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

- (void)addNewTag:(NSString *)tagName
{
    NSArray *keyArray = [NSArray arrayWithObject:@"name"];
    NSArray *objectsArray = [NSArray arrayWithObject:[NSString stringWithFormat:@"'%@'", tagName]];
    
    NSDictionary *dataDic = [NSDictionary dictionaryWithObjects:objectsArray forKeys:keyArray];
    [self writeToDB:dataDic];
    
//    NSArray *objectArray = [NSArray arrayWithObjects:@"0", tagName, nil];
//    NSArray *keyArray = [NSArray arrayWithObjects:@"id", @"name", nil];
//    [tagArray addObject:[NSDictionary dictionaryWithObjects:objectArray forKeys:keyArray]];
}

- (void)writeToDB:(NSDictionary *)dataDic
{
    if (![ETAccountDBManager insertToTable:@"Tag" dataDictionary:dataDic]) {
        UIAlertController *errorAlertController = [ETUtility showAlert:@"ETAccount" Message:@"저장하지 못했습니다." atViewController:self withBlank:YES];
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:NSLocalizedString(@"확인", @"Cancel action")
                                       style:UIAlertActionStyleCancel
                                       handler:nil];
        [errorAlertController addAction:cancelAction];
    }
    else
        [self initTagList];
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
//        UIAlertController *addTagAlertControl = [ETUtility showAlert:@"태그 추가" Message:@"태그명을 입력해주세요" atViewController:self withBlank:YES];
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
                                       [self addNewTag:[newTagTextField text]];
                                       [tableView reloadData];
                                   }];
        [addTagAlertControl addAction:okAction];
        
        UIAlertAction *cancelAction = [UIAlertAction
                                       actionWithTitle:NSLocalizedString(@"취소", @"Cancel action")
                                       style:UIAlertActionStyleCancel
                                       handler:nil];
        [addTagAlertControl addAction:cancelAction];
        
        [self presentViewController:addTagAlertControl animated:YES completion:nil];
    }
}

@end
