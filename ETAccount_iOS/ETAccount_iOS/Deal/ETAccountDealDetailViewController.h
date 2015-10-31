//
//  ETAccountDealDetailViewController.h
//  ETAccount_iOS
//
//  Created by 기용 이 on 2015. 10. 19..
//  Copyright © 2015년 Eten. All rights reserved.
//

#import "ETAccountAddDealTableViewController.h"

@interface ETAccountDealDetailViewController : ETAccountAddDealTableViewController {
//    NSString *dealDescription;
//    NSInteger dealTagTarget;
    NSInteger dealId;
}

- (void)initDealDetailWithDate:(NSString *)date Name:(NSString *)name Money:(NSString *)money Left:(NSInteger)left Right:(NSInteger)right Description:(NSString *)description tagTarget:(NSInteger)tagTarget Id:(NSInteger)_id;

@property (assign, readwrite) id<ETAccountAddDealDelegate> addDealDelegate;

@end
