//
//  ETAccountStatisticsCalculator.h
//  ETAccount_iOS
//
//  Created by 기용 이 on 2016. 4. 9..
//  Copyright © 2016년 Eten. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ETUtility.h"

@interface ETAccountStatisticsCalculator : NSObject

+ (NSMutableArray *)getResultOfAccounts:(NSString *)localWhereString Order:(NSString *)localOrderString List:(NSMutableDictionary *)listDictionary;
+ (void)addMoneyWithDealId:(NSInteger)dealId Id:(NSInteger)tempId Name:(NSString *)tempName Color:(UIColor *)tempColor Money:(NSInteger)tempMoney Date:(NSString *)tempDate To:(NSMutableArray *)tempResultArray List:(NSMutableDictionary *)tempListDictionary Is1:(BOOL)is1;

@end
