//
//  AppDelegate.m
//  ISUPOS
//
//  Created by Mac User on 4/2/15.
//  Copyright (c) 2015 Impinge Solutions. All rights reserved.
//

#import "AppDelegate.h"
// Other Classes
#import "HomeViewController.h"
#import "articalsViewController.h"
#import "receiptsViewController.h"
#import "ParkRecieptViewController.h"
#import "MoreViewController.h"
#import "ISUPosSoapService.h"
// Helper Classes
#import "Constants.h"
#import "getArticleName.h"
#import <SplunkMint/SplunkMint.h>
#import "Language.h"
#import "NSMutableDictionary+NilValueCheck.h"
#import "SendGridEmailAttachment.h"


static NSString *portName = nil;
static NSString *portSettings = nil;
static NSString *drawerPortName = nil;


@interface AppDelegate ()
{
    NSMutableArray *array_ArticleDetails;
    int saveIndex;
    int articleLitCount;
    NSString *currencySign;
    AppDelegate *appDelegate;
    
    NSMutableString *str_emailFormat;
   
    
    //    SendGridEmail *email;
    
}
@property(nonatomic,strong)SendGridEmail *email;
@property (nonatomic,strong) SendGrid *sendGridClient;
@end


@implementation AppDelegate
@synthesize ary_RegisterSale;
@synthesize bool_RegisterSale;


@synthesize reciptArray,reciptArrayReceipt,arrayPrintLog;

+ (instancetype)delegate
{
    return [UIApplication sharedApplication].delegate;
}

#pragma mark getter/setter

+ (NSString*)getPortName
{
    return portName;
}

+ (void)setPortName:(NSString *)m_portName
{
    if (portName != m_portName) {
        [portName release];
        portName = [m_portName copy];
    }
}

+ (NSString *)getPortSettings
{
    return portSettings;
}

+ (void)setPortSettings:(NSString *)m_portSettings
{
    if (portSettings != m_portSettings) {
        [portSettings release];
        portSettings = [m_portSettings copy];
    }
}

+ (NSString *)getDrawerPortName {
    return drawerPortName;
}

+ (void)setDrawerPortName:(NSString *)portName {
    if (drawerPortName != portName) {
        [drawerPortName release];
        drawerPortName = [portName copy];
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
//    str_msg=[Language get:@"Please Enter Valid Email" alter:@"!Please Enter Valid Email"];
//    
    [[NSUserDefaults standardUserDefaults] setObject:@"00" forKey:@"SelectedTab"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // OLD ID Splunk API Key Paased Here
    //[[Mint sharedInstance] initAndStartSession:@"5b472369"];
    
    //new ID
    [[Mint sharedInstance] initAndStartSession:@"944456bf"];
    
    //Crashlytics
    
    [Fabric with:@[[Crashlytics class]]];
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:91.0f/255.0f green:41.0f/255.0f blue:117.0f/255.0f alpha:1.0f]];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    //    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"navbar.png"]]];
    
    //    [[UINavigationBar appearance] setTranslucent:NO];
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"HelveticaNeue" size:30], NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, nil];
    
    [[UINavigationBar appearance] setTitleTextAttributes:attributes];
    
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    
    // Global
    
    NSManagedObjectContext *context1 =[appDelegate managedObjectContext];
    NSEntityDescription *entityDesc1 =[NSEntityDescription entityForName:@"GlobalVariables" inManagedObjectContext:context1];
    NSFetchRequest *request11 = [[NSFetchRequest alloc] init];
    [request11 setEntity:entityDesc1];
    NSError *error1;
    NSArray *objects11 = [context1 executeFetchRequest:request11 error:&error1];
    
    if ([objects11 count] == 0)
    {
        NSManagedObject *newContact;
        newContact = [NSEntityDescription insertNewObjectForEntityForName:@"GlobalVariables" inManagedObjectContext:context1];
        
        [newContact setValue:@"0" forKey:@"originalMail"];
        [newContact setValue:@"0" forKey:@"originalPrint"];
        [newContact setValue:@"0" forKey:@"copyPrint"];
        [newContact setValue:@"0" forKey:@"copyMail"];
        [newContact setValue:@"0" forKey:@"originalMailZDay"];
        [newContact setValue:@"0" forKey:@"originalPrintZDay"];
        [newContact setValue:@"0" forKey:@"copyPrintZDay"];
        [newContact setValue:@"0" forKey:@"copyMailZDay"];
        [newContact setValue:@"0" forKey:@"refund"];
        [newContact setValue:@"0" forKey:@"refundZDay"];
        [newContact setValue:@"0.0" forKey:@"totalCopyMailAmount"];
        [newContact setValue:@"0.0" forKey:@"totalCopyPrintAmount"];
        [newContact setValue:@"0.0" forKey:@"totalCopyMailAmountZDay"];
        [newContact setValue:@"0.0" forKey:@"totalCopyPrintAmountZDay"];
        
        [context1 save:&error1];
    }
    //
    
    
    NSManagedObjectContext *context =[appDelegate managedObjectContext];
    
    NSEntityDescription *entityDesc =[NSEntityDescription entityForName:@"User" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
//    NSString *str=@"test@gmail.com";
//    
//    NSPredicate *pred =[NSPredicate predicateWithFormat:@"(email = %@)",str];
//    [request setPredicate:pred];
    // NSManagedObject *matches = nil;
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    if ([objects count] == 0) {
        NSManagedObject *newContact;
        newContact = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:context];
        [newContact setValue:@"admin@isupos.com" forKey:@"email"];
        [newContact setValue:@"admin" forKey:@"password"];
        [context save:&error];
        
        [[NSUserDefaults standardUserDefaults] setObject:@"admin@isupos.com" forKey:@"Luser"];
        [[NSUserDefaults standardUserDefaults]setValue:@"yes" forKey:@"firstTime"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    } else {

        AppDelegate *appDelegateTemp = [[UIApplication sharedApplication]delegate];
        UIViewController* rootController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"LoginViewController"];
        UINavigationController* navigation = [[UINavigationController alloc] initWithRootViewController:rootController];
        appDelegateTemp.window.rootViewController = navigation;
    }
    
    NSFetchRequest *request1 = [NSFetchRequest fetchRequestWithEntityName:@"Cart"];
    NSArray *objects1 = [context executeFetchRequest:request1 error:&error];
    if (objects1 == nil) {
        // handle error
    } else {
        for (NSManagedObject *object in objects1) {
            [context deleteObject:object];
        }
        [context save:&error];
    }
    
    
    //    NSFetchRequest *request2 = [NSFetchRequest fetchRequestWithEntityName:@"CustomDiscount"];
    //    NSPredicate *pred2 =[NSPredicate predicateWithFormat:@"(id = %@)",@"1S"];
    //    [request setPredicate:pred2];
    //
    //    NSArray *objects2 = [context executeFetchRequest:request2 error:&error];
    //    if (objects2 == nil) {
    //        // handle error
    //    } else {
    //        for (NSManagedObject *object in objects2) {
    //            [context deleteObject:object];
    //        }
    //        [context save:&error];
    //    }
    
    
    NSEntityDescription *entityDesccd =[NSEntityDescription entityForName:@"VatVariation" inManagedObjectContext:context];
    NSFetchRequest *requesttt = [[NSFetchRequest alloc] init];
    [requesttt setEntity:entityDesccd];
    
    NSArray *objectss3 = [context executeFetchRequest:requesttt error:&error];
    if ([objectss3 count] == 0) {
        
        NSManagedObject *newContact;
        for(int i=0;i<4;i++)
        {
            newContact = [NSEntityDescription insertNewObjectForEntityForName:@"VatVariation" inManagedObjectContext:context];
            if(i==0)
                [newContact setValue:@"0%" forKey:@"vat"];
            if(i==1)
                [newContact setValue:@"6%" forKey:@"vat"];
            if(i==2)
                [newContact setValue:@"12%" forKey:@"vat"];
            if(i==3)
                [newContact setValue:@"25%" forKey:@"vat"];
            //            if(i==3)
            //        [newContact setValue:@"25%" forKey:@"vat"];
            
            [context save:&error];
        }
    }
    NSEntityDescription *entityDescc =[NSEntityDescription entityForName:@"VatandCurrency" inManagedObjectContext:context];
    NSFetchRequest *requestt = [[NSFetchRequest alloc] init];
    [requestt setEntity:entityDescc];
    NSManagedObject *matches = nil;
    NSArray *objectss = [context executeFetchRequest:requestt error:&error];
    if ([objectss count] == 0) {
        NSManagedObject *newContact;
        newContact = [NSEntityDescription insertNewObjectForEntityForName:@"VatandCurrency" inManagedObjectContext:context];
        [newContact setValue:@"$" forKey:@"currency"];
        currencySign=@"$";
        [context save:&error];
        
    } else {
        
        matches=(NSManagedObject*)[objectss objectAtIndex:0];
        
        currencySign=[matches valueForKey:@"currency"];
        
        if([[matches valueForKey:@"language"] isEqualToString:@"SE"])
        {
            [Language setLanguage:@"sv"];
            
        }
        else
        {
            [Language setLanguage:@"en"];
            
        }
        
        emailid=[matches valueForKey:@"email"];
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSLog(@"%@",[paths objectAtIndex:0]);
    
    return YES;
}


-(void)getArticlevalues:(id)index
{
    SoapArray *array=(SoapArray*)index;

    NSMutableDictionary *dict;
    dict=[[NSMutableDictionary alloc] init];
    
    [dict setValuesForKeysWithDictionary:[[array objectAtIndex:0] valueForKey:@"Active"] forKey:@"Active"];
    [dict setValue:[[array objectAtIndex:0] valueForKey:@"ArticleNumber"] forKey:@"ArticleNumber"];
    [dict setValue:[[array objectAtIndex:0] valueForKey:@"AttributeCombo"] forKey:@"AttributeCombo"];
    [dict setValue:[[array objectAtIndex:0] valueForKey:@"Barcode"] forKey:@"Barcode"];
    [dict setValue:[[array objectAtIndex:0] valueForKey:@"Brand"] forKey:@"Brand"];
    [dict setValue:[[array objectAtIndex:0] valueForKey:@"CostPrice"] forKey:@"CostPrice"];
    [dict setValue:[[array objectAtIndex:0] valueForKey:@"Description"] forKey:@"Description"];
    [dict setValue:[[array objectAtIndex:0] valueForKey:@"GroupName"] forKey:@"GroupName"];
    [dict setValue:[[array objectAtIndex:0] valueForKey:@"LastModified"] forKey:@"LastModified"];
    [dict setValue:[[array objectAtIndex:0] valueForKey:@"Location"] forKey:@"Location"];
    [dict setValue:[[array objectAtIndex:0] valueForKey:@"Name"] forKey:@"Name"];
    [dict setValue:[[array objectAtIndex:0] valueForKey:@"PriceIncVat"] forKey:@"PriceIncVat"];
    [dict setValue:[[array objectAtIndex:0] valueForKey:@"ProductModel"] forKey:@"ProductModel"];
    [dict setValue:[[array objectAtIndex:0] valueForKey:@"Quantity"] forKey:@"Quantity"];
    [dict setValue:[[array objectAtIndex:0] valueForKey:@"SalesAccount"] forKey:@"SalesAccount"];
    [dict setValue:[[array objectAtIndex:0] valueForKey:@"SerialNumber"] forKey:@"SerialNumber"];
    [dict setValue:[[array objectAtIndex:0] valueForKey:@"SubGroupName"] forKey:@"SubGroupName"];
    [dict setValue:[[array objectAtIndex:0] valueForKey:@"Supplier"] forKey:@"Supplier"];
    [dict setValue:[[array objectAtIndex:0] valueForKey:@"Unit"] forKey:@"Unit"];
    [dict setValue:[[array objectAtIndex:0] valueForKey:@"Vat"] forKey:@"Vat"];
    [dict setValue:[[array objectAtIndex:0] valueForKey:@"VatRateDec"] forKey:@"VatRateDec"];
    
    
    [array_ArticleDetails addObject:dict];
    
    if (articleLitCount==[array_ArticleDetails count]) {
        
        for (int i=0; i<[array_ArticleDetails count]; i++) {
          
            saveIndex=i;
            
            [self getData];
            
            
        }
    }
    
    
}


-(void)getArticleList:(id)index
{
    SoapArray *array=(SoapArray*)index;

    
    NSMutableArray *ArticleList=[[NSMutableArray alloc] init];
    
    ArticleList= [NSMutableArray arrayWithArray:[[array objectAtIndex:0] valueForKey:@"Articles"]];
    
    
    array_ArticleDetails=[[NSMutableArray alloc] init];
    articleLitCount=[ArticleList count];
    for (int i=0; i<[ArticleList count]; i++) {
        
        ISUPosSoapService *service = [[ISUPosSoapService alloc] init];
        [service GetArticleName:self action:@selector(getArticlevalues:) UserId:(NSNumber *)[NSString stringWithFormat:@"%@",[ArticleList objectAtIndex:i]]];
        
        
        
    }
    
    //    NSMutableArray *arrayXML = [[NSMutableArray alloc] init];
    //    NSArray *p = [[[array objectAtIndex:0] valueForKey:@"Articles"] nodesForXPath:@"//TrackResponse/TrackInfo" error:nil];
    //    if ([p count]>0) {
    //        for (CXMLElement *resultElement in [[p objectAtIndex:0] elementsForName:@"TrackDetail"]) {
    //            [arrayXML addObject:[resultElement stringValue]];
    //        }
    //    }
    
    
}


#pragma mark Send Grid

- (SendGrid*)sendGridClient{
    
    //    if (!_sendGridClient) {
    _sendGridClient =[SendGrid apiUser:@"satishsaini" apiKey:@"SatS@123"];
    //    }
    return _sendGridClient;
}

- (void)sendMailWithSubject:(NSString *)subject sendFrom:(NSString *)senderEmailID ToReciepents:(NSString *)reciepents messageHtmlBodyContent:(NSString *)messageHtmlBody {
    
    
    _email = [[SendGridEmail alloc] init];
    
    
    if([self.reciptArray count]>0)
    {
        
       // [self createMailFormat];
        [self newreceiptFormatForMail];
        
        NSMutableArray *receipentsList;
        
        if ([[NSUserDefaults standardUserDefaults]valueForKey:@"EMAIL"]) {
            
            receipentsList = [[NSMutableArray alloc] initWithArray:@[[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"EMAIL"]]]];
        }
        else
        {
            receipentsList = [[NSMutableArray alloc] initWithArray:@[@"richag@impingeonline.com", @"mandeepsharma@impingeonline.com",@"parveen@impingeonline.com"]];
        }
        
        
        [_email setTos:receipentsList];
        //    [email addBcc:@"davinder@impingesolutions.com"];
        _email.from = @"info@isupos.com";
        _email.subject = [NSString stringWithFormat:@"%@", [Language get:@"Receipt" alter:@"!Receipt"]];
        //    email.html = @"<html><head><title>Payment Receipt</title><style>tr{float:left;clear:both;padding:2px 0;width:230px;}.heading{border-bottom: 1px dashed #000;float: left;padding: 10px 0;}.total{border-top:1px dashed #000;border-bottom:1px dashed #000;padding: 5px 0;}.buying{border-top:1px dashed #000;margin-top:60px;}</style></head><body><div class=""wrapper""><div class=""sale""><table><tr class=""heading""><td>Date:</td><td>24 August 2015</td><td>&nbsp;<td><td>Time:18:08</td></tr><tr><td colspan=4><strong>SALE</strong></td></tr><tr><td>2</td><td>DDR2 Module 2GB</td><td>&nbsp;<td><td>200.00</td></tr><tr><td>2</td><td>DDR2 Module 2GB</td><td>&nbsp;<td><td>200.00</td></tr><tr><td>2</td><td>DDR2 Module 2GB</td><td>&nbsp;<td><td>200.00</td></tr><tr><td colspan=2>Vat</td><td>&nbsp;<td><td style=""text-align: right;width: 160px;"">""$120.00</td></tr><tr><td colspan=2>Discount</td><td>&nbsp;<td><td style=""text-align" "right;width: 110px;"">-$0.00</td></tr><tr class=""total""><td colspan=2>Total</td><td>&nbsp;<td><td style=""text-align: right;width: 150px;""><strong>$600.00</strong></td></tr><tr><td>Charge</td><td colspan=3>&nbsp;</td></tr><tr><td>$600.00</td><td colspan=3>&nbsp;</td></tr><tr><td colspan=4 style=""width:230px;text-align:center;border-bottom:1px dashed #000;"">Sign Here</td></tr><tr class=""buying""><td colspan=4>Thank you for buying!</td></tr></table></div></div></body></html></h1>";
        //    email.text = @"My first email through SendGrid /n /nThanks/nRajeev Lochan Ranga";
        
        _email.html=str_emailFormat;
        
   //     [self.sendGridClient sendWithWeb:_email];
        [self.sendGridClient sendWithWeb:_email successBlock:^(id responseObject) {
            
            
            NSLog(@"Mail send Successfully to %@ ",receipentsList);
            
            //print merchant receipt after the email is sent
            NSString *portName = [AppDelegate getPortName];
            NSString *portSettings = [AppDelegate getPortSettings];
            [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"print_merchant_receipt"];
            [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"print_customer_receipt"];
            [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"print_combined_receipt"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [MiniPrinterFunctions PrintSampleReceiptWithPortname:portName
                                                    portSettings:portSettings
                                                       widthInch:2];

            
            
            [self.receipt_paymentDetails_copy removeAllObjects];
            
        } failureBlock:^(NSError *error) {
            
        }];
        
        
    }
    else
    {
        
    }
}

- (NSString*)convertMonthString:(NSString *)monthString{
    monthString = [Language get:[NSString stringWithFormat:@"%@",monthString] alter:[NSString stringWithFormat:@"!%@",monthString]];
    return monthString;
}

