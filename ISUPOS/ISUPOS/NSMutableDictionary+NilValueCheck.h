//
//  NSMutableDictionary+NilValueCheck.h
//  ISUPOS
//
//  Created by Mac User on 24/01/17.
//  Copyright © 2017 Impinge Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (NilValueCheck)
- (void)setObjectWithNilKeyValidation:(id)anObject forKey:(id)aKey;
@end
