//
//  ChildMutableDictionary.m
//  ISUPOS
//
//  Created by Mac User on 24/01/17.
//  Copyright © 2017 Impinge Solutions. All rights reserved.
//

#import "ChildMutableDictionary.h"

@implementation ChildMutableDictionary

- (void)setObject:(id)anObject forKey:(id<NSCopying>)aKey {
    if ([CommonMethods validateDictionaryValueForKey:anObject] == NO) {
        anObject = @"";
        
    }
}




@end