#pragma mark -- NewReceipt Format
- (void)newreceiptFormatForMail{
    
    appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context1 =[appDelegate managedObjectContext];
    NSError *error1;
    NSEntityDescription *entityDescc =[NSEntityDescription entityForName:@"VatandCurrency" inManagedObjectContext:context1];
    NSFetchRequest *requestt = [[NSFetchRequest alloc] init];
    [requestt setEntity:entityDescc];
    NSManagedObject *matches = nil;
    NSArray *objectss = [context1 executeFetchRequest:requestt error:&error1];
    if ([objectss count] == 0) {
        NSManagedObject *newContact;
        newContact = [NSEntityDescription insertNewObjectForEntityForName:@"VatandCurrency" inManagedObjectContext:context1];
        [newContact setValue:@"$" forKey:@"currency"];
        currencySign=@"$";
        [context1 save:&error1];
        
    } else {
        
        matches=(NSManagedObject*)[objectss objectAtIndex:0];
        currencySign=[matches valueForKey:@"currency"];
    }
    
       
    NSManagedObjectContext *context =[appDelegate managedObjectContext];
    NSEntityDescription *entityDesc =[NSEntityDescription entityForName:@"ReceiptData" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    NSPredicate *pred =[NSPredicate predicateWithFormat:@"(id = %@)",@"1"];
    [request setPredicate:pred];
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    //    NSManagedObject *person = (NSManagedObject *)[objects objectAtIndex:0];
    
    NSMutableDictionary *dictHeaderFooter = [NSMutableDictionary new];
    
    if (objects.count == 0)
    {
        [dictHeaderFooter setValue:@"" forKey:@"organization_name"];
        [dictHeaderFooter setValue:@"" forKey:@"company_name"];
        [dictHeaderFooter setValue:@"" forKey:@"address1"];
        [dictHeaderFooter setValue:@"" forKey:@"address2"];
        [dictHeaderFooter setValue:@"" forKey:@"zipcode"];
        [dictHeaderFooter setValue:@"" forKey:@"city"];
        [dictHeaderFooter setValue:@"" forKey:@"phone"];
        [dictHeaderFooter setValue:@"" forKey:@"fax"];
        [dictHeaderFooter setValue:@"" forKey:@"homepage"];
        
        [dictHeaderFooter setValue:@"" forKey:@"row1"];
        [dictHeaderFooter setValue:@"" forKey:@"row2"];
        [dictHeaderFooter setValue:@"" forKey:@"row3"];
        [dictHeaderFooter setValue:@"" forKey:@"row4"];
        [dictHeaderFooter setValue:@"" forKey:@"row5"];
        [dictHeaderFooter setValue:@"" forKey:@"row6"];
        [dictHeaderFooter setValue:@"" forKey:@"row7"];
        [dictHeaderFooter setValue:@"" forKey:@"row8"];
        [dictHeaderFooter setValue:@"" forKey:@"row9"];
        [dictHeaderFooter setValue:@"" forKey:@"row10"];
    }
    else
    {
        for(int i=0;i<objects.count;i++)
        {
            NSManagedObject *person = (NSManagedObject *)[objects objectAtIndex:i];
            
            [dictHeaderFooter setValue:[person valueForKey:@"organization_name"] forKey:@"organization_name"];
            [dictHeaderFooter setValue:[person valueForKey:@"company_name"] forKey:@"company_name"];
            [dictHeaderFooter setValue:[person valueForKey:@"address1"] forKey:@"address1"];
            [dictHeaderFooter setValue:[person valueForKey:@"address2"] forKey:@"address2"];
            [dictHeaderFooter setValue:[person valueForKey:@"zipcode"] forKey:@"zipcode"];
            [dictHeaderFooter setValue:[person valueForKey:@"city"] forKey:@"city"];
            [dictHeaderFooter setValue:[person valueForKey:@"phone"] forKey:@"phone"];
            [dictHeaderFooter setValue:[person valueForKey:@"fax"] forKey:@"fax"];
            [dictHeaderFooter setValue:[person valueForKey:@"homepage"] forKey:@"homepage"];
            
            [dictHeaderFooter setValue:[person valueForKey:@"row1"] forKey:@"row1"];
            [dictHeaderFooter setValue:[person valueForKey:@"row2"] forKey:@"row2"];
            [dictHeaderFooter setValue:[person valueForKey:@"row3"] forKey:@"row3"];
            [dictHeaderFooter setValue:[person valueForKey:@"row4"] forKey:@"row4"];
            [dictHeaderFooter setValue:[person valueForKey:@"row5"] forKey:@"row5"];
            [dictHeaderFooter setValue:[person valueForKey:@"row6"] forKey:@"row6"];
            [dictHeaderFooter setValue:[person valueForKey:@"row7"] forKey:@"row7"];
            [dictHeaderFooter setValue:[person valueForKey:@"row8"] forKey:@"row8"];
            [dictHeaderFooter setValue:[person valueForKey:@"row9"] forKey:@"row9"];
            [dictHeaderFooter setValue:[person valueForKey:@"row10"] forKey:@"row10"];
        }
    }
    
    
    if (self.customerReceipt != nil) {
        
        [self addReceiptData];
 }

    str_emailFormat=[[NSMutableString alloc] init];
    
    //Recipet format

    [str_emailFormat appendString:@"<html><head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\" /><title>:: Invoice ::</title><style>body{margin:0;padding:0;font-family:Verdana, Geneva, sans-serif;font-size:14px;}</style></head>"];
    
    [str_emailFormat appendString:@"<body>"];
    [str_emailFormat appendString:@"<table width=\"100%\" cellpadding=\"0\" cellspacing=\"0\" border=\"0\">"];
    [str_emailFormat appendString:@"<tr>"];
    [str_emailFormat appendString:@"<td valign=\"top\" align=\"center\">"];
    [str_emailFormat appendString:@"<table width=\"295px\" cellpadding=\"0\" cellspacing=\"0\" border=\"0\"><tr><td valign=\"top\" align=\"center\"><table width=\"100%\" cellpadding=\"0\" cellspacing=\"0\">"];
    
    if ([self validateDictionaryValueForKey:[dictHeaderFooter valueForKey:@"company_name"] ]) {
        [str_emailFormat appendFormat:@"<tr><td align=\"center\" valign=\"top\" style=\"font-weight:bold; font-size:18px\">%@</td></tr>",[dictHeaderFooter valueForKey:@"company_name"]];
    }
    [str_emailFormat appendString:@"<tr><td align=\"center\" valign=\"top\" height=\"15px\">&nbsp;</td></tr>"];
    
    if ([self validateDictionaryValueForKey:[dictHeaderFooter valueForKey:@"organization_name"] ]) {
        [str_emailFormat appendFormat:@"<tr><td align=\"center\" valign=\"top\" style=\"font-size:12px;\">Org.nr: %@</td></tr>",[dictHeaderFooter valueForKey:@"organization_name"]];
    }
    if ([self validateDictionaryValueForKey:[dictHeaderFooter valueForKey:@"address1"] ]) { //Ramgatan 11
        [str_emailFormat appendFormat:@"<tr><td align=\"center\" valign=\"top\" style=\"font-size:12px;\">%@</td></tr>",[dictHeaderFooter valueForKey:@"address1"]];
    }
    if ([self validateDictionaryValueForKey:[dictHeaderFooter valueForKey:@"address2"] ]) {// 65341 KARLSTAD
        [str_emailFormat appendFormat:@"<tr><td align=\"center\" valign=\"top\" style=\"font-size:12px;\">%@",[dictHeaderFooter valueForKey:@"address2"]];
    }
    
    if ([self validateDictionaryValueForKey:[dictHeaderFooter valueForKey:@"city"] ]) {
        [str_emailFormat appendFormat:@"<tr><td align=\"center\" valign=\"top\" style=\"font-size:12px; display:block;\">%@</td></tr>",[dictHeaderFooter valueForKey:@"city"] ];
    }
    
    if ([self validateDictionaryValueForKey:[dictHeaderFooter valueForKey:@"homepage"] ]) {
        [str_emailFormat appendFormat:@"<tr><td align=\"center\" valign=\"top\" style=\"font-size:12px; display:block;\">%@</td></tr>",[dictHeaderFooter valueForKey:@"homepage"] ];
    }
    
    if ([self validateDictionaryValueForKey:[dictHeaderFooter valueForKey:@"zipcode"] ]) {
        [str_emailFormat appendFormat:@"<tr><td align=\"center\" valign=\"top\" style=\"font-size:12px; display:block;\">%@</td></tr>",[dictHeaderFooter valueForKey:@"zipcode"] ];
    }
    
    if ([self validateDictionaryValueForKey:[dictHeaderFooter valueForKey:@"phone"] ]) {
        [str_emailFormat appendFormat:@"<tr><td align=\"center\" valign=\"top\" style=\"font-size:12px; display:block;\">%@</td></tr>", [dictHeaderFooter valueForKey:@"phone"]];
    }
    
    if ([self validateDictionaryValueForKey:[dictHeaderFooter valueForKey:@"fax"] ]) {
        [str_emailFormat appendFormat:@"<tr><td align=\"center\" valign=\"top\" style=\"font-size:12px; display:block;\">%@</td></tr>", [dictHeaderFooter valueForKey:@"fax"]];
    }
    // Row1 to Row5 for Tax at the top of the Receipt
    if ([self validateDictionaryValueForKey:[dictHeaderFooter valueForKey:@"row1"] ]) {
        [str_emailFormat appendFormat:@"<tr><td align=\"center\" valign=\"top\" style=\"font-size:12px; display:block;\">%@</td></tr>", [dictHeaderFooter valueForKey:@"row1"]];
    }
    
    if ([self validateDictionaryValueForKey:[dictHeaderFooter valueForKey:@"row2"] ]) {
        [str_emailFormat appendFormat:@"<tr><td align=\"center\" valign=\"top\" style=\"font-size:12px; display:block;\">%@</td></tr>", [dictHeaderFooter valueForKey:@"row2"]];
    }
    
    if ([self validateDictionaryValueForKey:[dictHeaderFooter valueForKey:@"row3"] ]) {
        [str_emailFormat appendFormat:@"<tr><td align=\"center\" valign=\"top\" style=\"font-size:12px; display:block;\">%@</td></tr>", [dictHeaderFooter valueForKey:@"row3"]];
    }
    
    if ([self validateDictionaryValueForKey:[dictHeaderFooter valueForKey:@"row4"] ]) {
        [str_emailFormat appendFormat:@"<tr><td align=\"center\" valign=\"top\" style=\"font-size:12px; display:block;\">%@</td></tr>", [dictHeaderFooter valueForKey:@"row4"]];
    }
    
    if ([self validateDictionaryValueForKey:[dictHeaderFooter valueForKey:@"row5"] ]) {
        [str_emailFormat appendFormat:@"<tr><td align=\"center\" valign=\"top\" style=\"font-size:12px; display:block;\">%@</td></tr>", [dictHeaderFooter valueForKey:@"row5"]];
    }
    
    [str_emailFormat appendString:@"<tr><td align=\"center\" valign=\"top\" height=\"15px\">&nbsp;</td></tr>"];
    [str_emailFormat appendFormat:@"<td align=\"center\" valign=\"top\" style=\"font-size:24px; font-weight:bold;\">%@</td>",[Language get:@"Receipt" alter:@"!Receipt"]];
    [str_emailFormat appendFormat:@"</table></td></tr><tr><td><hr /></td></tr>"];
    [str_emailFormat appendString:@"<tr><td valign=\"top\" align=\"center\"><table width=\"100%\" cellpadding=\"0\" cellspacing=\"0\" border=\"0\">"];
    
    
    
    if (self.customerReceipt!=nil) {
        [str_emailFormat appendFormat:@"<tr><td style=\"font-size:11px\" valign=\"top\" align=\"left\" >%@ : 1</td><td style=\"font-size:11px\" valign=\"top\" align=\"center\">%@ : %@</td><td style=\"font-size:11px\" valign=\"top\" align=\"right\">%@</td></tr>",[Language get:@"Cash" alter:@"!Cash"],[Language get:@"Receipt No" alter:@"!Receipt No"],[[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:0] valueForKey:@"id"], [self.receipt_paymentDetails_copy valueForKey:@"Date"]];
        
        [str_emailFormat appendFormat:@"<tr><td colspan=\"3\" valign=\"top\" align=\"left\"><table width=\"100%%\" cellpadding=\"0\" cellspacing=\"0\" border=\"0\"><tr><td style=\"font-size:11px\" valign=\"top\" align=\"left\">%@ : Administrator</td><td>&nbsp;</td><td style=\"font-size:11px\" valign=\"top\" align=\"right\">%@</td></tr></table></td></tr>",[Language get:@"Seller" alter:@"!Seller"],[self.receipt_paymentDetails_copy valueForKey:@"Time"]];
    }
    else{
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd MMMM yyyy"];
        
        
        NSDate *receiptDate = [dateFormatter dateFromString:[[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:0] valueForKey:@"date"]];
        
        [str_emailFormat appendFormat:@"<tr><td style=\"font-size:11px\" valign=\"top\" align=\"left\" >Kassa : 1</td><td style=\"font-size:11px\" valign=\"top\" align=\"center\">%@ : %@</td><td style=\"font-size:11px\" valign=\"top\" align=\"right\">%@</td></tr>",[Language get:@"Receipt No" alter:@"!Receipt No"],[[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:0] valueForKey:@"id"], [dateFormatter stringFromDate:receiptDate]];
        [dateFormatter setDateFormat:@"hh:mm:ss"];
        NSDate *receipt_time = [NSDate date];
        
        [str_emailFormat appendFormat:@"<tr><td colspan=\"3\" valign=\"top\" align=\"left\"><table width=\"100%%\" cellpadding=\"0\" cellspacing=\"0\" border=\"0\"><tr><td style=\"font-size:11px\" valign=\"top\" align=\"left\">Saljare : Administrator</td><td>&nbsp;</td><td style=\"font-size:11px\" valign=\"top\" align=\"right\">%@</td></tr></table></td></tr>",[dateFormatter stringFromDate:receipt_time]];
    }
    
    [str_emailFormat appendFormat:@"</table></td><tr><td><hr /></td></tr>"];
    
    for (int i=0; i <[[appDelegate.reciptArray valueForKey:@"sub"] count]; i++) {
        
        
        NSString *str_name=[NSString stringWithFormat:@"%@",[[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:i] valueForKey:@"name"]];
        NSString *string_space = @"";
        int str_legnth=[NSString stringWithFormat:@"%@",[[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:i] valueForKey:@"name"]].length;
        if (str_legnth<20) {
            
            for (int i =0 ; i<(20-str_legnth); i++) {
                
                string_space=[string_space stringByAppendingString:@"&nbsp;"];
            }
        }
        else
        {
            
            NSString *myString = [NSString stringWithFormat:@"%@",[[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:i] valueForKey:@"name"]];
            str_name = (myString.length > 20) ? [myString substringToIndex:20] : myString;
        }
        
        NSString *concatenateString = [str_name stringByAppendingString:string_space];
        
        
        float str=0.0;
        
        if (![[[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:i] valueForKey:@"peritemprice"] isEqual:NULL] && ![[[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:i] valueForKey:@"peritemprice"] isEqual:[NSNull null]]&&[[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:i] valueForKey:@"peritemprice"] !=nil)
            
        {
            if (![[[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:i] valueForKey:@"count"] isEqual:NULL] && ![[[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:i] valueForKey:@"count"] isEqual:[NSNull null]]&&[[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:i] valueForKey:@"count"] !=nil)
            {
                
                //                str = [[[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:i] valueForKey:@"peritemprice"] floatValue]*[[[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:i] valueForKey:@"count"] floatValue];
                //
                //
                //                [str_emailFormat appendFormat:@"<tr><td>%@x</td><td>%@</td><td>&nbsp;<td><td>%@</td></tr>",[[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:i] valueForKey:@"count"],concatenateString,[NSString stringWithFormat:@"%.02f", str]];
                
                
                [str_emailFormat appendFormat:@"<tr><td valign=\"top\" align=\"center\"><table width=\"100%%\" cellpadding=\"0\" cellspacing=\"0\" border=\"0\">"];
                
                [str_emailFormat appendFormat:@"<tr><td style=\"font-size:11px\" valign=\"top\" align=\"left\" >%@</td><td style=\"font-size:11px\" valign=\"top\" align=\"right\">%.02f %@</td></tr>",str_name,totalamount,currencySign];
                
                [str_emailFormat appendFormat:@"<tr><td colspan=\"2\" valign=\"top\" align=\"left\"><table width=\"100%%\" cellpadding=\"0\" cellspacing=\"0\" border=\"0\">"];
                
                 NSString *art_id = [[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:i] valueForKey:@"article_id"];
                
                if (art_id.length == 0) {
                    NSEntityDescription *entityDesc2 =[NSEntityDescription entityForName:@"Trasections" inManagedObjectContext:context];
                    NSFetchRequest *request = [[NSFetchRequest alloc] init];
                    [request setEntity:entityDesc2];
                    NSPredicate *predicate;
                    predicate = [NSPredicate predicateWithFormat:@"(id = %@)",[[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:0] valueForKey:@"id"]];
                    [request setPredicate:predicate];
                    NSArray *transactions_objects = [context executeFetchRequest:request
                                                              error:&error];
                    
                    if ([transactions_objects count]>0)
                    {
                        NSManagedObject *managedObj = (NSManagedObject *) [transactions_objects objectAtIndex:0];
                        
                        if ([[managedObj valueForKey:@"article_id"] length]>0){
                            
                            art_id = [managedObj valueForKey:@"article_id"];
                        }
                    }
                    
                }
                [str_emailFormat appendFormat:@"<tr><td colspan=\"2\" style=\"font-size:11px\" valign=\"top\" align=\"left\">ArtNr: %@</td></tr>",art_id];
                
                [str_emailFormat appendFormat:@"<tr><td width=\"39\"></td><td style=\"font-size:11px\" valign=\"top\" align=\"left\">%@ X %.02f %@</td></tr>",[[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:i] valueForKey:@"count"],[[[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:i] valueForKey:@"peritemprice"] floatValue], currencySign];
                
            }
        }
        
        
        
        
    }
    
    [str_emailFormat appendFormat:@"</table></td></tr></table></td></tr><tr><td><hr /></td></tr>"];
    
    [str_emailFormat appendFormat:@"<tr><td valign=\"top\" align=\"center\"><table width=\"100%%\" cellpadding=\"0\" cellspacing=\"0\" border=\"0\">"];
    
    [str_emailFormat appendFormat:@"<tr><td style=\"font-size:12px; font-weight:bold;\" valign=\"top\" align=\"left\" >%@</td><td style=\"font-size:11px\"valign=\"top\"align=\"right\">%.02f %@</td></tr><tr><td colspan=\"2\" height=\"10px\">&nbsp;</td></tr>",[Language get:@"To Pay" alter:@"!To Pay"],totalamount,currencySign];
    
    
    if ([appDelegate.reciptArray valueForKey:@"exchange"] != nil)
    {
        
        [str_emailFormat appendFormat:@"<tr><td colspan=\"2\" valign=\"top\" align=\"left\"><table width=\"100%%\" cellpadding=\"0\" cellspacing=\"0\" border=\"0\">"];
        
        [str_emailFormat appendFormat:@"<tr><td style=\"font-size:11px\" valign=\"top\" align=\"left\">%@</td><td style=\"font-size:11px\" valign=\"top\" align=\"right\">%.02f %@</td></tr><tr><td colspan=\"2\" height=\"10px\">&nbsp;</td></tr>",[Language get:@"Exchange" alter:@"!Exchange"],[[appDelegate.reciptArray valueForKey:@"exchange"]floatValue],currencySign];
        
    }
    
    [str_emailFormat appendFormat:@"<tr><td colspan=\"2\" valign=\"top\" align=\"left\"><table width=\"100%%\" cellpadding=\"0\" cellspacing=\"0\" border=\"0\">"];
    
    [str_emailFormat appendFormat:@"<tr><td style=\"font-size:11px\" valign=\"top\" align=\"left\">%@</td><td style=\"font-size:11px\" valign=\"top\" align=\"right\">%.02f %@</td></tr><tr><td colspan=\"2\" height=\"10px\">&nbsp;</td></tr>",[Language get:@"Short" alter:@"!Short"],totalamount,currencySign];
    //Moms = VAT
    NSDictionary *receiptArray_details = [[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:0];
    [str_emailFormat appendFormat:@"<tr><td style=\"font-size:11px\" valign=\"top\" align=\"left\">%@    </td><td style=\"font-size:11px\" valign=\"top\" align=\"right\">%.02f %@</td></tr>",[Language get:@"Vat" alter:@"!Vat"],[[appDelegate.reciptArray valueForKey:@"totalvat"] floatValue],currencySign];
//    [str_emailFormat appendFormat:@"<tr><td style=\"font-size:11px\" valign=\"top\" align=\"left\">%@ %lu%%</td><td style=\"font-size:11px\" valign=\"top\" align=\"right\">%.02f %@</td></tr>",[Language get:@"Vat" alter:@"!Vat"],[[receiptArray_details valueForKey:@"vat"] integerValue],[[appDelegate.reciptArray valueForKey:@"totalvat"] floatValue],currencySign];
    
    //    //Moms Total = Total VAT
    //    [str_emailFormat appendFormat:@"<tr><td style=\"font-size:11px\" valign=\"top\" align=\"left\">%@</td><td style=\"font-size:11px\" valign=\"top\" align=\"right\">%.02f kr</td></tr><tr><td colspan=\"2\" height=\"10px\">&nbsp;</td></tr>",[Language get:@"Vat" alter:@"!Vat"],[[appDelegate.reciptArray valueForKey:@"totalvat"] floatValue]];
    
    //Kontrollenhet = control
//    [str_emailFormat appendFormat:@"<tr><td style=\"font-size:11px\" valign=\"top\" align=\"left\">%@:</td><td style=\"font-size:11px\" valign=\"top\" align=\"right\">&nbsp;</td></tr>",[Language get:@"Control:" alter:@"!Control:"]];
    
//    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"UnitId"]!=nil) {
//        [str_emailFormat appendFormat:@"<tr><td style=\"font-size:11px\" valign=\"top\" align=\"left\">%@</td><td style=\"font-size:11px\" valign=\"top\" align=\"right\">&nbsp;</td></tr>",[[NSUserDefaults standardUserDefaults] valueForKey:@"UnitId"]];
//
//    }
//    
    
    [str_emailFormat appendFormat:@"</table></td></tr></table></td></tr><tr><td><hr /></td></tr>"];
    
    [str_emailFormat appendFormat:@"<tr><td valign=\"top\" align=\"center\"><table width=\"100%%\" cellpadding=\"0\" cellspacing=\"0\" border=\"0\">"];

    //if (self.customerReceipt!=nil)
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"payment_mode"] isEqualToString:@"Card"]) {
        
        NSLog(@"%@",self.receipt_paymentDetails_copy);
        
        //KORTTRANSAKTION = Card transaction    Betalning = Payment
        [str_emailFormat appendFormat:@"<tr><td colspan=\"2\" align=\"center\" style=\"font-weight:bold; font-size:13px\">%@</td></tr><tr><td colspan=\"2\" height=\"10px\">&nbsp;</td></tr><tr><td style=\"font-size:11px;\" valign=\"top\" align=\"left\" >%@</td><td>&nbsp;</td></tr>",[Language get:@"Card Transaction" alter:@"!Card Transaction"],[Language get:@"Payment" alter:@"!Payment"]];
        
        [str_emailFormat appendFormat:@"<tr><td colspan=\"2\" valign=\"top\" align=\"left\"><table width=\"100%%\" cellpadding=\"0\" cellspacing=\"0\" border=\"0\">"];
        
        //SEK 24,00 kr
        [str_emailFormat appendFormat:@"<tr><td style=\"font-size:11px\" valign=\"top\" align=\"left\" >%@</td><td style=\"font-size:11px\" valign=\"top\" align=\"left\">%.02f </td></tr>",currencySign,totalamount];
        //Butiknr = Shop No.
        [str_emailFormat appendFormat:@"<tr><td style=\"font-size:11px\" valign=\"top\" align=\"left\">%@</td><td style=\"font-size:11px\" valign=\"top\" align=\"left\">%@</td></tr>",[Language get:@"Shop No." alter:@"!Shop No."],[self.receipt_paymentDetails_copy valueForKey:@"Merchant ID"]];
        
        [str_emailFormat appendFormat:@"<tr><td style=\"font-size:11px\" valign=\"top\" align=\"left\">%@</td><td style=\"font-size:11px\" valign=\"top\" align=\"left\">%@</td></tr>",[Language get:@"TerminalId:" alter:@"!TerminalId:"],[self.receipt_paymentDetails_copy  valueForKey:@"Terminal ID"]];
        
        [str_emailFormat appendFormat:@"<tr><td>&nbsp;</td><td style=\"font-size:11px\" valign=\"top\" align=\"left\">%@</td></tr>",[self.receipt_paymentDetails_copy valueForKey:@"Account"]];
        [str_emailFormat appendFormat:@"<tr><td>&nbsp;</td><td style=\"font-size:11px\" valign=\"top\" align=\"left\">payworks %@</td></tr>",[self.receipt_paymentDetails_copy valueForKey:@"Card"]];
        
        [str_emailFormat appendFormat:@"<tr><td style=\"font-size:11px\" valign=\"top\" align=\"left\">Auth:</td><td style=\"font-size:11px\" valign=\"top\" align=\"left\">%@</td></tr>", [self.receipt_paymentDetails_copy  valueForKey:@"Authorization"]];
        
        [str_emailFormat appendFormat:@"<tr><td style=\"font-size:11px\" valign=\"top\" align=\"left\">Ref nr:</td><td style=\"font-size:11px\" valign=\"top\" align=\"left\">%@</td></tr>",[self.receipt_paymentDetails_copy  valueForKey:@"Transaction"]];
        
        [str_emailFormat appendFormat:@"<tr><td style=\"font-size:11px\" valign=\"top\" align=\"left\">AID:</td><td style=\"font-size:11px\" valign=\"top\" align=\"left\">%@</td></tr>",[self.receipt_paymentDetails_copy valueForKey:@"AID"]];
        
        [str_emailFormat appendFormat:@"<tr><td>&nbsp;</td><td style=\"font-size:11px\" valign=\"top\" align=\"left\">%@ %@</td></tr>",[Language get:@"Entry Mode" alter:@"!Entry Mode"],[self.receipt_paymentDetails_copy valueForKey:@"Entry Mode"]];
        
        [str_emailFormat appendFormat:@"<tr><td style=\"font-size:11px\" valign=\"top\" align=\"left\">PWID:</td><td style=\"font-size:11px\" valign=\"top\" align=\"left\">%@</td></tr>",[self.receipt_paymentDetails_copy  valueForKey:@"pwid_part1"]];
        
        [str_emailFormat appendFormat:@"<tr><td>&nbsp;</td><td style=\"font-size:11px\" valign=\"top\" align=\"left\">%@</td></tr>",[self.receipt_paymentDetails_copy  valueForKey:@"pwid_part2"]];
        
        [str_emailFormat appendFormat:@"</table></td></tr></table></td></tr><tr><td><hr /></td></tr>"];
        
        
    }
    
  
    //[str_emailFormat appendFormat:@"<tr><td height=\"20px\">&nbsp;</td></tr>"];
    
    
  //  [str_emailFormat appendString:@"<tr><td><hr /></td></tr>"];
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"Code"] length]>0) {
        [str_emailFormat appendFormat:@"<tr><td valign=\"top\" align=\"center\"><table width=\"100%%\" cellpadding=\"0\" cellspacing=\"0\" border=\"0\">"];
        [str_emailFormat appendFormat:@"<tr><td height=\"5px\">&nbsp;</td></tr>"];
        [str_emailFormat appendFormat:@"<tr><td align=\"center\" valign=\"top\" style=\"font-size:11px; display:block;\">%@</td></tr>", [[NSUserDefaults standardUserDefaults] valueForKey:@"Code"]];
        [str_emailFormat appendString:@"</table></td></tr>"];
    }
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"UnitId"] length]>0) {
        [str_emailFormat appendFormat:@"<tr><td valign=\"top\" align=\"center\"><table width=\"100%%\" cellpadding=\"0\" cellspacing=\"0\" border=\"0\">"];
        [str_emailFormat appendFormat:@"<tr><td height=\"5px\">&nbsp;</td></tr>"];
        [str_emailFormat appendFormat:@"<tr><td align=\"center\" valign=\"top\" style=\"font-size:11px; display:block;\">%@</td></tr>", [[NSUserDefaults standardUserDefaults] valueForKey:@"UnitId"]];
        [str_emailFormat appendString:@"</table></td></tr>"];
    }

    // Row6 to Row10 for Tax at the end of the Receipt
    if ([self validateDictionaryValueForKey:[dictHeaderFooter valueForKey:@"row6"] ]) {
        [str_emailFormat appendFormat:@"<tr><td valign=\"top\" align=\"center\"><table width=\"100%%\" cellpadding=\"0\" cellspacing=\"0\" border=\"0\">"];
        // [str_emailFormat appendFormat:@"<tr><td align=\"center\" style=\"font-weight:bold; font-size:13px\">Sign In Here</td></tr>"];
        [str_emailFormat appendFormat:@"<tr><td align=\"center\" valign=\"top\" style=\"font-size:12px; display:block;\">%@</td></tr>", [dictHeaderFooter valueForKey:@"row6"]];
        
    }
    
    if ([self validateDictionaryValueForKey:[dictHeaderFooter valueForKey:@"row7"] ]) {
        [str_emailFormat appendFormat:@"<tr><td height=\"5px\">&nbsp;</td></tr>"];
        [str_emailFormat appendFormat:@"<tr><td align=\"center\" valign=\"top\" style=\"font-size:12px; display:block;\">%@</td></tr>", [dictHeaderFooter valueForKey:@"row7"]];
        
    }
    
    if ([self validateDictionaryValueForKey:[dictHeaderFooter valueForKey:@"row8"] ]) {
        [str_emailFormat appendFormat:@"<tr><td height=\"5px\">&nbsp;</td></tr>"];
        [str_emailFormat appendFormat:@"<tr><td align=\"center\" valign=\"top\" style=\"font-size:12px; display:block;\">%@</td></tr>", [dictHeaderFooter valueForKey:@"row8"]];
         }
    
    if ([self validateDictionaryValueForKey:[dictHeaderFooter valueForKey:@"row9"] ]) {
        [str_emailFormat appendFormat:@"<tr><td height=\"5px\">&nbsp;</td></tr>"];
        [str_emailFormat appendFormat:@"<tr><td align=\"center\" valign=\"top\" style=\"font-size:12px; display:block;\">%@</td></tr>", [dictHeaderFooter valueForKey:@"row9"]];
     }
    
    if ([self validateDictionaryValueForKey:[dictHeaderFooter valueForKey:@"row10"] ]) {
        [str_emailFormat appendFormat:@"<tr><td height=\"5px\">&nbsp;</td></tr>"];
        [str_emailFormat appendFormat:@"<tr><td align=\"center\" valign=\"top\" style=\"font-size:12px; display:block;\">%@</td></tr>", [dictHeaderFooter valueForKey:@"row10"]];
        [str_emailFormat appendString:@"</table></td></tr>"];
       }
    
    
    [str_emailFormat appendString:@"<tr><td><hr /></td></tr>"];
    [str_emailFormat appendFormat:@"<tr><td align=\"center\" style=\"font-size:11px\" valign=\"top\" align=\"left\">%@</td></tr>",[Language get:@"Thank you for buying!" alter:@"!Thank you for buying!"]];
    [str_emailFormat appendFormat:@"<tr><td height=\"50\">&nbsp;</td></tr>"];
    [str_emailFormat appendFormat:@"<tr><td valign=\"top\" align=\"center\" style=\"font-size:11px\">%@ - %@</td></tr>",[Language get:@"Save the receipt" alter:@"!Save the receipt"],[Language get:@"Customer Copy" alter:@"!Customer Copy"]];
    [str_emailFormat appendString:@"<tr><td><hr /></td></tr></table></td></tr></table></body></html>"];
}
     
/*
 "Contact" = "Kontakt";
 "AID" = "AID";
 "Account" = "Konto";
 "Additional Information" = "Ytterligare information";
 "Address" = "Adress.";
 "Amount" = "Summa";
 "Authorization" = "Tillst\U00e5nd";
 "City" = "Stad";
 "Country" = "Land";
 "Date" = "Datum";
 "Entry Mode" = "Inmatningsl\U00e4ge";
 "Information" = "Information";
 "Merchant ID" = "KassaID";
 "Name" = "Namn";
 "PWID" = "PWID";
 "Receipt Type" = "Kvittotyp";
 "Terminal ID" = "Terminal ID";
 "Time" = "Tid";
 "Transaction" = "Transaktion";
 "Type" = "Typ";
 "Zip" = "Postnummer";
 
 */

- (void)addReceiptData{
     self.receipt_paymentDetails  = [[NSMutableDictionary alloc]init];
        MPReceipt *receipt = self.customerReceipt;
    

                for (MPReceiptLineItem* lineItem in receipt.merchantDetails)
        {
            NSString *label = lineItem.label;
            
            if([label containsString:@"Adress."])
            {
                label=@"Address";
            }
           
            else if([label containsString:@"Kontakt"])
            {
                label=@"Contact";
            }
            else if([label containsString:@"Land"])
            {
                label=@"Country";
            }
            else if([label containsString:@"Namn"])
            {
                label=@"Name";
            }
            else if([label containsString:@"Postnummer"])
            {
                label=@"Zip";
            }
            else if([label containsString:@"Stad"])
            {
                label=@"City";
            }
            else if ([label containsString:@"Ytterligare information"])
            {
                label=@"Additional Information";
            }

            NSString *value = lineItem.value;
            
            [self.receipt_paymentDetails  setObject:value forKey:label];
        }
    
        NSString *receiptType=receipt.receiptType.label;
        NSString *payment=receipt.transactionType.label;
        NSString *amount=receipt.amountAndCurrency.label;
    
        if([receiptType containsString:@"Kvittotyp"])
        {
            receiptType = @"Receipt Type";
        }
    
    if([payment containsString:@"Typ"])
    {
        payment = @"Payment";
    }
    
    if([amount containsString:@"Summa"])
    {
        amount = @"Amount";
    }
    
    
        [self.receipt_paymentDetails  setObject:receipt.receiptType.value forKey:receiptType];
        [self.receipt_paymentDetails  setObject:receipt.transactionType.value forKey:payment];
        [self.receipt_paymentDetails  setObject:receipt.amountAndCurrency.value forKey:amount];
    

        for (MPReceiptLineItem* lineItem in receipt.paymentDetails)
        {
            NSString *label = lineItem.label;
            
            if([label containsString:@"Kort"])
            {
                label=@"Card";
            }
            else if([label containsString:@"Konto"])
            {
                label=@"Account";
            }
            else if([label containsString:@"Inmatningsläge"])
            {
                label=@"Entry Mode";
            }
            
            NSString *value = lineItem.value;

            [self.receipt_paymentDetails  setObject:value forKey:label];
           // NSLog(@"%ld :%@", (long)lineItem.key, value);
        }
    
        [self.receipt_paymentDetails  setObject:receipt.statusText.value forKey:receipt.statusText.label];
    NSString *dateKey=receipt.date.label;
    NSString *timeKey=receipt.time.label;

    if([dateKey containsString:@"Datum"])
    {
        dateKey=@"Date";
    }
    if([timeKey containsString:@"Tid"])
    {
        timeKey=@"Time";
    }
        [self.receipt_paymentDetails  setObject:receipt.date.value forKey:dateKey];
        [self.receipt_paymentDetails  setObject:receipt.time.value forKey:timeKey];
    
        for (MPReceiptLineItem* lineItem in receipt.clearingDetails)
        {
            NSString *label = lineItem.label;
            
            if([label containsString:@"Transaktion"])
            {
                label=@"Transaction";
            }
            else if([label containsString:@"KassaID"])
            {
                label=@"Merchant ID";
            }
            else if([label containsString:@"Tillstånd"])
            {
                label=@"Authorization";
            }
        
            NSString *value = lineItem.value;
            [self.receipt_paymentDetails  setObject:value forKey:label];
        }
        [self.receipt_paymentDetails  setObject:receipt.identifier.value forKey:receipt.identifier.label];
        NSString *pwid_part1 = [receipt.identifier.value substringWithRange:NSMakeRange(0,receipt.identifier.value.length/2)];
        NSString *pwid_part2 = [receipt.identifier.value substringWithRange:NSMakeRange(receipt.identifier.value.length/2 -1, receipt.identifier.value.length/2)];
       // NSDictionary *pwid_dict = @{@"pwid_part1":pwid_part1,@"pwid_part2":pwid_part2};
        [self.receipt_paymentDetails  setObject:pwid_part1 forKey:@"pwid_part1"];
        [self.receipt_paymentDetails  setObject:pwid_part2 forKey:@"pwid_part2"];
    
        self.receipt_paymentDetails_copy = [[NSMutableDictionary alloc] init];
        self.receipt_paymentDetails_copy = [self.receipt_paymentDetails mutableCopy];
        NSLog(@"Payment Details: \n%@",self.receipt_paymentDetails_copy );
}

