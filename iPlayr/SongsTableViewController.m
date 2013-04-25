//
//  SongsTableViewController.m
//  iPlayr
//
//  Created by Ethan Arbuckle on 4/11/13.
//
//

#import "SongsTableViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "CustomCell.h"
#import "NowPlayingViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"

@interface SongsTableViewController ()

@end
int tag = 0;
@implementation SongsTableViewController
@synthesize songsTableView, bottomTabs;

- (void)viewDidLoad {
    [super viewDidLoad];
    appd = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    songsArray = [[NSMutableArray alloc] init];
    albumsArray = [[NSMutableArray alloc] init];
    artistsArray = [[NSMutableArray alloc] init];
    songEntity = [[NSMutableArray alloc] init];
    musicController = [MPMusicPlayerController applicationMusicPlayer];
    [self setArrays];
    songsTableView.delegate = self;
    songsTableView.dataSource = self;
    bottomTabs.delegate = self;
    UITabBarItem *firstItem = [[UITabBarItem alloc] initWithTitle:@"Playlists" image:nil tag:0];
    UITabBarItem *secondItem = [[UITabBarItem alloc] initWithTitle:@"Artists" image:nil tag:1];
    UITabBarItem *third = [[UITabBarItem alloc] initWithTitle:@"Songs" image:nil tag:2];
    UITabBarItem *fourth = [[UITabBarItem alloc] initWithTitle:@"Albums" image:nil tag:3];
    NSArray *itemsArray = [NSArray arrayWithObjects:firstItem, secondItem, third, fourth, nil];
    UINavigationBar *bar = [self.navigationController navigationBar];
    bar.tintColor = [UIColor blackColor];
    [bottomTabs setItems:itemsArray animated:YES];
    [self addFooter];
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(checkPlaying) userInfo:nil repeats:YES];
}

- (void)setArrays {
    MPMediaQuery *query = [[MPMediaQuery alloc] init];
    [query setGroupingType:MPMediaGroupingTitle];
    NSArray *albums = [query collections];
    for (MPMediaItemCollection *album in albums) {
        NSArray *songs = [album items];
        for (MPMediaItem *song in songs) {
            NSString *songTitle = [song valueForProperty:MPMediaItemPropertyTitle];
            NSString *artistTitles = [song valueForProperty:MPMediaItemPropertyArtist];
            NSString *album = [song valueForProperty:MPMediaItemPropertyAlbumTitle];
            [artistsArray addObject:artistTitles];
            [songsArray addObject:songTitle];
            [songEntity addObject:song];
            [albumsArray addObject:album];
        }
    }
}

