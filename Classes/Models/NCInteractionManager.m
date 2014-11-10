//
//  NCInteractionManager.m
//  NakedChinese
//
//  Created by Dmitriy Karachentsov on 21.08.14.
//  Copyright (c) 2014 Dmitriy Karachentsov. All rights reserved.
//

#import "NCInteractionManager.h"

@import AudioToolbox;
@import AVFoundation;

static NSString *const kEN_FemaleFolder = @"female_en";
static NSString *const kRU_FemaleFolder = @"female_ru";
static NSString *const kEN_MaleFolder   = @"male_en";
static NSString *const kRU_MaleFolder   = @"male_ru";

@interface NCInteractionManager () <AVAudioPlayerDelegate>
@property (strong, nonatomic) AVAudioPlayer *player;
@property (weak, nonatomic) AVAudioSession *session;
@property (nonatomic, strong) NSNumber *soundIndex;
@end

@implementation NCInteractionManager

#pragma mark - getters and setters
- (NSNumber *)soundIndex
{
    if(!_soundIndex) return @0;
    else
        return _soundIndex;
}

#pragma mark - Lifecycle

+ (instancetype)sharedInstance {
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _session = [AVAudioSession sharedInstance];
        
        [_session setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionDuckOthers error:nil];
        
        [_session setActive:NO error:nil];
    }
    return self;
}

#pragma mark - Private

- (NSArray *)en_femaleSounds {
    return [self soundsFromDirectory:kEN_FemaleFolder];
}

- (NSArray *)ru_femaleSounds {
    return [self soundsFromDirectory:kRU_FemaleFolder];
}

- (NSArray *)en_maleSounds {
    return [self soundsFromDirectory:kEN_MaleFolder];
}

- (NSArray *)ru_maleSounds {
    return [self soundsFromDirectory:kRU_MaleFolder];
}

- (NSArray *)soundsFromDirectory:(NSString *)directory {
    NSString *soundsPath = [NSString stringWithFormat:@"%@/sounds/%@/", [[NSBundle mainBundle] resourcePath], directory];
    NSFileManager *fileManager =[NSFileManager defaultManager];
    return [fileManager contentsOfDirectoryAtPath:soundsPath error:nil];
}

- (void)playSongAtURL:(NSURL *)url {
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    _player.delegate = self;
    _player.volume = 0.8f;
    [_player prepareToPlay];
    [_player play];
}

#pragma mark - Public

- (void)playRandomSoundAtInteractionHell:(NCHell)hell {
    NSArray *sounds = nil;
    NSString *directory = nil;
    if (self.soundLanguage == NCSoundLanguageEnglish) {
        if (hell == NCHellMan) {
            sounds = [self en_maleSounds];
            directory = kEN_MaleFolder;
        } else {
            sounds = [self en_femaleSounds];
            directory = kEN_FemaleFolder;
        }
    } else if (self.soundLanguage == NCSoundLanguageRussian) {
        if (hell == NCHellMan) {
            sounds = [self ru_maleSounds];
            directory = kRU_MaleFolder;
        } else {
            sounds = [self ru_femaleSounds];
            directory = kRU_FemaleFolder;
        }
    }
    
    if (!sounds) {
        NSAssert(NO, @"NCInteractionManager: System error!");
        return;
    }
    
    //NSUInteger soundIndex = arc4random()%[sounds count];
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/sounds/%@/%@", [[NSBundle mainBundle] resourcePath], directory, sounds[[self.soundIndex intValue]]]];
    if([self.soundIndex intValue] != sounds.count-1)
    {
        int value = [self.soundIndex intValue];
        value++;
        self.soundIndex = [NSNumber numberWithInt:value];
    }
    else
    {
        self.soundIndex = @0;
    }
    [self playSongAtURL:url];
}

#pragma mark - AVAudioPlayerDelegate

-(void)audioPlayerBeginInterruption:(AVAudioPlayer *)player {
    [_session setActive:YES error:nil];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    if (flag) {
        _player = nil;
        [_session setActive:NO error:nil];
    }
}

@end
