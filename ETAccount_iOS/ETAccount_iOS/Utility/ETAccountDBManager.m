//
//  ETAccountDBManager.m
//  ETAccount_iOS
//
//  Created by 기용 이 on 2015. 10. 18..
//  Copyright © 2015년 Eten. All rights reserved.
//

#import "ETAccountDBManager.h"

@implementation ETAccountDBManager

+ (NSString *)getItem:(NSString *)itemName OfId:(NSInteger)itemIdx FromTable:(NSString *)table
{
    //현재는 전체 로드 : 날짜순 조건 추가, 동적 로딩 추가
    
    NSString *qerryString = [NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE id = %d",itemName, table, itemIdx];
    NSArray *columnArray = [NSArray arrayWithObjects:itemName, nil];
    
    return [[[ETUtility selectDataWithQuerry:qerryString FromFile:_DB WithColumn:columnArray] objectAtIndex:0] objectForKey:itemName];
}

@end
