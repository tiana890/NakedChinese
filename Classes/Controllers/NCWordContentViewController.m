//
//  NCWordContentViewController.m
//  NakedChinese
//
//  Created by Dmitriy Karachentsov on 03.07.14.
//  Copyright (c) 2014 Dmitriy Karachentsov. All rights reserved.
//

#import "NCWordContentViewController.h"
#import "NCConstants.h"
#import "NCAppDelegate.h"

#import <AVFoundation/AVFoundation.h>
#import "UIImageView+AFNetworking.h"

#import "NCWordImageViewController.h"

#define SERVER_ADDRESS @"http://china:8901/upload/picture/"

@interface NCWordContentViewController () <AVSpeechSynthesizerDelegate>
@property (strong, nonatomic) AVSpeechSynthesizer *synthesizer;

@property (weak, nonatomic) IBOutlet UIImageView *pictureView;
@property (weak, nonatomic) IBOutlet UILabel *chineseLabel;
@property (weak, nonatomic) IBOutlet UILabel *pinyinLabel;
@property (weak, nonatomic) IBOutlet UILabel *translationLabel;
@property (strong, nonatomic) IBOutlet UIButton *hiddenViewButton;
@property (strong, nonatomic) IBOutlet UIView *helpView;


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
        UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfFile:self.word.bigImage]];
        [self.pictureView setImage:img];
        
    }
    self.chineseLabel.text = self.word.material.materialZH;
    self.pinyinLabel.text = self.word.material.materialZH_TR;
    [self.translationLabel setText:self.word.material.materialWord];
    
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
    [self shareWithActivityItems:@[NSLocalizedString(@"share_text", nil), self.pictureView.image]];
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


- (void)shareWithActivityItems:(NSArray *)activityItems {
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityController.excludedActivityTypes = @[UIActivityTypeAirDrop, UIActivityTypeCopyToPasteboard, UIActivityTypePrint];
    [self presentViewController:activityController animated:YES completion:nil];
}

#pragma mark - AVSpeechSynthesizerDelegate

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance {
    NSLog(@"End utterance: %@",utterance.speechString);
}

- (IBAction)zoomButtonPressed:(id)sender
{
    /*
    UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
    [self.hiddenView setFrame:keyWindow.frame];
    //[keyWindow addSubview:self.hiddenView];
    
    self.hiddenView.hidden = NO;
    [UIView animateWithDuration:1.0f animations:^{
        [self.hiddenView setAlpha:1.0f];
        self.hiddenViewButton.userInteractionEnabled = YES;
    }];
    self.helpView.userInteractionEnabled = NO;
     */
    [self performSegueWithIdentifier:@"imageSegue" sender:self];
    
}

- (IBAction)closeZoomImage:(id)sender
{
    self.hiddenViewButton.userInteractionEnabled = NO;
    
    [UIView animateWithDuration:1.0f animations:^{
        [self.hiddenView setAlpha:0.0f];
        self.hiddenViewButton.userInteractionEnabled = NO;
    }];
    self.helpView.userInteractionEnabled = YES;
    //UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
    //[self.hiddenView removeFromSuperview];
}

#pragma mark Segues
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"imageSegue"])
    {
        NCWordImageViewController *ic = segue.destinationViewController;
        ic.img = self.pictureView.image;
    }
}


@end
