//
//  ETAccountAddViewController.h
//  ETAccount_iOS
//
//  Created by 기용 이 on 2015. 4. 10..
//  Copyright (c) 2015년 Eten. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ETAccountAddViewController : UIViewController <UITextFieldDelegate> {
    IBOutlet UITextField *inputDescriptionTextField;
    IBOutlet UITextField *inputValueTextField;
    IBOutlet UILabel *itemLeft_placeholderLabel;
    IBOutlet UILabel *itemRight_placeholderLabel;
}

@end
