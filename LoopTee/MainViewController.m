//
//  LoopTeeViewController.m
//  LoopTee
//
//  Created by Cameron Briar on 3/8/11.
//  Copyright 2011 CSU Fresno. All rights reserved.
//

#import "MainViewController.h"
#import <Foundation/Foundation.h>
#import <iAd/iAd.h>
#define KILL_TIMER(t)   if (t) { [t invalidate]; t=nil; }

@implementation MainViewController
@synthesize label1, label2, label3, label4, noartwork, time1, onoff, looplabel, backgroundColorTimer, userMediaItemCollection, artwork, volumeslider, nowplaying;

int lcount = 0, scount = 0, loopcount = 1, bcount = 0, onOFF = 0, shuffle = 0; 
float backt = 4.0;
NSTimeInterval currentPlaybackTime1;
NSTimeInterval currentPlaybackTime2;


/*
 // The designated initializer. Override to perform setup that is required before the view is loaded.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
 if (self) {
 // Custom initialization
 }
 return self;
 }
 */

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 }
 */



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
    // Override point for customization after application launch.
    // instantiate a music player
	
	MPMusicPlayerController *myPlayer =
    [MPMusicPlayerController applicationMusicPlayer];
    
    //if ([self useiPodPlayer]) {
        
	//	[self setMusicPlayer: [MPMusicPlayerController myPlayer]];
    //}
	// assign a playback queue containing all media items on the device
	[myPlayer setQueueWithQuery: [MPMediaQuery songsQuery]];
	
	// start playing from the beginning of the queue
	[myPlayer play];
	ADBannerView *adView = [[ADBannerView alloc] initWithFrame:CGRectZero];
	adView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
	[self.view addSubview:adView];
    
	//volumeslider.value = myPlayer.volume;
	
	[NSTimer scheduledTimerWithTimeInterval:1.0f
									 target:self
								   selector:@selector(updatetime:)
								   userInfo:nil
									repeats:YES];
	noartwork = [UIImage imageNamed:@"no_artwork.png"];
	[self updatetext];
	[self wallpaperonoroff];
    [super viewDidLoad];
}
- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    NSLog(@"Banner view is beginning an ad action");
    BOOL shouldExecuteAction = [self allowActionToRun]; // your application implements this method
    if (!willLeave && shouldExecuteAction)
    {
        // insert code here to suspend any services that might conflict with the advertisement
    }
    return shouldExecuteAction;
}
-(void)wallpaperonoroff {
	if (onOFF % 3 == 0)
	{
		time1 = [NSTimer scheduledTimerWithTimeInterval: 3.5
												 target: self
											   selector: @selector (updateBackgroundColor)
											   userInfo: nil
												repeats: YES];
		[self setBackgroundColorTimer:time1];
		/*[self setBackgroundColorTimer: [NSTimer scheduledTimerWithTimeInterval: 3.5
		 target: self
		 selector: @selector (updateBackgroundColor)
		 userInfo: nil
		 repeats: YES]];*/
		onoff.text = @"on";
	} else if (onOFF % 3 == 1) {
		self.view.backgroundColor = [UIColor whiteColor]; onoff.text = @"off"; KILL_TIMER(time1);
	} else if (onOFF % 3 == 2) {
		self.view.backgroundColor = [UIColor grayColor]; onoff.text = @"off"; KILL_TIMER(time1);
	}
}			   
-(IBAction)backgroundcolor:(id)sender {
	onOFF += 1;
	[self wallpaperonoroff];
}
-(void)updatetext {
	MPMusicPlayerController *myPlayer =
    [MPMusicPlayerController applicationMusicPlayer];
	MPMediaItem *currentItem = [myPlayer nowPlayingItem];
	[nowplaying setText: [
						  NSString stringWithFormat: @"%@ %@ %@ %@",
						  NSLocalizedString (@"Now Playing:", @"Label for introducing the now-playing song title and artist"),
						  [currentItem valueForProperty: MPMediaItemPropertyTitle],
						  NSLocalizedString (@"by", @"Article between song name and artist name"),
						  [currentItem valueForProperty: MPMediaItemPropertyArtist]]];
	MPMediaItemArtwork *artworkfrompod = [currentItem valueForProperty: MPMediaItemPropertyArtwork];
	UIImage *album = [artworkfrompod imageWithSize: CGSizeMake (110, 110)];
	artwork.image = noartwork;
	if (album) artwork.image = album;
}
-(void)updatetime:(NSTimer *)timer {
	MPMusicPlayerController *myPlayer =
    [MPMusicPlayerController applicationMusicPlayer];
	int seconds = myPlayer.currentPlaybackTime;
	if (seconds < 1.0) [self updatetext];
	int minutes = seconds/60;
	seconds -= minutes * 60;
	NSString *timing = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
	label3.text = timing;
}
-(IBAction)incloop:(id)sender {
	if (loopcount < 10)
		loopcount += 1;
	NSString *looptext = [NSString stringWithFormat:@"%d", loopcount];
	looplabel.text = looptext;
}
-(IBAction)decloop:(id)sender {
	if (loopcount > 1)
		loopcount -= 1;
	NSString *looptext = [NSString stringWithFormat:@"%d", loopcount];
	looplabel.text = looptext;
}
-(IBAction)loop:(id)sender {
	MPMusicPlayerController *myPlayer =
	[MPMusicPlayerController applicationMusicPlayer];
	if (lcount % 2 == 0) {
		currentPlaybackTime1 = myPlayer.currentPlaybackTime;
		int seconds = currentPlaybackTime1;
		int minutes = seconds/60;
		seconds -= minutes * 60;
		NSString *time11 = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
		label1.text = time11;
	}
	if (lcount % 2 == 1)
	{	currentPlaybackTime2 = myPlayer.currentPlaybackTime;
		int seconds = currentPlaybackTime2;
		int minutes = seconds/60;
		seconds -= minutes * 60;
		NSString *time2 = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
		label2.text = time2;
		int i = 0;
		while (currentPlaybackTime2 > currentPlaybackTime1)
		{
			myPlayer.currentPlaybackTime = currentPlaybackTime1;
			NSTimeInterval looper = currentPlaybackTime1;
			while (looper <= currentPlaybackTime2)
			{
				looper = myPlayer.currentPlaybackTime;
			}
			i++;
			if (i >= loopcount) currentPlaybackTime1 = (looper + 0.0001);
		}
	}
	
	lcount += 1;
	
}
-(IBAction)backfive:(id)sender{
	MPMusicPlayerController *myPlayer =
	[MPMusicPlayerController applicationMusicPlayer];
	if (myPlayer.currentPlaybackTime > (backt + .02))
		myPlayer.currentPlaybackTime = myPlayer.currentPlaybackTime - backt;
}
-(IBAction)next:(id)sender {
	MPMusicPlayerController *myPlayer =
	[MPMusicPlayerController applicationMusicPlayer];
	[myPlayer skipToNextItem];
	[self updatetext];
	label1.text = nil;
	label2.text = nil;
}
-(IBAction)previous:(id)sender {
	MPMusicPlayerController *myPlayer =
	[MPMusicPlayerController applicationMusicPlayer];
	[myPlayer skipToPreviousItem];
	[self updatetext];
	label1.text = nil;
	label2.text = nil;
}

