//
//  ViewController.h
//  DwollaOAuth
//
//  Created by Nick Schulze on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DwollaOAuth2Client.h"
#import "IDwollaMessages.h"
#import "APIViewController.h"

@interface ViewController : UIViewController <IDwollaMessages>

-(IBAction)login;

-(void)successfulLogin;

-(void)failedLogin:(NSArray*)errors;
@end
