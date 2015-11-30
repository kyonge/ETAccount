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

@synthesize addViewController;

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
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


#pragma mark - 초기화

- (void)initDeals
{
    //현재는 전체 로드 : 날짜순 조건 추가, 동적 로딩 추가
    
    NSString *querryString = @"SELECT Deal.id, Deal.name, Deal.tag_target_id, Account_1.name account_1, Account_2.name account_2, money, description, Deal.date FROM Deal JOIN Account Account_1 ON Deal.account_id_1 = Account_1.id JOIN Account Account_2 ON Deal.account_id_2 = Account_2.id ORDER BY datetime(Deal.Date) DESC";
    NSArray *columnArray = [NSArray arrayWithObjects:@"id", @"name", @"tag_target_id", @"account_1", @"account_2", @"money", @"description", @"date", nil];
    
    dealArray = [ETUtility selectDataWithQuerry:querryString FromFile:_DB WithColumn:columnArray];
//    NSLog(@"%@", dealArray);
}


#pragma mark - 추가

- (IBAction)addAccount:(id)sender
{
    [sender setEnabled:NO];
    
    addViewController = [[ETAccountAddViewController alloc] init];
    [addViewController setSuperViewController:self];
    [addViewController setAddDelegate:self];
    [[self view] addSubview:[addViewController view]];
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
    [[cell accountExpenseLabel] setText:[tempAccountDictionary objectForKey:@"account_2"]];
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
