//
//  ETAccountAddDealTableViewController.h
//  ETAccount_iOS
//
//  Created by 기용 이 on 2015. 9. 20..
//  Copyright (c) 2015년 Eten. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ETAccountAddTableViewCell.h"
#import "ETAccountAddAccountTableViewController.h"

@protocol ETAccountAddDealDelegate;

@interface ETAccountAddDealTableViewController : UITableViewController <UINavigationControllerDelegate, ETAccountAddAccountDelegate> {
    IBOutlet UITableView *addDealTableView;
    
    ACCOUNT_DIRECTION direction;
    NSInteger accountLeftId, accountRightId;
    BOOL isAccountLeftFilled, isAccountRightFilled;
}

@property (assign, readwrite) id<ETAccountAddDealDelegate> addDealDelegate;

@end


@protocol ETAccountAddDealDelegate <NSObject>

- (void)didAddDeal;

@end
