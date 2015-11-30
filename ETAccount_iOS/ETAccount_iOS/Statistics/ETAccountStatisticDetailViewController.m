//
//  ETAccountStatisticDetailViewController.m
//  ETAccount_iOS
//
//  Created by 기용 이 on 2015. 11. 24..
//  Copyright © 2015년 Eten. All rights reserved.
//

#import "ETAccountStatisticDetailViewController.h"

@interface ETAccountStatisticDetailViewController ()

@end

@implementation ETAccountStatisticDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ETAccountAddStatisticSegue"]) {
//        [(ETAccountAddDealTableViewController *)[[(UINavigationController *)[segue destinationViewController] viewControllers] objectAtIndex:0] setAddDealDelegate:self];
    }
    else if ([[segue identifier] isEqualToString:@"ETAccountDetailStatisticItemSegue"]) {
        NSDictionary *selectedDeal = [resultArray objectAtIndex:selectedRow];
        
        NSString *tempDateString = [selectedDeal objectForKey:@"date"];
//        NSString *finalDateString = [ETFormatter dateColumnFormat:tempDateString];
        
        NSString *querryString_1 = [NSString stringWithFormat:@"SELECT Account.id FROM Account WHERE Account.name = '%@'", [selectedDeal objectForKey:@"account_1"]];
        NSArray *columnArray = [NSArray arrayWithObject:@"id"];
        NSArray *account_1_id = [ETUtility selectDataWithQuerry:querryString_1 FromFile:_DB WithColumn:columnArray];
        NSString *querryString_2 = [NSString stringWithFormat:@"SELECT Account.id FROM Account WHERE Account.name = '%@'", [selectedDeal objectForKey:@"account_2"]];
        NSArray *account_2_id = [ETUtility selectDataWithQuerry:querryString_2 FromFile:_DB WithColumn:columnArray];
        
        [(ETAccountDealDetailViewController *)[segue destinationViewController] setAddDealDelegate:self];
        [(ETAccountDealDetailViewController *)[segue destinationViewController] initDealDetailWithDate:tempDateString
                                                                                                  Name:[selectedDeal objectForKey:@"name"]
                                                                                                 Money:[selectedDeal objectForKey:@"money"]
                                                                                                  Left:[[[account_1_id objectAtIndex:0] objectForKey:@"id"] integerValue]
                                                                                                 Right:[[[account_2_id objectAtIndex:0] objectForKey:@"id"] integerValue]
                                                                                           Description:[selectedDeal objectForKey:@"description"]
                                                                                             tagTarget:[[selectedDeal objectForKey:@"tag_target_id"] integerValue]
                                                                                                    Id:[[selectedDeal objectForKey:@"id"] integerValue]];
    }
}

- (void)setStatisticDictionary:(NSDictionary *)inputDictionary
{
    statisticDictionary = [NSDictionary dictionaryWithDictionary:inputDictionary];
}

