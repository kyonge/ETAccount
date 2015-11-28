//
//  ETAccountStatisticListViewController.m
//  ETAccount_iOS
//
//  Created by 기용 이 on 2015. 11. 23..
//  Copyright © 2015년 Eten. All rights reserved.
//

#import "ETAccountStatisticListViewController.h"

@interface ETAccountStatisticListViewController ()

@end

@implementation ETAccountStatisticListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initStatistics];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ETAccountStatisticDetailSegue"]) {
        statisticDetailViewController = (ETAccountStatisticDetailViewController *)[segue destinationViewController];
//        ETAccountStatisticDetailViewController *statisticDetailViewController = (ETAccountStatisticDetailViewController *)[segue destinationViewController];
//        [statisticDetailViewController setStatisticDictionary:tempStaticDictionary];
//        [statisticDetailViewController initStatistic];
    }
}


#pragma mark - 초기화

- (void)initStatistics
{
    //현재는 전체 로드 : 날짜순 조건 추가, 동적 로딩 추가
    
    NSString *querryString = @"SELECT Statistic.id, Statistic.name, Statistic.statistic_order FROM Statistic Statistic ORDER BY Statistic.statistic_order";
    NSArray *columnArray = [NSArray arrayWithObjects:@"id", @"name", @"statistic_order", nil];
//    NSString *querryString = @"SELECT Deal.id, Deal.name, Deal.tag_target_id, Account_1.name account_1, Account_2.name account_2, money, description, Deal.date FROM Deal JOIN Account Account_1 ON Deal.account_id_1 = Account_1.id JOIN Account Account_2 ON Deal.account_id_2 = Account_2.id ORDER BY datetime(Deal.Date) DESC";
//    NSArray *columnArray = [NSArray arrayWithObjects:@"id", @"name", @"tag_target_id", @"account_1", @"account_2", @"money", @"description", @"date", nil];
//    NSLog(@"%@", querryString);
    
    statisticArray = [ETUtility selectDataWithQuerry:querryString FromFile:_DB WithColumn:columnArray];
//    NSLog(@"%@", statisticArray);
}


#pragma mark - 델리게이트 메서드

#pragma mark UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [statisticArray count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (ETAccountStatisticListTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"StatisticListTableViewCellIdentifier";
    
    ETAccountStatisticListTableViewCell *cell = (ETAccountStatisticListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ETAccountStatisticListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(ETAccountStatisticListTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"%@", [[statisticArray objectAtIndex:indexPath.row] objectForKey:@"name"]);
    [[cell textLabel] setText:[[statisticArray objectAtIndex:indexPath.row] objectForKey:@"name"]];
//    NSDictionary *tempAccountDictionary = [dealArray objectAtIndex:indexPath.row];
//    NSString *tempDateString = [tempAccountDictionary objectForKey:@"date"];
//    NSString *finalDateString = [ETFormatter dateColumnFormat:tempDateString];
//    
//    [[cell accountDateLabel] setText:finalDateString];
//    [[cell accountNameLabel] setText:[tempAccountDictionary objectForKey:@"name"]];
//    [[cell accountIncomeLabel] setText:[tempAccountDictionary objectForKey:@"account_1"]];
//    [[cell accountExpenseLabel] setText:[tempAccountDictionary objectForKey:@"account_2"]];
//    [[cell accountPriceLabel] setText:[tempAccountDictionary objectForKey:@"money"]];
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
//    selectedRow = indexPath.row;
    
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    tempStaticDictionary = [statisticArray objectAtIndex:indexPath.row];
    [statisticDetailViewController setStatisticDictionary:[statisticArray objectAtIndex:indexPath.row]];
    [statisticDetailViewController initStatistic];
    
    [tableView reloadData];
//    [challengerDelegate searchChallengerNick:[challengerListArray objectAtIndex:indexPath.row]];
}

//- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
//{
//    UITableViewRowAction *deleteTagAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
//                                                                               title:@"Delete"
//                                                                             handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
//                                                                                 [tableView setEditing:NO animated:NO];
//                                                                                 
//                                                                                 [self askDelete:indexPath TableView:tableView];
//                                                                             }];
//    [deleteTagAction setBackgroundColor:[UIColor redColor]];
//    
//    [tableView setEditing:YES animated:NO];
//    return [NSArray arrayWithObject:deleteTagAction];
//}

@end
