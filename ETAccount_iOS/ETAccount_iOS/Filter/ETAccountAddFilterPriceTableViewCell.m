//
//  ETAccountAddFilterPriceTableViewCell.m
//  ETAccount_iOS
//
//  Created by 기용 이 on 2015. 12. 7..
//  Copyright © 2015년 Eten. All rights reserved.
//

#import "ETAccountAddFilterPriceTableViewCell.h"

@implementation ETAccountAddFilterPriceTableViewCell

@synthesize addDealCellDelegate;

#pragma mark - 델리게이트 메서드

#pragma mark UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [addDealCellDelegate didEndEditText:[textField text] CellIndex:2];
}

@end
