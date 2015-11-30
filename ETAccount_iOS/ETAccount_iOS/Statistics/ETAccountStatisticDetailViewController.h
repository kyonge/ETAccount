//
//  ETAccountStatisticDetailViewController.h
//  ETAccount_iOS
//
//  Created by 기용 이 on 2015. 11. 24..
//  Copyright © 2015년 Eten. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ETAccountStatisticDetailTableViewCell.h"
//#import "ETAccountGraphView.h"
#import "ETAccountTableViewCell.h"

#import "ETUtility.h"
#import "ETFormatter.h"

@interface ETAccountStatisticDetailViewController : UITableViewController {
//    IBOutlet ETAccountGraphView *graphView;
    IBOutlet UITableView *statisticTableView;
    NSDictionary *statisticDictionary;
    NSArray *resultArray;
}

- (void)setStatisticDictionary:(NSDictionary *)inputDictionary;
- (void)initStatistic;

@end
