//
//  ETAccountAddStatisticTableViewCell.h
//  ETAccount_iOS
//
//  Created by 기용 이 on 2015. 12. 6..
//  Copyright © 2015년 Eten. All rights reserved.
//

#import "ETAccountAddTableViewCell.h"

@interface ETAccountAddStatisticTableViewCell : ETAccountAddTableViewCell

@property (readwrite) NSInteger cellSection;
@property (assign, readwrite) id<ETAccountAddDealCellDelegate> addDealCellDelegate;

@end
