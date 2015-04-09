//
//  ETAccountTableViewCell.h
//  ETAccount_iOS
//
//  Created by 기용 이 on 2015. 4. 9..
//  Copyright (c) 2015년 Eten. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ETAccountTableViewCell : UITableViewCell

@property (readwrite) IBOutlet UILabel *accountDateLabel;
@property (readwrite) IBOutlet UILabel *accountNameLabel;
@property (readwrite) IBOutlet UILabel *accountPriceLabel;
@property (readwrite) IBOutlet UILabel *accountIncomeLabel;
@property (readwrite) IBOutlet UILabel *accountExpenseLabel;

@end
