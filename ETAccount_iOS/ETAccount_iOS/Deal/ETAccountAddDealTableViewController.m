//
//  ETAccountAddDealTableViewController.m
//  ETAccount_iOS
//
//  Created by 기용 이 on 2015. 9. 20..
//  Copyright (c) 2015년 Eten. All rights reserved.
//

#import "ETAccountAddDealTableViewController.h"

@interface ETAccountAddDealTableViewController ()

@end

@implementation ETAccountAddDealTableViewController

@synthesize addDealDelegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([[segue identifier] isEqualToString:@"ETAccountAddDealSegue"]) {
//        [(ETAccountAddDealTableViewController *)[[(UINavigationController *)[segue destinationViewController] viewControllers] objectAtIndex:0] setAddDealDelegate:self];
//    }
}

- (IBAction)close:(id)sender
{
    UIAlertController *alertController = [ETUtility showAlert:@"ETAccount" Message:@"저장하지 않고 닫으시겠습니까?" atViewController:self withBlank:YES];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"닫기", @"Close action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   [addDealDelegate didAddDeal];
                                   [self dismissViewControllerAnimated:YES completion:nil];
                               }];
    [alertController addAction:okAction];
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"취소", @"Cancel action")
                                   style:UIAlertActionStyleCancel
                                   handler:nil];
    [alertController addAction:cancelAction];
}

- (NSInteger)getTag
{
    NSArray *tagKeyArray = [NSArray arrayWithObject:@"object"];
    NSArray *tagObjectsArray = [NSArray arrayWithObject:@"'1'"];
    NSDictionary *tagDataDic = [NSDictionary dictionaryWithObjects:tagObjectsArray forKeys:tagKeyArray];
    
    if (![ETAccountDBManager insertToTable:@"Tag_target" dataDictionary:tagDataDic]) {
        [ETUtility showAlert:@"ETAccount" Message:@"저장하지 못했습니다." atViewController:self withBlank:NO];
        return -1;
    }
    return [ETAccountDBManager getLastIdFromTable:@"Tag_target"];
}

- (IBAction)selectOk:(id)sender
{
    // 거래 명
    if(!dealNameString || [dealNameString length] == 0) {
        [ETUtility showAlert:@"ETAccount" Message:@"거래명을 입력해주세요" atViewController:self withBlank:NO];
        return;
    }
    NSString *tempDealNameString = [NSString stringWithFormat:@"'%@'", dealNameString];
    
    // 거래 날짜
    NSString *tempDealDateString = [NSString stringWithFormat:@"'%@'", dealDateString];
    
    // 가격
    NSMutableString *dealCost = [NSMutableString stringWithFormat:@"%ld", (long)dealPrice];
    if ([dealCost integerValue] == 0) {
        [ETUtility showAlert:@"ETAccount" Message:@"가격정보가 없습니다" atViewController:self withBlank:NO];
        return;
    }
    NSIndexPath *costIndex = [NSIndexPath indexPathForRow:0 inSection:2];
    if ([[(ETAccountAddTableViewCell *)[addDealTableView cellForRowAtIndexPath:costIndex] plusMinusButton] tag] == NUMBER_SIGN_MINUS) {
        if ([dealCost characterAtIndex:0] != '-')
            dealCost = [NSMutableString stringWithFormat:@"-%@", dealCost];
    }
    else {
        if ([dealCost characterAtIndex:0] == '-')
            dealCost = [NSMutableString stringWithFormat:@"%@", [dealCost substringFromIndex:1]];
    }
    
    
    // 좌변
    if (!isAccountLeftFilled) {
        [ETUtility showAlert:@"ETAccount" Message:@"좌변이 비어있습니다" atViewController:self withBlank:NO];
        return;
    }
    
    // 우변
    if (!isAccountRightFilled) {
        [ETUtility showAlert:@"ETAccount" Message:@"우변이 비어있습니다" atViewController:self withBlank:NO];
        return;
    }
    
    // 거래 설명
    NSString *tempDealDescription;
    NSIndexPath *descriptionIndex = [NSIndexPath indexPathForRow:0 inSection:4];
    NSString *dealDescription = [[[addDealTableView cellForRowAtIndexPath:descriptionIndex] titleTextField] text];
    if (!dealDescription || [dealDescription length] == 0) {
        if ([dealDescriptionString length] == 0)
            tempDealDescription = @"' '";
        else tempDealDescription = [NSString stringWithFormat:@"'%@'", dealDescriptionString];
    }
    else {
        tempDealDescription = [NSString stringWithFormat:@"'%@'", dealDescription];
    }
    
    // 태그
    NSInteger tag_target_1 = [self getTag];
    if (tag_target_1 == -1)
        return;
    else {
//        if (![ETAccountDBManager insertToTable:@"Tag_target" dataDictionary:tagDataDic]) {
//            [ETUtility showAlert:@"ETAccount" Message:@"저장하지 못했습니다." atViewController:self withBlank:NO];
////        return;
//        }
//        NSInteger tag_target_2 = [ETAccountDBManager getLastIdFromTable:@"Tag_target"];
//        
//        NSLog(@"%ld %ld", (long)tag_target_1, (long)tag_target_2);
        
        NSArray *keyArray = [NSArray arrayWithObjects:@"name", @"account_id_1", @"account_id_2", @"tag_target_id", @"description", @"'date'", @"money", nil];
        NSArray *objectsArray = [NSArray arrayWithObjects:tempDealNameString,
                                 [NSNumber numberWithInteger:accountLeftId], [NSNumber numberWithInteger:accountRightId],
                                 [NSNumber numberWithInteger:tag_target_1],
                                 tempDealDescription, tempDealDateString, dealCost, nil];
        
        NSDictionary *dataDic = [NSDictionary dictionaryWithObjects:objectsArray forKeys:keyArray];
//        NSLog(@"%@", dataDic);
        [self writeToDB:dataDic];
    }
}

