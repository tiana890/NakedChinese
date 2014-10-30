//
//  DBHelper.m
//  NakedChinese
//
//  Created by IMAC  on 30.10.14.
//  Copyright (c) 2014 Dmitriy Karachentsov. All rights reserved.
//

#import "DBHelper.h"
#import "NCAppDelegate.h"
#import "NCWord.h"

@implementation DBHelper

- (NSArray *)getWordsFromDBWithPackID:(int)packID
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    NCAppDelegate *appDelegate = (NCAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Word"];
    /*NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"count"
                                                                   ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    [fetchRequest setSortDescriptors:sortDescriptors];
     */
    NSString *formatPredicate = [NSString stringWithFormat:@"pack_id == %i", packID];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:formatPredicate];
    [fetchRequest setPredicate:predicate];
    NSError *error = nil;
    NSArray *wordArray = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    for(NSManagedObject *obj in wordArray)
    {
        NCWord *word = [NCWord getNCWordFromNSManagedObject:obj];
        [array addObject:word];
    }
    return array;
}

- (void)setWordsToDB:(NSArray *)wordsArray
{
    NCAppDelegate *appDelegate = (NCAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    NSManagedObject *words = [NSEntityDescription insertNewObjectForEntityForName:@"Words"
                                                          inManagedObjectContext:appDelegate.managedObjectContext];
    
    NSMutableSet *containWords = [words mutableSetValueForKey:@"containWords"];
    
    for(NCWord *word in wordsArray)
    {
        //проверяем есть ли такой элемент в базе
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Word"];
        NSString *formatPredicate = [NSString stringWithFormat:@"id == %i", [word.ID intValue]];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:formatPredicate];
        [fetchRequest setPredicate:predicate];
        NSError *error = nil;
        NSArray *wordArray = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
        
        if(wordArray.count > 0)
        {
            
            [appDelegate.managedObjectContext deleteObject:wordArray[0]];
        }
        
        NSManagedObject *newWord = [NSEntityDescription insertNewObjectForEntityForName:@"Word"
                                                              inManagedObjectContext:appDelegate.managedObjectContext];
        [newWord setValue:word.ID forKey:@"id"];
        [newWord setValue:word.image forKey:@"image"];
        [newWord setValue:word.packID forKey:@"pack_id"];
        
        [containWords addObject:newWord];
        
        
    }
    
    //    сохраняем данные в хранилище
    [appDelegate saveContext];

}
@end
