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

- (NCWord *)getWordWithID:(int)wordID
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    NSString *formatPredicate = [NSString stringWithFormat:@"id == %i", wordID];
    
    NSArray *wordArray = [self fetchRequestWithEntityName:@"Word" andFormatPredicate:formatPredicate];
    
    NCWord *word = [[NCWord alloc] init];
    
    if(wordArray.count > 0)
    {
        NSManagedObject *obj = wordArray[0];
        word = [NCWord getNCWordFromNSManagedObject:obj];
        NSString *predicate = [NSString stringWithFormat:@"id == %i", [word.ID intValue]];
        NSArray *materialArray = [self fetchRequestWithEntityName:@"Material" andFormatPredicate:predicate];
        if(materialArray.count > 0)
        {
            word.material = [NCMaterial getNCMaterialFromNSManagedObject:materialArray[0]];
        }
        [array addObject:word];
    }

    return word;
}

- (NSArray *)getPacks
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    NSArray *packArray = [self fetchRequestWithEntityName:@"Pack" andFormatPredicate:@""];
    
    for(NSManagedObject *obj in packArray)
    {
        NCPack *pack = [NCPack getNCPackFromNSManagedObject:obj];
        [array addObject:pack];
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
        
        NSLog(@"material %@", word.material.materialZH);
        
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

- (NSArray *)getFavorites
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    NSArray *favArray = [self fetchRequestWithEntityName:@"Favorite" andFormatPredicate:@""];
    
    for(NSManagedObject *obj in favArray)
    {
        NSNumber *fav = [obj valueForKey:@"id"];
        [array addObject:fav];
    }
    return array;
}

- (void)setWordToFavorites:(NCWord *)word
{
    NCAppDelegate *appDelegate = (NCAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    NSManagedObject *words = [NSEntityDescription insertNewObjectForEntityForName:@"Favorites"
                                                           inManagedObjectContext:appDelegate.managedObjectContext];
    
    NSMutableSet *containFavorites = [words mutableSetValueForKey:@"containFavorites"];
    
    //проверяем есть ли такой элемент в БД
    NSString *formatPredicate = [NSString stringWithFormat:@"id == %i", [word.ID intValue]];
    NSArray *favoritesArray = [self fetchRequestWithEntityName:@"Favorite" andFormatPredicate:formatPredicate];
    if(favoritesArray.count == 0)
    {
        NSManagedObject *newPack = [NSEntityDescription insertNewObjectForEntityForName:@"Favorite"
                                                                 inManagedObjectContext:appDelegate.managedObjectContext];
        [newPack setValue:word.ID forKey:@"id"];
        [containFavorites addObject:newPack];
        
        //    сохраняем данные в хранилище
        [appDelegate saveContext];

    }
    
}

- (void) deleteWordFromFavorites:(NCWord *)word
{
    NCAppDelegate *appDelegate = (NCAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    //проверяем есть ли такой элемент в БД
    NSString *formatPredicate = [NSString stringWithFormat:@"id == %i", [word.ID intValue]];
    NSArray *favoritesArray = [self fetchRequestWithEntityName:@"Favorite" andFormatPredicate:formatPredicate];
    if(favoritesArray.count > 0)
    {
        for(int i = 0; i < favoritesArray.count; i++)
            [appDelegate.managedObjectContext deleteObject:favoritesArray[i]];
    }
    [appDelegate saveContext];
}

- (BOOL)ifExistsInFavorites:(NCWord *)word
{
    //проверяем есть ли такой элемент в БД
    NSString *formatPredicate = [NSString stringWithFormat:@"id == %i", [word.ID intValue]];
    NSArray *favoritesArray = [self fetchRequestWithEntityName:@"Favorite" andFormatPredicate:formatPredicate];
    if(favoritesArray.count > 0)
        return YES;
    else
        return NO;

}

- (void)setPackToDB:(NCPack *)pack
{
    NCAppDelegate *appDelegate = (NCAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    NSManagedObject *packs = [NSEntityDescription insertNewObjectForEntityForName:@"Packs"
                                                           inManagedObjectContext:appDelegate.managedObjectContext];
    
    NSMutableSet *containPacks = [packs mutableSetValueForKey:@"containPacks"];
    
    //проверяем есть ли такой элемент в БД
    NSString *formatPredicate = [NSString stringWithFormat:@"id == %i", [pack.ID intValue]];
    NSArray *packArray = [self fetchRequestWithEntityName:@"Pack" andFormatPredicate:formatPredicate];
    if(packArray.count > 0)
    {
        for(int i = 0; i < packArray.count; i++)
            [appDelegate.managedObjectContext deleteObject:packArray[i]];
    }
   
    NSManagedObject *newPack = [NSEntityDescription insertNewObjectForEntityForName:@"Pack"
                                                                 inManagedObjectContext:appDelegate.managedObjectContext];
    [newPack setValue:pack.ID forKey:@"id"];
    [newPack setValue:pack.partition forKey:@"partition"];
    
    [containPacks addObject:newPack];
        
    //    сохраняем данные в хранилище
    [appDelegate saveContext];

}

- (NSArray *)searchWordContainsString:(NSString *)string
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    NSString *lang = NSLocalizedString(@"lang", nil);
    
    NSPredicate *predicate   = [NSPredicate predicateWithFormat:@"%K contains %@", lang, string];
    
    NSArray *materialArray = [self fetchRequestWithEntityName:@"Material" andPredicate:predicate];
    
    for (int i = 0; i < materialArray.count; i++)
    {
        NCMaterial *material = [[NCMaterial alloc] init];
        NSManagedObject *obj = materialArray[i];
        material = [NCMaterial getNCMaterialFromNSManagedObject:obj];
        NSString *predicate = [NSString stringWithFormat:@"id == %i", [material.materialID intValue]];
        NSArray *wordArray = [self fetchRequestWithEntityName:@"Word" andFormatPredicate:predicate];
        if(wordArray.count > 0)
        {
            NCWord *word = [[NCWord alloc] init];
            word = [NCWord getNCWordFromNSManagedObject:wordArray[0]];
            word.material = material;
            [array addObject:word];
        }
       
    }
    
    return array;
}

- (NSArray *) fetchRequestWithEntityName:(NSString *) entityName andFormatPredicate:(NSString *)formatPredicate
{
    NCAppDelegate *appDelegate = (NCAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:entityName];
    if(![formatPredicate isEqualToString:@""])
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:formatPredicate];
        [fetchRequest setPredicate:predicate];
    }
    NSError *error = nil;
    NSArray *array = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    return array;
}

- (NSArray *) fetchRequestWithEntityName:(NSString *) entityName andPredicate:(NSPredicate *)predicate
{
    NCAppDelegate *appDelegate = (NCAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:entityName];
    [fetchRequest setPredicate:predicate];
    NSError *error = nil;
    NSArray *array = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    return array;
}


@end
