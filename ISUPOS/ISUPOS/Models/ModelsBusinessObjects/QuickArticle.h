//
//  QuickArticle.h
//  ISUPOS
//
//  Created by Mac User on 4/6/15.
//  Copyright (c) 2015 Impinge Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Article, QuickItem;

@interface QuickArticle : NSManagedObject

@property (nonatomic, retain) NSNumber * article_id;
@property (nonatomic, retain) NSDate * created_date;
@property (nonatomic, retain) NSDate * modified_date;
@property (nonatomic, retain) NSNumber * quick_article_id;
@property (nonatomic, retain) NSNumber * quick_item_id;
@property (nonatomic, retain) Article *articleDetails;
@property (nonatomic, retain) QuickItem *quickItemDetails;

+(QuickArticle*)getInstanceForInsert;

@end
