//
//  ETFormatter.m
//  ETAccount_iOS
//
//  Created by 기용 이 on 2015. 9. 20..
//  Copyright (c) 2015년 Eten. All rights reserved.
//

#import "ETFormatter.h"

@implementation ETFormatter

+ (NSString *)dateColumnFormat:(NSString *)tempDateString
{
    NSArray *tempDateArray = [tempDateString componentsSeparatedByString:@" "];
    NSArray *dateArray = [(NSString *)[tempDateArray objectAtIndex:0] componentsSeparatedByString:@"-"];
    NSArray *timeArray = [(NSString *)[tempDateArray objectAtIndex:1] componentsSeparatedByString:@":"];
    NSString *finalDateString = [NSString stringWithFormat:@"%@\n%@/%@\n%@:%@",
                                 [dateArray objectAtIndex:0], [dateArray objectAtIndex:1], [dateArray objectAtIndex:2],
                                 [timeArray objectAtIndex:0], [timeArray objectAtIndex:1]];
    
    return finalDateString;
}

+ (NSString *)dateStringForDeal:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    
    return [formatter stringFromDate:date];
}

@end
