//
//  ETAccountDBManager.m
//  ETAccount_iOS
//
//  Created by 기용 이 on 2015. 10. 18..
//  Copyright © 2015년 Eten. All rights reserved.
//

#import "ETAccountDBManager.h"

@implementation ETAccountDBManager

+ (NSInteger)getLast:(NSString *)key FromTable:(NSString *)table
{
    NSString *querryString = [NSString stringWithFormat:@"SELECT %@ FROM %@ ORDER BY %@ DESC LIMIT 1", key, table, key];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:_DB];
    FMDatabase *db = [FMDatabase databaseWithPath:documentPath];
    [db open];
    
    FMResultSet *rs = [db executeQuery:querryString];
    NSInteger lastId = 0;
    
    while ([rs next]) {
        lastId = [[rs stringForColumn:key] integerValue];
    }
    [db close];
    
    return lastId;
}

+ (NSMutableArray *)getAllItems:(NSArray *)columnArray FromTable:(NSString *)table
{
    NSString *querryString = [NSString stringWithFormat:@"SELECT %@", [columnArray objectAtIndex:0]];
    for (NSInteger tempIndex = 1; tempIndex < [columnArray count]; tempIndex++)
        querryString = [NSString stringWithFormat:@"%@, %@", querryString, [columnArray objectAtIndex:tempIndex]];
    
    querryString = [NSString stringWithFormat:@"%@ FROM %@", querryString, table];
    NSMutableArray *resultArray = [ETUtility selectDataWithQuerry:querryString FromFile:_DB WithColumn:columnArray];
    
    return resultArray;
}

+ (NSMutableArray *)getItems:(NSArray *)columnArray Object:(NSString *)object ForKey:(NSString *)key FromTable:(NSString *)table
{
    NSString *querryString = [NSString stringWithFormat:@"SELECT %@", [columnArray objectAtIndex:0]];
    for (NSInteger tempIndex = 1; tempIndex < [columnArray count]; tempIndex++)
        querryString = [NSString stringWithFormat:@"%@, %@", querryString, [columnArray objectAtIndex:tempIndex]];
    
    querryString = [NSString stringWithFormat:@"%@ FROM %@ WHERE %@ = %@", querryString, table, key, object];
    NSMutableArray *resultArray = [ETUtility selectDataWithQuerry:querryString FromFile:_DB WithColumn:columnArray];
    
    return resultArray;
}

+ (NSString *)getItem:(NSString *)itemName OfId:(NSInteger)itemIdx FromTable:(NSString *)table
{
    NSString *querryString = [NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE id = %ld",itemName, table, (long)itemIdx];
    NSArray *columnArray = [NSArray arrayWithObjects:itemName, nil];
    
    NSArray *resultArray = [ETUtility selectDataWithQuerry:querryString FromFile:_DB WithColumn:columnArray];
    if ([resultArray count] > 0)
        return [[resultArray objectAtIndex:0] objectForKey:itemName];
    else return @"-1";
}

+ (NSString *)getItem:(NSString *)itemName OfId:(NSInteger)itemIdx Key:(NSString *)key FromTable:(NSString *)table
{
    NSString *querryString = [NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE %@ = %ld",itemName, table, key, (long)itemIdx];
    NSArray *columnArray = [NSArray arrayWithObjects:itemName, nil];
    
    NSArray *resultArray = [ETUtility selectDataWithQuerry:querryString FromFile:_DB WithColumn:columnArray];
    if ([resultArray count] > 0)
        return [[resultArray objectAtIndex:0] objectForKey:itemName];
    else return @"-1";
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
    
    return [ETUtility runQuerry:querryString FromFile:_DB];
}

+ (BOOL)updateToTable:(NSString *)table dataDictionary:(NSDictionary *)dataDic ToId:(NSInteger)itemId
{
    NSString *querryString = [NSString stringWithFormat:@"UPDATE %@ SET ", table];
    
    NSInteger dataDicCount = [[dataDic allKeys] count];
    
    for (NSInteger index = 0; index < dataDicCount - 1; index++) {
        querryString = [NSString stringWithFormat:@"%@%@ = %@, ", querryString,
                        [[dataDic allKeys] objectAtIndex:index], [dataDic objectForKey:[[dataDic allKeys] objectAtIndex:index]]];
    }
    querryString = [NSString stringWithFormat:@"%@%@ = %@ ", querryString,
                    [[dataDic allKeys] objectAtIndex:dataDicCount - 1], [dataDic objectForKey:[[dataDic allKeys] objectAtIndex:dataDicCount - 1]]];
    
    querryString = [NSString stringWithFormat:@"%@WHERE id = %ld", querryString, (long)itemId];
    
    NSLog(@"querryString : %@", querryString);
    
    return [ETUtility runQuerry:querryString FromFile:_DB];
}

+ (BOOL)deleteFromTable:(NSString *)table OfId:(NSInteger)itemId
{
    NSString *querryString = [NSString stringWithFormat:@"DELETE FROM %@ WHERE id = %ld", table, (long)itemId];
    
    return [ETUtility runQuerry:querryString FromFile:_DB];
}

+ (BOOL)deleteFromTable:(NSString *)table OfId:(NSInteger)itemId Key:(NSString *)key
{
    NSString *querryString = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ = %ld", table, key, (long)itemId];
    
    return [ETUtility runQuerry:querryString FromFile:_DB];
}

@end
