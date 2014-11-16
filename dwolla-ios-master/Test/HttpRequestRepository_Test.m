//
//  HttpRequestRepository_Test.m
//  DwollaOAuth
//
//  Created by James Armstead on 12/19/12.
//
//

#import <OCMock/OCMock.h>
#import <GHUnitIOS/GHUnit.h>
#import "HttpRequestRepository.h"

@interface HttpRequestRepository_Test : GHTestCase {}
@property (retain) HttpRequestRepository *httpRequestRepository;
@property (retain) id mockHttpRequestHelper;
@property (retain) id mockNSURLConnectionRepository;
@end

@implementation HttpRequestRepository_Test

@synthesize httpRequestRepository, mockHttpRequestHelper;

- (void)setUp
{
    [super setUp];
    self.httpRequestRepository = [[HttpRequestRepository alloc] init];
    self.mockHttpRequestHelper = [OCMockObject mockForClass:[HttpRequestHelper class]];
    self.mockNSURLConnectionRepository = [OCMockObject mockForClass:[NSURLConnectionRepository class]];
    
    [httpRequestRepository setHttpRequestHelper:self.mockHttpRequestHelper];
    [httpRequestRepository setNsURLConnectionRepository:self.mockNSURLConnectionRepository];
}

- (void)tearDown
{
    // Tear-down code here.
    [super tearDown];
}

-(void) Setup_NSURLConnectionRepository_WithResponseDictionary:(NSDictionary*) responseDictionary
{
    [[[self.mockNSURLConnectionRepository stub] andReturn:responseDictionary] sendSynchronousRequest:OCMOCK_ANY];
}

-(void)testSend_WithValidData_ShouldGetJSONData
{
    [self Setup_NSURLConnectionRepository_WithResponseDictionary:[[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                                                  @"false", @"Success",
                                                                  @"", @"Response", nil]];
    
    NSMutableDictionary* parameterDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                                @"1111", @"pin",
                                                @"812-111-1111", @"destinationId",
                                                @"1.00", @"amount",
                                                @"dwolla", @"destinationType", nil];
    
    [[self.mockHttpRequestHelper expect] getJSONDataFromNsDictionary: parameterDictionary];
    [[[self.mockHttpRequestHelper stub] andReturn:[[NSDictionary alloc]init]] checkRequestForSuccessAndReturn:OCMOCK_ANY];
    
    [httpRequestRepository postRequest:@"TestURL" withParameterDictionary:parameterDictionary];
    
    [self.mockHttpRequestHelper verify];
}

@end
