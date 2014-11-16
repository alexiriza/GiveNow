//
//  HttpRequestHelper_Tests.m
//  DwollaOAuth
//
//  Created by James Armstead on 12/19/12.
//
//

#import "HttpRequestHelper.h"
#import <GHUnitIOS/GHUnit.h>

@interface HttpRequestHelper_Tests : GHTestCase {}
@property (retain) HttpRequestHelper *httpRequestHelper;
@end

@implementation HttpRequestHelper_Tests


- (void)setUp
{
    [super setUp];
    self.httpRequestHelper = [[HttpRequestHelper alloc] init];
}

- (void)tearDown
{
    // Tear-down code here.
    [super tearDown];
}


-(void)testgetJSONDataFromNsDictionary_WithValidDictionary_ShouldReturnValidJSON
{
    NSMutableDictionary* parameterDictionary = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                                @"1111", @"pin",
                                                @"812-111-1111", @"destinationId",
                                                @"1.00", @"amount", nil];
    
    NSData* theData = [self.httpRequestHelper getJSONDataFromNsDictionary: parameterDictionary];
    
    NSString* jsonString = [[NSString alloc] initWithData:theData
                                             encoding:NSUTF8StringEncoding];
    
    GHAssertTrue([jsonString isEqualToString: @"{\"pin\":\"1111\",\"destinationId\":\"812-111-1111\",\"amount\":\"1.00\"}"], @"JSON data does not match");
}

-(void)testgetQueryParametersFroNSDictionary_WithValidDictionary_ShouldReturnValidQueryString
{
    NSDictionary* parameterDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                @"hot", @"dog",
                                                @"schonfeld", @"michael",
                                                @"awesome", @"dwolla", nil];
    
    NSString* queryString = [self.httpRequestHelper getQueryParametersFroNSDictionary:parameterDictionary];
    
    GHAssertTrue([queryString isEqualToString:@"dog=hot&michael=schonfeld&dwolla=awesome"], @"Query string was not generated correctly");
}

-(void)testgetQueryParametersFroNSDictionary_WithCharacterNeedingEncoded_ShouldReturnValidQueryString
{
    NSDictionary* parameterDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:
                                         @"h/o$t", @"dog",
                                         @"schonfeld", @"michael",
                                         @"awesome", @"dwolla", nil];
    
    NSString* queryString = [self.httpRequestHelper getQueryParametersFroNSDictionary:parameterDictionary];
    
    GHAssertEqualStrings(queryString, @"dog=h%2Fo%24t&michael=schonfeld&dwolla=awesome", @"Query string was not generated correctly");
}

@end
