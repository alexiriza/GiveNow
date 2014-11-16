//
//  Created by James Armstead on 12/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <OCMock/OCMock.h>
#import <GHUnitIOS/GHUnit.h>
#import <DwollaOAuthLib/DwollaAPI.h>
#import "DwollaAPI_Base_Test.h"

@interface DwollaAPI_Transactions_Test : DwollaAPI_Base_Test {}
@end

@implementation DwollaAPI_Transactions_Test

-(void)testGetTransactionsSince_WithNoAccessToken_ShouldThrowException
{
    GHAssertThrows([self.dwollaAPI getTransactionsSince:@"" withType:@"" withLimit:@"" withSkip:@""], @"No Exception was through when no AccessToken was passed in");
}

-(void)testGetTransactionsSince_WithValidData_ShouldCallHttpRequestRepository
{
    [self Setup_WithAccessToken_ClientKey_ClientSecret];
    
    NSDictionary* parameterDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                         @"123456789", @"oauth_token",
                                         @"10", @"limit", nil];
    
    [[self.mockHttpRequestRepository expect] getRequest: @"https://www.dwolla.com/oauth/rest/transactions"
                           withQueryParameterDictionary: parameterDictionary];
    
    [self.dwollaAPI getTransactionsSince:@"" withType:@"" withLimit:@"10" withSkip:@""];
    
    [self.mockHttpRequestRepository verify];
}

-(void)testGetTransactionsSince_WithValidData_ShouldReturnValidDictionaryResponse
{
    [self Setup_WithAccessToken_ClientKey_ClientSecret];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.dwolla.com/oauth/rest/transactions?types=money_sent&oauth_token=123456789"] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10];
    [request setHTTPMethod: @"GET"];
    
    NSMutableDictionary* responseDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                               @"true", @"Success",
                                               [[NSMutableArray alloc] initWithObjects: [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                                @"1.25", @"Amount",
                                                @"8/29/2011 1:42:48 PM", @"Date",
                                                @"812-111-1111", @"DestinationId",
                                                @"Test User", @"DestinationName",
                                                @"2", @"Id",
                                                @"", @"SourceId",
                                                @"", @"SourceName",                                         
                                                @"money_sent", @"Type",
                                                @"Dwolla", @"UserType",
                                                @"processed", @"Status",
                                                @"", @"ClearingDate",                                         
                                                @"", @"Notes",                                         
                                                nil],
                                                [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                                 @"1.00", @"Amount",
                                                 @"8/29/2011 1:42:48 PM", @"Date",
                                                 @"812-111-1111", @"DestinationId",
                                                 @"Test User", @"DestinationName",
                                                 @"3", @"Id",
                                                 @"", @"SourceId",
                                                 @"", @"SourceName", 
                                                 @"money_sent", @"Type",
                                                 @"Dwolla", @"UserType",
                                                 @"processed", @"Status",
                                                 @"", @"ClearingDate",
                                                 @"", @"Notes",
                                                 nil], nil], @"Response", nil];
    
    
    [self Setup_HttpRequestRepository_WithNSURLConnectionRepositoryMock_WithResponseDictionary:responseDictionary withRequest: request];
    
    NSArray *actuals = [self.dwollaAPI getTransactionsSince:@"" withType:@"money_sent" withLimit:@"" withSkip:@""];
    DwollaTransaction *actual = [actuals objectAtIndex:0];
    DwollaTransaction *actual2 = [actuals objectAtIndex:1];
    
    DwollaTransaction *expecting = [[DwollaTransaction alloc] initWithAmount:@"1.25" clearingDate:@"" date:@"8/29/2011 1:42:48 PM" destinationID:@"812-111-1111" destinationName:@"Test User" transactionID:@"2" notes:@"" sourceID:@"" sourceName:@"" status:@"processed" type:@"money_sent" userType:@"Dwolla"];
    DwollaTransaction *expecting2 = [[DwollaTransaction alloc] initWithAmount:@"1.00" clearingDate:@"" date:@"8/29/2011 1:42:48 PM" destinationID:@"812-111-1111" destinationName:@"Test User" transactionID:@"3" notes:@"" sourceID:@"" sourceName:@"" status:@"processed" type:@"money_sent" userType:@"Dwolla"];
    
    GHAssertEqualStrings([actual amount], [expecting amount], @"Amount expected does not match");
    GHAssertEqualStrings([actual clearingDate], [expecting clearingDate], @"Clearing Date expected does not match");
    GHAssertEqualStrings([actual date], [expecting date], @"Date expected does not match");
    GHAssertEqualStrings([actual destinationID], [expecting destinationID], @"Destination Id expected does not match");
    GHAssertEqualStrings([actual destinationName], [expecting destinationName], @"Destination Name expected does not match");
    GHAssertEqualStrings([actual transactionID], [expecting transactionID], @"Transaction Id expected does not match");
    GHAssertEqualStrings([actual notes], [expecting notes], @"Notes expected does not match");
    GHAssertEqualStrings([actual sourceID], [expecting sourceID], @"Source Id expected does not match");
    GHAssertEqualStrings([actual sourceName], [expecting sourceName], @"Source Name expected does not match");
    GHAssertEqualStrings([actual status], [expecting status], @"Status expected does not match");
    GHAssertEqualStrings([actual type], [expecting type], @"Type expected does not match");
    GHAssertEqualStrings([actual userType], [expecting userType], @"User Type expected does not match");
    
    GHAssertEqualStrings([actual2 amount], [expecting2 amount], @"Amount expected does not match");
    GHAssertEqualStrings([actual2 clearingDate], [expecting2 clearingDate], @"Clearing Date expected does not match");
    GHAssertEqualStrings([actual2 date], [expecting2 date], @"Date expected does not match");
    GHAssertEqualStrings([actual2 destinationID], [expecting2 destinationID], @"Destination Id expected does not match");
    GHAssertEqualStrings([actual2 destinationName], [expecting2 destinationName], @"Destination Name expected does not match");
    GHAssertEqualStrings([actual2 transactionID], [expecting2 transactionID], @"Transaction Id expected does not match");
    GHAssertEqualStrings([actual2 notes], [expecting2 notes], @"Notes expected does not match");
    GHAssertEqualStrings([actual2 sourceID], [expecting2 sourceID], @"Source Id expected does not match");
    GHAssertEqualStrings([actual2 sourceName], [expecting2 sourceName], @"Source Name expected does not match");
    GHAssertEqualStrings([actual2 status], [expecting2 status], @"Status expected does not match");
    GHAssertEqualStrings([actual2 type], [expecting2 type], @"Type expected does not match");
    GHAssertEqualStrings([actual2 userType], [expecting2 userType], @"User Type expected does not match");
}