-(IBAction)play:(id)sender {
	MPMusicPlayerController *myPlayer = [MPMusicPlayerController applicationMusicPlayer];
	MPMusicPlaybackState playbackState = [myPlayer playbackState];
	
	if (playbackState == MPMusicPlaybackStateStopped || playbackState == MPMusicPlaybackStatePaused) {
		[myPlayer play];
	} else if (playbackState == MPMusicPlaybackStatePlaying) {
		[myPlayer pause];
	}
}
- (IBAction)volumeadjusted:(UISlider *)sender
{
	MPMusicPlayerController *myPlayer = [MPMusicPlayerController applicationMusicPlayer];
	myPlayer.volume = [sender value];
}
-(IBAction)backtrack:(id)sender {
	int t = bcount % 4;
	switch (t) {
		case 0:
			label4.text = @"-2s";
			backt = 2.0;
			bcount += 1;
			break;
		case 1:
			label4.text = @"-4s";
			backt = 4.0;
			bcount += 1;
			break;
		case 2:
			label4.text = @"-8s";
			backt = 8.0;
			bcount += 1;
			break;
		case 3:
			label4.text = @"-10s";
			backt = 10.0;
			bcount += 1;
			break;
		default:
			label4.text = @"-4s";
			backt = 4.0;
			break;
	}
}

-(IBAction)shufflesongs:(id)sender {
	MPMusicPlayerController *myPlayer = [MPMusicPlayerController applicationMusicPlayer];
	if (shuffle % 2 == 0) {
        [myPlayer setShuffleMode:MPMusicShuffleModeDefault];
	} else {
		[myPlayer setShuffleMode:MPMusicShuffleModeOff];
	}
}

