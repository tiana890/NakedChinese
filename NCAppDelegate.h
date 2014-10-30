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

@interface NCAppDelegate : UIResponder <UIApplicationDelegate, NCDataManagerProtocol>

@property (strong, nonatomic) UIWindow *window;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
@end
