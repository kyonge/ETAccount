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

@interface ETAccountAddDealTableViewController : UITableViewController <UINavigationControllerDelegate, ETAccountAddAccountDelegate> {
    IBOutlet UITableView *addDealTableView;
    
    ACCOUNT_DIRECTION direction;
    NSInteger AccountLeftId, AccountRightId;
    BOOL isAccountLeftFilled, isAccountRightFilled;
}

@end
