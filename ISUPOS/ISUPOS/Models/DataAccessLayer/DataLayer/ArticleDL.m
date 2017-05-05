//
//  ArticleDL.m
//  ISUPOS
//
//  Created by Mac User on 4/6/15.
//  Copyright (c) 2015 Impinge Solutions. All rights reserved.
//

#import "ArticleDL.h"

@implementation ArticleDL

+(void)addUpdateWithObject:(Article*)object
{
    NSError *error;
    if (![[AppDelegate delegate].managedObjectContext save:&error]) {
        UIMsg(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
}

+(NSMutableArray*)getDataWithPredicate:(NSPredicate*)predicate
{
    NSManagedObjectContext *context = [AppDelegate delegate].managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = kEntityForNameWithContext(@"Article", context);
    [fetchRequest setEntity:entity];
    
    if(predicate)
        [fetchRequest setPredicate:predicate];
    
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    return [NSMutableArray arrayWithArray:fetchedObjects];
}

+(void)deleteTheObject:(Article*)object
{
    [[AppDelegate delegate].managedObjectContext deleteObject:object];
}
@end
