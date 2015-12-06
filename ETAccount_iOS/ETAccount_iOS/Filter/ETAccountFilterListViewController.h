//
//  ETAccountFilterListViewController.h
//  ETAccount_iOS
//
//  Created by 기용 이 on 2015. 12. 6..
//  Copyright © 2015년 Eten. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Constants.h"
#import "ETUtility.h"

#import "ETAccountFilterDetailTableViewController.h"
#import "ETAccountAddFilterPriceTableViewCell.h"

@protocol ETAccountFilterSelectDelegate;

@interface ETAccountFilterListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, ETAccountFilterDetailDelegate, ETAccountAddDealCellDelegate> {
    IBOutlet UITableView *filterTableView;
    
    NSArray *itemsArray;
    NSString *selectedItem, *selectedItemId, *selectedPrice;
    
    FILTER_DETAIL selectedType;
    BOOL isTypeSelected;
}

@property (assign, readwrite) id<ETAccountFilterSelectDelegate> filterDetailDelegate;

@end


@protocol ETAccountFilterSelectDelegate <NSObject>

- (void)didSelect:(NSDictionary *)filterDataDictionary;

@end