- (void)initStatistic
{
    // 통계 기본 데이터
    NSString *querryString = [NSString stringWithFormat:@"SELECT Statistic.id, Statistic.date_1, Statistic.date_2, Statistic.type, Statistic.is_favorite, Statistic.name, Statistic.statistic_order FROM Statistic Statistic WHERE Statistic.id=%@", [statisticDictionary objectForKey:@"id"]];
    NSArray *columnArray = [NSArray arrayWithObjects:@"id", @"date_1", @"date_2", @"type", @"is_favorite", @"name", @"statistic_order", nil];
    
    statisticDictionary = [[ETUtility selectDataWithQuerry:querryString FromFile:_DB WithColumn:columnArray] objectAtIndex:0];
//    NSLog(@"staticDictionary : %@", statisticDictionary);
    
    // 필터
    querryString = [NSString stringWithFormat:@"SELECT Filter.id, Filter.type, Filter.item, Filter.compare FROM Filter Filter JOIN Statistics_filter_match Match ON Filter.id = Match.filter_id WHERE Match.statistic_id=%@", [statisticDictionary objectForKey:@"id"]];
    columnArray = [NSArray arrayWithObjects:@"id", @"type", @"item", @"compare", nil];
    NSArray *filterArray = [ETUtility selectDataWithQuerry:querryString FromFile:_DB WithColumn:columnArray];
//    NSLog(@"%@", filterArray);
    
    // 기본 Deal SELECT 쿼리
    querryString = @"SELECT Deal.id, Deal.name, Deal.tag_target_id, Account_1.name account_1, Account_1.tag_target_id tag_target_id_1, Account_2.name account_2, Account_2.tag_target_id tag_target_id_2, money, description, Deal.date FROM Deal JOIN Account Account_1 ON Deal.account_id_1 = Account_1.id JOIN Account Account_2 ON Deal.account_id_2 = Account_2.id WHERE";
    
    // date 조건
    NSString *date_1String = [statisticDictionary objectForKey:@"date_1"];
    if (![date_1String isEqualToString:@"0"])
        querryString = [NSString stringWithFormat:@"%@ Deal.date>'%@' AND", querryString, date_1String];
    NSString *date_2String = [statisticDictionary objectForKey:@"date_2"];
    if (![date_2String isEqualToString:@"0"])
        querryString = [NSString stringWithFormat:@"%@ Deal.date>'%@' AND", querryString, date_2String];
//    NSLog(@"%@", querryString);
    
    // 필터 내용들을 Deal SELECT 쿼리에 추가
    for (NSDictionary *tempFilterDictionary in filterArray) {
//        NSLog(@"%@", tempFilterDictionary);
        FILTER_TYPE tempType = [[tempFilterDictionary objectForKey:@"type"] integerValue];
        NSInteger tempItem = [[tempFilterDictionary objectForKey:@"item"] integerValue];
        FILTER_COMPARE tempCompare = [[tempFilterDictionary objectForKey:@"compare"] integerValue];
        
        switch (tempType) {
            case FILTER_TYPE_ITEM:
                querryString = [NSString stringWithFormat:@"%@ (Deal.account_id_1='%ld' OR Deal.account_id_2='%ld') AND", querryString, (long)tempItem, (long)tempItem];
                break;
                
            case FILTER_TYPE_TAG: {
                NSString *tagQuerryString = [NSString stringWithFormat:@"SELECT Deal.id, Deal.tag_target_id, Tag_match.tag_id FROM Deal Deal JOIN Tag_match Tag_match ON Deal.tag_target_id = Tag_match.tag_target_id WHERE Tag_match.tag_id='%ld'", (long)tempItem];
                NSArray *tagColumnArray = [NSArray arrayWithObjects:@"id", @"tag_target_id", @"tag_id", nil];
                NSArray *tagTargetArray = [ETUtility selectDataWithQuerry:tagQuerryString FromFile:_DB WithColumn:tagColumnArray];
                
                querryString = [NSString stringWithFormat:@"%@ (", querryString];
                for (NSDictionary *tempTagTargetDictionary in tagTargetArray) {
                    NSNumber *tempItem = [tempTagTargetDictionary objectForKey:@"tag_id"];
                    querryString = [NSString stringWithFormat:@"%@ Deal.tag_target_id='%@' OR tag_target_id_1='%@' OR tag_target_id_2='%@' OR", querryString, tempItem, tempItem, tempItem];
                }
                querryString = [querryString substringToIndex:[querryString length] - 3];
                querryString = [NSString stringWithFormat:@"%@) AND", querryString];
                
                break;
            }
                
            case FILTER_TYPE_COST: {
                NSString *compareString;
                if (tempCompare == FILTER_COMPARE_SAME)
                    compareString = @"=";
                else if (tempCompare == FILTER_COMPARE_LEFT)
                    compareString = @">";
                else if (tempCompare == FILTER_COMPARE_SAME_LEFT)
                    compareString = @">=";
                else if (tempCompare == FILTER_COMPARE_RIGHT)
                    compareString = @"<";
                else if (tempCompare == FILTER_COMPARE_SAME_RIGHT)
                    compareString = @"<=";
                
                querryString = [NSString stringWithFormat:@"%@ ABS(money)%@%ld AND", querryString, compareString, (long)tempItem];
                
                break;
            }
                
            default:
                break;
        }
    }
    querryString = [querryString substringToIndex:[querryString length] - 4];
//    NSLog(@"%@", querryString);
    
    // ORDER BY
    querryString = [NSString stringWithFormat:@"%@ ORDER BY datetime(Deal.Date) DESC", querryString];
//    NSLog(@"%@", querryString);
    
    // Deal SELECT
    columnArray = [NSArray arrayWithObjects:@"id", @"name", @"tag_target_id", @"account_1", @"tag_target_id_1", @"account_2", @"tag_target_id_2", @"money", @"description", @"date", nil];
    resultArray = [ETUtility selectDataWithQuerry:querryString FromFile:_DB WithColumn:columnArray];
//    NSLog(@"%@", resultArray);
    
    [statisticTableView reloadData];
}


#pragma mark - 삭제

