//
//  ETAccountGraphSharedData.m
//  ETAccount_iOS
//
//  Created by 기용 이 on 2016. 2. 28..
//  Copyright © 2016년 Eten. All rights reserved.
//

#import "ETAccountGraphSharedData.h"

@implementation ETAccountGraphSharedData

static ETAccountGraphSharedData *sharedData = nil;

- (BOOL)setBaseWithFrame:(CGRect)frame
{
    if (![self basicSet]) {
//        CGRect frame = [self frame];
        innerScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [innerScrollView setBackgroundColor:[UIColor lightGrayColor]];
        [self addSubview:innerScrollView];
        
        [self setBasicSet:YES];
    }
    
    return [self basicSet];
}

+ (ETAccountGraphSharedData *)sharedData
{
    if (!sharedData) {
        sharedData = [[self alloc] init];
        
        [sharedData setGlobalDataArray:[NSMutableArray array]];
    }
    
    return sharedData;
}

@end
