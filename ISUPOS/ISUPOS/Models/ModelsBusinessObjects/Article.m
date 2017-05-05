//
//  Article.m
//  ISUPOS
//
//  Created by Mac User on 4/6/15.
//  Copyright (c) 2015 Impinge Solutions. All rights reserved.
//

#import "Article.h"
#import "QuickArticle.h"
#import "Variant.h"


@implementation Article

@dynamic article_description;
@dynamic article_id;
@dynamic article_img_url;
@dynamic article_no;
@dynamic barc_img_url;
@dynamic created_by;
@dynamic created_date;
@dynamic is_active;
@dynamic is_deleted;
@dynamic modified_date;
@dynamic name;
@dynamic price;
@dynamic unit;
@dynamic unit_type;
@dynamic vat;
@dynamic variantDetails;
@dynamic quickArticleDetails;

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self asignProperties];
    }
    return self;
}

-(void)asignProperties
{
    
    self.article_description = @"";
    self.article_id = [NSNumber numberWithInt:0];
    self.article_img_url = @"";
    self.article_no = @"";
    self.barc_img_url = @"";
    self.created_by = @"";
    self.created_date = [NSDate date];
    self.is_active = [NSNumber numberWithInt:1];
    self.is_deleted = [NSNumber numberWithInt:0];
    self.modified_date = [NSDate date];
    self.name = @"";
    self.price = [NSNumber numberWithInt:0];
    self.unit = [NSNumber numberWithInt:0];
    self.unit_type = [NSNumber numberWithInt:0];
    self.vat = [NSNumber numberWithInt:0];

}

+(Article*)getInstanceForInsert
{
    NSManagedObjectContext *context = [AppDelegate delegate].managedObjectContext;
    return  kInsertWithNameAndWithContext(@"Article",context);
}


@end
