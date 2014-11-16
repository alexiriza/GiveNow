//
//  APIViewController.h
//  DwollaOAuth
//
//  Created by Nick Schulze on 6/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DwollaAPI.h"

@interface APIViewController : UIViewController

-(IBAction)getBalance;

-(IBAction)getContacts;

-(IBAction)getFundingSources;

-(IBAction)getFirstSource;

-(IBAction)getTransactions;

-(IBAction)getTransaction;

-(IBAction)getTransactionStats;

-(IBAction)getAccountInfo;

-(IBAction)getBasicInfo;

-(IBAction)sendMoney;

-(IBAction)requestMoney;

-(IBAction)logout;

-(IBAction)getNearby;

@property (retain) DwollaAPI *dwollaAPI;

@end
