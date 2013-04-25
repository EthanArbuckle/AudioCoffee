//
//  lastfmMain.h
//  iPlayr
//
//  Created by Ethan Arbuckle on 4/16/13.
//
//

#import <UIKit/UIKit.h>

@interface lastfmMain : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property IBOutlet UITableView *songsTable;
@property NSString *un;
@property NSString *pw;

@end
