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
#import "ETAccountAddViewController.h"

#import "ETUtility.h"
#import "ETFormatter.h"

@interface ETAccountViewController : DetailViewController <UITableViewDataSource, UITableViewDelegate, ETAccountAddDelegate> {
    NSMutableArray *accountArray;
    
    IBOutlet UIBarButtonItem *addItem;
    
    ETAccountAddViewController *addViewController;
}

@property (strong) ETAccountAddViewController *addViewController;

@end
