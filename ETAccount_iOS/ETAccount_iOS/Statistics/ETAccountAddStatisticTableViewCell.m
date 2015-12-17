//
//  ETAccountAddStatisticTableViewCell.m
//  ETAccount_iOS
//
//  Created by 기용 이 on 2015. 12. 6..
//  Copyright © 2015년 Eten. All rights reserved.
//

#import "ETAccountAddStatisticTableViewCell.h"

@implementation ETAccountAddStatisticTableViewCell

@synthesize cellSection;
@synthesize addDealCellDelegate;

#pragma mark - Date Picker

- (void)setDatePicker:(UIDatePickerMode)datePickerMode WithCurrentTime:(BOOL)isCurrentTime DatePickerIndex:(NSInteger)index DateString:(NSString *)dateString
{
    datePicker = [[UIDatePicker alloc] init];
    [datePicker setDatePickerMode:datePickerMode];
    if (isCurrentTime)
        [datePicker setDate:[NSDate date]];
    else
        [datePicker setDate:[ETFormatter dateFromDateSting:dateString]];
    
    NSLog(@"%@", [ETFormatter dateStringForDeal:[datePicker date]]);
         
    datePickerIndex = index;
    
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
    
    [titleTextField setText:[NSString stringWithFormat:@"%@", [ETFormatter dateStringForDeal:[datePicker date]]]];
    NSLog(@"asdf : %@", [titleTextField text]);
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
    NSLog(@"AA");
    [addDealCellDelegate didEndEditText:[titleTextField text] CellIndex:10 + datePickerIndex];
//    if ([sender tag] == NUMBER_SIGN_PLUS) {
//        [sender setTag:NUMBER_SIGN_MINUS];
//        [titleTextField setTextColor:[UIColor redColor]];
//    }
//    else {
//        [sender setTag:NUMBER_SIGN_PLUS];
//        [titleTextField setTextColor:[UIColor blackColor]];
//    }
}


#pragma mark - 델리게이트 메서드

#pragma mark UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [addDealCellDelegate didEndEditText:[textField text] CellIndex:cellSection];
}

@end
