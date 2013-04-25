//
//  lastfmMain.m
//  iPlayr
//
//  Created by Ethan Arbuckle on 4/16/13.
//
//

#import "lastfmMain.h"
#import "FMEngine.h"
#import "SBJSON.h"
#import "CustomCell.h"
#import "NSString+FMEngine.h"

@interface lastfmMain ()

@end

NSMutableArray *tracks;

@implementation lastfmMain

- (void)viewDidLoad {
    FMEngine *fmEngine = [[FMEngine alloc] init];
    tracks = [[NSMutableArray alloc] init];
    
    
    NSString *authToken = [fmEngine generateAuthTokenFromUsername:_un password:_pw];
    
    
    NSDictionary *urlDict = [NSDictionary dictionaryWithObjectsAndKeys:_un, @"user", authToken, @"authToken", _LASTFM_API_KEY_, @"api_key", nil, nil];
    
    
   // NSDictionary *urlDict2 = [NSDictionary dictionaryWithObjectsAndKeys:_un, @"user", authToken, @"authToken", _LASTFM_API_KEY_, @"api_key", nil, nil];
    
    
    NSData *data = [fmEngine dataForMethod:@"user.getPlaylists" withParameters:urlDict useSignature:YES httpMethod:POST_TYPE error:nil];
    NSString *newStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    SBJsonParser *parse = [[SBJsonParser alloc] init];
    NSDictionary *songsdict = [parse objectWithString:newStr];
    for (NSDictionary *currSong in [[songsdict objectForKey:@"tracks"] objectForKey : @"track"]) {
        [tracks addObject:currSong];
    }
    _songsTable.delegate = self;
    _songsTable.dataSource = self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [tracks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"CustomCell";
    CustomCell *cell = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    NSDictionary *current = [tracks objectAtIndex:indexPath.row];
    cell.songLabel.text = [current valueForKey:@"name"];
    cell.artistLabel.text = [[current objectForKey:@"artist"] valueForKey:@"name"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

@end
