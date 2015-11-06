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
#import "ETAccountAddTagViewController.h"

@protocol ETAccountAddDealDelegate;

@interface ETAccountAddDealTableViewController : UITableViewController <UINavigationControllerDelegate, ETAccountAddAccountDelegate, ETAccountAddDealCellDelegate, ETAccountChangeTagDelegate> {
    IBOutlet UITableView *addDealTableView;
    
    NSArray *selectedTagsArray;
    
    ACCOUNT_DIRECTION direction;
    NSString *dealDateString, *dealNameString, *dealDescriptionString;
    NSInteger dealPrice, accountLeftId, accountRightId, dealTagTarget;
    BOOL isAccountLeftFilled, isAccountRightFilled;
}

- (void)setTagCell:(ETAccountAddTableViewCell *)cell;
- (NSArray *)getSelectedTagsWithTargetId:(NSInteger)targetID;

@property (assign, readwrite) id<ETAccountAddDealDelegate> addDealDelegate;

@end


@protocol ETAccountAddDealDelegate <NSObject>

- (void)didAddDeal;

@end