//
//  Requester.m
//  Sdaminfo
//
//  Created by IMAC  on 28.05.14.
//  Copyright (c) 2014 Bolyshev OOO. All rights reserved.
//

#import "Requester.h"
#import "AFNetworking.h"
#import "BackgroundSessionManager.h"

//#define SERVER_ADDRESS @"http://nakedchinese.bb777.ru/api/get/"
//#define SERVER_ADDRESS @"http://china:8901/api/get/"
#define SERVER_ADDRESS @"http://www.nakedchineseapp.com/api/get/"

@interface Requester()<NSURLSessionDelegate, NSURLSessionDownloadDelegate>

@end

@implementation Requester

- (void) requestPath:(NSString*)pathString withParameters:(NSDictionary*) params isPOST:(BOOL) isPost delegate:(SEL) method
{
    
    NSURL *baseURL = [NSURL URLWithString:SERVER_ADDRESS];
    NSURL *url = [NSURL URLWithString:pathString relativeToURL:baseURL];
    
    if(isPost == YES)
    {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
        
        [manager POST:pathString parameters:params success:^(NSURLSessionDataTask *task , id responseObject)
         {
             NSLog(@"%@", responseObject);
         }failure:^(NSURLSessionDataTask *task , NSError *error )
         {
             if([_delegate respondsToSelector:@selector(requesterProtocolRequestFailure:)])
             {
                 [_delegate performSelector:@selector(requesterProtocolRequestFailure:) withObject:[self errorMessage:error]];
             }
         }];
        
    }
    else
    {
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        // manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
        //NSLog(@"%@", url.absoluteString);
    
        [manager GET:url.absoluteString parameters:params success:^(NSURLSessionDataTask *task , id responseObject)
         {
             if([_delegate respondsToSelector:method])
             {
                 NSDictionary *d = responseObject;
                 [_delegate performSelector:method withObject:d];
             }

         }failure:^(NSURLSessionDataTask *task , NSError *error )
         {
              NSLog(@"Error %@", error.description);
             if([_delegate respondsToSelector:@selector(requesterProtocolRequestFailure:)])
             {
                
                 [_delegate performSelector:@selector(requesterProtocolRequestFailure:) withObject:[self errorMessage:error]];
             }
         }];
        
    }
}

- (void)backgroundRequest:(NSString *)pathString withParameters:(NSDictionary *)params delegate:(SEL)method
{
    NSURL *baseURL = [NSURL URLWithString:SERVER_ADDRESS];
    NSURL *url = [NSURL URLWithString:pathString relativeToURL:baseURL];
       
    [[BackgroundSessionManager sharedManager] GET:url.absoluteString parameters:params success:^(NSURLSessionDataTask *task , id responseObject)
     {
         if([_delegate respondsToSelector:method])
         {
             NSDictionary *d = responseObject;
             //NSLog(@"%@", responseObject);
             [_delegate performSelector:method withObject:d];
         }
         
     }failure:^(NSURLSessionDataTask *task , NSError *error )
     {
         /*
         NSLog(@"Error %@", error.debugDescription);
         if(error)
         {
             if([_delegate respondsToSelector:@selector(requesterProtocolRequestFailure:)])
             {
                 
                 [_delegate performSelector:@selector(requesterProtocolRequestFailure:) withObject:[self errorMessage:error]];
             }
         }
          */
     }];
}

