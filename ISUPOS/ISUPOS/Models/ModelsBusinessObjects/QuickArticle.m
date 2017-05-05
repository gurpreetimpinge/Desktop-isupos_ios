//
//  QuickArticle.m
//  ISUPOS
//
//  Created by Mac User on 4/6/15.
//  Copyright (c) 2015 Impinge Solutions. All rights reserved.
//

#import "QuickArticle.h"
#import "Article.h"
#import "QuickItem.h"


@implementation QuickArticle

@dynamic article_id;
@dynamic created_date;
@dynamic modified_date;
@dynamic quick_article_id;
@dynamic quick_item_id;
@dynamic articleDetails;
@dynamic quickItemDetails;


+(QuickArticle*)getInstanceForInsert
{
    NSManagedObjectContext *context = [AppDelegate delegate].managedObjectContext;
    return  kInsertWithNameAndWithContext(@"QuickArticle",context);
}


@end
