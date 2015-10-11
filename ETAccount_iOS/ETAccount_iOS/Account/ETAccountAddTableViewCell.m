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
            break;
            
            
        case ADD_DEAL_CELL_TYPE_TEXT:
            [titleLabel setHidden:YES];
            [titleTextField setKeyboardType:UIKeyboardTypeDefault];
            [titleTextField setHidden:NO];
            break;
            
        case ADD_DEAL_CELL_TYPE_NUMBERS:
            [titleLabel setHidden:YES];
            [titleTextField setKeyboardType:UIKeyboardTypeNumberPad];
            [titleTextField setHidden:NO];
            
            UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
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

@end
