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
    
    NSString *querryString = [NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE id = %ld",itemName, table, (long)itemIdx];
    NSArray *columnArray = [NSArray arrayWithObjects:itemName, nil];
    
    return [[[ETUtility selectDataWithQuerry:querryString FromFile:_DB WithColumn:columnArray] objectAtIndex:0] objectForKey:itemName];
}

+ (BOOL)insertToTable:(NSString *)table dataDictionary:(NSDictionary *)dataDic
{
    NSString *querryString = [NSString stringWithFormat:@"INSERT INTO %@ (", table];
    
    NSInteger dataDicCount = [[dataDic allKeys] count];
    
    for (NSInteger index = 0; index < dataDicCount - 1; index++) {
        querryString = [NSString stringWithFormat:@"%@%@, ", querryString, [[dataDic allKeys] objectAtIndex:index]];
    }
    querryString = [NSString stringWithFormat:@"%@%@) VALUES (", querryString, [[dataDic allKeys] objectAtIndex:dataDicCount - 1]];
    
    for (NSInteger index = 0; index < dataDicCount - 1; index++) {
        querryString = [NSString stringWithFormat:@"%@%@, ", querryString, [dataDic objectForKey:[[dataDic allKeys] objectAtIndex:index]]];
    }
    querryString = [NSString stringWithFormat:@"%@%@)", querryString, [dataDic objectForKey:[[dataDic allKeys] objectAtIndex:dataDicCount - 1]]];
    NSLog(@"%@",querryString);
    return [ETUtility runQuerry:querryString FromFile:_DB];
}

+ (BOOL)updateToTable:(NSString *)table dataDictionary:(NSDictionary *)dataDic ToId:(NSInteger)dealId
{
    NSString *querryString = [NSString stringWithFormat:@"UPDATE %@ SET ", table];
    
    NSInteger dataDicCount = [[dataDic allKeys] count];
    
    for (NSInteger index = 0; index < dataDicCount - 1; index++) {
        querryString = [NSString stringWithFormat:@"%@%@ = %@, ", querryString,
                        [[dataDic allKeys] objectAtIndex:index], [dataDic objectForKey:[[dataDic allKeys] objectAtIndex:index]]];
    }
    querryString = [NSString stringWithFormat:@"%@%@ = %@ ", querryString,
                    [[dataDic allKeys] objectAtIndex:dataDicCount - 1], [dataDic objectForKey:[[dataDic allKeys] objectAtIndex:dataDicCount - 1]]];
    
    querryString = [NSString stringWithFormat:@"%@WHERE id = %ld", querryString, (long)dealId];
    
    return [ETUtility runQuerry:querryString FromFile:_DB];
}

@end
