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
    [self.tableView reloadData];
}

#pragma mark - Lifecycle

#pragma mark - Custom Accessors

- (void)setState:(NCExplanationSliderState)state {
    if (_state != state) {
        switch (state) {
            case NCExplanationSliderVisible:
                [self animationSlideReplaceWithAngle:M_PI];
                self.sliderLabel.text = NSLocalizedString(@"Вернуться назад", @"pull to down");
                break;
            case NCExplanationSliderHidden:
                [self animationSlideReplaceWithAngle:0];
                self.sliderLabel.text = NSLocalizedString(@"Дополнительная информация", @"pull to up");
                break;
            case NCExplanationSliderDragToDown:
                [self animationSlideReplaceWithAngle:M_PI];
                self.sliderLabel.text = NSLocalizedString(@"", @"continue to pull down");
                break;
            case NCExplanationSliderDragToUp:
                [self animationSlideReplaceWithAngle:0];
                self.sliderLabel.text = NSLocalizedString(@"", @"continue to pull up");
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
    
    NCMaterial *material = self.arrayOfExplanations[indexPath.row];
    if(indexPath.row == 0)
    {
        cell.translateLabel.text = material.materialWord;
    }
    else
    {
        cell.chineseLabel.text = [NSString stringWithFormat:@"%d.%@",indexPath.row, material.materialZH];
        cell.pinyinLabel.text = material.materialZH_TR;
        cell.translateLabel.text = material.materialWord;
    }
    
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
    if (indexPath.row == 0) {
        cell = [self explanationCellAtIndexPath:indexPath withIdentifier:ExplanationTitleCellIdentifier];
       // cell = [tableView dequeueReusableCellWithIdentifier:ExplanationTitleCellIdentifier forIndexPath:indexPath];
       // NCMaterial *material = self.arrayOfExplanations[indexPath.row];
       // [((NCExplanationCell *)cell).translateLabel setText:material.materialWord];
    } else {
        cell = [self explanationCellAtIndexPath:indexPath withIdentifier:NCExplanationCellIdentifier];
    }
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.arrayOfExplanations count];
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
    if (indexPath.row == 0) {
        rowHeight = [self heightForBasicExplanationAtIndexPath:indexPath withIdentifier:ExplanationTitleCellIdentifier];
    } else {
        rowHeight = [self heightForBasicExplanationAtIndexPath:indexPath withIdentifier:NCExplanationCellIdentifier];
    }
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
