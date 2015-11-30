//
//  ETAccountStatisticDetailTableViewCell.h
//  ETAccount_iOS
//
//  Created by 기용 이 on 2015. 11. 24..
//  Copyright © 2015년 Eten. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ETAccountStatisticDetailTableViewCell : UITableViewCell {
    IBOutlet UILabel *nameLabel;
    IBOutlet UILabel *moneyLabel;
}

@property (readonly) IBOutlet UILabel *nameLabel;
@property (readonly) IBOutlet UILabel *moneyLabel;

@end
