//
//  AppDelegate.m
//  iPlayr
//
//  Created by Ethan Arbuckle on 4/10/13.
//
//

#import "AppDelegate.h"
#import "SHSidebarController.h"

@implementation AppDelegate
@synthesize avPlayer;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.isPlaying = NO;
    self.isShuffle = NO;
    self.repeatMode = 0;
   // avPlayer = [[AVAudioPlayer alloc] init];
    NSMutableArray *vcs = [NSMutableArray array];
    UIViewController *localmusic = [[UIStoryboard storyboardWithName:@"localMusicViews" bundle:nil] instantiateViewControllerWithIdentifier:@"localMusicTable"];
    UIViewController *lastfm = [[UIStoryboard storyboardWithName:@"lastfmViews" bundle:nil] instantiateViewControllerWithIdentifier:@"lastfmLogin"];
    UIViewController *settings = [[UIStoryboard storyboardWithName:@"Settingsboard" bundle:nil] instantiateViewControllerWithIdentifier:@"settingsMain"];
    UINavigationController *localmusicnav = [[UINavigationController alloc] initWithRootViewController:localmusic];
    UINavigationController *lastfmnav = [[UINavigationController alloc] initWithRootViewController:lastfm];
    UINavigationController *settingsnav = [[UINavigationController alloc] initWithRootViewController:settings];
    NSDictionary *localmusicdict = [NSDictionary dictionaryWithObjectsAndKeys:localmusicnav, @"vc", @"Local Music", @"title", nil];
    NSDictionary *lasdtfmdict = [NSDictionary dictionaryWithObjectsAndKeys:lastfmnav, @"vc", @"Last.FM", @"title", nil];
    NSDictionary *settingsdict = [NSDictionary dictionaryWithObjectsAndKeys:settingsnav, @"vc", @"Settings", @"title", nil];
    [vcs addObject:localmusicdict];
    [vcs addObject:lasdtfmdict];
    [vcs addObject:settingsdict];
    SHSidebarController *sidebar = [[SHSidebarController alloc] initWithArrayOfVC:vcs];
    self.window.rootViewController = sidebar;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    NSLog(@"low mem");
    [avPlayer pause];
    [avPlayer finalize];
    self.isPlaying = NO;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device's memory is low." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
}

@end
