//
//  ViewController.m
//  DwollaOAuth
//
//  Created by Nick Schulze on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

-(IBAction)login
{
    NSArray *scopes = [[NSArray alloc] initWithObjects:@"send", @"balance", @"accountinfofull", @"contacts", @"funding",  @"request", @"transactions", nil];
    DwollaOAuth2Client *client = [[DwollaOAuth2Client alloc] initWithFrame:CGRectMake(0, 0, 320, 460) key:@"qsWR4NLYZWc7hy84kRdr2TTPKjkUDQpDfMjUUrro6d2uWbw0dU" secret:@"r+nWEsy45d+zpB86mUy0QANbrTSas9KswANPUeL7auV0m1MicC" redirect:@"https://www.dwolla.com" response:@"code" scopes:scopes view:self.view reciever:self];
    [client login];
}

-(void)successfulLogin
{
    APIViewController* actions = [[APIViewController alloc] init];
    [actions setModalTransitionStyle:UIModalPresentationFullScreen];
    [self presentModalViewController:actions animated:YES];
}

-(void)failedLogin:(NSArray*)errors
{
    
}


@end