// merchant receipt in html format
//- (void)printMerchantReceipt{
//    
//     str_emailFormat=[[NSMutableString alloc] init];
//    
//    [str_emailFormat appendString:@"<html xmlns=\"http://www.w3.org/1999/xhtml\"><head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\" /><title>:: ISOPUS Merchant Receipt ::</title><style>body{margin:0;padding:0;font-family:Verdana, Geneva, sans-serif;font-size:14px;}</style></head>"];
//    [str_emailFormat appendString:@"body><table width=\"100%\" cellpadding=\"0\" cellspacing=\"0\" border=\"0\"><tr><td valign=\"top\" align=\"center\"><table width=\"295px\" cellpadding=\"0\" cellspacing=\"0\" border=\"0\">"];
//    
//    [str_emailFormat appendFormat:@"<tr><td valign=\"top\" align=\"left\" style=\"font-size:12px\">%@</td></tr>",[self.receipt_paymentDetails_copy  valueForKey:@"Name"]];
//    [str_emailFormat appendFormat:@"<tr><td valign=\"top\" align=\"left\" style=\"font-size:12px\">%@</td></tr>",[self.receipt_paymentDetails_copy  valueForKey:@"Address"]];
//    [str_emailFormat appendFormat:@"<tr><td valign=\"top\" align=\"left\" style=\"font-size:12px\">%@ %@</td></tr>",[self.receipt_paymentDetails_copy  valueForKey:@"Zip"],[self.receipt_paymentDetails_copy  valueForKey:@"City"]];
//    [str_emailFormat appendFormat:@"<tr><td valign=\"top\" align=\"left\" style=\"font-size:12px\">%@</td></tr>",[self.receipt_paymentDetails_copy  valueForKey:@"Country"]];
//    [str_emailFormat appendFormat:@"<tr><td valign=\"top\" align=\"left\" style=\"font-size:12px\">%@</td></tr>",[self.receipt_paymentDetails_copy  valueForKey:@"Contact"]];
//    
//    [str_emailFormat appendFormat:@"<tr><td height=\"20px\">&nbsp;</td></tr><tr><td valign=\"top\" align=\"left\" style=\"font-size:12px\">Butikens kvitto Betalning</td></tr>"];
//    [str_emailFormat appendFormat:@"<tr><td valign=\"top\" align=\"left\" style=\"font-size:12px\">%@</td></tr>",[self.receipt_paymentDetails_copy  valueForKey:@"Account"]];
//    [str_emailFormat appendFormat:@"<tr><td valign=\"top\" align=\"left\" style=\"font-size:12px\">%@ %@</td></tr>",[self.receipt_paymentDetails_copy  valueForKey:@"Date"],[self.receipt_paymentDetails_copy  valueForKey:@"Time"]];
//    
//    
//    [str_emailFormat appendFormat:@"<tr><td height=\"20px\">&nbsp;</td></tr><tr><td valign=\"top\" align=\"left\" style=\"font-size:12px\">%@</td></tr>",[self.receipt_paymentDetails_copy  valueForKey:@"Card"]];
//    [str_emailFormat appendFormat:@"<tr><td valign=\"top\" align=\"left\" style=\"font-size:12px\">%@</td></tr>",[self.receipt_paymentDetails_copy  valueForKey:@"Account"]];
//    [str_emailFormat appendFormat:@"<tr><td valign=\"top\" align=\"left\" style=\"font-size:12px\">AID %@</td></tr>",[self.receipt_paymentDetails_copy  valueForKey:@"AID"]];
//    [str_emailFormat appendFormat:@"<tr><td valign=\"top\" align=\"left\" style=\"font-size:12px\">Inmatningslage %@</td></tr>",[self.receipt_paymentDetails_copy  valueForKey:@"Entry Mode"]];
//    
//    [str_emailFormat appendFormat:@"<tr><td height=\"20px\">&nbsp;</td></tr><tr><td valign=\"top\" align=\"left\" style=\"font-size:12px\">Transaktion : 217500</td></tr>"];
//    [str_emailFormat appendFormat:@"<tr><td valign=\"top\" align=\"left\" style=\"font-size:12px\">Tillstand : %@</td></tr>",[self.receipt_paymentDetails_copy  valueForKey:@"Authorization"]];
//    [str_emailFormat appendFormat:@"<tr><td valign=\"top\" align=\"left\" style=\"font-size:12px\">KasssID : %@</td></tr>",[self.receipt_paymentDetails_copy  valueForKey:@"Merchant ID"]];
//    [str_emailFormat appendFormat:@"<tr><td valign=\"top\" align=\"left\" style=\"font-size:12px\">TerminalId : %@</td></tr>",[self.receipt_paymentDetails_copy  valueForKey:@"Terminal ID"]];
//
//    //PWID
//    NSString *pwid = [self.receipt_paymentDetails_copy  valueForKey:@"PWID"];
//    NSString *pwid_part1 = [pwid substringWithRange:NSMakeRange(0,pwid.length/2)];
//    NSString *pwid_part2 = [pwid substringWithRange:NSMakeRange(pwid.length/2 -1, pwid.length/2)];
//  
//    [str_emailFormat appendFormat:@"<tr><td valign=\"top\" align=\"left\" style=\"font-size:12px\"><table width=\"100%%\" cellpadding=\"0\" cellspacing=\"0\" border=\"0\"><tr><td colspan=\"2\" valign=\"top\" align=\"left\">PWID : %@</td></tr><tr><td width=\"50\">&nbsp;</td><td valign=\"top\" align=\"left\">%@</td></tr></table></td></tr><tr><td height=\"20px\">&nbsp;</td></tr>",pwid_part1,pwid_part2];
//    
//    [str_emailFormat appendFormat:@"<tr><td valign=\"top\" align=\"left\" style=\"font-size:12px\">Behall kvitto</td></tr>"];
//    [str_emailFormat appendFormat:@"</table></td></tr></table></body></html>"];
//     
//     
//}

     
#pragma mark - Main Receipt Format when transaction completed and on transactions.

-(void)createMailFormat
{
    
    appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context1 =[appDelegate managedObjectContext];
    NSError *error1;
    NSEntityDescription *entityDescc =[NSEntityDescription entityForName:@"VatandCurrency" inManagedObjectContext:context1];
    NSFetchRequest *requestt = [[NSFetchRequest alloc] init];
    [requestt setEntity:entityDescc];
    NSManagedObject *matches = nil;
    NSArray *objectss = [context1 executeFetchRequest:requestt error:&error1];
    if ([objectss count] == 0) {
        NSManagedObject *newContact;
        newContact = [NSEntityDescription insertNewObjectForEntityForName:@"VatandCurrency" inManagedObjectContext:context1];
        [newContact setValue:@"$" forKey:@"currency"];
        currencySign=@"$";
        [context1 save:&error1];
        
    } else {
        
        matches=(NSManagedObject*)[objectss objectAtIndex:0];
        currencySign=[matches valueForKey:@"currency"];
    }

    
    NSString *str_cur;
    
    if ([currencySign isEqualToString:@"$"]) {
        
        str_cur=@"&#36;";
        
    }else if ([currencySign isEqualToString:@"€"]) {
        
        str_cur=@"&#128;";
        
    } else if ([currencySign isEqualToString:@"SEK"]) {
        
        str_cur=@"SEK";
    }
    else
    {
        str_cur=@"&#36;";
    }
    

    NSManagedObjectContext *context =[appDelegate managedObjectContext];
    NSEntityDescription *entityDesc =[NSEntityDescription entityForName:@"ReceiptData" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    NSPredicate *pred =[NSPredicate predicateWithFormat:@"(id = %@)",@"1"];
    [request setPredicate:pred];
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    //    NSManagedObject *person = (NSManagedObject *)[objects objectAtIndex:0];
    
    NSMutableDictionary *dictHeaderFooter = [NSMutableDictionary new];
    
    if (objects.count == 0)
    {
        [dictHeaderFooter setValue:@"" forKey:@"organization_name"];
        [dictHeaderFooter setValue:@"" forKey:@"company_name"];
        [dictHeaderFooter setValue:@"" forKey:@"address1"];
        [dictHeaderFooter setValue:@"" forKey:@"address2"];
        [dictHeaderFooter setValue:@"" forKey:@"zipcode"];
        [dictHeaderFooter setValue:@"" forKey:@"city"];
        [dictHeaderFooter setValue:@"" forKey:@"phone"];
        [dictHeaderFooter setValue:@"" forKey:@"fax"];
        [dictHeaderFooter setValue:@"" forKey:@"homepage"];
        
        [dictHeaderFooter setValue:@"" forKey:@"row1"];
        [dictHeaderFooter setValue:@"" forKey:@"row2"];
        [dictHeaderFooter setValue:@"" forKey:@"row3"];
        [dictHeaderFooter setValue:@"" forKey:@"row4"];
        [dictHeaderFooter setValue:@"" forKey:@"row5"];
        [dictHeaderFooter setValue:@"" forKey:@"row6"];
        [dictHeaderFooter setValue:@"" forKey:@"row7"];
        [dictHeaderFooter setValue:@"" forKey:@"row8"];
        [dictHeaderFooter setValue:@"" forKey:@"row9"];
        [dictHeaderFooter setValue:@"" forKey:@"row10"];
    }
    else
    {
        for(int i=0;i<objects.count;i++)
        {
            NSManagedObject *person = (NSManagedObject *)[objects objectAtIndex:i];
            
            [dictHeaderFooter setValue:[person valueForKey:@"organization_name"] forKey:@"organization_name"];
            [dictHeaderFooter setValue:[person valueForKey:@"company_name"] forKey:@"company_name"];
            [dictHeaderFooter setValue:[person valueForKey:@"address1"] forKey:@"address1"];
            [dictHeaderFooter setValue:[person valueForKey:@"address2"] forKey:@"address2"];
            [dictHeaderFooter setValue:[person valueForKey:@"zipcode"] forKey:@"zipcode"];
            [dictHeaderFooter setValue:[person valueForKey:@"city"] forKey:@"city"];
            [dictHeaderFooter setValue:[person valueForKey:@"phone"] forKey:@"phone"];
            [dictHeaderFooter setValue:[person valueForKey:@"fax"] forKey:@"fax"];
            [dictHeaderFooter setValue:[person valueForKey:@"homepage"] forKey:@"homepage"];
            
            [dictHeaderFooter setValue:[person valueForKey:@"row1"] forKey:@"row1"];
            [dictHeaderFooter setValue:[person valueForKey:@"row2"] forKey:@"row2"];
            [dictHeaderFooter setValue:[person valueForKey:@"row3"] forKey:@"row3"];
            [dictHeaderFooter setValue:[person valueForKey:@"row4"] forKey:@"row4"];
            [dictHeaderFooter setValue:[person valueForKey:@"row5"] forKey:@"row5"];
            [dictHeaderFooter setValue:[person valueForKey:@"row6"] forKey:@"row6"];
            [dictHeaderFooter setValue:[person valueForKey:@"row7"] forKey:@"row7"];
            [dictHeaderFooter setValue:[person valueForKey:@"row8"] forKey:@"row8"];
            [dictHeaderFooter setValue:[person valueForKey:@"row9"] forKey:@"row9"];
            [dictHeaderFooter setValue:[person valueForKey:@"row10"] forKey:@"row10"];
        }
    }
    
    
    
    str_emailFormat=[[NSMutableString alloc] init];
    
    
    //Recipet format
    
    [str_emailFormat  appendString:@"<html><head><title>Payment Receipt</title><style>tr{float:left;clear:both;padding:2px 0;width:230px;}.heading{border-bottom: 1px dashed #000;float: left;padding: 10px 0;}.total{border-top:1px dashed #000;border-bottom:1px dashed #000;padding: 5px 0;}.buying{border-top:1px dashed #000;}.align{text-align:center;width:230px;}</style></head><body><div class=""wrapper""><div class=""sale"">"];
    
    
    if ([@"Original" isEqualToString:[[NSUserDefaults standardUserDefaults]valueForKey:@"ReciptType"]]) {
        
        [str_emailFormat  appendString:[NSString stringWithFormat:@"<tr><td style=""text-align: right;width: 600px;""><strong>%@</strong></td></tr>", [Language get:@"Original" alter:@"!Original"]]];
        
    }
    else
    {
        [str_emailFormat  appendString:[NSString stringWithFormat:@"<tr><td style=""text-align: right;width: 600px;""><strong>%@</strong></td></tr>", [Language get:@"Copy" alter:@"!Copy"]]];
    }
    
    
    [str_emailFormat appendString:[NSString stringWithFormat:@"<br><br>%@: #%@",[Language get:@"Receipt No" alter:@"!Receipt No"],[[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:0] valueForKey:@"id"]]];
    
    
    // Recipt Company details
    
    [str_emailFormat  appendString:@"<table>"];
    
    
    
    
    if ([dictHeaderFooter valueForKey:@"organization_name"]) {
        
        [str_emailFormat appendFormat:@"<tr><td colspan=4 class=""align"">%@</td></tr>",[dictHeaderFooter valueForKey:@"organization_name"]];
    }
    
    if ([dictHeaderFooter valueForKey:@"company_name"]) {
        
        [str_emailFormat appendFormat:@"<tr><td colspan=4 class=""align"">%@</td></tr>",[dictHeaderFooter valueForKey:@"company_name"]];
    }
    
    if ([dictHeaderFooter valueForKey:@"address1"]) {
        
        [str_emailFormat appendFormat:@"<tr><td colspan=4 class=""align"">%@</td></tr>",[dictHeaderFooter valueForKey:@"address1"]];
    }
    if ([dictHeaderFooter valueForKey:@"address2"]) {
        
        [str_emailFormat appendFormat:@"<tr><td colspan=4 class=""align"">%@</td></tr>",[dictHeaderFooter valueForKey:@"address2"]];
    }
    
    if ([dictHeaderFooter valueForKey:@"city"]) {
        
        [str_emailFormat appendFormat:@"<tr><td colspan=4 class=""align"">%@ %@</td></tr>",[dictHeaderFooter valueForKey:@"city"],[dictHeaderFooter valueForKey:@"zipcode"]];
    }
    
    
    if ([dictHeaderFooter valueForKey:@"phone"]) {
        
        [str_emailFormat appendFormat:@"<tr><td colspan=4 class=""align"">%@</td></tr>",[dictHeaderFooter valueForKey:@"phone"]];
    }
    
    if ([dictHeaderFooter valueForKey:@"fax"]) {
        
        [str_emailFormat appendFormat:@"<tr><td colspan=4 class=""align"">%@</td></tr>",[dictHeaderFooter valueForKey:@"fax"]];
    }
    
    [str_emailFormat appendFormat:@"<tr><td colspan=4 class=""align"">%@</td></tr>",[dictHeaderFooter valueForKey:@"row1"]];
    [str_emailFormat appendFormat:@"<tr><td colspan=4 class=""align"">%@</td></tr>",[dictHeaderFooter valueForKey:@"row2"]];
    [str_emailFormat appendFormat:@"<tr><td colspan=4 class=""align"">%@</td></tr>",[dictHeaderFooter valueForKey:@"row3"]];
    [str_emailFormat appendFormat:@"<tr><td colspan=4 class=""align"">%@</td></tr>",[dictHeaderFooter valueForKey:@"row4"]];
    [str_emailFormat appendFormat:@"<tr><td colspan=4 class=""align"">%@</td></tr>",[dictHeaderFooter valueForKey:@"row5"]];
    
//    [str_emailFormat appendFormat:@"<tr style=""margin-top:60px;""><td colspan=4>%@&nbsp %@&nbsp %@&nbsp %@&nbsp %@&nbsp</td><tr>",[dictHeaderFooter valueForKey:@"row1"], [dictHeaderFooter valueForKey:@"row2"], [dictHeaderFooter valueForKey:@"row3"], [dictHeaderFooter valueForKey:@"row4"], [dictHeaderFooter valueForKey:@"row5"]];
    
//    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"INFRASEC_PASSWORD"]) {
//        [str_emailFormat appendFormat:@"<tr style=""margin-top:60px;""><td colspan=4>%@:  %@</td><tr>",[Language get:@"ManRegisterId" alter:@"!ManRegisterId"],[[NSUserDefaults standardUserDefaults]valueForKey:@"INFRASEC_PASSWORD"]];
//    }
    
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"POS_ID"]) {
        [str_emailFormat appendFormat:@"<tr style=""margin-top:60px;""><td colspan=4>%@:  %@</td><tr>",[Language get:@"ManRegisterId" alter:@"!ManRegisterId"],[[NSUserDefaults standardUserDefaults]valueForKey:@"POS_ID"]];
    }
    
    
    
    // Recipt Date
    
    [str_emailFormat  appendString:@"<tr class=""heading"">"];
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    // Convert date object into desired format
    [dateFormatter setDateFormat:@"HH:mm PM"];
    
    
    
    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"MailType"] isEqualToString:@"Tran"])
    {
        
        NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc]init];
        //            [dateFormatter1 setDateFormat:@"MMM"];
        [dateFormatter1 setDateFormat:@"dd MMMM yyyy"];
        
        NSDate *dayDate=[dateFormatter1 dateFromString:[[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:0] valueForKey:@"date"]];
        NSString *dateString;
        
        
        
        NSDate *currDate = dayDate;
        
        
        //            NSString *str_timeZone=nil;
        
        //            if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"language"]isEqualToString:@"EN"]) {
        //
        //                str_timeZone=@"GMT";
        //            }
        //            else
        //            {
        //                str_timeZone=@"CET";
        //            }
        [dateFormatter1 setDateFormat:@"MMM"];
        
        NSString *str_month = nil;
        str_month = [dateFormatter1 stringFromDate:dayDate];
        
        
        if([str_month isEqualToString:@"Jan"])
        {
            str_month=[Language get:@"Jan" alter:@"!Jan"];
        }
        else if([str_month isEqualToString:@"Feb"])
        {
            str_month=[Language get:@"Feb" alter:@"!Feb"];
        }
        else if([str_month isEqualToString:@"Mar"])
        {
            str_month=[Language get:@"Mar" alter:@"!Mar"];
        }
        else if([str_month isEqualToString:@"Apr"])
        {
            str_month=[Language get:@"Apr" alter:@"!Apr"];
        }
        else if([str_month isEqualToString:@"May"])
        {
            str_month=[Language get:@"May" alter:@"!May"];
        }
        else if([str_month isEqualToString:@"Jun"])
        {
            str_month=[Language get:@"Jun" alter:@"!Jun"];
        }
        else if([str_month isEqualToString:@"Jul"])
        {
            str_month=[Language get:@"Jul" alter:@"!Jul"];
        }
        else if([str_month isEqualToString:@"Aug"])
        {
            str_month=[Language get:@"Aug" alter:@"!Aug"];
        }
        else if([str_month isEqualToString:@"Sep"])
        {
            str_month=[Language get:@"Sep" alter:@"!Sep"];
        }
        else if([str_month isEqualToString:@"Oct"])
        {
            str_month=[Language get:@"Oct" alter:@"!Oct"];
        }
        else if([str_month isEqualToString:@"Nov"])
        {
            str_month=[Language get:@"Nov" alter:@"!Nov"];
        }
        else if([str_month isEqualToString:@"Dec"])
        {
            str_month=[Language get:@"Dec" alter:@"!Dec"];
        }
        
        [dateFormatter1 setDateFormat:@"dd"];
        
        NSString *str_day = [dateFormatter1 stringFromDate:currDate];
        
        [dateFormatter1 setDateFormat:@"yyyy"];
        
        NSString *str_year = [dateFormatter1 stringFromDate:currDate];
        
        dateString=[NSString stringWithFormat:@"%@ %@ %@",str_day,str_month,str_year];

        
        //        NSString *stringDate = [[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:0] valueForKey:@"date"];
        //
        //        // Convert to new Date Format
        //        NSDateFormatter *dateFormatter1=[[NSDateFormatter alloc] init];
        //
        //        [dateFormatter1 setDateFormat:@"yyyy-MMMM-dd"];
        //        NSDate *date  = [dateFormatter1 dateFromString:stringDate];
        //
        //        NSString *newDate = [dateFormatter1 stringFromDate:date];
        
        
        
        [str_emailFormat appendFormat:@"<td>%@:</td><td>%@</td><td>&nbsp;<td><td>%@:%@</td></tr>",[Language get:@"Date" alter:@"!Date"], dateString,[Language get:@"Time" alter:@"!Time"], [dateFormatter stringFromDate:[NSDate date]]];
        
        [str_emailFormat  appendString:[NSString stringWithFormat:@"<tr><td colspan=4><strong>%@</strong></td></tr>", [Language get:@"SALE" alter:@"SALE"]]];
        
        
        NSMutableString *str_product;
        str_product=[[NSMutableString alloc] init];
        
        for (int i=0; i <[[appDelegate.reciptArray valueForKey:@"sub"] count]; i++) {
            
            
            NSString *str_name=[NSString stringWithFormat:@"%@",[[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:i] valueForKey:@"name"]];
            NSString *string_space = @"";
            int str_legnth=[NSString stringWithFormat:@"%@",[[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:i] valueForKey:@"name"]].length;
            if (str_legnth<20) {
                
                for (int i =0 ; i<(20-str_legnth); i++) {
                    
                    string_space=[string_space stringByAppendingString:@"&nbsp;"];
                }
            }
            else
            {
                
                NSString *myString = [NSString stringWithFormat:@"%@",[[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:i] valueForKey:@"name"]];
                str_name = (myString.length > 20) ? [myString substringToIndex:20] : myString;
            }
            
            NSString *concatenateString = [str_name stringByAppendingString:string_space];
            
            
            float str=0.0;
            
            if (![[[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:i] valueForKey:@"peritemprice"] isEqual:NULL] && ![[[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:i] valueForKey:@"peritemprice"] isEqual:[NSNull null]]&&[[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:i] valueForKey:@"peritemprice"] !=nil)
                
            {
                if (![[[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:i] valueForKey:@"count"] isEqual:NULL] && ![[[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:i] valueForKey:@"count"] isEqual:[NSNull null]]&&[[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:i] valueForKey:@"count"] !=nil)
                {
                    
                    str = [[[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:i] valueForKey:@"peritemprice"] floatValue]*[[[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:i] valueForKey:@"count"] floatValue];
                    
                    
                    [str_emailFormat appendFormat:@"<tr><td>%@x</td><td>%@</td><td>&nbsp;<td><td>%@</td></tr>",[[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:i] valueForKey:@"count"],concatenateString,[NSString stringWithFormat:@"%.02f", str]];
                    
                }
            }
            
        }
        
        [str_emailFormat appendFormat:@"<tr><td co lspan=2>%@</td><td>&nbsp;<td><td style=""text-align: right;width: 110px;"">%@ %.02f</td></tr>",[Language get:@"Vat" alter:@"!Vat"],str_cur, [[appDelegate.reciptArray valueForKey:@"totalvat"] floatValue]];
        
        
        if ([[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:0] valueForKey:@"discount"] != nil) {
            
            
            if([[[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:0] valueForKey:@"type"] isEqualToString:@"$"])
            {
                
                [str_emailFormat appendFormat:@"<tr><td colspan=2>%@</td><td>&nbsp;<td><td style=""text-align: right;width: 110px;"">%@ %.02f</td></tr>", [Language get:@"Discount" alter:@"!Discount"], str_cur, [[[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:0] valueForKey:@"discount"] floatValue]];
            }
            else
            {
                
                
                [str_emailFormat appendFormat:@"<tr><td colspan=2>%@</td><td>&nbsp;<td><td style=""text-align: right;width: 110px;"">%@ %.02f</td></tr>", [Language get:@"Discount" alter:@"!Discount"], @"%", [[[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:0] valueForKey:@"discount"] floatValue]];
            }

            
        }

        
        //
        //     NSString *str_total=[NSString stringWithFormat:@"%@ %.02f\n",str_cur, [[appDelegate.reciptArray valueForKey:@"tprice"] floatValue]-[[[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:0] valueForKey:@"discount"] floatValue]];
        
        NSString *str_total=[NSString stringWithFormat:@"%@ %.02f\n",str_cur, [[appDelegate.reciptArray valueForKey:@"tprice"] floatValue]];
        
        [str_emailFormat appendFormat:@"<tr class=""total""><td colspan=2>%@</td><td>&nbsp;<td><td style=""text-align: right;width: 150px;""><strong>%@</strong></td></tr>",[Language get:@"Total" alter:@"!Total"], str_total];
        
        
        [str_emailFormat appendFormat:@"<tr><td>%@</td><td colspan=3>&nbsp;</td></tr>", [Language get:@"ChargePay" alter:@"!ChargePay"]];
        
        [str_emailFormat appendFormat:@"<tr><td>%@</td><td colspan=3>&nbsp;</td></tr>",str_total];
        
    }
    else
    {
        
        NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc]init];
        //            [dateFormatter1 setDateFormat:@"MMM"];
        [dateFormatter1 setDateFormat:@"dd MMMM yyyy"];
        
        NSDate *dayDate=[dateFormatter1 dateFromString:[appDelegate.reciptArray valueForKey:@"totaldate"]];
        NSString *dateString;
        
        
        
        NSDate *currDate = dayDate;
        
        
        //            NSString *str_timeZone=nil;
        
        //            if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"language"]isEqualToString:@"EN"]) {
        //
        //                str_timeZone=@"GMT";
        //            }
        //            else
        //            {
        //                str_timeZone=@"CET";
        //            }
        [dateFormatter1 setDateFormat:@"MMM"];
        
        NSString *str_month = nil;
        str_month = [dateFormatter1 stringFromDate:dayDate];
        
        
        if([str_month isEqualToString:@"Jan"])
        {
            str_month=[Language get:@"Jan" alter:@"!Jan"];
        }
        else if([str_month isEqualToString:@"Feb"])
        {
            str_month=[Language get:@"Feb" alter:@"!Feb"];
        }
        else if([str_month isEqualToString:@"Mar"])
        {
            str_month=[Language get:@"Mar" alter:@"!Mar"];
        }
        else if([str_month isEqualToString:@"Apr"])
        {
            str_month=[Language get:@"Apr" alter:@"!Apr"];
        }
        else if([str_month isEqualToString:@"May"])
        {
            str_month=[Language get:@"May" alter:@"!May"];
        }
        else if([str_month isEqualToString:@"Jun"])
        {
            str_month=[Language get:@"Jun" alter:@"!Jun"];
        }
        else if([str_month isEqualToString:@"Jul"])
        {
            str_month=[Language get:@"Jul" alter:@"!Jul"];
        }
        else if([str_month isEqualToString:@"Aug"])
        {
            str_month=[Language get:@"Aug" alter:@"!Aug"];
        }
        else if([str_month isEqualToString:@"Sep"])
        {
            str_month=[Language get:@"Sep" alter:@"!Sep"];
        }
        else if([str_month isEqualToString:@"Oct"])
        {
            str_month=[Language get:@"Oct" alter:@"!Oct"];
        }
        else if([str_month isEqualToString:@"Nov"])
        {
            str_month=[Language get:@"Nov" alter:@"!Nov"];
        }
        else if([str_month isEqualToString:@"Dec"])
        {
            str_month=[Language get:@"Dec" alter:@"!Dec"];
        }
        
        [dateFormatter1 setDateFormat:@"dd"];
        
        NSString *str_day = [dateFormatter1 stringFromDate:currDate];
        
        [dateFormatter1 setDateFormat:@"yyyy"];
        
        NSString *str_year = [dateFormatter1 stringFromDate:currDate];
        
        dateString=[NSString stringWithFormat:@"%@ %@ %@",str_day,str_month,str_year];
        
        
        
        [str_emailFormat appendFormat:@"<td>%@:</td><td>%@</td><td>&nbsp;<td><td>%@:%@</td></tr>",[Language get:@"Date" alter:@"!Date"], dateString,[Language get:@"Time" alter:@"!Time"], [dateFormatter stringFromDate:[NSDate date]]];
        
        [str_emailFormat  appendString:[NSString stringWithFormat:@"<tr><td colspan=4><strong>%@</strong></td></tr>", [Language get:@"SALE" alter:@"SALE"]]];
        
        
        NSMutableString *str_product;
        str_product=[[NSMutableString alloc] init];
        
        NSMutableDictionary *dictAllItem = [appDelegate.reciptArray valueForKey:@"sub"];
        
        NSMutableArray * arrayItems = [NSMutableArray new];
        
        
        for (NSString *key in dictAllItem)
        {
            [arrayItems addObject:[dictAllItem objectForKey:key]];
        }
        
        for (int i=0; i <[arrayItems count]; i++) {
            
            
            
            NSString *str_name=[NSString stringWithFormat:@"%@",[[arrayItems objectAtIndex:i] valueForKey:@"name"]];
            NSString *string_space = @"";
            int str_legnth=[NSString stringWithFormat:@"%@",[[arrayItems objectAtIndex:i] valueForKey:@"name"]].length;
            if (str_legnth<20) {
                
                for (int i =0 ; i<(20-str_legnth); i++) {
                    
                    
                    string_space=[string_space stringByAppendingString:@"&nbsp;"];
                }
            }
            else
            {
                
                NSString *myString = [NSString stringWithFormat:@"%@",[[arrayItems objectAtIndex:i] valueForKey:@"name"]];
                str_name = (myString.length > 20) ? [myString substringToIndex:20] : myString;
            }
            
            NSString *concatenateString = [str_name stringByAppendingString:string_space];
            
            
            float str=0.0;
            
            if (![[[arrayItems objectAtIndex:i] valueForKey:@"price"] isEqual:NULL] && ![[[arrayItems objectAtIndex:i] valueForKey:@"price"] isEqual:[NSNull null]]&&[[arrayItems objectAtIndex:i] valueForKey:@"price"] !=nil)
                
            {
                if (![[[arrayItems objectAtIndex:i] valueForKey:@"count"] isEqual:NULL] && ![[[arrayItems objectAtIndex:i] valueForKey:@"count"] isEqual:[NSNull null]]&&[[arrayItems objectAtIndex:i] valueForKey:@"count"] !=nil)
                {
                    
                    str = [[[arrayItems objectAtIndex:i] valueForKey:@"price"] floatValue]*[[[arrayItems objectAtIndex:i] valueForKey:@"count"] floatValue];
                    
                    
                    [str_emailFormat appendFormat:@"<tr><td>%@x</td><td>%@</td><td>&nbsp;<td><td>%@</td></tr>",[[arrayItems objectAtIndex:i] valueForKey:@"count"],concatenateString,[NSString stringWithFormat:@"%.02f", str]];
                    
                }
            }
            
        }
        
        
        //        NSManagedObjectContext *context =[appDelegate managedObjectContext];
        //
        //
        //        NSEntityDescription *entityDesc2 =[NSEntityDescription entityForName:@"CustomDiscount" inManagedObjectContext:context];
        //        NSFetchRequest *request11 = [[NSFetchRequest alloc] init];
        //        [request11 setEntity:entityDesc2];
        //        NSError *error2;
        //        NSArray *objects2 = [context executeFetchRequest:request11 error:&error2];
        //
        //        NSManagedObject *person2;
        //
        //        float sumnew=0.0;
        //
        //
        //        for(int i=0;i<objects2.count;i++)
        //        {
        //            person2 = (NSManagedObject *)[objects2 objectAtIndex:i];
        //
        //            sumnew = [[person2 valueForKey:@"discount"] floatValue]+sumnew;
        //        }
        
        
        [str_emailFormat appendFormat:@"<tr><td colspan=2>%@</td><td>&nbsp;<td><td style=""text-align: right;width: 110px;"">%@ %.02f</td></tr>",[Language get:@"Vat" alter:@"!Vat"],str_cur, [[appDelegate.reciptArray valueForKey:@"totalvat"] floatValue]];
        
        //        [str_emailFormat appendFormat:@"<tr><td colspan=2>%@</td><td>&nbsp;<td><td style=""text-align: right;width: 110px;"">%@ %.02f</td></tr>", [Language get:@"Discount" alter:@"!Discount"], str_cur, [[[arrayItems objectAtIndex:0] valueForKey:@"discount"] floatValue]];
        
        
        
        //        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        //        NSManagedObjectContext *context =[appDelegate managedObjectContext];
        //
        //
        //        NSEntityDescription *entityDesc2 =[NSEntityDescription entityForName:@"CustomDiscount" inManagedObjectContext:context];
        //        NSFetchRequest *request11 = [[NSFetchRequest alloc] init];
        //        [request11 setEntity:entityDesc2];
        //        NSError *error2;
        //        NSArray *objects2 = [context executeFetchRequest:request11 error:&error2];
        //
        //        NSManagedObject *person2;
        //
        //        float sumnew=0.0;
        //
        //        for(int i=0;i<objects2.count;i++)
        //        {
        //
        //            NSArray* ary_ID = [[appDelegate.reciptArray valueForKey:@"finalid"] componentsSeparatedByString: @","];
        //
        //
        //            if ([ary_ID count]>0)
        //            {
        //                if ([ary_ID containsObject:[NSString stringWithFormat:@"%@",[[objects2 objectAtIndex:i] valueForKey:@"id"]]])
        //                {
        //                    person2 = (NSManagedObject *)[objects2 objectAtIndex:i];
        //
        //                    sumnew = [[person2 valueForKey:@"discount"] floatValue]+sumnew;
        //
        //                }
        //            }
        //
        //        }
        
        
        
        //        [str_emailFormat appendFormat:@"<tr><td colspan=2>%@</td><td>&nbsp;<td><td style=""text-align: right;width: 110px;"">%@ %.02f</td></tr>", [Language get:@"Discount" alter:@"!Discount"], str_cur, [[[arrayItems objectAtIndex:0] valueForKey:@"discount"] floatValue]];
        
        [str_emailFormat appendFormat:@"<tr><td colspan=2>%@</td><td>&nbsp;<td><td style=""text-align: right;width: 110px;"">%@ %@</td></tr>", [Language get:@"Discount" alter:@"!Discount"], str_cur, [appDelegate.reciptArray valueForKey:@"totaldiscount"]];
        
