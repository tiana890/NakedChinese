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

#import "NCTestResultViewController.h"

#import "NCPack.h"
#import "NCWord.h"
#import "NCDataManager.h"

#import "NCTest.h"
#import "NCQuestion.h"


@import AVFoundation;

#pragma mark Cells Identifiers
static NSString *const NCTestWordCellIdentifier = @"wordCell";
static NSString *const NCTestTranslationWordCellIdentifier = @"translationWordCell";

#pragma mark Height Constant
const CGFloat NCTestWordCellHeight = 104.f;
const CGFloat NCTestTranslationWordCellHeight = 55.f;


@interface NCQuestionViewController () <UITableViewDataSource, UITableViewDelegate, AVSpeechSynthesizerDelegate, NCDataManagerProtocol>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet FXBlurView *backgroundBlurView;
@property (weak, nonatomic) IBOutlet UIImageView *answerIndicatorView;
@property (weak, nonatomic) IBOutlet NCNavigationBar *navigationBar;

@property (strong, nonatomic) AVSpeechSynthesizer *synthesizer;

@property (nonatomic, strong) NSArray *wordsArray;
@property (nonatomic, strong) NSNumber *currentWord;

@property (nonatomic, strong) NCTest *test;
@property (nonatomic, strong) NSNumber *numberOfTestWords;
@end

@implementation NCQuestionViewController

#pragma mark getters and setters
- (NSNumber *)currentWord
{
    if(!_currentWord)
        return [[NSNumber alloc]initWithInt:0];
    else
        return _currentWord;
}

- (NCTest *)test
{
    if(!_test) _test = [[NCTest alloc] init];
    return _test;
}

#pragma mark - Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupBackgroundImage];
    
    [self.navigationBar separatorLineHide:YES];
    
    if(self.type != NCTestTypeLanguageChinese)
    {
        [self.soundButton setImage:nil];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    if(!self.ifFavorites)
    {
        NSMutableArray *idsArray = [[NSMutableArray alloc] init];
        for(NCPack *pack in self.packsArray)
        {
            [idsArray addObject:pack.ID];
        }
        [NCDataManager sharedInstance].delegate = self;
        [[NCDataManager sharedInstance] getLocalWordsWithPackIDs:idsArray];
    }
    else
    {
        [NCDataManager sharedInstance] .delegate = self;
        [[NCDataManager sharedInstance] getFavorites];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

#pragma mark Data Manager methods
- (void)ncDataManagerProtocolGetLocalWordsWithPackIDs:(NSArray *)arrayOfWords
{
    if(arrayOfWords.count > 0)
    {
        self.wordsArray = arrayOfWords;
        self.numberOfTestWords = [NSNumber numberWithInt:[self.test fillTestWithWordsArray:arrayOfWords andTestType:self.type]];
    }
}

- (void)ncDataManagerProtocolGetFavorites:(NSArray *)arrayOfFavorites
{
    if(arrayOfFavorites.count > 0)
    {
        self.wordsArray = arrayOfFavorites;
        self.numberOfTestWords = [NSNumber numberWithInt:[self.test fillTestWithWordsArray:arrayOfFavorites andTestType:self.type]];
    }
}
#pragma mark - Custom Accessors

- (AVSpeechSynthesizer *)synthesizer {
    if (!_synthesizer) {
        _synthesizer = [AVSpeechSynthesizer new];
        _synthesizer.delegate = self;
    }
    
    //по какой-то причине первая строка не произносится вслух
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:@" "];
    utterance.rate = AVSpeechUtteranceMaximumSpeechRate;
    utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];
    [_synthesizer speakUtterance:utterance];
    return _synthesizer;
}


#pragma mark - IBActions

- (IBAction)toBackAction:(id)sender {
    [UIAlertView showWithTitle:NSLocalizedString(@"ALERT_TEST_TITLE", nil)
                       message:NSLocalizedString(@"ALERT_TEST_MESSAGE", nil)
             cancelButtonTitle:NSLocalizedString(@"ALERT_TEST_CANCEL", nil)
             otherButtonTitles:@[NSLocalizedString(@"ALERT_TEST_ABORT", nil)]
                      tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex)
     {
         if (buttonIndex == 1) {
             [self.navigationController popViewControllerAnimated:YES];
         }
     }];
}

