//
//  getArticleName.h
//  ISUPOS
//
//  Created by Mandeep Sharma on 01/07/15.
//  Copyright (c) 2015 Impinge Solutions. All rights reserved.
//

#import "SDZEntityObject.h"

@interface getArticleName : SDZEntityObject
{
    NSString    *Active;
    NSString    *ArticleNumber;
    NSString    *AttributeCombo;
    NSString    *Barcode;
    NSString    *Brand;
    NSString    *CostPrice;
    NSString    *Description;
    NSString    *GroupName;
    NSString    *LastModified;
    NSString     *Location;
    NSString    *Name;
    NSString    *PriceIncVat;
    NSString    *ProductModel;
    NSString    *Quantity;
    NSString    *SalesAccount;
    NSString    *SerialNumber;
    NSString    *SubGroupName;
    NSString    *Supplier ;
    NSString    *Unit;
    NSString    *Vat;
    NSString    *VatRateDec;
    
}

@property (retain, nonatomic) NSString *Active;
@property (retain, nonatomic) NSString *ArticleNumber;
@property (retain, nonatomic) NSString *AttributeCombo;
@property (retain, nonatomic) NSString *Barcode;
@property (retain, nonatomic) NSString *Brand;
@property (retain, nonatomic) NSString *CostPrice;
@property (retain, nonatomic) NSString *Description;
@property (retain, nonatomic) NSString *GroupName;
@property (retain, nonatomic) NSString *LastModified;
@property (retain, nonatomic) NSString *Location;
@property (retain, nonatomic) NSString *Name;
@property (retain, nonatomic) NSString *PriceIncVat;
@property (retain, nonatomic) NSString *ProductModel;
@property (retain, nonatomic) NSString *Quantity;
@property (retain, nonatomic) NSString *Supplier ;
@property (retain, nonatomic) NSString *Unit;
@property (retain, nonatomic) NSString *Vat;
@property (retain, nonatomic) NSString *VatRateDec;
@property (retain, nonatomic) NSString *SalesAccount;
@property (retain, nonatomic) NSString *SerialNumber;
@property (retain, nonatomic) NSString *SubGroupName;


+ (getArticleName *) newWithNode: (CXMLNode*) node;
- (id) initWithNode: (CXMLNode*) node;
@end
