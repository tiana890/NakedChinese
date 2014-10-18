//
//  NCQuestionViewController.m
//  NakedChinese
//
//  Created by Dmitriy Karachentsov on 31.07.14.
//  Copyright (c) 2014 Dmitriy Karachentsov. All rights reserved.
//

#import "NCQuestionViewController.h"
#import "UIViewController+nc_interactionImageSetuper.h"

#import "NCTestWordCell.h"
#import "NCTestTranslationWordCell.h"
#import <FXBlurView/FXBlurView.h>

#import "NCNavigationBar.h"

#import "NCConstants.h"

#import <UIAlertView+Blocks/UIAlertView+Blocks.h>

@import AVFoundation;

#pragma mark Cells Identifiers
static NSString *const NCTestWordCellIdentifier = @"wordCell";
static NSString *const NCTestTranslationWordCellIdentifier = @"translationWordCell";

#pragma mark Height Constant
const CGFloat NCTestWordCellHeight = 104.f;
const CGFloat NCTestTranslationWordCellHeight = 55.f;


@interface NCQuestionViewController () <UITableViewDataSource, UITableViewDelegate, AVSpeechSynthesizerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet FXBlurView *backgroundBlurView;
@property (weak, nonatomic) IBOutlet UIImageView *answerIndicatorView;
@property (weak, nonatomic) IBOutlet NCNavigationBar *navigationBar;

@property (strong, nonatomic) AVSpeechSynthesizer *synthesizer;

@end

@implementation NCQuestionViewController

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupBackgroundImage];
    
    [self.navigationBar separatorLineHide:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

#pragma mark - Custom Accessors

- (AVSpeechSynthesizer *)synthesizer {
    if (!_synthesizer) {
        _synthesizer = [AVSpeechSynthesizer new];
        _synthesizer.delegate = self;
    }
    return _synthesizer;
}

#warning TEST_DATA
- (NSDictionary *)testWord {
    return @{NCWordChineseKey: @"現在，前橄欖球隊",
             NCWordPinyinKey : @"Zhè bùzhǐ"};
}

#pragma mark - IBActions

- (IBAction)toBackAction:(id)sender {
    [UIAlertView showWithTitle:NSLocalizedString(@"Прервать тест", @"ALERT_TEST_TITLE")
                       message:NSLocalizedString(@"Вы уверены что хотите прервать тест?", @"ALERT_TEST_MESSAGE")
             cancelButtonTitle:NSLocalizedString(@"Отмена", @"ALERT_TEST_CANCEL")
             otherButtonTitles:@[NSLocalizedString(@"Прервать", @"ALERT_TEST_ABORT")]
                      tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex)
     {
         if (buttonIndex == 1) {
             [self.navigationController popViewControllerAnimated:YES];
         }
     }];
}

- (IBAction)soundWordAction:(id)sender {
    [self sayText:self.testWord[NCWordChineseKey]];
}

#pragma mark - Private

- (void)sayText:(NSString *)text {
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:text];
    utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];
    [self.synthesizer speakUtterance:utterance];
}

- (void)parseAnswer {
    
    static BOOL toggle = NO;
    BOOL correctlyAnswer = toggle;
    toggle = !toggle;
    
    UIImage *const correctImage = [UIImage imageNamed:@"nc_correct_answer"];
    UIImage *const wrongImage = [UIImage imageNamed:@"nc_wrong_answer"];
    self.answerIndicatorView.image = correctlyAnswer ? correctImage : wrongImage;
    //[self answerAnimation];
    
}

- (void)answerAnimation {
    [self hideUIItems:YES completion:^{
        [self hideAnswerIndicator:NO completion:^{
            [self hideAnswerIndicator:YES completion:^{
                [self hideUIItems:NO completion:nil];
            }];
        }];
    }];
}

- (void)hideUIItems:(BOOL)hide completion:(void (^)(void))completion {
    CGFloat alpha = hide ? .0f : 1.f;
    [UIView animateWithDuration:0.5 animations:^{
        self.tableView.alpha = alpha;
        self.navigationBar.alpha = alpha;
    } completion:^(BOOL finished) {
        if (finished) {
            if (completion) {
                completion();
            }
        }
    }];
}

- (void)hideAnswerIndicator:(BOOL)hide completion:(void (^)(void))completion {
    [UIView animateWithDuration:0.5 animations:^{
        self.answerIndicatorView.alpha = hide ? 0.f : 1.f;
    } completion:^(BOOL finished) {
        if (finished) {
            if (completion) {
                completion();
            }
        }
    }];

}
- (void)hideBarsLinesAlgorithmFromCalculationScrollView:(UIScrollView *)scrollView {
    CGFloat scrollOffset = scrollView.contentOffset.y;
    BOOL isHideNavLine = !(scrollOffset > 0);
    [self.navigationBar separatorLineHide:isHideNavLine];
}

- (void)animationTransitionNextWordWithCompletion:(void (^)(void))completion {
    [UIView animateKeyframesWithDuration:1.2 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeCubic animations:^{
        
        [UIView addKeyframeWithRelativeStartTime:0.0f relativeDuration:0.3f animations:^{
            self.view.alpha = 0;
        }];
        
        
        [UIView addKeyframeWithRelativeStartTime:0.5f relativeDuration:0.3f animations:^{
            self.view.alpha = 1;
        }];
        
    } completion:^(BOOL finished) {
        if (completion && finished) {
            completion();
        }
    }];
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger index = [indexPath row];
    
    UITableViewCell *cell = nil;
    if (index == 0) {
        NCTestWordCell *wordCell = [tableView dequeueReusableCellWithIdentifier:NCTestWordCellIdentifier forIndexPath:indexPath];
        
        wordCell.chineseLabel.text = self.testWord[NCWordChineseKey];
        wordCell.pinyinLabel.text = self.testWord[NCWordPinyinKey];
        wordCell.userInteractionEnabled = NO;
        
        [wordCell layoutIfNeeded];
        [wordCell updateConstraintsIfNeeded];
        
        cell = wordCell;
    } else {
        
        NCTestTranslationWordCell *wordCell = [tableView dequeueReusableCellWithIdentifier:NCTestTranslationWordCellIdentifier forIndexPath:indexPath];
        
        if (index != 5) {
            index -= 1;
            wordCell.translationLabel.text = @"Вагина";
            wordCell.userInteractionEnabled = YES;
        } else {
            wordCell.translationLabel.text = @"1/20";
            wordCell.userInteractionEnabled = NO;
        }
        
        cell = wordCell;
    }
    return cell;
}

#pragma mark - <UITableViewDelegate>

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([indexPath row] == 0) {
        return NCTestWordCellHeight;
    }
    return NCTestTranslationWordCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self animationTransitionNextWordWithCompletion:^{
        [self parseAnswer];
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self hideBarsLinesAlgorithmFromCalculationScrollView:scrollView];
}

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
