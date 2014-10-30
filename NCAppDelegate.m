//
//  NCAppDelegate.m
//  NakedChinese
//
//  Created by Dmitriy Karachentsov on 18.06.14.
//  Copyright (c) 2014 Dmitriy Karachentsov. All rights reserved.
//

#import "NCAppDelegate.h"
#import "NCDataManager.h"

@interface NCAppDelegate()



@end
@implementation NCAppDelegate

@synthesize managedObjectModel = _managedObjectModel;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self setupAnalitycs];
    [self initDB];
    BOOL ifFirstLaunch = [[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"];
    
    if (ifFirstLaunch == NO)
    {
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
    }
       return YES;
}

- (void)initDB
{
    /*NSDictionary *dishNamesAndWeights = @{@"soup":@310, @"meat":@300, @"fruit":@500, @"fish":@270, @"bread":@100, @"salad":@220, @"pizza":@280, @"tea":@250, @"coffee":@210, @"juice":@200};
    
    
    NSManagedObject *menu = [NSEntityDescription insertNewObjectForEntityForName:@"Menu"
                                                          inManagedObjectContext:self.managedObjectContext];
    
    NSMutableSet *dishes = [menu mutableSetValueForKey:@"dishes"];
    
    int dishID = 0;
    for(NSString *key in [dishNamesAndWeights allKeys])
    {
        NSManagedObject *dish = [NSEntityDescription insertNewObjectForEntityForName:@"Dish"
                                                              inManagedObjectContext:self.managedObjectContext];
        [dish setValue:[NSNumber numberWithInt:dishID] forKey:@"id"];
        [dish setValue:@"dish name" forKey:@"name"];
        [dish setValue:[dishNamesAndWeights objectForKey:key] forKey:@"weight"];
        [dish setValue:@0 forKey:@"count"];
        
        [dishes addObject:dish];
        
        dishID++;
        
    }
    
    //    сохраняем данные в хранилище
    [self saveContext];*/
    
    NCDataManager *dataManager = [NCDataManager sharedInstance];
    [dataManager getWordsWithPackID:18 andMode:@"reachable"];
    
}

#pragma mark - Core Data Stack

- (NSManagedObjectModel *)managedObjectModel
{
    if(_managedObjectModel)
        return _managedObjectModel;
    
    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if(_persistentStoreCoordinator)
        return _persistentStoreCoordinator;
    
    NSURL *storeURL = [[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                               inDomains:NSUserDomainMask] lastObject] URLByAppendingPathComponent:@"nakedChienese.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    if(![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]){
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)managedObjectContext
{
    if(nil != _managedObjectContext)
        return _managedObjectContext;
    
    NSPersistentStoreCoordinator *store = self.persistentStoreCoordinator;
    if(nil != store){
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:store];
    }
    
    return _managedObjectContext;
}

- (void)saveContext {
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    
    if(managedObjectContext != nil) {
        if([managedObjectContext hasChanges] && ![managedObjectContext save:&error]){
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


- (void)setupAnalitycs {
}

/*
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
*/
@end
