//
//  Article.h
//  ISUPOS
//
//  Created by Mac User on 4/6/15.
//  Copyright (c) 2015 Impinge Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class QuickArticle, Variant;

@interface Article : NSManagedObject

@property (nonatomic, retain) NSString * article_description;
@property (nonatomic, retain) NSNumber * article_id;
@property (nonatomic, retain) NSString * article_img_url;
@property (nonatomic, retain) NSString * article_no;
@property (nonatomic, retain) NSString * barc_img_url;
@property (nonatomic, retain) NSString * created_by;
@property (nonatomic, retain) NSDate * created_date;
@property (nonatomic, retain) NSNumber * is_active;
@property (nonatomic, retain) NSNumber * is_deleted;
@property (nonatomic, retain) NSDate * modified_date;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSNumber * unit;
@property (nonatomic, retain) NSNumber * unit_type;
@property (nonatomic, retain) NSNumber * vat;
@property (nonatomic, retain) NSSet *variantDetails;
@property (nonatomic, retain) QuickArticle *quickArticleDetails;
@end

@interface Article (CoreDataGeneratedAccessors)

- (void)addVariantDetailsObject:(Variant *)value;
- (void)removeVariantDetailsObject:(Variant *)value;
- (void)addVariantDetails:(NSSet *)values;
- (void)removeVariantDetails:(NSSet *)values;

@end
