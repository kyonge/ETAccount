//
//  ETAccountAddTableViewCell.h
//  ETAccount_iOS
//
//  Created by 기용 이 on 2015. 9. 20..
//  Copyright (c) 2015년 Eten. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ETUtility.h"
#import "Constants.h"

@interface ETAccountAddTableViewCell : UITableViewCell {
    IBOutlet UILabel *titleLabel;
    IBOutlet UITextField *titleTextField;
}

- (void)setType:(ADD_DEAL_CELL_TYPE)type;
- (void)setTitle:(NSString *)titleString;
- (void)setPlaceholder:(NSString *)placeholderString;

@end
