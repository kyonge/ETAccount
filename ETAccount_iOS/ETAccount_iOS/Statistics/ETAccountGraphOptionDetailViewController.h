//
//  ETAccountGraphOptionDetailViewController.h
//  ETAccount_iOS
//
//  Created by 기용 이 on 2016. 3. 27..
//  Copyright © 2016년 Eten. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ETAccountGraphView.h"

#define OPTION_TYPE if ([self option] == ETACCOUNT_GRAPH_OPTION_TYPE)
#define OPTION_KIND else if ([self option] == ETACCOUNT_GRAPH_OPTION_KIND)

@protocol ETAccountGraphOptionDealDelegate;

@interface ETAccountGraphOptionDetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UITableView *optionDetailTableViewController;
}

@property (assign, readwrite) id<ETAccountGraphOptionDealDelegate> graphOptionDelegate;

@property (readwrite) ETACCOUNT_GRAPH_OPTION option;

- (void)reloadTableView;

@end


@protocol ETAccountGraphOptionDealDelegate <NSObject>

- (void)didTypeChanged:(ETACCOUNT_GRAPH_TYPE)type;
- (void)didKindChanged:(ETACCOUNT_GRAPH_KIND)kind;

@end
