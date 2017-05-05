//
//  ISUPosSoapService.m
//  ISUPOS
//
//  Created by Rohit Mahajan on 6/8/15.
//  Copyright (c) 2015 Impinge Solutions. All rights reserved.
//

#import "ISUPosSoapService.h"
#import "Soap.h"
#import "getArticleList.h"
#import "getArticleId.h"
#import "getUser.h"

@implementation ISUPosSoapService

- (id) init
{
    if(self = [super init])
    {
        
        NSString *finalBaseServiceUrl = @"https://central.isupos.se/integration/isupos3/Isupos3Integration.svc";
        self.serviceUrl = finalBaseServiceUrl;
        self.namespace = @"http://tempuri.org/";
        self.headers = [super headers];
        self.logging = YES;
    }
    return self;
}

- (SoapRequest*) GetArticleList: (id) target action: (SEL) action UserId: (NSNumber *) UserId
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.bool_RegisterSale = NO;
    
    NSMutableArray* _params = [NSMutableArray array];
    [_params addObject: [[SoapParameter alloc] initWithValue: [[NSUserDefaults standardUserDefaults] valueForKey:@"USERNAME"] forName: @"username"]];
    [_params addObject: [[SoapParameter alloc] initWithValue: [[NSUserDefaults standardUserDefaults] valueForKey:@"PASSWORD"] forName: @"password"]];
//    [_params addObject: [[SoapParameter alloc] initWithValue: @"1" forName: @"articleNumber"]];
    
    NSString* _envelope = [Soap createEnvelope: @"GetAllArticleList" forNamespace:self.namespace withParameters: _params withHeaders: self.headers];
    SoapRequest* _request = [SoapRequest create: target action: action service: self soapAction: @"http://tempuri.org/IIsupos3Service/GetAllArticleList" postData: _envelope deserializeTo:[[getArticleId alloc] init]];
    [_request send];
    return _request;
    
}

- (SoapRequest*) GetArticleName: (id) target action: (SEL) action UserId: (NSNumber *) UserId
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.bool_RegisterSale = NO;
    NSMutableArray* _params = [NSMutableArray array];
    [_params addObject: [[SoapParameter alloc] initWithValue: [[NSUserDefaults standardUserDefaults] valueForKey:@"USERNAME"] forName: @"username"]];
    [_params addObject: [[SoapParameter alloc] initWithValue: [[NSUserDefaults standardUserDefaults] valueForKey:@"PASSWORD"] forName: @"password"]];
    [_params addObject: [[SoapParameter alloc] initWithValue: UserId forName: @"articleNumber"]];
//    [_params addObject: [[SoapParameter alloc] initWithValue: @"178590" forName: @"articleNumber"]];

    NSString* _envelope = [Soap createEnvelope: @"GetArticle" forNamespace:self.namespace withParameters: _params withHeaders: self.headers];
    SoapRequest* _request = [SoapRequest create: target action: action service: self soapAction: @"http://tempuri.org/IIsupos3Service/GetArticle" postData: _envelope deserializeTo:[[getArticleList alloc] init]];
    [_request send];
    return _request;
    
}


- (SoapRequest*) GetUser: (id) target action: (SEL) action
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.bool_RegisterSale = NO;
    
    NSMutableArray* _params = [NSMutableArray array];
    [_params addObject: [[SoapParameter alloc] initWithValue: [[NSUserDefaults standardUserDefaults] valueForKey:@"USERNAME"] forName: @"username"]];
    [_params addObject: [[SoapParameter alloc] initWithValue: [[NSUserDefaults standardUserDefaults] valueForKey:@"PASSWORD"] forName: @"password"]];
    //    [_params addObject: [[SoapParameter alloc] initWithValue: @"1" forName: @"articleNumber"]];
    
    NSString* _envelope = [Soap createEnvelope: @"wsdl" forNamespace:self.namespace withParameters: _params withHeaders: self.headers];
    SoapRequest* _request = [SoapRequest create: target action: action service: self soapAction: @"http://central.isupos.se/integration/isupos3/Isupos3Integration.svc?wsdl" postData: _envelope deserializeTo:[[getUser alloc] init]];
    [_request send];
    return _request;
    
}

