//
//  ETAccountViewController.h
//  ETAccount_iOS
//
//  Created by 기용 이 on 2015. 4. 9..
//  Copyright (c) 2015년 Eten. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DetailViewController.h"
#import "ETAccountTableViewCell.h"

#import "ETUtility.h"

@interface ETAccountViewController : DetailViewController <UITableViewDataSource, UITableViewDelegate> {
    NSMutableArray *accountArray;
}

@end
