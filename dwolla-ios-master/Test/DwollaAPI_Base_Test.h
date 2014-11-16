//
//  DwollaOAuthTests.m
//  DwollaOAuthTests
//
//  Created by James Armstead on 12/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

@interface DwollaAPI_Base_Test : GHTestCase {}
@property (retain) DwollaAPI *dwollaAPI;
@property (retain) id mockTokenRepository;
@property (retain) id mockHttpRequestRepository;
@property (retain) id mockHttpRequestHelper;
@property (retain) id mockNSURLConnectionRepository;

- (void) Setup_WithAccessToken_ClientKey_ClientSecret;
- (void) Setup_PostRequest_WithDictionary: (NSDictionary *) result;
- (void) Setup_GetRequest_WithDictionary: (NSDictionary *) result;
- (void) Setup_HttpRequestRepository_WithNSURLConnectionRepositoryMock_WithResponseDictionary:(NSDictionary*) responseDictionary
                                                                                 withRequest:(NSMutableURLRequest*) request;
- (NSMutableArray *)Get_Mocked_DwollaContacts;
- (NSMutableArray *)Get_Mocked_DwollaContactsResponse;

@end
