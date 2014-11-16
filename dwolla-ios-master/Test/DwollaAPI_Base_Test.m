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

@implementation DwollaAPI_Base_Test

@synthesize dwollaAPI, mockTokenRepository, mockHttpRequestRepository, mockHttpRequestHelper;

- (void)setUp
{
    [super setUp];
    self.dwollaAPI = [DwollaAPI sharedInstance];
    self.mockTokenRepository = [OCMockObject mockForClass:[OAuthTokenRepository class]];
    self.mockHttpRequestRepository = [OCMockObject mockForClass:[HttpRequestRepository class]];
    self.mockHttpRequestHelper = [OCMockObject mockForClass:[HttpRequestHelper class]];
    self.mockNSURLConnectionRepository = [OCMockObject mockForClass:[NSURLConnectionRepository class]];
    
    [dwollaAPI setOAuthTokenRepository:self.mockTokenRepository];
    [dwollaAPI setHttpRequestRepository:self.mockHttpRequestRepository];
    [dwollaAPI setHttpRequestHelper:self.mockHttpRequestHelper];
}

- (void)tearDown
{
    // Tear-down code here.
    [super tearDown];
}

- (void) Setup_WithAccessToken_ClientKey_ClientSecret {
    BOOL boolYes = YES;
    [[[self.mockTokenRepository stub] andReturnValue:OCMOCK_VALUE(boolYes)] hasAccessToken];
    [[[self.mockTokenRepository stub] andReturn:@"123456789"] getAccessToken];
    [[[self.mockTokenRepository stub] andReturn:@"123"] getClientKey];
    [[[self.mockTokenRepository stub] andReturn:@"456"] getClientSecret];
}

- (void) Setup_PostRequest_WithDictionary: (NSDictionary *) result {
    [[[self.mockHttpRequestRepository stub] andReturn:result] postRequest:OCMOCK_ANY withParameterDictionary:OCMOCK_ANY];
}

- (void) Setup_GetRequest_WithDictionary: (NSDictionary *) result {
    [[[self.mockHttpRequestRepository stub] andReturn:result] getRequest:OCMOCK_ANY];
}

-(void) Setup_HttpRequestRepository_WithNSURLConnectionRepositoryMock_WithResponseDictionary:(NSDictionary*) responseDictionary
                                                                                 withRequest:(NSMutableURLRequest*) request
{
    [[[self.mockNSURLConnectionRepository stub] andReturn:responseDictionary] sendSynchronousRequest:request];
    
    //Mocked out NSURLConnection and passed it to a real HttpRequestRepository to test Logic
    HttpRequestRepository *httpRequestRepository = [[HttpRequestRepository alloc] init];
    [httpRequestRepository setNsURLConnectionRepository:self.mockNSURLConnectionRepository];
    [dwollaAPI setHttpRequestRepository:httpRequestRepository];
}

- (NSMutableArray *)Get_Mocked_DwollaContacts
{
    DwollaContact* one = [[DwollaContact alloc] initWithUserID:@"12345" name:@"Ben Facebook Test" image:@"" city:@"Des Moines" state:@"IA" type:@"Facebook" address:@"" longitude:@"" latitude:@""];
    
    DwollaContact* two = [[DwollaContact alloc] initWithUserID:@"812-111-111" name:@"Ben Dwolla Test" image:@"" city:@"Des Moines" state:@"IA" type:@"Dwolla" address:@"" longitude:@"" latitude:@""];
    
    return [[NSMutableArray alloc] initWithObjects:one, two, nil];
}

- (NSMutableArray *)Get_Mocked_DwollaContactsResponse
{
    NSDictionary* one = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                         @"12345", @"Id",
                         @"Ben Facebook Test", @"Name",
                         @"", @"Image",
                         @"Des Moines", @"City",
                         @"IA", @"State",
                         @"Facebook", @"Type",
                         @"", @"Address",
                         @"", @"Longitude",
                         @"", @"Latitude",
                         nil];
 
    NSDictionary* two = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                         @"812-111-111", @"Id",
                         @"Ben Dwolla Test", @"Name",
                         @"", @"Image",
                         @"Des Moines", @"City",
                         @"IA", @"State",
                         @"Dwolla", @"Type",
                         @"", @"Address",
                         @"", @"Longitude",
                         @"", @"Latitude",
                         nil];
    
      return [[NSMutableArray alloc] initWithObjects:one, two, nil];
}

@end
