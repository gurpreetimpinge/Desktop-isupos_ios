//
//  getArticleId.m
//  ISUPOS
//
//  Created by Mandeep Sharma on 01/07/15.
//  Copyright (c) 2015 Impinge Solutions. All rights reserved.
//

#import "getUser.h"
#import "getUserDetails.h"

@implementation getUser
+ (id) newWithNode: (CXMLNode*) node
{
    return [[[getUser alloc] initWithNode: node] autorelease];
}

- (id) initWithNode: (CXMLNode*) node
{
    if(self = [self init]) {
        for(CXMLElement* child in [node children])
        {
            getUserDetails* value = [[getUserDetails newWithNode: child] object];
            if(value != nil) {
                [self addObject: value];
            }
        }
    }
    return self;
}

@end
