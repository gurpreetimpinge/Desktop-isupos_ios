//
//  ChildMutableDictionary.h
//  ISUPOS
//
//  Created by Mac User on 24/01/17.
//  Copyright © 2017 Impinge Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonMethods.h"

@interface ChildMutableDictionary : NSMutableDictionary
- (void)setObject:(id)anObject forKey:(id<NSCopying>)aKey;
@end
