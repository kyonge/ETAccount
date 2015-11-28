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
    else if ([[segue identifier] isEqualToString:@"ETAccountViewStatisticSegue"]) {
//        NSDictionary *selectedDeal = [dealArray objectAtIndex:selectedRow];
//        
//        NSString *tempDateString = [selectedDeal objectForKey:@"date"];
//        //        NSString *finalDateString = [ETFormatter dateColumnFormat:tempDateString];
//        
//        NSString *querryString_1 = [NSString stringWithFormat:@"SELECT Account.id FROM Account WHERE Account.name = '%@'", [selectedDeal objectForKey:@"account_1"]];
//        NSArray *columnArray = [NSArray arrayWithObject:@"id"];
//        NSArray *account_1_id = [ETUtility selectDataWithQuerry:querryString_1 FromFile:_DB WithColumn:columnArray];
//        NSString *querryString_2 = [NSString stringWithFormat:@"SELECT Account.id FROM Account WHERE Account.name = '%@'", [selectedDeal objectForKey:@"account_2"]];
//        NSArray *account_2_id = [ETUtility selectDataWithQuerry:querryString_2 FromFile:_DB WithColumn:columnArray];
//        
//        [(ETAccountDealDetailViewController *)[segue destinationViewController] setAddDealDelegate:self];
//        [(ETAccountDealDetailViewController *)[segue destinationViewController] initDealDetailWithDate:tempDateString
//                                                                                                  Name:[selectedDeal objectForKey:@"name"]
//                                                                                                 Money:[selectedDeal objectForKey:@"money"]
//                                                                                                  Left:[[[account_1_id objectAtIndex:0] objectForKey:@"id"] integerValue]
//                                                                                                 Right:[[[account_2_id objectAtIndex:0] objectForKey:@"id"] integerValue]
//                                                                                           Description:[selectedDeal objectForKey:@"description"]
//                                                                                             tagTarget:[[selectedDeal objectForKey:@"tag_target_id"] integerValue]
//                                                                                                    Id:[[selectedDeal objectForKey:@"id"] integerValue]];
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

- (void)setStatisticDictionary:(NSDictionary *)inputDictionary
{
    statisticDictionary = [NSDictionary dictionaryWithDictionary:inputDictionary];
}

- (void)initStatistic
{
    NSString *querryString = [NSString stringWithFormat:@"SELECT Statistic.id, Statistic.date_1, Statistic.date_2, Statistic.type, Statistic.is_favorite, Statistic.name, Statistic.statistic_order FROM Statistic Statistic WHERE Statistic.id=%@", [statisticDictionary objectForKey:@"id"]];
    NSArray *columnArray = [NSArray arrayWithObjects:@"id", @"date_1", @"date_2", @"type", @"is_favorite", @"name", @"statistic_order", nil];
    
    statisticDictionary = [[ETUtility selectDataWithQuerry:querryString FromFile:_DB WithColumn:columnArray] objectAtIndex:0];
    NSLog(@"staticDictionary : %@", statisticDictionary);
}


#pragma mark - 델리게이트 메서드

#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"Graph";
        case 1:
            return @"";
    }
    
    return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0)
        return 1;
    else return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = @"ETAccountTableCellIdentifier";
    
    ETAccountStatisticDetailTableViewCell *cell = (ETAccountStatisticDetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    [cell setAddDealCellDelegate:self];
    if (cell == nil) {
        cell = [[ETAccountStatisticDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
//    [cell setCellSection:indexPath.section];
    
    switch (indexPath.section) {
        case 0:
//            [cell setType:ADD_DEAL_CELL_TYPE_TEXT];
//            [cell setPlaceholder:@"날짜"];
//            
//            [cell setDatePicker:UIDatePickerModeDate WithCurrentTime:YES];
            break;
        case 1:
//            [cell setType:ADD_DEAL_CELL_TYPE_TEXT];
//            [cell setPlaceholder:@"거래명"];
            break;
    }
    
    return cell;
}

//- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(nonnull NSIndexPath *)indexPath
//{
//    [[tableView cellForRowAtIndexPath:indexPath] resignFirstResponder];
//}

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

@end
