//
//  ETAccountAddTableViewCell.m
//  ETAccount_iOS
//
//  Created by 기용 이 on 2015. 9. 20..
//  Copyright (c) 2015년 Eten. All rights reserved.
//

#import "ETAccountAddTableViewCell.h"

@implementation ETAccountAddTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setType:(ADD_DEAL_CELL_TYPE)type
{
    switch (type) {
        case ADD_DEAL_CELL_TYPE_BUTTON:
            [titleLabel setHidden:NO];
            [titleTextField setHidden:YES];
            [plusMinusButton setHidden:YES];
            break;
            
        case ADD_DEAL_CELL_TYPE_TEXT:
            [titleLabel setHidden:YES];
            [titleTextField setKeyboardType:UIKeyboardTypeDefault];
            [titleTextField setHidden:NO];
            [plusMinusButton setHidden:YES];
            break;
            
        case ADD_DEAL_CELL_TYPE_NUMBERS:
            [titleLabel setHidden:YES];
            [titleTextField setKeyboardType:UIKeyboardTypeNumberPad];
            [titleTextField setHidden:NO];
            [plusMinusButton setHidden:NO];
            
            UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, DEVICE_SIZE.width, 50)];
            [numberToolbar setBarStyle:UIBarStyleBlackOpaque];
            [numberToolbar setItems:[NSArray arrayWithObjects:
//                                     [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(doneNumberPad)],
                                     [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                                     [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneNumberPad)],
                                     nil]];
            [numberToolbar sizeToFit];
            [titleTextField setInputAccessoryView:numberToolbar];
            break;
    }
}

- (void)doneNumberPad
{
    [titleTextField resignFirstResponder];
}

- (void)setTitle:(NSString *)titleString
{
    [titleLabel setText:titleString];
}

- (void)setPlaceholder:(NSString *)placeholderString
{
    [titleTextField setPlaceholder:placeholderString];
}

- (IBAction)closeKeyboard:(id)sender
{
    [sender resignFirstResponder];
}


#pragma mark - Date Picker

- (void)setDatePicker
{
    datePicker = [[UIDatePicker alloc] init];
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    
    UIToolbar* datePickerToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, DEVICE_SIZE.width, 50)];
    [datePickerToolbar setBarStyle:UIBarStyleBlackOpaque];
    [datePickerToolbar setItems:[NSArray arrayWithObjects:
                                 [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancleDatePicker)],
                                 [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                                 [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(acceptDatepicker)],
                                 nil]];
    [datePickerToolbar sizeToFit];
    
    [titleTextField setInputAccessoryView:datePickerToolbar];
    [titleTextField setInputView:datePicker];
    
    [titleTextField setText:[NSString stringWithFormat:@"%@", [ETFormatter dateStringForDeal:[datePicker date]]]];
}

- (void)cancleDatePicker
{
    [titleTextField resignFirstResponder];
}

- (void)acceptDatepicker
{
    [titleTextField setText:[NSString stringWithFormat:@"%@", [ETFormatter dateStringForDeal:[datePicker date]]]];
    [self cancleDatePicker];
}


#pragma maek - Plus&Minus

- (IBAction)changePlusMinus:(id)sender
{
    if ([sender tag] == NUMBER_PLUS) {
        [sender setTag:NUMBER_MINUS];
        [titleTextField setTextColor:[UIColor redColor]];
    }
    else {
        [sender setTag:NUMBER_PLUS];
        [titleTextField setTextColor:[UIColor blackColor]];
    }
}

@end
