//
//  ETAccountTableViewCell.m
//  ETAccount_iOS
//
//  Created by 기용 이 on 2015. 4. 9..
//  Copyright (c) 2015년 Eten. All rights reserved.
//

#import "ETAccountTableViewCell.h"

@implementation ETAccountTableViewCell

@synthesize accountDateLabel;
@synthesize accountNameLabel;
@synthesize accountPriceLabel;
@synthesize accountIncomeLabel;
@synthesize accountExpenseLabel;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