- (void)addFooter {
    UIView *tfooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, songsTableView.frame.size.width, 45)];
    tfooterView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(songsTableView.frame.size.width / 2 - 120, 0, 240, 35)];
    label3.backgroundColor = [UIColor clearColor];
    label3.font = [UIFont systemFontOfSize:12];
    label3.numberOfLines = 2;
    label3.lineBreakMode = NSLineBreakByWordWrapping;
    label3.textAlignment = NSTextAlignmentCenter;
    if (([songsArray count] > 1) || ([songsArray count] < 1)) {
        label3.text = [NSString stringWithFormat:@"%d Songs", [songsArray count]];
    } else {
        label3.text = [NSString stringWithFormat:@"%d Song", [songsArray count]];
    }
    label3.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
    [tfooterView addSubview:label3];
    songsTableView.tableFooterView = tfooterView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [songsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"CustomCell";
    CustomCell *cell = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    NSString *time = [[songEntity objectAtIndex:indexPath.row] valueForProperty:MPMediaItemPropertyPlaybackDuration];
    NSMutableString *textForSong = [[NSMutableString alloc] init];
    NSMutableString *textForAlbum = [[NSMutableString alloc] init];
    if (tag == 1) {
        textForSong = [artistsArray objectAtIndex:indexPath.row];
        textForAlbum = [songsArray objectAtIndex:indexPath.row];
    } else if (tag == 3) {
        textForSong = [albumsArray objectAtIndex:indexPath.row];
        textForAlbum = [songsArray objectAtIndex:indexPath.row];
    } else {
        textForSong = [songsArray objectAtIndex:indexPath.row];
        textForAlbum = [artistsArray objectAtIndex:indexPath.row];
    }
    cell.artistLabel.text = [NSString stringWithFormat:@"%@ | %d minutes", textForAlbum, [time intValue] / 60];
    cell.songLabel.text = textForSong;
    cell.albumArt.image = [self albumCover:[songEntity objectAtIndex:indexPath.row]];
    if ([cell.songLabel.text rangeOfString:[NSString stringWithFormat:@"%@", lastplayingtitle]].location != NSNotFound) {
        [cell.nowPlaying setHidden:NO];
    } else {
        [cell.nowPlaying setHidden:YES];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomCell *tappedcell = (CustomCell *)[songsTableView cellForRowAtIndexPath:indexPath];
    [songsTableView deselectRowAtIndexPath:indexPath animated:YES];
    if (!tappedcell.nowPlaying.isHidden) {
        [self.navigationController pushViewController:viewControllerForward animated:YES];
    } else {
        [lastPlaying.nowPlaying setHidden:YES];
        viewControllerForward = [self.storyboard instantiateViewControllerWithIdentifier:@"NowPlaying"];
        [viewControllerForward setCurrentSong:[songEntity objectAtIndex:indexPath.row]];
        [viewControllerForward setSongs:songEntity];
        [self.navigationController pushViewController:viewControllerForward animated:YES];
        lastPlaying = (CustomCell *)[songsTableView cellForRowAtIndexPath:indexPath];
        [lastPlaying.nowPlaying setHidden:NO];
        lastplayingtitle = [NSMutableString stringWithFormat:@"%@", lastPlaying.songLabel.text];
    }
}

- (UIImage *)albumCover:(MPMediaItem *)mediaItem {
    MPMediaItemArtwork *artwork = [mediaItem valueForProperty:MPMediaItemPropertyArtwork];
    UIImage *artworkImage = [artwork imageWithSize:CGSizeMake(25, 25)];
    if (artworkImage) {
        return artworkImage;
    } else {
        return nil;
    }
}

- (void)checkPlaying {
    if (viewControllerForward) {
        UIBarButtonItem *forward = [[self class] createSquareBarButtonItemWithTitle:@"Now Playing" target:self action:@selector(NowPlayingPush)];
        self.navigationItem.rightBarButtonItem = forward;
    } else {
        self.navigationItem.rightBarButtonItem = nil;
    }
    NSIndexPath *path = [NSIndexPath indexPathForRow:(int)appd.currentPlaying inSection:0];
    CustomCell *cell = (CustomCell *)[songsTableView cellForRowAtIndexPath:path];
    if (appd.isPlaying) {
        lastplayingtitle = [songsArray objectAtIndex:(int)appd.currentPlaying];
        [self removeAllPlayingIcons];
        [cell.nowPlaying setHidden:NO];
    } else {
        [cell.nowPlaying setHidden:YES];
    }
}

- (void)NowPlayingPush {
    [self.navigationController pushViewController:viewControllerForward animated:YES];
}

- (void)removeAllPlayingIcons {
    for (CustomCell *cell in self.songsTableView.visibleCells) {
        [cell.nowPlaying setHidden:YES];
    }
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    [self removeAllPlayingIcons];
    MPMediaQuery *query = [[MPMediaQuery alloc] init];
    if (item.tag == 1) {
        tag = 1;
        [query setGroupingType:MPMediaGroupingArtist];
    } else if (item.tag == 2) {
        tag = 2;
        [query setGroupingType:MPMediaGroupingTitle];
    } else if (item.tag == 3) {
        tag = 3;
        [query setGroupingType:MPMediaGroupingAlbum];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not Implemented" message:@"Playlists are not ready and have been disabled. Sorry!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        [query setGroupingType:MPMediaGroupingTitle];
    }
    [artistsArray removeAllObjects];
    [songsArray removeAllObjects];
    [albumsArray removeAllObjects];
    [songEntity removeAllObjects];
    NSArray *albums = [query collections];
    for (MPMediaItemCollection *album in albums) {
        NSArray *songs = [album items];
        for (MPMediaItem *song in songs) {
            NSString *songTitle = [song valueForProperty:MPMediaItemPropertyTitle];
            NSString *artistTitles = [song valueForProperty:MPMediaItemPropertyArtist];
            NSString *album = [song valueForProperty:MPMediaItemPropertyAlbumTitle];
            [artistsArray addObject:artistTitles];
            [songsArray addObject:songTitle];
            [songEntity addObject:song];
            [albumsArray addObject:album];
        }
    }
    [self.songsTableView reloadData];
}

+ (UIBarButtonItem *)createSquareBarButtonItemWithTitle:(NSString *)t target:(id)tgt action:(SEL)a {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *buttonImage = [[UIImage imageNamed:@"forward.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:0];
    [[button titleLabel] setFont:[UIFont boldSystemFontOfSize:12.0]];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [button setTitleShadowColor:[UIColor colorWithWhite:1.0 alpha:0.7] forState:UIControlStateNormal];
    [button setTitleShadowColor:[UIColor clearColor] forState:UIControlStateHighlighted];
    [[button titleLabel] setShadowOffset:CGSizeMake(0.0, 1.0)];
    CGRect buttonFrame = [button frame];
    buttonFrame.size.width = [t sizeWithFont:[UIFont boldSystemFontOfSize:12.0]].width + 24.0;
    buttonFrame.size.height = buttonImage.size.height;
    [button setFrame:buttonFrame];
    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [button setTitle:t forState:UIControlStateNormal];
    [button addTarget:tgt action:a forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    return buttonItem;
}

@end
