//
//  ETHTTPUtility.m
//  ETStampMG
//
//  Created by Eten on 10. 12. 20..
//  Copyright 2010 Korea University. All rights reserved.
//

#import "ETHTTPUtility.h"

@implementation ETHTTPUtility

@synthesize bodyObject;

@synthesize receivedData; 
@synthesize response; 
@synthesize result; 
@synthesize target; 
@synthesize selector;

@synthesize httpDelegate;

- (BOOL)sendURL:(NSString *)url ToServerURLPre:(NSString *)urlPre InMethod:(NSString *)method WithSession:(BOOL)withSession
{
    NSString *headString = [url substringToIndex:1];
    if (![headString isEqualToString:@"/"])
        [NSException raise:NSInvalidArgumentException format:@"HasNoSlash"];
    
    if (![ETHTTPUtility isMethodValid:method]) {
        [NSException raise:NSInvalidArgumentException format:@"InvalidMethod"];
    }
    
    if ([method isEqualToString:@"GET"]) {
        return [self getFromURL:url ToServerURLPre:urlPre WithSession:withSession];
//        return YES;
    }
    else if ([method isEqualToString:@"POST"]) {
        [self postToURL:url ToServerURLPre:urlPre WithSession:withSession];
        return YES;
    }
    else if ([method isEqualToString:@"PUT"]) {
        [self putToURL:url ToServerURLPre:urlPre WithSession:withSession];
        return YES;
    }
    else if ([method isEqualToString:@"DELETE"]) {
        [self deleteFromURL:url ToServerURLPre:urlPre WithSession:withSession];
        return YES;
    }
    
    return NO; 
}

