//
//  ETAccountStatisticsCalculator.m
//  ETAccount_iOS
//
//  Created by 기용 이 on 2016. 4. 9..
//  Copyright © 2016년 Eten. All rights reserved.
//

#import "ETAccountStatisticsCalculator.h"

@implementation ETAccountStatisticsCalculator

+ (NSMutableArray *)getResultOfAccounts:(NSString *)localWhereString Order:(NSString *)localOrderString List:(NSMutableDictionary *)listDictionary
{
    NSString *querryString = @"SELECT Deal.id, Deal.tag_target_id, Account_1.id account_1, Account_1.name account_1_name, Account_1.color_r account_1_r, Account_1.color_g account_1_g, Account_1.color_b account_1_b, Account_1.tag_target_id tag_target_id_1, Account_2.id account_2, Account_2.name account_2_name, Account_2.color_r account_2_r, Account_2.color_g account_2_g, Account_2.color_b account_2_b,Account_2.tag_target_id tag_target_id_2, money, Deal.date FROM Deal JOIN Account Account_1 ON Deal.account_id_1 = Account_1.id JOIN Account Account_2 ON Deal.account_id_2 = Account_2.id ";
    querryString = [NSString stringWithFormat:@"%@ %@",querryString, localWhereString];
    
    // ORDER BY
    querryString = [NSString stringWithFormat:@"%@ ORDER BY %@", querryString, localOrderString];
    
    NSArray *columnArray = [NSArray arrayWithObjects:
                            @"id", @"tag_target_id",
                            @"account_1", @"account_1_name", @"account_1_r", @"account_1_g", @"account_1_b", @"tag_target_id_1",
                            @"account_2", @"account_2_name", @"account_2_r", @"account_2_g", @"account_2_b", @"tag_target_id_2",
                            @"money", @"date", nil];
    NSArray *resultDataArray = [ETUtility selectDataWithQuerry:querryString FromFile:_DB WithColumn:columnArray];
//    NSLog(@"%@", resultDataArray);
    
    NSMutableArray *tempResultArray = [NSMutableArray array];
    
    for (NSDictionary *tempDataDictionary in resultDataArray)
    {
        NSInteger dealId = [[tempDataDictionary objectForKey:@"id"] integerValue];
        NSInteger tempId_1 = [[tempDataDictionary objectForKey:@"account_1"] integerValue];
        NSString *tempName_1 = [tempDataDictionary objectForKey:@"account_1_name"];
        UIColor *tempColor_1 = [UIColor colorWithRed:[[tempDataDictionary objectForKey:@"account_1_r"] floatValue] / 255.0
                                               green:[[tempDataDictionary objectForKey:@"account_1_g"] floatValue] / 255.0
                                                blue:[[tempDataDictionary objectForKey:@"account_1_b"] floatValue] / 255.0 alpha:1.0];
        NSInteger tempId_2 = [[tempDataDictionary objectForKey:@"account_2"] integerValue];
        NSString *tempName_2 = [tempDataDictionary objectForKey:@"account_2_name"];
        UIColor *tempColor_2 = [UIColor colorWithRed:[[tempDataDictionary objectForKey:@"account_2_r"] floatValue] / 255.0
                                               green:[[tempDataDictionary objectForKey:@"account_2_g"] floatValue] / 255.0
                                                blue:[[tempDataDictionary objectForKey:@"account_2_b"] floatValue] / 255.0 alpha:1.0];
        NSInteger tempMoney = [[tempDataDictionary objectForKey:@"money"] integerValue];
        NSString *tempDate = [tempDataDictionary objectForKey:@"date"];
        
//        NSLog(@"%@", tempDataDictionary);
        
        [ETAccountStatisticsCalculator addMoneyWithDealId:dealId Id:tempId_1 Name:tempName_1 Color:tempColor_1 Money:tempMoney Date:tempDate To:tempResultArray List:listDictionary Is1:YES];
        [ETAccountStatisticsCalculator addMoneyWithDealId:dealId Id:tempId_2 Name:tempName_2 Color:tempColor_2 Money:tempMoney Date:tempDate To:tempResultArray List:listDictionary Is1:NO];
    }
    
//    NSLog(@"%@", tempResultArray);
    return tempResultArray;
}

+ (void)addMoneyWithDealId:(NSInteger)dealId Id:(NSInteger)tempId Name:(NSString *)tempName Color:(UIColor *)tempColor Money:(NSInteger)tempMoney Date:(NSString *)tempDate To:(NSMutableArray *)tempResultArray List:(NSMutableDictionary *)tempListDictionary Is1:(BOOL)is1
{
    if (tempId < 0)
        return;
    
    if (!is1)
        tempMoney *= -1;
    
    if (!tempColor)
        tempColor = [UIColor grayColor];
    
    NSString *dealIdString = [NSString stringWithFormat:@"%ld", (long)dealId];
    NSString *itemIdString = [NSString stringWithFormat:@"%ld", (long)tempId];
    NSArray *keyArray = [NSArray arrayWithObjects:@"dealId", @"id", @"name", @"color", @"money", @"date", nil];
    if (!tempDate)
        tempDate = @" ";
    
    NSArray *tempObjectArray = [NSArray arrayWithObjects:dealIdString, itemIdString, tempName, tempColor, [NSString stringWithFormat:@"%ld", (long)tempMoney], tempDate, nil];
    NSMutableDictionary *tempAccountDataDictionary = [NSMutableDictionary dictionaryWithObjects:tempObjectArray forKeys:keyArray];
    
    if (tempListDictionary) {
        if ([[tempListDictionary allKeys] containsObject:itemIdString]) {
            NSMutableArray *tempListArray = [tempListDictionary objectForKey:itemIdString];
            [tempListArray addObject:tempAccountDataDictionary];
            [tempListDictionary setObject:tempListArray forKey:itemIdString];
        }
        else {
            NSMutableArray *tempListArray = [NSMutableArray array];
            [tempListArray addObject:tempAccountDataDictionary];
            [tempListDictionary setObject:tempListArray forKey:itemIdString];
        }
    }
    
    if (![ETUtility doesArray:tempResultArray hasDictionaryWithId:tempId]) {
        [tempResultArray addObject:tempAccountDataDictionary];
    }
    else {
        NSMutableDictionary *tempAccountDataDictionary = [NSMutableDictionary dictionaryWithDictionary:[ETUtility selectDictionaryWithValue:itemIdString OfKey:@"id" inArray:tempResultArray]];
        NSInteger tempIndex = [tempResultArray indexOfObject:tempAccountDataDictionary];
        [tempAccountDataDictionary setValue:[NSString stringWithFormat:@"%ld", (long)([[tempAccountDataDictionary objectForKey:@"money"] integerValue] + tempMoney)] forKey:@"money"];
        [tempResultArray replaceObjectAtIndex:tempIndex withObject:tempAccountDataDictionary];
    }
}

@end
