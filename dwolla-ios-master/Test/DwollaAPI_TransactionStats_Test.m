//
//  Created by James Armstead on 12/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <OCMock/OCMock.h>
#import <GHUnitIOS/GHUnit.h>
#import <DwollaOAuthLib/DwollaAPI.h>
#import "DwollaAPI_Base_Test.h"

@interface DwollaAPI_TransactionStats_Test : DwollaAPI_Base_Test {}
@end

@implementation DwollaAPI_TransactionStats_Test

-(void)testGetTransactionStats_WithNoAccessToken_ShouldThrowException
{
    GHAssertThrows([self.dwollaAPI getTransactionStatsWithStart:@"" withEnd:@"" withTypes:@""], @"No Exception was through when no AccessToken was passed in");
}

-(void)testGetTransactionsSince_WithValidData_ShouldCallHttpRequestRepository
{
    [self Setup_WithAccessToken_ClientKey_ClientSecret];
    
    NSDictionary* parameterDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                         @"123456789", @"oauth_token",
                                         @"1/1/2012", @"startDate",
                                         @"1/2/2012", @"endDate",
                                         @"money_sent", @"types", nil];
    
    [[self.mockHttpRequestRepository expect] getRequest: @"https://www.dwolla.com/oauth/rest/transactions/stats"
                           withQueryParameterDictionary: parameterDictionary];
    
    [self.dwollaAPI getTransactionStatsWithStart:@"1/1/2012" withEnd:@"1/2/2012" withTypes:@"money_sent"];
    
    [self.mockHttpRequestRepository verify];
}

-(void)testGetTransactionsSince_WithValidData_ShouldReturnValidDictionaryResponse
{
    [self Setup_WithAccessToken_ClientKey_ClientSecret];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.dwolla.com/oauth/rest/transactions/stats?types=money_sent&oauth_token=123456789"] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10];
    [request setHTTPMethod: @"GET"];
    
    NSMutableDictionary* responseDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                               @"true", @"Success",
                                                [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                                 @"1", @"TransactionsCount",
                                                 @"1000.00", @"TransactionsTotal",
                                                 nil], @"Response", nil];
    
    [self Setup_HttpRequestRepository_WithNSURLConnectionRepositoryMock_WithResponseDictionary:responseDictionary withRequest: request];
    
    DwollaTransactionStats *actual = [self.dwollaAPI getTransactionStatsWithStart:@"" withEnd:@"" withTypes:@"money_sent"];
    
    DwollaTransactionStats *expecting = [[DwollaTransactionStats alloc] initWithSuccess:true count:@"1" total:@"1000.00"];
    
    GHAssertEqualStrings([actual count], [expecting count], @"Amount expected does not match");
    GHAssertEqualStrings([actual total], [expecting total], @"Clearing Date expected does not match");
}
@end
