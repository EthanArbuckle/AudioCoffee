//
//  AppDelegate.h
//  iPlayr
//
//  Created by Ethan Arbuckle on 4/10/13.
//
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property AVAudioPlayer *avPlayer;
@property NSInteger *currentPlaying;
@property BOOL isPlaying;
@property BOOL isShuffle;
@property int repeatMode;

@end
