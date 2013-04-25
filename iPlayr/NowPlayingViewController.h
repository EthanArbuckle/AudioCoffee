//
//  NowPlayingViewController.h
//  iPlayr
//
//  Created by Ethan Arbuckle on 4/11/13.
//
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "AppDelegate.h"

@interface NowPlayingViewController : UIViewController <AVAudioPlayerDelegate, UIScrollViewDelegate> {
    AppDelegate *appd;
    NSMutableArray *mediaItems;
    UINavigationBar *bar;
}

- (UIImage*)albumCover:(MPMediaItem*)mediaItem;
- (NSString *)formatTime:(int)seconds;
- (void)newSong;
- (void)updateLockscreen;
//- (void)loadScrollViewWithPage:(int)page;
- (IBAction)pauseplay:(id)sender;
- (IBAction)forwardbutton:(id)sender;
- (IBAction)backbutton:(id)sender;
- (IBAction)backdouble:(id)sender;
- (IBAction)scrubber:(id)sender;
- (IBAction)shufflePressed:(id)sender;
- (IBAction)repeatPressed:(id)sender;

@property MPMediaItem *currentSong;
@property NSMutableArray *songs;
@property IBOutlet UIImageView *artworkImage;
@property IBOutlet UILabel *songTitle;
@property IBOutlet UILabel *artistTitle;
@property IBOutlet UIButton *backfordb;
@property IBOutlet UIButton *playpau;
@property IBOutlet UIScrollView *scrollView1;
@property IBOutlet UISlider *duration;
@property IBOutlet UILabel *sofar;
@property IBOutlet UILabel *left;
@property IBOutlet UIButton *shuffle;
@property IBOutlet UIButton *repeat;

@end