//        NSString *str_total=[NSString stringWithFormat:@"%@ %.02f\n",str_cur, [[appDelegate.reciptArray valueForKey:@"totalSum"] floatValue]-[[appDelegate.reciptArray valueForKey:@"totaldiscount"]floatValue]];
        
         NSString *str_total=[NSString stringWithFormat:@"%@ %.02f\n",str_cur, [[appDelegate.reciptArray valueForKey:@"totalSum"] floatValue]];
        
        //          NSString *str_total=[NSString stringWithFormat:@"%@ %.02f\n",str_cur, [[appDelegate.reciptArray valueForKey:@"totalSum"] floatValue]-[[appDelegate.reciptArray valueForKey:@"totalvat"]floatValue]];
        
        [str_emailFormat appendFormat:@"<tr class=""total""><td colspan=2>%@</td><td>&nbsp;<td><td style=""text-align: right;width: 150px;""><strong>%@</strong></td></tr>",[Language get:@"Total" alter:@"!Total"], str_total];
        
        
        [str_emailFormat appendFormat:@"<tr><td>%@</td><td colspan=3>&nbsp;</td></tr>", [Language get:@"ChargePay" alter:@"!ChargePay"]];
        
        [str_emailFormat appendFormat:@"<tr><td>%@</td><td colspan=3>&nbsp;</td></tr>",str_total];
        
    }
    
    
    [str_emailFormat appendFormat:@"<tr><td colspan=4 style=""width:230px;text-align:center;"">-------------%@-------------</td></tr>", [Language get:@"Sign Here" alter:@"!Sign Here"]];
    
    //    [str_emailFormat appendFormat:@"<tr style=""margin-top:60px;""><td colspan=4>%@ %@ %@ %@ %@ %@ %@ %@ %@ %@</td><tr>",[dictHeaderFooter valueForKey:@"row1"], [dictHeaderFooter valueForKey:@"row2"], [dictHeaderFooter valueForKey:@"row3"], [dictHeaderFooter valueForKey:@"row4"], [dictHeaderFooter valueForKey:@"row5"], [dictHeaderFooter valueForKey:@"row6"], [dictHeaderFooter valueForKey:@"row7"], [dictHeaderFooter valueForKey:@"row8"], [dictHeaderFooter valueForKey:@"row9"], [dictHeaderFooter valueForKey:@"row10"]];
    
    [str_emailFormat appendFormat:@"<tr><td colspan=4 class=""align"">%@</td></tr>",[dictHeaderFooter valueForKey:@"row6"]];
    [str_emailFormat appendFormat:@"<tr><td colspan=4 class=""align"">%@</td></tr>",[dictHeaderFooter valueForKey:@"row7"]];
    [str_emailFormat appendFormat:@"<tr><td colspan=4 class=""align"">%@</td></tr>",[dictHeaderFooter valueForKey:@"row8"]];
    [str_emailFormat appendFormat:@"<tr><td colspan=4 class=""align"">%@</td></tr>",[dictHeaderFooter valueForKey:@"row9"]];
    [str_emailFormat appendFormat:@"<tr><td colspan=4 class=""align"">%@</td></tr>",[dictHeaderFooter valueForKey:@"row10"]];
    
//    [str_emailFormat appendFormat:@"<tr style=""margin-top:60px;""><td colspan=4>%@&nbsp %@&nbsp %@&nbsp %@&nbsp %@&nbsp</td><tr>", [dictHeaderFooter valueForKey:@"row6"], [dictHeaderFooter valueForKey:@"row7"], [dictHeaderFooter valueForKey:@"row8"], [dictHeaderFooter valueForKey:@"row9"], [dictHeaderFooter valueForKey:@"row10"]];
//    
    [str_emailFormat appendFormat:@"<tr class=""buying""><td colspan=4>%@</td></tr></table></div></div></body></html>", [Language get:@"Thank you for buying!" alter:@"!Thank you for buying!"]];
    
    
}


- (void)sendForgetMailWithSubject:(NSString *)subject sendFrom:(NSString *)senderEmailID ToReciepents:(NSString *)reciepents messageHtmlBodyContent:(NSString *)messageHtmlBody {
    _email = [[SendGridEmail alloc] init];
    
    
    NSMutableArray *receipentsList;
    
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"EMAIL"]) {
        
        receipentsList = [[NSMutableArray alloc] initWithArray:@[[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"EMAIL"]]]];
    }
    else
    {
        receipentsList = [[NSMutableArray alloc] initWithArray:@[@"rajeevlochan@impingeonline.com", @"mandeepsharma@impingeonline.com"]];
    }
    
    
    NSString *password =[self randomStringWithLength:6];
    
    [self resetPassword:password];
    
    [_email setTos:receipentsList];
//    [_email addBcc:@"davinder@impingesolutions.com"];
    _email.from = @"info@isupos.com";
    _email.subject = subject;
    _email.text = [NSString stringWithFormat:@"Please find below new password for login \n %@ ",password];
    
//    _email.html=str_emailFormat;
    
    [self.sendGridClient sendWithWeb:_email];
    
}


NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

-(NSString *) randomStringWithLength: (int) len {
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform([letters length])]];
    }

    return randomString;
}



-(void)resetPassword:(NSString *)newpassword
{
    
        NSManagedObjectContext *context =[appDelegate managedObjectContext];
        NSError *error;
        NSEntityDescription *entityDescc =[NSEntityDescription entityForName:@"User" inManagedObjectContext:context];
        NSFetchRequest *requestt = [[NSFetchRequest alloc] init];
        [requestt setEntity:entityDescc];
        
        NSArray *objectss = [context executeFetchRequest:requestt error:&error];
        if ([objectss count] == 0) {
            
        }
        else
        {
            NSManagedObject *obj=(NSManagedObject *)[objectss objectAtIndex:0];
            [obj setValue:newpassword forKey:@"password"];
            [obj setValue:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"EMAIL"]] forKey:@"email"];
         
            [context save:&error];
        }
    
}

- (void)sendReceiptMailWithSubject:(NSString *)subject sendFrom:(NSString *)senderEmailID ToReciepents:(NSString *)reciepents messageHtmlBodyContent:(NSString *)messageHtmlBody
{
    
     _email = [[SendGridEmail alloc] init];
    
    if([appDelegate.reciptArrayReceipt count]>0)
    {
        [self createMailFormatReceipt];
        NSLog(@"Receipt HTML format - - - - ->\n%@", str_emailFormat);
        
        NSMutableArray *receipentsList;
        
        if ([[NSUserDefaults standardUserDefaults]valueForKey:@"EMAIL"]) {
            
            receipentsList = [[NSMutableArray alloc] initWithArray:@[[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"EMAIL"]]]];
        }
        else
        {
            receipentsList = [[NSMutableArray alloc] initWithArray:@[@"richag@impingeonline.com", @"mandeepsharma@impingeonline.com",@"parveen@impingeonline.com"]];
        }
        
        [_email setTos:receipentsList];
        _email.from = @"info@isupos.com";
        _email.subject =[NSString stringWithFormat:@"%@",[Language get:@"Receipt" alter:@"!Receipt"]];
        [_email addBcc:@"davi@impingesolutions.com"];
        _email.html=str_emailFormat;
        
        [self.sendGridClient sendWithWeb:_email];
    }
    else
    {
        
    }
}

- (void)sendEmailListAttachmentMail:(NSData *)txtFileData
{
    
    _email = [[SendGridEmail alloc] init];
    
    NSLog(@"Receipt HTML format - - - - ->\n%@", str_emailFormat);
    
    NSMutableArray *receipentsList;
    
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"EMAIL"]) {
        
        receipentsList = [[NSMutableArray alloc] initWithArray:@[[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"EMAIL"]]]];
    }
    else
    {
        receipentsList = [[NSMutableArray alloc] initWithArray:@[@"meghas@impingeonline.com"]];
    }
    
    [_email setTos:receipentsList];
    _email.from = @"info@isupos.com";
    _email.subject =[NSString stringWithFormat:@"%@",[Language get:@"Emails" alter:@"!Emails"]];
  //  [_email addBcc:@"davi@impingesolutions.com"];
    
    str_emailFormat=[[NSMutableString alloc] init];
    [str_emailFormat  appendString:@"<html><head><title>Email List</title><style>tr{float:left;clear:both;padding:2px 0;width:230px;}.heading{border-bottom: 1px dashed #000;float: left;padding: 10px 0;}.total{border-top:1px dashed #000;border-bottom:1px dashed #000;padding: 5px 0;}.buying{border-top:1px dashed #000;}.align{text-align:center;width:230px;}</style></head><body>Please find attachment"];
    [str_emailFormat appendFormat:@"<tr><td colspan=4 class=""align""></td></tr>"];
    [str_emailFormat appendFormat:@"</body></html>"];
    
//_email.html = @"<html><body>Please find attachment</body></html>";
    _email.html=str_emailFormat;
    
    SendGridEmailAttachment* someImageAttachment = [[SendGridEmailAttachment alloc] init];
    someImageAttachment.attachmentData = txtFileData;
    someImageAttachment.mimeType = @"text/plain";
    someImageAttachment.fileName = @"Email";
    someImageAttachment.extension = @"txt";
    
    [_email attachFile:someImageAttachment];
    
    [self.sendGridClient sendAttachmentWithWeb:_email];
   // [self.sendGridClient sendWithWeb:_email];
}

#pragma mark - Receipt Format on receipts and park receipt viewController.
//- (void)createMailFormatReceipt{
//    
//    appDelegate = [[UIApplication sharedApplication] delegate];
//    NSManagedObjectContext *context1 =[appDelegate managedObjectContext];
//    NSError *error1;
//    NSEntityDescription *entityDescc =[NSEntityDescription entityForName:@"VatandCurrency" inManagedObjectContext:context1];
//    NSFetchRequest *requestt = [[NSFetchRequest alloc] init];
//    [requestt setEntity:entityDescc];
//    NSManagedObject *matches = nil;
//    NSArray *objectss = [context1 executeFetchRequest:requestt error:&error1];
//    if ([objectss count] == 0) {
//        NSManagedObject *newContact;
//        newContact = [NSEntityDescription insertNewObjectForEntityForName:@"VatandCurrency" inManagedObjectContext:context1];
//        [newContact setValue:@"$" forKey:@"currency"];
//        currencySign=@"$";
//        [context1 save:&error1];
//        
//    } else {
//        
//        matches=(NSManagedObject*)[objectss objectAtIndex:0];
//        currencySign=[matches valueForKey:@"currency"];
//    }
//    
//    NSString *str_cur;
//    
//    if ([currencySign isEqualToString:@"$"]) {
//        
//        str_cur=@"&#36;";
//        
//    }else if ([currencySign isEqualToString:@"€"]) {
//        
//        str_cur=@"&#128;";
//        
//    } else if ([currencySign isEqualToString:@"SEK"]) {
//        
//        str_cur=@"SEK";
//    }
//    else
//    {
//        str_cur=@"&#36;";
//    }
//    
//    NSManagedObjectContext *context =[appDelegate managedObjectContext];
//    NSEntityDescription *entityDesc =[NSEntityDescription entityForName:@"ReceiptData" inManagedObjectContext:context];
//    NSFetchRequest *request = [[NSFetchRequest alloc] init];
//    [request setEntity:entityDesc];
//    NSPredicate *pred =[NSPredicate predicateWithFormat:@"(id = %@)",@"1"];
//    [request setPredicate:pred];
//    NSError *error;
//    NSArray *objects = [context executeFetchRequest:request error:&error];
//    //    NSManagedObject *person = (NSManagedObject *)[objects objectAtIndex:0];
//    
//    NSMutableDictionary *dictHeaderFooter = [NSMutableDictionary new];
//    
//    if (objects.count == 0)
//    {
//        [dictHeaderFooter setValue:@"" forKey:@"organization_name"];
//        [dictHeaderFooter setValue:@"" forKey:@"company_name"];
//        [dictHeaderFooter setValue:@"" forKey:@"address1"];
//        [dictHeaderFooter setValue:@"" forKey:@"address2"];
//        [dictHeaderFooter setValue:@"" forKey:@"zipcode"];
//        [dictHeaderFooter setValue:@"" forKey:@"city"];
//        [dictHeaderFooter setValue:@"" forKey:@"phone"];
//        [dictHeaderFooter setValue:@"" forKey:@"fax"];
//        [dictHeaderFooter setValue:@"" forKey:@"homepage"];
//        
//        [dictHeaderFooter setValue:@"" forKey:@"row1"];
//        [dictHeaderFooter setValue:@"" forKey:@"row2"];
//        [dictHeaderFooter setValue:@"" forKey:@"row3"];
//        [dictHeaderFooter setValue:@"" forKey:@"row4"];
//        [dictHeaderFooter setValue:@"" forKey:@"row5"];
//        [dictHeaderFooter setValue:@"" forKey:@"row6"];
//        [dictHeaderFooter setValue:@"" forKey:@"row7"];
//        [dictHeaderFooter setValue:@"" forKey:@"row8"];
//        [dictHeaderFooter setValue:@"" forKey:@"row9"];
//        [dictHeaderFooter setValue:@"" forKey:@"row10"];
//    }
//    else
//    {
//        for(int i=0;i<objects.count;i++)
//        {
//            NSManagedObject *person = (NSManagedObject *)[objects objectAtIndex:i];
//            
//            [dictHeaderFooter setValue:[person valueForKey:@"organization_name"] forKey:@"organization_name"];
//            [dictHeaderFooter setValue:[person valueForKey:@"company_name"] forKey:@"company_name"];
//            [dictHeaderFooter setValue:[person valueForKey:@"address1"] forKey:@"address1"];
//            [dictHeaderFooter setValue:[person valueForKey:@"address2"] forKey:@"address2"];
//            [dictHeaderFooter setValue:[person valueForKey:@"zipcode"] forKey:@"zipcode"];
//            [dictHeaderFooter setValue:[person valueForKey:@"city"] forKey:@"city"];
//            [dictHeaderFooter setValue:[person valueForKey:@"phone"] forKey:@"phone"];
//            [dictHeaderFooter setValue:[person valueForKey:@"fax"] forKey:@"fax"];
//            [dictHeaderFooter setValue:[person valueForKey:@"homepage"] forKey:@"homepage"];
//            
//            [dictHeaderFooter setValue:[person valueForKey:@"row1"] forKey:@"row1"];
//            [dictHeaderFooter setValue:[person valueForKey:@"row2"] forKey:@"row2"];
//            [dictHeaderFooter setValue:[person valueForKey:@"row3"] forKey:@"row3"];
//            [dictHeaderFooter setValue:[person valueForKey:@"row4"] forKey:@"row4"];
//            [dictHeaderFooter setValue:[person valueForKey:@"row5"] forKey:@"row5"];
//            [dictHeaderFooter setValue:[person valueForKey:@"row6"] forKey:@"row6"];
//            [dictHeaderFooter setValue:[person valueForKey:@"row7"] forKey:@"row7"];
//            [dictHeaderFooter setValue:[person valueForKey:@"row8"] forKey:@"row8"];
//            [dictHeaderFooter setValue:[person valueForKey:@"row9"] forKey:@"row9"];
//            [dictHeaderFooter setValue:[person valueForKey:@"row10"] forKey:@"row10"];
//        }
//    }
//    
//    str_emailFormat=[[NSMutableString alloc] init];
//    
//    //Recipet format
//    
//    [str_emailFormat  appendString:@"<html><head><title>Payment Receipt</title><style>tr{float:left;clear:both;padding:2px 0;width:230px;}.heading{border-bottom: 1px dashed #000;float: left;padding: 10px 0;}.total{border-top:1px dashed #000;border-bottom:1px dashed #000;padding: 5px 0;}.buying{border-top:1px dashed #000;}.align{text-align:center;width:230px;}</style></head><body><div class=""wrapper""><div class=""sale"">"];
//    

