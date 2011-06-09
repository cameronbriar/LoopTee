#import "MusicTableViewController.h"
#import "MainViewController.h"

@implementation MusicTableViewController

static NSString *kCellIdentifier = @"Cell";

@synthesize delegate;					
@synthesize mediaItemCollectionTable;	
@synthesize addMusicButton;				

- (void) viewDidLoad {

    [super viewDidLoad];
	
	[self.addMusicButton setTitle: NSLocalizedString (@"AddMusicFromTableView", @"Add button shown on table view for invoking the media item picker")];
	
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];      
}


- (IBAction)doneShowingMusicList:(id) sender {

	[self.delegate musicTableViewControllerDidFinish: self];	
}

- (IBAction) showMediaPicker: (id) sender {

	MPMediaPickerController *picker =
		[[MPMediaPickerController alloc] initWithMediaTypes: MPMediaTypeAnyAudio];
	
	picker.delegate						= self;
	picker.allowsPickingMultipleItems	= YES;
	picker.prompt						= NSLocalizedString (@"AddSongsPrompt", @"Prompt to user to choose some songs to play");
	
	[[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleDefault animated:YES];

	[self presentModalViewController: picker animated: YES];
	[picker release];
}

- (void) mediaPicker: (MPMediaPickerController *) mediaPicker didPickMediaItems: (MPMediaItemCollection *) mediaItemCollection {
  
	[self dismissModalViewControllerAnimated: YES];
	[self.delegate updatePlayerQueueWithMediaCollection: mediaItemCollection];
	[self.mediaItemCollectionTable reloadData];

	[[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleBlackOpaque animated:YES];
}

- (void) mediaPickerDidCancel: (MPMediaPickerController *) mediaPicker {

	[self dismissModalViewControllerAnimated: YES];

	[[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleBlackOpaque animated:YES];
}

#pragma mark Table view methods________________________
- (NSInteger) tableView: (UITableView *) table numberOfRowsInSection: (NSInteger)section {

	MainViewController *mainViewController = (MainViewController *) self.delegate;
	MPMediaItemCollection *currentQueue = mainViewController.userMediaItemCollection;
	return [currentQueue.items count];
}

- (UITableViewCell *) tableView: (UITableView *) tableView cellForRowAtIndexPath: (NSIndexPath *) indexPath {

	NSInteger row = [indexPath row];
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: kCellIdentifier];
	
	if (cell == nil) {
	
		cell = [[[UITableViewCell alloc] initWithFrame: CGRectZero 
									   reuseIdentifier: kCellIdentifier] autorelease];
	}
	
	MainViewController *mainViewController = (MainViewController *) self.delegate;
	MPMediaItemCollection *currentQueue = mainViewController.userMediaItemCollection;
	MPMediaItem *anItem = (MPMediaItem *)[currentQueue.items objectAtIndex: row];
	
	if (anItem) {
		cell.textLabel.text = [anItem valueForProperty:MPMediaItemPropertyTitle];
	}

	[tableView deselectRowAtIndexPath: indexPath animated: YES];
	
	return cell;
}

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {

	[tableView deselectRowAtIndexPath: indexPath animated: YES];
}

#pragma mark Application state management_____________
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

    [super dealloc];
}


@end
