//
//  ETHTTPUtility.h
//  ETStampMG
//
//  Created by Eten on 10. 12. 20..
//  Copyright 2010 Korea University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

#define SET_URL(URL_PRE) url = [NSString stringWithFormat:@"%@%@", URL_PRE, url];
#define HTTP_TimeInterval 10.0f

@protocol ETHTTPUtilityDelegate;

@interface ETHTTPUtility : NSObject {
    id target;
	SEL selector;
    
    NSDictionary *bodyObject;
    
	NSMutableData *receivedData;
	NSURLResponse *response;
	NSString *result;
    NSMutableString *mtbSource;
    NSArray *xmlRawData;
}

- (BOOL)sendURL:(NSString *)url ToServerURLPre:(NSString *)urlPre InMethod:(NSString *)method WithSession:(BOOL)withSession;
+ (BOOL)isMethodValid:(NSString *)method;

- (BOOL)getFromURL:(NSString *)url ToServerURLPre:(NSString *)urlPre WithSession:(BOOL)session;
- (BOOL)deleteFromURL:(NSString *)url ToServerURLPre:(NSString *)urlPre WithSession:(BOOL)session;

#pragma mark - JSON 응답값 조회
+ (id)parseData:(NSData *)jsonData Type:(NSString *)type Log:(BOOL)showLog;
+ (id)parseString:(NSData *)jsonData Type:(NSString *)type Log:(BOOL)showLog;

//- (BOOL)requestUrl:(NSString *)url bodyObject:(NSDictionary *)bodyObject; 
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)aResponse; 
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data; 
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error; 
- (void)connectionDidFinishLoading:(NSURLConnection *)connection; 
- (void)setDelegate:(id)aTarget selector:(SEL)aSelector; 
- (NSString *)getXMLData:(NSString *)source;

@property (readwrite) id target;
@property (readwrite) SEL selector;

@property (readwrite) NSDictionary *bodyObject;

@property (readwrite) NSMutableData *receivedData;
@property (readwrite) NSURLResponse *response;
@property (readwrite) NSString *result;

@property (assign, readwrite) id<ETHTTPUtilityDelegate> httpDelegate;

@end


@protocol ETHTTPUtilityDelegate <NSObject>

- (void)sendStatusCode:(NSInteger)code;

@end
