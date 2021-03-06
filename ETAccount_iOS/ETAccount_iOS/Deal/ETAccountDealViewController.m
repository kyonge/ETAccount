//
//  ETAccountDealViewController.m
//  ETAccount_iOS
//
//  Created by 기용 이 on 2015. 4. 9..
//  Copyright (c) 2015년 Eten. All rights reserved.
//

#import "ETAccountDealViewController.h"

@interface ETAccountDealViewController ()

@end

@implementation ETAccountDealViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initDeals];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ETAccountAddDealSegue"]) {
        [(ETAccountAddDealTableViewController *)[[(UINavigationController *)[segue destinationViewController] viewControllers] objectAtIndex:0] setAddDealDelegate:self];
    }
    else if ([[segue identifier] isEqualToString:@"ETAccountViewDealSegue"]) {
        NSDictionary *selectedDeal = [dealArray objectAtIndex:selectedRow];
        
        [self sendDealDateDictionray:selectedDeal ToDetailViewController:(ETAccountDealDetailViewController *)[segue destinationViewController]];
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

- (void)sendDealDateDictionray:(NSDictionary *)dealDataDictionary ToDetailViewController:(ETAccountDealDetailViewController *)detailViewController
{
    NSString *tempDateString = [dealDataDictionary objectForKey:@"date"];
//    NSString *finalDateString = [ETFormatter dateColumnFormat:tempDateString];
    
    NSString *querryString_1 = [NSString stringWithFormat:@"SELECT Account.id FROM Account WHERE Account.name = '%@'", [dealDataDictionary objectForKey:@"account_1"]];
    NSArray *columnArray = [NSArray arrayWithObject:@"id"];
    NSArray *account_1_id = [ETUtility selectDataWithQuerry:querryString_1 FromFile:_DB WithColumn:columnArray];
    NSString *querryString_2 = [NSString stringWithFormat:@"SELECT Account.id FROM Account WHERE Account.name = '%@'", [dealDataDictionary objectForKey:@"account_2"]];
    NSArray *account_2_id = [ETUtility selectDataWithQuerry:querryString_2 FromFile:_DB WithColumn:columnArray];
    
    [detailViewController setAddDealDelegate:self];
    [detailViewController initDealDetailWithDate:tempDateString
                                            Name:[dealDataDictionary objectForKey:@"name"]
                                           Money:[dealDataDictionary objectForKey:@"money"]
                                            Left:[[[account_1_id objectAtIndex:0] objectForKey:@"id"] integerValue]
                                           Right:[[[account_2_id objectAtIndex:0] objectForKey:@"id"] integerValue]
                                     Description:[dealDataDictionary objectForKey:@"description"]
                                       tagTarget:[[dealDataDictionary objectForKey:@"tag_target_id"] integerValue]
                                              Id:[[dealDataDictionary objectForKey:@"id"] integerValue]];
}


#pragma mark - 초기화

- (void)initDeals
{
    //현재는 전체 로드 : 날짜순 조건 추가, 동적 로딩 추가
    
    NSString *querryString = @"SELECT Deal.id, Deal.name, Deal.tag_target_id, Account_1.name account_1, Account_1.color_r account_1_r, Account_1.color_g account_1_g, Account_1.color_b account_1_b, Account_2.name account_2, Account_2.color_r account_2_r, Account_2.color_g account_2_g, Account_2.color_b account_2_b, money, description, Deal.date FROM Deal JOIN Account Account_1 ON Deal.account_id_1 = Account_1.id JOIN Account Account_2 ON Deal.account_id_2 = Account_2.id";
    NSArray *columnArray = [NSArray arrayWithObjects:
                            @"id", @"name", @"tag_target_id",
                            @"account_1", @"account_1_r", @"account_1_g", @"account_1_b",
                            @"account_2", @"account_2_r", @"account_2_g", @"account_2_b",
                            @"money", @"description", @"date", nil];
    
    if (isUntillToday)
        querryString = [NSString stringWithFormat:@"%@ WHERE Deal.date<=datetime('%@', '+1 day')", querryString, [[[ETFormatter dateStringForDeal:[NSDate date]] componentsSeparatedByString:@" "] objectAtIndex:0]];
    
     querryString = [NSString stringWithFormat:@"%@ ORDER BY datetime(Deal.Date) DESC", querryString];
    
    dealArray = [ETUtility selectDataWithQuerry:querryString FromFile:_DB WithColumn:columnArray];
//    NSLog(@"%@", dealArray);
}

- (IBAction)changeDateOption:(id)sender
{
    isUntillToday = !isUntillToday;
    
    [self initDeals];
    [dealListTableView reloadData];
}


#pragma mark - 추가

- (IBAction)addAccount:(id)sender
{
    [sender setEnabled:NO];
}


#pragma mark - 반복

- (void)repeatDeals:(NSIndexPath *)indexPath
{
    NSDictionary *selectedDeal = [dealArray objectAtIndex:indexPath.row];
    
    ETAccountDealRepeatViewController *repeatDealViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"ETAccountDealRepeatViewController"];
    [self sendDealDateDictionray:selectedDeal ToDetailViewController:repeatDealViewController];
    
    [self presentViewController:repeatDealViewController animated:YES completion:nil];
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
    NSDictionary *dealDictionary = [dealArray objectAtIndex:indexPath.row];
    
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
    
    [self initDeals];
    [tableView reloadData];
}