- (void) downloadTaskFromURL:(NSString *)url toFile:(NSString *)filePath progressBarDelegate:(SEL)method andWordID:(NSNumber *) wordID
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setValue:wordID.stringValue forHTTPHeaderField:@"wordID"];
    //[request setValue:NSStringFromSelector(method) forHTTPHeaderField:@"select"];
    //[request setValue:filePath forHTTPHeaderField:@"filePath"];
    
    NSURLSessionDownloadTask *downloadTask = [[BackgroundSessionManager sharedManager] downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        
        UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:targetPath]];
        NSData *data = [NSData dataWithData:UIImagePNGRepresentation(image)];
        NSError *error;
        [@"" writeToFile:filePath atomically:YES
                encoding:NSUTF8StringEncoding error:&error];
        NSLog(@"WRITE ERROR: %@", error.description);
        [data writeToURL:[self addSkipBackupAttributeToItemAtPath:filePath] atomically:YES];
        NSLog(@"FILE PATH %@\n\n", filePath);
        
        NSNumber *wID = [NSNumber numberWithInt:[request valueForHTTPHeaderField:@"wordID"].intValue];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:wID forKey:@"wordID"];
        [dict setObject:@1 forKey:@"percent"];
        if([_delegate respondsToSelector:method])
        {
            [_delegate performSelector:method withObject:dict];
        }
        
        return targetPath;
        
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        
        if(error)
        {
            if([_delegate respondsToSelector:@selector(requesterProtocolRequestFailure:)])
            {
                [_delegate performSelector:@selector(requesterProtocolRequestFailure:) withObject:[self errorMessage:error]];
            }

        }
            
    }];
    
    [[BackgroundSessionManager sharedManager] setDownloadTaskDidWriteDataBlock:^(NSURLSession *session, NSURLSessionDownloadTask *downloadTask, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
        if([_delegate respondsToSelector:method])
        {
            NSNumber *wID = [NSNumber numberWithInt:[downloadTask.currentRequest valueForHTTPHeaderField:@"wordID"].intValue];
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setObject:wID forKey:@"wordID"];
            NSNumber *bytesPercentage = [NSNumber numberWithFloat:(float)totalBytesWritten/(float)totalBytesExpectedToWrite];
            [dict setObject:bytesPercentage forKey:@"percent"];
            if(![bytesPercentage isEqualToNumber:@1])
                [_delegate performSelector:method withObject:dict];
        }
    }];
   // NSURLSessionDownloadTask *downLoadTask = [[BackgroundSessionManager sharedManager].session downloadTaskWithRequest:request];
    [downloadTask resume];
}

#pragma mark URLSession methods

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes
{
    NSLog(@"didResumeAtOffset %i", (int)fileOffset);
}


- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(NSError *)error
{
    NSLog(@"didBecomeInvalidWithError %@", error.description);
}

- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session
{
    NSLog(@"didFinishEventsForBackgroundURLSession");
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    NSLog(@"didCompleteWithError = %@", error.description);
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
   /* NSURLRequest *request =  [downloadTask currentRequest];
   // NSNumber *number = [NSNumber numberWithInt:[request valueForHTTPHeaderField:@"wordID"].intValue];
    SEL method = NSSelectorFromString([request valueForHTTPHeaderField:@"select"]);
    NSString *filePath = [request valueForHTTPHeaderField:@"filePath"];
    
    UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:location]];
    NSData *data = [NSData dataWithData:UIImagePNGRepresentation(image)];
    [data writeToFile:filePath atomically:YES];
    
    NSNumber *wID = [NSNumber numberWithInt:[request valueForHTTPHeaderField:@"wordID"].intValue];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:wID forKey:@"wordID"];
    [dict setObject:@1 forKey:@"percent"];
    if([_delegate respondsToSelector:method])
    {
        [_delegate performSelector:method withObject:dict];
    }
    */

}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{/*
    NSURLRequest *request =  [downloadTask currentRequest];
    // NSNumber *number = [NSNumber numberWithInt:[request valueForHTTPHeaderField:@"wordID"].intValue];
    SEL method = NSSelectorFromString([request valueForHTTPHeaderField:@"select"]);
    //NSString *filePath = [request valueForHTTPHeaderField:@"filePath"];

    if([_delegate respondsToSelector:method])
    {
        NSNumber *wID = [NSNumber numberWithInt:[downloadTask.currentRequest valueForHTTPHeaderField:@"wordID"].intValue];
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setObject:wID forKey:@"wordID"];
        NSNumber *bytesPercentage = [NSNumber numberWithFloat:(float)totalBytesWritten/(float)totalBytesExpectedToWrite];
        [dict setObject:bytesPercentage forKey:@"percent"];
        if(![bytesPercentage isEqualToNumber:@1])
            [_delegate performSelector:method withObject:dict];
    }*/
}
- (NSString*) errorMessage:(NSError*) error
{
    NSString *errorMessage = [[NSString alloc] init];
    NSLog(@"%@", [error localizedFailureReason]);
    errorMessage = @"Ошибка при загрузке данных!";
    return errorMessage;
}

- (NSURL *)addSkipBackupAttributeToItemAtPath:(NSString *) filePathString
{
    NSURL* URL= [NSURL fileURLWithPath: filePathString];
    //assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
    
    NSError *error = nil;
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                  forKey: NSURLIsExcludedFromBackupKey error: &error];
    if(!success){
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    return URL;
}
@end
