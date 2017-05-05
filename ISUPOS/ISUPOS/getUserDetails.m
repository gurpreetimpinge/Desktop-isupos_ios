//
//  getArticle.m
//  ISUPOS
//
//  Created by Mandeep Sharma on 01/07/15.
//  Copyright (c) 2015 Impinge Solutions. All rights reserved.
//

#import "getUserDetails.h"

@implementation getUserDetails

@synthesize Articles;
//@synthesize EntityKeyValues;

+ (getUserDetails *) newWithNode: (CXMLNode*) node
{
    if(node == nil) { return nil; }
    return (getUserDetails*)[[[getUserDetails alloc] initWithNode: node] autorelease];
}

- (id) initWithNode: (CXMLNode*) node {
    if(self = [super initWithNode: node])
    {
        
//        self.Articles = [Soap getNodeValue: node withName: @"Articles"] ;
       
//        self.Articles=[Soap objectFromNode:node];
        
//        node=[Soap getNode:node withName:@"Articles"];
     
        CXMLNode *nodenew;
        
        nodenew = [Soap getNode:node withName:@"Articles"];

        NSMutableArray *array = [[NSMutableArray alloc] init];
        
        for(CXMLElement* child in [nodenew children])
        {

            [array addObject:[child stringValue]];
            
        }

        self.Articles = [NSMutableArray arrayWithArray:array];
        
        
        
    }
    return self;
}

@end
