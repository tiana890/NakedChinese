//
//  NCMenuViewController.m
//  NakedChinese
//
//  Created by Dmitriy Karachentsov on 28.07.14.
//  Copyright (c) 2014 Dmitriy Karachentsov. All rights reserved.
//

#import "NCMenuViewController.h"
#import "UIViewController+nc_interactionImageSetuper.h"
#import "NCTestViewController.h"

#import "NCNavigationBar.h"
#import <FXBlurView/FXBlurView.h>

#import "NCInteractionView.h"

#import "NCMenuCell.h"

#pragma mark Storyboard segues identifiers
static NSString *const NCLanguageControllerSegueIdentifier  = @"toLanguageController";
static NSString *const NCSubscribeControllerSegueIdentifier = @"toSubscribeController";
static NSString *const NCTestControllerSegueIdentifier = @"toTestController";

static NSString *const NCMenuIconKey  = @"icon";
static NSString *const NCMenuTitleKey = @"title";

@interface NCMenuViewController ()
@end

@implementation NCMenuViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupBackgroundImage];
}

#pragma mark - IBActions

- (IBAction)hideMenuAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Private

- (void)hideBarsLinesAlgorithmFromCalculationScrollView:(UIScrollView *)scrollView {
    CGFloat scrollOffset = scrollView.contentOffset.y;
    BOOL isHideNavLine = !(scrollOffset > 0);
    [((NCNavigationBar *)self.navigationController.navigationBar) separatorLineHide:isHideNavLine];
}

- (NSArray *)menuItemsForSection:(NSInteger)section {
    NSArray *items = nil;
    if (section == 0) {
        items = @[@{NCMenuIconKey: @"nc_lamp_b",  NCMenuTitleKey: @"О программе"},
                  @{NCMenuIconKey: @"nc_user",  NCMenuTitleKey: @"Создатели"},
                  @{NCMenuIconKey: @"nc_mark",  NCMenuTitleKey: @"Наши партнеры"},
                  @{NCMenuIconKey: @"nc_cart",  NCMenuTitleKey: @"Восстановить покупки"},
                  @{NCMenuIconKey: @"nc_globe", NCMenuTitleKey: @"Поменять язык"}];
    } else if (section == 1) {
        items = @[@{NCMenuIconKey: @"nc_favorite", NCMenuTitleKey: @"Избранное"},
                  @{NCMenuIconKey: @"nc_check",    NCMenuTitleKey: @"Тест"}];
    } else if (section == 2) {
        items = @[@{NCMenuIconKey: @"nc_star",    NCMenuTitleKey: @"Оценить приложение"},
                  @{NCMenuIconKey: @"nc_edit",    NCMenuTitleKey: @"Написать нам"},
                  @{NCMenuIconKey: @"nc_coffee",  NCMenuTitleKey: @"Посетить веб-сайт"},
                  @{NCMenuIconKey: @"nc_message", NCMenuTitleKey: @"Рассылка"}];
    }
    return items;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self menuItemsForSection:section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *const cellIdentifier = @"Cell";
    NCMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    NSArray *items = [self menuItemsForSection:indexPath.section];
    NSDictionary *item = items[indexPath.row];
    
    cell.pictureView.image = [UIImage imageNamed:item[NCMenuIconKey]];
    cell.titleLabel.text = item[NCMenuTitleKey];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 4:
                [self performSegueWithIdentifier:NCLanguageControllerSegueIdentifier sender:self];
                break;
        }
    } else if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
                
                break;
            case 1:
                [self performSegueWithIdentifier:NCTestControllerSegueIdentifier sender:self];
                break;
        }
    } else if (indexPath.section == 2) {
        switch (indexPath.row) {
            case 3:
                [self performSegueWithIdentifier:NCSubscribeControllerSegueIdentifier sender:self];
                break;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 5;
    }
    return 25;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self hideBarsLinesAlgorithmFromCalculationScrollView:scrollView];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:NCTestControllerSegueIdentifier]) {
        NCTestViewController *testController = [segue destinationViewController];
        testController.openFromMenu = YES;
    }
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

@end
