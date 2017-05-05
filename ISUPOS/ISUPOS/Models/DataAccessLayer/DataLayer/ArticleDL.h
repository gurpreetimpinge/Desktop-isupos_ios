//
//  ArticleDL.h
//  ISUPOS
//
//  Created by Mac User on 4/6/15.
//  Copyright (c) 2015 Impinge Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Article.h"

@interface ArticleDL : NSObject

+(void)addUpdateWithObject:(Article*)object;

+(NSMutableArray*)getDataWithPredicate:(NSPredicate*)predicate;

+(void)deleteTheObject:(Article*)object;
@end
