//
//  ETAccountViewController.m
//  ETAccount_iOS
//
//  Created by 기용 이 on 2015. 4. 9..
//  Copyright (c) 2015년 Eten. All rights reserved.
//

#import "ETAccountViewController.h"

@interface ETAccountViewController ()

@end

@implementation ETAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initAccount];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 초기화

- (void)initAccount
{
    accountArray = [ETUtility selectAllSQliteDatasFromFile:@"ETAccount.sqlite" Table:@"AccountTable" WithColumn:[NSArray arrayWithObjects:@"idx", @"date", @"item_left", @"value_left", @"item_right", @"description", nil]];
}


#pragma mark - 델리게이트 메서드

#pragma mark UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [accountArray count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (ETAccountTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AccountTableViewCellIdentifier";
    
    ETAccountTableViewCell *cell = (ETAccountTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ETAccountTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(ETAccountTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *tempAccountDictionary = [accountArray objectAtIndex:indexPath.row];
    [[cell accountDateLabel] setText:[tempAccountDictionary objectForKey:@"date"]];
    [[cell accountNameLabel] setText:[tempAccountDictionary objectForKey:@"description"]];
    [[cell accountIncomeLabel] setText:[tempAccountDictionary objectForKey:@"item_left"]];
    [[cell accountExpenseLabel] setText:[tempAccountDictionary objectForKey:@"item_right"]];
    [[cell accountPriceLabel] setText:[tempAccountDictionary objectForKey:@"value_left"]];
//    NSInteger tempRank = [[currentRankArray objectAtIndex:indexPath.row] integerValue];
//    
//    [POVenueSummaryCellController setVenueSummaryCell:cell dictionary:tempVenueDictionary withRank:tempRank BigSize:NO];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView reloadData];
    //    [challengerDelegate searchChallengerNick:[challengerListArray objectAtIndex:indexPath.row]];
}

@end