//    
//    if ([@"Original" isEqualToString:[[NSUserDefaults standardUserDefaults]valueForKey:@"ReciptType"]]) {
//        
//        [str_emailFormat  appendString:[NSString stringWithFormat:@"<tr><td colspan=4><strong>%@</strong></td></tr>", [Language get:@"Original" alter:@"!Original"]]];
//        
//    }
//    else
//    {
//        [str_emailFormat  appendString:[NSString stringWithFormat:@"<tr><td colspan=4><strong>%@</strong></td></tr>", [Language get:@"Copy" alter:@"!Copy"]]];
//    }
//    
//    
//    // Recipt Company details
//    
//    [str_emailFormat  appendString:@"<table>"];
//    
//    if ([dictHeaderFooter valueForKey:@"organization_name"]) {
//        
//        [str_emailFormat appendFormat:@"<tr><td colspan=4 class=""align"">%@</td></tr>",[dictHeaderFooter valueForKey:@"organization_name"]];
//    }
//    
//    if ([dictHeaderFooter valueForKey:@"company_name"]) {
//        
//        [str_emailFormat appendFormat:@"<tr><td colspan=4 class=""align"">%@</td></tr>",[dictHeaderFooter valueForKey:@"company_name"]];
//    }
//    
//    if ([dictHeaderFooter valueForKey:@"address1"]) {
//        
//        [str_emailFormat appendFormat:@"<tr><td colspan=4 class=""align"">%@</td></tr>",[dictHeaderFooter valueForKey:@"address1"]];
//    }
//    if ([dictHeaderFooter valueForKey:@"address2"]) {
//        
//        [str_emailFormat appendFormat:@"<tr><td colspan=4 class=""align"">%@</td></tr>",[dictHeaderFooter valueForKey:@"address2"]];
//    }
//    
//    if ([dictHeaderFooter valueForKey:@"city"]) {
//        
//        [str_emailFormat appendFormat:@"<tr><td colspan=4 class=""align"">%@ %@</td></tr>",[dictHeaderFooter valueForKey:@"city"],[dictHeaderFooter valueForKey:@"zipcode"]];
//    }
//    
//    
//    if ([dictHeaderFooter valueForKey:@"phone"]) {
//        
//        [str_emailFormat appendFormat:@"<tr><td colspan=4 class=""align"">%@</td></tr>",[dictHeaderFooter valueForKey:@"phone"]];
//    }
//    
//    if ([dictHeaderFooter valueForKey:@"fax"]) {
//        
//        [str_emailFormat appendFormat:@"<tr><td colspan=4 class=""align"">%@</td></tr>",[dictHeaderFooter valueForKey:@"fax"]];
//    }
//    
//    
//    [str_emailFormat appendFormat:@"<tr><td colspan=4 class=""align"">%@</td></tr>",[dictHeaderFooter valueForKey:@"row1"]];
//    [str_emailFormat appendFormat:@"<tr><td colspan=4 class=""align"">%@</td></tr>",[dictHeaderFooter valueForKey:@"row2"]];
//    [str_emailFormat appendFormat:@"<tr><td colspan=4 class=""align"">%@</td></tr>",[dictHeaderFooter valueForKey:@"row3"]];
//    [str_emailFormat appendFormat:@"<tr><td colspan=4 class=""align"">%@</td></tr>",[dictHeaderFooter valueForKey:@"row4"]];
//    [str_emailFormat appendFormat:@"<tr><td colspan=4 class=""align"">%@</td></tr>",[dictHeaderFooter valueForKey:@"row5"]];
//    
//    //    [str_emailFormat appendFormat:@"<tr style=""margin-top:60px;""><td colspan=4>%@&nbsp %@&nbsp %@&nbsp %@&nbsp %@&nbsp</td><tr>",[dictHeaderFooter valueForKey:@"row1"], [dictHeaderFooter valueForKey:@"row2"], [dictHeaderFooter valueForKey:@"row3"], [dictHeaderFooter valueForKey:@"row4"], [dictHeaderFooter valueForKey:@"row5"]];
//    
//    // Recipt Date
//    
//    [str_emailFormat  appendString:@"<tr class=""heading"">"];
//    
//    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
//    // Convert date object into desired format
//    [dateFormatter setDateFormat:@"HH:mm PM"];
//    
//    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc]init];
//    //            [dateFormatter1 setDateFormat:@"MMM"];
//    [dateFormatter1 setDateFormat:@"dd MMMM yyyy"];
//    
//    NSDate *dayDate=[NSDate date];
//    NSString *dateString;
//    
//    
//    
//    NSDate *currDate = dayDate;
//    
//    
//    //            NSString *str_timeZone=nil;
//    
//    //            if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"language"]isEqualToString:@"EN"]) {
//    //
//    //                str_timeZone=@"GMT";
//    //            }
//    //            else
//    //            {
//    //                str_timeZone=@"CET";
//    //            }
//    [dateFormatter1 setDateFormat:@"MMM"];
//    
//    NSString *str_month = nil;
//    str_month = [dateFormatter1 stringFromDate:dayDate];
//    
//    
//    if([str_month isEqualToString:@"Jan"])
//    {
//        str_month=[Language get:@"Jan" alter:@"!Jan"];
//    }
//    else if([str_month isEqualToString:@"Feb"])
//    {
//        str_month=[Language get:@"Feb" alter:@"!Feb"];
//    }
//    else if([str_month isEqualToString:@"Mar"])
//    {
//        str_month=[Language get:@"Mar" alter:@"!Mar"];
//    }
//    else if([str_month isEqualToString:@"Apr"])
//    {
//        str_month=[Language get:@"Apr" alter:@"!Apr"];
//    }
//    else if([str_month isEqualToString:@"May"])
//    {
//        str_month=[Language get:@"May" alter:@"!May"];
//    }
//    else if([str_month isEqualToString:@"Jun"])
//    {
//        str_month=[Language get:@"Jun" alter:@"!Jun"];
//    }
//    else if([str_month isEqualToString:@"Jul"])
//    {
//        str_month=[Language get:@"Jul" alter:@"!Jul"];
//    }
//    else if([str_month isEqualToString:@"Aug"])
//    {
//        str_month=[Language get:@"Aug" alter:@"!Aug"];
//    }
//    else if([str_month isEqualToString:@"Sep"])
//    {
//        str_month=[Language get:@"Sep" alter:@"!Sep"];
//    }
//    else if([str_month isEqualToString:@"Oct"])
//    {
//        str_month=[Language get:@"Oct" alter:@"!Oct"];
//    }
//    else if([str_month isEqualToString:@"Nov"])
//    {
//        str_month=[Language get:@"Nov" alter:@"!Nov"];
//    }
//    else if([str_month isEqualToString:@"Dec"])
//    {
//        str_month=[Language get:@"Dec" alter:@"!Dec"];
//    }
//    
//    [dateFormatter1 setDateFormat:@"dd"];
//    
//    NSString *str_day = [dateFormatter1 stringFromDate:currDate];
//    
//    [dateFormatter1 setDateFormat:@"yyyy"];
//    
//    NSString *str_year = [dateFormatter1 stringFromDate:currDate];
//    
//    dateString=[NSString stringWithFormat:@"%@ %@ %@",str_day,str_month,str_year];
//    
//    
//    
//    
//    [str_emailFormat appendFormat:@"<td>%@:</td><td>%@</td><td>&nbsp;<td><td>%@:%@</td></tr>",[Language get:@"Date" alter:@"!Date"], [dateFormatter1 stringFromDate:[NSDate date]],[Language get:@"Time" alter:@"!Time"], [dateFormatter stringFromDate:[NSDate date]]];
//    //     [[[appDelegate.reciptArrayReceipt valueForKey:@"sub"] objectAtIndex:0] valueForKey:@"date"]
//    
//    [str_emailFormat  appendString:[NSString stringWithFormat:@"<tr><td colspan=4><strong>%@</strong></td></tr>", [Language get:@"SALE" alter:@"!SALE"]]];
//    
//    
//    NSMutableString *str_product;
//    str_product=[[NSMutableString alloc] init];
//    
//    for (int i=0; i <[appDelegate.reciptArrayReceipt count]; i++) {
//        
//        
//        NSString *str_name=[NSString stringWithFormat:@"%@",[[appDelegate.reciptArrayReceipt objectAtIndex:i] valueForKey:@"name"]];
//        NSString *string_space = @"";
//        int str_legnth=[NSString stringWithFormat:@"%@",[[appDelegate.reciptArrayReceipt objectAtIndex:i] valueForKey:@"name"]].length;
//        if (str_legnth<20) {
//            
//            for (int i =0 ; i<(20-str_legnth); i++) {
//                
//                string_space=[string_space stringByAppendingString:@"&nbsp;"];
//            }
//        }
//        else
//        {
//            NSString *myString = [NSString stringWithFormat:@"%@",[[appDelegate.reciptArrayReceipt objectAtIndex:i] valueForKey:@"name"]];
//            str_name = (myString.length > 20) ? [myString substringToIndex:20] : myString;
//        }
//        
//        NSString *concatenateString = [str_name stringByAppendingString:string_space];
//        
//        
//        
//        float str = [[NSString stringWithFormat:@"%@",[[appDelegate.reciptArrayReceipt objectAtIndex:i] valueForKey:@"price"] ] floatValue]*[[NSString stringWithFormat:@"%@",[[appDelegate.reciptArrayReceipt objectAtIndex:i] valueForKey:@"count"] ] floatValue];
//        
//        
//        
//        [str_emailFormat appendFormat:@"<tr><td>%@x</td><td>%@</td><td>&nbsp;<td><td>%@</td></tr>",[NSString stringWithFormat:@"%@",[[appDelegate.reciptArrayReceipt objectAtIndex:i] valueForKey:@"count"] ],concatenateString,[NSString stringWithFormat:@"%.02f",str]];
//        
//    }
//    
//    [str_emailFormat appendFormat:@"<tr><td colspan=2>%@</td><td>&nbsp;<td><td style=""text-align: right;width: 110px;"">%@ %.02f</td></tr>",[Language get:@"Vat" alter:@"!Vat"], str_cur, [[[NSUserDefaults standardUserDefaults]valueForKey:@"reciptVat"] floatValue]];
//    
//    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"reciptDis"] != nil) {
//        
//        
//        if ([[NSUserDefaults standardUserDefaults]valueForKey:@"reciptDis"])
//            [str_emailFormat appendFormat:@"<tr><td colspan=2>%@</td><td>&nbsp;<td><td style=""text-align: right;width: 110px;"">%@ %.02f</td></tr>",[Language get:@"Discount" alter:@"!Discount"], str_cur,[[[NSUserDefaults standardUserDefaults]valueForKey:@"reciptDis"] floatValue]];
//        
//    }
//    
//    //    NSString *str_total=[NSString stringWithFormat:@"$%.02f\n",TotalValue-[[NSString stringWithFormat:@"%@",[[appDelegate.reciptArrayReceipt objectAtIndex:0] valueForKey:@"discount"] ] floatValue]];
//    
//    [str_emailFormat appendFormat:@"<tr class=""total""><td colspan=2>%@</td><td>&nbsp;<td><td style=""text-align: right;width: 150px;""><strong>%0.2f</strong></td></tr>",[Language get:@"Total" alter:@"!Total"], [[[NSUserDefaults standardUserDefaults]valueForKey:@"reciptTotal"] floatValue]];
//    
//    
//    [str_emailFormat appendFormat:@"<tr><td>%@</td><td colspan=3>&nbsp;</td></tr>", [Language get:@"ChargePay" alter:@"!ChargePay"]];
//    
//    [str_emailFormat appendFormat:@"<tr><td>%0.2f</td><td colspan=3>&nbsp;</td></tr>",[[[NSUserDefaults standardUserDefaults]valueForKey:@"reciptTotal"] floatValue]];
//    
//    
//    [str_emailFormat appendFormat:@"<tr><td colspan=4 class=""align"">%@</td></tr>",[dictHeaderFooter valueForKey:@"row6"]];
//    [str_emailFormat appendFormat:@"<tr><td colspan=4 class=""align"">%@</td></tr>",[dictHeaderFooter valueForKey:@"row7"]];
//    [str_emailFormat appendFormat:@"<tr><td colspan=4 class=""align"">%@</td></tr>",[dictHeaderFooter valueForKey:@"row8"]];
//    [str_emailFormat appendFormat:@"<tr><td colspan=4 class=""align"">%@</td></tr>",[dictHeaderFooter valueForKey:@"row9"]];
//    [str_emailFormat appendFormat:@"<tr><td colspan=4 class=""align"">%@</td></tr>",[dictHeaderFooter valueForKey:@"row10"]];
//    
//    [str_emailFormat appendFormat:@"<tr><td colspan=4 style=""width:230px;text-align:center;"">-------------%@-------------</td></tr>", [Language get:@"Sign Here" alter:@"!Sign Here"]];
//    
//    //    [str_emailFormat appendFormat:@"<tr style=""margin-top:60px;""><td colspan=4>%@ %@ %@ %@ %@ %@ %@ %@ %@ %@</td><tr>",[dictHeaderFooter valueForKey:@"row1"], [dictHeaderFooter valueForKey:@"row2"], [dictHeaderFooter valueForKey:@"row3"], [dictHeaderFooter valueForKey:@"row4"], [dictHeaderFooter valueForKey:@"row5"], [dictHeaderFooter valueForKey:@"row6"], [dictHeaderFooter valueForKey:@"row7"], [dictHeaderFooter valueForKey:@"row8"], [dictHeaderFooter valueForKey:@"row9"], [dictHeaderFooter valueForKey:@"row10"]];
//    
//    
//    
//    [str_emailFormat appendFormat:@"<tr style=""margin-top:60px;""><td colspan=4>%@&nbsp %@&nbsp %@&nbsp %@&nbsp %@&nbsp</td><tr>", [dictHeaderFooter valueForKey:@"row6"], [dictHeaderFooter valueForKey:@"row7"], [dictHeaderFooter valueForKey:@"row8"], [dictHeaderFooter valueForKey:@"row9"], [dictHeaderFooter valueForKey:@"row10"]];
//    
//    
//    [str_emailFormat appendFormat:@"<tr class=""buying""><td colspan=4>%@</td></tr></table></div></div></body></html>", [Language get:@"Thank you for buying!" alter:@"!Thank you for buying!"]];
//    
//    
//    //    reciptTotal
//    //    reciptVat
//    //    reciptDis
//    
//}

- (void)createMailFormatReceipt
{
    
    appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context1 =[appDelegate managedObjectContext];
    NSError *error1;
    NSEntityDescription *entityDescc =[NSEntityDescription entityForName:@"VatandCurrency" inManagedObjectContext:context1];
    NSFetchRequest *requestt = [[NSFetchRequest alloc] init];
    [requestt setEntity:entityDescc];
    NSManagedObject *matches = nil;
    NSArray *objectss = [context1 executeFetchRequest:requestt error:&error1];
    if ([objectss count] == 0) {
        NSManagedObject *newContact;
        newContact = [NSEntityDescription insertNewObjectForEntityForName:@"VatandCurrency" inManagedObjectContext:context1];
        [newContact setValue:@"$" forKey:@"currency"];
        currencySign=@"$";
        [context1 save:&error1];
        
    } else {
        
        matches=(NSManagedObject*)[objectss objectAtIndex:0];
        currencySign=[matches valueForKey:@"currency"];
    }
  
    NSString *str_cur;
    
    if ([currencySign isEqualToString:@"$"]) {
        
        str_cur=@"&#36;";
        
    }else if ([currencySign isEqualToString:@"€"]) {
        
        str_cur=@"&#128;";
        
    } else if ([currencySign isEqualToString:@"SEK"]) {
        
        str_cur=@"SEK";
    }
    else
    {
        str_cur=@"&#36;";
    }

    NSManagedObjectContext *context =[appDelegate managedObjectContext];
    NSEntityDescription *entityDesc =[NSEntityDescription entityForName:@"ReceiptData" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    NSPredicate *pred =[NSPredicate predicateWithFormat:@"(id = %@)",@"1"];
    [request setPredicate:pred];
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    //    NSManagedObject *person = (NSManagedObject *)[objects objectAtIndex:0];
    
    NSMutableDictionary *dictHeaderFooter = [NSMutableDictionary new];
    
    if (objects.count == 0)
    {
        [dictHeaderFooter setValue:@"" forKey:@"organization_name"];
        [dictHeaderFooter setValue:@"" forKey:@"company_name"];
        [dictHeaderFooter setValue:@"" forKey:@"address1"];
        [dictHeaderFooter setValue:@"" forKey:@"address2"];
        [dictHeaderFooter setValue:@"" forKey:@"zipcode"];
        [dictHeaderFooter setValue:@"" forKey:@"city"];
        [dictHeaderFooter setValue:@"" forKey:@"phone"];
        [dictHeaderFooter setValue:@"" forKey:@"fax"];
        [dictHeaderFooter setValue:@"" forKey:@"homepage"];
        
        [dictHeaderFooter setValue:@"" forKey:@"row1"];
        [dictHeaderFooter setValue:@"" forKey:@"row2"];
        [dictHeaderFooter setValue:@"" forKey:@"row3"];
        [dictHeaderFooter setValue:@"" forKey:@"row4"];
        [dictHeaderFooter setValue:@"" forKey:@"row5"];
        [dictHeaderFooter setValue:@"" forKey:@"row6"];
        [dictHeaderFooter setValue:@"" forKey:@"row7"];
        [dictHeaderFooter setValue:@"" forKey:@"row8"];
        [dictHeaderFooter setValue:@"" forKey:@"row9"];
        [dictHeaderFooter setValue:@"" forKey:@"row10"];
    }
    else
    {
        for(int i=0;i<objects.count;i++)
        {
            NSManagedObject *person = (NSManagedObject *)[objects objectAtIndex:i];
            
            [dictHeaderFooter setValue:[person valueForKey:@"organization_name"] forKey:@"organization_name"];
            [dictHeaderFooter setValue:[person valueForKey:@"company_name"] forKey:@"company_name"];
            [dictHeaderFooter setValue:[person valueForKey:@"address1"] forKey:@"address1"];
            [dictHeaderFooter setValue:[person valueForKey:@"address2"] forKey:@"address2"];
            [dictHeaderFooter setValue:[person valueForKey:@"zipcode"] forKey:@"zipcode"];
            [dictHeaderFooter setValue:[person valueForKey:@"city"] forKey:@"city"];
            [dictHeaderFooter setValue:[person valueForKey:@"phone"] forKey:@"phone"];
            [dictHeaderFooter setValue:[person valueForKey:@"fax"] forKey:@"fax"];
            [dictHeaderFooter setValue:[person valueForKey:@"homepage"] forKey:@"homepage"];
            
            [dictHeaderFooter setValue:[person valueForKey:@"row1"] forKey:@"row1"];
            [dictHeaderFooter setValue:[person valueForKey:@"row2"] forKey:@"row2"];
            [dictHeaderFooter setValue:[person valueForKey:@"row3"] forKey:@"row3"];
            [dictHeaderFooter setValue:[person valueForKey:@"row4"] forKey:@"row4"];
            [dictHeaderFooter setValue:[person valueForKey:@"row5"] forKey:@"row5"];
            [dictHeaderFooter setValue:[person valueForKey:@"row6"] forKey:@"row6"];
            [dictHeaderFooter setValue:[person valueForKey:@"row7"] forKey:@"row7"];
            [dictHeaderFooter setValue:[person valueForKey:@"row8"] forKey:@"row8"];
            [dictHeaderFooter setValue:[person valueForKey:@"row9"] forKey:@"row9"];
            [dictHeaderFooter setValue:[person valueForKey:@"row10"] forKey:@"row10"];
        }
    }
    
    str_emailFormat=[[NSMutableString alloc] init];
    
    //Recipet format
    
   [str_emailFormat  appendString:@"<html><head><title>Payment Receipt</title><style>tr{float:left;clear:both;padding:2px 0;width:230px;}.heading{border-bottom: 1px dashed #000;float: left;padding: 10px 0;}.total{border-top:1px dashed #000;border-bottom:1px dashed #000;padding: 5px 0;}.buying{border-top:1px dashed #000;}.align{text-align:center;width:230px;}</style></head><body><div class=""wrapper""><div class=""sale"">"];
    

    
    
    if ([@"Original" isEqualToString:[[NSUserDefaults standardUserDefaults]valueForKey:@"ReciptType"]]) {
        
        [str_emailFormat  appendString:[NSString stringWithFormat:@"<tr><td colspan=4><strong>%@</strong></td></tr>", [Language get:@"Original" alter:@"!Original"]]];
        
    }
    else
    {
        [str_emailFormat  appendString:[NSString stringWithFormat:@"<tr><td colspan=4><strong>%@</strong></td></tr>", [Language get:@"Copy" alter:@"!Copy"]]];
    }
    
    
    // Recipt Company details
    
    [str_emailFormat  appendString:@"<table>"];
    
    if ([dictHeaderFooter valueForKey:@"organization_name"]) {
        
        [str_emailFormat appendFormat:@"<tr><td colspan=4 class=""align"">%@</td></tr>",[dictHeaderFooter valueForKey:@"organization_name"]];
    }
    
    if ([dictHeaderFooter valueForKey:@"company_name"]) {
        
        [str_emailFormat appendFormat:@"<tr><td colspan=4 class=""align"">%@</td></tr>",[dictHeaderFooter valueForKey:@"company_name"]];
    }
    
    if ([dictHeaderFooter valueForKey:@"address1"]) {
        
        [str_emailFormat appendFormat:@"<tr><td colspan=4 class=""align"">%@</td></tr>",[dictHeaderFooter valueForKey:@"address1"]];
    }
    if ([dictHeaderFooter valueForKey:@"address2"]) {
        
        [str_emailFormat appendFormat:@"<tr><td colspan=4 class=""align"">%@</td></tr>",[dictHeaderFooter valueForKey:@"address2"]];
    }
    
    if ([dictHeaderFooter valueForKey:@"city"]) {
        
        [str_emailFormat appendFormat:@"<tr><td colspan=4 class=""align"">%@ %@</td></tr>",[dictHeaderFooter valueForKey:@"city"],[dictHeaderFooter valueForKey:@"zipcode"]];
    }
    
    
    if ([dictHeaderFooter valueForKey:@"phone"]) {
        
        [str_emailFormat appendFormat:@"<tr><td colspan=4 class=""align"">%@</td></tr>",[dictHeaderFooter valueForKey:@"phone"]];
    }
    
    if ([dictHeaderFooter valueForKey:@"fax"]) {
        
        [str_emailFormat appendFormat:@"<tr><td colspan=4 class=""align"">%@</td></tr>",[dictHeaderFooter valueForKey:@"fax"]];
    }
    
    
    [str_emailFormat appendFormat:@"<tr><td colspan=4 class=""align"">%@</td></tr>",[dictHeaderFooter valueForKey:@"row1"]];
    [str_emailFormat appendFormat:@"<tr><td colspan=4 class=""align"">%@</td></tr>",[dictHeaderFooter valueForKey:@"row2"]];
    [str_emailFormat appendFormat:@"<tr><td colspan=4 class=""align"">%@</td></tr>",[dictHeaderFooter valueForKey:@"row3"]];
    [str_emailFormat appendFormat:@"<tr><td colspan=4 class=""align"">%@</td></tr>",[dictHeaderFooter valueForKey:@"row4"]];
    [str_emailFormat appendFormat:@"<tr><td colspan=4 class=""align"">%@</td></tr>",[dictHeaderFooter valueForKey:@"row5"]];
    
//    [str_emailFormat appendFormat:@"<tr style=""margin-top:60px;""><td colspan=4>%@&nbsp %@&nbsp %@&nbsp %@&nbsp %@&nbsp</td><tr>",[dictHeaderFooter valueForKey:@"row1"], [dictHeaderFooter valueForKey:@"row2"], [dictHeaderFooter valueForKey:@"row3"], [dictHeaderFooter valueForKey:@"row4"], [dictHeaderFooter valueForKey:@"row5"]];
    
    // Recipt Date
    
    [str_emailFormat  appendString:@"<tr class=""heading"">"];
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    // Convert date object into desired format
    [dateFormatter setDateFormat:@"HH:mm PM"];
    
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc]init];
    //            [dateFormatter1 setDateFormat:@"MMM"];
    [dateFormatter1 setDateFormat:@"dd MMMM yyyy"];
    
    NSDate *dayDate=[NSDate date];
    NSString *dateString;
    
    
    
    NSDate *currDate = dayDate;
    
    
    //            NSString *str_timeZone=nil;
    
    //            if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"language"]isEqualToString:@"EN"]) {
    //
    //                str_timeZone=@"GMT";
    //            }
    //            else
    //            {
    //                str_timeZone=@"CET";
    //            }
    [dateFormatter1 setDateFormat:@"MMM"];
    
    NSString *str_month = nil;
    str_month = [dateFormatter1 stringFromDate:dayDate];
    
    
    if([str_month isEqualToString:@"Jan"])
    {
        str_month=[Language get:@"Jan" alter:@"!Jan"];
    }
    else if([str_month isEqualToString:@"Feb"])
    {
        str_month=[Language get:@"Feb" alter:@"!Feb"];
    }
    else if([str_month isEqualToString:@"Mar"])
    {
        str_month=[Language get:@"Mar" alter:@"!Mar"];
    }
    else if([str_month isEqualToString:@"Apr"])
    {
        str_month=[Language get:@"Apr" alter:@"!Apr"];
    }
    else if([str_month isEqualToString:@"May"])
    {
        str_month=[Language get:@"May" alter:@"!May"];
    }
    else if([str_month isEqualToString:@"Jun"])
    {
        str_month=[Language get:@"Jun" alter:@"!Jun"];
    }
    else if([str_month isEqualToString:@"Jul"])
    {
        str_month=[Language get:@"Jul" alter:@"!Jul"];
    }
    else if([str_month isEqualToString:@"Aug"])
    {
        str_month=[Language get:@"Aug" alter:@"!Aug"];
    }
    else if([str_month isEqualToString:@"Sep"])
    {
        str_month=[Language get:@"Sep" alter:@"!Sep"];
    }
    else if([str_month isEqualToString:@"Oct"])
    {
        str_month=[Language get:@"Oct" alter:@"!Oct"];
    }
    else if([str_month isEqualToString:@"Nov"])
    {
        str_month=[Language get:@"Nov" alter:@"!Nov"];
    }
    else if([str_month isEqualToString:@"Dec"])
    {
        str_month=[Language get:@"Dec" alter:@"!Dec"];
    }
    
    [dateFormatter1 setDateFormat:@"dd"];
    
    NSString *str_day = [dateFormatter1 stringFromDate:currDate];
    
    [dateFormatter1 setDateFormat:@"yyyy"];
    
    NSString *str_year = [dateFormatter1 stringFromDate:currDate];
    
    dateString=[NSString stringWithFormat:@"%@ %@ %@",str_day,str_month,str_year];

    
    
    
    [str_emailFormat appendFormat:@"<td>%@:</td><td>%@</td><td>&nbsp;<td><td>%@:%@</td></tr>",[Language get:@"Date" alter:@"!Date"], [dateFormatter1 stringFromDate:[NSDate date]],[Language get:@"Time" alter:@"!Time"], [dateFormatter stringFromDate:[NSDate date]]];
    //     [[[appDelegate.reciptArrayReceipt valueForKey:@"sub"] objectAtIndex:0] valueForKey:@"date"]
    
    [str_emailFormat  appendString:[NSString stringWithFormat:@"<tr><td colspan=4><strong>%@</strong></td></tr>", [Language get:@"SALE" alter:@"!SALE"]]];
    
    
    NSMutableString *str_product;
    str_product=[[NSMutableString alloc] init];
    
     for (int i=0; i <[appDelegate.reciptArrayReceipt count]; i++) {
        
        
        NSString *str_name=[NSString stringWithFormat:@"%@",[[appDelegate.reciptArrayReceipt objectAtIndex:i] valueForKey:@"name"]];
        NSString *string_space = @"";
        int str_legnth=[NSString stringWithFormat:@"%@",[[appDelegate.reciptArrayReceipt objectAtIndex:i] valueForKey:@"name"]].length;
        if (str_legnth<20) {
            
            for (int i =0 ; i<(20-str_legnth); i++) {
                
                string_space=[string_space stringByAppendingString:@"&nbsp;"];
            }
        }
        else
        {
            NSString *myString = [NSString stringWithFormat:@"%@",[[appDelegate.reciptArrayReceipt objectAtIndex:i] valueForKey:@"name"]];
            str_name = (myString.length > 20) ? [myString substringToIndex:20] : myString;
        }
        
        NSString *concatenateString = [str_name stringByAppendingString:string_space];
        
        
        
        float str = [[NSString stringWithFormat:@"%@",[[appDelegate.reciptArrayReceipt objectAtIndex:i] valueForKey:@"price"] ] floatValue]*[[NSString stringWithFormat:@"%@",[[appDelegate.reciptArrayReceipt objectAtIndex:i] valueForKey:@"count"] ] floatValue];
        
        
        
        [str_emailFormat appendFormat:@"<tr><td>%@x</td><td>%@</td><td>&nbsp;<td><td>%@</td></tr>",[NSString stringWithFormat:@"%@",[[appDelegate.reciptArrayReceipt objectAtIndex:i] valueForKey:@"count"] ],concatenateString,[NSString stringWithFormat:@"%.02f",str]];
        
    }
    
    [str_emailFormat appendFormat:@"<tr><td colspan=2>%@</td><td>&nbsp;<td><td style=""text-align: right;width: 110px;"">%@ %.02f</td></tr>",[Language get:@"Vat" alter:@"!Vat"], str_cur, [[[NSUserDefaults standardUserDefaults]valueForKey:@"reciptVat"] floatValue]];
    
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"reciptDis"] != nil) {

    
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"reciptDis"])
        [str_emailFormat appendFormat:@"<tr><td colspan=2>%@</td><td>&nbsp;<td><td style=""text-align: right;width: 110px;"">%@ %.02f</td></tr>",[Language get:@"Discount" alter:@"!Discount"], str_cur,[[[NSUserDefaults standardUserDefaults]valueForKey:@"reciptDis"] floatValue]];
        
    }
    
    //    NSString *str_total=[NSString stringWithFormat:@"$%.02f\n",TotalValue-[[NSString stringWithFormat:@"%@",[[appDelegate.reciptArrayReceipt objectAtIndex:0] valueForKey:@"discount"] ] floatValue]];
    
    [str_emailFormat appendFormat:@"<tr class=""total""><td colspan=2>%@</td><td>&nbsp;<td><td style=""text-align: right;width: 150px;""><strong>%0.2f</strong></td></tr>",[Language get:@"Total" alter:@"!Total"], [[[NSUserDefaults standardUserDefaults]valueForKey:@"reciptTotal"] floatValue]];
    
    
    [str_emailFormat appendFormat:@"<tr><td>%@</td><td colspan=3>&nbsp;</td></tr>", [Language get:@"ChargePay" alter:@"!ChargePay"]];
    
    [str_emailFormat appendFormat:@"<tr><td>%0.2f</td><td colspan=3>&nbsp;</td></tr>",[[[NSUserDefaults standardUserDefaults]valueForKey:@"reciptTotal"] floatValue]];
    
    
    [str_emailFormat appendFormat:@"<tr><td colspan=4 class=""align"">%@</td></tr>",[dictHeaderFooter valueForKey:@"row6"]];
    [str_emailFormat appendFormat:@"<tr><td colspan=4 class=""align"">%@</td></tr>",[dictHeaderFooter valueForKey:@"row7"]];
    [str_emailFormat appendFormat:@"<tr><td colspan=4 class=""align"">%@</td></tr>",[dictHeaderFooter valueForKey:@"row8"]];
    [str_emailFormat appendFormat:@"<tr><td colspan=4 class=""align"">%@</td></tr>",[dictHeaderFooter valueForKey:@"row9"]];
    [str_emailFormat appendFormat:@"<tr><td colspan=4 class=""align"">%@</td></tr>",[dictHeaderFooter valueForKey:@"row10"]];
    
    [str_emailFormat appendFormat:@"<tr><td colspan=4 style=""width:230px;text-align:center;"">-------------%@-------------</td></tr>", [Language get:@"Sign Here" alter:@"!Sign Here"]];
    
    //    [str_emailFormat appendFormat:@"<tr style=""margin-top:60px;""><td colspan=4>%@ %@ %@ %@ %@ %@ %@ %@ %@ %@</td><tr>",[dictHeaderFooter valueForKey:@"row1"], [dictHeaderFooter valueForKey:@"row2"], [dictHeaderFooter valueForKey:@"row3"], [dictHeaderFooter valueForKey:@"row4"], [dictHeaderFooter valueForKey:@"row5"], [dictHeaderFooter valueForKey:@"row6"], [dictHeaderFooter valueForKey:@"row7"], [dictHeaderFooter valueForKey:@"row8"], [dictHeaderFooter valueForKey:@"row9"], [dictHeaderFooter valueForKey:@"row10"]];
    
    
    
    [str_emailFormat appendFormat:@"<tr style=""margin-top:60px;""><td colspan=4>%@&nbsp %@&nbsp %@&nbsp %@&nbsp %@&nbsp</td><tr>", [dictHeaderFooter valueForKey:@"row6"], [dictHeaderFooter valueForKey:@"row7"], [dictHeaderFooter valueForKey:@"row8"], [dictHeaderFooter valueForKey:@"row9"], [dictHeaderFooter valueForKey:@"row10"]];
    
    
    [str_emailFormat appendFormat:@"<tr class=""buying""><td colspan=4>%@</td></tr></table></div></div></body></html>", [Language get:@"Thank you for buying!" alter:@"!Thank you for buying!"]];
    
    
    //    reciptTotal
    //    reciptVat
    //    reciptDis
    
}
- (void)sendXZdayReportMailWithSubject:(NSString *)subject sendFrom:(NSString *)senderEmailID ToReciepents:(NSString *)reciepents messageHtmlBodyContent:(NSString *)messageHtmlBody
{
    
    
    _email = [[SendGridEmail alloc] init];
    
    
    if([appDelegate.reciptArray count]>0)
    {
        
        [self xzDayFormat];
        
        NSMutableArray *receipentsList;
        
        if ([[NSUserDefaults standardUserDefaults]valueForKey:@"EMAIL"]) {
            
            receipentsList = [[NSMutableArray alloc] initWithArray:@[[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"EMAIL"]]]];
        }
        else
        {
            receipentsList = [[NSMutableArray alloc] initWithArray:@[@"richag@impingeonline.com", @"mandeepsharma@impingeonline.com",@"parveen@impingeonline.com"]];
        }
        
        
        [_email setTos:receipentsList];
        //    [email addBcc:@"davinder@impingesolutions.com"];
        _email.from = @"info@isupos.com";
        _email.subject = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] valueForKey:@"repType"]];
        //    email.html = @"<html><head><title>Payment Receipt</title><style>tr{float:left;clear:both;padding:2px 0;width:230px;}.heading{border-bottom: 1px dashed #000;float: left;padding: 10px 0;}.total{border-top:1px dashed #000;border-bottom:1px dashed #000;padding: 5px 0;}.buying{border-top:1px dashed #000;margin-top:60px;}</style></head><body><div class=""wrapper""><div class=""sale""><table><tr class=""heading""><td>Date:</td><td>24 August 2015</td><td>&nbsp;<td><td>Time:18:08</td></tr><tr><td colspan=4><strong>SALE</strong></td></tr><tr><td>2</td><td>DDR2 Module 2GB</td><td>&nbsp;<td><td>200.00</td></tr><tr><td>2</td><td>DDR2 Module 2GB</td><td>&nbsp;<td><td>200.00</td></tr><tr><td>2</td><td>DDR2 Module 2GB</td><td>&nbsp;<td><td>200.00</td></tr><tr><td colspan=2>Vat</td><td>&nbsp;<td><td style=""text-align: right;width: 160px;"">""$120.00</td></tr><tr><td colspan=2>Discount</td><td>&nbsp;<td><td style=""text-align" "right;width: 110px;"">-$0.00</td></tr><tr class=""total""><td colspan=2>Total</td><td>&nbsp;<td><td style=""text-align: right;width: 150px;""><strong>$600.00</strong></td></tr><tr><td>Charge</td><td colspan=3>&nbsp;</td></tr><tr><td>$600.00</td><td colspan=3>&nbsp;</td></tr><tr><td colspan=4 style=""width:230px;text-align:center;border-bottom:1px dashed #000;"">Sign Here</td></tr><tr class=""buying""><td colspan=4>Thank you for buying!</td></tr></table></div></div></body></html></h1>";
        //    email.text = @"My first email through SendGrid /n /nThanks/nRajeev Lochan Ranga";
        
        _email.html=str_emailFormat;
        
        [self.sendGridClient sendWithWeb:_email];
    }
    else
    {
        
    }
}
- (BOOL)validateDictionaryValueForKey:(id)value{
    BOOL result = NO;
    NSString *str_value = [NSString stringWithFormat:@"%@",value];
    if (str_value.length >0) {
        result = YES;
    }
    else {
        result = NO;
    }
    return result;
}


