//
//  APIViewController.m
//  DwollaOAuth
//
//  Created by Nick Schulze on 6/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "APIViewController.h"

@interface APIViewController ()

@end

@implementation APIViewController

@synthesize dwollaAPI;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        dwollaAPI = [DwollaAPI sharedInstance];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction) getBalance
{
    float balance = [dwollaAPI getBalance];
    NSLog(@"%0.2f", balance);
}

-(IBAction)getContacts
{
    NSArray* contacts = [dwollaAPI getContactsByName:@"" types:@"" limit:@""];
    NSLog(@"%@", [contacts description]);
}

-(IBAction)getFundingSources
{
    NSArray* sources = [dwollaAPI getFundingSources];
    if(sources.count > 0) {
        DwollaFundingSource* person = [sources objectAtIndex:0];
        NSLog(@"%@", [person name]);
    }
}

-(IBAction)getFirstSource
{
    NSArray* sources = [dwollaAPI getFundingSources];
    if(sources.count > 0) {
        DwollaFundingSource* source = [sources objectAtIndex:0];
        NSLog(@"%@", [source name]);
    }
}

-(IBAction)logout
{
    [dwollaAPI clearAccessToken];
}

-(IBAction)getTransactions
{
    NSArray *transactions = [dwollaAPI getTransactionsSince:@"04-08-12" withType:@"" withLimit:@"10" withSkip:@"0"];
    if(transactions.count > 0) {
        DwollaTransaction* transaction = [transactions objectAtIndex:0];
        NSLog(@"%@", [transaction description]);
    }
}

-(IBAction)getTransaction;
{
    NSArray *transactions = [dwollaAPI getTransactionsSince:@"04-08-12" withType:@"" withLimit:@"10" withSkip:@"0"];
    if(transactions.count > 0) {
        DwollaTransaction* transaction = [transactions objectAtIndex:0];
        DwollaTransaction* trans = [dwollaAPI getTransaction:transaction.transactionID];
        NSLog(@"%@", [trans description]);
    }
}

-(IBAction)getTransactionStats
{
    DwollaTransactionStats *stats = [dwollaAPI getTransactionStatsWithStart:@"" withEnd:@"" withTypes:@""];
    NSLog(@"%@", [stats description]);
}

-(IBAction)getAccountInfo
{
    DwollaUser* user = [dwollaAPI getAccountInfo];
    NSLog(@"%@", [user name]);
}

-(IBAction)getBasicInfo
{
    NSArray *transactions = [dwollaAPI getTransactionsSince:@"04-08-12" withType:@"" withLimit:@"10" withSkip:@"0"];
    if(transactions.count > 0) {
        DwollaTransaction* transaction = [transactions objectAtIndex:0];
        DwollaUser* user = [dwollaAPI getBasicInfoWithAccountID:transaction.destinationID];
        NSLog(@"%@", [user description]);
    }
}

-(IBAction)sendMoney
{
    NSString* request = [dwollaAPI sendMoneyWithPIN:@"" destinationID:@"812-607-7497" destinationType:@"Dwolla" amount:@"0.01" facilitatorAmount:@"0" assumeCosts:@"false" notes:@"api_test" fundingSourceID:@""];
    NSLog(@"%@", request);
}

-(IBAction)requestMoney
{
    NSString* request = [dwollaAPI requestMoneyWithPIN:@"" sourceID:@"812-525-0238" sourceType:nil amount:@"0.01" facilitatorAmount:@"0.00" notes:nil];
    NSLog(@"%@", request);
}

-(IBAction)getNearby
{
    NSArray* contacts = [dwollaAPI getNearbyWithLatitude:@"41.6" Longitude:@"-93.6" Limit:@"5" Range:@"1"];
    NSLog(@"%@", [contacts description]);
}

@end
