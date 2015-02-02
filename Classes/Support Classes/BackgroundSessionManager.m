//
//  BackgroundSessionManager.m
//  NakedChinese
//
//  Created by IMAC  on 24.01.15.
//  Copyright (c) 2015 Dmitriy Karachentsov. All rights reserved.
//

#import "BackgroundSessionManager.h"

static NSString * const kBackgroundSessionIdentifier = @"com.nakedchineseapp.nakedchinese.backgroundDownloadSession";

@implementation BackgroundSessionManager

+ (instancetype)sharedManager
{
    static id sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
        
    });
    return sharedMyManager;
}

- (instancetype)init
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:kBackgroundSessionIdentifier];
    self = [super initWithSessionConfiguration:configuration];
    if (self) {
        //[self configureDownloadFinished];            // when download done, save file
        //[self configureBackgroundSessionFinished];   // when entire background session done, call completion handler
        //[self configureAuthentication];              // my server uses authentication, so let's handle that; if you don't use authentication challenges, you can remove this
    }
    return self;
}

- (void)configureDownloadFinished
{
    // just save the downloaded file to documents folder using filename from URL
    
    [self setDownloadTaskDidFinishDownloadingBlock:^NSURL *(NSURLSession *session, NSURLSessionDownloadTask *downloadTask, NSURL *location) {
        NSString *filename      = [downloadTask.originalRequest.URL lastPathComponent];
        NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        NSString *path          = [documentsPath stringByAppendingPathComponent:filename];
        return [NSURL fileURLWithPath:path];
    }];
    
}

- (void)configureBackgroundSessionFinished
{
    typeof(self) __weak weakSelf = self;
    
    [self setDidFinishEventsForBackgroundURLSessionBlock:^(NSURLSession *session) {
        if (weakSelf.savedCompletionHandler) {
            weakSelf.savedCompletionHandler();
            weakSelf.savedCompletionHandler = nil;
        }
    }];
}

- (void)configureAuthentication
{
    NSURLCredential *myCredential = [NSURLCredential credentialWithUser:@"userid" password:@"password" persistence:NSURLCredentialPersistenceForSession];
    
    [self setTaskDidReceiveAuthenticationChallengeBlock:^NSURLSessionAuthChallengeDisposition(NSURLSession *session, NSURLSessionTask *task, NSURLAuthenticationChallenge *challenge, NSURLCredential *__autoreleasing *credential) {
        if (challenge.previousFailureCount == 0) {
            *credential = myCredential;
            return NSURLSessionAuthChallengeUseCredential;
        } else {
            return NSURLSessionAuthChallengePerformDefaultHandling;
        }
    }];
}
@end
