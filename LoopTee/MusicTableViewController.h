#import <MediaPlayer/MediaPlayer.h>

@protocol MusicTableViewControllerDelegate;


@interface MusicTableViewController : UIViewController <MPMediaPickerControllerDelegate, UITableViewDelegate> {

	id <MusicTableViewControllerDelegate>	delegate;
	IBOutlet UITableView					*mediaItemCollectionTable;
	IBOutlet UIBarButtonItem				*addMusicButton;
}

@property (nonatomic, assign) id <MusicTableViewControllerDelegate>	delegate;
@property (nonatomic, retain) UITableView							*mediaItemCollectionTable;
@property (nonatomic, retain) UIBarButtonItem						*addMusicButton;

- (IBAction) showMediaPicker: (id) sender;
- (IBAction) doneShowingMusicList: (id) sender;

@end


@protocol MusicTableViewControllerDelegate

- (void) musicTableViewControllerDidFinish: (MusicTableViewController *) controller;
- (void) updatePlayerQueueWithMediaCollection: (MPMediaItemCollection *) mediaItemCollection;

@end

