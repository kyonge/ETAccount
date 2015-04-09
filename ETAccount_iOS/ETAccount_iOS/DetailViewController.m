//
//  DetailViewController.m
//  ETAccount_iOS
//
//  Created by 기용 이 on 2015. 4. 7..
//  Copyright (c) 2015년 Eten. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
            
        // Update the view.
        [self configureView];
    }
}

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.detailItem) {
//        self.detailDescriptionLabel.text = [self.detailItem description];
//        if ([[[self detailItem] objectForKey:@"name"] isEqualToString:@"가계부"]) {
//            NSLog(@"!!");
//            [[self view] addSubview:[accountViewController view]];
//        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    accountViewController = [ETAccountViewController new];
    
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
