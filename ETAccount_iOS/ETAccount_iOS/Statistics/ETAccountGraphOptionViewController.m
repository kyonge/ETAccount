//
//  ETAccountGraphOptionViewController.m
//  ETAccount_iOS
//
//  Created by 기용 이 on 2016. 3. 25..
//  Copyright © 2016년 Eten. All rights reserved.
//

#import "ETAccountGraphOptionViewController.h"

@interface ETAccountGraphOptionViewController ()

@end

@implementation ETAccountGraphOptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    tempType = [[ETAccountGraphView sharedView] graphType];
    tempKind = [[ETAccountGraphView sharedView] graphKind];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ETAccountGraphOptionDetailSegue"]) {
        ETAccountGraphOptionDetailViewController *graphOptionDetailViewController = (ETAccountGraphOptionDetailViewController *)[segue destinationViewController];
        [graphOptionDetailViewController setGraphOptionDelegate:self];
        [graphOptionDetailViewController setOption:selectedOption];
        [graphOptionDetailViewController reloadTableView];
    }
}


#pragma mark - 옵션 저장

- (IBAction)saveOption:(id)sender
{
    [[self navigationController] popViewControllerAnimated:YES];
    
    [_graphOptionDelegate didTypeChanged:tempType];
    [_graphOptionDelegate didKindChanged:tempKind];
}


#pragma mark 델리게이트 메서드

#pragma UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"ETAccountGraphOptionCellIdentifier";
    
    ETAccountGraphOptionCell *cell = (ETAccountGraphOptionCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ETAccountGraphOptionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(ETAccountGraphOptionCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        switch (tempType) {
            case ETACCOUNT_GRAPH_TYPE_EACH_TOTAL:
                [[cell optionNameLabel] setText:@"그래프 타입 : 항목별 총합"];
                break;
                
            case ETACCOUNT_GRAPH_TYPE_DAILY_FLOW:
                [[cell optionNameLabel] setText:@"그래프 타입 : 일자별 흐름"];
                
            default:
                break;
        }
    }
    else if (indexPath.row == 1) {
        switch (tempKind) {
            case ETACCOUNT_GRAPH_KIND_SQUARE: {
                [[cell optionNameLabel] setText:@"그래프 종류 : 사각형"];
                break;
            }
            case ETACCOUNT_GRAPH_KIND_LINE: {
                [[cell optionNameLabel] setText:@"그래프 종류 : 꺾은선"];
                break;
            }
        }
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
        selectedOption = ETACCOUNT_GRAPH_OPTION_TYPE;
    else if (indexPath.row == 1)
        selectedOption = ETACCOUNT_GRAPH_OPTION_KIND;
    
    return indexPath;
}

#pragma mark ETAccountGraphOptionDealDelegate

- (void)didTypeChanged:(ETACCOUNT_GRAPH_TYPE)type
{
    tempType = type;
    
    [optionListTableView reloadData];
}

- (void)didKindChanged:(ETACCOUNT_GRAPH_KIND)kind
{
    tempKind = kind;
    
    [optionListTableView reloadData];
}

@end
