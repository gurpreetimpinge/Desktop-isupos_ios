//
//  VariantDL.h
//  ISUPOS
//
//  Created by Mac User on 4/6/15.
//  Copyright (c) 2015 Impinge Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Variant.h"

@interface VariantDL : NSObject

+(void)addUpdateWithObject:(Variant*)object;

+(NSMutableArray*)getDataWithPredicate:(NSPredicate*)predicate;

+(void)deleteTheObject:(Variant*)object;
@end
