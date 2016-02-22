//
//  ETAccountWhereMaker.m
//  ETAccount_iOS
//
//  Created by 기용 이 on 2015. 11. 30..
//  Copyright © 2015년 Eten. All rights reserved.
//

#import "ETAccountWhereMaker.h"

@implementation ETAccountWhereMaker

+ (NSString *)whereStringWithDictionary:(NSDictionary *)tempStatisticDictionary
{
    BOOL noDateCondition = NO;
    
    // 필터
    NSString *querryString = [NSString stringWithFormat:@"SELECT Filter.id, Filter.type, Filter.item, Filter.compare FROM Filter Filter JOIN Statistics_filter_match Match ON Filter.id = Match.filter_id WHERE Match.statistic_id=%@", [tempStatisticDictionary objectForKey:@"id"]];
    NSArray *columnArray = [NSArray arrayWithObjects:@"id", @"type", @"item", @"compare", nil];
    NSArray *filterArray = [ETUtility selectDataWithQuerry:querryString FromFile:_DB WithColumn:columnArray];
//    NSLog(@"%@", filterArray);
    
    // 기본 Deal SELECT 쿼리
//    querryString = @"SELECT Deal.id, Deal.name, Deal.tag_target_id, Account_1.name account_1, Account_1.tag_target_id tag_target_id_1, Account_2.name account_2, Account_2.tag_target_id tag_target_id_2, money, description, Deal.date FROM Deal JOIN Account Account_1 ON Deal.account_id_1 = Account_1.id JOIN Account Account_2 ON Deal.account_id_2 = Account_2.id WHERE";
    NSString *whereString = @"WHERE";
    
    // date 조건
    NSString *date_1String = [tempStatisticDictionary objectForKey:@"date_1"];
    if (![date_1String isEqualToString:@"~"])
        whereString = [NSString stringWithFormat:@"%@ Deal.date>'%@' AND", whereString, date_1String];
    NSString *date_2String = [tempStatisticDictionary objectForKey:@"date_2"];
    if (![date_2String isEqualToString:@"~"])
        whereString = [NSString stringWithFormat:@"%@ Deal.date<'%@' AND", whereString, date_2String];
    
    if (![date_1String isEqualToString:@"~"] || ![date_2String isEqualToString:@"~"])
        whereString = [whereString substringToIndex:[whereString length] - 3];
    else noDateCondition = YES;
//    NSLog(@"%@", whereString);
    
    // 필터 내용들을 Deal SELECT 쿼리에 추가
    for (NSDictionary *tempFilterDictionary in filterArray) {
//        NSLog(@"%@", tempFilterDictionary);
        FILTER_TYPE tempType = [[tempFilterDictionary objectForKey:@"type"] integerValue];
        NSInteger tempItem = [[tempFilterDictionary objectForKey:@"item"] integerValue];
        FILTER_COMPARE tempCompare = [[tempFilterDictionary objectForKey:@"compare"] integerValue];
        
        switch (tempType) {
            case FILTER_TYPE_ITEM:
                if (noDateCondition) {
                    if ([filterArray indexOfObject:tempFilterDictionary] == 0)
                        whereString = [NSString stringWithFormat:@"%@ ((Deal.account_id_1='%ld' OR Deal.account_id_2='%ld')", whereString, (long)tempItem, (long)tempItem];
                    else
                        whereString = [NSString stringWithFormat:@"%@ (Deal.account_id_1='%ld' OR Deal.account_id_2='%ld')", whereString, (long)tempItem, (long)tempItem];
                    noDateCondition = NO;
                }
                else if ([filterArray indexOfObject:tempFilterDictionary] == 0)
                    whereString = [NSString stringWithFormat:@"%@ AND ((Deal.account_id_1='%ld' OR Deal.account_id_2='%ld')", whereString, (long)tempItem, (long)tempItem];
                else
                    whereString = [NSString stringWithFormat:@"%@ OR (Deal.account_id_1='%ld' OR Deal.account_id_2='%ld')", whereString, (long)tempItem, (long)tempItem];
                break;
                
            case FILTER_TYPE_TAG: {
                NSString *tagQuerryString = [NSString stringWithFormat:@"SELECT Deal.id, Deal.tag_target_id, Tag_match.tag_id FROM Deal Deal JOIN Tag_match Tag_match ON Deal.tag_target_id = Tag_match.tag_target_id WHERE Tag_match.tag_id='%ld'", (long)tempItem];
                NSArray *tagColumnArray = [NSArray arrayWithObjects:@"id", @"tag_target_id", @"tag_id", nil];
                NSArray *tagTargetArray = [ETUtility selectDataWithQuerry:tagQuerryString FromFile:_DB WithColumn:tagColumnArray];
                
                if (noDateCondition) {
                    whereString = [NSString stringWithFormat:@"%@ (", whereString];
                    noDateCondition = NO;
                }
                else if ([filterArray indexOfObject:tempFilterDictionary] == 0)
                    whereString = [NSString stringWithFormat:@"%@ AND (", whereString];
                else
                    whereString = [NSString stringWithFormat:@"%@ OR (", whereString];
                
                for (NSDictionary *tempTagTargetDictionary in tagTargetArray) {
                    NSNumber *tempItem = [tempTagTargetDictionary objectForKey:@"tag_id"];
                    whereString = [NSString stringWithFormat:@"%@ Deal.tag_target_id='%@' OR tag_target_id_1='%@' OR tag_target_id_2='%@' OR", whereString, tempItem, tempItem, tempItem];
                }
                whereString = [whereString substringToIndex:[whereString length] - 2];
                whereString = [NSString stringWithFormat:@"%@)", whereString];
                
                break;
            }
                
            case FILTER_TYPE_PRICE: {
                NSString *compareString;
                if (tempCompare == FILTER_COMPARE_SAME)
                    compareString = @"=";
                else if (tempCompare == FILTER_COMPARE_LEFT)
                    compareString = @">";
                else if (tempCompare == FILTER_COMPARE_SAME_LEFT)
                    compareString = @">=";
                else if (tempCompare == FILTER_COMPARE_RIGHT)
                    compareString = @"<";
                else if (tempCompare == FILTER_COMPARE_SAME_RIGHT)
                    compareString = @"<=";
                
                if (noDateCondition) {
                    whereString = [NSString stringWithFormat:@"%@ ABS(money)%@%ld", whereString, compareString, (long)tempItem];
                    noDateCondition = NO;
                }
                else
                    whereString = [NSString stringWithFormat:@"%@ AND ABS(money)%@%ld", whereString, compareString, (long)tempItem];
                
                break;
            }
                
            default:
                break;
        }
    }
//    whereString = [whereString substringToIndex:[whereString length] - 4];
//    NSLog(@"%@", whereString);
    
    whereString = [NSString stringWithFormat:@"%@)", whereString];
    
    return whereString;
}

@end
