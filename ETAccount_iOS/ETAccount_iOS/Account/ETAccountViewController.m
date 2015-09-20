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

@synthesize addViewController;

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
    //현재는 전체 로드 : 날짜순 조건 추가, 동적 로딩 추가
    
    NSString *qerryString = @"SELECT Deal.id, Deal.name, Account_1.name account_1, Account_2.name account_2, money, description, Deal.date FROM Deal JOIN Account Account_1 ON Deal.account_id_1 = Account_1.id JOIN Account Account_2 ON Deal.account_id_2 = Account_2.id";
    NSArray *columnArray = [NSArray arrayWithObjects:@"id", @"name", @"account_1", @"account_2", @"money", @"description", @"date", nil];
    
    accountArray = [ETUtility selectDataWithQuerry:qerryString FromFile:_DB WithColumn:columnArray];
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
    NSString *tempDateString = [tempAccountDictionary objectForKey:@"date"];
    NSString *finalDateString = [ETFormatter dateColumnFormat:tempDateString];
    
    [[cell accountDateLabel] setText:finalDateString];
    [[cell accountNameLabel] setText:[tempAccountDictionary objectForKey:@"description"]];
    [[cell accountIncomeLabel] setText:[tempAccountDictionary objectForKey:@"account_1"]];
    [[cell accountExpenseLabel] setText:[tempAccountDictionary objectForKey:@"account_2"]];
    [[cell accountPriceLabel] setText:[tempAccountDictionary objectForKey:@"money"]];
//    NSInteger tempRank = [[currentRankArray objectAtIndex:indexPath.row] integerValue];
//    
//    [POVenueSummaryCellController setVenueSummaryCell:cell dictionary:tempVenueDictionary withRank:tempRank BigSize:NO];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView reloadData];
//    [challengerDelegate searchChallengerNick:[challengerListArray objectAtIndex:indexPath.row]];
}

#pragma mark ETAccountAddDelegate

- (void)closeAddView
{
    [addItem setEnabled:YES];
    
    [self initAccount];
}

@end
