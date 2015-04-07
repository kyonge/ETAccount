//
//  MasterViewController.h
//  ETAccount_iOS
//
//  Created by 기용 이 on 2015. 4. 7..
//  Copyright (c) 2015년 Eten. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ETUtility.h"

@class DetailViewController;

@interface MasterViewController : UITableViewController {
    NSMutableArray *statDataArray;
}

@property (strong, nonatomic) DetailViewController *detailViewController;


@end

