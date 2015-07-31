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
#import "NCGreetingViewController.h"
#import "NCPackViewController.h"
#import "NCJokesViewController.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "NCNavigationBar.h"
#import <FXBlurView/FXBlurView.h>
#import "NCIAHelper.h"

#import "NCInteractionView.h"

#import "NCMenuCell.h"

#pragma mark Storyboard segues identifiers
static NSString *const NCLanguageControllerSegueIdentifier  = @"toLanguageController";
static NSString *const NCSubscribeControllerSegueIdentifier = @"toSubscribeController";
static NSString *const NCTestControllerSegueIdentifier = @"toTestController";
static NSString *const NCGreetingControllerSegueIdentifier = @"toGreetingController";
static NSString *const NCFavoritesControllerSegueIdentifier = @"toFavoritesController";
static NSString *const NCAuthorControllerSegueIdentifier = @"toAuthorController";
static NSString *const NCPartnersControllerSegueIdentifier = @"toPartnersController";
static NSString *const NCJokesControllerSegueIdentifier = @"toJokesController";

static NSString *const NCMenuIconKey  = @"icon";
static NSString *const NCMenuTitleKey = @"title";

@interface NCMenuViewController ()<MFMailComposeViewControllerDelegate>
@end

@implementation NCMenuViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupBackgroundImage];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    //[self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:146.0f/255.0f green:138.0f/255.0f blue:138.0f/255.0f alpha:1.0f]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productsRestored:) name:IAPHelperProductRestoreNotification  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productsRestoredFail:) name:IAPHelperProductRestoreFailNotification  object:nil];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:146.0f/255.0f green:138.0f/255.0f blue:138.0f/255.0f alpha:1.0f]];
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
    /*
     "about" = "About programm";
     "creators" = "Author";
     "partners" = "Our partners";
     "restore" = "Restore purchases";
     "fav" = "Favourites";
     "test" = "Test";
     "rate" = "Rate application";
     "feedback" = "Feedback";
     "site" = "Visit web site";
     "subscribe" = "Subscribe";
     */
    NSArray *items = nil;
    if (section == 0) {
        items = @[@{NCMenuIconKey: @"nc_lamp_b",  NCMenuTitleKey: NSLocalizedString(@"about", nil)},
                  //@{NCMenuIconKey: @"nc_user",  NCMenuTitleKey: NSLocalizedString(@"creators", nil)},
                  @{NCMenuIconKey: @"nc_mark",  NCMenuTitleKey: NSLocalizedString(@"partners", nil)},
                  @{NCMenuIconKey: @"nc_cart",  NCMenuTitleKey: NSLocalizedString(@"restore", nil)}];
                  //@{NCMenuIconKey: @"nc_globe", NCMenuTitleKey: @}];
    } else if (section == 1) {
        items = @[@{NCMenuIconKey: @"nc_favorite", NCMenuTitleKey: NSLocalizedString(@"fav", nil)},
                  @{NCMenuIconKey: @"nc_jokes_menu", NCMenuTitleKey: NSLocalizedString(@"jokes", nil)},
                  @{NCMenuIconKey: @"nc_check",    NCMenuTitleKey: NSLocalizedString(@"test", nil)}];
    } else if (section == 2) {
        items = @[@{NCMenuIconKey: @"nc_star",    NCMenuTitleKey: NSLocalizedString(@"rate", nil)},
                  @{NCMenuIconKey: @"nc_edit",    NCMenuTitleKey: NSLocalizedString(@"feedback", nil)}];
                 // @{NCMenuIconKey: @"nc_coffee",  NCMenuTitleKey: NSLocalizedString(@"site", nil)},
                  //@{NCMenuIconKey: @"nc_message", NCMenuTitleKey: NSLocalizedString(@"subscribe", nil)}];
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
            case 0:
            {
                [self performSegueWithIdentifier:NCGreetingControllerSegueIdentifier sender:self];
                break;
            }
           /* case 1:
            {
                [self performSegueWithIdentifier:NCAuthorControllerSegueIdentifier sender:self];
                break;
            }
            */
            case 1:
            {
                [self performSegueWithIdentifier:NCPartnersControllerSegueIdentifier sender:self];
                break;
            }
            case 2:
            {
                [[NCIAHelper sharedInstance] restoreCompletedTransactions];
                break;
            }
                
            case 3:
                [self performSegueWithIdentifier:NCLanguageControllerSegueIdentifier sender:self];
                break;
        }
    } else if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 0:
                [self performSegueWithIdentifier:NCFavoritesControllerSegueIdentifier sender:self];
                break;
            case 1:
                [self performSegueWithIdentifier:NCJokesControllerSegueIdentifier sender:self];
                break;
            case 2:
                [self performSegueWithIdentifier:NCTestControllerSegueIdentifier sender:self];
                break;
        }
    } else if (indexPath.section == 2) {
        switch (indexPath.row) {
            case 1:
                [self sendMail];
                break;
            case 3:
                [self performSegueWithIdentifier:NCSubscribeControllerSegueIdentifier sender:self];
                break;
        }
    }
}

- (void) sendMail
{
    MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
    [mailViewController setToRecipients:@[@"nakedchinese@yahoo.com"]];
    mailViewController.mailComposeDelegate = self;
    [mailViewController setSubject:@""];
    [mailViewController setMessageBody:NSLocalizedString(@"feedback_body", nil) isHTML:NO];
    
    [self presentViewController:mailViewController animated:YES completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
    if ([segue.identifier isEqualToString:NCTestControllerSegueIdentifier])
    {
        NCTestViewController *testController = [segue destinationViewController];
        testController.openFromMenu = YES;
    }
    else if([segue.identifier isEqualToString:NCGreetingControllerSegueIdentifier])
    {
        NCGreetingViewController *greetingController = [segue destinationViewController];
        greetingController.openFromMenu = YES;
    }
    else if([segue.identifier isEqualToString:NCFavoritesControllerSegueIdentifier])
    {
        NCPackViewController *packController = [segue destinationViewController];
        packController.type = NCPackControllerOfFavorite;
        packController.isOpenFromMenu = YES;
    }
    else if([segue.identifier isEqualToString:NCJokesControllerSegueIdentifier])
    {
        NCJokesViewController *jc = [segue destinationViewController];
        jc.isOpenFromMenu = YES;
    }
}

- (void)productsRestored:(NSNotification *) notification
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"product_restored", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)productsRestoredFail:(NSNotification *) notification
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:NSLocalizedString(@"product_restored_fail", nil) delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
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