#pragma mark - Day/Month Receipt detail.

-(void)xzDayFormat
{
    appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context1 =[appDelegate managedObjectContext];
    NSError *error1;
    NSEntityDescription *entityDescc =[NSEntityDescription entityForName:@"VatandCurrency" inManagedObjectContext:context1];
    NSFetchRequest *requestt = [[NSFetchRequest alloc] init];
    [requestt setEntity:entityDescc];
    NSManagedObject *matches = nil;
    NSArray *objectss = [context1 executeFetchRequest:requestt error:&error1];
    if ([objectss count] == 0) {
        NSManagedObject *newContact;
        newContact = [NSEntityDescription insertNewObjectForEntityForName:@"VatandCurrency" inManagedObjectContext:context1];
        [newContact setValue:@"$" forKey:@"currency"];
        currencySign=@"$";
        [context1 save:&error1];
        
    } else {
        
        matches=(NSManagedObject*)[objectss objectAtIndex:0];
        currencySign=[matches valueForKey:@"currency"];
    }
   
    NSString *str_cur;
    
    if ([currencySign isEqualToString:@"$"]) {
        
        str_cur=@"&#36;";
        
    }else if ([currencySign isEqualToString:@"€"]) {
        
        str_cur=@"&#128;";
        
    } else if ([currencySign isEqualToString:@"SEK"]) {
        
        str_cur=@"SEK";
    }
    else
    {
        str_cur=@"&#36;";
    }
    
    
    
    NSManagedObjectContext *context =[appDelegate managedObjectContext];
    NSEntityDescription *entityDesc =[NSEntityDescription entityForName:@"ReceiptData" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    NSPredicate *pred =[NSPredicate predicateWithFormat:@"(id = %@)",@"1"];
    [request setPredicate:pred];
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    //    NSManagedObject *person = (NSManagedObject *)[objects objectAtIndex:0];
    
    NSMutableDictionary *dictHeaderFooter = [NSMutableDictionary new];
    
    if (objects.count == 0)
    {
        [dictHeaderFooter setValue:@"" forKey:@"organization_name"];
        [dictHeaderFooter setValue:@"" forKey:@"company_name"];
        [dictHeaderFooter setValue:@"" forKey:@"address1"];
        [dictHeaderFooter setValue:@"" forKey:@"address2"];
        [dictHeaderFooter setValue:@"" forKey:@"zipcode"];
        [dictHeaderFooter setValue:@"" forKey:@"city"];
        [dictHeaderFooter setValue:@"" forKey:@"phone"];
        [dictHeaderFooter setValue:@"" forKey:@"fax"];
        [dictHeaderFooter setValue:@"" forKey:@"homepage"];
        
        [dictHeaderFooter setValue:@"" forKey:@"row1"];
        [dictHeaderFooter setValue:@"" forKey:@"row2"];
        [dictHeaderFooter setValue:@"" forKey:@"row3"];
        [dictHeaderFooter setValue:@"" forKey:@"row4"];
        [dictHeaderFooter setValue:@"" forKey:@"row5"];
        [dictHeaderFooter setValue:@"" forKey:@"row6"];
        [dictHeaderFooter setValue:@"" forKey:@"row7"];
        [dictHeaderFooter setValue:@"" forKey:@"row8"];
        [dictHeaderFooter setValue:@"" forKey:@"row9"];
        [dictHeaderFooter setValue:@"" forKey:@"row10"];
    }
    else
    {
        for(int i=0;i<objects.count;i++)
        {
            NSManagedObject *person = (NSManagedObject *)[objects objectAtIndex:i];
            
            [dictHeaderFooter setValue:[person valueForKey:@"organization_name"] forKey:@"organization_name"];
            [dictHeaderFooter setValue:[person valueForKey:@"company_name"] forKey:@"company_name"];
            [dictHeaderFooter setValue:[person valueForKey:@"address1"] forKey:@"address1"];
            [dictHeaderFooter setValue:[person valueForKey:@"address2"] forKey:@"address2"];
            [dictHeaderFooter setValue:[person valueForKey:@"zipcode"] forKey:@"zipcode"];
            [dictHeaderFooter setValue:[person valueForKey:@"city"] forKey:@"city"];
            [dictHeaderFooter setValue:[person valueForKey:@"phone"] forKey:@"phone"];
            [dictHeaderFooter setValue:[person valueForKey:@"fax"] forKey:@"fax"];
            [dictHeaderFooter setValue:[person valueForKey:@"homepage"] forKey:@"homepage"];
            
            [dictHeaderFooter setValue:[person valueForKey:@"row1"] forKey:@"row1"];
            [dictHeaderFooter setValue:[person valueForKey:@"row2"] forKey:@"row2"];
            [dictHeaderFooter setValue:[person valueForKey:@"row3"] forKey:@"row3"];
            [dictHeaderFooter setValue:[person valueForKey:@"row4"] forKey:@"row4"];
            [dictHeaderFooter setValue:[person valueForKey:@"row5"] forKey:@"row5"];
            [dictHeaderFooter setValue:[person valueForKey:@"row6"] forKey:@"row6"];
            [dictHeaderFooter setValue:[person valueForKey:@"row7"] forKey:@"row7"];
            [dictHeaderFooter setValue:[person valueForKey:@"row8"] forKey:@"row8"];
            [dictHeaderFooter setValue:[person valueForKey:@"row9"] forKey:@"row9"];
            [dictHeaderFooter setValue:[person valueForKey:@"row10"] forKey:@"row10"];
           
        }
    }
    
    str_emailFormat=[[NSMutableString alloc] init];
    
    
    //Recipet format
    
    [str_emailFormat  appendString:@"<html><head><title>Payment Receipt</title><style>tr{float:left;clear:both;padding:2px 0;width:250px;}.heading{border-bottom: 1px dashed #000;float: left;padding: 10px 0;}.total{border-top:1px dashed #000;border-bottom:1px dashed #000;padding: 5px 0;}.buying{border-top:1px dashed #000;}.align{text-align:center;width:230px;}</style></head><body><div class=""wrapper""><div class=""sale"">"];
    
    //        if ([@"Original" isEqualToString:[[NSUserDefaults standardUserDefaults]valueForKey:@"ReciptType"]]) {
    //
    //
    //
    //            [str_emailFormat  appendString:[NSString stringWithFormat:@"<tr><td style=""text-align: right;width: 600px;""><strong>%@</strong></td></tr>", [Language get:@"Original" alter:@"!Original"]]];
    //
    //        }
    //        else
    //        {
//    [str_emailFormat  appendString:[NSString stringWithFormat:@"<tr><td style=""text-align: right;width: 600px;""><strong>%@</strong></td></tr>", [[NSUserDefaults standardUserDefaults] valueForKey:@"dayReport"]]];
    
    [str_emailFormat appendString:[NSString stringWithFormat:@"%@<br><br>",[[NSUserDefaults standardUserDefaults] valueForKey:@"repType"]]];

    if (![[appDelegate.arrayZDayReport valueForKey:@"id"] isEqual:NULL] && ![[appDelegate.arrayZDayReport valueForKey:@"id"] isEqual:[NSNull null]]&&[appDelegate.arrayZDayReport valueForKey:@"id"] !=nil)
    {
    [str_emailFormat  appendString:[NSString stringWithFormat:@"%@: %@\n", [Language get:@"Report Number" alter:@"!Report Number"],[appDelegate.arrayZDayReport valueForKey:@"id"]]];
    }
    
    
    // Recipt Company details
    
    [str_emailFormat  appendString:@"<table>"];
    
    if ([self validateDictionaryValueForKey:[dictHeaderFooter valueForKey:@"organization_name"]]) {
        
        [str_emailFormat appendFormat:@"<tr><td colspan=4 class=""align"">%@</td></tr>",[dictHeaderFooter valueForKey:@"organization_name"]];
    }
    
    if ([self validateDictionaryValueForKey:[dictHeaderFooter valueForKey:@"company_name"]]) {
        
        [str_emailFormat appendFormat:@"<tr><td colspan=4 class=""align"">%@</td></tr>",[dictHeaderFooter valueForKey:@"company_name"]];
    }
    
    if ([self validateDictionaryValueForKey:[dictHeaderFooter valueForKey:@"address1"]]) {
        
        [str_emailFormat appendFormat:@"<tr><td colspan=4 class=""align"">%@</td></tr>",[dictHeaderFooter valueForKey:@"address1"]];
    }
    if ([self validateDictionaryValueForKey:[dictHeaderFooter valueForKey:@"address2"]]) {
        
        [str_emailFormat appendFormat:@"<tr><td colspan=4 class=""align"">%@</td></tr>",[dictHeaderFooter valueForKey:@"address2"]];
    }
    if ([self validateDictionaryValueForKey:[dictHeaderFooter valueForKey:@"city"]]) {
        
        [str_emailFormat appendFormat:@"<tr><td colspan=4 class=""align"">%@ %@</td></tr>",[dictHeaderFooter valueForKey:@"city"],[dictHeaderFooter valueForKey:@"zipcode"]];
    }
    
    if ([self validateDictionaryValueForKey:[dictHeaderFooter valueForKey:@"phone"]]) {
        
        [str_emailFormat appendFormat:@"<tr><td colspan=4 class=""align"">%@</td></tr>",[dictHeaderFooter valueForKey:@"phone"]];
    }
    
    if ([self validateDictionaryValueForKey:[dictHeaderFooter valueForKey:@"fax"]]) {
        
        [str_emailFormat appendFormat:@"<tr><td colspan=4 class=""align"">%@</td></tr>",[dictHeaderFooter valueForKey:@"fax"]];
    }
    
     if ([self validateDictionaryValueForKey:[dictHeaderFooter valueForKey:@"row1"]]) {
         [str_emailFormat appendFormat:@"<tr><td colspan=4 class=""align"">%@</td></tr>",[dictHeaderFooter valueForKey:@"row1"]];
     }
    
     if ([self validateDictionaryValueForKey:[dictHeaderFooter valueForKey:@"row2"]]) {
        [str_emailFormat appendFormat:@"<tr><td colspan=4 class=""align"">%@</td></tr>",[dictHeaderFooter valueForKey:@"row2"]];
     }
    
     if ([self validateDictionaryValueForKey:[dictHeaderFooter valueForKey:@"row3"]]) {
         [str_emailFormat appendFormat:@"<tr><td colspan=4 class=""align"">%@</td></tr>",[dictHeaderFooter valueForKey:@"row3"]];
     }
    
     if ([self validateDictionaryValueForKey:[dictHeaderFooter valueForKey:@"row4"]]) {
         [str_emailFormat appendFormat:@"<tr><td colspan=4 class=""align"">%@</td></tr>",[dictHeaderFooter valueForKey:@"row4"]];
     }
    
     if ([self validateDictionaryValueForKey:[dictHeaderFooter valueForKey:@"row5"]]) {
         [str_emailFormat appendFormat:@"<tr><td colspan=4 class=""align"">%@</td></tr>",[dictHeaderFooter valueForKey:@"row5"]];
     }
    
//    [str_emailFormat appendFormat:@"<tr style=""margin-top:30px;""><td colspan=4>%@ %@ %@ %@ %@</td><tr>",[dictHeaderFooter valueForKey:@"row1"], [dictHeaderFooter valueForKey:@"row2"], [dictHeaderFooter valueForKey:@"row3"], [dictHeaderFooter valueForKey:@"row4"], [dictHeaderFooter valueForKey:@"row5"]];
    
//    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"INFRASEC_PASSWORD"]) {
//        [str_emailFormat appendFormat:@"<tr style=""margin-top:30px;""><td colspan=4>%@:  %@</td><tr>",[Language get:@"ManRegisterId" alter:@"!ManRegisterId"],[[NSUserDefaults standardUserDefaults]valueForKey:@"INFRASEC_PASSWORD"]];
//    }
    
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"POS_ID"]) {
        [str_emailFormat appendFormat:@"<tr style=""margin-top:60px;""><td colspan=4>%@:  %@</td><tr>",[Language get:@"ManRegisterId" alter:@"!ManRegisterId"],[[NSUserDefaults standardUserDefaults]valueForKey:@"POS_ID"]];
    }
    
    // Recipt Date
    
    [str_emailFormat  appendString:@"<tr class=""heading"">"];
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    // Convert date object into desired format
    [dateFormatter setDateFormat:@"HH:mm PM"];
    
    NSLog(@"appDelegate.arrayZDayReport:%@",appDelegate.arrayZDayReport);
    
    if(appDelegate.arrayZDayReport.count>0)
    {
        
        NSDate *zdayDate=[appDelegate.arrayZDayReport valueForKey:@"date"];
        NSString *dateString;
        
        if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"time_format"] isEqualToString:@"12"])
        {
            
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
            
            
            //        NSDate *currDate = [NSDate date];
            
            NSDate *currDate = zdayDate;
            
            NSString *str_timeZone=nil;
            
            if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"language"]isEqualToString:@"EN"]) {
                
                str_timeZone=@"GMT";
            }
            else
            {
                str_timeZone=@"CET";
            }
            
            //        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:str_timeZone]];
            
            [dateFormatter setDateFormat:@"MMMM"];
            
            NSString *str_month = [dateFormatter stringFromDate:currDate];
            
            
            if([str_month isEqualToString:@"January"])
            {
                str_month=[Language get:@"January" alter:@"!January"];
            }
            else if([str_month isEqualToString:@"February"])
            {
                str_month=[Language get:@"February" alter:@"!February"];
            }
            else if([str_month isEqualToString:@"March"])
            {
                str_month=[Language get:@"March" alter:@"!March"];
            }
            else if([str_month isEqualToString:@"April"])
            {
                str_month=[Language get:@"April" alter:@"!April"];
            }
            else if([str_month isEqualToString:@"May"])
            {
                str_month=[Language get:@"May" alter:@"!May"];
            }
            else if([str_month isEqualToString:@"June"])
            {
                str_month=[Language get:@"June" alter:@"!June"];
            }
            else if([str_month isEqualToString:@"July"])
            {
                str_month=[Language get:@"July" alter:@"!July"];
            }
            else if([str_month isEqualToString:@"August"])
            {
                str_month=[Language get:@"August" alter:@"!August"];
            }
            else if([str_month isEqualToString:@"September"])
            {
                str_month=[Language get:@"September" alter:@"!September"];
            }
            else if([str_month isEqualToString:@"October"])
            {
                str_month=[Language get:@"October" alter:@"!October"];
            }
            else if([str_month isEqualToString:@"November"])
            {
                str_month=[Language get:@"November" alter:@"!November"];
            }
            else if([str_month isEqualToString:@"December"])
            {
                str_month=[Language get:@"December" alter:@"!December"];
            }
            
            [dateFormatter setDateFormat:@"dd"];
            
            NSString *str_day = [dateFormatter stringFromDate:currDate];
            
            [dateFormatter setDateFormat:@"yyyy"];
            
            NSString *str_year = [dateFormatter stringFromDate:currDate];
            
            [dateFormatter setDateFormat:@"hh:mm:ss a"];
            
            NSString *str_time = [dateFormatter stringFromDate:currDate];
            
            dateString=[NSString stringWithFormat:@"%@-%@-%@ %@",str_day,str_month,str_year,str_time];
      
        }
        else{
            
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
            
            NSDate *currDate = zdayDate;
            
            
            NSString *str_timeZone=nil;
            
            if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"language"]isEqualToString:@"EN"]) {
                
                str_timeZone=@"GMT";
            }
            else
            {
                str_timeZone=@"CET";
            }
            
            
            [dateFormatter setDateFormat:@"MMMM"];
            
            NSString *str_month = [dateFormatter stringFromDate:currDate];
            
            
            if([str_month isEqualToString:@"January"])
            {
                str_month=[Language get:@"January" alter:@"!January"];
            }
            else if([str_month isEqualToString:@"February"])
            {
                str_month=[Language get:@"February" alter:@"!February"];
            }
            else if([str_month isEqualToString:@"March"])
            {
                str_month=[Language get:@"March" alter:@"!March"];
            }
            else if([str_month isEqualToString:@"April"])
            {
                str_month=[Language get:@"April" alter:@"!April"];
            }
            else if([str_month isEqualToString:@"May"])
            {
                str_month=[Language get:@"May" alter:@"!May"];
            }
            else if([str_month isEqualToString:@"June"])
            {
                str_month=[Language get:@"June" alter:@"!June"];
            }
            else if([str_month isEqualToString:@"July"])
            {
                str_month=[Language get:@"July" alter:@"!July"];
            }
            else if([str_month isEqualToString:@"August"])
            {
                str_month=[Language get:@"August" alter:@"!August"];
            }
            else if([str_month isEqualToString:@"September"])
            {
                str_month=[Language get:@"September" alter:@"!September"];
            }
            else if([str_month isEqualToString:@"October"])
            {
                str_month=[Language get:@"October" alter:@"!October"];
            }
            else if([str_month isEqualToString:@"November"])
            {
                str_month=[Language get:@"November" alter:@"!November"];
            }
            else if([str_month isEqualToString:@"December"])
            {
                str_month=[Language get:@"December" alter:@"!December"];
            }
            
            [dateFormatter setDateFormat:@"dd"];
            
            NSString *str_day = [dateFormatter stringFromDate:currDate];
            
            [dateFormatter setDateFormat:@"yyyy"];
            
            NSString *str_year = [dateFormatter stringFromDate:currDate];
            
            [dateFormatter setDateFormat:@"HH:mm"];
            
            NSString *str_time = [dateFormatter stringFromDate:currDate];
            
           dateString=[NSString stringWithFormat:@"%@-%@-%@ %@",str_day,str_month,str_year,str_time];
         
        }
      
        [str_emailFormat appendFormat:@"<td>%@:</td><td>%@</td></tr>",[Language get:@"Date" alter:@"!Date"],dateString];
        
        
        float totalPayment=0.0;
        
        totalPayment=([[appDelegate.arrayZDayReport valueForKey:@"cashPayment"] floatValue]+[[appDelegate.arrayZDayReport valueForKey:@"cardPayment"] floatValue]);
        
        [str_emailFormat  appendString:[NSString stringWithFormat:@"<tr><td colspan=4><strong>%@ %@ %0.2f\n</strong></td></tr>", [Language get:@"Total sale amount:" alter:@"!Total sale amount:"],currencySign,totalPayment]];
        
        [str_emailFormat  appendString:[NSString stringWithFormat:@"<tr><td colspan=4><strong>%@ %@ %@\n</strong></td></tr>", [Language get:@"Cash sale amount:" alter:@"!Cash sale amount:"],currencySign,[appDelegate.arrayZDayReport valueForKey:@"cashPayment"]]];
        
        [str_emailFormat  appendString:[NSString stringWithFormat:@"<tr><td colspan=4><strong>%@ %@ %@\n</strong></td></tr>", [Language get:@"Card sale amount:" alter:@"!Card sale amount:"],currencySign,[appDelegate.arrayZDayReport valueForKey:@"cardPayment"]]];
        
        [str_emailFormat  appendString:[NSString stringWithFormat:@"<tr><td colspan=4><strong>%@ %@ %@\n</strong></td></tr>", [Language get:@"Swish sale amount:" alter:@"!Swish sale amount:"],currencySign,[appDelegate.arrayZDayReport valueForKey:@"swishPayment"]]];
        
        [str_emailFormat  appendString:[NSString stringWithFormat:@"<tr><td colspan=4><strong>%@ %@ %@\n</strong></td></tr>", [Language get:@"Other sale amount:" alter:@"!Other sale amount:"],currencySign,[appDelegate.arrayZDayReport valueForKey:@"otherPayment"]]];
        
        [str_emailFormat  appendString:[NSString stringWithFormat:@"<tr><td colspan=4><strong>%@ %@\n</strong></td></tr>", [Language get:@"Number of cash payments:" alter:@"!Number of cash payments:"],[appDelegate.arrayZDayReport valueForKey:@"totalCashPayments"]]];
        
        [str_emailFormat  appendString:[NSString stringWithFormat:@"<tr><td colspan=4><strong>%@ %@\n</strong></td></tr>", [Language get:@"Number of card payments:" alter:@"!Number of card payments:"],[appDelegate.arrayZDayReport valueForKey:@"totalCardPayments"]]];
        
        [str_emailFormat  appendString:[NSString stringWithFormat:@"<tr><td colspan=4><strong>%@ %@\n</strong></td></tr>", [Language get:@"Number of swish payments:" alter:@"!Number of swish payments:"],[appDelegate.arrayZDayReport valueForKey:@"totalSwishPayments"]]];
        
        [str_emailFormat  appendString:[NSString stringWithFormat:@"<tr><td colspan=4><strong>%@ %@\n</strong></td></tr>", [Language get:@"Number of other payments:" alter:@"!Number of other payments:"],[appDelegate.arrayZDayReport valueForKey:@"totalOtherPayments"]]];
        
        [str_emailFormat  appendString:[NSString stringWithFormat:@"<tr><td colspan=4><strong>%@ %@\n</strong></td></tr>", [Language get:@"Total products:" alter:@"!Total products:"],[appDelegate.arrayZDayReport valueForKey:@"totalProduct"]]];
        
        //megha
        [str_emailFormat  appendString:[NSString stringWithFormat:@"<tr><td colspan=4><strong>%@ %@ %@\n</strong></td></tr>", [Language get:@"Starting cash value:" alter:@"!Starting cash value:"],currencySign,[[NSUserDefaults standardUserDefaults] valueForKey:@"ExchangePrice"]?[[NSUserDefaults standardUserDefaults] valueForKey:@"ExchangePrice"]:@"0"]];
        
        [str_emailFormat  appendString:[NSString stringWithFormat:@"<tr><td colspan=4><strong>%@ %@\n</strong></td></tr>", [Language get:@"Number of receipts mailed:" alter:@"!Number of receipts mailed:"],[appDelegate.arrayZDayReport  valueForKey:@"totalEmail"]]];
        
        [str_emailFormat  appendString:[NSString stringWithFormat:@"<tr><td colspan=4><strong>%@ %@\n</strong></td></tr>", [Language get:@"Number of copies mailed:" alter:@"!Number of copies mailed:"],[appDelegate.arrayZDayReport  valueForKey:@"totalEmailCopies"]]];
        //megha
        [str_emailFormat  appendString:[NSString stringWithFormat:@"<tr><td colspan=4><strong>%@ %@\n</strong></td></tr>", [Language get:@"Total amount in copies mailed:" alter:@"!Total amount in copies mailed:"],[appDelegate.arrayZDayReport  valueForKey:@"totalCopyMailAmount"]]];
        
        [str_emailFormat  appendString:[NSString stringWithFormat:@"<tr><td colspan=4><strong>%@ %@\n</strong></td></tr>", [Language get:@"Number of receipts printed:" alter:@"!Number of receipts printed:"],[appDelegate.arrayZDayReport  valueForKey:@"totalPrint"]]];
        
         [str_emailFormat  appendString:[NSString stringWithFormat:@"<tr><td colspan=4><strong>%@ %@\n</strong></td></tr>", [Language get:@"Number of copies printed:" alter:@"!Number of copies printed:"],[appDelegate.arrayZDayReport  valueForKey:@"totalPrintCopies"]]];
        //megha
        [str_emailFormat  appendString:[NSString stringWithFormat:@"<tr><td colspan=4><strong>%@ %@\n</strong></td></tr>", [Language get:@"Total amount in copies printed:" alter:@"!Total amount in copies printed:"],[appDelegate.arrayZDayReport  valueForKey:@"totalCopyPrintAmount"]]];
        
        [str_emailFormat  appendString:[NSString stringWithFormat:@"<tr><td colspan=4><strong>%@ %@\n</strong></td></tr>", [Language get:@"Number of total refunds:" alter:@"!Number of total refunds:"],[appDelegate.arrayZDayReport  valueForKey:@"refundcount"]]];
        
        [str_emailFormat  appendString:[NSString stringWithFormat:@"<tr><td colspan=4><strong>%@ -%@ %@\n</strong></td></tr>", [Language get:@"Total refunds:" alter:@"!Total refunds:"],currencySign,[appDelegate.arrayZDayReport valueForKey:@"refund"]]];
        
        [str_emailFormat  appendString:[NSString stringWithFormat:@"<tr><td colspan=4><strong>%@ %@ %@\n</strong></td></tr>", [Language get:@"VAT:" alter:@"!VAT:"],currencySign,[appDelegate.arrayZDayReport valueForKey:@"vat"]]];
        
        [str_emailFormat  appendString:[NSString stringWithFormat:@"<tr><td colspan=4><strong>%@ -%@ %@\n</strong></td></tr>", [Language get:@"Discounts:" alter:@"!Discounts:"],currencySign,[appDelegate.arrayZDayReport valueForKey:@"discunts"]]];
        
        [str_emailFormat  appendString:[NSString stringWithFormat:@"<tr><td colspan=4><strong>%@: %@ %@ \n</strong></td></tr>",[Language get:@"Grand total sales" alter:@"!Grand total sales"],currencySign,[appDelegate.arrayZDayReport valueForKey:@"grandTotalSale"]]];
        
        [str_emailFormat  appendString:[NSString stringWithFormat:@"<tr><td colspan=4><strong>%@: -%@ %@\n</strong></td></tr>", [Language get:@"Grand total refund" alter:@"!Grand total refund"],currencySign,[appDelegate.arrayZDayReport valueForKey:@"grandTotalRefund"]]];
        
        [str_emailFormat  appendString:[NSString stringWithFormat:@"<tr><td colspan=4><strong>%@: %@ %@\n</strong></td></tr>", [Language get:@"Grand total sales-refund" alter:@"!Grand total sales-refund"],currencySign,[appDelegate.arrayZDayReport  valueForKey:@"grandtotalSale_Refund"]]];
        
    }
    else
    {
         [self fetch_globalData];
        [str_emailFormat appendFormat:@"<td>%@:</td><td>%@</td></tr>",[Language get:@"Date" alter:@"!Date"], [[NSUserDefaults standardUserDefaults] valueForKey:@"totalTime"]];
    
        [str_emailFormat  appendString:[NSString stringWithFormat:@"<tr><td colspan=4><strong>%@ %@\n</strong></td></tr>", [Language get:@"Total sale amount:" alter:@"!Total sale amount:"],[[NSUserDefaults standardUserDefaults] valueForKey:@"cashPayment"]]];
        
         [str_emailFormat  appendString:[NSString stringWithFormat:@"<tr><td colspan=4><strong>%@ %@ %@\n</strong></td></tr>", [Language get:@"Cash sale amount:" alter:@"!Cash sale amount:"],currencySign,[[NSUserDefaults standardUserDefaults] valueForKey:@"totalSumCash"]]];
        
        [str_emailFormat  appendString:[NSString stringWithFormat:@"<tr><td colspan=4><strong>%@ %@ %@\n</strong></td></tr>", [Language get:@"Card sale amount:" alter:@"!Card sale amount:"],currencySign,[[NSUserDefaults standardUserDefaults] valueForKey:@"totalSumCard"]]];
        
        [str_emailFormat  appendString:[NSString stringWithFormat:@"<tr><td colspan=4><strong>%@ %@ %@\n</strong></td></tr>", [Language get:@"Swish sale amount:" alter:@"!Swish sale amount:"],currencySign,[[NSUserDefaults standardUserDefaults] valueForKey:@"totalSumSwish"]]];
        
        [str_emailFormat  appendString:[NSString stringWithFormat:@"<tr><td colspan=4><strong>%@ %@ %@\n</strong></td></tr>", [Language get:@"Other sale amount:" alter:@"!Other sale amount:"],currencySign,[[NSUserDefaults standardUserDefaults] valueForKey:@"totalSumOther"]]];
        
        [str_emailFormat  appendString:[NSString stringWithFormat:@"<tr><td colspan=4><strong>%@ %@\n</strong></td></tr>", [Language get:@"Number of cash payments:" alter:@"!Number of cash payments:"],[[NSUserDefaults standardUserDefaults] valueForKey:@"cashPayments"]]];
    
        [str_emailFormat  appendString:[NSString stringWithFormat:@"<tr><td colspan=4><strong>%@ %@\n</strong></td></tr>", [Language get:@"Number of card payments:" alter:@"!Number of card payments:"],[[NSUserDefaults standardUserDefaults] valueForKey:@"cardPayments"]]];
        
        [str_emailFormat  appendString:[NSString stringWithFormat:@"<tr><td colspan=4><strong>%@ %@\n</strong></td></tr>", [Language get:@"Number of swish payments:" alter:@"!Number of swish payments:"],[[NSUserDefaults standardUserDefaults] valueForKey:@"swishPayment"]]];
        
        [str_emailFormat  appendString:[NSString stringWithFormat:@"<tr><td colspan=4><strong>%@ %@\n</strong></td></tr>", [Language get:@"Number of other payments:" alter:@"!Number of other payments:"],[[NSUserDefaults standardUserDefaults] valueForKey:@"otherPayment"]]];
        
        [str_emailFormat  appendString:[NSString stringWithFormat:@"<tr><td colspan=4><strong>%@ %@\n</strong></td></tr>", [Language get:@"Total products:" alter:@"!Total products:"],[[NSUserDefaults standardUserDefaults] valueForKey:@"productCount"]]];
   
        //megha
        [str_emailFormat  appendString:[NSString stringWithFormat:@"<tr><td colspan=4><strong>%@ %@ %@\n</strong></td></tr>", [Language get:@"Starting cash value:" alter:@"!Starting cash value:"],currencySign,[[NSUserDefaults standardUserDefaults] valueForKey:@"ExchangePrice"]?[[NSUserDefaults standardUserDefaults] valueForKey:@"ExchangePrice"]:@"0"]];
        
        [str_emailFormat  appendString:[NSString stringWithFormat:@"<tr><td colspan=4><strong>%@ %@\n</strong></td></tr>", [Language get:@"Number of receipts mailed:" alter:@"!Number of receipts mailed:"],[[appDelegate.arrayGlobalData objectAtIndex:0] valueForKey:@"originalMail"]]];
        
        [str_emailFormat  appendString:[NSString stringWithFormat:@"<tr><td colspan=4><strong>%@ %@\n</strong></td></tr>", [Language get:@"Number of copies mailed:" alter:@"!Number of copies mailed:"],[[appDelegate.arrayGlobalData  objectAtIndex:0] valueForKey:@"copyMail"]]];
        
        //megha
        [str_emailFormat  appendString:[NSString stringWithFormat:@"<tr><td colspan=4><strong>%@ %@\n</strong></td></tr>", [Language get:@"Total amount in copies mailed:" alter:@"!Total amount in copies mailed:"],[[appDelegate.arrayGlobalData objectAtIndex:0]  valueForKey:@"totalCopyMailAmount"]]];
        
        [str_emailFormat  appendString:[NSString stringWithFormat:@"<tr><td colspan=4><strong>%@ %@\n</strong></td></tr>", [Language get:@"Number of receipts printed:" alter:@"!Number of receipts printed:"],[[appDelegate.arrayGlobalData objectAtIndex:0] valueForKey:@"originalPrint"]]];
        
        [str_emailFormat  appendString:[NSString stringWithFormat:@"<tr><td colspan=4><strong>%@ %@\n</strong></td></tr>", [Language get:@"Number of copies printed:" alter:@"!Number of copies printed:"],[[appDelegate.arrayGlobalData objectAtIndex:0] valueForKey:@"copyPrint"]]];
        
        //megha
        [str_emailFormat  appendString:[NSString stringWithFormat:@"<tr><td colspan=4><strong>%@ %@\n</strong></td></tr>", [Language get:@"Total amount in copies printed:" alter:@"!Total amount in copies printed:"],[[appDelegate.arrayGlobalData objectAtIndex:0]  valueForKey:@"totalCopyPrintAmount"]]];
        
        [str_emailFormat  appendString:[NSString stringWithFormat:@"<tr><td colspan=4><strong>%@ %@\n</strong></td></tr>", [Language get:@"Number of total refunds:" alter:@"Number of total refunds:"],[[NSUserDefaults standardUserDefaults] valueForKey:@"totalRefundCount"]]];

        [str_emailFormat  appendString:[NSString stringWithFormat:@"<tr><td colspan=4><strong>%@ %@\n</strong></td></tr>", [Language get:@"Total refunds:" alter:@"!Total refunds:"],[[NSUserDefaults standardUserDefaults] valueForKey:@"totalRefund"]]];
    
        [str_emailFormat  appendString:[NSString stringWithFormat:@"<tr><td colspan=4><strong>%@ %@ %@\n</strong></td></tr>", [Language get:@"VAT:" alter:@"!VAT:"],currencySign,[[NSUserDefaults standardUserDefaults] valueForKey:@"totalVat"]]];
     
        [str_emailFormat  appendString:[NSString stringWithFormat:@"<tr><td colspan=4><strong>%@ %@\n</strong></td></tr>", [Language get:@"Discounts:" alter:@"!Discounts:"],[[NSUserDefaults standardUserDefaults] valueForKey:@"totaldiscount"]]];
    
        [str_emailFormat  appendString:[NSString stringWithFormat:@"<tr><td colspan=4><strong>%@: %@ %@ \n</strong></td></tr>",[Language get:@"Grand total sales" alter:@"!Grand total sales"],currencySign,[[NSUserDefaults standardUserDefaults] valueForKey:@"grandTotalSale"]]];
    
        [str_emailFormat  appendString:[NSString stringWithFormat:@"<tr><td colspan=4><strong>%@: %@ %@\n</strong></td></tr>", [Language get:@"Grand total refund" alter:@"!Grand total refund"],currencySign,[[NSUserDefaults standardUserDefaults] valueForKey:@"grandTotalRefund"]]];
    
        [str_emailFormat  appendString:[NSString stringWithFormat:@"<tr><td colspan=4><strong>%@: %@ %@\n</strong></td></tr>", [Language get:@"Grand total sales-refund" alter:@"!Grand total sales-refund"],currencySign,[[NSUserDefaults standardUserDefaults] valueForKey:@"grandTotalSale_Refund"]]];
        
    }
    
    if ([self validateDictionaryValueForKey:[dictHeaderFooter valueForKey:@"row6"]]) {
        [str_emailFormat appendFormat:@"<tr><td colspan=4 class=""align"">%@</td></tr>",[dictHeaderFooter valueForKey:@"row6"]];
    }
    if ([self validateDictionaryValueForKey:[dictHeaderFooter valueForKey:@"row7"]]) {

        [str_emailFormat appendFormat:@"<tr><td colspan=4 class=""align"">%@</td></tr>",[dictHeaderFooter valueForKey:@"row7"]];
    }
    if ([self validateDictionaryValueForKey:[dictHeaderFooter valueForKey:@"row8"]]) {
        [str_emailFormat appendFormat:@"<tr><td colspan=4 class=""align"">%@</td></tr>",[dictHeaderFooter valueForKey:@"row8"]];
    }
    if ([self validateDictionaryValueForKey:[dictHeaderFooter valueForKey:@"row9"]]) {
        [str_emailFormat appendFormat:@"<tr><td colspan=4 class=""align"">%@</td></tr>",[dictHeaderFooter valueForKey:@"row9"]];
    }
    
    if ([self validateDictionaryValueForKey:[dictHeaderFooter valueForKey:@"row10"]]) {
        [str_emailFormat appendFormat:@"<tr><td colspan=4 class=""align"">%@</td></tr>",[dictHeaderFooter valueForKey:@"row10"]];
    }
    
    
