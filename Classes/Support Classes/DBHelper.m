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
#import "NCExplanation.h"

#define SERVER_ADDRESS @"http://nakedchineseapp.com/upload/picture/"

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

- (void)setWordsToDB:(NSArray *)wordsArray withImages:(BOOL)ifSaveImages
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
            for(int i = 0; i < wordArray.count; i++)
                [appDelegate.managedObjectContext deleteObject:wordArray[i]];
        }
        
        //Material
        NSArray *materialArray = [self fetchRequestWithEntityName:@"Material" andFormatPredicate:formatPredicate];
        if(materialArray.count > 0)
        {
            for(int i = 0; i < materialArray.count; i++)
            {
                [appDelegate.managedObjectContext deleteObject:materialArray[i]];
            }
        }
        
        //вставляем его в базу
        NSManagedObject *newWord = [NSEntityDescription insertNewObjectForEntityForName:@"Word"
                                                                 inManagedObjectContext:appDelegate.managedObjectContext];
        [newWord setValue:word.ID forKey:@"id"];
        
        if(ifSaveImages)
        {
            [newWord setValue:[self getImagePathAndSaveImageFromWord:word] forKey:@"imageBig"];
        }
        else
        {
            [newWord setValue:word.image forKey:@"image"];
            [newWord setValue:word.bigImage forKey:@"imageBig"];
        }
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

- (NSString *)getImagePathAndSaveImageFromWord:(NCWord *)word
{
    return word.image;
}

- (void)setWordsToDB:(NSArray *)wordsArray
{
    [self setWordsToDB:wordsArray withImages:NO];
}

- (void)setWordsAndImagesToDB:(NSArray *)wordsArray
{
    
}

