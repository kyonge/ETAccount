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

@synthesize changeTagDelegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initTagList];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [changeTagDelegate didChangeSelectedTagsArray:selectedTagsArray];
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
    selectedTagsArray = [NSMutableArray arrayWithArray:selectedArray];
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


#pragma mark - 삭제

- (void)delete:(NSIndexPath *)indexPath TableView:(UITableView*)tableView
{
    NSInteger deleteTagId = [[[tagArray objectAtIndex:indexPath.row] objectForKey:@"id"] integerValue];
    
    // DB에서 삭제
    if (![ETAccountDBManager deleteFromTable:@"Tag" OfId:deleteTagId]) {
        [ETUtility showAlert:@"ETAccount" Message:@"삭제하지 못했습니다." atViewController:self withBlank:NO];
    }
    
    if (![ETAccountDBManager deleteFromTable:@"Tag_match" OfId:deleteTagId Key:@"tag_id"]) {
        [ETUtility showAlert:@"ETAccount" Message:@"삭제하지 못했습니다." atViewController:self withBlank:NO];
    }
    
    // SelectedTagsArray에서 삭제
    for (NSDictionary *tempDic in selectedTagsArray) {
        if ([[tempDic objectForKey:@"id"] integerValue] == deleteTagId)
            [selectedTagsArray removeObject:tempDic];
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
    
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    
    for (NSDictionary *tempDic in selectedTagsArray) {
        if ([[tempDic objectForKey:@"id"] integerValue] == [cell tag])
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [tagArray count]) {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [[cell textLabel] setText:@"신규 항목 추가"];
    }
    else {
        [[cell textLabel] setText:[[tagArray objectAtIndex:indexPath.row] objectForKey:@"name"]];
        [[cell textLabel] setTag:[[[tagArray objectAtIndex:indexPath.row] objectForKey:@"id"] integerValue]];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != [tagArray count]) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if ([cell accessoryType] == UITableViewCellAccessoryNone) {
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            
            // SelectedTagsArray에 추가
            NSArray *tagObjectArray = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%ld", (long)[[cell textLabel] tag]], [[cell textLabel] text], nil];
            NSArray *tagKeyArray = [NSArray arrayWithObjects:@"id", @"name", nil];
            NSDictionary *tagDictionary = [NSDictionary dictionaryWithObjects:tagObjectArray forKeys:tagKeyArray];
            [selectedTagsArray addObject:tagDictionary];
            
            [tableView reloadData];
        }
        else {
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            
            // SelectedTagsArray에 삭제
            for (NSDictionary *tempDic in selectedTagsArray) {
                if ([[tempDic objectForKey:@"id"] integerValue] == [[cell textLabel] tag]) {
                    [selectedTagsArray removeObject:tempDic];
                    break;
                }
            }
        }
        
        [self initTagList];
        [changeTagDelegate didChangeSelectedTagsArray:selectedTagsArray];
    }
    else {
        [self showAddTabAlertControllerFromTableView:tableView];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [tagArray count])
        return NO;
    
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
