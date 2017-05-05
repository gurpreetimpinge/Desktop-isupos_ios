//
//  getArticle.h
//  ISUPOS
//
//  Created by Mandeep Sharma on 01/07/15.
//  Copyright (c) 2015 Impinge Solutions. All rights reserved.
//

#import "SDZEntityObject.h"

@interface getUserDetails : SDZEntityObject
{
    
    NSMutableArray    *Articles;
//    NSMutableArray* Articles;
    
}

@property (retain, nonatomic) NSMutableArray *Articles;
//@property (retain, nonatomic) NSMutableArray* Articles;

+ (getUserDetails *) newWithNode: (CXMLNode*) node;
- (id) initWithNode: (CXMLNode*) node;
@end
