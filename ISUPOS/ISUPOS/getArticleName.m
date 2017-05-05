//
//  getArticleName.m
//  ISUPOS
//
//  Created by Mandeep Sharma on 01/07/15.
//  Copyright (c) 2015 Impinge Solutions. All rights reserved.
//

#import "getArticleName.h"

@implementation getArticleName

@synthesize Active;
@synthesize ArticleNumber;
@synthesize AttributeCombo;
@synthesize Barcode;
@synthesize Brand;
@synthesize CostPrice;
@synthesize Description;
@synthesize GroupName;
@synthesize LastModified;
@synthesize Location;
@synthesize Name;
@synthesize PriceIncVat;
@synthesize ProductModel;
@synthesize Quantity;
@synthesize SalesAccount;
@synthesize SerialNumber;
@synthesize SubGroupName;
@synthesize Supplier;
@synthesize Unit;
@synthesize Vat;
@synthesize VatRateDec;


+ (getArticleName *) newWithNode: (CXMLNode*) node
{
    if(node == nil) { return nil; }
    return (getArticleName*)[[[getArticleName alloc] initWithNode: node] autorelease];
}

- (id) initWithNode: (CXMLNode*) node {
    if(self = [super initWithNode: node])
    {
        
        self.Active = [Soap getNodeValue: node withName: @"Active"] ;
        self.ArticleNumber = [Soap getNodeValue: node withName: @"ArticleNumber"] ;
        self.AttributeCombo = [Soap getNodeValue: node withName: @"AttributeCombo"] ;
        self.Barcode = [Soap getNodeValue: node withName: @"Barcode"] ;
        self.Brand = [Soap getNodeValue: node withName: @"Brand"] ;
        self.CostPrice = [Soap getNodeValue: node withName: @"CostPrice"] ;
        self.Description = [Soap getNodeValue: node withName: @"Description"] ;
        self.GroupName = [Soap getNodeValue: node withName: @"GroupName"] ;
        self.LastModified = [Soap getNodeValue: node withName: @"LastModified"] ;
        self.Location = [Soap getNodeValue: node withName: @"Location"] ;
        self.Name = [Soap getNodeValue: node withName: @"Name"] ;
        self.PriceIncVat = [Soap getNodeValue: node withName: @"PriceIncVat"] ;
        self.ProductModel = [Soap getNodeValue: node withName: @"ProductModel"] ;
        self.Quantity = [Soap getNodeValue: node withName: @"Quantity"] ;
        self.SalesAccount = [Soap getNodeValue: node withName: @"SalesAccount"] ;
        self.SerialNumber = [Soap getNodeValue: node withName: @"SerialNumber"] ;
        self.SubGroupName = [Soap getNodeValue: node withName: @"SubGroupName"] ;
        self.Supplier = [Soap getNodeValue: node withName: @"Supplier"] ;
        self.Unit = [Soap getNodeValue: node withName: @"Unit"] ;
        self.Vat = [Soap getNodeValue: node withName: @"Vat"] ;
        self.VatRateDec = [Soap getNodeValue: node withName: @"VatRateDec"] ;
        
    }
    return self;
}
@end
