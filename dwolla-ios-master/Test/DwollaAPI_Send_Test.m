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

@interface DwollaAPI_Send_Tests : DwollaAPI_Base_Test {}
@end

@implementation DwollaAPI_Send_Tests

-(void)testSend_WithNoAccessToken_ShouldThrowException
{
    GHAssertThrows([self.dwollaAPI sendMoneyWithPIN:@"1111" destinationID:@"812-111-1111" destinationType:@"dwolla" amount:@"0.00" facilitatorAmount:@"" assumeCosts:@"" notes:@"" fundingSourceID:@""], @"No Exception was through when no AccessToken was passed in");
}

-(void)testSend_WithNoPIN_ShouldThrowException
{
    [self Setup_WithAccessToken_ClientKey_ClientSecret];
    GHAssertThrows([self.dwollaAPI sendMoneyWithPIN:@"" destinationID:@"812-111-1111" destinationType:@"dwolla" amount:@"0.00" facilitatorAmount:@"" assumeCosts:@"" notes:@"" fundingSourceID:@""], @"No Exception was through when no PIN was passed in");
}
-(void)testSend_WithNoDestintation_ShouldThrowException
{
    [self Setup_WithAccessToken_ClientKey_ClientSecret];
    GHAssertThrows([self.dwollaAPI sendMoneyWithPIN:@"1111" destinationID:@"" destinationType:@"dwolla" amount:@"0.00" facilitatorAmount:@"" assumeCosts:@"" notes:@"" fundingSourceID:@""], @"No Exception was through when no Destination was passed in");
}
-(void)testSend_WithNoAmount_ShouldThrowException
{
    [self Setup_WithAccessToken_ClientKey_ClientSecret];
    GHAssertThrows([self.dwollaAPI sendMoneyWithPIN:@"1111" destinationID:@"812-111-1111" destinationType:@"dwolla" amount:@"" facilitatorAmount:@"" assumeCosts:@"" notes:@"" fundingSourceID:@""], @"No Exception was through when no Amount was passed in");
}

-(void)testSend_WithValidData_ShouldCallHttpRequestRepositoryWithSendURLAndNSData
{
    [self Setup_WithAccessToken_ClientKey_ClientSecret];
    [[[self.mockHttpRequestHelper stub] andReturn:[NSData alloc]]getJSONDataFromNsDictionary: OCMOCK_ANY];
    [[[self.mockHttpRequestHelper stub] andReturn:@"123456789"] encodeString:@"123456789"];
    
    NSMutableDictionary* parameterDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                                @"1111", @"pin",
                                                @"812-111-1111", @"destinationId",
                                                @"1.00", @"amount",
                                                @"dwolla", @"destinationType", nil];
    
    [[self.mockHttpRequestRepository expect] postRequest:@"https://www.dwolla.com/oauth/rest/transactions/send?oauth_token=123456789" withParameterDictionary:parameterDictionary];
    
    [self.dwollaAPI sendMoneyWithPIN:@"1111" destinationID:@"812-111-1111" destinationType:@"dwolla" amount:@"1.00" facilitatorAmount:@"" assumeCosts:@"" notes:@"" fundingSourceID:@""];
    
    [self.mockHttpRequestRepository verify];
}

-(void)testSend_WithInValidData_ShouldThrowAnErrorIfSuccessComesBackFalse
{
    [self Setup_WithAccessToken_ClientKey_ClientSecret];
    [[[self.mockHttpRequestHelper stub] andReturn:[NSData alloc]]getJSONDataFromNsDictionary: OCMOCK_ANY];
    
    NSMutableDictionary* responseDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                               @"false", @"Success",
                                               @"asdf", @"Response", nil];
    
    [self Setup_HttpRequestRepository_WithNSURLConnectionRepositoryMock_WithResponseDictionary:responseDictionary withRequest:OCMOCK_ANY];
    
    GHAssertThrows([self.dwollaAPI sendMoneyWithPIN:@"1111" destinationID:@"812-111-1111" destinationType:@"dwolla" amount:@"1.00" facilitatorAmount:@"" assumeCosts:@"" notes:@"" fundingSourceID:@""], @"No Exception was through when Response came back with Success is false");
}

-(void)testSend_WithValidData_ShouldReturnValidDictionaryResponse
{
    [self Setup_WithAccessToken_ClientKey_ClientSecret];
    [[[self.mockHttpRequestHelper stub] andReturn:[NSData alloc]]getJSONDataFromNsDictionary: OCMOCK_ANY];
    [[[self.mockHttpRequestHelper stub] andReturn:@"123456789"] encodeString:@"123456789"];
    
    NSMutableDictionary* responseDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                               @"true", @"Success",
                                               @"1010101", @"Response", nil];
    
    [self Setup_HttpRequestRepository_WithNSURLConnectionRepositoryMock_WithResponseDictionary:responseDictionary withRequest:OCMOCK_ANY];
    
    NSString *result = [self.dwollaAPI sendMoneyWithPIN:@"1111" destinationID:@"812-111-1111" destinationType:@"dwolla" amount:@"1.00" facilitatorAmount:@"" assumeCosts:@"" notes:@"" fundingSourceID:@""];
    
    GHAssertTrue([@"1010101" isEqualToString:result], @"Response is not coming back as the Transaction ID");
    
}
@end
