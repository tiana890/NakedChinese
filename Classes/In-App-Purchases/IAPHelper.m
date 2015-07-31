//
//  IAPHelper.m
//  NakedChinese
//
//  Created by IMAC  on 19.01.15.
//  Copyright (c) 2015 Dmitriy Karachentsov. All rights reserved.
//

// 1
#import "IAPHelper.h"
#import <StoreKit/StoreKit.h>
#import "NCProductDownloader.h"

NSString *const IAPHelperProductPurchasedNotification = @"IAPHelperProductPurchasedNotification";
NSString *const IAHelperProductNotPurchasedNotification = @"IAHelperProductNotPurchasedNotification";
NSString *const IAPHelperProductPurchasedFailedTransactionNotification = @"IAPHelperProductPurchasedFailedTransactionNotification";
NSString *const IAPHelperProductRestoreNotification = @"IAPHelperProductRestoreNotification";
NSString *const IAPHelperProductRestoreFailNotification = @"IAPHelperProductRestoreFailNotification";
// 2
@interface IAPHelper () <SKProductsRequestDelegate, SKPaymentTransactionObserver>

@property (nonatomic, readwrite, copy) RequestProductsCompletionHandler _completionHandler;
@end

@implementation IAPHelper {
    // 3
    SKProductsRequest * _productsRequest;
    // 4
    //RequestProductsCompletionHandler _completionHandler;
    NSSet * _productIdentifiers;
    NSMutableSet * _purchasedProductIdentifiers;
}

- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers {
    
    if ((self = [super init])) {
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        // Store product identifiers
        _productIdentifiers = productIdentifiers;
        
        // Check for previously purchased products
        _purchasedProductIdentifiers = [NSMutableSet set];
        for (NSString * productIdentifier in _productIdentifiers) {
            BOOL productPurchased = [[NSUserDefaults standardUserDefaults] boolForKey:productIdentifier];
            if (productPurchased) {
                [_purchasedProductIdentifiers addObject:productIdentifier];
                NSLog(@"Previously purchased: %@", productIdentifier);
            } else {
                [[NSNotificationCenter defaultCenter] postNotificationName:IAHelperProductNotPurchasedNotification object:productIdentifier userInfo:nil];
                NSLog(@"Not purchased: %@", productIdentifier);
            }
        }
        
    }
    return self;
}

- (void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler {
    
    // 1
    self._completionHandler = [completionHandler copy];
    
    // 2
    _productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:_productIdentifiers];
    _productsRequest.delegate = self;
    [_productsRequest start];
    
}

#pragma mark - SKProductsRequestDelegate

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    
    NSLog(@"Loaded list of products...");
    _productsRequest = nil;
    
    NSArray * skProducts = response.products;
    for (SKProduct * skProduct in skProducts) {
        NSLog(@"Found product: %@ %@ %0.2f",
              skProduct.productIdentifier,
              skProduct.localizedTitle,
              skProduct.price.floatValue);
    }
    
    if (self._completionHandler) {
        self._completionHandler(YES, skProducts);
        self._completionHandler = nil;
    }
    
}


- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    
    NSLog(@"Failed to load list of products.");
    _productsRequest = nil;

    if (self._completionHandler) {
        self._completionHandler(NO, nil);
        self._completionHandler = nil;
    }
}

- (BOOL)productPurchased:(NSString *)productIdentifier {
    return [_purchasedProductIdentifiers containsObject:productIdentifier];
}

- (void)buyProduct:(SKProduct *)product {
    
    NSLog(@"Buying %@...", product.productIdentifier);
    
    SKPayment * payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
    
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction * transaction in transactions) {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
            default:
                break;
        }
    };
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    NSLog(@"completeTransaction...");
    
    [self provideContentForProductIdentifier:transaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    NSLog(@"restoreTransaction...");
    
    [self provideContentForProductIdentifier:transaction.originalTransaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    
    
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    
    NSLog(@"failedTransaction...");

    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        NSLog(@"Transaction error: %@", transaction.error.localizedDescription);
    }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
   // [[NSNotificationCenter defaultCenter] postNotificationName:IAHelperProductNotPurchasedNotification object:transaction.error.localizedDescription userInfo:nil];
}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    NSLog(@"%@",queue );
    NSLog(@"Restored Transactions are once again in Queue for purchasing %@",[queue transactions]);
    [[NSNotificationCenter defaultCenter] postNotificationName:IAPHelperProductRestoreNotification object:nil userInfo:nil];
    NSMutableArray *purchasedItemIDs = [[NSMutableArray alloc] init];
    NSLog(@"received restored transactions: %i", queue.transactions.count);
    
    for (SKPaymentTransaction *transaction in queue.transactions) {
        NSString *productID = transaction.payment.productIdentifier;
        [purchasedItemIDs addObject:productID];
        NSLog (@"product id is %@" , productID);
        // here put an if/then statement to write files based on previously purchased items
        // example if ([productID isEqualToString: @"youruniqueproductidentifier]){write files} else { nslog sorry}
        /*dispatch_async(dispatch_queue_create("com.nakedchineseapp.nakedchinese.background_thread", NULL), ^{
            [[NCProductDownloader sharedInstance] loadBoughtProduct:productID];
        });
        */
        
        [[NCProductDownloader sharedInstance] setProductIsBought:productID];
    }
}



- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
    NSLog(@"Restore completed transaction failed with error: %@", error);
    [[NSNotificationCenter defaultCenter] postNotificationName:IAPHelperProductRestoreFailNotification object:nil userInfo:nil];
}

- (void)provideContentForProductIdentifier:(NSString *)productIdentifier {
    
    [_purchasedProductIdentifiers addObject:productIdentifier];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:productIdentifier];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:IAPHelperProductPurchasedNotification object:productIdentifier userInfo:nil];
    
}

- (void)restoreCompletedTransactions {
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}
@end