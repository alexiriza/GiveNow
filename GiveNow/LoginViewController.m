//
//  LoginViewController.m
//  Give Now
//
//  Created by Emma Trefethen & Alexander Iriza on 11/14/14.
//  Copyright (c) 2014 Emma Trefethen & Alex Iriza. All rights reserved.
//

#import "LoginViewController.h"
#import "MainPageViewController.h"

@interface LoginViewController ()

@property (strong, nonatomic) DwollaOAuth2Client *client;

@end

@implementation LoginViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSArray *scopes = [[NSArray alloc]
                       initWithObjects:
                       @"send",
                       @"accountinfofull",
                       @"funding", nil];
    
    DwollaOAuth2Client *client = [[DwollaOAuth2Client alloc] initWithFrame:[[UIScreen mainScreen] bounds] key:@"cfW1KJiB7R1o4CE3Jcs+zHWXMG/GAS0wwpIHzUtwDIaaVdujRe" secret:@"Y76XNqFKmSt8ANhhEtJgwCKPEKvN43JU/+3lSJapTx9zipOtCY" redirect:@"https://www.dwolla.com" response:@"code" scopes:scopes view:self.view reciever:self];
    
    self.client = client;
    
    [client login];
}

- (void)successfulLogin {
    MainPageViewController* actions = [self.storyboard instantiateViewControllerWithIdentifier:@"MainPage"];
    
    actions.client = self.client;
        
    [self presentViewController:actions animated:YES completion:nil];
}

- (void)failedLogin:(NSArray *)errors {
    
}

@end
