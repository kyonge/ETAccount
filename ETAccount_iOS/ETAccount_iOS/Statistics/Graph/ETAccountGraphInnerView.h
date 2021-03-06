//
//  ETAccountGraphInnerView.h
//  ETAccount_iOS
//
//  Created by 기용 이 on 2015. 12. 27..
//  Copyright © 2015년 Eten. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ETFormatter.h"
#import "Constants.h"

@interface ETAccountGraphDataItem : NSObject

@property (readwrite) NSInteger itemIndex;
@property (readwrite) NSString *itemName;
@property (readwrite) NSInteger itemValue;
@property (readwrite) NSInteger itemRealValue;
@property (readwrite) UIColor *itemColor;

@end


@interface ETAccountGraphInnerView : UIView {
    CGPoint lastStrokePoint;
}

@property (readwrite) ETACCOUNT_GRAPH_TYPE graphType;
@property (readwrite) ETACCOUNT_GRAPH_KIND graphKind;

@property (strong, readwrite) NSMutableArray *graphInnerDataArray;
@property (assign, readwrite) CGFloat zeroPositionX;

@property (assign, nonatomic) CGFloat gridLineWidth;
@property (strong, nonatomic) UIColor *gridLineColor;

@end
