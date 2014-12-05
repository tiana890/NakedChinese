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
#import "UIImageView+AFNetworking.h"

#define SERVER_ADDRESS @"http://china:8901/upload/picture/"

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

    if([self.word.packID isEqualToNumber:@1])
    {
        [self.pictureView setImage:[UIImage imageNamed:self.word.bigImage]];
    }
    else
    {
        [self.pictureView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", SERVER_ADDRESS, self.word.image]]];
    }
    NSLog(@"word frame = %@", NSStringFromCGRect(self.pictureView.frame));
    self.chineseLabel.text = self.word.material.materialZH;
    self.pinyinLabel.text = self.word.material.materialZH_TR;
    if([NSLocalizedString(@"lang", nil) isEqualToString:@"ru"])
    {
        [self.translationLabel setText:self.word.material.materialRU];
    }
    else
    {
        [self.translationLabel setText:self.word.material.materialEN];
    }

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(self.ifFavourite)
    {
        
    }
    else
    {
        
    }
}
#pragma mark - Custom Accessors

- (AVSpeechSynthesizer *)synthesizer {
    if (!_synthesizer) {
        _synthesizer = [AVSpeechSynthesizer new];
        _synthesizer.delegate = self;
        
        //по какой-то причине первая строка не произносится вслух
        AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:@" "];
        utterance.rate = AVSpeechUtteranceMaximumSpeechRate;
        utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];
        [_synthesizer speakUtterance:utterance];

    }
    return _synthesizer;
}

#pragma mark IBActions

- (IBAction)shareAction:(id)sender {
    [self shareWithActivityItems:@[@"say"]];
}
- (IBAction)sayAction:(id)sender {
    [self sayText:self.chineseLabel.text];
}

#pragma mark - Private

- (void)sayText:(NSString *)text {
    
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:text];
    utterance.rate = AVSpeechUtteranceMinimumSpeechRate;
    utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];
    [self.synthesizer speakUtterance:utterance];
}

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didStartSpeechUtterance:(AVSpeechUtterance *)utterance
{
    NSLog(@"start");
}

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer willSpeakRangeOfSpeechString:(NSRange)characterRange utterance:(AVSpeechUtterance *)utterance
{
    NSLog(@"%@", NSStringFromRange(characterRange));
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
