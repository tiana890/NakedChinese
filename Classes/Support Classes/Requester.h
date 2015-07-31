//
//  Requester.h
//  Sdaminfo
//
//  Created by IMAC  on 28.05.14.
//  Copyright (c) 2014 Bolyshev OOO. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RequesterProtocol <NSObject>
@optional
- (void) requesterProtocolRequestResponse:(NSDictionary*)dict;
- (void) requesterProtocolBackgroundRequestResponse:(NSDictionary *)dict;
- (void) requesterProtocolRequestFailure:(NSString*)failureDescription;
@end

@interface Requester : NSObject

@property (nonatomic, weak) id<RequesterProtocol> delegate;
- (void) requestPath:(NSString*)pathString withParameters:(NSDictionary*) params isPOST:(BOOL) isPost delegate:(SEL) method;
- (void) backgroundRequest:(NSString *)pathString withParameters:(NSDictionary *) params delegate:(SEL) method;
- (void) downloadTaskFromURL:(NSString *)url toFile:(NSString *)filePath progressBarDelegate:(SEL)method andWordID:(NSNumber *) wordID;

@end
