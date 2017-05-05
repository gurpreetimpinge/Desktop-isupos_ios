//
//  NSMutableDictionary+NilValueCheck.m
//  ISUPOS
//
//  Created by Mac User on 24/01/17.
//  Copyright © 2017 Impinge Solutions. All rights reserved.
//

#import "NSMutableDictionary+NilValueCheck.h"
#import "CommonMethods.h"

@implementation NSMutableDictionary (NilValueCheck)


- (void)setObjectWithNilKeyValidation:(id)anObject forKey:(id)aKey {
    
    if ([CommonMethods validateDictionaryValueForKey:anObject] == NO) {
        anObject = @"";
        [self setObject:anObject forKey:aKey];
    }
}



@end
