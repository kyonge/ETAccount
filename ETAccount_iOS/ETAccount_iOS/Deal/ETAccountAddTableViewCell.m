//
//  ETAccountAddTableViewCell.m
//  ETAccount_iOS
//
//  Created by 기용 이 on 2015. 9. 20..
//  Copyright (c) 2015년 Eten. All rights reserved.
//

#import "ETAccountAddTableViewCell.h"

@implementation ETAccountAddTableViewCell

@synthesize cellSection;
@synthesize titleTextField;
@synthesize plusMinusButton;
@synthesize addDealCellDelegate;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initNotification
{
    
}

- (void)removeNotification
{
    
}

- (void)setType:(ADD_DEAL_CELL_TYPE)type
{
    switch (type) {
        case ADD_DEAL_CELL_TYPE_DEFAULT:
            [titleLabel setHidden:YES];
            [titleTextField setHidden:YES];
            [plusMinusButton setHidden:YES];
            break;
            
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
            
        case ADD_DEAL_CELL_TYPE_NUMBERS: {
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
            
        case ADD_DEAL_CELL_TYPE_TEXT_WITH_ACC_BUTTON:
            [titleLabel setHidden:YES];
            [titleTextField setKeyboardType:UIKeyboardTypeDefault];
            [titleTextField setHidden:NO];
            [plusMinusButton setHidden:NO];
            break;
    }
}

- (void)doneNumberPad
{
    [titleTextField resignFirstResponder];
}

- (void)setTextFieldTag:(NSInteger)tag
{
    [titleTextField setTag:tag];
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
    [addDealCellDelegate didEndEditText:[(UITextField *)sender text] CellIndex:cellSection];
    
    [sender resignFirstResponder];
}


#pragma mark - Date Picker

- (void)setDatePicker:(UIDatePickerMode)datePickerMode WithCurrentTime:(BOOL)isCurrentTime DatePickerIndex:(NSInteger)index DateString:(NSString *)dateString
{
    datePicker = [[UIDatePicker alloc] init];
    [datePicker setDatePickerMode:datePickerMode];
    if (isCurrentTime)
        [datePicker setDate:[NSDate date]];
    else {
        if (![dateString isEqualToString:@"0"])
            [datePicker setDate:[ETFormatter dateFromDateSting:dateString]];
//        else
//            //날짜 설정 안한 경우
    }
//- (void)setDatePicker:(UIDatePickerMode)datePickerMode WithCurrentTime:(BOOL)isCurrentTime DatePickerIndex:(NSInteger)index
//{
//    datePicker = [[UIDatePicker alloc] init];
//    [datePicker setDatePickerMode:datePickerMode];
//    datePickerIndex = index;
    
    UIToolbar* datePickerToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, DEVICE_SIZE.width, 50)];
    [datePickerToolbar setBarStyle:UIBarStyleBlackOpaque];
    [datePickerToolbar setItems:[NSArray arrayWithObjects:
                                 [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelDatePicker)],
                                 [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                                 [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(acceptDatepicker)],
                                 nil]];
    [datePickerToolbar sizeToFit];
    
    [titleTextField setInputAccessoryView:datePickerToolbar];
    [titleTextField setInputView:datePicker];
    
    if (isCurrentTime)
        [titleTextField setText:[NSString stringWithFormat:@"%@", [ETFormatter dateStringForDeal:[datePicker date]]]];
    [addDealCellDelegate didEndEditText:[titleTextField text] CellIndex:10 + datePickerIndex];
}

- (void)cancelDatePicker
{
    [titleTextField resignFirstResponder];
}

- (void)acceptDatepicker
{
    [titleTextField setText:[NSString stringWithFormat:@"%@", [ETFormatter dateStringForDeal:[datePicker date]]]];
    [addDealCellDelegate didEndEditText:[titleTextField text] CellIndex:10 + datePickerIndex];
    
    [self cancelDatePicker];
}


#pragma maek - Accessor Button: Plus&Minus

- (IBAction)changePlusMinus:(id)sender
{
    if ([sender tag] == NUMBER_SIGN_PLUS) {
        [sender setTag:NUMBER_SIGN_MINUS];
        [titleTextField setTextColor:[UIColor redColor]];
    }
    else {
        [sender setTag:NUMBER_SIGN_PLUS];
        [titleTextField setTextColor:[UIColor blackColor]];
    }
}


#pragma mark - 델리게이트 메서드

#pragma mark UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [addDealCellDelegate didEndEditText:[textField text] CellIndex:cellSection];
}

@end


@implementation ETAccountAddTableViewDescriptionCell

- (void)initNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)removeNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidHideNotification object:nil];
}

- (void)keyboardWasShown:(NSNotification *)aNotification
{
    if (![[self titleTextField] isFirstResponder])
        return;
//    NSLog(@"%@", self);
    
    NSDictionary* info = [aNotification userInfo];
//    NSLog(@"info : %@", info);
    CGFloat animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
//    NSLog(@"%f", kbSize.height);
    
    [ETUtility AnimationView:[self window] toFrame:CGRectMake(0, -kbSize.height, DEVICE_SIZE.width, DEVICE_SIZE.height) toAlpha:1.0 inTime:animationDuration toTarget:self WithSelector:nil];
}

- (void)keyboardWillBeHidden:(NSNotification *)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGFloat animationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [ETUtility AnimationView:[self window] toFrame:CGRectMake(0, 0, DEVICE_SIZE.width, DEVICE_SIZE.height) toAlpha:1.0 inTime:animationDuration toTarget:self WithSelector:nil];
}

@end