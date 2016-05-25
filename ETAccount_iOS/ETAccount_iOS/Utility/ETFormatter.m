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
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
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

+ (NSDate *)dateFromDateSting:(NSString *)dateString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    
    return [formatter dateFromString:dateString];
}

+ (NSString *)moneyFormatFromString:(NSString *)moneyString
{
    NSInteger money = [moneyString integerValue];
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior: NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle: NSNumberFormatterDecimalStyle];
    return [numberFormatter stringFromNumber: [NSNumber numberWithInteger:money]];
}

+ (NSString *)dateStringAddedOneDay:(NSString *)originalDateString
{
    NSDate *originalDate = [ETFormatter dateFromDateSting:originalDateString];
    NSDate *resultDate = [originalDate dateByAddingTimeInterval:60 * 60 * 24];
    
    return [ETFormatter dateStringForDeal:resultDate];
    
//    NSArray *originalDate_1Array = [[[originalDateString componentsSeparatedByString:@" "] objectAtIndex:0] componentsSeparatedByString:@"-"];
//    NSInteger yearInteger = [[originalDate_1Array objectAtIndex:0] integerValue];
//    NSInteger monthInteger = [[originalDate_1Array objectAtIndex:1] integerValue];
//    NSInteger dayInteger = [[originalDate_1Array objectAtIndex:2] integerValue];
//    
//    NSInteger newYearInteger = 0, newMonthInteger = 0, newDayInteger = 0;
//    
//    if (monthInteger == 1 || monthInteger == 3 || monthInteger == 5 || monthInteger == 7 || monthInteger == 8 || monthInteger == 10 || monthInteger == 12) {
//        if (dayInteger == 31) {
//            if (monthInteger == 12) {
//                newYearInteger = yearInteger + 1;
//                newMonthInteger = 1;
//            }
//            else {
//                newYearInteger = yearInteger;
//                newMonthInteger = monthInteger + 1;
//            }
//            newDayInteger = 1;
//        }
//        else {
//            newYearInteger = yearInteger;
//            newMonthInteger = monthInteger;
//            newDayInteger = dayInteger + 1;
//        }
//    }
//    else if (monthInteger == 4 || monthInteger == 6 || monthInteger == 9 || monthInteger == 11) {
//        if (dayInteger == 30) {
//            newYearInteger = yearInteger;
//            newMonthInteger = monthInteger + 1;
//            newDayInteger = 1;
//        }
//        else {
//            newYearInteger = yearInteger;
//            newMonthInteger = monthInteger;
//            newDayInteger = dayInteger + 1;
//        }
//    }
//    else if (monthInteger == 2) {
//        NSInteger lastDay = 28;
//        if ((yearInteger % 4 == 0 && yearInteger % 100 != 0) || yearInteger % 400 == 0) {
//            lastDay = 29;
//        }
//        if (dayInteger == lastDay) {
//            newMonthInteger = 3;
//            newDayInteger = 1;
//        }
//        else {
//            newMonthInteger = monthInteger;
//            newDayInteger = dayInteger + 1;
//        }
//        newYearInteger = yearInteger;
//    }
//    else {
//        newYearInteger = yearInteger;
//        newMonthInteger = monthInteger;
//        newDayInteger = dayInteger + 1;
//    }
//    
//    NSString *resultString = [NSString stringWithFormat:@"%ld-%ld-%ld 00:00", (long)newYearInteger, (long)newMonthInteger, (long)newDayInteger];
//    
//    return resultString;
}

@end
