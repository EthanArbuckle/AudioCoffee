//
//  NowPlayingViewController.m
//  iPlayr
//
//  Created by Ethan Arbuckle on 4/11/13.
//
//

#import "NowPlayingViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "MusicMatch.h"
#import "SongsTableViewController.h"
#import "CustomCell.h"
#import <AVFoundation/AVFoundation.h>
#import "AppDelegate.h"
#import "MarqueeLabel.h"
#import "DAAnisotropicImage.h"

@interface NowPlayingViewController ()

@end

BOOL isPlaying = YES;
int currentindex = 0;
NSMutableArray *songUrls;
const CGFloat kScrollObjHeight = 199.0;
const CGFloat kScrollObjWidth = 280.0;
const NSUInteger kNumPages = 2;
UIPageControl *pageControl;

@implementation NowPlayingViewController
@synthesize currentSong;
@synthesize songs;
@synthesize scrollView1;

- (void)viewWillAppear:(BOOL)animated {
}

- (void)viewDidLoad {
    pageControl = [[UIPageControl alloc] init];
    self.navigationItem.titleView = nil;
    self.navigationController.navigationItem.titleView = nil;
    appd = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    songUrls = [[NSMutableArray alloc] init];
    mediaItems = [[NSMutableArray alloc] init];
    for (MPMediaItem *item in songs) {
        [songUrls addObject:[item valueForProperty:MPMediaItemPropertyAssetURL]];
        [mediaItems addObject:item];
    }
    if (appd.repeatMode == 0) {
        [_repeat setImage:[UIImage imageNamed:@"repeat.png"] forState:UIControlStateNormal];
    } else if (appd.repeatMode == 1) {
        [_repeat setImage:[UIImage imageNamed:@"replay.png"] forState:UIControlStateNormal];
    } else {
        [_repeat setImage:[UIImage imageNamed:@"noreplay.png"] forState:UIControlStateNormal];
    }
    if (appd.isShuffle) {
        [_shuffle setImage:[UIImage imageNamed:@"shuffle_on"] forState:UIControlStateNormal];
    } else {
        [_shuffle setImage:[UIImage imageNamed:@"shuffle_off"] forState:UIControlStateNormal];
    }
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
    NSURL *firstSong = [currentSong valueForProperty:MPMediaItemPropertyAssetURL];
    //  appd.avPlayer.delegate = self;
    appd.avPlayer = [[AVAudioPlayer alloc] init];
    (void)[appd.avPlayer initWithContentsOfURL:firstSong error:nil];
    appd.avPlayer.delegate = self;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [appd.avPlayer play];
    MPVolumeView *volumeViewSlider = [[MPVolumeView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, 390, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.view addSubview:volumeViewSlider];
    [volumeViewSlider sizeToFit];
    currentindex = [songUrls indexOfObject:[currentSong valueForProperty:MPMediaItemPropertyAssetURL]];
    _songTitle.text = [currentSong valueForProperty:MPMediaItemPropertyTitle];
    _artistTitle.text = [currentSong valueForProperty:MPMediaItemPropertyArtist];
    _artworkImage.clipsToBounds = YES;
    _artworkImage.image = [self albumCover:currentSong];
    UITapGestureRecognizer *tapTwice = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backdouble:)];
    tapTwice.numberOfTapsRequired = 2;
    [_backfordb addGestureRecognizer:tapTwice];
    appd.isPlaying = YES;
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTime:) userInfo:nil repeats:YES];
    _duration.maximumValue = appd.avPlayer.duration;
    bar = [self.navigationController navigationBar];
    bar.tintColor = [UIColor blackColor];
    MarqueeLabel *label = [[MarqueeLabel alloc] initWithFrame:CGRectMake(80, 2, 220, 25)];
    label.text = [currentSong valueForProperty:MPMediaItemPropertyTitle];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    label.textColor = [UIColor lightGrayColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = label;
    [DAAnisotropicImage startAnisotropicUpdatesWithHandler:^(UIImage *image) {
        [_duration setThumbImage:image forState:UIControlStateNormal];
        /*   NSArray *tempArray = volumeViewSlider.subviews; //Adds reflective button to volume slider
           for (id current in tempArray) {
               if ([current isKindOfClass:[UISlider class]]) {
                   UISlider *tempSlider = (UISlider *)current;
                   [tempSlider setThumbImage:image forState:UIControlStateNormal];
               }
           } */
    }];
    /*  CGRect fullScreenRect = CGRectMake(50, 50, 200, 200);
       scrollView1 = [[UIScrollView alloc] initWithFrame:fullScreenRect];
       //scrollView1.contentSize = CGSizeMake(200 * kNumPages, 200);
       scrollView1.delegate = self;
       scrollView1.pagingEnabled = YES;
       scrollView1.showsHorizontalScrollIndicator = NO;
       scrollView1.showsVerticalScrollIndicator = NO;
       scrollView1.scrollsToTop = NO;
       pageControl.numberOfPages = kNumPages;
       pageControl.currentPage = 1; */
    //  [self loadScrollViewWithPage:1];
    //  scrollView1.contentSize = CGSizeMake(200, 200);
    // UIImageView *testImage = [[UIImageView alloc] initWithFrame:fullScreenRect];
    // [testImage setImage:[self albumCover:currentSong]];
    // [scrollView1 addSubview:testImage];
    // [self.view addSubview:scrollView1];
}

