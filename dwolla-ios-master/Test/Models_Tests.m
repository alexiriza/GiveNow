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



@interface Models_Tests : GHTestCase {}
@property (retain) DwollaAPI *dwollaAPI;
@property (retain) HttpRequestHelper *httpRequestHelper;
@property (retain) id mockTokenRepository;
@property (retain) id mockHttpRequestRepository;
@end

@implementation Models_Tests

@synthesize dwollaAPI, mockTokenRepository, mockHttpRequestRepository;

- (void)setUp
{
    [super setUp];
    self.dwollaAPI = [DwollaAPI sharedInstance];
    self.mockTokenRepository = [OCMockObject mockForClass:[OAuthTokenRepository class]];
    self.mockHttpRequestRepository = [OCMockObject mockForClass:[HttpRequestRepository class]];
    self.httpRequestHelper = [[HttpRequestHelper alloc] init];
    
    [dwollaAPI setOAuthTokenRepository:self.mockTokenRepository];
    [dwollaAPI setHttpRequestRepository:self.mockHttpRequestRepository];
    [dwollaAPI setHttpRequestHelper:self.httpRequestHelper];
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

- (void) Setup_GetRequestWithParameterDictionary_WithDictionary: (NSDictionary *) result {
    [[[self.mockHttpRequestRepository stub] andReturn:result] getRequest:OCMOCK_ANY withQueryParameterDictionary:OCMOCK_ANY];
}

- (NSDictionary*) GetTransactionResponseDictionary {
    return [[NSDictionary alloc] initWithObjectsAndKeys:@"true", @"Success", @"Success", @"Message",
                            [[NSArray alloc]initWithObjects:[self GetTransactionDictionary], nil], @"Response", nil];
}

- (NSDictionary*) GetContactsDictionary {
    return [[NSDictionary alloc] initWithObjectsAndKeys:@"true", @"Success", @"Success", @"Message",
                            [[NSArray alloc] initWithObjects:
                             [[NSDictionary alloc] initWithObjectsAndKeys:@"Ben Facebook Test", @"Name", @"12345", @"Id", @"Facebook", @"Type", @"", @"Image", @"Des Moines", @"City", @"IA", @"State", nil],
                             [[NSDictionary alloc] initWithObjectsAndKeys:@"Ben Dwolla Test", @"Name", @"812-111-111", @"Id", @"Dwolla", @"Type", @"", @"Image", @"Des Moines", @"City", @"IA", @"State", nil], nil], @"Response", nil];
}

- (NSDictionary *) GetTransactionDictionary {
    return [[NSDictionary alloc] initWithObjectsAndKeys:
    @"1.91", @"Amount",
    @"7/18/2012 1:45:36 PM", @"Date",
    @"money_sent", @"Type",
    @"Dwolla", @"UserType",
    @"812-737-5434", @"DestinationId",
    @"Timbuktuu Coffee", @"DestinationName",
    @"", @"SourceId",
    @"", @"SourceName",
    @"", @"ClearingDate",
    @"From iPhone", @"Notes",
    @"1226108", @"Id",
    @"processed", @"Status",
    nil];
}

- (NSMutableArray *)Get_Mocked_DwollaContacts
{
    DwollaContact* one = [[DwollaContact alloc] initWithUserID:@"12345" name:@"Ben Facebook Test" image:@"" city:@"Des Moines" state:@"IA" type:@"Facebook" address:@"" longitude:@"" latitude:@""];
    
    DwollaContact* two = [[DwollaContact alloc] initWithUserID:@"812-111-111" name:@"Ben Dwolla Test" image:@"" city:@"Des Moines" state:@"IA" type:@"Dwolla" address:@"" longitude:@"" latitude:@""];
    
    return [[NSMutableArray alloc] initWithObjects:one, two, nil];
}


-(void)testSend_WithSuccessfulResponse_ShouldReturnValidTransactionId
{
    [self Setup_WithAccessToken_ClientKey_ClientSecret];
    NSDictionary* result = [[NSDictionary alloc] initWithObjectsAndKeys:@"true", @"Success", @"Success", @"Message", @"12345", @"Response",  nil];
    [self Setup_PostRequest_WithDictionary:result];
    
    
    NSString* response = [dwollaAPI sendMoneyWithPIN:@"5211" destinationID:@"812-111-1111" destinationType:@"dwolla" amount:@"0.00" facilitatorAmount:@"" assumeCosts:@"" notes:@"" fundingSourceID:@""];
    GHAssertTrue([response isEqualToString:@"12345"],@"INCORRECT ID");
}
-(void)testRequest_WithSuccessfulResponse_ShouldReturnValidRequestId
{
    [self Setup_WithAccessToken_ClientKey_ClientSecret];
    NSDictionary* result = [[NSDictionary alloc] initWithObjectsAndKeys:@"true", @"Success", @"Success", @"Message", @"12345", @"Response", nil];
    [self Setup_PostRequest_WithDictionary:result];
    
    NSString* response = [dwollaAPI requestMoneyWithPIN:@"5211" sourceID:@"812-111-1111" sourceType:@"dwolla" amount:@"1.00" facilitatorAmount:@"" notes:@""];
    GHAssertTrue([response isEqualToString:@"12345"],@"INCORRECT ID");
}

-(void)testGetBalance_WithSuccessfulResponse_ShouldReturnValidBalance
{
    [self Setup_WithAccessToken_ClientKey_ClientSecret];
    NSDictionary* result = [[NSDictionary alloc] initWithObjectsAndKeys:@"true", @"Success", @"Success", @"Message", @"55.76", @"Response", nil];
    [self Setup_GetRequest_WithDictionary:result];
    
    float response = [dwollaAPI getBalance];
    float expected_balance = 55.76;
    
    GHAssertTrue((response == expected_balance),@"INCORRECT AMOUNT");
}


-(void)testGetContacts_WithSuccessfulResponse_ShouldReturnValidContacts
{
    [self Setup_WithAccessToken_ClientKey_ClientSecret];
    [self Setup_GetRequestWithParameterDictionary_WithDictionary: [self GetContactsDictionary]];
    
    NSMutableArray* actual = [dwollaAPI getContactsByName:@"" types:@"" limit:@""];
    NSMutableArray *expecting = [self Get_Mocked_DwollaContacts];
    
    DwollaContact* expecting1 = [expecting objectAtIndex:0];
    DwollaContact* expecting2 = [expecting objectAtIndex:1];
 
    DwollaContact* actual1 = [actual objectAtIndex:0];
    DwollaContact* actual2 = [actual objectAtIndex:1];
    
    GHAssertTrue([expecting1 isEqualTo:actual1],@"NOT EQUAL!");
    GHAssertTrue([expecting2 isEqualTo:actual2],@"NOT EQUAL!");
}

-(void)testGetNearby_WithSuccessfulResponse_ShouldReturnValidContacts
{
    [self Setup_WithAccessToken_ClientKey_ClientSecret];
    [self Setup_GetRequestWithParameterDictionary_WithDictionary:[self GetContactsDictionary]];

    NSMutableArray* actual = [dwollaAPI getNearbyWithLatitude:@"10.00" Longitude:@"10.00" Limit:@"" Range:@""];
    NSMutableArray* expecting = [self Get_Mocked_DwollaContacts];
    
    DwollaContact* expecting1 = [expecting objectAtIndex:0];
    DwollaContact* expecting2 = [expecting objectAtIndex:1];
    
    DwollaContact* actual1 = [actual objectAtIndex:0];
    DwollaContact* actual2 = [actual objectAtIndex:1];
    
    GHAssertTrue([expecting1 isEqualTo:actual1],@"NOT EQUAL!");
    GHAssertTrue([expecting2 isEqualTo:actual2],@"NOT EQUAL!");
}

-(void)testGetFundingSources_WithSuccessfulResponse_ShouldReturnValidFundingSources
{
    [self Setup_WithAccessToken_ClientKey_ClientSecret];
    
    NSDictionary* result = [[NSDictionary alloc] initWithObjectsAndKeys:@"true", @"Success", @"Success", @"Message",
                            [[NSArray alloc] initWithObjects:[[NSDictionary alloc] initWithObjectsAndKeys:
                                                              @"TVmMwlKz1z6HmOK1np8NFA==", @"Id",
                                                              @"Donations Collection Fund - Savings", @"Name",
                                                              @"Savings", @"Type",
                                                              @"true", @"Verified",
                                                              nil], nil], @"Response", nil];

    [self Setup_GetRequest_WithDictionary:result];
    
    NSArray* actual = [self.dwollaAPI getFundingSources];
    
    DwollaFundingSource* expectedSource = [[DwollaFundingSource alloc] initWithSourceID:@"TVmMwlKz1z6HmOK1np8NFA==" name:@"Donations Collection Fund - Savings" type:@"Savings" verified:@"true"];
    
    DwollaFundingSource* actualSource = [actual objectAtIndex:0];

    GHAssertEqualStrings([actualSource sourceID], [expectedSource sourceID], @"Id expected does not match");
    GHAssertEqualStrings([actualSource name], [expectedSource name], @"Name expected does not match");
    GHAssertEqualStrings([actualSource type], [expectedSource type], @"Type expected does not match");
    GHAssertTrue([actualSource isVerified], @"Verified expected does not match");
}

-(void)testGetFundingSource_WithValidFundingSource_ShouldReturnValidFundingSource
{
    [self Setup_WithAccessToken_ClientKey_ClientSecret];
    
    NSDictionary* result = [[NSDictionary alloc] initWithObjectsAndKeys:@"true", @"Success", @"Success", @"Message",
                            [[NSDictionary alloc] initWithObjectsAndKeys:
                                                              @"TVmMwlKz1z6HmOK1np8NFA==", @"Id",
                                                              @"Donations Collection Fund - Savings", @"Name",
                                                              @"Savings", @"Type",
                                                              @"true", @"Verified",
                                                              nil], @"Response", nil];
    
    [self Setup_GetRequest_WithDictionary: result];
    
    DwollaFundingSource* actual = [dwollaAPI getFundingSource:@"123"];
    
    DwollaFundingSource* expected = [[DwollaFundingSource alloc] initWithSourceID:@"TVmMwlKz1z6HmOK1np8NFA==" name:@"Donations Collection Fund - Savings" type:@"Savings" verified:@"true"];
    
    
    GHAssertEqualStrings([actual sourceID], [expected sourceID], @"Id expected does not match");
    GHAssertEqualStrings([actual name], [expected name], @"Name expected does not match");
    GHAssertEqualStrings([actual type], [expected type], @"Type expected does not match");
    GHAssertTrue([actual isVerified], @"Verified expected does not match");
}

-(void)testGetAccountInfo_WithSuccessfulResponse_ShouldReturnValidAccountInformation
{
    [self Setup_WithAccessToken_ClientKey_ClientSecret];
    
    NSDictionary* result = [[NSDictionary alloc] initWithObjectsAndKeys:@"true", @"Success", @"Success", @"Message",
                            [[NSDictionary alloc] initWithObjectsAndKeys:
                                                              @"Ames", @"City",
                                                              @"IA", @"State",
                                                              @"Personal", @"Type",
                                                              @"812-570-5285", @"Id",
                                                              @"Nick Schulze", @"Name",
                                                              @"0", @"Latitude",
                                                              @"0", @"Longitude",
                                                              nil], @"Response", nil];
    [self Setup_GetRequest_WithDictionary:result];    
    
    DwollaUser* user = [dwollaAPI getAccountInfo];
    
    DwollaUser* user2 = [[DwollaUser alloc] initWithUserID:@"812-570-5285" name:@"Nick Schulze" city:@"Ames" state:@"IA" latitude:@"41.584546" longitude:@"-93.634167" type:@"Personal"];
    
    GHAssertTrue([user isEqualTo:user2], @"NOT EQUAL");
}


-(void)testGetBasicAccountInfo_WithSuccessfulResponse_ShouldReturnValidBasicAccountInformation
{
    [self Setup_WithAccessToken_ClientKey_ClientSecret];
    
    NSDictionary* result = [[NSDictionary alloc] initWithObjectsAndKeys:@"true", @"Success", @"Success", @"Message",
                            [[NSDictionary alloc] initWithObjectsAndKeys:
                             @"Personal", @"Type",
                             @"812-570-5285", @"Id",
                             @"Nick Schulze", @"Name",
                             @"0", @"Latitude",
                             @"0", @"Longitude",
                             nil], @"Response", nil];

    [self Setup_GetRequest_WithDictionary:result];
    
    DwollaUser* user = [dwollaAPI getBasicInfoWithAccountID:@"1"];
    
    DwollaUser* user2 = [[DwollaUser alloc] initWithUserID:@"812-570-5285" name:@"Nick Schulze" city:nil state:nil latitude:@"0" longitude:@"0" type:nil];
    
    GHAssertTrue([user isEqualTo:user2], @"NOT EQUAL");
}

-(void)testGetTransactions_WithSuccessfulResponse_ShouldReturnValidTransactions
{
    [self Setup_WithAccessToken_ClientKey_ClientSecret];
    [self Setup_GetRequestWithParameterDictionary_WithDictionary:[self GetTransactionResponseDictionary]];
    
    NSArray* transactions = [dwollaAPI getTransactionsSince:@"" withType:@"" withLimit:@"" withSkip:@""];
    
    DwollaTransaction* actual = [transactions objectAtIndex:0];
    
    DwollaTransaction* expected = [[DwollaTransaction alloc] initWithAmount:@"1.91" clearingDate:@"" date:@"7/18/2012 1:45:36 PM" destinationID:@"812-737-5434" destinationName:@"Timbuktuu Coffee" transactionID:@"1226108" notes:@"From iPhone" sourceID:@"" sourceName:@"" status:@"processed" type:@"money_sent" userType:@"Dwolla"];
    
    GHAssertEqualStrings([actual amount], [expected amount], @"Amount expected does not match");
    GHAssertEqualStrings([actual clearingDate], [expected clearingDate], @"Clearing Date expected does not match");
    GHAssertEqualStrings([actual date], [expected date], @"Date expected does not match");
    GHAssertEqualStrings([actual destinationID], [expected destinationID], @"Destination Id expected does not match");
    GHAssertEqualStrings([actual destinationName], [expected destinationName], @"Destination Name expected does not match");
    GHAssertEqualStrings([actual transactionID], [expected transactionID], @"Transaction Id expected does not match");
    GHAssertEqualStrings([actual notes], [expected notes], @"Notes expected does not match");
    GHAssertEqualStrings([actual sourceID], [expected sourceID], @"Source Id expected does not match");
    GHAssertEqualStrings([actual sourceName], [expected sourceName], @"Source Name expected does not match");
    GHAssertEqualStrings([actual status], [expected status], @"Status expected does not match");
    GHAssertEqualStrings([actual type], [expected type], @"Type expected does not match");
    GHAssertEqualStrings([actual userType], [expected userType], @"User Type expected does not match");
}

-(void)testGetTransaction_WithSuccessfulResponse_ShouldReturnValidTransaction
{
    [self Setup_WithAccessToken_ClientKey_ClientSecret];
    [self Setup_GetRequest_WithDictionary:[[NSDictionary alloc]
                                           initWithObjectsAndKeys:
                                           @"true", @"Success",
                                           @"Success", @"Message",
                                           [self GetTransactionDictionary], @"Response", nil]];

    DwollaTransaction* transaction = [dwollaAPI getTransaction:@""];
    
    DwollaTransaction* transaction2 = [[DwollaTransaction alloc] initWithAmount:@"1.91" clearingDate:@"" date:@"7/18/2012 1:45:36 PM" destinationID:@"812-737-5434" destinationName:@"Timbuktuu Coffee" transactionID:@"1226108" notes:@"" sourceID:@"" sourceName:@"" status:@"processed" type:@"money_sent" userType:@"Dwolla"];
    
    GHAssertTrue([transaction isEqualTo:transaction2], @"NOT EQUAL");
}

-(void)testGetTransactionStats_WithSuccessfulResponse_ShouldReturnValidTransactionStats
{
    [self Setup_WithAccessToken_ClientKey_ClientSecret];
    
    NSDictionary* result = [[NSDictionary alloc] initWithObjectsAndKeys:@"true", @"Success", @"Success", @"Message",
                            [[NSDictionary alloc] initWithObjectsAndKeys:
                             @"1", @"TransactionsCount",
                             @"0.3", @"TransactionsTotal",
                             nil], @"Response", nil];
    
    [self Setup_GetRequestWithParameterDictionary_WithDictionary:result];
    
    DwollaTransactionStats* stats = [dwollaAPI getTransactionStatsWithStart:@"" withEnd:@"" withTypes:@""];
    
    DwollaTransactionStats* stats2 = [[DwollaTransactionStats alloc] initWithSuccess:YES count:@"1" total:@"0.3"];
    
    GHAssertTrue([stats isEqualTo:stats2], @"NOT EQUAL");
}


@end
