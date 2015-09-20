//
//  ETAccountAddViewController.m
//  ETAccount_iOS
//
//  Created by 기용 이 on 2015. 4. 10..
//  Copyright (c) 2015년 Eten. All rights reserved.
//

#import "ETAccountAddViewController.h"

@interface ETAccountAddViewController ()

@end

@implementation ETAccountAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 날짜 컨트롤

- (void)initDate
{
    
}

- (IBAction)selectDate:(id)sender
{
    
}


#pragma mark - 설명

- (void)inputDescriptionDone
{
    
}


#pragma mark - 금액

- (void)inputValueDone
{
    
}

- (IBAction)textFieldClose:(UITextField *)textField
{
    [textField resignFirstResponder];
}


#pragma mark - 항목

- (IBAction)selectItemLeft:(id)sender
{
    
}

- (IBAction)selectItemRight:(id)sender
{
    
}


#pragma mark - 델리게이트 메서드

#pragma mark UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == inputDescriptionTextField)
        [self inputDescriptionDone];
    else if (textField == inputValueTextField)
        [self inputValueDone];
}

@end
