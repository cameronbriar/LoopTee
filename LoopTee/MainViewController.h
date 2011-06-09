//
//  MainViewController.h
//  LoopTee
//
//  Created by Cameron Briar on 5/31/11.
//  Copyright 2011 CSU Fresno. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "MusicTableViewController.h"
#import "LoopTeeAppDelegate.h"

#define PLAYER_TYPE_PREF_KEY @"player_type_preference"
#define AUDIO_TYPE_PREF_KEY @"audio_technology_preference"

@interface MainViewController : UIViewController <MPMediaPickerControllerDelegate, MusicTableViewControllerDelegate> {
	LoopTeeAppDelegate	*applicationDelegate;
	IBOutlet UILabel *label1;
	IBOutlet UILabel *label2;
	IBOutlet UILabel *label3;
	IBOutlet UILabel *label4;
	IBOutlet UILabel *onoff;
	IBOutlet UILabel *looplabel;
	IBOutlet UILabel *nowplaying;
	IBOutlet UIImageView *artwork;
	IBOutlet UISlider *volumeslider;
	MPMediaItemCollection *userMediaItemCollection;
	NSTimer *backgroundColorTimer;
	NSTimer *time1;
	UIImage *noartwork;
	
}
-(IBAction)incloop:(id)sender;
-(IBAction)decloop:(id)sender;
-(IBAction)loop:(id)sender;
-(IBAction)next:(id)sender;
-(IBAction)previous:(id)sender;
-(IBAction)backfive:(id)sender;
-(IBAction)play:(id)sender;
-(IBAction)volumeadjusted:(id)sender;
-(IBAction)addmusic:(id)sender;
-(IBAction)backtrack:(id)sender;
-(IBAction)backgroundcolor:(id)sender;
-(IBAction)shufflesongs:(id)sender;
@property (nonatomic, retain) MPMediaItemCollection	*userMediaItemCollection;
@property (nonatomic, retain) IBOutlet UILabel *label1;
@property (nonatomic, retain) IBOutlet UILabel *label2;
@property (nonatomic, retain) IBOutlet UILabel *label3;
@property (nonatomic, retain) IBOutlet UILabel *label4;
@property (nonatomic, retain) IBOutlet UILabel *onoff;
@property (nonatomic, retain) IBOutlet UILabel *looplabel;
@property (nonatomic, retain) IBOutlet UILabel *nowplaying;
@property (nonatomic, retain) IBOutlet UIImageView *artwork;
@property (nonatomic, retain) IBOutlet UISlider *volumeslider;
@property (nonatomic, retain) NSTimer *backgroundColorTimer;
@property (nonatomic, retain) NSTimer *time1;
@property (nonatomic, retain) UIImage *noartwork;
- (BOOL) useiPodPlayer;

@end