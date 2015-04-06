//
//  ETXMLParser.h
//  PopOp
//
//  Created by 기용 이 on 2015. 1. 25..
//  Copyright (c) 2015년 Opinion8. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ETXMLParser : NSXMLParser <NSXMLParserDelegate>
{
    NSMutableArray *dictionaryStack;
    NSMutableString *textInProgress;
    NSError *__autoreleasing *errorPointer;
}

+ (NSDictionary *)dictionaryForXMLData:(NSData *)data error:(NSError *__autoreleasing *)errorPointer;
+ (NSDictionary *)dictionaryForXMLString:(NSString *)string error:(NSError *__autoreleasing *)errorPointer;

@end

