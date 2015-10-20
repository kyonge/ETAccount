//
//  ETFormatter.h
//  ETAccount_iOS
//
//  Created by 기용 이 on 2015. 9. 20..
//  Copyright (c) 2015년 Eten. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ETFormatter : NSObject

+ (NSString *)dateColumnFormat:(NSString *)tempDateString;
+ (NSString *)dateStringForDeal:(NSDate *)date;
+ (NSString *)dateStringFromDateColumnFormat:(NSString *)tempDateColumn;

@end
