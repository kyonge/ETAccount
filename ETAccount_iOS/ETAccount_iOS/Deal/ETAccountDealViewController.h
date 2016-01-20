//
//  ETAccountDealViewController.h
//  ETAccount_iOS
//
//  Created by 기용 이 on 2015. 4. 9..
//  Copyright (c) 2015년 Eten. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DetailViewController.h"
#import "ETAccountTableViewCell.h"
#import "ETAccountAddDealTableViewController.h"
#import "ETAccountDealDetailViewController.h"

#import "ETUtility.h"
#import "ETFormatter.h"

@interface ETAccountDealViewController : DetailViewController <UITableViewDataSource, UITableViewDelegate, ETAccountAddDealDelegate> {
    NSMutableArray *dealArray;
    
    IBOutlet UIBarButtonItem *addItem;
    IBOutlet UITableView *dealListTableView;
    
    NSInteger selectedRow;
    
    BOOL isUntillToday;
}

@end
