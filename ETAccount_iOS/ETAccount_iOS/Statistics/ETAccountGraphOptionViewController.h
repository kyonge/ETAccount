//
//  ETAccountGraphOptionViewController.h
//  ETAccount_iOS
//
//  Created by 기용 이 on 2016. 3. 25..
//  Copyright © 2016년 Eten. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ETAccountGraphView.h"
#import "ETAccountGraphOptionCell.h"
#import "ETAccountGraphOptionDetailViewController.h"

@interface ETAccountGraphOptionViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ETAccountGraphOptionDealDelegate>{
    IBOutlet UITableView *optionListTableView;
    
    ETACCOUNT_GRAPH_OPTION selectedOption;
    
    ETACCOUNT_GRAPH_TYPE tempType;
    ETACCOUNT_GRAPH_KIND tempKind;
}

@property (assign, readwrite) id<ETAccountGraphOptionDealDelegate> graphOptionDelegate;

@end
