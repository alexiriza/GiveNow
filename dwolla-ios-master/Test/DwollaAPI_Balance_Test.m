//
//  Created by James Armstead on 12/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <OCMock/OCMock.h>
#import <GHUnitIOS/GHUnit.h>
#import <DwollaOAuthLib/DwollaAPI.h>
#import "DwollaAPI_Base_Test.h"

@interface DwollaAPI_Balance_Tests : DwollaAPI_Base_Test {}
@end

@implementation DwollaAPI_Balance_Tests

-(void)testBalance_WithNoAccessToken_ShouldThrowException
{
    GHAssertThrows([self.dwollaAPI getBalance], @"No Exception was through when no AccessToken was passed in");
}

-(void)testRequest_WithValidData_ShouldCallHttpRequestRepository
{
    [self Setup_WithAccessToken_ClientKey_ClientSecret];
    [[[self.mockHttpRequestHelper stub] andReturn:@"123456789"] encodeString:@"123456789"];
    [[self.mockHttpRequestRepository expect] getRequest:@"https://www.dwolla.com/oauth/rest/balance?oauth_token=123456789"];
    
    [self.dwollaAPI getBalance];
    
    [self.mockHttpRequestRepository verify];
}

-(void)testRequest_WithValidData_ShouldReturnBalance
{
    [self Setup_WithAccessToken_ClientKey_ClientSecret];
    
    [[[self.mockHttpRequestHelper stub] andReturn:@"123456789"] encodeString:@"123456789"];
    [[[self.mockHttpRequestRepository stub] andReturn:[[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                                       @"true", @"Success",
                                                       @"10.00", @"Response", nil]]
     getRequest:@"https://www.dwolla.com/oauth/rest/balance?oauth_token=123456789"];
    
    float balance = [self.dwollaAPI getBalance];
    
    GHAssertTrue((balance == 10.00), @"Balance does not equal the correct balance");
}

@end
