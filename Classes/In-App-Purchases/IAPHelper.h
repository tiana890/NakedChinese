//
//  IAPHelper.h
//  NakedChinese
//
//  Created by IMAC  on 19.01.15.
//  Copyright (c) 2015 Dmitriy Karachentsov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
UIKIT_EXTERN NSString *const IAPHelperProductPurchasedNotification;
UIKIT_EXTERN NSString *const IAHelperProductNotPurchasedNotification;
UIKIT_EXTERN NSString *const IAPHelperProductPurchasedFailedTransactionNotification;
UIKIT_EXTERN NSString *const IAPHelperProductRestoreNotification;
UIKIT_EXTERN NSString *const IAPHelperProductRestoreFailNotification;

typedef void (^RequestProductsCompletionHandler)(BOOL success, NSArray * products);

@interface IAPHelper : NSObject

- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers;
- (void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler;
- (void)buyProduct:(SKProduct *)product;
- (BOOL)productPurchased:(NSString *)productIdentifier;
- (void)restoreCompletedTransactions;
@end

