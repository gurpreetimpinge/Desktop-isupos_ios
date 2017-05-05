//
//  QuickItem.m
//  ISUPOS
//
//  Created by Mac User on 4/6/15.
//  Copyright (c) 2015 Impinge Solutions. All rights reserved.
//

#import "QuickItem.h"
#import "QuickArticle.h"


@implementation QuickItem

@dynamic created_date;
@dynamic is_active;
@dynamic is_deleted;
@dynamic modified_date;
@dynamic name;
@dynamic quick_item_id;
@dynamic type;
@dynamic quickArticleDetails;


+(QuickItem*)getInstanceForInsert
{
    NSManagedObjectContext *context = [AppDelegate delegate].managedObjectContext;
    return  kInsertWithNameAndWithContext(@"QuickItem",context);
}

@end
