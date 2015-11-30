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

+ (NSString *)dateStringFromDateColumnFormat:(NSString *)tempDateColumn
{
    NSArray *tempDateArray = [tempDateColumn componentsSeparatedByString:@" "];
    NSString *yearString = (NSString *)[tempDateArray objectAtIndex:0];
    NSArray *dateArray = [(NSString *)[tempDateArray objectAtIndex:1] componentsSeparatedByString:@"/"];
    NSArray *timeArray = [(NSString *)[tempDateArray objectAtIndex:2] componentsSeparatedByString:@":"];
    
    NSString *monthString = [dateArray objectAtIndex:1];
//    if ([monthString integerValue] < 10)
//        monthString = [NSString stringWithFormat:@"0%@", monthString];
    NSString *dayString = [dateArray objectAtIndex:2];
//    if ([dayString integerValue] < 10)
//        dayString = [NSString stringWithFormat:@"0%@", dayString];
    NSString *hourString = [timeArray objectAtIndex:0];
//    if ([hourString integerValue] < 10)
//        hourString = [NSString stringWithFormat:@"0%@", hourString];
    NSString *minuteString = [timeArray objectAtIndex:1];
//    if ([minuteString integerValue] < 10)
//        minuteString = [NSString stringWithFormat:@"0%@", minuteString];
    
    NSString *finalDateString = [NSString stringWithFormat:@"%@-%@-%@ %@:%@",
                                 yearString, monthString, dayString, hourString, minuteString];
    
    return finalDateString;
}

+ (NSString *)moneyFormatFromString:(NSString *)moneyString
{
    NSInteger money = [moneyString integerValue];
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior: NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle: NSNumberFormatterDecimalStyle];
    return [numberFormatter stringFromNumber: [NSNumber numberWithInteger:money]];
}

@end
