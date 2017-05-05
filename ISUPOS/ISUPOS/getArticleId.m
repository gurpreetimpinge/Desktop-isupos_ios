//
//  getArticleId.m
//  ISUPOS
//
//  Created by Mandeep Sharma on 01/07/15.
//  Copyright (c) 2015 Impinge Solutions. All rights reserved.
//

#import "getArticleId.h"
#import "getArticle.h"

@implementation getArticleId
+ (id) newWithNode: (CXMLNode*) node
{
    return [[[getArticleId alloc] initWithNode: node] autorelease];
}

- (id) initWithNode: (CXMLNode*) node
{
    if(self = [self init]) {
        for(CXMLElement* child in [node children])
        {
            getArticle* value = [[getArticle newWithNode: child] object];
            if(value != nil) {
                [self addObject: value];
            }
        }
    }
    return self;
}

@end