//GetTransaction Test
-(void)testGetTransaction_WithNoAccessToken_ShouldThrowException
{
    GHAssertThrows([self.dwollaAPI getTransaction:@"123"], @"No Exception was through when no AccessToken was passed in");
}
-(void)testGetTransaction_WithValidData_ShouldCallHttpRequestRepository
{
    [self Setup_WithAccessToken_ClientKey_ClientSecret];
    
    [[[self.mockHttpRequestHelper stub] andReturn:@"123456789"] encodeString:@"123456789"];
    
    [[self.mockHttpRequestRepository expect] getRequest: @"https://www.dwolla.com/oauth/rest/transactions/123?oauth_token=123456789"];
    
    [self.dwollaAPI getTransaction:@"123"];
    
    [self.mockHttpRequestRepository verify];
}
-(void)testGetTransaction_WithValidData_ShouldReturnValidDictionaryResponse
{
    [self Setup_WithAccessToken_ClientKey_ClientSecret];
    
    [[[self.mockHttpRequestHelper stub] andReturn:@"123456789"] encodeString:@"123456789"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.dwolla.com/oauth/rest/transactions/123?oauth_token=123456789"] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10];
    [request setHTTPMethod: @"GET"];
    
    NSMutableDictionary* responseDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                               @"true", @"Success",
                                               [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                                                                         @"1.25", @"Amount",
                                                                                         @"8/29/2011 1:42:48 PM", @"Date",
                                                                                         @"812-111-1111", @"DestinationId",
                                                                                         @"Test User", @"DestinationName",
                                                                                         @"2", @"Id",
                                                                                         @"", @"SourceId",
                                                                                         @"", @"SourceName",
                                                                                         @"money_sent", @"Type",
                                                                                         @"Dwolla", @"UserType",
                                                                                         @"processed", @"Status",
                                                                                         @"", @"ClearingDate",
                                                                                         @"", @"Notes",
                                                                                         nil], @"Response", nil];
    
    
    [self Setup_HttpRequestRepository_WithNSURLConnectionRepositoryMock_WithResponseDictionary:responseDictionary withRequest: request];
    
    DwollaTransaction *actual = [self.dwollaAPI getTransaction:@"123"];
    
    DwollaTransaction *expecting = [[DwollaTransaction alloc] initWithAmount:@"1.25" clearingDate:@"" date:@"8/29/2011 1:42:48 PM" destinationID:@"812-111-1111" destinationName:@"Test User" transactionID:@"2" notes:@"" sourceID:@"" sourceName:@"" status:@"processed" type:@"money_sent" userType:@"Dwolla"];
    
    GHAssertEqualStrings([actual amount], [expecting amount], @"Amount expected does not match");
    GHAssertEqualStrings([actual clearingDate], [expecting clearingDate], @"Clearing Date expected does not match");
    GHAssertEqualStrings([actual date], [expecting date], @"Date expected does not match");
    GHAssertEqualStrings([actual destinationID], [expecting destinationID], @"Destination Id expected does not match");
    GHAssertEqualStrings([actual destinationName], [expecting destinationName], @"Destination Name expected does not match");
    GHAssertEqualStrings([actual transactionID], [expecting transactionID], @"Transaction Id expected does not match");
    GHAssertEqualStrings([actual notes], [expecting notes], @"Notes expected does not match");
    GHAssertEqualStrings([actual sourceID], [expecting sourceID], @"Source Id expected does not match");
    GHAssertEqualStrings([actual sourceName], [expecting sourceName], @"Source Name expected does not match");
    GHAssertEqualStrings([actual status], [expecting status], @"Status expected does not match");
    GHAssertEqualStrings([actual type], [expecting type], @"Type expected does not match");
    GHAssertEqualStrings([actual userType], [expecting userType], @"User Type expected does not match");
}

@end
