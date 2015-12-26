//
//  ETAccountEditStatisticViewController.m
//  ETAccount_iOS
//
//  Created by 기용 이 on 2015. 12. 18..
//  Copyright © 2015년 Eten. All rights reserved.
//

#import "ETAccountEditStatisticViewController.h"

@interface ETAccountEditStatisticViewController ()

@end

@implementation ETAccountEditStatisticViewController

@synthesize addStatisticDelegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ETAccountAddFilterSegue"]) {
        ETAccountFilterListViewController *addFilterViewController = (ETAccountFilterListViewController *)[segue destinationViewController];
        [addFilterViewController setFilterDetailDelegate:self];
    }
    else if ([[segue identifier] isEqualToString:@"ETAccountEditStatisticCell"] ||
        [[segue identifier] isEqualToString:@"ETAccountEditStatisticDateCell"] ||
        [[segue identifier] isEqualToString:@"ETAccountEditStatisticFilterCell"]) {
        ETAccountFilterListViewController *addFilterViewController = (ETAccountFilterListViewController *)[segue destinationViewController];
        [addFilterViewController setFilterDetailDelegate:self];
    }
}

- (void)initStatisticName:(NSString *)name DateString:(NSString *)date EndDateString:(NSString *)end StatisticId:(NSInteger)initId
{
    dealNameString = name;
    dealDateString = date;
    endDateString = end;
    statisticId = initId;
    
    NSString *querryString = [NSString stringWithFormat:@"SELECT Filter.id, Filter.type, Filter.item, Filter.compare, Statistics_filter_match.id match_id FROM Filter JOIN Statistics_filter_match ON Statistics_filter_match.filter_id = Filter.id WHERE statistic_id = %ld", (long)initId];
    filterArray = [ETUtility selectDataWithQuerry:querryString FromFile:_DB WithColumn:[NSArray arrayWithObjects:@"id", @"type", @"item", @"compare", @"match_id", nil]];
    lastFilterArray = [NSArray arrayWithArray:filterArray];
    
    [statisticTableView reloadData];
}


#pragma mark - 저장

- (void)writeToDB:(NSDictionary *)dataDic Table:(NSString *)tableName
{
//    NSLog(@"%@", dataDic);
    if (![ETAccountDBManager updateToTable:tableName dataDictionary:dataDic ToId:statisticId]) {
        UIAlertController *errorAlertController = [ETUtility showAlert:@"ETAccount" Message:@"저장하지 못했습니다." atViewController:self withBlank:YES];
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:NSLocalizedString(@"확인", @"Cancel action")
                                       style:UIAlertActionStyleCancel
                                       handler:nil];
        [errorAlertController addAction:cancelAction];
    }
    
    for (NSDictionary *tempFilterDictionary in lastFilterArray) {
        NSInteger tempFilterId = [[tempFilterDictionary objectForKey:@"id"] integerValue];
        BOOL isExist = [ETUtility doesArray:filterArray hasDictionaryWithId:tempFilterId];
        
        if (!isExist) {
            [ETAccountDBManager deleteFromTable:@"Filter" OfId:tempFilterId];
            [ETAccountDBManager deleteFromTable:@"Statistics_filter_match" OfId:[[tempFilterDictionary objectForKey:@"match_id"] integerValue]];
        }
    }
    
//    NSLog(@"%@", filterArray);
    for (NSDictionary *tempFilterDictionary in filterArray) {
        NSString *foundId = [ETAccountDBManager getItem:@"id" OfId:[[tempFilterDictionary objectForKey:@"id"] integerValue] FromTable:@"Filter"];
//        NSLog(@"foundId : %@", foundId);
        
        NSArray *keyArray = [NSArray arrayWithObjects:@"type", @"item", @"compare", nil];
        NSArray *objectsArray = [NSArray arrayWithObjects:[tempFilterDictionary objectForKey:@"type"],
                                 [tempFilterDictionary objectForKey:@"item"],
                                 [tempFilterDictionary objectForKey:@"compare"], nil];
        
        NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithObjects:objectsArray forKeys:keyArray];
        
        if ([foundId integerValue] == -1) {
            [ETAccountDBManager insertToTable:@"Filter" dataDictionary:dataDic];
            
            NSInteger lastFilterId = [ETAccountDBManager getLast:@"id" FromTable:@"Filter"];
            keyArray = [NSArray arrayWithObjects:@"statistic_id", @"filter_id", nil];
            objectsArray = [NSArray arrayWithObjects:
                            [NSString stringWithFormat:@"%ld", (long)statisticId],
                            [NSString stringWithFormat:@"%ld", (long)lastFilterId], nil];
            dataDic = [NSMutableDictionary dictionaryWithObjects:objectsArray forKeys:keyArray];
            [ETAccountDBManager insertToTable:@"Statistics_filter_match" dataDictionary:dataDic];
        }
//        else {
//            [dataDic setObject:foundId forKey:@"id"];
//            [ETAccountDBManager updateToTable:@"FIlter" dataDictionary:dataDic];
//        }
    }
    
    [addStatisticDelegate didAddDeal];
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - 델리게이트 메서드

#pragma mark Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = @"ETAccountEditStatisticCell";
    if (indexPath.section == 1)
        CellIdentifier = @"ETAccountEditStatisticDateCell";
    else if (indexPath.section == 2)
        CellIdentifier = @"ETAccountEditStatisticFilterCell";
    
    ETAccountEditStatisticTableViewCell *cell = (ETAccountEditStatisticTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ETAccountEditStatisticTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [cell setAddDealCellDelegate:self];
    [cell setCellSection:indexPath.section];
    
    return cell;
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    UITableViewRowAction *deleteTagAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                               title:@"Delete"
                                                                             handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
                                                                                 [tableView setEditing:NO animated:NO];
                                                                                 
                                                                                 [filterArray removeObjectAtIndex:indexPath.row];
                                                                                 [tableView reloadData];
                                                                             }];
    [deleteTagAction setBackgroundColor:[UIColor redColor]];
    
    [tableView setEditing:YES animated:NO];
    return [NSArray arrayWithObject:deleteTagAction];
}

@end
