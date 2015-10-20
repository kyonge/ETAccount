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
#import "ETAccountAddViewController.h"
#import "ETAccountAddDealTableViewController.h"
#import "ETAccountDealDetailViewController.h"

#import "ETUtility.h"
#import "ETFormatter.h"

@interface ETAccountDealViewController : DetailViewController <UITableViewDataSource, UITableViewDelegate, ETAccountAddDelegate, ETAccountAddDealDelegate> {
    NSMutableArray *dealArray;
    
    IBOutlet UIBarButtonItem *addItem;
    IBOutlet UITableView *dealListTableView;
    
    ETAccountAddViewController *addViewController;
    
    NSInteger selectedRow;
}

@property (strong) ETAccountAddViewController *addViewController;

@end
