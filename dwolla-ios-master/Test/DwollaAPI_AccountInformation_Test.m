//
//  Created by James Armstead on 12/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <OCMock/OCMock.h>
#import <GHUnitIOS/GHUnit.h>
#import <DwollaOAuthLib/DwollaAPI.h>
#import "DwollaAPI_Base_Test.h"

@interface DwollaAPI_AccountInformation_Test : DwollaAPI_Base_Test {}
@end

@implementation DwollaAPI_AccountInformation_Test

-(void)testAccountInformation_WithNoAccessToken_ShouldThrowException
{
    GHAssertThrows([self.dwollaAPI getAccountInfo], @"No Exception was through when no AccessToken was passed in");
}

-(void)testAccountInformation_WithValidData_ShouldCallHttpRequestRepository
{
    [self Setup_WithAccessToken_ClientKey_ClientSecret];
    
    [[[self.mockHttpRequestHelper stub] andReturn:@"123456789"] encodeString:@"123456789"];
    [[self.mockHttpRequestRepository expect] getRequest:@"https://www.dwolla.com/oauth/rest/users?oauth_token=123456789"];
    
    [self.dwollaAPI getAccountInfo];
    
    [self.mockHttpRequestRepository verify];
}

-(void)testAccountInformation_WithValidData_ShouldReturnValidDictionaryResponse
{
    [self Setup_WithAccessToken_ClientKey_ClientSecret];
    
    [[[self.mockHttpRequestHelper stub] andReturn:@"123456789"] encodeString:@"123456789"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.dwolla.com/oauth/rest/users?oauth_token=123456789"] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10];
    [request setHTTPMethod: @"GET"];
    
    NSMutableDictionary* responseDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                               @"true", @"Success",
                                               [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                                @"812-111-1111", @"Id",
                                                @"Ben Facebook Test", @"Name",
                                                @"Des Moines", @"City",
                                                @"IA", @"State",
                                                @"Dwolla", @"Type",
                                                @"", @"Longitude",
                                                @"", @"Latitude",
                                                nil], @"Response", nil];
    
    [self Setup_HttpRequestRepository_WithNSURLConnectionRepositoryMock_WithResponseDictionary:responseDictionary withRequest: request];
    
    DwollaUser *actual= [self.dwollaAPI getAccountInfo];
    DwollaUser *expecting = [[DwollaUser alloc] initWithUserID:@"812-111-1111" name:@"Ben Facebook Test" city:@"Des Moines" state:@"IA"
                                                      latitude:@"" longitude:@"" type:@"Dwolla"];
    
    GHAssertEqualStrings([actual userID], [expecting userID], @"Id expected does not match");
    GHAssertEqualStrings([actual name], [expecting name], @"Name expected does not match");
    GHAssertEqualStrings([actual city], [expecting city], @"City expected does not match");
    GHAssertEqualStrings([actual state], [expecting state], @"City expected does not match");
    GHAssertEqualStrings([actual type], [expecting type], @"Type expected does not match");
    GHAssertEqualStrings([actual latitude], [expecting latitude], @"Latitude expected does not match");
    GHAssertEqualStrings([actual longitude], [expecting longitude], @"Longitude expected does not match");
}


//GetBasicInformation
-(void)testBasicInfoWithAccountID_WithNoClientIdOrClientSecret_ShouldThrowException
{
    GHAssertThrows([self.dwollaAPI getBasicInfoWithAccountID:@"123"], @"No Exception was through when no Client Key or Secret was passed in");
}
-(void)testBasicInfoWithAccountID_WithValidData_ShouldCallHttpRequestRepository
{
    [self Setup_WithAccessToken_ClientKey_ClientSecret];
    
    [[self.mockHttpRequestRepository expect] getRequest:@"https://www.dwolla.com/oauth/rest/users/543?client_id=123&client_secret=456"];
    
    [self.dwollaAPI getBasicInfoWithAccountID:@"543"];
    
    [self.mockHttpRequestRepository verify];
}
-(void)testBasicInfoWithAccountID_WithValidData_ShouldReturnValidDictionaryResponse
{
    [self Setup_WithAccessToken_ClientKey_ClientSecret];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.dwolla.com/oauth/rest/users/432?client_id=123&client_secret=456"] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10];
    [request setHTTPMethod: @"GET"];
    
    NSMutableDictionary* responseDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                               @"true", @"Success",
                                               [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                                @"812-111-1111", @"Id",
                                                @"Ben Facebook Test", @"Name",
                                                @"1.0", @"Longitude",
                                                @"2.0", @"Latitude",
                                                nil], @"Response", nil];
    
    [self Setup_HttpRequestRepository_WithNSURLConnectionRepositoryMock_WithResponseDictionary:responseDictionary withRequest: request];
    
    DwollaUser *actual= [self.dwollaAPI getBasicInfoWithAccountID:@"432"];
    DwollaUser *expecting = [[DwollaUser alloc] initWithUserID:@"812-111-1111" name:@"Ben Facebook Test" city:nil state:nil
                                                      latitude:@"2.0" longitude:@"1.0" type:nil];
    
    GHAssertEqualStrings([actual userID], [expecting userID], @"Id expected does not match");
    GHAssertEqualStrings([actual name], [expecting name], @"Name expected does not match");
    GHAssertEqualStrings([actual city], [expecting city], @"City expected does not match");
    GHAssertEqualStrings([actual state], [expecting state], @"City expected does not match");
    GHAssertEqualStrings([actual type], [expecting type], @"Type expected does not match");
    GHAssertEqualStrings([actual latitude], [expecting latitude], @"Latitude expected does not match");
    GHAssertEqualStrings([actual longitude], [expecting longitude], @"Longitude expected does not match");
}





@end
