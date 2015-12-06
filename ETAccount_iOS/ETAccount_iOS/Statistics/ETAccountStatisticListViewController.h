//
//  ETAccountStatisticListViewController.h
//  ETAccount_iOS
//
//  Created by 기용 이 on 2015. 11. 23..
//  Copyright © 2015년 Eten. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ETAccountStatisticDetailViewController.h"
#import "ETAccountAddStatisticViewController.h"
#import "ETAccountStatisticListTableViewCell.h"

#import "ETUtility.h"

@interface ETAccountStatisticListViewController : UIViewController <UITableViewDataSource, UITabBarDelegate, ETAccountAddDealDelegate> {
    IBOutlet UIBarButtonItem *addItem;
    IBOutlet UITableView *statisticListTableView;
    
    NSMutableArray *statisticArray;
    
    ETAccountStatisticDetailViewController *statisticDetailViewController;
}

@end
