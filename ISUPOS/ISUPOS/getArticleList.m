//
//  getArticleList.m
//  ISUPOS
//
//  Created by Mandeep Sharma on 01/07/15.
//  Copyright (c) 2015 Impinge Solutions. All rights reserved.
//

#import "getArticleList.h"
#import "getArticleName.h"

@implementation getArticleList
+ (id) newWithNode: (CXMLNode*) node
{
    return [[[getArticleList alloc] initWithNode: node] autorelease];
}

- (id) initWithNode: (CXMLNode*) node
{
    if(self = [self init]) {
        for(CXMLElement* child in [node children])
        {
            getArticleName* value = [[getArticleName newWithNode: child] object];
            if(value != nil) {
                [self addObject: value];
            }
        }
    }
    return self;
}

@end