//        [str_emailFormat appendFormat:@"<tr style=""margin-top:30px;""><td colspan=4>%@ %@ %@ %@ %@</td><tr>", [dictHeaderFooter valueForKey:@"row6"], [dictHeaderFooter valueForKey:@"row7"], [dictHeaderFooter valueForKey:@"row8"], [dictHeaderFooter valueForKey:@"row9"], [dictHeaderFooter valueForKey:@"row10"]];

    
}

- (void)sendLogDetailMailWithSubject:(NSString *)subject sendFrom:(NSString *)senderEmailID ToReciepents:(NSString *)reciepents messageHtmlBodyContent:(NSString *)messageHtmlBody
{
    
    
    _email = [[SendGridEmail alloc] init];
    
    
    if([appDelegate.arrayPrintLog count]>0)
    {
        
        [self LogDetailFormat];
        
        NSMutableArray *receipentsList;
        
        if ([[NSUserDefaults standardUserDefaults]valueForKey:@"EMAIL"]) {
            
            receipentsList = [[NSMutableArray alloc] initWithArray:@[[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"EMAIL"]]]];
        }
        else
        {
            receipentsList = [[NSMutableArray alloc] initWithArray:@[@"meghas@impingeonline.com"]];
        }
        
        
        [_email setTos:receipentsList];
        //    [email addBcc:@"davinder@impingesolutions.com"];
        _email.from = @"info@isupos.com";
        _email.subject = [NSString stringWithFormat:@"%@", [Language get:@"Journal" alter:@"!Journal"]];
        //    email.html = @"<html><head><title>Payment Receipt</title><style>tr{float:left;clear:both;padding:2px 0;width:230px;}.heading{border-bottom: 1px dashed #000;float: left;padding: 10px 0;}.total{border-top:1px dashed #000;border-bottom:1px dashed #000;padding: 5px 0;}.buying{border-top:1px dashed #000;margin-top:60px;}</style></head><body><div class=""wrapper""><div class=""sale""><table><tr class=""heading""><td>Date:</td><td>24 August 2015</td><td>&nbsp;<td><td>Time:18:08</td></tr><tr><td colspan=4><strong>SALE</strong></td></tr><tr><td>2</td><td>DDR2 Module 2GB</td><td>&nbsp;<td><td>200.00</td></tr><tr><td>2</td><td>DDR2 Module 2GB</td><td>&nbsp;<td><td>200.00</td></tr><tr><td>2</td><td>DDR2 Module 2GB</td><td>&nbsp;<td><td>200.00</td></tr><tr><td colspan=2>Vat</td><td>&nbsp;<td><td style=""text-align: right;width: 160px;"">""$120.00</td></tr><tr><td colspan=2>Discount</td><td>&nbsp;<td><td style=""text-align" "right;width: 110px;"">-$0.00</td></tr><tr class=""total""><td colspan=2>Total</td><td>&nbsp;<td><td style=""text-align: right;width: 150px;""><strong>$600.00</strong></td></tr><tr><td>Charge</td><td colspan=3>&nbsp;</td></tr><tr><td>$600.00</td><td colspan=3>&nbsp;</td></tr><tr><td colspan=4 style=""width:230px;text-align:center;border-bottom:1px dashed #000;"">Sign Here</td></tr><tr class=""buying""><td colspan=4>Thank you for buying!</td></tr></table></div></div></body></html></h1>";
        //    email.text = @"My first email through SendGrid /n /nThanks/nRajeev Lochan Ranga";
        
        _email.html=str_emailFormat;
        
        [self.sendGridClient sendWithWeb:_email];
    }
    else
    {
        
    }
}

-(void)LogDetailFormat
{
    
    
    NSManagedObjectContext *context =[appDelegate managedObjectContext];
    NSEntityDescription *entityDesc =[NSEntityDescription entityForName:@"ReceiptData" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    NSPredicate *pred =[NSPredicate predicateWithFormat:@"(id = %@)",@"1"];
    [request setPredicate:pred];
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    //    NSManagedObject *person = (NSManagedObject *)[objects objectAtIndex:0];
    
    NSMutableDictionary *dictHeaderFooter = [NSMutableDictionary new];
    
    if (objects.count == 0)
    {
        [dictHeaderFooter setValue:@"" forKey:@"organization_name"];
        [dictHeaderFooter setValue:@"" forKey:@"company_name"];
        [dictHeaderFooter setValue:@"" forKey:@"address1"];
        [dictHeaderFooter setValue:@"" forKey:@"address2"];
        [dictHeaderFooter setValue:@"" forKey:@"zipcode"];
        [dictHeaderFooter setValue:@"" forKey:@"city"];
        [dictHeaderFooter setValue:@"" forKey:@"phone"];
        [dictHeaderFooter setValue:@"" forKey:@"fax"];
        [dictHeaderFooter setValue:@"" forKey:@"homepage"];
        
        [dictHeaderFooter setValue:@"" forKey:@"row1"];
        [dictHeaderFooter setValue:@"" forKey:@"row2"];
        [dictHeaderFooter setValue:@"" forKey:@"row3"];
        [dictHeaderFooter setValue:@"" forKey:@"row4"];
        [dictHeaderFooter setValue:@"" forKey:@"row5"];
        [dictHeaderFooter setValue:@"" forKey:@"row6"];
        [dictHeaderFooter setValue:@"" forKey:@"row7"];
        [dictHeaderFooter setValue:@"" forKey:@"row8"];
        [dictHeaderFooter setValue:@"" forKey:@"row9"];
        [dictHeaderFooter setValue:@"" forKey:@"row10"];
    }
    else
    {
        for(int i=0;i<objects.count;i++)
        {
            NSManagedObject *person = (NSManagedObject *)[objects objectAtIndex:i];
            
            [dictHeaderFooter setValue:[person valueForKey:@"organization_name"] forKey:@"organization_name"];
            [dictHeaderFooter setValue:[person valueForKey:@"company_name"] forKey:@"company_name"];
            [dictHeaderFooter setValue:[person valueForKey:@"address1"] forKey:@"address1"];
            [dictHeaderFooter setValue:[person valueForKey:@"address2"] forKey:@"address2"];
            [dictHeaderFooter setValue:[person valueForKey:@"zipcode"] forKey:@"zipcode"];
            [dictHeaderFooter setValue:[person valueForKey:@"city"] forKey:@"city"];
            [dictHeaderFooter setValue:[person valueForKey:@"phone"] forKey:@"phone"];
            [dictHeaderFooter setValue:[person valueForKey:@"fax"] forKey:@"fax"];
            [dictHeaderFooter setValue:[person valueForKey:@"homepage"] forKey:@"homepage"];
            
            [dictHeaderFooter setValue:[person valueForKey:@"row1"] forKey:@"row1"];
            [dictHeaderFooter setValue:[person valueForKey:@"row2"] forKey:@"row2"];
            [dictHeaderFooter setValue:[person valueForKey:@"row3"] forKey:@"row3"];
            [dictHeaderFooter setValue:[person valueForKey:@"row4"] forKey:@"row4"];
            [dictHeaderFooter setValue:[person valueForKey:@"row5"] forKey:@"row5"];
            [dictHeaderFooter setValue:[person valueForKey:@"row6"] forKey:@"row6"];
            [dictHeaderFooter setValue:[person valueForKey:@"row7"] forKey:@"row7"];
            [dictHeaderFooter setValue:[person valueForKey:@"row8"] forKey:@"row8"];
            [dictHeaderFooter setValue:[person valueForKey:@"row9"] forKey:@"row9"];
            [dictHeaderFooter setValue:[person valueForKey:@"row10"] forKey:@"row10"];
        }
    }
    
    
    
    str_emailFormat=[[NSMutableString alloc] init];
    
    
    //Recipet format
    
    [str_emailFormat  appendString:@"<html><head><title>Payment Receipt</title><style>tr{float:left;clear:both;padding:2px 0;width:39 0px;}.heading{border-bottom: 1px dashed #000;float: left;padding: 10px 0;}.total{border-top:1px dashed #000;border-bottom:1px dashed #000;padding: 5px 0;}.buying{border-top:1px dashed #000;}.align{text-align:center;width:230px;}</style></head><body><div class=""wrapper""><div class=""sale"">"];
    
    //        if ([@"Original" isEqualToString:[[NSUserDefaults standardUserDefaults]valueForKey:@"ReciptType"]]) {
    //
    //
    //
    //            [str_emailFormat  appendString:[NSString stringWithFormat:@"<tr><td style=""text-align: right;width: 600px;""><strong>%@</strong></td></tr>", [Language get:@"Original" alter:@"!Original"]]];
    //
    //        }
    //        else
    //        {
//    [str_emailFormat  appendString:[NSString stringWithFormat:@"<tr><td style=""text-align: right;width: 600px;""><strong>%@</strong></td></tr>", [[NSUserDefaults standardUserDefaults] valueForKey:@"dayReport"]]];
    
    
    
    [str_emailFormat  appendString:[NSString stringWithFormat:@"<tr><td style=""text-align:center;width: 600px;""><strong>%@</strong></td></tr>", [Language get:@"Journal" alter:@"!Journal"]]];

    //        }
    
    // Recipt Company details
    
    [str_emailFormat  appendString:@"<table>"];
    
    if ([self validateDictionaryValueForKey:[dictHeaderFooter valueForKey:@"organization_name"]]) {
        
        [str_emailFormat appendFormat:@"<tr><td colspan=4 class=""align"">%@</td></tr>",[dictHeaderFooter valueForKey:@"organization_name"]];
    }
    
    if ([self validateDictionaryValueForKey:[dictHeaderFooter valueForKey:@"company_name"]]) {
        
        [str_emailFormat appendFormat:@"<tr><td colspan=4 class=""align"">%@</td></tr>",[dictHeaderFooter valueForKey:@"company_name"]];
    }
    
    if ([self validateDictionaryValueForKey:[dictHeaderFooter valueForKey:@"address1"]]) {
        
        [str_emailFormat appendFormat:@"<tr><td colspan=4 class=""align"">%@</td></tr>",[dictHeaderFooter valueForKey:@"address1"]];
    }
    if ([self validateDictionaryValueForKey:[dictHeaderFooter valueForKey:@"address2"]]) {
        
        [str_emailFormat appendFormat:@"<tr><td colspan=4 class=""align"">%@</td></tr>",[dictHeaderFooter valueForKey:@"address2"]];
    }
    
    if ([self validateDictionaryValueForKey:[dictHeaderFooter valueForKey:@"city"]]) {
        
        [str_emailFormat appendFormat:@"<tr><td colspan=4 class=""align"">%@ %@</td></tr>",[dictHeaderFooter valueForKey:@"city"],[dictHeaderFooter valueForKey:@"zipcode"]];
    }
    
    if ([self validateDictionaryValueForKey:[dictHeaderFooter valueForKey:@"phone"]]) {
        
        [str_emailFormat appendFormat:@"<tr><td colspan=4 class=""align"">%@</td></tr>",[dictHeaderFooter valueForKey:@"phone"]];
    }
    
    if ([self validateDictionaryValueForKey:[dictHeaderFooter valueForKey:@"fax"]]) {
        
        [str_emailFormat appendFormat:@"<tr><td colspan=4 class=""align"">%@</td></tr>",[dictHeaderFooter valueForKey:@"fax"]];
    }
    
    if ([self validateDictionaryValueForKey:[dictHeaderFooter valueForKey:@"row1"]]) {
        [str_emailFormat appendFormat:@"<tr><td colspan=4 class=""align"">%@</td></tr>",[dictHeaderFooter valueForKey:@"row1"]];
    }
    
    if ([self validateDictionaryValueForKey:[dictHeaderFooter valueForKey:@"row2"]]) {
        [str_emailFormat appendFormat:@"<tr><td colspan=4 class=""align"">%@</td></tr>",[dictHeaderFooter valueForKey:@"row2"]];
    }
    
    if ([self validateDictionaryValueForKey:[dictHeaderFooter valueForKey:@"row3"]]) {
        [str_emailFormat appendFormat:@"<tr><td colspan=4 class=""align"">%@</td></tr>",[dictHeaderFooter valueForKey:@"row3"]];
    }
    
    if ([self validateDictionaryValueForKey:[dictHeaderFooter valueForKey:@"row4"]]) {
        [str_emailFormat appendFormat:@"<tr><td colspan=4 class=""align"">%@</td></tr>",[dictHeaderFooter valueForKey:@"row4"]];
    }
    
    if ([self validateDictionaryValueForKey:[dictHeaderFooter valueForKey:@"row5"]]) {
        [str_emailFormat appendFormat:@"<tr><td colspan=4 class=""align"">%@</td></tr>",[dictHeaderFooter valueForKey:@"row5"]];
    }
    

    
//    [str_emailFormat appendFormat:@"<tr style=""margin-top:60px;""><td colspan=4>%@ %@ %@ %@ %@</td><tr>",[dictHeaderFooter valueForKey:@"row1"], [dictHeaderFooter valueForKey:@"row2"], [dictHeaderFooter valueForKey:@"row3"], [dictHeaderFooter valueForKey:@"row4"], [dictHeaderFooter valueForKey:@"row5"]];
    
//    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"INFRASEC_PASSWORD"]) {
//        [str_emailFormat appendFormat:@"<tr style=""margin-top:60px;""><td colspan=4>%@:  %@</td><tr>",[Language get:@"ManRegisterId" alter:@"!ManRegisterId"],[[NSUserDefaults standardUserDefaults]valueForKey:@"INFRASEC_PASSWORD"]];
//    }
    
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"POS_ID"]) {
        [str_emailFormat appendFormat:@"<tr style=""margin-top:60px;""><td colspan=4>%@:  %@</td><tr>",[Language get:@"ManRegisterId" alter:@"!ManRegisterId"],[[NSUserDefaults standardUserDefaults]valueForKey:@"POS_ID"]];
    }
    
    // Recipt Date
    
    [str_emailFormat  appendString:@"<tr class=""heading"">"];
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    // Convert date object into desired format
    [dateFormatter setDateFormat:@"HH:mm PM"];
    
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc]init];
    //            [dateFormatter1 setDateFormat:@"MMM"];
    [dateFormatter1 setDateFormat:@"dd MMMM yyyy"];
    
    NSDate *dayDate=[NSDate date];
    NSString *dateString;
    
    
    
    NSDate *currDate = dayDate;
    
    
    //            NSString *str_timeZone=nil;
    
    //            if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"language"]isEqualToString:@"EN"]) {
    //
    //                str_timeZone=@"GMT";
    //            }
    //            else
    //            {
    //                str_timeZone=@"CET";
    //            }
    [dateFormatter1 setDateFormat:@"MMM"];
    
    NSString *str_month = nil;
    str_month = [dateFormatter1 stringFromDate:dayDate];
    
    
    if([str_month isEqualToString:@"Jan"])
    {
        str_month=[Language get:@"Jan" alter:@"!Jan"];
    }
    else if([str_month isEqualToString:@"Feb"])
    {
        str_month=[Language get:@"Feb" alter:@"!Feb"];
    }
    else if([str_month isEqualToString:@"Mar"])
    {
        str_month=[Language get:@"Mar" alter:@"!Mar"];
    }
    else if([str_month isEqualToString:@"Apr"])
    {
        str_month=[Language get:@"Apr" alter:@"!Apr"];
    }
    else if([str_month isEqualToString:@"May"])
    {
        str_month=[Language get:@"May" alter:@"!May"];
    }
    else if([str_month isEqualToString:@"Jun"])
    {
        str_month=[Language get:@"Jun" alter:@"!Jun"];
    }
    else if([str_month isEqualToString:@"Jul"])
    {
        str_month=[Language get:@"Jul" alter:@"!Jul"];
    }
    else if([str_month isEqualToString:@"Aug"])
    {
        str_month=[Language get:@"Aug" alter:@"!Aug"];
    }
    else if([str_month isEqualToString:@"Sep"])
    {
        str_month=[Language get:@"Sep" alter:@"!Sep"];
    }
    else if([str_month isEqualToString:@"Oct"])
    {
        str_month=[Language get:@"Oct" alter:@"!Oct"];
    }
    else if([str_month isEqualToString:@"Nov"])
    {
        str_month=[Language get:@"Nov" alter:@"!Nov"];
    }
    else if([str_month isEqualToString:@"Dec"])
    {
        str_month=[Language get:@"Dec" alter:@"!Dec"];
    }
    
    [dateFormatter1 setDateFormat:@"dd"];
    
    NSString *str_day = [dateFormatter1 stringFromDate:currDate];
    
    [dateFormatter1 setDateFormat:@"yyyy"];
    
    NSString *str_year = [dateFormatter1 stringFromDate:currDate];
    
    dateString=[NSString stringWithFormat:@"%@ %@ %@",str_day,str_month,str_year];
    
    
    
    [str_emailFormat appendFormat:@"<td>%@: </td><td>%@</td><td>&nbsp;<td><td>%@: %@</td></tr>",[Language get:@"Date" alter:@"!Date"], dateString,[Language get:@"Time" alter:@"!Time"],[dateFormatter stringFromDate:[NSDate date]]];
    
    [str_emailFormat  appendString:[NSString stringWithFormat:@"<tr><td colspan=4><strong>%@\n</strong></td></tr>", [NSString stringWithFormat:@"%@&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;%@&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;%@&nbsp;\n\n",[Language get:@"S No" alter:@"!S No"],[Language get:@"Date" alter:@"!Date"],[Language get:@"Description" alter:@"!Description"]]]];
    
    
    for (int i=0; i<[appDelegate.arrayPrintLog count]; i++) {
    
        NSString *stringDateTime;
        stringDateTime = [NSString stringWithFormat:@"%@",[[appDelegate.arrayPrintLog valueForKey:@"date"] objectAtIndex:i]];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"dd MMMM yyyy, hh:mm:ss"];
        
