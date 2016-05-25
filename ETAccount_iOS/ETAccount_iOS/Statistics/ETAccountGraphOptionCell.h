//
//  ETAccountGraphOptionCell.h
//  ETAccount_iOS
//
//  Created by 기용 이 on 2016. 3. 27..
//  Copyright © 2016년 Eten. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ETAccountGraphOptionCell : UITableViewCell {
    IBOutlet UISwitch *optionSwitch;
}

@property (readwrite) IBOutlet UILabel *optionNameLabel;

@end
