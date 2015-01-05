//
//  NCAppDelegate.h
//  NakedChinese
//
//  Created by Dmitriy Karachentsov on 18.06.14.
//  Copyright (c) 2014 Dmitriy Karachentsov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "NCDataManager.h"
#import "NCStartViewController.h"

@protocol AppDelegateHandleURLProtocol <NSObject>

- (void) appDelegateHandleURLProtocolOpenJokeItemWithNumber:(int) number;

@end
@interface NCAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic) BOOL ifFirstLaunch;

@property (nonatomic, strong) NCStartViewController *startViewController;

@property (nonatomic, weak) id<AppDelegateHandleURLProtocol> delegate;
- (void)saveContext;
@end
