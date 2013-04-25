//
//  SongsTableViewController.h
//  iPlayr
//
//  Created by Ethan Arbuckle on 4/11/13.
//
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "CustomCell.h"  
#import "NowPlayingViewController.h"
#import "AppDelegate.h"

@interface SongsTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITabBarDelegate> {
    NSMutableArray *songsArray;
    NSMutableArray *albumsArray;
    NSMutableArray *artistsArray;
    NSMutableArray *songEntity;
    NSArray *alphabet;
    MPMusicPlayerController *musicController;
    CustomCell *lastPlaying;
    NSMutableString *lastplayingtitle;
    NowPlayingViewController *viewControllerForward;
    AppDelegate *appd;
}

@property IBOutlet UITableView *songsTableView;
@property IBOutlet UITabBar *bottomTabs;

- (void)setArrays;
- (void)addFooter;
- (void)removeAllPlayingIcons;
- (UIImage *)albumCover:(MPMediaItem *)mediaItem;
+ (UIBarButtonItem *)createSquareBarButtonItemWithTitle:(NSString *)t target:(id)tgt action:(SEL)a;

@end
