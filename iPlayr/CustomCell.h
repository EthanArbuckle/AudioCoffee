//
//  CustomCell.h
//  iPlayr
//
//  Created by Ethan Arbuckle on 4/11/13.
//
//

#import <UIKit/UIKit.h>

@interface CustomCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *songLabel;
@property (nonatomic, weak) IBOutlet UILabel *artistLabel;
@property IBOutlet UIImageView *nowPlaying;
@property IBOutlet UIImageView *albumArt;

@end
