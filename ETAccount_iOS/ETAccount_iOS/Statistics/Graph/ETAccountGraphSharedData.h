//
//  ETAccountGraphSharedData.h
//  ETAccount_iOS
//
//  Created by 기용 이 on 2016. 2. 28..
//  Copyright © 2016년 Eten. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ETAccountGraphSharedData : UIView {
    UIScrollView *innerScrollView;
    
    
}

+ (ETAccountGraphSharedData *)sharedData;

@property (readwrite, strong) NSMutableArray *globalDataArray;
@property BOOL basicSet;

@end
