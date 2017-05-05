//
//  QuickItem.h
//  ISUPOS
//
//  Created by Mac User on 4/6/15.
//  Copyright (c) 2015 Impinge Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class QuickArticle;

@interface QuickItem : NSManagedObject

@property (nonatomic, retain) NSDate * created_date;
@property (nonatomic, retain) NSNumber * is_active;
@property (nonatomic, retain) NSNumber * is_deleted;
@property (nonatomic, retain) NSDate * modified_date;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * quick_item_id;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) QuickArticle *quickArticleDetails;

@end
