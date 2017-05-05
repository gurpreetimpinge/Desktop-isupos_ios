//
//  QuickItemDL.h
//  ISUPOS
//
//  Created by Mac User on 4/6/15.
//  Copyright (c) 2015 Impinge Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuickItem.h"

@interface QuickItemDL : NSObject

+(void)addUpdateWithObject:(QuickItem*)object;

+(NSMutableArray*)getDataWithPredicate:(NSPredicate*)predicate;

+(void)deleteTheObject:(QuickItem*)object;
@end