- (SoapRequest*) PostRegisterSale: (id) target action: (SEL) action ary:(NSMutableArray *)selectedArray
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.bool_RegisterSale = YES;
    
    
//    NSString *soapMessage = [NSString stringWithFormat:
//                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
//                             "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:tem=\"http://tempuri.org/\">\n"
//                             "<soapenv:Header/>\n"
//                             "<soapenv:Body>\n"
//                             "<tem:RegisterSale>\n"
//                             "<tem:username>rdev_rdev_appuser</tem:username>\n"
//                             "<tem:password>Wg!39kP+37</tem:password>\n"
//                             "<tem:receipt><tem:CashierName>%@</tem:CashierName>\n"
//                             "<tem:CustomerName>%@</tem:CustomerName>\n"
//                             "<tem:CustomerNumber>%@</tem:CustomerNumber>\n"
//                             "<tem:IsRepurchase>%@</tem:IsRepurchase>\n"
//                             "<tem:MemberCards>%@</tem:MemberCards>\n"
//                             "<tem:ReceiptNumber>%@</tem:ReceiptNumber>\n"
//                             "<tem:SalesTime>%@</tem:SalesTime>\n"
//                             "<tem:SalesType>%@</tem:SalesType>\n"
//                             "</tem:receipt>\n"
//                             "</tem:RegisterSale>\n"
//                             "</soapenv:Body>\n"
//                             "</soapenv:Envelope>\n",
//                             @"terye",
//                             @"ehrgferg",
//                             @"erhuvvd",
//                             [NSNumber numberWithBool:YES],
//                             @"1",
//                             [NSDate date],
//                             @"24",
//                             @"1"
//                             ];
//    
//    
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
//    
//    NSString *yourDateString = [formatter stringFromDate:[NSDate date]];
//    NSDate *date = [formatter dateFromString:yourDateString];
    