- (void)setMaterialsToDB:(NSArray *)materialsArray andExplanations:(NSArray *)explanationsArray
{
    NCAppDelegate *appDelegate = (NCAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    NSManagedObject *materials = [NSEntityDescription insertNewObjectForEntityForName:@"Materials"
                                                               inManagedObjectContext:appDelegate.managedObjectContext];
    
    NSMutableSet *containMaterials = [materials mutableSetValueForKey:@"containMaterials"];
    
    for(NCMaterial *material in materialsArray)
    {
        //проверяем есть ли такой элемент в базе
        
        NSString *formatPredicate = [NSString stringWithFormat:@"id == %i", [material.materialID intValue]];
        
        NSArray *materialArray = [self fetchRequestWithEntityName:@"Material" andFormatPredicate:formatPredicate];
        if(materialArray.count > 0)
        {
            [appDelegate.managedObjectContext deleteObject:materialArray[0]];
        }
        
        //вставляем его в базу
        
        NSManagedObject *newMaterial = [NSEntityDescription insertNewObjectForEntityForName:@"Material" inManagedObjectContext:appDelegate.managedObjectContext];
        
        [newMaterial setValue:material.materialID forKey:@"id"];
        [newMaterial setValue:material.materialZH forKey:@"zh"];
        [newMaterial setValue:material.materialZH_TR forKey:@"zh_tr"];
        [newMaterial setValue:material.materialEN forKey:@"en"];
        [newMaterial setValue:material.materialRU forKey:@"ru"];
        [newMaterial setValue:material.materialSound forKey:@"sound"];
        
        [containMaterials addObject:newMaterial];
        
    }
    
    NSManagedObject *explanations = [NSEntityDescription insertNewObjectForEntityForName:@"Explanations"
                                                               inManagedObjectContext:appDelegate.managedObjectContext];
    
    NSMutableSet *containExplanations = [explanations mutableSetValueForKey:@"containExplanations"];
    
    
    for(NCExplanation *explanation in explanationsArray)
    {
        //проверяем есть ли такой элемент в базе
        
        NSString *formatPredicate = [NSString stringWithFormat:@"id == %i", [explanation.ID intValue]];
        
        NSArray *explanationArray = [self fetchRequestWithEntityName:@"Explanation" andFormatPredicate:formatPredicate];
        if(explanationArray.count > 0)
        {
            [appDelegate.managedObjectContext deleteObject:explanationArray[0]];
        }
        
        //вставляем его в базу
        
        NSManagedObject *newExplanation = [NSEntityDescription insertNewObjectForEntityForName:@"Explanation" inManagedObjectContext:appDelegate.managedObjectContext];
        
        [newExplanation setValue:explanation.ID forKey:@"id"];
        [newExplanation setValue:explanation.wordID forKey:@"word_id"];
        
        [containExplanations addObject:newExplanation];

    }
    
    //    сохраняем данные в хранилище
    [appDelegate saveContext];

}

- (NSArray *)getMaterialsWithWordID:(int)wordID
{
    NSString *formatPredicate = [NSString stringWithFormat:@"word_id == %i", wordID];
        
    NSArray *explanationArray = [self fetchRequestWithEntityName:@"Explanation" andFormatPredicate:formatPredicate];
    
    NSMutableArray *materialIDs = [[NSMutableArray alloc] init];
    for(NSManagedObject *obj in explanationArray)
    {
        NCExplanation *explanation = [NCExplanation getNCExplanationdFromNSManagedObject:obj];
        [materialIDs addObject:explanation.ID];
    }
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    for(int i = 0; i < materialIDs.count; i++)
    {
    
        NSString *formatPredicate = [NSString stringWithFormat:@"id == %i", [materialIDs[i] intValue]];
            
        NSArray *materialArray = [self fetchRequestWithEntityName:@"Material" andFormatPredicate:formatPredicate];
        
        if(materialArray.count > 0)
        {
            [result addObject:[NCMaterial getNCMaterialFromNSManagedObject:materialArray[0]]];
        }
    }

    return result;
    
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
    
    
    NSManagedObject *newPack = [NSEntityDescription insertNewObjectForEntityForName:@"Pack"
                                                             inManagedObjectContext:appDelegate.managedObjectContext];
    if(packArray.count > 0)
    {
        for(int i = 0; i < packArray.count; i++)
        {
            NCPack *oldPack = [NCPack getNCPackFromNSManagedObject:packArray[i]];
            NSNumber *oldPaidValue = oldPack.paid;
            NSNumber *oldDownloadedValue = oldPack.downloaded;
            [appDelegate.managedObjectContext deleteObject:packArray[i]];
            [newPack setValue:oldPaidValue forKey:@"paid"];
            [newPack setValue:oldDownloadedValue forKey:@"downloaded"];
            
        }
    }
    else
    {
        [newPack setValue:pack.paid forKey:@"paid"];
        [newPack setValue:pack.downloaded forKey:@"downloaded"];
    }
    
    [newPack setValue:pack.ID forKey:@"id"];
    [newPack setValue:pack.partition forKey:@"partition"];
    [containPacks addObject:newPack];
    
    [appDelegate saveContext];
    
}

- (void)setPackPaid:(NCPack *)pack
{
    NCAppDelegate *appDelegate = (NCAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    NSManagedObject *packs = [NSEntityDescription insertNewObjectForEntityForName:@"Packs"
                                                           inManagedObjectContext:appDelegate.managedObjectContext];
    
    NSMutableSet *containPacks = [packs mutableSetValueForKey:@"containPacks"];
    
    //проверяем есть ли такой элемент в БД
    NSString *formatPredicate = [NSString stringWithFormat:@"id == %i", [pack.ID intValue]];
    NSArray *packArray = [self fetchRequestWithEntityName:@"Pack" andFormatPredicate:formatPredicate];
    
    
    NSManagedObject *newPack = [NSEntityDescription insertNewObjectForEntityForName:@"Pack"
                                                             inManagedObjectContext:appDelegate.managedObjectContext];
    if(packArray.count > 0)
    {
        for(int i = 0; i < packArray.count; i++)
        {
            [appDelegate.managedObjectContext deleteObject:packArray[i]];
        }
    }
    [newPack setValue:pack.downloaded forKey:@"downloaded"];
    [newPack setValue:@1 forKey:@"paid"];
    [newPack setValue:pack.ID forKey:@"id"];
    [newPack setValue:pack.partition forKey:@"partition"];
    [containPacks addObject:newPack];
    //сохраняем данные в хранилище
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
            if(word.packID.intValue != 16)
                [array addObject:word];
        }
       
    }
    
    NSPredicate *predicateZH   = [NSPredicate predicateWithFormat:@"zh contains %@", string];
    
    materialArray = [self fetchRequestWithEntityName:@"Material" andPredicate:predicateZH];
    
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
            if(word.packID.intValue != 16)
                [array addObject:word];
        }
        
    }
    
    NSPredicate *predicateZH_TR   = [NSPredicate predicateWithFormat:@"zh_tr contains %@", string];
    
    materialArray = [self fetchRequestWithEntityName:@"Material" andPredicate:predicateZH_TR];
    
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
            if(word.packID.intValue != 16)
                [array addObject:word];
        }
        
    }
    
    
    return array;
}

