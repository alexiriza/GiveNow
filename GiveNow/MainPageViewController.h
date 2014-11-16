//
//  MainPageViewController.h
//  Give Now
//
//  Created by Emma Trefethen & Alexander Iriza on 11/14/14.
//  Copyright (c) 2014 Emma Trefethen & Alex Iriza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DwollaAPI.h"
#import "DwollaOAuth2Client.h"

@interface MainPageViewController : UIViewController <UITextFieldDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) DwollaOAuth2Client *client;

@end
