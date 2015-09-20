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

@synthesize superViewController;
@synthesize addDelegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 기본 컨트롤

- (IBAction)close:(id)sender
{
    UIAlertController *alertController = [ETUtility showAlert:@"ETAccount" Message:@"입력 창을 닫으시겠습니까?" atViewController:superViewController withBlank:YES];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"닫기", @"Close action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   [self close];
                               }];
    [alertController addAction:okAction];
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"취소", @"Cancel action")
                                   style:UIAlertActionStyleCancel
                                   handler:nil];
    [alertController addAction:cancelAction];
}

- (IBAction)closeKeyboards:(id)sender
{
    [inputNameTextField resignFirstResponder];
    [inputDescriptionTextField resignFirstResponder];
    [inputValueTextField resignFirstResponder];
}

- (void)close
{
    [[self view] removeFromSuperview];
    [addDelegate closeAddView];
}

- (IBAction)confirm:(id)sender
{
    
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
