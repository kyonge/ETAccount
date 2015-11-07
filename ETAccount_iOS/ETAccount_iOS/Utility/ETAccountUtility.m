//
//  ETAccountUtility.m
//  ETAccount_iOS
//
//  Created by 기용 이 on 2015. 11. 7..
//  Copyright © 2015년 Eten. All rights reserved.
//

#import "ETAccountUtility.h"

@implementation ETAccountUtility

// 새로운 tag_target_id 생성

+ (NSInteger)getTagFromViewController:(UIViewController *)viewController
{
    NSArray *tagKeyArray = [NSArray arrayWithObject:@"object"];
    NSArray *tagObjectsArray = [NSArray arrayWithObject:@"'1'"];
    NSDictionary *tagDataDic = [NSDictionary dictionaryWithObjects:tagObjectsArray forKeys:tagKeyArray];
    
    if (![ETAccountDBManager insertToTable:@"Tag_target" dataDictionary:tagDataDic]) {
        [ETUtility showAlert:@"ETAccount" Message:@"태그를 생성하지 못했습니다." atViewController:viewController withBlank:NO];
        return -1;
    }
    return [ETAccountDBManager getLast:@"id" FromTable:@"Tag_target"];
}

@end
