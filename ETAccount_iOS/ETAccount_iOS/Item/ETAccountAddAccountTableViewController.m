//
//  ETAccountAddAccountTableViewController.m
//  ETAccount_iOS
//
//  Created by 기용 이 on 2015. 10. 16..
//  Copyright © 2015년 Eten. All rights reserved.
//

#import "ETAccountAddAccountTableViewController.h"

@interface ETAccountAddAccountTableViewController ()

@end

@implementation ETAccountAddAccountTableViewController

@synthesize addDelegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initItemList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initItemList
{
    //현재는 전체 로드 : 날짜순 조건 추가, 동적 로딩 추가
    
    NSString *querryString = @"SELECT Account.id, Account.name, Account.account_order FROM Account ORDER BY Account.account_order";
    NSArray *columnArray = [NSArray arrayWithObjects:@"id", @"name", @"account_order", nil];
    
    itemArray = [ETUtility selectDataWithQuerry:querryString FromFile:_DB WithColumn:columnArray];
}


#pragma maek - 추가

- (void)showAddAccountAlertControllerFromTableView:(UITableView *)tableView
{
    UIAlertController *addTagAlertControl = [UIAlertController
                                             alertControllerWithTitle:@"항목 추가"
                                             message:@"항목명을 입력해주세요"
                                             preferredStyle:UIAlertControllerStyleAlert];
    [addTagAlertControl addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        [textField setPlaceholder:@"항목명"];
        [textField setKeyboardType:UIKeyboardTypeDefault];
        newAccountTextField = textField;
    }];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"추가", @"Close action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   [self addNewAccount:[newAccountTextField text] TableView:tableView];
                               }];
    [addTagAlertControl addAction:okAction];
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"취소", @"Cancel action")
                                   style:UIAlertActionStyleCancel
                                   handler:nil];
    [addTagAlertControl addAction:cancelAction];
    
    [self presentViewController:addTagAlertControl animated:YES completion:nil];
}

- (void)addNewAccount:(NSString *)accountName TableView:(UITableView*)tableView
{
    // 태그
    NSInteger tag_target_1 = [ETAccountUtility getTagFromViewController:self];
    NSInteger tag_target_2 = [ETAccountUtility getTagFromViewController:self];
    NSInteger accountOrder = [ETAccountDBManager getLast:@"account_order" FromTable:@"Account"] + 1;
    
    if (tag_target_1 == -1 || tag_target_2 == -1)
        return;
    else {
        if (![self saveAccountWithTargetId11:tag_target_1 TargetId2:tag_target_2 Name:accountName Order:accountOrder]) {
            [ETUtility showAlert:@"ETAccount" Message:@"태그를 저장하지 못했습니다." atViewController:self withBlank:NO];
            return;
        }
    }
    
    [self initItemList];
    [tableView reloadData];
}

- (BOOL)saveAccountWithTargetId11:(NSInteger)targetId1 TargetId2:(NSInteger)targetId2 Name:(NSString *)accountName Order:(NSInteger)accountOrder
{
    NSArray *keyArray = [NSArray arrayWithObjects:@"name", @"tag_target_id", @"auto_target_id", @"account_order", nil];
    NSArray *objectsArray = [NSArray arrayWithObjects:
                             [NSString stringWithFormat:@"'%@'", accountName],
                             [NSString stringWithFormat:@"'%ld'", (long)targetId1],
                             [NSString stringWithFormat:@"'%ld'", (long)targetId2],
                             [NSString stringWithFormat:@"'%ld'", (long)accountOrder], nil];
    
    NSDictionary *dataDic = [NSDictionary dictionaryWithObjects:objectsArray forKeys:keyArray];
    
    if (![ETAccountDBManager insertToTable:@"Account" dataDictionary:dataDic]) {
        return NO;
    }
    
    return YES;
}


#pragma mark - 삭제

- (void)askDelete:(NSIndexPath *)indexPath TableView:(UITableView*)tableView
{
    UIAlertController *deleteAccountAlertControl = [UIAlertController
                                                    alertControllerWithTitle:@"항목 삭제"
                                                    message:@"계정 항목을 삭제하시겠습니까?"
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
    // 사용하고 있는 거래가 있는지 체크
    NSDictionary *dealDictionary = [itemArray objectAtIndex:indexPath.row];
    NSInteger targetAccountId = [[dealDictionary objectForKey:@"id"] integerValue];
    NSString *querryString = [NSString stringWithFormat:@"SELECT Deal.id FROM Deal WHERE account_id_1 = %ld OR account_id_2 = %ld", (long)targetAccountId, (long)targetAccountId];
    NSArray *keyArray = [NSArray arrayWithObject:@"id"];
    
    NSArray *dealsArray = [ETUtility selectDataWithQuerry:querryString FromFile:_DB WithColumn:keyArray];
    
    if ([dealsArray count] > 0) {
        [ETUtility showAlert:@"항목 삭제" Message:@"항목을 사용하고 있는 거래가 있습니다." atViewController:self withBlank:NO];
        return;
    }
    
    // DB에서 삭제
    if (![ETAccountDBManager deleteFromTable:@"Account" OfId:targetAccountId]) {
        [ETUtility showAlert:@"ETAccount" Message:@"삭제하지 못했습니다." atViewController:self withBlank:NO];
    }

    [self initItemList];
    [tableView reloadData];
}


#pragma maek - 델리게이트 메서드

#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [itemArray count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AccountTableViewCellIdentifier";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [itemArray count])
        [[cell textLabel] setText:@"신규 항목 추가"];
    else
        [[cell textLabel] setText:[[itemArray objectAtIndex:indexPath.row] objectForKey:@"name"]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [itemArray count])
        [self showAddAccountAlertControllerFromTableView:tableView];
    else {
        [addDelegate didSelectAccount:[[[itemArray objectAtIndex:indexPath.row] objectForKey:@"id"] integerValue]];
        [[self navigationController] popViewControllerAnimated:YES];
    }
    
    [tableView reloadData];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [itemArray count])
        return NO;
    
    return YES;
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

@end
