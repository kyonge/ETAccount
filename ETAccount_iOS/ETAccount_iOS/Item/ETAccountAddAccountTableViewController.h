//
//  ETAccountAddAccountTableViewController.h
//  ETAccount_iOS
//
//  Created by 기용 이 on 2015. 10. 16..
//  Copyright © 2015년 Eten. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ETUtility.h"
#import "ETAccountDBManager.h"

@protocol ETAccountAddAccountDelegate;

@interface ETAccountAddAccountTableViewController : UITableViewController {
    NSMutableArray *itemArray;
    
    UITextField *newAccountTextField;
}

@property (assign, readwrite) id<ETAccountAddAccountDelegate> addDelegate;

@end


@protocol ETAccountAddAccountDelegate <NSObject>

- (void)didSelectAccount:(NSInteger)accountId;

@end
