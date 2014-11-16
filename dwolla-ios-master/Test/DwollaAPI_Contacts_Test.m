//
//  Created by James Armstead on 12/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <OCMock/OCMock.h>
#import <GHUnitIOS/GHUnit.h>
#import <DwollaOAuthLib/DwollaAPI.h>
#import "DwollaAPI_Base_Test.h"

@interface DwollaAPI_Contacts_Test : DwollaAPI_Base_Test {}
@end

@implementation DwollaAPI_Contacts_Test

-(void)testContactsByName_WithNoAccessToken_ShouldThrowException
{
    GHAssertThrows([self.dwollaAPI getContactsByName:@"" types:@"" limit:@""], @"No Exception was through when no AccessToken was passed in");
}

-(void)testContactsByName_WithValidData_ShouldCallHttpRequestRepository
{
    [self Setup_WithAccessToken_ClientKey_ClientSecret];
    
    NSMutableDictionary* parameterDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                                @"123456789", @"oauth_token",
                                                @"test", @"name", nil];
    
    [[self.mockHttpRequestRepository expect] getRequest:@"https://www.dwolla.com/oauth/rest/contact" withQueryParameterDictionary: parameterDictionary];
    
    [self.dwollaAPI getContactsByName:@"test" types:@"" limit:@""];
    
    [self.mockHttpRequestRepository verify];
}

-(void)testContactsByName_WithValidData_ShouldReturnValidDictionaryResponse
{
    [self Setup_WithAccessToken_ClientKey_ClientSecret];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.dwolla.com/oauth/rest/contact?name=test&oauth_token=123456789"] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10];
    [request setHTTPMethod: @"GET"];
    
    NSMutableDictionary* responseDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                               @"true", @"Success",
                                               [self Get_Mocked_DwollaContactsResponse], @"Response", nil];
    
    [self Setup_HttpRequestRepository_WithNSURLConnectionRepositoryMock_WithResponseDictionary:responseDictionary withRequest: request];
    
    NSMutableArray *actual= [self.dwollaAPI getContactsByName:@"test" types:@"" limit:@""];
    NSMutableArray *expecting = [self Get_Mocked_DwollaContacts];
    
    DwollaContact* expecting1 = [expecting objectAtIndex:0];
    DwollaContact* expecting2 = [expecting objectAtIndex:1];
    
    DwollaContact* actual1 = [actual objectAtIndex:0];
    DwollaContact* actual2 = [actual objectAtIndex:1];
    
    GHAssertTrue([expecting1 isEqualTo:actual1],@"NOT EQUAL!");
    GHAssertTrue([expecting2 isEqualTo:actual2],@"NOT EQUAL!");
}


// GetNearby
-(void)testNearbyWithLatitude_WithNoClientKeyOrClientSecret_ShouldThrowException
{
    GHAssertThrows([self.dwollaAPI getNearbyWithLatitude:@"" Longitude:@"" Limit:@"" Range:@""], @"No Exception was through when no Client Key or Secret was passed in");
}

-(void)testNearbyWithLatitude_WithValidData_ShouldCallHttpRequestRepository
{
    [self Setup_WithAccessToken_ClientKey_ClientSecret];
    
    NSMutableDictionary* parameterDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                                @"123", @"client_id",
                                                @"456", @"client_secret",
                                                @"10", @"latitude",
                                                @"12", @"longitude", nil];
    
    [[self.mockHttpRequestRepository expect] getRequest:@"https://www.dwolla.com/oauth/rest/contacts/nearby" withQueryParameterDictionary: parameterDictionary];
    
    [self.dwollaAPI getNearbyWithLatitude:@"10" Longitude:@"12" Limit:@"" Range:@""];
    
    [self.mockHttpRequestRepository verify];
}

-(void)testNearbyWithLatitude_WithValidData_ShouldReturnValidDictionaryResponse
{
    [self Setup_WithAccessToken_ClientKey_ClientSecret];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"https://www.dwolla.com/oauth/rest/contacts/nearby?longitude=12.00&latitude=10.12&client_secret=456&client_id=123"] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10];
    [request setHTTPMethod: @"GET"];
    
    NSMutableDictionary* responseDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                               @"true", @"Success",
                                               [self Get_Mocked_DwollaContactsResponse], @"Response", nil];
    
    [self Setup_HttpRequestRepository_WithNSURLConnectionRepositoryMock_WithResponseDictionary:responseDictionary withRequest: request];
    
    NSMutableArray *actual = [self.dwollaAPI getNearbyWithLatitude:@"10.12" Longitude:@"12.00" Limit:@"" Range:@""];
    NSMutableArray *expecting = [self Get_Mocked_DwollaContacts];
    
    DwollaContact* expecting1 = [expecting objectAtIndex:0];
    DwollaContact* expecting2 = [expecting objectAtIndex:1];
    
    DwollaContact* actual1 = [actual objectAtIndex:0];
    DwollaContact* actual2 = [actual objectAtIndex:1];
    
    GHAssertTrue([expecting1 isEqualTo:actual1],@"NOT EQUAL!");
    GHAssertTrue([expecting2 isEqualTo:actual2],@"NOT EQUAL!");
}

@end
