//
//  ETAccountWhereMaker.h
//  ETAccount_iOS
//
//  Created by 기용 이 on 2015. 11. 30..
//  Copyright © 2015년 Eten. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ETUtility.h"

@interface ETAccountWhereMaker : NSObject

+ (NSString *)whereStringWithDictionary:(NSDictionary *)tempStatisticDictionary;

@end
