//
//  ETAccountAddTableViewCell.h
//  ETAccount_iOS
//
//  Created by 기용 이 on 2015. 9. 20..
//  Copyright (c) 2015년 Eten. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ETUtility.h"
#import "ETFormatter.h"
#import "Constants.h"

@protocol ETAccountAddDealCellDelegate;

@interface ETAccountAddTableViewCell : UITableViewCell <UITextFieldDelegate> {
    IBOutlet UILabel *titleLabel;
    IBOutlet UITextField *titleTextField;
    IBOutlet UIButton *plusMinusButton;
    
    UIDatePicker *datePicker;
}

- (void)setType:(ADD_DEAL_CELL_TYPE)type;
- (void)setTitle:(NSString *)titleString;
- (void)setPlaceholder:(NSString *)placeholderString;
#pragma mark - Date Picker
- (void)setDatePicker:(UIDatePickerMode)datePickerMode WithCurrentTime:(BOOL)isCurrentTime;
#pragma maek - Plus&Minus
- (IBAction)changePlusMinus:(id)sender;

@property (readwrite) NSInteger cellSection;
@property (readonly) UITextField *titleTextField;
@property (readonly) UIButton *plusMinusButton;

@property (assign, readwrite) id<ETAccountAddDealCellDelegate> addDealCellDelegate;

@end


@protocol ETAccountAddDealCellDelegate <NSObject>

- (void)didEndEditText:(NSString *)insertedText CellIndex:(NSInteger)index;

@end
