//
//  ETAccountGraphOptionDetailViewController.m
//  ETAccount_iOS
//
//  Created by 기용 이 on 2016. 3. 27..
//  Copyright © 2016년 Eten. All rights reserved.
//

#import "ETAccountGraphOptionDetailViewController.h"

@interface ETAccountGraphOptionDetailViewController ()

@end

@implementation ETAccountGraphOptionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadTableView
{
    [optionDetailTableViewController reloadData];
}


#pragma mark 델리게이트 메서드

#pragma UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"ETAccountGraphOptionDetailCellIdentifier";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0: {
            OPTION_TYPE
                [[cell textLabel] setText:@"항목별 총합"];
            OPTION_KIND
                [[cell textLabel] setText:@"사각형"];
            break;
        }
        case 1: {
            OPTION_TYPE
                [[cell textLabel] setText:@"일자별 흐름"];
            OPTION_KIND
                [[cell textLabel] setText:@"꺾은선"];
            break;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            OPTION_TYPE
                [_graphOptionDelegate didTypeChanged:ETACCOUNT_GRAPH_TYPE_EACH_TOTAL];
            OPTION_KIND
                [_graphOptionDelegate didKindChanged:ETACCOUNT_GRAPH_KIND_SQUARE];
            break;
            
        case 1:
            OPTION_TYPE
                [_graphOptionDelegate didTypeChanged:ETACCOUNT_GRAPH_TYPE_DAILY_FLOW];
            OPTION_KIND
                [_graphOptionDelegate didKindChanged:ETACCOUNT_GRAPH_KIND_LINE];
            break;
            
        default:
            break;
    }
    
    [[self navigationController] popViewControllerAnimated:YES];
}

@end
