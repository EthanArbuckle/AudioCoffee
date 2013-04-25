//
//  lastfmLogin.m
//  iPlayr
//
//  Created by Ethan Arbuckle on 4/20/13.
//
//

#import "lastfmLogin.h"
#import "FMEngine.h"
#import "lastfmMain.h"

@interface lastfmLogin ()

@end

@implementation lastfmLogin

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Locked" message:@"LASTFM has been disabled in this build." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
    return;
    [super viewDidLoad];
	UIAlertView *warn = [[UIAlertView alloc] initWithTitle:@"Notice" message:@"Last.FM has NOT been added yet. Logging in will ONLY list your playlists." delegate:self cancelButtonTitle:@"I Understand" otherButtonTitles:nil, nil];
    [warn show];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    lastfmMain *next = [segue destinationViewController];
    [next setPw:_pw.text];
    [next setUn:_ua.text];
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    FMEngine *fmEngine = [[FMEngine alloc] init];
    NSString *authToken = [fmEngine generateAuthTokenFromUsername:_ua.text password:_pw.text];
    if (authToken.length > 4) {
        return NO;
    }
    else {
        UIAlertView *warn = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Disabled" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [warn show];
        return NO;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
