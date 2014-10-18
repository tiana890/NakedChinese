//
//  NCWordContentViewController.m
//  NakedChinese
//
//  Created by Dmitriy Karachentsov on 03.07.14.
//  Copyright (c) 2014 Dmitriy Karachentsov. All rights reserved.
//

#import "NCWordContentViewController.h"
#import "NCConstants.h"

#import <AVFoundation/AVFoundation.h>

@interface NCWordContentViewController () <AVSpeechSynthesizerDelegate>
@property (strong, nonatomic) AVSpeechSynthesizer *synthesizer;

@property (weak, nonatomic) IBOutlet UIImageView *pictureView;
@property (weak, nonatomic) IBOutlet UILabel *chineseLabel;
@property (weak, nonatomic) IBOutlet UILabel *pinyinLabel;
@property (weak, nonatomic) IBOutlet UILabel *translationLabel;
@end

@implementation NCWordContentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.pictureView.image = self.dictionaryWithWord[NCWorkPictureKey];
    self.chineseLabel.text = self.dictionaryWithWord[NCWordChineseKey];
    self.pinyinLabel.text = self.dictionaryWithWord[NCWordPinyinKey];
    self.translationLabel.text = self.dictionaryWithWord[NCWordTranslateKey];
}

#pragma mark - Custom Accessors

- (AVSpeechSynthesizer *)synthesizer {
    if (!_synthesizer) {
        _synthesizer = [AVSpeechSynthesizer new];
        _synthesizer.delegate = self;
    }
    return _synthesizer;
}

#pragma mark IBActions

- (IBAction)shareAction:(id)sender {
    [self shareWithActivityItems:@[@"say"]];
}
- (IBAction)sayAction:(id)sender {
    [self sayText:self.dictionaryWithWord[NCWordChineseKey]];
}

#pragma mark - Private

- (void)sayText:(NSString *)text {
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:text];
    utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];
    [self.synthesizer speakUtterance:utterance];
}

- (void)shareWithActivityItems:(NSArray *)activityItems {
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityController.excludedActivityTypes = @[UIActivityTypeAirDrop, UIActivityTypeCopyToPasteboard, UIActivityTypePrint];
    [self presentViewController:activityController animated:YES completion:nil];
}

#pragma mark - AVSpeechSynthesizerDelegate

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance {
    NSLog(@"End utterance: %@",utterance.speechString);
}

@end
