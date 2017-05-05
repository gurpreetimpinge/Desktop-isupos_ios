//
//  Language.m
//  TownCenterProject
//
//  Created by ASAL on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Language.h"

@implementation Language

static NSBundle *bundle = nil;

+(void)initialize
{
    NSArray* languages = [NSLocale preferredLanguages];
    NSString *current = [languages objectAtIndex:0];
    [self setLanguage:current];
}


+(void)setLanguage:(NSString *)language {
    
    NSString *path = [[ NSBundle mainBundle ] pathForResource:language ofType:@"lproj"];
    bundle = [NSBundle bundleWithPath:path];
}

+(NSString *)get:(NSString *)key alter:(NSString *)alternate
{
   
    return [bundle localizedStringForKey:key value:alternate table:nil];
}

@end
