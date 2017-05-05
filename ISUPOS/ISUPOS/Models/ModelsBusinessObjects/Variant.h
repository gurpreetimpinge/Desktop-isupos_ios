//
//  Variant.h
//  ISUPOS
//
//  Created by Mac User on 4/6/15.
//  Copyright (c) 2015 Impinge Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Article;

@interface Variant : NSManagedObject

@property (nonatomic, retain) NSNumber * article_id;
@property (nonatomic, retain) NSDate * created_date;
@property (nonatomic, retain) NSDate * modified_date;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSNumber * variant_id;
@property (nonatomic, retain) Article *articleDetails;

@end
