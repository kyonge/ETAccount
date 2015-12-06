//
//  ETAccountFilterDetailTableViewController.h
//  ETAccount_iOS
//
//  Created by 기용 이 on 2015. 12. 6..
//  Copyright © 2015년 Eten. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Constants.h"

@protocol ETAccountFilterDetailDelegate;

@interface ETAccountFilterDetailTableViewController : UITableViewController <UITextFieldDelegate> {
    FILTER_DETAIL selectedType;
}

@property (readwrite) NSArray *itemArray;
@property (readwrite) FILTER_DETAIL selectedType;
@property (assign, readwrite) id<ETAccountFilterDetailDelegate> filterDetailDelegate;

@end


@protocol ETAccountFilterDetailDelegate <NSObject>

- (void)didSelect:(FILTER_DETAIL)filterDetail Index:(NSInteger)index;

@end