- (BOOL) ifPaidPack:(NCPack *)pack
{
       //проверяем есть ли такой элемент в БД
    NSString *formatPredicate = [NSString stringWithFormat:@"id == %i", [pack.ID intValue]];
    NSArray *packArray = [self fetchRequestWithEntityName:@"Pack" andFormatPredicate:formatPredicate];
    
    if(packArray.count > 0)
    {
        NCPack *pack = [NCPack getNCPackFromNSManagedObject:packArray[0]];
        if([pack.paid isEqualToNumber:@1])
            return YES;
        else
            return NO;
    }
    else
        return NO;
    

}

- (void) setPackDownloaded:(NCPack *)pack
{
    NCAppDelegate *appDelegate = (NCAppDelegate *)[[UIApplication sharedApplication]delegate];
    
    NSManagedObject *packs = [NSEntityDescription insertNewObjectForEntityForName:@"Packs"
                                                           inManagedObjectContext:appDelegate.managedObjectContext];
    
    NSMutableSet *containPacks = [packs mutableSetValueForKey:@"containPacks"];
    
    //проверяем есть ли такой элемент в БД
    NSString *formatPredicate = [NSString stringWithFormat:@"id == %i", [pack.ID intValue]];
    NSArray *packArray = [self fetchRequestWithEntityName:@"Pack" andFormatPredicate:formatPredicate];
    
    
    NSManagedObject *newPack = [NSEntityDescription insertNewObjectForEntityForName:@"Pack"
                                                             inManagedObjectContext:appDelegate.managedObjectContext];
    if(packArray.count > 0)
    {
        for(int i = 0; i < packArray.count; i++)
        {
            [appDelegate.managedObjectContext deleteObject:packArray[i]];
        }
    }
    
    [newPack setValue:@1 forKey:@"downloaded"];
    [newPack setValue:pack.paid forKey:@"paid"];
    [newPack setValue:pack.ID forKey:@"id"];
    [newPack setValue:pack.partition forKey:@"partition"];
    [containPacks addObject:newPack];
    //    сохраняем данные в хранилище
    [appDelegate saveContext];
}

- (BOOL) ifPackDownloaded:(NCPack *)pack
{
    //проверяем есть ли такой элемент в БД
    NSString *formatPredicate = [NSString stringWithFormat:@"id == %i", [pack.ID intValue]];
    NSArray *packArray = [self fetchRequestWithEntityName:@"Pack" andFormatPredicate:formatPredicate];
    
    if(packArray.count > 0)
    {
        NCPack *pack = [NCPack getNCPackFromNSManagedObject:packArray[0]];
        if([pack.downloaded isEqualToNumber:@1])
            return YES;
        else
            return NO;
    }
    else
        return NO;
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
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                            initWithKey:@"id" ascending:YES];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    
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
