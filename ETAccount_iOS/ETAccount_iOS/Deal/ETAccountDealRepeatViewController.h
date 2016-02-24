//
//  ETAccountDealRepeatViewController.h
//  ETAccount_iOS
//
//  Created by 기용 이 on 2016. 2. 23..
//  Copyright © 2016년 Eten. All rights reserved.
//

#import "ETAccountDealDetailViewController.h"

typedef enum : NSUInteger {
    PERIOD_DAILY,
    PERIOD_WEEKLY,
    PERIOD_MONTHLY,
    PERIOD_ANNUALLY
} PERIOD;

@interface ETAccountDealRepeatViewController : ETAccountDealDetailViewController <UIScrollViewDelegate, UITextFieldDelegate> {
    IBOutlet UISegmentedControl *pageSegmentedControl, *periodSegmentedControl;
    UIScrollView *pageScrollView;
    
    UITextField *divideCountTextField;
    UISlider *divideCountSlider;
    
    UITextField *repeatCountTextField;
    UISwitch *displaySwitch;
}

@end
