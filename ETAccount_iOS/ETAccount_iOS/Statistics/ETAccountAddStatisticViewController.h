//
//  ETAccountAddStatisticViewController.h
//  ETAccount_iOS
//
//  Created by 기용 이 on 2015. 12. 5..
//  Copyright © 2015년 Eten. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ETAccountAddDealTableViewController.h"
#import "ETAccountFilterListViewController.h"
#import "ETAccountAddStatisticTableViewCell.h"

@interface ETAccountAddStatisticViewController : ETAccountAddDealTableViewController <ETAccountAddDealCellDelegate, ETAccountFilterSelectDelegate> {
    IBOutlet UITableView *statisticTableView;
    
    NSMutableArray *filterArray;
    NSString *endDateString;
    
    BOOL isFavorite;
}

@end
