//
//  CommonMethods.m
//  ISUPOS
//
//  Created by Mac User on 23/01/17.
//  Copyright © 2017 Impinge Solutions. All rights reserved.
//

#import "CommonMethods.h"

@implementation CommonMethods

+ (BOOL)validateDictionaryValueForKey:(id)value{
    BOOL result = NO;
    NSString *str_value = [NSString stringWithFormat:@"%@",value];
    if (str_value.length >0 && value != [NSNull null] && value != nil) { // && ![str_value isEqualToString:@"nil"
        result = YES;
    }
    else {
        result = NO;
    }
    return result;
}

@end
