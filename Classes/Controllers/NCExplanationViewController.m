//
//  NCExplanationViewController.m
//  NakedChinese
//
//  Created by Dmitriy Karachentsov on 02.07.14.
//  Copyright (c) 2014 Dmitriy Karachentsov. All rights reserved.
//

#import "NCExplanationViewController.h"

#import "NCExplanationCell.h"
#import "NCMaterial.h"
#import "NCConstants.h"

static NSString *const NCExplanationCellIdentifier = @"explanationCell";
static NSString *const ExplanationTitleCellIdentifier = @"titleCell";

@interface NCExplanationViewController () <NCExplanationCellDelegate>
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UILabel *mainLabel;
@property (weak, nonatomic) IBOutlet UIButton *slideImage;
@property (weak, nonatomic) IBOutlet UILabel *sliderLabel;
@end

@implementation NCExplanationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.tableView.contentInset = UIEdgeInsetsMake(self.tableYOffset, 0, 0, 0);
}

#pragma mark getters & setters
- (void)setArrayOfExplanations:(NSArray *)arrayOfExplanations
{
    _arrayOfExplanations = arrayOfExplanations;
    if(arrayOfExplanations.count > 0)
    {
        //NSLog(@"load explanations");
        NCMaterial *material = _arrayOfExplanations[0];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[self stringWithLineBreaks:material.materialWord]];
        //[hogan addAttribute:NSFontAttributeName
                      //value:[UIFont systemFontOfSize:20.0]
                     // range:NSMakeRange(24, 11)];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setHeadIndent:100.0f];
        [paragraphStyle setTailIndent:-20.0f];
        paragraphStyle.firstLineHeadIndent = 40.0f;
        
        [str setAttributes: @{NSParagraphStyleAttributeName: paragraphStyle} range:NSRangeFromString(material.materialWord)];
        if(![str isEqualToAttributedString:[[NSAttributedString alloc] initWithString:@"none"]])
        {
            [self.mainLabel setAttributedText:str];
            
            CGSize size = [self.mainLabel systemLayoutSizeFittingSize:UILayoutFittingExpandedSize];
            [self.mainLabel setFrame:CGRectMake(self.mainLabel.frame.origin.x, self.mainLabel.frame.origin.y, size.width, size.height)];
            [self.headerView setFrame:CGRectMake(self.headerView.frame.origin.x, self.headerView.frame.origin.y, self.headerView.frame.size.width, self.mainLabel.frame.size.height + 8.0f)];
        }
        else
        {
            [self.headerView setFrame:CGRectZero];
        }
        [self.mainLabel updateConstraints];
        [self.headerView updateConstraints];
        //[self.tableView updateConstraints];
        //[self.headerView setFrame:CGRectMake(self.headerView.frame.origin.x, self.headerView.frame.origin.y, self.headerView.frame.size.width, size.height+20.0f)];
        [self.tableView reloadData];
        
    }
}

- (NSString *)stringWithLineBreaks:(NSString *)str
{
    return [str stringByReplacingOccurrencesOfString:@"\\n" withString:@"\r"];
}

#pragma mark - Lifecycle

#pragma mark - Custom Accessors

- (void)setState:(NCExplanationSliderState)state {
    if (_state != state) {
        switch (state) {
            case NCExplanationSliderVisible:
                [self animationSlideReplaceWithAngle:M_PI];
                self.sliderLabel.text = NSLocalizedString(@"explanation_return", nil);
                break;
            case NCExplanationSliderHidden:
                [self animationSlideReplaceWithAngle:0];
                self.sliderLabel.text = NSLocalizedString(@"explanation_add_info", nil);
                break;
            case NCExplanationSliderDragToDown:
                [self animationSlideReplaceWithAngle:M_PI];
                self.sliderLabel.text = NSLocalizedString(@"", @"");
                break;
            case NCExplanationSliderDragToUp:
                [self animationSlideReplaceWithAngle:0];
                self.sliderLabel.text = NSLocalizedString(@"", @"");
                break;
        }
        _state = state;
    }
}

#pragma mark - Private

