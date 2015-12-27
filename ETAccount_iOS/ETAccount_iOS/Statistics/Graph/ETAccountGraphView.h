//
//  ETAccountGraphView.h
//  ETAccount_iOS
//
//  Created by 기용 이 on 2015. 11. 24..
//  Copyright © 2015년 Eten. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ETFormatter.h"

#import "ETAccountGraphInnerView.h"

@interface ETAccountGraphView : UIView {
    ETAccountGraphInnerView *innerView;
    
    UIScrollView *innerScrollView;
    
    NSArray *dataArray;
    NSString *startDateString, *endDateString;
    
    BOOL basicSet;
    BOOL innerViewSet;
}

- (BOOL)setBaseWithFrame:(CGRect)frame;
- (void)setDataArray:(NSArray *)array;
- (void)setStartDateString:(NSString *)dateString;
- (void)setEndDateString:(NSString *)dateString;
- (void)initInnerView;

@end
