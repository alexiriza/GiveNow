//
//  DwollaOAuthTests.m
//  DwollaOAuthTests
//
//  Created by Nick Schulze on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <OCMock/OCMock.h>
#import <GHUnitIOS/GHUnit.h>
#import <DwollaOAuthLib/DwollaAPI.h>
#import "DwollaAPI_Base_Test.h"

@interface DwollaAPI_Request_Tests : DwollaAPI_Base_Test {}
@end

@implementation DwollaAPI_Request_Tests

-(void)testRequest_WithValidData_ShouldCallHttpRequestRepositoryWithSendURLAndNSData
{
    [self Setup_WithAccessToken_ClientKey_ClientSecret];
    [[[self.mockHttpRequestHelper stub] andReturn:[NSData alloc]]getJSONDataFromNsDictionary: OCMOCK_ANY];
    [[[self.mockHttpRequestHelper stub] andReturn:@"123456789"] encodeString:@"123456789"];
    
    NSMutableDictionary* parameterDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                                @"1111", @"pin",
                                                @"812-111-1111", @"sourceId",
                                                @"1.00", @"amount",
                                                @"dwolla", @"sourceType", nil];
    
    [[self.mockHttpRequestRepository expect] postRequest:@"https://www.dwolla.com/oauth/rest/transactions/request?oauth_token=123456789" withParameterDictionary:parameterDictionary];
    
    [self.dwollaAPI requestMoneyWithPIN:@"1111" sourceID:@"812-111-1111" sourceType:@"dwolla" amount:@"1.00" facilitatorAmount:@"" notes:@""];
    
    [self.mockHttpRequestRepository verify];
}

-(void)testRequest_WithNoAccessToken_ShouldThrowException
{
    GHAssertThrows([self.dwollaAPI requestMoneyWithPIN:@"1111" sourceID:@"812-111-1111" sourceType:@"dwolla" amount:@"1.00" facilitatorAmount:@"" notes:@""], @"No Exception was through when no AccessToken was passed in");
}

-(void)testRequest_WithNoPIN_ShouldThrowException
{
    [self Setup_WithAccessToken_ClientKey_ClientSecret];
    GHAssertThrows([self.dwollaAPI requestMoneyWithPIN:@"" sourceID:@"812-111-1111" sourceType:@"dwolla" amount:@"1.00" facilitatorAmount:@"" notes:@""], @"No Exception was through when no PIN was passed in");
}
-(void)testRequest_WithNoSource_ShouldThrowException
{
    [self Setup_WithAccessToken_ClientKey_ClientSecret];
    GHAssertThrows([self.dwollaAPI requestMoneyWithPIN:@"1111" sourceID:@"" sourceType:@"dwolla" amount:@"1.00" facilitatorAmount:@"" notes:@""], @"No Exception was through when no Source was passed in");
}
-(void)testRequest_WithNoAmount_ShouldThrowException
{
    [self Setup_WithAccessToken_ClientKey_ClientSecret];
    GHAssertThrows([self.dwollaAPI requestMoneyWithPIN:@"1111" sourceID:@"812-111-1111" sourceType:@"dwolla" amount:@"" facilitatorAmount:@"" notes:@""], @"No Exception was through when no Amount was passed in");
}

-(void)testRequest_WithInValidData_ShouldThrowAnErrorIfSuccessComesBackFalse
{
    [self Setup_WithAccessToken_ClientKey_ClientSecret];
    [[[self.mockHttpRequestHelper stub] andReturn:[NSData alloc]]getJSONDataFromNsDictionary: OCMOCK_ANY];
    
    NSMutableDictionary* responseDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                               @"false", @"Success",
                                               @"asdf", @"Response", nil];
    
    [self Setup_HttpRequestRepository_WithNSURLConnectionRepositoryMock_WithResponseDictionary:responseDictionary withRequest:OCMOCK_ANY];
    
    GHAssertThrows([self.dwollaAPI requestMoneyWithPIN:@"1111" sourceID:@"812-111-1111" sourceType:@"dwolla" amount:@"1.00" facilitatorAmount:@"" notes:@""], @"No Exception was through when Response came back with Success is false");
}

-(void)testRequest_WithValidData_ShouldReturnValidDictionaryResponse
{
    [self Setup_WithAccessToken_ClientKey_ClientSecret];
    
    [[[self.mockHttpRequestHelper stub] andReturn:@"123456789"] encodeString:@"123456789"];
    
    NSMutableDictionary* responseDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                               @"true", @"Success",
                                               @"0101010", @"Response", nil];
    
    [self Setup_HttpRequestRepository_WithNSURLConnectionRepositoryMock_WithResponseDictionary:responseDictionary withRequest:OCMOCK_ANY];
    
    NSString *result = [self.dwollaAPI requestMoneyWithPIN:@"1111" sourceID:@"812-111-1111" sourceType:@"dwolla" amount:@"1.00" facilitatorAmount:@"" notes:@""];
    
    GHAssertTrue([@"0101010" isEqualToString:result], @"Response is not coming back as the Transaction ID");
    
}
@end
