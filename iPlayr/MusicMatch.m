//
//  MusicMatch.m
//  iPlayr
//
//  Created by Ethan Arbuckle on 4/12/13.
//
//

#import "MusicMatch.h"
#import "JSON.h"

NSString *baseURL = @"http://api.musixmatch.com/ws/1.1/";
NSString *apiKey = @"735a521404a1f6baaf3eae48f2ff47c7";

@implementation MusicMatch

- (NSString*)getLyricsForSongTitled:(NSString*)songTitle {
    NSString *url = [NSString stringWithFormat:@"%@matcher.lyrics.get?q_track=%@&apikey=%@", baseURL, songTitle, apiKey];
    NSString *jsonData = [NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:nil];
    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
    NSDictionary *results = [jsonParser objectWithString:jsonData];
    NSString *lyrics = [[[results objectForKey:@"body"] objectForKey:@"lyrics"] objectForKey:@"lyrics_body"];
    return lyrics;
}

@end