//GET
- (BOOL)getFromURL:(NSString *)url ToServerURLPre:(NSString *)urlPre WithSession:(BOOL)withSession
{
    SET_URL(urlPre)
    
    NSMutableArray *parts = [NSMutableArray array];
    NSString *part;
    
    id key;
    id value;
		
    for (key in bodyObject)
    {
        value = [bodyObject objectForKey:key];
        part = [NSString stringWithFormat:@"%@=%@", [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                [value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [parts addObject:part];
    }
    
    NSData *tempData = [[parts componentsJoinedByString:@"&"] dataUsingEncoding:NSUTF8StringEncoding];
    NSString *params = [[NSString alloc] initWithData:tempData encoding:NSUTF8StringEncoding];
    
    if (withSession) {
        url = [NSString stringWithFormat:@"%@?%@", url, params];
    }
    
//    NSLog(@"url : %@", url);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] 
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy 
                                                       timeoutInterval:HTTP_TimeInterval];
    [request setHTTPMethod:@"GET"];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self]; 
	
    if (!connection) {
        return NO;
    }
    
    receivedData = [[NSMutableData alloc] init];
    
    return YES;
}

//POST
- (BOOL)postToURL:(NSString *)url ToServerURLPre:(NSString *)urlPre WithSession:(BOOL)withSession
{
    SET_URL(urlPre)
//    NSLog(@"url : %@", url);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy 
                                                       timeoutInterval:HTTP_TimeInterval];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    
    if (bodyObject)  {
        NSMutableArray *parts = [NSMutableArray array]; 
        NSString *part;
        id key; 
        id value; 
		
        for (key in bodyObject)  {
            value = [bodyObject objectForKey:key];
            
            part = [NSString stringWithFormat:@"%@=%@", [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                    [value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            [parts addObject:part];
        }
        
//        if (withSession) {
//            part = [NSString stringWithFormat:@"session_key=%@", [[[UserInfo sharedInfo] sessionKey] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//            [parts addObject:part];
//        }
        
//        NSLog(@"%@", parts);
        
        [request setHTTPBody:[[parts componentsJoinedByString:@"&"] dataUsingEncoding:NSUTF8StringEncoding]]; 
    }
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self]; 
	
    if (!connection) {
        return NO;
    }
    
    receivedData = [[NSMutableData alloc] init]; 
    return YES;
}

//PUT
- (BOOL)putToURL:(NSString *)url ToServerURLPre:(NSString *)urlPre WithSession:(BOOL)withSession
{
    SET_URL(urlPre)
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:HTTP_TimeInterval];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"PUT"];
    
    NSMutableArray *parts = [NSMutableArray array];
    NSString *part;
    id key;
    id value;
    
    for (key in bodyObject)
    {
        value = [bodyObject objectForKey:key];
        part = [NSString stringWithFormat:@"%@=%@", [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                [value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [parts addObject:part];
    }
    
//    if (withSession) {
//        part = [NSString stringWithFormat:@"session_key=%@", [[[UserInfo sharedInfo] sessionKey] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//        [parts addObject:part];
//    }
    
    [request setHTTPBody:[[parts componentsJoinedByString:@"&"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	
    if (!connection)
    {
        return NO;
    }
    
    receivedData = [[NSMutableData alloc] init];
    return YES;
}

//DELETE

- (BOOL)deleteFromURL:(NSString *)url ToServerURLPre:(NSString *)urlPre WithSession:(BOOL)session
{
    SET_URL(urlPre)
    
    NSMutableArray *parts = [NSMutableArray array];
    NSString *part;
    
    id key;
    id value;
    
//    UserInfo *sharedInfo = [UserInfo sharedInfo];
//    
//    if (session == YES) {
//        part = [NSString stringWithFormat:@"session_key=%@", [[sharedInfo sessionKey] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//        [parts addObject:part];
//    }
    
    for (key in bodyObject)
    {
        value = [bodyObject objectForKey:key];
        part = [NSString stringWithFormat:@"%@=%@", [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                [value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [parts addObject:part];
    }
    
    NSData *tempData = [[parts componentsJoinedByString:@"&"] dataUsingEncoding:NSUTF8StringEncoding];
    NSString *params = [[NSString alloc] initWithData:tempData encoding:NSUTF8StringEncoding];
    if (session == YES) {
        url = [NSString stringWithFormat:@"%@?%@", url, params];
    }
    
//    NSLog(@"url : %@", url);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:HTTP_TimeInterval];
    [request setHTTPMethod:@"DELETE"];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	
    if (!connection)
    {
        return NO;
    }
    
    receivedData = [[NSMutableData alloc] init];
    
    return YES;
}

- (BOOL)deleteToURL:(NSString *)url ToServerUrlPre:(NSString *)urlPre
{
    return [self deleteFromURL:url ToServerURLPre:urlPre WithSession:YES];
}


#pragma mark - 메서드 검증

+ (BOOL)isMethodValid:(NSString *)method
{
    return ([method isEqualToString:@"POST"] ||
            [method isEqualToString:@"GET"] ||
            [method isEqualToString:@"PUT"] ||
            [method isEqualToString:@"DELETE"]);
}


#pragma mark - JSON 응답값 조회

+ (id)parseData:(NSData *)jsonData Type:(NSString *)type Log:(BOOL)showLog
{
    NSError *error;
    id json = [NSJSONSerialization JSONObjectWithData:jsonData
                                              options:kNilOptions
                                                error:&error];
    if (error)
        NSLog(@"error : %@", error);
    
    if (showLog)
        NSLog(@"%@ : %@", type, json);

//    if ([json respondsToSelector:@selector(allKeys)] && [[(NSDictionary *)json allKeys] count] == 1) {
//        json = [(NSDictionary *)json objectForKey:@"message"];
//    }
    
    return json;
}

+ (id)parseString:(NSData *)jsonData Type:(NSString *)type Log:(BOOL)showLog
{
    NSError *error;
    id json = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
    if (error)
        NSLog(@"error : %@", error);
    
    if (showLog)
        NSLog(@"%@ : %@", type, json);
    
    if ([json respondsToSelector:@selector(allKeys)] && [[(NSDictionary *)json allKeys] count] == 1) {
        json = [(NSDictionary *)json objectForKey:@"message"];
    }
    
    return json;
}


#pragma mark - 접속

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)aResponse 
{
    self.response = aResponse;
    
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    NSInteger responseStatusCode = [httpResponse statusCode];
//    NSLog(@"code : %d", responseStatusCode);
    [httpDelegate sendStatusCode:responseStatusCode];
    
//    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;	
//	if ([response respondsToSelector:@selector(allHeaderFields)]) {
//		NSDictionary *dictionary = [httpResponse allHeaderFields];
//		NSLog(@"%@", dictionary);
//	}
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data 
{
//    NSLog(@"%@", data);
    
    [receivedData appendData:data];
} 

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{ 
//    [NSException raise:NSInvalidArgumentException format:@"NOResponse"];
//    에러가 발생되었을 경우 호출되는 메서드 
    NSLog(@"Error: %@", [error localizedDescription]);
    NSLog(@"이거네");
//	UIAlertView *alert;
//	alert = [[UIAlertView alloc]initWithTitle:@"접속 에러" message:@"인터넷 연결을 확인해주세요" delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
//	[alert show];
	if(target)
    { 
//        [target performSelector:selector withObject:result]; 
//        [target performSelector:@selector(stopIndicator)];
//        [target performSelector:@selector(enableLogin)];
    }
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:@"offLine" object:nil];
} 

- (void)connectionDidFinishLoading:(NSURLConnection *)connection 
{
    if(target) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [target performSelector:selector withObject:receivedData];
#pragma clang diagnostic pop
    }
}

- (NSString *)getXMLData:(NSString *)source {
	mtbSource = [NSMutableString stringWithString:source];
	NSRange firstRange = [mtbSource rangeOfString:@">"];
	[mtbSource deleteCharactersInRange:NSMakeRange(0, firstRange.location + 1)];
	firstRange = [mtbSource rangeOfString:@"<"];
	return [mtbSource substringToIndex:firstRange.location];
}

- (void)setDelegate:(id)aTarget selector:(SEL)aSelector 
{
    self.target = aTarget; 
    self.selector = aSelector; 
}

- (void)httpConnected {
}

@end
