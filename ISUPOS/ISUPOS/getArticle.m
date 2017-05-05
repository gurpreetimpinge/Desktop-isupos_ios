//
//  getArticle.m
//  ISUPOS
//
//  Created by Mandeep Sharma on 01/07/15.
//  Copyright (c) 2015 Impinge Solutions. All rights reserved.
//

#import "getArticle.h"

@implementation getArticle

@synthesize Articles;
//@synthesize EntityKeyValues;

+ (getArticle *) newWithNode: (CXMLNode*) node
{
    if(node == nil) { return nil; }
    return (getArticle*)[[[getArticle alloc] initWithNode: node] autorelease];
}

- (id) initWithNode: (CXMLNode*) node {
    if(self = [super initWithNode: node])
    {
        
//        self.Articles = [Soap getNodeValue: node withName: @"Articles"] ;
       
//        self.Articles=[Soap objectFromNode:node];
        
//        node=[Soap getNode:node withName:@"Articles"];
     
        NSString *str_Status = nil;
        
        CXMLNode *nodeStatus;
        
        nodeStatus = [Soap getNode:node withName:@"Status"];
        
 
        
        for(CXMLElement* child in [nodeStatus children])
        {
            str_Status=[child stringValue];
            
            
        }
        
        
        CXMLNode *nodeMsg;
        
        nodeMsg = [Soap getNode:node withName:@"Message"];
     
        
        for(CXMLElement* child in [nodeMsg children])
        {
         
            
            if (![str_Status isEqualToString:@"Ok"]) {
                
                [[[UIAlertView alloc] initWithTitle:@"ISUPOS" message:[child stringValue] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                
            }
            
            
        }
        
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