- (void)askDelete:(NSIndexPath *)indexPath TableView:(UITableView*)tableView
{
    UIAlertController *deleteAccountAlertControl = [UIAlertController
                                                    alertControllerWithTitle:@"거래 삭제"
                                                    message:@"거래를 삭제하시겠습니까?"
                                                    preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"삭제", @"Close action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   [self delete:indexPath TableView:tableView];
                               }];
    [deleteAccountAlertControl addAction:okAction];
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"취소", @"Cancel action")
                                   style:UIAlertActionStyleCancel
                                   handler:nil];
    [deleteAccountAlertControl addAction:cancelAction];
    
    [self presentViewController:deleteAccountAlertControl animated:YES completion:nil];
}

- (void)delete:(NSIndexPath *)indexPath TableView:(UITableView*)tableView
{
    NSDictionary *dealDictionary = [resultArray objectAtIndex:indexPath.row];
    
    // tag_target_id 삭제
    NSInteger targetTag = [[dealDictionary objectForKey:@"tag_target_id"] integerValue];
    [ETAccountDBManager deleteFromTable:@"Tag_target" OfId:targetTag];
    
    NSString *deleteMatchOfTargetQuerryString = [NSString stringWithFormat:@"DELETE FROM Tag_match WHERE tag_target_id = %ld", (long)targetTag];
    [ETUtility runQuerry:deleteMatchOfTargetQuerryString FromFile:_DB];
    
    // DB에서 삭제
    NSInteger targetAccountId = [[dealDictionary objectForKey:@"id"] integerValue];
    if (![ETAccountDBManager deleteFromTable:@"Deal" OfId:targetAccountId]) {
        [ETUtility showAlert:@"ETAccount" Message:@"삭제하지 못했습니다." atViewController:self withBlank:NO];
    }
    
    [self initStatistic];
    [tableView reloadData];
}


#pragma mark - 델리게이트 메서드

#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"Graph";
        case 1:
            return @"Result - Account";
        case 2:
            return @"Result - Tag";
        case 3:
            return @"Data";
    }
    
    return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 3)
        return [resultArray count];
    else return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
        return [[self view] frame].size.width;
    else if (indexPath.section == 3)
        return 60;
    else return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3) {
        static NSString *CellIdentifier = @"ETAccountStatisticResultDataListTableViewCellIdentifier";
        
        ETAccountTableViewCell *cell = (ETAccountTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[ETAccountTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        return cell;
    }
    
    static NSString *CellIdentifier = @"ETAccountStatisticResultValueListTableViewCellIdentifier";
    
    ETAccountStatisticDetailTableViewCell *cell = (ETAccountStatisticDetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    [cell setAddDealCellDelegate:self];
    if (cell == nil) {
        cell = [[ETAccountStatisticDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(ETAccountTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 3) {
        NSDictionary *tempAccountDictionary = [resultArray objectAtIndex:indexPath.row];
        NSString *tempDateString = [tempAccountDictionary objectForKey:@"date"];
        NSString *finalDateString = [ETFormatter dateColumnFormat:tempDateString];
        
        [[cell accountDateLabel] setText:finalDateString];
        [[cell accountNameLabel] setText:[tempAccountDictionary objectForKey:@"name"]];
        [[cell accountIncomeLabel] setText:[tempAccountDictionary objectForKey:@"account_1"]];
        [[cell accountExpenseLabel] setText:[tempAccountDictionary objectForKey:@"account_2"]];
        [[cell accountPriceLabel] setText:[NSString stringWithFormat:@"%@", [ETFormatter moneyFormatFromString:[tempAccountDictionary objectForKey:@"money"]]]];
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedRow = indexPath.row;
    
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
//            [cell setType:ADD_DEAL_CELL_TYPE_BUTTON];
//            [cell setTitle:@"날짜"];
            break;
        case 1:
//            [cell setType:ADD_DEAL_CELL_TYPE_TEXT];
//            [cell setPlaceholder:@"거래명"];
            break;
    }
    
    [tableView reloadData];
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    UITableViewRowAction *deleteTagAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                               title:@"Delete"
                                                                             handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
                                                                                 [tableView setEditing:NO animated:NO];
                                                                                 
                                                                                 [self askDelete:indexPath TableView:tableView];
                                                                             }];
    [deleteTagAction setBackgroundColor:[UIColor redColor]];
    
    [tableView setEditing:YES animated:NO];
    return [NSArray arrayWithObject:deleteTagAction];
}

#pragma mark ETAccountAddDealDelegate

- (void)didAddDeal
{
    [self initStatistic];
}

@end
