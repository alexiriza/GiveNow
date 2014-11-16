#ios-sdk-oauth2: iOS SDK for Dwolla's API
=================================================================================

## Version

1.0

## Requirements
- [iOS Developer License](https://developer.apple.com/devcenter/ios/index.action)
- [Dwolla Application](https://www.dwolla.com/applications)

## Installation

- Download XCode 4 (https://developer.apple.com/xcode/index.php)
- Add repo as submodule
- Add DwollaOAuth project as subproject to application
- Add DwollaOAuthLib as a target dependency in "Build Phases"
- Add libDwollaOAuthLib.a to "Link Binaries with Libraries" in "Build Phases"
- Add $(SRCROOT)/dwolla-ios/DwollaOAuthLib to "Header Search Paths" (select recursive)

## Usage

```objective-c
  NSArray *scopes = [[NSArray alloc] initWithObjects:@"send", @"balance", @"accountinfofull", @"contacts", @"funding",  @"request", @"transactions", nil];
    DwollaOAuth2Client *client = [[DwollaOAuth2Client alloc] initWithFrame:CGRectMake(0, 0, 320, 460) key:@"key goes here" secret:@"secret goes here" redirect:@"https://www.dwolla.com" response:@"code" scopes:scopes view:self.view reciever:self];
    [client login];
    
    NSString* balance = [DwollaAPI getBalance];
```

## Examples / Quickstart

This repo includes various usage examples, including:

* Authenticating with OAuth [ViewController.m]
* Sending money [APIViewController.m]
* Fetching account information [APIViewController.m]
* Grabbing a user's contacts [APIViewController.m]
* Listing a user's funding sources [APIViewController.m]
* Registering a new Dwolla user account [APIViewController.m]

## Methods

DwollaOAuth2Client class:

    -(id)initWithFrame:(CGRect)frame key:(NSString*)key secret:(NSString*)secret redirect:(NSString*)redirect response:(NSString*)response scopes:(NSArray*)scopes view:(UIView*)view reciever:(id<IDwollaMessages>)receiver; ==> (DwollaOauth2Client*) instance of DwollaOAuth2Client
    -(BOOL)isAuthorized;               ==> (BOOL) YES if valid access token is present
    -(void)login;  				       ==> (void) performs a login operation for the user
    -(void)logout;					   ==> (void) performs a logout operation for the user

DwollaAPI class:

    +(BOOL)hasToken;                   ==> (BOOL) YES if valid access token is present
    +(NSString*)getAccessToken;        ==> (NSString*) a string representing the access token
    +(void)setAccessToken:(NSString*) token;    ==> (void) sets the access token
    +(void)clearAccessToken;	       ==> (void) clears the access token
    +(NSString*)sendMoneyWithPIN:(NSString*)pin destinationID:(NSString*)destinationID destinationType:(NSString*)type amount:(NSString*)amount facilitatorAmount:(NSString*)facAmount assumeCosts:(NSString*)assumeCosts notes:(NSString*)notes fundingSourceID:(NSString*)fundingID;       ==> (NSString*) string representing the transaction id
	+(NSString*)requestMoneyWithPIN:(NSString*)pin  sourceID:(NSString*)sourceID sourceType:(NSString*)type  amount:(NSString*)amount facilitatorAmount:(NSString*)facAmount notes:(NSString*)notes;    ==> (NSString*) string representing the request id
    +(NSDictionary*)getJSONBalance;    ==> (NSDictionary*) JSON representation of the request
    +(NSString*)getBalance;            ==> (NSString*) string representation of the balance
    +(NSDictionary*)getJSONContactsByName:(NSString*)name  types:(NSString*)types limit:(NSString*)limit;   ==> (NSDictionary*) JSON representation of the request 
	+(DwollaContacts*)getContactsByName:(NSString*)name  types:(NSString*)types limit:(NSString*)limit;    ==> (DwollaContacts*) a DwollaContacts object containing the results of the request
	+(NSDictionary*)getJSONNearbyWithLatitude:(NSString*)lat  Longitude:(NSString*)lon Limit:(NSString*)limit Range:(NSString*)range;  ==> (NSDictionary*) JSON representation of the request
	+(DwollaContacts*)getNearbyWithLatitude:(NSString*)lat  Longitude:(NSString*)lon Limit:(NSString*)limit Range:(NSString*)range   ==> (DwollaContacts*) a DwollaContacts object containing the results of the request     
	+(NSDictionary*)getJSONFundingSources;  ==> (NSDictionary*) JSON representation of the request
	+(DwollaFundingSources*)getFundingSources;   ==> (DwollaFundingSources*) a DwollaFundingSources object containing the results of the request
	+(NSDictionary*)getJSONFundingSource:(NSString*)sourceID;   ==> (NSDictionary*) JSON representation of the request
	+(DwollaFundingSource*)getFundingSource:(NSString*)sourceID;   ==> (DwollaFundingSource*) a DwollaFundingSource object containing the result of the request
	+(NSDictionary*)getJSONAccountInfo;  ==> (NSDictionary*) JSON representation of the request
	+(DwollaUser*)getAccountInfo;      ==> (DwollaUser*) a DwollaUser object containing the result of the request
	+(NSDictionary*)getJSONBasicInfoWithAccountID:(NSString*)accountID;   ==> (NSDictionary*)  JSON representation of the request
	+(DwollaUser*)getBasicInfoWithAccountID:(NSString*)accountID;   ==> (DwollaUser*) a DwollaUser object containing the result of the request
	+(DwollaUser*)registerUserWithEmail:(NSString*)email  password:(NSString*)password  pin:(NSString*)pin firstName:(NSString*)first lastName:(NSString*)last address:(NSString*)address address2:(NSString*)address2 city:(NSString*)city state:(NSString*)state zip:(NSString*)zip phone:(NSString*)phone birthDate:(NSString*)dob type:(NSString*)type organization:(NSString*)organization ein:(NSString*)ein acceptTerms:(BOOL)accept;  ==> (DwollaUser*) a DwollaUser object containing the result of the request
	+(NSDictionary*)getJSONTransactionsSince:(NSString*)date limit:(NSString*)limit skip:(NSString*)skip;  ==> (NSDictionary*) JSON representation of the request
	+(DwollaTransactions*)getTransactionsSince:(NSString*)date limit:(NSString*)limit skip:(NSString*)skip;   ==> (DwollaTransactions*) a DwollaTransactions object contiaining the results of the request
	+(NSDictionary*)getJSONTransaction:(NSString*)transactionID;  ==> (NSDictionary*) JSON representation of the request
	+(NSDictionary*)getTransaction:(NSString*)transactionID;  ==> (DwollaTransaction*) a DwollaTransaction object containing the result of the request
	+(NSDictionary*)getJSONTransactionStats:(NSString*)start end:(NSString*)end;  ==> (NSDictionary*) JSON representation of the request 
	+(DwollaTransactionStats*)getTransactionStats:(NSString*)start end:(NSString*)end;  ==> (DwollaTransactionStats*) a DwollaTransactionStats object containing the results of the request
                            
DwollaContacts class:
    
    -(id)initWithSuccess:(BOOL)success contacts:(NSMutableArray*)contacts; ==> (DwollaContacts*) a DwollaContacts object
    -(BOOL)getSuccess; 			==> (BOOL) success of the request
    -(NSMutableArray*)getAll;   ==> (NSMutableArray*) an array of the contacts returned by the request
    -(NSMutableArray*)getAlphabetized:(NSString*)direction;    ==> (NSMutableArray*) a sorted array of contacts
	-(DwollaContact*)getObjectAtIndex:(int)index;   ==> (DwollaContact*) the contact at the given index
	-(int) count;   	==> (int) count of contacts returned by the request
	-(BOOL) isEqualTo:(DwollaContacts*)_contacts;   ==> (BOOL) returns YES if DwollaContacts object are equal

DwollaContact class:
    
    -(id)initWithUserID:(NSString*)userID name:(NSString*)name image:(NSString*)image city:(NSString*)city  state:(NSString*)state  type:(NSString*)type; ==> (DwollaContact*) a DwollaContact object
    -(NSString*)getName; 		==> (NSString*) name of the DwollaContact
    -(NSString*)getUserID;      ==> (NSString*) userID of the DwollaContact
    -(NSString*)getImageURL;    ==> (NSString*) imageURL of the DwollaContact
	-(NSString*)getCity;   	    ==> (NSString*) city of the DwollaContact
	-(NSString*)getState;   	==> (NSString*) state of the DwollaContact
	-(NSString*)getType;   		==> (NSString*) type of the DwollaContact
	-(BOOL) isEqualTo:(DwollaContact*)_contact;   ==> (BOOL) returns YES if DwollaContact object 
	
DwollaFundingSources class:
    
    -(id)initWithSuccess:(BOOL)success sources:(NSMutableArray*)sources; ==> (DwollaFundingSources*) a DwollaFundingSources object
    -(BOOL)getSuccess; 			==> (BOOL) success of the request
    -(NSMutableArray*)getAll;   ==> (NSMutableArray*) an array of the sources returned by the request
    -(NSMutableArray*)getAlphabetized:(NSString*)direction;    ==> (NSMutableArray*) a sorted array of sources
	-(DwollaFundingSource*)getObjectAtIndex:(int)index;   ==> (DwollaFundingSource*) the source at the given index
	-(int) count;   	==> (int) count of sources returned by the request
	-(BOOL) isEqualTo:(DwollaFundingSources*)_sources;   ==> (BOOL) returns YES if DwollaFundingSources object 

DwollaFundingSource class:
    
    -(id)initWithSourceID:(NSString*)userID name:(NSString*)name type:(NSString*)type verified:(NSString*)verified  ==> (DwollaFundingSource*) a DwollaFundingSource object
    -(NSString*)getName; 		==> (NSString*) name of the DwollaFundingSource
    -(NSString*)getSourceID;    ==> (NSString*) userID of the DwollaFundingSource
	-(NSString*)getType;   		==> (NSString*) type of the DwollaFundingSource
	-(BOOL)isVerified;   		==> (BOOL) YES if the DwollaFundingSource is verified
	-(BOOL) isEqualTo:(DwollaFundingSource*)_source;   ==> (BOOL) returns YES if DwollaFundingSource object 

DwollaUser class:
    
    -(id)initWithUserID:(NSString*)userID name:(NSString*)name city:(NSString*)city  state:(NSString*)state latitude:(NSString*)latitude longitude(NSString*)longitude type:(NSString*)type; ==> (DwollaUser*) a DwollaUser object
    -(NSString*)getName; 		==> (NSString*) name of the DwollaUser
    -(NSString*)getUserID;      ==> (NSString*) userID of the DwollaUser
	-(NSString*)getCity;   	    ==> (NSString*) city of the DwollaUser
	-(NSString*)getState;   	==> (NSString*) state of the DwollaUser
	-(NSString*)getType;   		==> (NSString*) type of the DwollaUser
	-(NSString*)getLongitude;   ==> (NSString*) longitude of the DwollaUser
	-(NSString*)getLatitude;   	==> (NSString*) latitude of the DwollaUser
	-(BOOL) isEqualTo:(DwollaUser*)_user;   ==> (BOOL) returns YES if DwollaUser objects are equal 
	
DwollaTransactions class:
    
    -(id)initWithSuccess:(BOOL)success transactions:(NSMutableArray*)transactions; ==> (DwollaTransactions*) a DwollaTransactions object
    -(BOOL)getSuccess; 			==> (BOOL) success of the request
    -(NSMutableArray*)getAll;   ==> (NSMutableArray*) an array of the transactions returned by the request
    -(NSMutableArray*)getAlphabetized:(NSString*)direction;    ==> (NSMutableArray*) a sorted array of transactions
	-(DwollaTransaction*)getObjectAtIndex:(int)index;   ==> (DwollaTransaction*) the transaction at the given index
	-(int) count;   	==> (int) count of transactions returned by the request
	-(BOOL) isEqualTo:(DwollaTransactions*)_transactions;   ==> (BOOL) returns YES if DwollaTransactions object 
	
DwollaTransaction class:
    
	-(id)initWithAmount:(NSString*)_amount clearingDate:(NSString*)_clearingDate date:(NSString*)_date destinationID:(NSString*)_destinationID destinationName:(NSString*)_destinationName transactionID:(NSString*)_transactionID notes:(NSString*)_notes sourceID:(NSString*)_sourceID sourceName:(NSString*)_sourceName status:(NSString*)_status type:(NSString*)_type userType:(NSString*)_userType   ==> (DwollaTransaction*) a DwollaTransaction object
	-(NSString*)getAmount; 		==> (NSString*) amount of the DwollaTransaction
    -(NSString*)getTransactionID;      ==> (NSString*) transactionID of the DwollaTransaction
	-(NSString*)getDestinationID;   	    ==> (NSString*) destinationID of the DwollaTransaction
	-(NSString*)getClearingDate;   	==> (NSString*) clearingDate of the DwollaTransaction
	-(NSString*)getDate;   		==> (NSString*) date of the DwollaTransaction
	-(NSString*)getDestinationName;   ==> (NSString*) destinationName of the DwollaTransaction
	-(NSString*)getNotes;   	==> (NSString*) notes of the DwollaTransaction
	-(NSString*)getSourceID;   	    ==> (NSString*) sourceID of the DwollaTransaction
	-(NSString*)getSourceName;   	==> (NSString*) sourceName of the DwollaTransaction
	-(NSString*)getStatus;   		==> (NSString*) status of the DwollaTransaction
	-(NSString*)getType;   ==> (NSString*) type of the DwollaTransaction
	-(NSString*)getUserType;   	==> (NSString*) userType of the DwollaTransaction
	-(BOOL) isEqualTo:(DwollaTransaction*)_transaction;   ==> (BOOL) returns YES if DwollaTransaction objects are equal 
	
DwollaTransactionStats class:
    
    -(id)initWithSuccess:(BOOL)_success count:(NSString*)_count total:(NSString*)_total; ==> (DwollaTransactionStats*) a DwollaTransactionStats object
    -(BOOL)wasSuccessful; 			==> (BOOL) success of the request
    -(NSString*)getCount;    ==> (NSString*) count of the DwollaTransactionStats
    -(NSString*)getTotal;    ==> (NSString*) total of DwollaTransactionStats 
	-(BOOL) isEqualTo:(DwollaTransactionStats*)_stats;   ==> (BOOL) returns YES if DwollaTransactionStats object 

## Sandbox

For Sandbox support, edit `Constants.m` and change the URL of `DWOLLA_API_BASEURL` to the following:

```Objective-C
static NSString *DWOLLA_API_BASEURL = @"https://uat.dwolla.com/oauth/rest";
```

## Credits

- Nick Schulze &lt;nicks@dwolla.com&gt;
- Michael Schonfeld &lt;michael@dwolla.com&gt;

## Support

- Dwolla API &lt;api@dwolla.com&gt;
- Nick Schulze &lt;nicks@dwolla.com&gt;
- Michael Schonfeld &lt;michael@dwolla.com&gt;

## References / Documentation

http://developers.dwolla.com/dev

## License 

(The MIT License)

Copyright (c) 2012 Dwolla &lt;nicks@dwolla.com&gt;

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
