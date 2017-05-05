//
//  QuickArticleDL.h
//  ISUPOS
//
//  Created by Mac User on 4/6/15.
//  Copyright (c) 2015 Impinge Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuickArticle.h"

@interface QuickArticleDL : NSObject

+(void)addUpdateWithObject:(QuickArticle*)object;

+(NSMutableArray*)getDataWithPredicate:(NSPredicate*)predicate;

+(void)deleteTheObject:(QuickArticle*)object;
@end
