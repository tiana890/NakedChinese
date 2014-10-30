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
#import "NCMaterial.h"

@implementation DBHelper

- (NSArray *)getWordsFromDBWithPackID:(int)packID
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    NCAppDelegate *appDelegate = (NCAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    NSString *formatPredicate = [NSString stringWithFormat:@"pack_id == %i", packID];
    
    NSArray *wordArray = [self fetchRequestWithEntityName:@"Word" andFormatPredicate:formatPredicate];
    
    for(NSManagedObject *obj in wordArray)
    {
        NCWord *word = [NCWord getNCWordFromNSManagedObject:obj];
        
        NSString *predicate = [NSString stringWithFormat:@"id == %i", [word.ID intValue]];
        NSArray *materialArray = [self fetchRequestWithEntityName:@"Material" andFormatPredicate:predicate];
        if(materialArray.count > 0)
        {
            word.material = [NCMaterial getNCMaterialFromNSManagedObject:materialArray[0]];
        }
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
    
    NSManagedObject *materials = [NSEntityDescription insertNewObjectForEntityForName:@"Materials"
                                                           inManagedObjectContext:appDelegate.managedObjectContext];
    
    NSMutableSet *containMaterials = [materials mutableSetValueForKey:@"containMaterials"];
    
    for(NCWord *word in wordsArray)
    {
        //проверяем есть ли такой элемент в базе
        //Word
       
        NSString *formatPredicate = [NSString stringWithFormat:@"id == %i", [word.ID intValue]];
    
        NSArray *wordArray = [self fetchRequestWithEntityName:@"Word" andFormatPredicate:formatPredicate];
        if(wordArray.count > 0)
        {
            [appDelegate.managedObjectContext deleteObject:wordArray[0]];
        }
        
        //Material
        NSArray *materialArray = [self fetchRequestWithEntityName:@"Material" andFormatPredicate:formatPredicate];
        if(materialArray.count > 0)
        {
            [appDelegate.managedObjectContext deleteObject:materialArray[0]];
        }
        
        //вставляем его в базу
        NSManagedObject *newWord = [NSEntityDescription insertNewObjectForEntityForName:@"Word"
                                                              inManagedObjectContext:appDelegate.managedObjectContext];
        [newWord setValue:word.ID forKey:@"id"];
        [newWord setValue:word.image forKey:@"image"];
        [newWord setValue:word.packID forKey:@"pack_id"];
        [newWord setValue:word.paid forKey:@"paid"];
        [newWord setValue:word.show forKey:@"show"];
        
        [containWords addObject:newWord];
        
        NSManagedObject *newMaterial = [NSEntityDescription insertNewObjectForEntityForName:@"Material" inManagedObjectContext:appDelegate.managedObjectContext];
        
        [newMaterial setValue:word.material.materialID forKey:@"id"];
        [newMaterial setValue:word.material.materialZH forKey:@"zh"];
        [newMaterial setValue:word.material.materialZH_TR forKey:@"zh_tr"];
        [newMaterial setValue:word.material.materialEN forKey:@"en"];
        [newMaterial setValue:word.material.materialRU forKey:@"ru"];
        [newMaterial setValue:word.material.materialSound forKey:@"sound"];
        
        [containMaterials addObject:newMaterial];
        
    }
    //    сохраняем данные в хранилище
    [appDelegate saveContext];

}

- (NSArray *) fetchRequestWithEntityName:(NSString *) entityName andFormatPredicate:(NSString *)formatPredicate
{
    NCAppDelegate *appDelegate = (NCAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:entityName];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:formatPredicate];
    [fetchRequest setPredicate:predicate];
    NSError *error = nil;
    NSArray *array = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    return array;
}
@end
