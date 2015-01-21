//
//  NCExplanationCell.m
//  NakedChinese
//
//  Created by Dmitriy Karachentsov on 02.07.14.
//  Copyright (c) 2014 Dmitriy Karachentsov. All rights reserved.
//

#import "NCExplanationCell.h"
@import AVFoundation;

@interface NCExplanationCell ()<AVSpeechSynthesizerDelegate>
@property (strong, nonatomic) AVSpeechSynthesizer *synthesizer;
@end

@implementation NCExplanationCell
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

- (void)sayText:(NSString *)text {
    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:text];
    utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CN"];
    utterance.rate = 0.15f;
    [self.synthesizer speakUtterance:utterance];
}
- (IBAction)sayAction:(id)sender
{
    [self sayText:self.chineseLabel.text];
}

#pragma mark - NSObject

- (void)awakeFromNib
{
    // Initialization code
}

#pragma mark - UITableViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
