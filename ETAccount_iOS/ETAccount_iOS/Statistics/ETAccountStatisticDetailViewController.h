//
//  ETAccountStatisticDetailViewController.h
//  ETAccount_iOS
//
//  Created by 기용 이 on 2015. 11. 24..
//  Copyright © 2015년 Eten. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ETAccountDealDetailViewController.h"
#import "ETAccountGraphOptionViewController.h"

#import "ETAccountStatisticDetailTableViewCell.h"
#import "ETAccountEditStatisticViewController.h"
#import "ETAccountGraphView.h"
#import "ETAccountGraphTableViewCell.h"
#import "ETAccountTableViewCell.h"

#import "ETUtility.h"
#import "ETFormatter.h"
#import "ETAccountWhereMaker.h"
//#import "ETAccountGraphSharedData.h"
#import "ETAccountStatisticsCalculator.h"

@interface ETAccountStatisticDetailViewController : UITableViewController <ETAccountAddDealDelegate, ETAccountGraphOptionDealDelegate> {
//    IBOutlet ETAccountGraphView *graphView;
//    ETAccountGraphView *graphView;
    
    IBOutlet UITableView *statisticTableView;
    NSDictionary *statisticDictionary;
    NSMutableArray *tempGraphDataArray, *tempGraphDailyDataArray;
    NSMutableArray *tempGraphDailyDataArrayTillFrom;
    NSMutableDictionary *tempGraphDataListDictionary;
    NSMutableDictionary *tempGraphDataListDictionaryTillFrom;
    NSArray *resultArray, *resultAccountArray, *resultTagArray;
    NSArray *resultAccountArrayTillFrom;
    NSString *whereString;
    
    NSInteger selectedRow;
}

- (void)setStatisticDictionary:(NSDictionary *)inputDictionary;
- (void)initStatistic;

@end
