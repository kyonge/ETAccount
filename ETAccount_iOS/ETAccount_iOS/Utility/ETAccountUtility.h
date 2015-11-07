//
//  ETAccountUtility.h
//  ETAccount_iOS
//
//  Created by 기용 이 on 2015. 11. 7..
//  Copyright © 2015년 Eten. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ETAccountDBManager.h"

@interface ETAccountUtility : NSObject

// 새로운 tag_target_id 생성
+ (NSInteger)getTagFromViewController:(UIViewController *)viewController;

@end