- (void)animationSlideReplaceWithAngle:(CGFloat)angle {
    [UIView animateWithDuration:0.2 animations:^{
        self.slideImage.transform = CGAffineTransformMakeRotation(angle);
    }];
}

- (NCExplanationCell *)explanationCellAtIndexPath:(NSIndexPath *)indexPath withIdentifier:(NSString *)identifier{
    NCExplanationCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    [self configureExplanationCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureExplanationCell:(NCExplanationCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    
    /*
    NSDictionary *object = self.arrayOfExplanations[indexPath.row - 1];
    
    cell.chineseLabel.text = [NSString stringWithFormat:@"%ld.%@",indexPath.row+1, object[NCWordChineseKey]];
    cell.pinyinLabel.text = object[NCWordPinyinKey];
    cell.translateLabel.text = object[NCWordTranslateKey];*/
    
    NCMaterial *material = self.arrayOfExplanations[indexPath.row+1];
    /*if(indexPath.row == 0)
    {
        cell.chineseLabel.text = material.materialWord;
        cell.translateLabel.hidden = YES;
        cell.pinyinLabel.hidden = YES;
    }
    else
    {*/
        cell.chineseLabel.text = [NSString stringWithFormat:@"%@", material.materialZH];
        cell.pinyinLabel.text = material.materialZH_TR;
        cell.translateLabel.text = material.materialWord;
        cell.translateLabel.hidden = NO;
        cell.pinyinLabel.hidden = NO;
    //}
    
}

- (CGFloat)heightForBasicExplanationAtIndexPath:(NSIndexPath *)indexPath withIdentifier:(NSString *)identifier {
    static NCExplanationCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
    });

    [self configureExplanationCell:sizingCell atIndexPath:indexPath];
    return [self calculateHeightForConfiguredSizingCell:sizingCell];
}

- (CGFloat)calculateHeightForConfiguredSizingCell:(UITableViewCell *)sizingCell {
    //[sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height;
}

#pragma mark - UITableViewDataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    //if (indexPath.row == 0) {
        //cell = [self explanationCellAtIndexPath:indexPath withIdentifier:ExplanationTitleCellIdentifier];
       // cell = [tableView dequeueReusableCellWithIdentifier:ExplanationTitleCellIdentifier forIndexPath:indexPath];
        //NCMaterial *material = self.arrayOfExplanations[indexPath.row];
        //[((NCExplanationCell *)cell).translateLabel setText:material.materialWord];
   // } else {
        cell = [self explanationCellAtIndexPath:indexPath withIdentifier:NCExplanationCellIdentifier];
        if(indexPath.row == [self.arrayOfExplanations count]-2)
        {
            ((NCExplanationCell *)cell).lineView.hidden = YES;
        }
        else
        {
            ((NCExplanationCell *)cell).lineView.hidden = NO;
        }
    //}
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.arrayOfExplanations count]-1;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 105;
}

#pragma mark - NCExplanationCellDelegate

-(void)sayFromExplanationCell:(NCExplanationCell *)cell {
    NSLog(@"Say from cell: %@", cell.chineseLabel.text);
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat rowHeight = .0f;
    //if (indexPath.row == 0) {
        //rowHeight = [self heightForBasicExplanationAtIndexPath:indexPath withIdentifier:ExplanationTitleCellIdentifier];
        //rowHeight = 50.0f;
    //} else {
        rowHeight = [self heightForBasicExplanationAtIndexPath:indexPath withIdentifier:NCExplanationCellIdentifier];
    //}
    
    return rowHeight;
}
- (IBAction)swipeAction:(id)sender {
    
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    
//    CGFloat scrollHeight = scrollView.contentSize.height;
//    
//    if (scrollHeight == 0) {
//        return;
//    }
//    
//    CGFloat ratio = (scrollView.contentOffset.y + [self tableYOffset]) / scrollHeight;
//    
//    // prevent any crazy behaviour due to lag
//    // sometimes it resets itself when comes to reset and show crazy jumps
//    if (ratio == 0) {
//        return;
//    }
//    
//    [self.delegate explanationViewController:self tableScrollRatio:ratio];
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
