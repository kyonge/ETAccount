//
//  ETAccountGraphView.m
//  ETAccount_iOS
//
//  Created by 기용 이 on 2015. 11. 24..
//  Copyright © 2015년 Eten. All rights reserved.
//

#import "ETAccountGraphView.h"

@implementation ETAccountGraphView

static ETAccountGraphView *sharedView = nil;

+ (ETAccountGraphView *)sharedView
{
    if (!sharedView) {
        sharedView = [[self alloc] init];
        
//        [sharedView setGlobalDataDictionary:[NSMutableDictionary dictionary]];
        [sharedView setGlobalDataArray:[NSMutableArray array]];
    }
    
    return sharedView;
}

- (BOOL)setBaseWithFrame:(CGRect)frame
{
    [self setFrame:frame];
    
    if (!basicSet) {
//        CGRect frame = [self frame];
        innerScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [innerScrollView setBackgroundColor:[UIColor lightGrayColor]];
        [innerScrollView setDelegate:self];
        [self addSubview:innerScrollView];
        
        basicSet = YES;
    }
    
    return basicSet;
}

- (void)testMethod
{
    NSLog(@"!!");
}

- (void)initInnerView
{
//    if (innerViewSet)
//        return;
    [innerView removeFromSuperview];
    
    NSDate *firstDate = [ETFormatter dateFromDateSting:[[ETAccountGraphView sharedView] firstDate]];
    NSDate *lastDate = [ETFormatter dateFromDateSting:[[ETAccountGraphView sharedView] lastDate]];
    NSTimeInterval interval = [lastDate timeIntervalSinceDate:firstDate];
    NSTimeInterval daysInterval = interval * 60 * 60 * 24;
    
    NSInteger biggestCostValue = [[ETAccountGraphView sharedView] biggestCost] / 1000;
    NSInteger smallestCostValue = [[ETAccountGraphView sharedView] smallestCost] / 1000;
    CGFloat innerViewWidth = 80 + daysInterval * 40;
    CGFloat innerViewHeight = 40 + (biggestCostValue - smallestCostValue) * 10;
    
    NSInteger biggest = 0, smallest = 0;
    
    switch ([[ETAccountGraphView sharedView] graphType]) {
        case ETACCOUNT_GRAPH_TYPE_DEFAULT:
            break;
            
        case ETACCOUNT_GRAPH_TYPE_EACH_TOTAL: {
            innerViewWidth = 40 + 40 * [[[ETAccountGraphView sharedView] globalDataArray] count];
            innerViewHeight = 40;
            
            biggest = [[[[[ETAccountGraphView sharedView] globalDataArray] objectAtIndex:0] objectForKey:@"money"] integerValue];
            smallest = biggest;
            break;
        }
            
        default:
            break;
    }
    
    if (innerViewWidth < [innerScrollView frame].size.width)
        innerViewWidth = [innerScrollView frame].size.width;
    if (innerViewHeight < [innerScrollView frame].size.height)
        innerViewHeight = [innerScrollView frame].size.height;

//    innerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, innerViewWidth, innerViewHeight)];
    innerView = [[ETAccountGraphInnerView alloc] initWithFrame:CGRectMake(0, 0, innerViewWidth, innerViewHeight)];
    [innerView setBackgroundColor:[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0]];
    [innerScrollView setContentSize:CGSizeMake([innerView frame].size.width, [innerView frame].size.height)];
    [innerScrollView addSubview:innerView];
    
    switch ([[ETAccountGraphView sharedView] graphType]) {
        case ETACCOUNT_GRAPH_TYPE_DEFAULT:
            break;
            
        case ETACCOUNT_GRAPH_TYPE_EACH_TOTAL: {
            for (NSDictionary *tempDataDictionary in [[ETAccountGraphView sharedView] globalDataArray]) {
//                NSLog(@"tempDataDictionary : %@", tempDataDictionary);
                NSInteger tempMoney = [[tempDataDictionary objectForKey:@"money"] integerValue];
                if (tempMoney > biggest)
                    biggest = tempMoney;
                if (tempMoney < smallest)
                    smallest = tempMoney;
            }
            
            if (biggest < 0) biggest = 0;
            else if (smallest > 0) smallest = 0;
            
            NSMutableArray *tempMutableArray = [NSMutableArray array];
            for (NSDictionary *tempDataDictionary in [[ETAccountGraphView sharedView] globalDataArray]) {
                ETAccountGraphDataItem *tempItem = [ETAccountGraphDataItem new];
                [tempItem setItemIndex:[[[ETAccountGraphView sharedView] globalDataArray] indexOfObject:tempDataDictionary]];
                [tempItem setItemName:[tempDataDictionary objectForKey:@"name"]];
                NSString *colorString = [tempDataDictionary objectForKey:@"color"];
                NSArray *colorArray = [colorString componentsSeparatedByString:@" "];
                [tempItem setItemColor:[UIColor colorWithRed:[[colorArray objectAtIndex:0] floatValue]
                                                       green:[[colorArray objectAtIndex:1] floatValue]
                                                        blue:[[colorArray objectAtIndex:2] floatValue] alpha:1.0]];
                NSInteger realValue = [[tempDataDictionary objectForKey:@"money"] integerValue];
                NSInteger relativeValue = 0;
                
                if (biggest == smallest) {
                    if (biggest > 0) relativeValue = 90;
                    else relativeValue = 10;
                }
                else relativeValue = 100 * (realValue - smallest) / (biggest - smallest);
//                NSLog(@"%ld %ld", (long)biggest, (long)smallest);
//                NSLog(@"%ld", (long)(realValue - smallest));
//                NSLog(@"realValue : %ld -> %ld", (long)realValue, (long)relativeValue);
                [tempItem setItemRealValue:realValue];
                [tempItem setItemValue:relativeValue];
                
                [tempMutableArray addObject:tempItem];
            }
//            NSLog(@"tempMutableArray : %@", tempMutableArray);
            [innerView setGraphInnerDataArray:tempMutableArray];
            
            if (biggest == smallest) {
                if (biggest > 0) [innerView setZeroPositionX:10];
                else [innerView setZeroPositionX:90];
            }
            else {
                [innerView setZeroPositionX:100 * (0 - smallest) / (biggest - smallest)];
            }
        }
            break;
            
        default:
            break;
    }
    
    innerViewSet = YES;
}

- (void)closeInnerView
{
    NSLog(@"closeInnerView");
    
    [innerView removeFromSuperview];
    
    innerViewSet = NO;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


#pragma mark - 델리게이트 메서드

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    NSLog(@"didScroll");
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
//    NSLog(@"beginDragging");
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
//    NSLog(@"EndDecelerating!!");
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return innerView;
}

@end