#pragma mark - 델리게이트 메서드

#pragma mark UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dealArray count];
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
    static NSString *CellIdentifier = @"DealTableViewCellIdentifier";
    
    ETAccountTableViewCell *cell = (ETAccountTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ETAccountTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(ETAccountTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *tempAccountDictionary = [dealArray objectAtIndex:indexPath.row];
    NSString *tempDateString = [tempAccountDictionary objectForKey:@"date"];
    NSString *finalDateString = [ETFormatter dateColumnFormat:tempDateString];
    
    [[cell accountDateLabel] setText:finalDateString];
    [[cell accountNameLabel] setText:[tempAccountDictionary objectForKey:@"name"]];
    [[cell accountIncomeLabel] setText:[tempAccountDictionary objectForKey:@"account_1"]];
    [[cell accountIncomeLabel] setTextColor:[UIColor colorWithRed:[[tempAccountDictionary objectForKey:@"account_1_r"] floatValue] / 255.0
                                                            green:[[tempAccountDictionary objectForKey:@"account_1_g"] floatValue] / 255.0
                                                             blue:[[tempAccountDictionary objectForKey:@"account_1_b"] floatValue] / 255.0 alpha:1.0]];
    [[cell accountExpenseLabel] setText:[tempAccountDictionary objectForKey:@"account_2"]];
    [[cell accountExpenseLabel] setTextColor:[UIColor colorWithRed:[[tempAccountDictionary objectForKey:@"account_2_r"] floatValue] / 255.0
                                                             green:[[tempAccountDictionary objectForKey:@"account_2_g"] floatValue] / 255.0
                                                              blue:[[tempAccountDictionary objectForKey:@"account_2_b"] floatValue] / 255.0 alpha:1.0]];
    [[cell accountPriceLabel] setText:[NSString stringWithFormat:@"%@", [ETFormatter moneyFormatFromString:[tempAccountDictionary objectForKey:@"money"]]]];
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedRow = indexPath.row;
    
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView reloadData];
//    [challengerDelegate searchChallengerNick:[challengerListArray objectAtIndex:indexPath.row]];
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    UITableViewRowAction *repeatTagAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                               title:@"Repeat"
                                                                             handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                                                                 [tableView setEditing:NO animated:NO];
                                                                                 
                                                                                 [self repeatDeals:indexPath];
                                                                             }];
    [repeatTagAction setBackgroundColor:[UIColor blueColor]];
    
    UITableViewRowAction *deleteTagAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                               title:@"Delete"
                                                                             handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
                                                                                 [tableView setEditing:NO animated:NO];
                                                                                 
                                                                                 [self askDelete:indexPath TableView:tableView];
                                                                             }];
    [deleteTagAction setBackgroundColor:[UIColor redColor]];
    
    [tableView setEditing:YES animated:NO];
    return [NSArray arrayWithObjects:repeatTagAction, deleteTagAction, nil];
}

#pragma mark ETAccountAddDelegate

- (void)closeAddView
{
    [addItem setEnabled:YES];
    
    [self initDeals];
}

#pragma mark ETAccountAddDealDelegate

- (void)didAddDeal
{
    [self initDeals];
    [dealListTableView reloadData];
}

@end