/*- (void)scrollViewDidScroll:(UIScrollView *)sender {
    CGFloat pageWidth = scrollView1.frame.size.width;
    int page = floor((scrollView1.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
   }

   - (void)loadScrollViewWithPage:(int)page {
    if (page < 0) return;
    if (page >= kNumPages) return;
        CGRect frame = scrollView1.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
    UIImageView *view = [[UIImageView alloc] initWithFrame:frame];
    [view setImage:[self albumCover:[mediaItems objectAtIndex:arc4random()%[songUrls count]]]];
    UIView *view2 = [[UIView alloc] init];
    view2.backgroundColor = [UIColor redColor];
        [scrollView1 addSubview:view2];
   }*/

- (UIImage *)albumCover:(MPMediaItem *)mediaItem {
    [self updateLockscreen];
    MPMediaItemArtwork *artwork = [mediaItem valueForProperty:MPMediaItemPropertyArtwork];
    UIImage *artworkImage = [artwork imageWithSize:CGSizeMake(171, 176)];
    if (artworkImage) {
        return artworkImage;
    } else {
        return nil;
    }
}

- (IBAction)pauseplay:(id)sender {
    if (isPlaying) {
        [appd.avPlayer pause];
        isPlaying = NO;
        [_playpau setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    } else {
        [appd.avPlayer play];
        isPlaying = YES;
        [_playpau setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
        appd.isPlaying = YES;
    }
}

- (IBAction)backdouble:(id)sender {
    [appd.avPlayer pause];
    if (currentindex == 0) {
        currentindex = [songUrls count] - 1;
    } else {
        currentindex--;
    }
    if (appd.isShuffle) {
        currentindex = arc4random() % [songUrls count];
    }
    (void)[appd.avPlayer initWithContentsOfURL:[songUrls objectAtIndex:currentindex] error:nil];
    [appd.avPlayer play];
    [self newSong];
}

- (IBAction)backbutton:(id)sender {
    if (appd.avPlayer.currentTime < 2.0f) {
        [self backdouble:nil];
        return;
    }
    [appd.avPlayer pause];
    (void)[appd.avPlayer initWithContentsOfURL:[songUrls objectAtIndex:currentindex] error:nil];
    [appd.avPlayer play];
    appd.avPlayer.delegate = self;
}

- (IBAction)forwardbutton:(id)sender {
    [appd.avPlayer pause];
    if (appd.isShuffle) {
        currentindex = arc4random() % [songUrls count];
    } else {
        currentindex++;
    }
    (void)[appd.avPlayer initWithContentsOfURL:[songUrls objectAtIndex:currentindex] error:nil];
    [appd.avPlayer play];
    [self newSong];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if (appd.repeatMode != 2) {
        [appd.avPlayer pause];
        if (appd.repeatMode != 1) {
            if (appd.isShuffle) {
                currentindex = arc4random() % [songUrls count];
            } else {
                currentindex++;
            }
        }
        (void)[appd.avPlayer initWithContentsOfURL:[songUrls objectAtIndex:currentindex] error:nil];
        [appd.avPlayer play];
        MPMediaItem *newSong = [mediaItems objectAtIndex:currentindex];
        _songTitle.text = [newSong valueForProperty:MPMediaItemPropertyTitle];
        _artistTitle.text = [newSong valueForProperty:MPMediaItemPropertyArtist];
        _artworkImage.image = [self albumCover:newSong];
        _duration.maximumValue = appd.avPlayer.duration;
        appd.isPlaying = YES;
        appd.avPlayer.delegate = self;
        MarqueeLabel *label = [[MarqueeLabel alloc] initWithFrame:CGRectMake(80, 2, 220, 25) rate:30 andFadeLength:10.0f];
        label.text = [newSong valueForProperty:MPMediaItemPropertyTitle];
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        label.textColor = [UIColor lightGrayColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        self.navigationItem.titleView = label;
    } else {
        appd.isPlaying = NO;
        [self pauseplay:nil];
    }
}

- (void)newSong {
    MPMediaItem *newSong = [mediaItems objectAtIndex:currentindex];
    _songTitle.text = [newSong valueForProperty:MPMediaItemPropertyTitle];
    _artistTitle.text = [newSong valueForProperty:MPMediaItemPropertyArtist];
    _artworkImage.image = [self albumCover:newSong];
    _duration.maximumValue = appd.avPlayer.duration;
    appd.isPlaying = YES;
    appd.avPlayer.delegate = self;
    MarqueeLabel *label = [[MarqueeLabel alloc] initWithFrame:CGRectMake(80, 2, 220, 25) rate:30 andFadeLength:10.0f];
    label.text = [newSong valueForProperty:MPMediaItemPropertyTitle];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    label.textColor = [UIColor lightGrayColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = label;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    if (event.type == UIEventTypeRemoteControl) {
        if (event.subtype == UIEventSubtypeRemoteControlTogglePlayPause) {
            [self pauseplay:nil];
        } else if (event.subtype == UIEventSubtypeRemoteControlNextTrack) {
            [self forwardbutton:nil];
        } else {
            [self backdouble:nil];
        }
    }
}

- (void)updateLockscreen {
    Class playingInfoCenter = NSClassFromString(@"MPNowPlayingInfoCenter");
    if (playingInfoCenter) {
        MPMediaItem *currentlyplaying = [mediaItems objectAtIndex:currentindex];
        NSString *songTitle = [NSString stringWithFormat:@"%@ | %d minutes", [currentlyplaying valueForProperty:MPMediaItemPropertyTitle], [[currentlyplaying valueForProperty:MPMediaItemPropertyPlaybackDuration] intValue] / 60];
        NSString *albumTitle = [currentlyplaying valueForProperty:MPMediaItemPropertyAlbumTitle];
        NSString *artistTitle = [currentlyplaying valueForProperty:MPMediaItemPropertyArtist];
        MPNowPlayingInfoCenter *center = [MPNowPlayingInfoCenter defaultCenter];
        center.nowPlayingInfo = nil;
        NSDictionary *songInfo = [NSDictionary dictionaryWithObjectsAndKeys:artistTitle, MPMediaItemPropertyArtist, songTitle, MPMediaItemPropertyTitle, albumTitle, MPMediaItemPropertyAlbumTitle, [currentlyplaying valueForProperty:MPMediaItemPropertyArtwork], MPMediaItemPropertyArtwork, nil];
        center.nowPlayingInfo = songInfo;
    }
}

- (void)updateTime:(NSTimer *)timer {
    appd.currentPlaying = (NSInteger *)currentindex;
    _duration.value = appd.avPlayer.currentTime;
    _sofar.text = [self formatTime:(int)appd.avPlayer.currentTime];
    int dur = appd.avPlayer.duration;
    int cur = appd.avPlayer.currentTime;
    _left.text = [self formatTime:dur - cur];
}

- (IBAction)scrubber:(id)sender {
    appd.avPlayer.currentTime = _duration.value;
}

- (NSString *)formatTime:(int)seconds {
    if (seconds <= 0) return @"00:00";
    int h = seconds / 3600;
    int m = (seconds % 3600) / 60;
    int s = seconds % 60;
    if (h) return [NSString stringWithFormat:@"%02i:%02i:%02i", h, m, s];
    else return [NSString stringWithFormat:@"%02i:%02i", m, s];
}

- (IBAction)shufflePressed:(id)sender {
    if (appd.isShuffle) {
        appd.isShuffle = NO;
        [_shuffle setImage:[UIImage imageNamed:@"shuffle_off"] forState:UIControlStateNormal];
    } else {
        appd.isShuffle = YES;
        [_shuffle setImage:[UIImage imageNamed:@"shuffle_on"] forState:UIControlStateNormal];
    }
}

- (IBAction)repeatPressed:(id)sender {
    if (appd.repeatMode == 0) {
        appd.repeatMode = 1;
        [_repeat setImage:[UIImage imageNamed:@"replay.png"] forState:UIControlStateNormal];
    } else if (appd.repeatMode == 1) {
        appd.repeatMode = 2;
        [_repeat setImage:[UIImage imageNamed:@"noreplay.png"] forState:UIControlStateNormal];
    } else {
        appd.repeatMode = 0;
        [_repeat setImage:[UIImage imageNamed:@"repeat.png"] forState:UIControlStateNormal];
    }
}

@end
