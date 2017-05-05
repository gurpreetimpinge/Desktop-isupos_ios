//
//  ISUPosSoapService.h
//  ISUPOS
//
//  Created by Rohit Mahajan on 6/8/15.
//  Copyright (c) 2015 Impinge Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Soap.h"

@interface ISUPosSoapService : SoapService
- (SoapRequest*) GetArticleName: (id) target action: (SEL) action UserId: (NSNumber *) UserId;
- (SoapRequest*) GetArticleList: (id) target action: (SEL) action UserId: (NSNumber *) UserId;
- (SoapRequest*) GetUser: (id) target action: (SEL) action;
- (SoapRequest*) PostRegisterSale: (id) target action: (SEL) action ary:(NSMutableArray *)selectedArray;
@end
