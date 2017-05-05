//
//  UserDL.h
//  ISUPOS
//
//  Created by Mac User on 4/6/15.
//  Copyright (c) 2015 Impinge Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface UserDL : NSObject

+(void)addUpdateWithObject:(User*)object;

+(NSMutableArray*)getDataWithPredicate:(NSPredicate*)predicate;

+(void)deleteTheObject:(User*)object;

@end