- (IBAction)soundWordAction:(id)sender {
    NCQuestion *q = [self.test getQuestionWithIndex:self.currentWord.intValue];
    if(self.type == NCTestTypeLanguageChinese)
    {
        [self sayText:q.word.material.materialZH];
    }
}

#pragma mark - Private

- (void)sayText:(NSString *)text {
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:text];
    utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];
    utterance.rate = AVSpeechUtteranceMinimumSpeechRate;
    [self.synthesizer speakUtterance:utterance];
}

- (void)parseAnswer:(int) index {
    UIImage *const correctImage = [UIImage imageNamed:@"nc_correct_answer"];
    UIImage *const wrongImage = [UIImage imageNamed:@"nc_wrong_answer"];
    
    BOOL ifRightAnswer = [self.test setAnswerIndex:index forQuestionWithIndex:self.currentWord.intValue];
    self.answerIndicatorView.image = (ifRightAnswer) ? correctImage : wrongImage;
    
    [self answerAnimation];
    
}

- (void)answerAnimation {
   
    [self hideUIItems:YES completion:^{
        [self hideAnswerIndicator:NO completion:^{
            int value = [self.currentWord intValue];
            value++;
            
            if(value < self.numberOfTestWords.intValue)
            {
                self.currentWord = [NSNumber numberWithInt:value];
                [self.tableView reloadData];
            }
            else
            {
                [self performSegueWithIdentifier:@"resultSegue" sender:self];
            }
            
            [self hideAnswerIndicator:YES completion:^{
                [self hideUIItems:NO completion:^{
                    
                }];
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
            //self.view.alpha = 0;
        }];
        
        
        [UIView addKeyframeWithRelativeStartTime:0.5f relativeDuration:0.3f animations:^{
           // self.view.alpha = 1;
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
    
    NCQuestion *q = [self.test getQuestionWithIndex:self.currentWord.intValue];
    
    UITableViewCell *cell = nil;
    if (index == 0) {
        NCTestWordCell *wordCell = [tableView dequeueReusableCellWithIdentifier:NCTestWordCellIdentifier forIndexPath:indexPath];
        
        if(self.type == NCTestTypeChineseLanguage)
        {
            wordCell.chineseLabel.text = q.word.material.materialWord;
            wordCell.pinyinLabel.text = @"";
        }
        else
        {
            wordCell.chineseLabel.text = q.word.material.materialZH;
            wordCell.pinyinLabel.text = q.word.material.materialZH_TR;
        }
        wordCell.userInteractionEnabled = NO;

        
        [wordCell layoutIfNeeded];
        [wordCell updateConstraintsIfNeeded];
        
        cell = wordCell;
    } else {
        
        NCTestTranslationWordCell *wordCell = [tableView dequeueReusableCellWithIdentifier:NCTestTranslationWordCellIdentifier forIndexPath:indexPath];
        
        if (index != 5) {
            index -= 1;
            wordCell.translationLabel.text = q.answerArray[index];
            wordCell.userInteractionEnabled = YES;
        } else {
            wordCell.translationLabel.text = [NSString stringWithFormat:@"%i/%i", self.currentWord.intValue+1, [self.test getNumberOfQuestions]];
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
        [self parseAnswer:(int)indexPath.row-1];
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self hideBarsLinesAlgorithmFromCalculationScrollView:scrollView];
}


#pragma mark - Navigation

 //In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NCTestResultViewController *rc = segue.destinationViewController;
    rc.rightResults = [self.test getMark];
    rc.rightResult = [NSNumber numberWithInt:[self.test getNumberOfRightAnswers]];
    rc.badResult = [NSNumber numberWithInt:[self.test getNumberOfQuestions] - rc.rightResult.intValue];
}


@end
