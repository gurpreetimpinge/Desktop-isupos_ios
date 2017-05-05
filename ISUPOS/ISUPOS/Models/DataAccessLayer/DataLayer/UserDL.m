//
//  UserDL.m
//  ISUPOS
//
//  Created by Mac User on 4/6/15.
//  Copyright (c) 2015 Impinge Solutions. All rights reserved.
//

#import "UserDL.h"

@implementation UserDL

+(void)addUpdateWithObject:(User*)object
{
    [self toIfObjectIsEmptyFillDefaultValues:object];
    NSError *error;
    if (![[AppDelegate delegate].managedObjectContext save:&error]) {
        UIMsg(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
}

+(NSMutableArray*)getDataWithPredicate:(NSPredicate*)predicate
{
    if(!predicate)
        predicate = [NSPredicate predicateWithFormat:@"is_deleted == 0"];
    
    NSManagedObjectContext *context = [AppDelegate delegate].managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = kEntityForNameWithContext(@"User", context);
    [fetchRequest setEntity:entity];
    
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    return [NSMutableArray arrayWithArray:fetchedObjects];
}

+(void)deleteTheObject:(User*)object
{
    [[AppDelegate delegate].managedObjectContext deleteObject:object];
}

+(void)toIfObjectIsEmptyFillDefaultValues:(User*)object
{
    
    kFillStringIfEmpty(object.email)
    kFillStringIfEmpty(object.first_name)
    kFillStringIfEmpty(object.last_name)
    kFillStringIfEmpty(object.password)
    kFillStringIfEmpty(object.username)
    
    kFillDateIfEmpty(object.created_date)
    kFillDateIfEmpty(object.modified_date)
    
    kFillNumberIfEmpty(object.is_active)
    kFillNumberIfEmpty(object.is_deleted)
    kFillNumberIfEmpty(object.user_id)
    kFillNumberIfEmpty(object.user_type)

}

@end
