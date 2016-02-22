//
//  ETAccountDealRepeatViewController.m
//  ETAccount_iOS
//
//  Created by 기용 이 on 2016. 2. 23..
//  Copyright © 2016년 Eten. All rights reserved.
//

#import "ETAccountDealRepeatViewController.h"

@interface ETAccountDealRepeatViewController ()

@end

@implementation ETAccountDealRepeatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadView
{
    
}

- (IBAction)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)confirm:(id)sender
{
    
}

- (IBAction)changePage:(UISegmentedControl *)segmentedControl
{
    NSLog(@"[segmentControl selectedSegmentIndex] : %d", [segmentedControl selectedSegmentIndex]);
}

@end