//    NSMutableDictionary *params1 = [NSMutableDictionary new];
//    [params1 setValue:[[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:0] valueForKey:@"article_id"] forKey:@"Articles"];
//    [params1 setValue:@"tty" forKey:@"CashierName"];
//    [params1 setValue:@"ewqf" forKey:@"CustomerName"];
//    [params1 setValue:@"eff" forKey:@"CustomerNumber"];
//    [params1 setValue:[NSNumber numberWithBool:YES] forKey:@"IsRepurchase"];
//    [params1 setValue:@"0" forKey:@"MemberCards"];
//    [params1 setValue:@"24" forKey: @"ReceiptNumber"];
//    [params1 setValue:date forKey: @"SalesTime"];
//    [params1 setValue:@"1" forKey: @"SalesType"];
//    [params1 setValue:[[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:0] valueForKey:@"id"] forKey: @"ReceiptNumber"];
//    [params1 setValue:[[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:0] valueForKey:@"time"] forKey: @"SalesTime"];
//    [params1 setValue:[[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:0] valueForKey:@"paymentMethod"] forKey: @"SalesType"];
    
    
    
    NSMutableArray *ary_ArticleDetail = [[NSMutableArray alloc]initWithArray:[[[[selectedArray objectAtIndex:0] valueForKey:@"main"] objectAtIndex:0] valueForKey:@"sub"]];
    
    NSMutableString* str_ArticleEntry = [[[NSMutableString alloc] initWithString: @""] autorelease];
    
    NSMutableArray* _params3 = [NSMutableArray array];
    
    for (int i=0; i<[ary_ArticleDetail count]; i++)
    {
        
        
        NSMutableString* str_Article = [[[NSMutableString alloc] initWithString: @""] autorelease];
        
        NSMutableArray* _params1 = [NSMutableArray array];
        [_params1 addObject: [[SoapParameter alloc] initWithValue: [[ary_ArticleDetail objectAtIndex:i] valueForKey:@"discription"] forName: @"ArticleDescription"]];
        [_params1 addObject: [[SoapParameter alloc] initWithValue: [[ary_ArticleDetail objectAtIndex:i] valueForKey:@"name"] forName: @"ArticleName"]];
        [_params1 addObject: [[SoapParameter alloc] initWithValue: [[ary_ArticleDetail objectAtIndex:i] valueForKey:@"article_id"] forName: @"ArticleNumber"]];
        
        if ([[ary_ArticleDetail objectAtIndex:i] valueForKey:@"discount"])
        {
            float discount = [[[ary_ArticleDetail objectAtIndex:i] valueForKey:@"discount"] intValue];
            [_params1 addObject:[[SoapParameter alloc] initWithValue: [NSNumber numberWithFloat:discount] forName: @"Discount"]];
        }
        else
        {
            [_params1 addObject:[[SoapParameter alloc] initWithValue: [NSNumber numberWithFloat:0] forName: @"Discount"]];
        }
        
        //  [_params1 addObject: [[SoapParameter alloc] initWithValue: [[ary_ArticleDetail objectAtIndex:i] valueForKey:@"Group"] forName: @"Group"]];
        
        
        float quantity = [[[ary_ArticleDetail objectAtIndex:i] valueForKey:@"count"] intValue];
        [_params1 addObject: [[SoapParameter alloc] initWithValue: [NSNumber numberWithFloat:quantity] forName: @"Quantity"]];
        
        [_params1 addObject: [[SoapParameter alloc] initWithValue: [NSString stringWithFormat:@"%d",i+1] forName: @"SerialNumber"]];
        
        float vatRateDec = [[[ary_ArticleDetail objectAtIndex:i] valueForKey:@"vat"] intValue];
        [_params1 addObject: [[SoapParameter alloc] initWithValue: [NSNumber numberWithFloat:vatRateDec] forName: @"VatRateDec"]];
        
        
        [_params1 addObject: [[SoapParameter alloc] initWithValue: [[selectedArray objectAtIndex:0] valueForKey:@"DiscountComment"] forName: @"DiscountComment"]];
        
        float priceIncVat = [[[[[selectedArray objectAtIndex:0] valueForKey:@"main"] objectAtIndex:0] valueForKey:@"tprice"] intValue];
        [_params1 addObject: [[SoapParameter alloc] initWithValue: [NSNumber numberWithFloat:priceIncVat] forName: @"PriceIncVat"]];
        
//        float refundableQuantity = [[[selectedArray objectAtIndex:0] valueForKey:@"RefundableQuantity"] intValue];
//        [_params1 addObject: [[SoapParameter alloc] initWithValue: [NSNumber numberWithFloat:refundableQuantity] forName: @"RefundableQuantity"]];
        
        
        if ([[[selectedArray objectAtIndex:0] valueForKey:@"IsRepurchase"] isEqualToString:@"YES"])
        {
            int salesId = [[[[[selectedArray objectAtIndex:0] valueForKey:@"main"] objectAtIndex:0] valueForKey:@"id"] intValue];
            [_params1 addObject: [[SoapParameter alloc] initWithValue: [NSNumber numberWithInt:salesId] forName: @"SalesId"]];
        }
        else
        {
            int salesId = [[[[[selectedArray objectAtIndex:0] valueForKey:@"main"] objectAtIndex:0] valueForKey:@"id"] intValue];
            [_params1 addObject: [[SoapParameter alloc] initWithValue: [NSNumber numberWithInt:0] forName: @"SalesId"]];
        }
        
        
        for(SoapParameter* p in _params1) {
            [str_Article appendString: p.xml];
        }
        
        [_params3 addObject: [[SoapParameter alloc] initWithValue: str_Article forName: @"ReceiptArticleEntry"]];
    }
    
    for(SoapParameter* p in _params3) {
        [str_ArticleEntry appendString: p.xml];
    }
    
    
    NSMutableArray* _params2 = [NSMutableArray array];
    
    [_params2 addObject: [[SoapParameter alloc] initWithValue: str_ArticleEntry forName: @"Articles"]];
    [_params2 addObject: [[SoapParameter alloc] initWithValue: [[NSUserDefaults standardUserDefaults] valueForKey:@"USERNAME"] forName: @"CashierName"]];
    
    if ([[[selectedArray objectAtIndex:0] valueForKey:@"IsRepurchase"] isEqualToString:@"YES"])
    {
        [_params2 addObject: [[SoapParameter alloc] initWithValue: [NSNumber numberWithBool:YES] forName: @"IsRepurchase"]];
    }
    else
    {
        [_params2 addObject: [[SoapParameter alloc] initWithValue: [NSNumber numberWithBool:NO] forName: @"IsRepurchase"]];
    }
    
    [_params2 addObject: [[SoapParameter alloc] initWithValue: [[[[selectedArray objectAtIndex:0] valueForKey:@"main"] objectAtIndex:0] valueForKey:@"id"] forName: @"ReceiptNumber"]];
    [_params2 addObject: [[SoapParameter alloc] initWithValue: [NSDate date] forName: @"SalesTime"]];
  //  [_params2 addObject: [[SoapParameter alloc] initWithValue: @"Cash" forName: @"SalesType"]];
    
    
    NSMutableString* str_Receipt = [[[NSMutableString alloc] initWithString: @""] autorelease];
    for(SoapParameter* p in _params2) {
        [str_Receipt appendString: p.xml];
    }
    
    NSMutableArray* _params = [NSMutableArray array];
    [_params addObject: [[SoapParameter alloc] initWithValue: [[NSUserDefaults standardUserDefaults] valueForKey:@"USERNAME"] forName: @"username"]];
    [_params addObject: [[SoapParameter alloc] initWithValue: [[NSUserDefaults standardUserDefaults] valueForKey:@"PASSWORD"] forName: @"password"]];
    [_params addObject: [[SoapParameter alloc] initWithValue:str_Receipt  forName: @"receipt"]];
    
    NSString* _envelope = [Soap createEnvelope: @"RegisterSale" forNamespace:self.namespace withParameters: _params withHeaders: self.headers];
    SoapRequest* _request = [SoapRequest create: target action: action service: self soapAction: @"http://tempuri.org/IIsupos3Service/RegisterSale" postData: _envelope deserializeTo:nil];
    [_request send];
    return _request;
    
}



@end