- (void)writeToDB:(NSDictionary *)dataDic
{
    if (![ETAccountDBManager insertToTable:@"Deal" dataDictionary:dataDic]) {
        UIAlertController *errorAlertController = [ETUtility showAlert:@"ETAccount" Message:@"저장하지 못했습니다." atViewController:self withBlank:YES];
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:NSLocalizedString(@"확인", @"Cancel action")
                                       style:UIAlertActionStyleCancel
                                       handler:nil];
        [errorAlertController addAction:cancelAction];
    }
    
    [addDealDelegate didAddDeal];
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - 델리게이트 메서드

#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"일시";
        case 1:
            return @"거래명";
        case 2:
            return @"금액";
        case 3:
            return @"항목";
        case 4:
            return @"설명";
        case 5:
            return @"태그";
    }
    
    return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 3)
        return 2;
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = @"AddCell";
    
    ETAccountAddTableViewCell *cell = (ETAccountAddTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [cell setAddDealCellDelegate:self];
    if (cell == nil) {
        cell = [[ETAccountAddTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [cell setCellSection:indexPath.section];
    
    switch (indexPath.section) {
        case 0:
            [cell setType:ADD_DEAL_CELL_TYPE_TEXT];
            [cell setPlaceholder:@"날짜"];
            
            [cell setDatePicker:UIDatePickerModeDate];
            break;
        case 1:
            [cell setType:ADD_DEAL_CELL_TYPE_TEXT];
            [cell setPlaceholder:@"거래명"];
            break;
        case 2:
            [cell setType:ADD_DEAL_CELL_TYPE_NUMBERS];
            [cell setPlaceholder:@"금액"];
            break;
        case 3:
            [cell setType:ADD_DEAL_CELL_TYPE_BUTTON];
            
            if (indexPath.row == 0) {
                if (isAccountLeftFilled)
                    [cell setTitle:[ETAccountDBManager getItem:@"name" OfId:accountLeftId FromTable:@"Account"]];
                else
                    [cell setTitle:@"좌변"];
            }
            else if (indexPath.row == 1) {
                if (isAccountRightFilled)
                    [cell setTitle:[ETAccountDBManager getItem:@"name" OfId:accountRightId FromTable:@"Account"]];
                else
                    [cell setTitle:@"우변"];
            }
            break;
            
        case 4:
            [cell setType:ADD_DEAL_CELL_TYPE_TEXT];
            [cell setPlaceholder:@"설명"];
            break;
        case 5:
            [cell setType:ADD_DEAL_CELL_TYPE_BUTTON];
            [cell setTitle:@"Tags"];
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(ETAccountAddTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSDictionary *tempVenueDictionary = [currentVenueArray objectAtIndex:indexPath.row];
//    NSInteger tempRank = [[currentRankArray objectAtIndex:indexPath.row] integerValue];
//    
//    [POVenueSummaryCellController setVenueSummaryCell:cell dictionary:tempVenueDictionary withRank:tempRank BigSize:NO];
}

- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    [[tableView cellForRowAtIndexPath:indexPath] resignFirstResponder];
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
        case 2:
//            [cell setType:ADD_DEAL_CELL_TYPE_NUMBERS];
//            [cell setPlaceholder:@"금액"];
            break;
        case 3: {
            if (indexPath.row == 0)
                direction = ACCOUNT_DIRECTION_LEFT;
            else if(indexPath.row == 1)
                direction = ACCOUNT_DIRECTION_RIGHT;
            
            ETAccountAddAccountTableViewController *addItemTableViewController = [[ETAccountAddAccountTableViewController alloc] init];
            [addItemTableViewController setAddDelegate:self];
            [[self navigationController] pushViewController:addItemTableViewController animated:YES];
            break;
        }
        case 4:
//            [cell setType:ADD_DEAL_CELL_TYPE_TEXT];
//            [cell setPlaceholder:@"설명"];
            break;
        case 5: {
//            ETAccountAddTagViewController *addTagViewController = [[ETAccountAddTagViewController alloc] init];
            ETAccountAddTagViewController *addTagViewController = [[self storyboard] instantiateViewControllerWithIdentifier:@"ETAccountAddTagViewController"];
//            addTagViewController setSelectedTags:<#(NSArray *)#>
//            [addTagViewController setAddDelegate:self];
            [[self navigationController] pushViewController:addTagViewController animated:YES];
            break;
        }
    }
    
    [tableView reloadData];
}


#pragma mark ETAccountAddAccountDelegate

- (void)didSelectAccount:(NSInteger)accountId
{
    if (direction == ACCOUNT_DIRECTION_LEFT) {
        isAccountLeftFilled = YES;
        accountLeftId = accountId;
    }
    else if (direction == ACCOUNT_DIRECTION_RIGHT) {
        isAccountRightFilled = YES;
        accountRightId = accountId;
    }
    
    [addDealTableView reloadData];
}

#pragma mark ETAccountAddDealCellDelegate

- (void)didEndEditText:(NSString *)insertedText CellIndex:(NSInteger)index
{
    switch (index) {
        case 0:
            dealDateString = insertedText;
            break;
            
        case 1:
            dealNameString = insertedText;
            break;
            
        case 2:
            dealPrice = [insertedText integerValue];
            break;
            
        case 4:
            dealDescriptionString = insertedText;
            
        default:
            break;
    }
}

@end