- (IBAction)addmusic: (id) sender {    
	// if the user has already chosen some music, display that list
	if (userMediaItemCollection) {
		
		MusicTableViewController *controller = [[MusicTableViewController alloc] initWithNibName: @"MusicTableView" bundle: nil];
		controller.delegate = self;
		
		controller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
		
		[self presentModalViewController: controller animated: YES];
		[controller release];
		
		// else, if no music is chosen yet, display the media item picker
	} else {
		
		MPMediaPickerController *picker =
		[[MPMediaPickerController alloc] initWithMediaTypes: MPMediaTypeMusic];
		
		picker.delegate						= self;
		picker.allowsPickingMultipleItems	= YES;
		picker.prompt						= NSLocalizedString (@"Add songs to play", "Prompt in media item picker");
		
		// The media item picker uses the default UI style, so it needs a default-style
		//		status bar to match it visually
		[[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleDefault animated: YES];
		
		[self presentModalViewController: picker animated: YES];
		[picker release];
	}
}
- (void) updateBackgroundColor {
	
	[UIView beginAnimations: nil context: nil];
    [UIView setAnimationDuration: 3.0];
	
	CGFloat redLevel	= rand() / (float) RAND_MAX;
	CGFloat greenLevel	= rand() / (float) RAND_MAX;
	CGFloat blueLevel	= rand() / (float) RAND_MAX;
	
	self.view.backgroundColor = [UIColor colorWithRed: redLevel
												green: greenLevel
												 blue: blueLevel
												alpha: 1.0];
	[UIView commitAnimations];
}
- (void) updatePlayerQueueWithMediaCollection: (MPMediaItemCollection *) mediaItemCollection {
	MPMusicPlayerController *myPlayer = [MPMusicPlayerController applicationMusicPlayer];
	
	if (mediaItemCollection) {
		
		if (userMediaItemCollection == nil) {
			
			[self setUserMediaItemCollection: mediaItemCollection];
			[myPlayer setQueueWithItemCollection: userMediaItemCollection];
			[myPlayer play];
			
			// Obtain the music player's state so it can then be
			//		restored after updating the playback queue.
		} else {
			
			MPMediaItem *nowPlayingItem			= myPlayer.nowPlayingItem;
			NSTimeInterval currentPlaybackTime	= myPlayer.currentPlaybackTime;
			
			// Combine the previously-existing media item collection with the new one
			NSMutableArray *combinedMediaItems	= [[userMediaItemCollection items] mutableCopy];
			NSArray *newMediaItems				= [mediaItemCollection items];
			[combinedMediaItems addObjectsFromArray: newMediaItems];
			
			[self setUserMediaItemCollection: [MPMediaItemCollection collectionWithItems: (NSArray *) combinedMediaItems]];
			[combinedMediaItems release];
			
			// Apply the new media item collection as a playback queue for the music player.
			[myPlayer setQueueWithItemCollection: userMediaItemCollection];
			
			// Restore the now-playing item and its current playback time.
			myPlayer.nowPlayingItem	= nowPlayingItem;
			myPlayer.currentPlaybackTime = currentPlaybackTime;
			
			[myPlayer play];
			[self updatetext];
			
		}
	}
}

// Invoked when the user taps the Done button in the media item picker after having chosen
//		one or more media items to play.
- (void) mediaPicker: (MPMediaPickerController *) mediaPicker didPickMediaItems: (MPMediaItemCollection *) mediaItemCollection {
	
	// Dismiss the media item picker.
	[self dismissModalViewControllerAnimated: YES];
	// Apply the chosen songs to the music player's queue.
	[self updatePlayerQueueWithMediaCollection: mediaItemCollection];
	
	[[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleBlackOpaque animated: YES];
}
- (BOOL) useiPodPlayer {
    
	if ([[NSUserDefaults standardUserDefaults] boolForKey: PLAYER_TYPE_PREF_KEY]) {
		return YES;		
	} else {
		return NO;
	}		
}

// Invoked when the user taps the Done button in the media item picker having chosen zero
//		media items to play
- (void) mediaPickerDidCancel: (MPMediaPickerController *) mediaPicker {
	
	[self dismissModalViewControllerAnimated: YES];
	
	[[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleBlackOpaque animated: YES];
}

// Invoked when the user taps the Done button in the table view.
- (void) musicTableViewControllerDidFinish: (MusicTableViewController *) controller {
	
	[self dismissModalViewControllerAnimated: YES];
}

/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	
	[artwork release];
	[label1 release];
	[label2 release];
	[label3 release];
	[looplabel release];
	[nowplaying release];
	[userMediaItemCollection release];
    [super dealloc];
}

@end