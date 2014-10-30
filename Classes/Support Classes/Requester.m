//
//  Requester.m
//  Sdaminfo
//
//  Created by IMAC  on 28.05.14.
//  Copyright (c) 2014 Bolyshev OOO. All rights reserved.
//

#import "Requester.h"
#import "AFNetworking.h"

//#define SERVER_ADDRESS @"http://nakedchinese.bb777.ru/api/get/"
#define SERVER_ADDRESS @"http://china:8901/api/get/"

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
         //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        NSLog(@"%@", url.absoluteString);
        [manager GET:url.absoluteString parameters:params success:^(NSURLSessionDataTask *task , id responseObject)
         {
             if([_delegate respondsToSelector:method])
             {
                 NSDictionary *d = responseObject;
                 NSLog(@"%@", responseObject);
                 [_delegate performSelector:method withObject:d];
             }

         }failure:^(NSURLSessionDataTask *task , NSError *error )
         {
             if([_delegate respondsToSelector:@selector(requesterProtocolRequestFailure:)])
             {
                 [_delegate performSelector:@selector(requesterProtocolRequestFailure:) withObject:[self errorMessage:error]];
             }
         }];
        
    }
}

/*- (void) requestAuthorizedPath:(NSString*)pathString withParameters:(NSDictionary*) params isPOST:(BOOL) isPost delegate:(SEL) method
{
    NSURL *baseURL = [NSURL URLWithString:SERVER_ADDRESS];
    NSURL *url = [NSURL URLWithString:pathString relativeToURL:baseURL];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFJSONResponseSerializer *responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [manager setResponseSerializer:responseSerializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [manager.requestSerializer setHTTPShouldHandleCookies:YES];
    
    
    if(![pathString isEqualToString:@"login"])
    {
        [self loadCookies];
        if([[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies].count >0)
        {
            NSHTTPCookie *cookie = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies][0];
            [manager.requestSerializer setValue:[NSString stringWithFormat:@"PHPSESSID=%@", cookie.value] forHTTPHeaderField:@"Cookie"];
            [manager.requestSerializer setValue:@"text/html" forHTTPHeaderField:@"Content-type"];
            [manager.requestSerializer setValue:@"text/html" forHTTPHeaderField:@"Accept"];
        }
    }
    
   if(!isPost)
    {
        [manager GET:url.absoluteString parameters:params success:^(NSURLSessionDataTask *task , id responseObject)
         {
             if([_delegate respondsToSelector:method])
             {
                 if([pathString isEqualToString:@"login"])
                 {
                     [self saveCookies];
                     
                 }
                 NSLog(@"%@", task.response.description);
                 
                 NSDictionary *d = responseObject;
            
                 [_delegate performSelector:method withObject:d];
             }
             
         }failure:^(NSURLSessionDataTask *task , NSError *error)
         {
              NSLog(@"%@", task.response.description);
             if([_delegate respondsToSelector:@selector(requesterProtocolRequestFailure:)])
             {
                 [_delegate performSelector:@selector(requesterProtocolRequestFailure:) withObject:[self errorMessage:error]];
             }
         }];
    }
    else
    {
        [manager POST:pathString parameters:params success:^(NSURLSessionDataTask *task, id responseObject)
        {
            if([_delegate respondsToSelector:method])
            {
                NSDictionary *d = responseObject;
                
                [_delegate performSelector:method withObject:d];
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error)
        {
            if([_delegate respondsToSelector:@selector(requesterProtocolRequestFailure:)])
            {
                [_delegate performSelector:@selector(requesterProtocolRequestFailure:) withObject:[self errorMessage:error]];
            }
            
        }];
    }
   

}
*/

- (NSString*) errorMessage:(NSError*) error
{
    NSString *errorMessage = [[NSString alloc] init];
    NSLog(@"%@", [error localizedFailureReason]);
    errorMessage = @"Ошибка при загрузке данных!";
    return errorMessage;
}
@end
