//
//  ETAccountGraphView.m
//  ETAccount_iOS
//
//  Created by 기용 이 on 2015. 11. 24..
//  Copyright © 2015년 Eten. All rights reserved.
//

#import "ETAccountGraphView.h"

@implementation ETAccountGraphView

- (BOOL)setBaseWithFrame:(CGRect)frame
{
    if (!basicSet) {
//        CGRect frame = [self frame];
        
        innerScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [innerScrollView setBackgroundColor:[UIColor lightGrayColor]];
        [self addSubview:innerScrollView];
        
        basicSet = YES;
    }
    
    return basicSet;
}

- (void)setDataArray:(NSArray *)array
{
    dataArray = [NSArray arrayWithArray:array];
}

- (void)setStartDateString:(NSString *)dateString
{
    startDateString = [NSString stringWithString:dateString];
//    startDateString = [[dateString componentsSeparatedByString:@" "] objectAtIndex:0];
}

- (void)setEndDateString:(NSString *)dateString
{
    endDateString = [NSString stringWithString:dateString];
}

- (void)initInnerView
{
    if (innerViewSet)
        return;
    
    NSDate *startDate = [ETFormatter dateFromDateSting:startDateString];
    NSDate *endDate = [ETFormatter dateFromDateSting:endDateString];
    
    NSLog(@"%@ %@", startDateString, endDateString);
    NSLog(@"%@ %@", startDate, endDate);
    
    NSDateComponents *dateComponent = [[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:endDate toDate:startDate options:0];
    NSInteger days = [dateComponent day];
    
    NSLog(@"%ld", (long)days);
    
//    innerView = [[ETAccountGraphInnerView alloc] initWithFrame:CGRectMake(0, 0, 1000, [innerScrollView frame].size.height)];
    innerView = [[ETAccountGraphInnerView alloc] initWithFrame:CGRectMake(0, 0, days * 50, [innerScrollView frame].size.height)];
    [innerScrollView setContentSize:CGSizeMake([innerView frame].size.width, [innerView frame].size.height)];
    [innerScrollView addSubview:innerView];
    
    innerViewSet = YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