//        NSDate *date=[dateFormatter dateFromString:stringDateTime];
        
        
        [dateFormatter setDateFormat:@"dd-MMM-yyyy"];
        
//        NSString *printDate=[dateFormatter stringFromDate:date];
        
        NSString *strFormat=[NSString stringWithFormat:@"&nbsp;&nbsp;&nbsp;%@&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;%@&nbsp;&nbsp;&nbsp;&nbsp;%@",[NSString stringWithFormat:@"%@",[[appDelegate.arrayPrintLog valueForKey:@"sno"] objectAtIndex:i]],stringDateTime,[NSString stringWithFormat:@"%@",[[appDelegate.arrayPrintLog valueForKey:@"discription"] objectAtIndex:i]]];
        
    
    [str_emailFormat  appendString:[NSString stringWithFormat:@"<tr><td colspan=4>%@\n</td></tr>",strFormat]];
    
    }
    
    if ([self validateDictionaryValueForKey:[dictHeaderFooter valueForKey:@"row6"]]) {
        [str_emailFormat appendFormat:@"<tr><td colspan=4 class=""align"">%@</td></tr>",[dictHeaderFooter valueForKey:@"row6"]];
    }
    if ([self validateDictionaryValueForKey:[dictHeaderFooter valueForKey:@"row7"]]) {
        
        [str_emailFormat appendFormat:@"<tr><td colspan=4 class=""align"">%@</td></tr>",[dictHeaderFooter valueForKey:@"row7"]];
    }
    if ([self validateDictionaryValueForKey:[dictHeaderFooter valueForKey:@"row8"]]) {
        [str_emailFormat appendFormat:@"<tr><td colspan=4 class=""align"">%@</td></tr>",[dictHeaderFooter valueForKey:@"row8"]];
    }
    if ([self validateDictionaryValueForKey:[dictHeaderFooter valueForKey:@"row9"]]) {
        [str_emailFormat appendFormat:@"<tr><td colspan=4 class=""align"">%@</td></tr>",[dictHeaderFooter valueForKey:@"row9"]];
    }
    
    if ([self validateDictionaryValueForKey:[dictHeaderFooter valueForKey:@"row10"]]) {
        [str_emailFormat appendFormat:@"<tr><td colspan=4 class=""align"">%@</td></tr>",[dictHeaderFooter valueForKey:@"row10"]];
    }
    [str_emailFormat appendFormat:@"<tr class=""buying""><td colspan=4></td></tr></table></div></div></body></html>"];
}


#pragma mark coredata Start

-(void)getData
{
    appDelegate =[[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context =
    [appDelegate managedObjectContext];
    
    NSEntityDescription *entityDesc =
    [NSEntityDescription entityForName:@"Article"
                inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
    NSPredicate *pred =
    [NSPredicate predicateWithFormat:@"(article_no = %@)",
     [[array_ArticleDetails objectAtIndex:saveIndex] valueForKey:@"ArticleNumber"]];
    [request setPredicate:pred];
    NSManagedObject *matches = nil;
    
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request
                                              error:&error];
    
    if ([objects count] == 0) {
        
        [self saveArticleDetails];
        
    } else {
        
        
        [self editArticleDetails];
        
    }
}

-(void)saveArticleDetails   ////To save Article data in database//////
{
    NSString *articleid=@"";
    
    appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context =[appDelegate managedObjectContext];
    NSEntityDescription *entityDesc =[NSEntityDescription entityForName:@"Article" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    articleid=[NSString stringWithFormat:@"IS%d",(int)(100000+[objects count]+1)];
    
    
    NSManagedObject *newContact;
    newContact = [NSEntityDescription insertNewObjectForEntityForName:@"Article" inManagedObjectContext:context];
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *NumberVat = [f numberFromString:[[array_ArticleDetails objectAtIndex:saveIndex] valueForKey:@"Vat"]];
    [newContact setValue:NumberVat forKey:@"vat"];
    //    [newContact setValue:[[array_ArticleDetails objectAtIndex:saveIndex] valueForKey:@"Unit"] forKey:@"unit_type"];
    [newContact setValue:NumberVat forKey:@"unit_type"];
    NSNumber *NumberPrice = [f numberFromString:[[array_ArticleDetails objectAtIndex:saveIndex] valueForKey:@"PriceIncVat"]];
    [newContact setValue:NumberPrice forKey:@"price"];
    NSNumber *NumberDiscount = [f numberFromString:[[array_ArticleDetails objectAtIndex:saveIndex] valueForKey:@"CostPrice"]];
    [newContact setValue:NumberDiscount forKey:@"discount"];
    [newContact setValue:[[array_ArticleDetails objectAtIndex:saveIndex] valueForKey:@"Description"] forKey:@"article_description"];
    [newContact setValue:[[array_ArticleDetails objectAtIndex:saveIndex] valueForKey:@"Name"] forKey:@"name"];
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    // Convert date object into desired format
    [dateFormatter setDateFormat:@"YYYY-MM-dd\'T\'HH:mm:ssZZZZZ"];
    NSDate *lastModiDate;
    lastModiDate = [dateFormatter dateFromString:[[array_ArticleDetails objectAtIndex:saveIndex] valueForKey:@"LastModified"]];
    
    
    
    
    [newContact setValue:lastModiDate forKey:@"modified_date"];
    [newContact setValue:lastModiDate forKey:@"created_date"];
    [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm"];

    [newContact setValue:[[array_ArticleDetails objectAtIndex:saveIndex] valueForKey:@"ArticleNumber"] forKey:@"article_no"];
    [newContact setValue:UIImagePNGRepresentation([UIImage imageNamed:@"block_Image.png"]) forKey:@"article_img_url"];
    [newContact setValue:[NSNumber numberWithInt:(int)[objects count]+1] forKey:@"article_id"];
    [context save:&error];
 
    
}


-(void)editArticleDetails  ////To edit Article data in database//////
{
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context =
    [appDelegate managedObjectContext];
    NSManagedObject *editContext;
    editContext = [NSEntityDescription
                   insertNewObjectForEntityForName:@"Article"
                   inManagedObjectContext:context];
    
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *NumberVat = [f numberFromString:[[array_ArticleDetails objectAtIndex:saveIndex] valueForKey:@"Vat"]];
    [editContext setValue:NumberVat forKey:@"vat"];
    //    [newContact setValue:[[array_ArticleDetails objectAtIndex:saveIndex] valueForKey:@"Unit"] forKey:@"unit_type"];
    [editContext setValue:NumberVat forKey:@"unit_type"];
    NSNumber *NumberPrice = [f numberFromString:[[array_ArticleDetails objectAtIndex:saveIndex] valueForKey:@"PriceIncVat"]];
    [editContext setValue:NumberPrice forKey:@"price"];
    NSNumber *NumberDiscount = [f numberFromString:[[array_ArticleDetails objectAtIndex:saveIndex] valueForKey:@"CostPrice"]];
    [editContext setValue:NumberDiscount forKey:@"discount"];
    [editContext setValue:[[array_ArticleDetails objectAtIndex:saveIndex] valueForKey:@"Description"] forKey:@"article_description"];
    [editContext setValue:[[array_ArticleDetails objectAtIndex:saveIndex] valueForKey:@"Name"] forKey:@"name"];
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    // Convert date object into desired format
    [dateFormatter setDateFormat:@"YYYY-MM-dd\'T\'HH:mm:ssZZZZZ"];
    NSDate *lastModiDate;
    lastModiDate = [dateFormatter dateFromString:[[array_ArticleDetails objectAtIndex:saveIndex] valueForKey:@"LastModified"]];
    
    
    [editContext setValue:lastModiDate forKey:@"modified_date"];
    [editContext setValue:lastModiDate forKey:@"created_date"];
    [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm"];

    [editContext setValue:UIImagePNGRepresentation([UIImage imageNamed:@"block_Image.png"]) forKey:@"article_img_url"];
    
    NSError *error;
    [context save:&error];
    
}


#pragma mark GlobalData 

-(void)PrintAndMailCountUpdate:(int)value amount:(float)totalAmount
{
    
//    1 for Original Mail
//    2 for Original Print
//    3 for Copy Mail
//    4 for Copy Print
//    5 for refund
    
    
    NSManagedObjectContext *contextz =[appDelegate managedObjectContext];
    NSEntityDescription *entityDescRec =[NSEntityDescription entityForName:@"GlobalVariables" inManagedObjectContext:contextz];
    NSFetchRequest *requestRec = [[NSFetchRequest alloc] init];
    [requestRec setEntity:entityDescRec];
    NSError *errorz;
    NSArray *objectsRec = [contextz executeFetchRequest:requestRec error:&errorz];
    NSManagedObject *persoRec = (NSManagedObject *)[objectsRec lastObject];
    
    int x = 0;
    int xz = 0;
    float amount = 0;
    float amountz = 0;
    
    if (value==1) {
        
        x=[[persoRec valueForKey:@"originalMail"] intValue]+1;
        xz=[[persoRec valueForKey:@"originalMailZDay"] intValue]+1;
        
    }
    
    if (value==2) {
        
        x=[[persoRec valueForKey:@"originalPrint"] intValue]+1;
        xz=[[persoRec valueForKey:@"originalPrintZDay"] intValue]+1;
    }
    
    if (value==3) {
        
        x=[[persoRec valueForKey:@"copyMail"] intValue]+1;
        xz=[[persoRec valueForKey:@"copyMailZDay"] intValue]+1;
        amount=[[persoRec valueForKey:@"totalCopyMailAmount"] floatValue]+totalAmount;
        amountz=[[persoRec valueForKey:@"totalCopyMailAmountZDay"] floatValue]+totalAmount;
    }
    
    if (value==4) {
        
        x=[[persoRec valueForKey:@"copyPrint"] intValue]+1;
        xz=[[persoRec valueForKey:@"copyPrintZDay"] intValue]+1;
        amount=[[persoRec valueForKey:@"totalCopyPrintAmount"] floatValue]+totalAmount;
        amountz=[[persoRec valueForKey:@"totalCopyPrintAmountZDay"] floatValue]+totalAmount;
    }
    
    if (value==5) {
        
        x=[[persoRec valueForKey:@"refund"] intValue]+1;
        xz=[[persoRec valueForKey:@"refundZDay"] intValue]+1;
    }
    
    
    NSString *str_UpdateValue=[NSString stringWithFormat:@"%d",x];
    NSString *str_UpdateValueZ=[NSString stringWithFormat:@"%d",xz];
    NSString *str_UpdateAmount=[NSString stringWithFormat:@"%.2f",amount];
    
    NSManagedObjectContext *context =[appDelegate managedObjectContext];
    NSError *error;
    NSEntityDescription *entityDescc =[NSEntityDescription entityForName:@"GlobalVariables" inManagedObjectContext:context];
    NSFetchRequest *requestt = [[NSFetchRequest alloc] init];
//    NSPredicate *predicate;
//    predicate = [NSPredicate predicateWithFormat:@"(id = %@)", Id];
//    [requestt setPredicate:predicate];
    [requestt setEntity:entityDescc];
    
    NSArray *objectss = [context executeFetchRequest:requestt error:&error];
    if ([objectss count] == 0) {
        
    }
    else
    {
        for (int i=0; i<[objectss count]; i++) {
            
            NSManagedObject *obj=(NSManagedObject *)[objectss objectAtIndex:i];
         
            if (value==1) {
                
                [obj setValue:str_UpdateValue forKey:@"originalMail"];
                [obj setValue:str_UpdateValueZ forKey:@"originalMailZDay"];
            }
            
            if (value==2) {
                
                [obj setValue:str_UpdateValue forKey:@"originalPrint"];
                [obj setValue:str_UpdateValueZ forKey:@"originalPrintZDay"];
            }
            
            if (value==3) {
                
                [obj setValue:str_UpdateValue forKey:@"copyMail"];
                [obj setValue:str_UpdateValueZ forKey:@"copyMailZDay"];
                [obj setValue:str_UpdateAmount forKey:@"totalCopyMailAmount"];
                [obj setValue:str_UpdateAmount forKey:@"totalCopyMailAmountZDay"];
            }
            
            if (value==4) {
                
                [obj setValue:str_UpdateValue forKey:@"copyPrint"];
                [obj setValue:str_UpdateValueZ forKey:@"copyPrintZDay"];
                [obj setValue:str_UpdateAmount forKey:@"totalCopyPrintAmount"];
                [obj setValue:str_UpdateAmount forKey:@"totalCopyPrintAmountZDay"];
            }
            
            if (value==5) {
                
                [obj setValue:str_UpdateValue forKey:@"refund"];
                [obj setValue:str_UpdateValueZ forKey:@"refundZDay"];
            }
            
            [context save:&error];
            
         }
        
    }
    [self fetch_globalData];
   
}

-(void)refundCountUpdate:(int)value :(int)index
{
    
    //    1 for Original Mail
    //    2 for Original Print
    //    3 for Copy Mail
    //    4 for Copy Print
    //    5 for refund
    
    
    
    NSManagedObjectContext *contextz =[appDelegate managedObjectContext];
    NSEntityDescription *entityDescRec =[NSEntityDescription entityForName:@"GlobalVariables" inManagedObjectContext:contextz];
    NSFetchRequest *requestRec = [[NSFetchRequest alloc] init];
    [requestRec setEntity:entityDescRec];
    NSError *errorz;
    NSArray *objectsRec = [contextz executeFetchRequest:requestRec error:&errorz];
    NSManagedObject *persoRec = (NSManagedObject *)[objectsRec lastObject];
    
    int x = 0;
    int xz = 0;
    
    NSString *str_UpdateValueZ = nil;
    NSString *str_UpdateValue = nil;
    
    if (index==1) {
        
        x=value;
        str_UpdateValue=[NSString stringWithFormat:@"%d",x];
    }
    
    if (index==2) {
        
        
        xz=value;
        str_UpdateValueZ=[NSString stringWithFormat:@"%d",xz];
    }
    
    
    
    
    
    
    
    NSManagedObjectContext *context =[appDelegate managedObjectContext];
    NSError *error;
    NSEntityDescription *entityDescc =[NSEntityDescription entityForName:@"GlobalVariables" inManagedObjectContext:context];
    NSFetchRequest *requestt = [[NSFetchRequest alloc] init];
    //    NSPredicate *predicate;
    //    predicate = [NSPredicate predicateWithFormat:@"(id = %@)", Id];
    //    [requestt setPredicate:predicate];
    [requestt setEntity:entityDescc];
    
    NSArray *objectss = [context executeFetchRequest:requestt error:&error];
    if ([objectss count] == 0) {
        
    }
    else
    {
        for (int i=0; i<[objectss count]; i++) {
            
            NSManagedObject *obj=(NSManagedObject *)[objectss objectAtIndex:i];
            
            if (index==1) {
                
                [obj setValue:str_UpdateValue forKey:@"refund"];
            }
            
            if (index==2) {
                
                [obj setValue:str_UpdateValueZ forKey:@"refundZDay"];
            }
            
            [context save:&error];
            
            
        }
        
    }
    [self fetch_globalData];
    
}

-(void)fetch_globalData
{
    appDelegate.arrayGlobalData=[[NSMutableArray alloc] init];
    
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context =[appDelegate managedObjectContext];
    NSEntityDescription *entityDescc =[NSEntityDescription entityForName:@"GlobalVariables" inManagedObjectContext:context];
    NSFetchRequest *requestt = [[NSFetchRequest alloc] init];
//    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"id.intValue" ascending:NO];
//    NSArray *descriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
//    [requestt setSortDescriptors:descriptors];
    [requestt setEntity:entityDescc];
    NSManagedObject *matches = nil;
    NSError *error;
    NSArray *objectss = [context executeFetchRequest:requestt error:&error];
    if ([objectss count] == 0) {
        
    } else {
        
        NSMutableDictionary *dict;
        
        for(int i=0;i<[objectss count];i++)
        {
            matches=(NSManagedObject*)[objectss objectAtIndex:i];
            
            
            dict = [[NSMutableDictionary alloc] init];
            
            [dict setObject:[matches valueForKey:@"originalMail"] forKey:@"originalMail"];
            [dict setObject:[matches valueForKey:@"originalPrint"] forKey:@"originalPrint"];
            [dict setObject:[matches valueForKey:@"copyMail"] forKey:@"copyMail"];
            [dict setObject:[matches valueForKey:@"copyPrint"] forKey:@"copyPrint"];
            [dict setObject:[matches valueForKey:@"originalMailZDay"] forKey:@"originalMailZDay"];
            [dict setObject:[matches valueForKey:@"originalPrintZDay"] forKey:@"originalPrintZDay"];
            [dict setObject:[matches valueForKey:@"copyMailZDay"] forKey:@"copyMailZDay"];
            [dict setObject:[matches valueForKey:@"copyPrintZDay"] forKey:@"copyPrintZDay"];
            [dict setObject:[matches valueForKey:@"refund"] forKey:@"refund"];
            [dict setObject:[matches valueForKey:@"refundZDay"] forKey:@"refundZDay"];
            [dict setObject:[matches valueForKey:@"totalCopyMailAmount"] forKey:@"totalCopyMailAmount"];
            [dict setObject:[matches valueForKey:@"totalCopyPrintAmount"] forKey:@"totalCopyPrintAmount"];
            [dict setObject:[matches valueForKey:@"totalCopyMailAmountZDay"] forKey:@"totalCopyMailAmountZDay"];
            [dict setObject:[matches valueForKey:@"totalCopyPrintAmountZDay"] forKey:@"totalCopyPrintAmountZDay"];
            
            [appDelegate.arrayGlobalData addObject:dict];
            
        }
    }
   
}


-(void)resetZdayGlobalValue
{
    NSManagedObjectContext *context =[appDelegate managedObjectContext];
    NSError *error;
    NSEntityDescription *entityDescc =[NSEntityDescription entityForName:@"GlobalVariables" inManagedObjectContext:context];
    NSFetchRequest *requestt = [[NSFetchRequest alloc] init];
    //    NSPredicate *predicate;
    //    predicate = [NSPredicate predicateWithFormat:@"(id = %@)", Id];
    //    [requestt setPredicate:predicate];
    [requestt setEntity:entityDescc];
    
    NSArray *objectss = [context executeFetchRequest:requestt error:&error];
    if ([objectss count] == 0) {
        
    }
    else
    {
        for (int i=0; i<[objectss count]; i++)
        {
            
            NSManagedObject *obj=(NSManagedObject *)[objectss objectAtIndex:i];
            
            
            [obj setValue:@"0" forKey:@"originalMailZDay"];
            
            [obj setValue:@"0" forKey:@"originalPrintZDay"];
            
            [obj setValue:@"0" forKey:@"copyMailZDay"];
            
            [obj setValue:@"0" forKey:@"copyPrintZDay"];
            
            [obj setValue:@"0" forKey:@"refundZDay"];
            
            [obj setValue:@"0.0" forKey:@"totalCopyMailAmountZDay"];
            
            [obj setValue:@"0.0" forKey:@"totalCopyPrintAmountZDay"];
            
            
            [context save:&error];
            
            
        }
        
    }
}


#pragma mark end core data

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
    
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;

@synthesize managedObjectModel = _managedObjectModel;

@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


- (NSURL *)applicationDocumentsDirectory
{
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.impinge.ISUPOS" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel
{
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"ISUPOS" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil)
    {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"ISUPOS.sqlite"];
 
    NSError *error = nil;
    
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        
        dict[NSUnderlyingErrorKey] = error;
        
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext
{
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil)
    {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    
    if (!coordinator)
    {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    
    return _managedObjectContext;
}


#pragma mark - Core Data Saving support

- (void)saveContext
{
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    
    if (managedObjectContext != nil)
    {
        NSError *error = nil;
        
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            
            abort();
        }
    }
}



#pragma mark - UITabBar

- (void)loadTabBarController
{
    HomeViewController *homeVC = [[HomeViewController alloc] init];
    
    articalsViewController *articleVC = [[articalsViewController alloc] init];
    
    receiptsViewController *receiptsVC = [[receiptsViewController alloc] init];
    
    ParkRecieptViewController *parkReceiptsVC = [[ParkRecieptViewController alloc] init];
    
    MoreViewController *moreVC = [[MoreViewController alloc] init];
    
    self.tabBarQuickButtons = [[UITabBarController alloc] init];
    
    if(IS_OS_7_OR_LATER)
    {
        [[UITabBar appearance] setTintColor:[UIColor colorWithRed:(244.0/255.0) green:(176.0/255.0) blue:(3.0/255.0) alpha:1.0]];
    }
    else
    {
        [self.tabBarQuickButtons.tabBar setSelectedImageTintColor:[UIColor colorWithRed:(244.0/255.0) green:(176.0/255.0) blue:(3.0/255.0) alpha:1.0]];
    }
    
    [self.tabBarQuickButtons setViewControllers:[NSArray arrayWithObjects:homeVC, articleVC, receiptsVC, parkReceiptsVC, moreVC, nil]];
    
    UITabBarItem *tabItem1 = [[[self.tabBarQuickButtons tabBar] items] objectAtIndex:0];
    
    [tabItem1 setTitle:@"Quick Buttons"];
    
    [tabItem1 setImage:IMAGE_FROM_BUNDLE(@"QuickButtonsIcon")];
    
    
    UITabBarItem *tabItem2 = [[[self.tabBarQuickButtons tabBar] items] objectAtIndex:1];
    
    [tabItem2 setTitle:@"Articles"];
    
    [tabItem2 setImage:IMAGE_FROM_BUNDLE(@"ArticlesIcon")];
    
    
    UITabBarItem *tabItem3 = [[[self.tabBarQuickButtons tabBar] items] objectAtIndex:2];
    
    [tabItem3 setTitle:@"Receipts"];
    
    [tabItem3 setImage:IMAGE_FROM_BUNDLE(@"ReceiptsIcon")];
    
    
    UITabBarItem *tabItem4 = [[[self.tabBarQuickButtons tabBar] items] objectAtIndex:3];
    
    [tabItem4 setTitle:@"Park Receipts"];
    
    [tabItem4 setImage:IMAGE_FROM_BUNDLE(@"ParkReceiptIcon")];
    
    
    UITabBarItem *tabItem5 = [[[self.tabBarQuickButtons tabBar] items] objectAtIndex:3];
    
    [tabItem5 setTitle:@"More"];
    
    [tabItem5 setImage:IMAGE_FROM_BUNDLE(@"MoreIcon")];
    //[tabItem4 setImage:[UIImage imageNamed:@"notification_footer_btn.png"]];
    
    
    [self.tabBarQuickButtons setSelectedIndex:1];
    
    [self.navigation pushViewController:self.tabBarQuickButtons animated:YES];
}


-(void)clearCart
{
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context =[appDelegate managedObjectContext];
    NSError *error;
    NSFetchRequest *request1 = [NSFetchRequest fetchRequestWithEntityName:@"Cart"];
    NSArray *objects1 = [context executeFetchRequest:request1 error:&error];
    if (objects1 == nil) {
        // handle error
    } else {
        for (NSManagedObject *object in objects1) {
            [context deleteObject:object];
        }
        [context save:&error];
    }
    
    
    NSFetchRequest *request2 = [NSFetchRequest fetchRequestWithEntityName:@"CustomDiscount"];
    
    NSPredicate *predicate;
    predicate = [NSPredicate predicateWithFormat:@"(id = %@)",@"1S"];
    [request2 setPredicate:predicate];
    
    NSArray *objects2 = [context executeFetchRequest:request2 error:&error];
    //    NSMutableArray *objects3 = [NSMutableArray arrayWithArray:objects2];
    if (objects2 == nil) {
        // handle error
    } else {
        
        
        //        NSManagedObject *objectToBeDeleted = [objects3 removeLastObject];
        
        for (NSManagedObject *object in objects2) {
            [context deleteObject:object];
        }
        [context save:&error];
    }
    
 
}


@end

