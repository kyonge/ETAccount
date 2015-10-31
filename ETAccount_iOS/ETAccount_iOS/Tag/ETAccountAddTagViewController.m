//
//  ETAccountAddTagViewController.m
//  ETAccount_iOS
//
//  Created by 기용 이 on 2015. 10. 26..
//  Copyright © 2015년 Eten. All rights reserved.
//

#import "ETAccountAddTagViewController.h"

@interface ETAccountAddTagViewController ()

@end

@implementation ETAccountAddTagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initTagList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initTagList
{
    NSString *querryString = @"SELECT Tag.id, Tag.name FROM Tag ORDER BY Tag.'id'";
    NSArray *columnArray = [NSArray arrayWithObjects:@"id", @"name", nil];
    
    tagArray = [ETUtility selectDataWithQuerry:querryString FromFile:_DB WithColumn:columnArray];
}

- (void)setSelectedTags:(NSArray *)selectedArray
{
    selectedTagArray = [NSMutableArray arrayWithArray:selectedArray];
}


#pragma mark - 추가

- (void)showAddTabAlertControllerFromTableView:(UITableView *)tableView
{
    UIAlertController *addTagAlertControl = [UIAlertController
                                             alertControllerWithTitle:@"태그 추가"
                                             message:@"태그명을 입력해주세요"
                                             preferredStyle:UIAlertControllerStyleAlert];
    [addTagAlertControl addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        [textField setPlaceholder:@"태그명"];
        [textField setKeyboardType:UIKeyboardTypeDefault];
        newTagTextField = textField;
    }];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"추가", @"Close action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   [self addNewTag:[newTagTextField text] TableView:tableView];
                               }];
    [addTagAlertControl addAction:okAction];
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"취소", @"Cancel action")
                                   style:UIAlertActionStyleCancel
                                   handler:nil];
    [addTagAlertControl addAction:cancelAction];
    
    [self presentViewController:addTagAlertControl animated:YES completion:nil];
}

- (void)addNewTag:(NSString *)tagName TableView:(UITableView*)tableView
{
    NSArray *keyArray = [NSArray arrayWithObject:@"name"];
    NSArray *objectsArray = [NSArray arrayWithObject:[NSString stringWithFormat:@"'%@'", tagName]];
    
    NSDictionary *dataDic = [NSDictionary dictionaryWithObjects:objectsArray forKeys:keyArray];
    
    [self writeToDB:dataDic TableView:tableView];
}

- (void)writeToDB:(NSDictionary *)dataDic TableView:(UITableView*)tableView
{
    if (![ETAccountDBManager insertToTable:@"Tag" dataDictionary:dataDic]) {
        [ETUtility showAlert:@"ETAccount" Message:@"저장하지 못했습니다." atViewController:self withBlank:NO];
    }
    
    [self initTagList];
    [tableView reloadData];
}

- (void)delete:(NSIndexPath *)indexPath TableView:(UITableView*)tableView
{
    if (![ETAccountDBManager deleteFromTable:@"Tag" OfId:[[[tagArray objectAtIndex:indexPath.row] objectForKey:@"id"] integerValue]]) {
        [ETUtility showAlert:@"ETAccount" Message:@"삭제하지 못했습니다." atViewController:self withBlank:NO];
    }
    
    [self initTagList];
    [tableView reloadData];
}


#pragma maek - 델리게이트 메서드

#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [tagArray count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AccountTableViewCellIdentifier";
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (indexPath.row != [tagArray count])
        [cell setTag:[[[tagArray objectAtIndex:indexPath.row] objectForKey:@"id"] integerValue]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [tagArray count])
        [[cell textLabel] setText:@"신규 항목 추가"];
    else
        [[cell textLabel] setText:[[tagArray objectAtIndex:indexPath.row] objectForKey:@"name"]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != [tagArray count]) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if ([cell accessoryType] == UITableViewCellAccessoryNone)
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        else [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    else {
        [self showAddTabAlertControllerFromTableView:tableView];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    UITableViewRowAction *deleteTagAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                               title:@"Delete"
                                                                             handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
                                                                                 [tableView setEditing:NO animated:NO];
                                                                                 
                                                                                 [self delete:indexPath TableView:tableView];
                                                                             }];
    [deleteTagAction setBackgroundColor:[UIColor redColor]];
    
    return [NSArray arrayWithObject:deleteTagAction];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
