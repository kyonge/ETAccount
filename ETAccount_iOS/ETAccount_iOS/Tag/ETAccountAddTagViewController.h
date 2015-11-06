//
//  ETAccountAddTagViewController.h
//  ETAccount_iOS
//
//  Created by 기용 이 on 2015. 10. 26..
//  Copyright © 2015년 Eten. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ETUtility.h"
#import "ETAccountDBManager.h"

@protocol ETAccountChangeTagDelegate;

@interface ETAccountAddTagViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate> {
    NSMutableArray *tagArray, *selectedTagsArray;
    
    UITextField *newTagTextField;
}

- (void)setSelectedTags:(NSArray *)selectedArray;

@property (assign, readwrite) id<ETAccountChangeTagDelegate> changeTagDelegate;

@end


@protocol ETAccountChangeTagDelegate <NSObject>

- (void)didChangeSelectedTagsArray:(NSArray *)newSelectedArray;

@end
