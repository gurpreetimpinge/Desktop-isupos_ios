//
//  Variant.m
//  ISUPOS
//
//  Created by Mac User on 4/6/15.
//  Copyright (c) 2015 Impinge Solutions. All rights reserved.
//

#import "Variant.h"
#import "Article.h"


@implementation Variant

@dynamic article_id;
@dynamic created_date;
@dynamic modified_date;
@dynamic name;
@dynamic price;
@dynamic variant_id;
@dynamic articleDetails;


+(Variant*)getInstanceForInsert
{
    NSManagedObjectContext *context = [AppDelegate delegate].managedObjectContext;
    return  kInsertWithNameAndWithContext(@"Variant",context);
}

@end
