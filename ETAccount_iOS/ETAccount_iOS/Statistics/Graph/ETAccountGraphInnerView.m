//
//  ETAccountGraphInnerView.m
//  ETAccount_iOS
//
//  Created by 기용 이 on 2015. 12. 27..
//  Copyright © 2015년 Eten. All rights reserved.
//

#import "ETAccountGraphInnerView.h"

@implementation ETAccountGraphInnerView

@synthesize gridSpacing;
@synthesize gridLineWidth;
@synthesize gridXOffset;
@synthesize gridYOffset;
@synthesize gridLineColor;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setDefaults];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setDefaults];
    }
    return self;
}

#pragma mark - Private Methods

- (void)drawRect:(CGRect)rect
{
    CGFloat width = CGRectGetWidth(self.bounds);
    CGFloat height = CGRectGetHeight(self.bounds);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineWidth = self.gridLineWidth;
    
    CGFloat x = self.gridXOffset;
    while (x <= width)
    {
        [path moveToPoint:CGPointMake(x, 0.0)];
        [path addLineToPoint:CGPointMake(x, height)];
        x += self.gridSpacing;
    }
    
    CGFloat y = self.gridYOffset;
    while (y <= height)
    {
        [path moveToPoint:CGPointMake(0.0, y)];
        [path addLineToPoint:CGPointMake(width, y)];
        y += self.gridSpacing;
    }
    
    [self.gridLineColor setStroke];
    [path stroke];
}


#pragma mark 초기화

- (void)setDefaults
{
    self.backgroundColor = [UIColor whiteColor];
    self.opaque = YES;
    
    self.gridSpacing = 20.0;
    
    if (self.contentScaleFactor == 2.0)
    {
        self.gridLineWidth = 0.5;
        self.gridXOffset = 0.25;
        self.gridYOffset = 0.25;
    }
    else
    {
        self.gridLineWidth = 1.0;
        self.gridXOffset = 0.5;
        self.gridYOffset = 0.5;
    }
    
    self.gridLineColor = [UIColor blueColor];
}

@end
