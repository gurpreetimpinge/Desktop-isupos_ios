//
//  paymentViewController.m
//  ISUPOS
//
//  Created by Rohit Mahajan on 6/23/15.
//  Copyright (c) 2015 Impinge Solutions. All rights reserved.
//

#import "paymentViewController.h"
#import "thankyouViewController.h"
#import "Language.h"
#import <AudioToolbox/AudioToolbox.h>
#import "MBProgressHUD.h"
#import "Reachability.h"
#import <mpos.core/mpos-extended.h>
#import "UITextField+Validations.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "CommonMethods.h"
#import "ISUPosSoapService.h"

@interface paymentViewController () <NSURLConnectionDelegate, NSURLAuthenticationChallengeSender, NSURLConnectionDataDelegate,NSXMLParserDelegate,EAAccessoryDelegate,NSStreamDelegate>
{
    
    AppDelegate *appDelegate;
    UIPopoverController *popover;
    NSString *currencySign;
    NSString *str_trnsCode;
    float zzzz, total, totalvat;
    
    NSString *str_Multiple;
    NSString *str_DiscountType;
    int int_TotalVat;
    float float_Discount;
    float float_TotalPrice;
    NSMutableArray *arrayAmount,*arrayVat;
    float finalTotal;
    NSMutableArray *dictAllItems;
    NSString *text_string;
    NSMutableDictionary *dictSub;
    int selectedRow,selectedSection;
    NSString *str_transactionId;
    
    UIAlertView *alertView_payment;
    
    NSString *portName;
    NSString *portSettings;
    
    MPTransactionProcess *process;
    MPTransaction *completedTransaction;
    int receiptMethodTag;
    
    IBOutlet UIView *view_EmailPopUpBg,*view_EmailBg;
    IBOutlet UITextField *txt_Email;
    IBOutlet UIButton *btn_DropDown,*btn_EmailOk,*btn_EmailCancel;
    IBOutlet UITableView *tbl_EmailList;
    
    NSMutableArray *ary_EmailList;
    
    float exchange;
    
}
@property (weak, nonatomic) IBOutlet UIView *transactionView;
@property (weak, nonatomic) IBOutlet UIButton *btnprint_cardPaymentReceipt;
@property (weak, nonatomic) IBOutlet UIButton *btnMail_cardPaymentReceipt;

@property (nonatomic, strong) NSXMLParser *xmlParser;
@property (nonatomic, strong) NSMutableArray *mutArray;
@property (nonatomic, strong) NSMutableDictionary *mutDictionary;
@property (nonatomic, strong) NSMutableString *foundValue;
@property (nonatomic, strong) NSString *currentElement;
- (IBAction)actionBuyCardReader:(UIButton *)sender;
- (IBAction)actionGetHelp:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *abort_action;
- (IBAction)abortButton_action:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UILabel *lblTransactionStatus_Title;

@property (weak, nonatomic) IBOutlet UILabel *lblTransactionStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblTransactionStatus2;
@end

@implementation paymentViewController
@synthesize callBack;
@synthesize str_PaymentMethod;
@synthesize str_QuickBlockName;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
  
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    exchange = 0;
    
//    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"language"] isEqualToString:@"SE"])
//    {
//       // b1.frame = CGRectMake(70, 365, 565, 53);
//        btn_Cash.frame = CGRectMake(15, 436, 565, 53);
//    }
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"SwishPaymentOn"] && [[NSUserDefaults standardUserDefaults] boolForKey:@"OtherPaymentOn"])
    {
//        btn_Swish.hidden = NO;
//        btn_Other.hidden = NO;
//        view_PaymentDivider.hidden = NO;
//        
//        btn_Swish.frame = CGRectMake(2, 504, 279, 53);
//        btn_Other.frame = CGRectMake(281, 504, 279, 53);
//        
//        btn_Swish.imageEdgeInsets = UIEdgeInsetsMake(0, -153, 0, 0);
//        btn_Swish.titleEdgeInsets = UIEdgeInsetsMake(0, -140, 0, 0);
//        
//        btn_Other.imageEdgeInsets = UIEdgeInsetsMake(0, 145, 0, 0);
//        btn_Other.titleEdgeInsets = UIEdgeInsetsMake(0, 165, 0, 0);
        
        btn_Swish.enabled = YES;
        btn_Swish.alpha = 1;
        btn_Other.enabled = YES;
        btn_Other.alpha = 1;
        
    }
    else if([[NSUserDefaults standardUserDefaults] boolForKey:@"SwishPaymentOn"])
    {
//        btn_Swish.frame = CGRectMake(2, 504, 279, 53);
//        btn_Other.hidden = YES;
//        view_PaymentDivider.hidden = YES;
//        
//        btn_Swish.imageEdgeInsets = UIEdgeInsetsMake(0, -153, 0, 0);
//        btn_Swish.titleEdgeInsets = UIEdgeInsetsMake(0, -140, 0, 0);
        
        btn_Swish.enabled = YES;
        btn_Swish.alpha = 1;
        btn_Other.enabled = NO;
        btn_Other.alpha = 0.5;
    }
    else if([[NSUserDefaults standardUserDefaults] boolForKey:@"OtherPaymentOn"])
    {
        btn_Other.frame = CGRectMake(2, 504, 279, 53);
        btn_Swish.hidden = YES;
        view_PaymentDivider.hidden = YES;
        
        btn_Other.imageEdgeInsets = UIEdgeInsetsMake(0, -153, 0, 0);
        btn_Other.titleEdgeInsets = UIEdgeInsetsMake(0, -140, 0, 0);
        
        btn_Swish.enabled = NO;
        btn_Swish.alpha = 0.5;
        btn_Other.enabled = YES;
        btn_Other.alpha = 1;
    }
    else
    {
        btn_Swish.enabled = NO;
        btn_Swish.alpha = 0.5;
        btn_Other.enabled = NO;
        btn_Other.alpha = 0.5;
    }
    
    if(str_trnsCode == nil)
    {
        str_trnsCode = @"";
        
    }
    
    self.transactionView.hidden = YES;
    [self enableEmail_PrintButtons:YES];
    self.btnprint_cardPaymentReceipt.hidden = YES;
    self.btnMail_cardPaymentReceipt.hidden = YES;
    text_string = @"BT:PRNT Star";
    
    [self setPortInfo];
    portName = [AppDelegate getPortName];
    portSettings = [AppDelegate getPortSettings];
    [MiniPrinterFunctions CheckStatusWithPortname:portName portSettings:portSettings sensorSetting:SensorActiveHigh];
    
    amountFeild.inputView = [[[NSBundle mainBundle] loadNibNamed:@"LNNumberpad" owner:self options:nil] objectAtIndex:0];
    [okBtn setEnabled:false];
    [okBtn setBackgroundColor:[UIColor lightGrayColor]];
    
    [btnEmail setEnabled:false];
    [btnEmail setBackgroundColor:[UIColor lightGrayColor]];
    
    [btnNone setEnabled:false];
    [btnNone setBackgroundColor:[UIColor lightGrayColor]];
    
    lbltitle.text=[Language get:@"Payment Method" alter:@"!Payment Method"];
    tenderdLbl.text=[Language get:@"Total" alter:@"!Total"];
//    [b1 setTitle:[Language get:@"Manual Entry" alter:@"!Manual Entry"] forState:UIControlStateNormal];
    [btn_Card setTitle:[Language get:@"Card Payment" alter:@"!Card Payment"] forState:UIControlStateNormal];
    [btn_Cash setTitle:[Language get:@"Cash" alter:@"!Cash"] forState:UIControlStateNormal];
    [btn_Swish setTitle:@"Swish" forState:UIControlStateNormal];
    [btn_Other setTitle:[Language get:@"Other" alter:@"!Other"] forState:UIControlStateNormal];
    
    //detect if card reader attached
    
    EAAccessory *currentAccessory = [self checkExternalAccessory];
    if(!currentAccessory)
    {
        self.labelConnectCReader.hidden=NO;
        self.btnBuyCardReader.hidden=NO;
        self.btnGetHelp.hidden=NO;
    self.LabelNoReaderConnected.text=[Language get:@"No card reader connected" alter:@"!No card reader connected"];
    self.labelConnectCReader.text=[Language get:@"Connect an ISUPOS card reader to accept easy card payments." alter:@"!Connect an ISUPOS card reader to accept easy card payments."];
    [self.btnBuyCardReader setTitle:[Language get:@"Buy card reader" alter:@"!Buy card reader"] forState:UIControlStateNormal];
    [self.btnGetHelp setTitle:[Language get:@"Get help" alter:@"!Get help"] forState:UIControlStateNormal];
    }
    else
    {
        self.labelConnectCReader.hidden=YES;
        self.btnBuyCardReader.hidden=YES;
        self.btnGetHelp.hidden=YES;
        self.LabelNoReaderConnected.text=[Language get:@"Miura card reader connected" alter:@"!Miura card reader connected"];
    }
//    [self.cancelButton setTitle:[Language get:@"Cancel" alter:@"!Cancel"] forState:UIControlStateNormal];
//    [self.CancelButtonNext setTitle:[Language get:@"Cancel" alter:@"!Cancel"] forState:UIControlStateNormal];
    
    [self.Cancel_Button_Payment setTitle:[Language get:@"Cancel" alter:@"!Cancel"] forState:UIControlStateNormal];
    [self.Cancel_Button setTitle:[Language get:@"Cancel" alter:@"!Cancel"] forState:UIControlStateNormal];
    [btnEmail setTitle:[Language get:@"Email" alter:@"!Email"] forState:UIControlStateNormal];
    [btnNone setTitle:[Language get:@"None" alter:@"!None"] forState:UIControlStateNormal];
    [okBtn setTitle:[Language get:@"Print" alter:@"!Print"] forState:UIControlStateNormal];

    self.view.superview.layer.cornerRadius = 0;
    
    NSManagedObjectContext *context =[appDelegate managedObjectContext];
    NSError *error;
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
    }
    
    
//    NSManagedObject *newContact;
//    newContact = [NSEntityDescription insertNewObjectForEntityForName:@"Log" inManagedObjectContext:context];
//    
//    [newContact setValue:[NSDate date] forKey:@"date"];
//    [newContact setValue:[Language get:@"Payment Method" alter:@"!Payment Method"] forKey:@"discription"];
//    [newContact setValue:@"" forKey:@"sno"];
//    
//    [context save:&error];
    
}
- (IBAction)print_cardpayment_action:(UIButton *)sender {
    
     [self enableEmail_PrintButtons:NO];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"No" forKey:@"None"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [MiniPrinterFunctions CheckStatusWithPortname:portName portSettings:portSettings sensorSetting:SensorActiveHigh];
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"PrinterStatus"] isEqualToString:@"Online"]) {
        
        receiptMethodTag=1;
        
        [[NSUserDefaults standardUserDefaults] setObject:@"Print" forKey:@"receipt_output_mode"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self VibrateandSound];
        [self saveDataAfterpayment];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ISUPOS" message:@"Printer not connected." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }

   
}


- (void)enableEmail_PrintButtons:(BOOL)value {
    
    self.btnMail_cardPaymentReceipt.enabled = value;
    self.btnprint_cardPaymentReceipt.enabled = value;
    
}

- (IBAction)email_cardPayment_action:(UIButton *)sender {
    
     [self enableEmail_PrintButtons:NO];
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    if (internetStatus != NotReachable) {
        
        
        NSManagedObjectContext *context =[appDelegate managedObjectContext];
        NSEntityDescription *entityDesc2 =[NSEntityDescription entityForName:@"EmailList" inManagedObjectContext:context];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entityDesc2];
        
        NSArray *objects2 = [context executeFetchRequest:request error:nil];
        NSManagedObject *matches = nil;
        
        [ary_EmailList removeAllObjects];
        
        for(int i=0;i<[objects2 count];i++)
        {
            matches=(NSManagedObject*)[objects2 objectAtIndex:i];
            NSLog(@"arr:%@",[matches valueForKey:@"emailId"]);
            [ary_EmailList addObject:[matches valueForKey:@"emailId"]];
            
        }
        
        [UIView beginAnimations:@"animate" context:nil];
        [UIView setAnimationDuration:0.35f];
        [UIView setAnimationBeginsFromCurrentState: NO];
        CGRect frame = view_EmailPopUpBg.frame;
        frame.origin.x = 0;
        [view_EmailPopUpBg setFrame:frame];
        [UIView commitAnimations];
        
//        if ([[NSUserDefaults standardUserDefaults]valueForKey:@"EMAIL"]) {
//            
//            txt_Email.text = [[NSUserDefaults standardUserDefaults]valueForKey:@"EMAIL"];
//        }
//        else
//        {
            txt_Email.text = @"";
//        }
        tbl_EmailList.hidden = YES;
        
        
        CGRect frame_EmailTable = tbl_EmailList.frame;
        if ([ary_EmailList count] >3)
        {
            frame_EmailTable.size.height = 180;
        }
        else
        {
            frame_EmailTable.size.height = [ary_EmailList count]*60;
        }
        
        tbl_EmailList.frame = frame_EmailTable;
        [tbl_EmailList reloadData];
        
        
        
//        alertView_payment=[[UIAlertView alloc]initWithTitle:@"ISUPOS" message:[Language get:@"Please enter your email" alter:@"!Please enter your email"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel",nil];
//        alertView_payment.tag=104;
//        alertView_payment.alertViewStyle=UIAlertViewStylePlainTextInput;
//        [[alertView_payment textFieldAtIndex:0] setDelegate:self];
//#if (TARGET_IPHONE_SIMULATOR)
//        [[alertView_payment textFieldAtIndex:0] setText:@"meghas@impingeonline.com"];
//        
//        
//#endif
//        
//        [alertView_payment show];
        
        
        
        
        
    }
    else {
        [[[UIAlertView alloc] initWithTitle:@"ISUPOS" message:[Language get:@"Please check your internet connection." alter:@"!Please check your internet connection."] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
    
   
    
    
}

-(EAAccessory*)checkExternalAccessory
{
    
        NSArray *accessories = [[EAAccessoryManager sharedAccessoryManager]
                                connectedAccessories];
        EAAccessory *accessory = nil;
    
        for (EAAccessory *obj in accessories)
        {
            if ([[obj protocolStrings] containsObject:@"com.miura.shuttle"])
            {
               return accessory = obj;
            }
        }
        
//        if (accessory)
//        {
//            session = [[EASession alloc] initWithAccessory:accessory
//                                               forProtocol:@"com.miura.shuttle"];
//            if (session)
//            {
//                [[session inputStream] setDelegate:self];
//                [[session inputStream] scheduleInRunLoop:[NSRunLoop currentRunLoop]
//                                                 forMode:NSDefaultRunLoopMode];
//                [[session inputStream] open];
//                [[session outputStream] setDelegate:self];
//                [[session outputStream] scheduleInRunLoop:[NSRunLoop currentRunLoop]
//                                                  forMode:NSDefaultRunLoopMode];
//                [[session outputStream] open];
//            }
//        }
//        
        return nil;
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Splunk Mint Breadcrumb added
    [[Mint sharedInstance] leaveBreadcrumb:@"paymentViewController_ViewController"];
    
    view_EmailBg.layer.borderWidth = 1;
    view_EmailBg.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    
    tbl_EmailList.layer.borderWidth = 1;
    tbl_EmailList.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    
    ary_EmailList = [NSMutableArray new];
}

+ (void)setPortName:(NSString *)m_portName
{
    [AppDelegate setPortName:m_portName];
}

+ (void)setPortSettings:(NSString *)m_portSettings
{
    [AppDelegate setPortSettings:m_portSettings];
}

- (void)setPortInfo
{
    NSString *localPortName = [NSString stringWithString:text_string];
    [paymentViewController setPortName:localPortName];
    
    NSString *localPortSettings = @"mini";
    
    [paymentViewController setPortSettings:localPortSettings];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cashPayment:(UIButton*)sender
{
    
    str_PaymentMethod=@"1";
    [[NSUserDefaults standardUserDefaults] setObject:@"Cash" forKey:@"payment_mode"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSManagedObjectContext *context =[appDelegate managedObjectContext];
    NSError *error;
    NSEntityDescription *entityDesc =[NSEntityDescription entityForName:@"Setting" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    NSPredicate *pred =[NSPredicate predicateWithFormat:@"(id = %@)",@"1"];
    [request setPredicate:pred];
    NSArray *objects = [context executeFetchRequest:request error:&error];
    if(objects.count==0)
    {
        [MiniPrinterFunctions CheckStatusWithPortname:portName portSettings:portSettings sensorSetting:SensorActiveHigh];
        
        [UIView beginAnimations:@"animate" context:nil];
        [UIView setAnimationDuration:0.35f];
        [UIView setAnimationBeginsFromCurrentState: NO];
        CGRect frame = tenderdview.frame;
        frame.origin.x = 0;
        [tenderdview setFrame:frame];
        [UIView commitAnimations];
        amountLbl.text=[NSString stringWithFormat:@"%@ %.02f",currencySign,totalamount];
        amountFeild.placeholder=[NSString stringWithFormat:@"%@ %@",currencySign,@"0.00"];
    }
    else
    {
        NSManagedObject *person = (NSManagedObject *)[objects objectAtIndex:0];
        
        if([[person valueForKey:@"skipTenderedView"]boolValue])
        {
            [self saveDataAfterpayment];
            
        }
        else
        {
            [UIView beginAnimations:@"animate" context:nil];
            [UIView setAnimationDuration:0.35f];
            [UIView setAnimationBeginsFromCurrentState: NO];
            CGRect frame = tenderdview.frame;
            frame.origin.x = 0;
            [tenderdview setFrame:frame];
            [UIView commitAnimations];
            amountLbl.text=[NSString stringWithFormat:@"%@ %.02f",currencySign,totalamount];
        }
        if([[person valueForKey:@"autoFillAmount"]boolValue])
        {
            amountFeild.text=[NSString stringWithFormat:@"%.02f",totalamount];
            [okBtn setEnabled:true];
            okBtn.backgroundColor=[UIColor colorWithRed:91.0f/255.0f green:41.0f/255.0f blue:117.0f/255.0f alpha:1.0f];
            
            [btnEmail setEnabled:true];
            btnEmail.backgroundColor=[UIColor colorWithRed:91.0f/255.0f green:41.0f/255.0f blue:117.0f/255.0f alpha:1.0f];
            
            [btnNone setEnabled:true];
            btnNone.backgroundColor=[UIColor colorWithRed:91.0f/255.0f green:41.0f/255.0f blue:117.0f/255.0f alpha:1.0f];
            
            amountFeild.placeholder=[NSString stringWithFormat:@"%@ %@",currencySign,@"0.00"];
        }
        else
        {
            amountFeild.placeholder=[NSString stringWithFormat:@"%@ %@",currencySign,@"0.00"];
            amountFeild.text=@"";
        }
    }
}
- (IBAction)buttonSwishOther:(UIButton*)sender
{
    
    if (sender == btn_Swish)
    {
        str_PaymentMethod = @"3";
        [[NSUserDefaults standardUserDefaults] setObject:@"Swish" forKey:@"payment_mode"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else
    {
        str_PaymentMethod=@"4";
        [[NSUserDefaults standardUserDefaults] setObject:@"Other" forKey:@"payment_mode"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    
    
    NSManagedObjectContext *context =[appDelegate managedObjectContext];
    NSError *error;
    NSEntityDescription *entityDesc =[NSEntityDescription entityForName:@"Setting" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    NSPredicate *pred =[NSPredicate predicateWithFormat:@"(id = %@)",@"1"];
    [request setPredicate:pred];
    NSArray *objects = [context executeFetchRequest:request error:&error];
    if(objects.count==0)
    {
        [MiniPrinterFunctions CheckStatusWithPortname:portName portSettings:portSettings sensorSetting:SensorActiveHigh];
        
        [UIView beginAnimations:@"animate" context:nil];
        [UIView setAnimationDuration:0.35f];
        [UIView setAnimationBeginsFromCurrentState: NO];
        CGRect frame = tenderdview.frame;
        frame.origin.x = 0;
        [tenderdview setFrame:frame];
        [UIView commitAnimations];
        amountLbl.text=[NSString stringWithFormat:@"%@ %.02f",currencySign,totalamount];
        amountFeild.placeholder=[NSString stringWithFormat:@"%@ %@",currencySign,@"0.00"];
    }
    else
    {
        NSManagedObject *person = (NSManagedObject *)[objects objectAtIndex:0];
        
        if([[person valueForKey:@"skipTenderedView"]boolValue])
        {
            [self saveDataAfterpayment];
            
        }
        else
        {
            [UIView beginAnimations:@"animate" context:nil];
            [UIView setAnimationDuration:0.35f];
            [UIView setAnimationBeginsFromCurrentState: NO];
            CGRect frame = tenderdview.frame;
            frame.origin.x = 0;
            [tenderdview setFrame:frame];
            [UIView commitAnimations];
            amountLbl.text=[NSString stringWithFormat:@"%@ %.02f",currencySign,totalamount];
        }
        if([[person valueForKey:@"autoFillAmount"]boolValue])
        {
            amountFeild.text=[NSString stringWithFormat:@"%.02f",totalamount];
            [okBtn setEnabled:true];
            okBtn.backgroundColor=[UIColor colorWithRed:91.0f/255.0f green:41.0f/255.0f blue:117.0f/255.0f alpha:1.0f];
            
            [btnEmail setEnabled:true];
            btnEmail.backgroundColor=[UIColor colorWithRed:91.0f/255.0f green:41.0f/255.0f blue:117.0f/255.0f alpha:1.0f];
            
            [btnNone setEnabled:true];
            btnNone.backgroundColor=[UIColor colorWithRed:91.0f/255.0f green:41.0f/255.0f blue:117.0f/255.0f alpha:1.0f];
            
            amountFeild.placeholder=[NSString stringWithFormat:@"%@ %@",currencySign,@"0.00"];
        }
        else
        {
            amountFeild.placeholder=[NSString stringWithFormat:@"%@ %@",currencySign,@"0.00"];
            amountFeild.text=@"";
        }
    }
}

- (IBAction)actionCardPayment:(UIButton *)sender{
    
    NSLog(@"ap%@",appDelegate.reciptArray);
    
    str_PaymentMethod=@"2";
    [[NSUserDefaults standardUserDefaults] setObject:@"Card" forKey:@"payment_mode"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ShowSignature"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSManagedObjectContext *context =[appDelegate managedObjectContext];
    NSError *error;
    NSEntityDescription *entityDesc =[NSEntityDescription entityForName:@"Setting" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    NSPredicate *pred =[NSPredicate predicateWithFormat:@"(id = %@)",@"1"];
    [request setPredicate:pred];
    NSArray *objects = [context executeFetchRequest:request error:&error];
    if(objects.count==0)
    {
        [MiniPrinterFunctions CheckStatusWithPortname:portName portSettings:portSettings sensorSetting:SensorActiveHigh];
        
        [UIView beginAnimations:@"animate" context:nil];
        [UIView setAnimationDuration:0.35f];
        [UIView setAnimationBeginsFromCurrentState: NO];
        CGRect frame = tenderdview.frame;
        frame.origin.x = 0;
        [tenderdview setFrame:frame];
        [UIView commitAnimations];
        amountLbl.text=[NSString stringWithFormat:@"%@ %.02f",currencySign,totalamount];
        amountFeild.placeholder=[NSString stringWithFormat:@"%@ %@",currencySign,@"0.00"];
    }
    else
    {
        NSManagedObject *person = (NSManagedObject *)[objects objectAtIndex:0];
        
        if([[person valueForKey:@"skipTenderedView"]boolValue])
        {
            [self saveDataAfterpayment];
            
        }
        else
        {
//            [UIView beginAnimations:@"animate" context:nil];
//            [UIView setAnimationDuration:0.35f];
//            [UIView setAnimationBeginsFromCurrentState: NO];
//            CGRect frame = tenderdview.frame;
//            frame.origin.x = 0;
//            [tenderdview setFrame:frame];
//            [UIView commitAnimations];
           // [self presentPayworksInterface];
            
            if (([[[NSUserDefaults standardUserDefaults] valueForKey:KPAYWORKS_MERCHANT_IDENTIFIER] length]>0) && ([[[NSUserDefaults standardUserDefaults] valueForKey:KPAYWORKS_MERCHANT_SECRET] length]>0))
            {
                 [self customPayworksInterface];
                self.transactionView.hidden = NO;
                [self enableEmail_PrintButtons:YES];
                [self.abort_action setTitle:@"abort" forState:UIControlStateNormal];
                [self.abort_action addTarget:self action:@selector(abortButton_action:) forControlEvents:UIControlEventTouchUpInside];
                
                amountLbl.text=[NSString stringWithFormat:@"%@ %.02f",currencySign,totalamount];
            }
            else if([[[NSUserDefaults standardUserDefaults] valueForKey:KPAYWORKS_MERCHANT_IDENTIFIER] length] == 0){
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Please enter merchant identifier in Settings" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                     self.transactionView.hidden = YES;
                }];
                [alert addAction:okButton];
                [self presentViewController:alert animated:YES completion:nil];
                
            }
            else if([[[NSUserDefaults standardUserDefaults] valueForKey:KPAYWORKS_MERCHANT_SECRET] length] == 0){
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Please enter merchant secret in Settings" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    self.transactionView.hidden = YES;
                }];
                [alert addAction:okButton];
                [self presentViewController:alert animated:YES completion:nil];
                
            }     
        }
        if([[person valueForKey:@"autoFillAmount"]boolValue])
        {
            amountFeild.text=[NSString stringWithFormat:@"%.02f",totalamount];
            [okBtn setEnabled:true];
            okBtn.backgroundColor=[UIColor colorWithRed:91.0f/255.0f green:41.0f/255.0f blue:117.0f/255.0f alpha:1.0f];
            
            [btnEmail setEnabled:true];
            btnEmail.backgroundColor=[UIColor colorWithRed:91.0f/255.0f green:41.0f/255.0f blue:117.0f/255.0f alpha:1.0f];
            
            [btnNone setEnabled:true];
            btnNone.backgroundColor=[UIColor colorWithRed:91.0f/255.0f green:41.0f/255.0f blue:117.0f/255.0f alpha:1.0f];
            
            amountFeild.placeholder=[NSString stringWithFormat:@"%@ %@",currencySign,@"0.00"];
        }
        else
        {
            amountFeild.placeholder=[NSString stringWithFormat:@"%@ %@",currencySign,@"0.00"];
            amountFeild.text=@"";
        }
    }
}


#pragma mark - Payworks Interface

- (void)customPayworksInterface{
    
    MPTransactionProvider* transactionProvider;
    MPAccessoryParameters *ap;
   
    
   
   
#if (TARGET_OS_SIMULATOR)
    // for Simulator
    
    transactionProvider =[MPMpos transactionProviderForMode:MPProviderModeMOCK
                    merchantIdentifier:[[NSUserDefaults standardUserDefaults] valueForKey:KPAYWORKS_MERCHANT_IDENTIFIER]
                     merchantSecretKey:[[NSUserDefaults standardUserDefaults] valueForKey:KPAYWORKS_MERCHANT_SECRET]];
    // Start with a mocked card reader:
    ap = [MPAccessoryParameters mockAccessoryParameters];
    
#else
    // for Device
    
    
        transactionProvider = [MPMpos transactionProviderForMode:MPProviderModeTEST //MPProviderModeTEST MPProviderModeLIVE
                                              merchantIdentifier:[[NSUserDefaults standardUserDefaults] valueForKey:KPAYWORKS_MERCHANT_IDENTIFIER]
                                               merchantSecretKey:[[NSUserDefaults standardUserDefaults] valueForKey:KPAYWORKS_MERCHANT_SECRET]];
    
    
    
    // When using the Bluetooth Miura Shuttle / M007 / M010, use the following parameters:
    ap = [MPAccessoryParameters externalAccessoryParametersWithFamily:MPAccessoryFamilyMiuraMPI
                                                             protocol:@"com.miura.shuttle"
                                                            optionals:nil];
#endif

    
    
    
    MPCurrency selected_currency;
    if ([currencySign isEqualToString:@"SEK"]) {
        selected_currency = MPCurrencySEK;
    }
    else if ([currencySign isEqualToString:@"$"])
    {
        selected_currency = MPCurrencyUSD;
    }
    else {
        selected_currency = MPCurrencyEUR;
    }
   // NSString *transaction_custom_identifier = [NSString stringWithFormat:@"%@",[[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:0] valueForKey:@"code"]];
    NSLog(@"%@",[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%.02f", totalamount]]);
    MPTransactionParameters *transactionParameters =
    [MPTransactionParameters chargeWithAmount:[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%.02f", totalamount]]
                                     currency: selected_currency
                                    optionals:^(id<MPTransactionParametersOptionals>  _Nonnull optionals) {
                                        optionals.subject = @"";    //[Language get:@"SALE" alter:@"!SALE"];
                                        optionals.customIdentifier = @"";
                                    }];

    
    // When using the WiFi Miura M010, use the following parameters:
    // MPAccessoryParameters *ap = [MPAccessoryParameters tcpAccessoryParametersWithFamily:MPAccessoryFamilyMiuraMPI
    //                                                                              remote:@"192.168.254.123"
    //                                                                                port:38521
    //                                                                           optionals:nil];
    
    process =
    [transactionProvider startTransactionWithParameters:transactionParameters
                                    accessoryParameters:ap
                                             registered:^(MPTransactionProcess *process,
                                                          MPTransaction *transaction)
     {
         NSLog(@"registered MPTransactionProcess, transaction id: %@", transaction.identifier);
     }
                                          statusChanged:^(MPTransactionProcess *process,
                                                          MPTransaction *transaction,
                                                          MPTransactionProcessDetails *details)
     {
         NSString *state;
        
         switch (details.state) {
            case MPTransactionProcessDetailsStateInitializingTransaction:
            case MPTransactionProcessDetailsStateProcessing:
                 if (details.stateDetails == 12 && [[NSUserDefaults standardUserDefaults] boolForKey:@"ShowSignature"])
                 {
                     [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"ShowSignature"];
                     [[NSUserDefaults standardUserDefaults] synchronize];
                 }
                 break;
             case MPTransactionProcessDetailsStateConnectingToAccessory:
                  state = @"Sale";
                 break;
           
             case MPTransactionProcessDetailsStateWaitingForCardPresentation:
                 state = [NSString stringWithFormat:@"Sale : %@", details.information[0]];
                 break;
            
                 
             case  MPTransactionProcessDetailsStateDeclined:
             case MPTransactionProcessDetailsStateAborted:
                 state = @"Abort";
                 self.transactionView.hidden = YES;
                 break;
           
            case MPTransactionProcessDetailsStateApproved:
                 state = @"Completed";
                 break;
                 
             default:
                 break;
         }
        

         self.lblTransactionStatus_Title.text = state;
         self.lblTransactionStatus.text = details.information[0];
         self.lblTransactionStatus2.text = details.information[1];
         self.abort_action.hidden = ![transaction canBeAborted];
         NSLog(@"%@\n%@", details.information[0], details.information[1]);
     }
                                         actionRequired:^(MPTransactionProcess *process,
                                                          MPTransaction *transaction,
                                                          MPTransactionAction action,
                                                          MPTransactionActionSupport *support)
     {
         switch (action) {
             case MPTransactionActionCustomerSignature: {
                 NSLog(@"show a UI that let's the customer provide his/her signature!");
                 // In a live app, this image comes from your signature screen
                 UIGraphicsBeginImageContext(CGSizeMake(1, 1));
                 UIImage *capturedSignature = UIGraphicsGetImageFromCurrentImageContext();
                 UIGraphicsEndImageContext();
                 
                 [process continueWithCustomerSignature:capturedSignature verified:YES];
                 
                 // Add this instead, if you would like to collect the customer signature on the printed merchant receipt
                 [process continueWithCustomerSignatureOnReceipt];
                 
                 break;
             }
             case MPTransactionActionCustomerIdentification: {
                 // always return NO here
                 [process continueWithCustomerIdentityVerified:NO];
                 break;
             }
             case MPTransactionActionApplicationSelection: {
                 // This happens only for readers that don't support application selection on their screen
                 break;
             }
             default: {
                 break;
             }
         }
     }
                                              completed:^(MPTransactionProcess *process,
                                                          MPTransaction *transaction,
                                                          MPTransactionProcessDetails *details)
     {
         NSLog(@"Transaction ended, transaction status is %lu", (unsigned long) transaction.status);
         
         if (details.state == MPTransactionProcessDetailsStateApproved) {
             // Ask the merchant, whether the shopper wants to have a receipt
             // and close the checkout UI
             completedTransaction = transaction;
             self.lblTransactionStatus2.hidden = YES;
             self.lblTransactionStatus.hidden = YES;
             
             self.btnprint_cardPaymentReceipt.hidden = NO;
             self.btnMail_cardPaymentReceipt.hidden = NO;
             
         } else if(details.state == MPTransactionProcessDetailsStateFailed) {
             // Allow your merchant to try another transaction
             self.abort_action.hidden = NO;
             [self.abort_action setTitle:@"close" forState:UIControlStateNormal];
             [self.abort_action addTarget:self action:@selector(closeTransaction) forControlEvents:UIControlEventTouchUpInside];
         }
         
         // only close your modal here
         
       
         [self.abort_action setTitle:@"close" forState:UIControlStateNormal];
         [self.abort_action addTarget:self action:@selector(closeTransaction) forControlEvents:UIControlEventTouchUpInside];
     }];

    
}
#pragma mark - UITextField Delegate Methods.

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
//    [textField resignFirstResponder];
    
//    [alertView_payment dismissWithClickedButtonIndex:alertView_payment.firstOtherButtonIndex animated:YES];
    
    if ([textField isEqual:[alertView_payment textFieldAtIndex:0]]) {
        
        if ([[alertView_payment textFieldAtIndex:0] validEmailAddress]) {

            
            
            [[NSUserDefaults standardUserDefaults] setObject:@"No" forKey:@"None"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            
            Reachability *reachability = [Reachability reachabilityForInternetConnection];
            NetworkStatus internetStatus = [reachability currentReachabilityStatus];
            if (internetStatus != NotReachable) {
                

                receiptMethodTag=2;
                
                
                [[NSUserDefaults standardUserDefaults] setObject:@"Email" forKey:@"receipt_output_mode"];
                [[NSUserDefaults standardUserDefaults] synchronize];

                [self VibrateandSound];
                [self saveDataAfterpayment];
                
            }
            else {
                [[[UIAlertView alloc] initWithTitle:@"ISUPOS" message:[Language get:@"Please check your internet connection." alter:@"!Please check your internet connection."] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }
            
            
        }
        
    }
    
    
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
 
    if (textField != txt_Email)
    {
        NSString *v;
        if([string isEqualToString:@""])
            v=[NSString stringWithFormat:@"%d",[textField.text intValue]/10];
        else
            v=[NSString stringWithFormat:@"%@%@",textField.text,string];
        
        
        [self multiplyamount:v];
    }
   
    return YES;
}
-(void)multiplyamount:(NSString*)v
{
    if(totalamount-[v floatValue]<0)
    {
        exchange = [v floatValue]-totalamount;
        
        tenderdLbl.text=[NSString stringWithFormat:@"%@: %@ %.02f",[Language get:@"Exchange" alter:@"!Exchange"],currencySign,[v floatValue]-totalamount];
        [okBtn setEnabled:true];
        okBtn.backgroundColor=[UIColor colorWithRed:91.0f/255.0f green:41.0f/255.0f blue:117.0f/255.0f alpha:1.0f];
        
        [btnEmail setEnabled:true];
        btnEmail.backgroundColor=[UIColor colorWithRed:91.0f/255.0f green:41.0f/255.0f blue:117.0f/255.0f alpha:1.0f];
        
        [btnNone setEnabled:true];
        btnNone.backgroundColor=[UIColor colorWithRed:91.0f/255.0f green:41.0f/255.0f blue:117.0f/255.0f alpha:1.0f];
    }
    else if(totalamount-[v floatValue]==0)
    {
        exchange = 0;
        
        tenderdLbl.text=[NSString stringWithFormat:@"%@",[Language get:@"Total" alter:@"!Total"]];
        [okBtn setEnabled:true];
        okBtn.backgroundColor=[UIColor colorWithRed:91.0f/255.0f green:41.0f/255.0f blue:117.0f/255.0f alpha:1.0f];
        
        [btnEmail setEnabled:true];
        btnEmail.backgroundColor=[UIColor colorWithRed:91.0f/255.0f green:41.0f/255.0f blue:117.0f/255.0f alpha:1.0f];
        
        [btnNone setEnabled:true];
        btnNone.backgroundColor=[UIColor colorWithRed:91.0f/255.0f green:41.0f/255.0f blue:117.0f/255.0f alpha:1.0f];
    }
    else
    {
        exchange = 0;
        
        tenderdLbl.text=[NSString stringWithFormat:@"%@",[Language get:@"Total" alter:@"!Total"]];
        [okBtn setEnabled:false];
        [okBtn setBackgroundColor:[UIColor lightGrayColor]];
        
        [btnEmail setEnabled:false];
        [btnEmail setBackgroundColor:[UIColor lightGrayColor]];
        
        [btnNone setEnabled:false];
        [btnNone setBackgroundColor:[UIColor lightGrayColor]];
    }
}
- (IBAction)cancelButton:(UIButton*)sender
{
    [callBack performSelector:@selector(toDismissThePopover)];
}

- (IBAction)backButton:(UIButton*)sender
{
    [UIView beginAnimations:@"animate" context:nil];
    [UIView setAnimationDuration:0.35f];
    [UIView setAnimationBeginsFromCurrentState: NO];
    CGRect frame = tenderdview.frame;
    frame.origin.x = 567;
    [tenderdview setFrame:frame];
    [UIView commitAnimations];
    amountLbl.text=[NSString stringWithFormat:@"%@ %.02f",currencySign,totalamount];
}
- (IBAction)paymentButton:(UIButton*)sender
{
    
    [[NSUserDefaults standardUserDefaults] setObject:@"No" forKey:@"None"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    [MiniPrinterFunctions CheckStatusWithPortname:portName portSettings:portSettings sensorSetting:SensorActiveHigh];
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"PrinterStatus"] isEqualToString:@"Online"]) {
    
        receiptMethodTag=1;
        
        [[NSUserDefaults standardUserDefaults] setObject:@"Print" forKey:@"receipt_output_mode"];
        [[NSUserDefaults standardUserDefaults] synchronize];

       [self VibrateandSound];
       [self saveDataAfterpayment];
    }
    else
    {
       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ISUPOS" message:@"Printer not connected." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
       [alert show];
    }
}

#pragma mark Sound

-(void)VibrateandSound
{
    NSString *path  = [[NSBundle mainBundle] pathForResource:@"fnebeep2" ofType:@"mp3"];
    NSURL *pathURL = [NSURL fileURLWithPath : path];
    
    SystemSoundID audioEffect;
    
    AudioServicesCreateSystemSoundID((__bridge CFURLRef) pathURL, &audioEffect);
    
    AudioServicesPlaySystemSound(audioEffect);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.19 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        AudioServicesDisposeSystemSoundID(audioEffect);
    });AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
-(void)toDismissThePopover
{
    [appDelegate.receipt_paymentDetails_copy removeAllObjects];
    [popover dismissPopoverAnimated:YES];
}
-(void)saveDataAfterpayment
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    if (internetStatus != NotReachable) {
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        if ([[NSUserDefaults standardUserDefaults]boolForKey:@"INFRASEC_STATUS"])
        {
            if ([[NSUserDefaults standardUserDefaults]valueForKey:@"INFRASEC_PASSWORD"])
            {
                
                if ([[NSUserDefaults standardUserDefaults]valueForKey:@"INFRASEC_USERNAME"])
                {
                    [self performSelector:@selector(getTransCodeXml) withObject:nil afterDelay:0.0];
                    
                }
                else
                {
                    //                [self performSelector:@selector(saveData) withObject:nil afterDelay:0.0];
                    
                    [[[UIAlertView alloc] initWithTitle:@"ISUPOS" message:[Language get:@"The receipt CTU server is not accepting the receipt" alter:@"!The receipt CTU server is not accepting the receipt"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                    
                    tenderdview.hidden = YES;
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                }
            }
            else
            {
                //            [self performSelector:@selector(saveData) withObject:nil afterDelay:0.0];
                
                [[[UIAlertView alloc] initWithTitle:@"ISUPOS" message:[Language get:@"The receipt CTU server is not accepting the receipt" alter:@"!The receipt CTU server is not accepting the receipt"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                tenderdview.hidden = YES;
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }
        }
        else
        {
            [self performSelector:@selector(saveData) withObject:nil afterDelay:0.0];
        }
        
        
    }
    else {
        [[[UIAlertView alloc] initWithTitle:@"ISUPOS" message:[Language get:@"Please check your internet connection." alter:@"!Please check your internet connection."] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}

-(void)PostRegisterSaleData
{
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 103) {
        if (buttonIndex == 0) {

            
            if ([[alertView textFieldAtIndex:0] validEmailAddress]) {
              
                
                [[NSUserDefaults standardUserDefaults] setObject:@"No" forKey:@"None"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                
                Reachability *reachability = [Reachability reachabilityForInternetConnection];
                NetworkStatus internetStatus = [reachability currentReachabilityStatus];
                if (internetStatus != NotReachable) {
                  
                    receiptMethodTag=2;
                    
                    [[NSUserDefaults standardUserDefaults] setObject:@"Email" forKey:@"receipt_output_mode"];
                    [[NSUserDefaults standardUserDefaults] setObject:@"Original" forKey:@"ReciptType"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    [self VibrateandSound];
                    [self saveDataAfterpayment];
                    
                }
                else {
                    [[[UIAlertView alloc] initWithTitle:@"ISUPOS" message:[Language get:@"Please check your internet connection." alter:@"!Please check your internet connection."] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                }
                
                
            }
        }
        
    }
    else if (alertView.tag == 104){
        if (buttonIndex == 0) {
            
            if ([[alertView textFieldAtIndex:0] validEmailAddress]) {
                
                [[NSUserDefaults standardUserDefaults] setObject:@"No" forKey:@"None"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                
                Reachability *reachability = [Reachability reachabilityForInternetConnection];
                NetworkStatus internetStatus = [reachability currentReachabilityStatus];
                if (internetStatus != NotReachable) {
                    
                   
                    
                    
                    NSString *email = [alertView_payment textFieldAtIndex:0].text;
                    [[NSUserDefaults standardUserDefaults] setObject:email forKey:@"EMAIL"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    appDelegate.customerReceipt = completedTransaction.customerReceipt;
                   
                    receiptMethodTag=2;
                    [[NSUserDefaults standardUserDefaults] setObject:@"Email" forKey:@"receipt_output_mode"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    [self VibrateandSound];
                    [self saveDataAfterpayment];
                    
                    
                     NSMutableDictionary  *receipt_paymentDetails = [[NSMutableDictionary alloc]init];;
                    NSMutableDictionary *receipt_merchantDetails = [[NSMutableDictionary alloc]init];
                    
                    NSMutableDictionary *receipt_clearingDetails = [[NSMutableDictionary alloc]init];
                    
                    NSDictionary *pwid_dict = nil;
                    MPReceipt *receipt = nil;
                    //if (self.customerReceipt != nil) {
                        
                        
                    receipt = completedTransaction.customerReceipt;
                    
                    
                    
                   
                    
                    receipt = completedTransaction.customerReceipt;
                    // For the Customer Receipt
                    
                    // NSLog(@"MERCHANT DETAILS");
                    for (MPReceiptLineItem* lineItem in receipt.merchantDetails)
                    {
                        NSString *label = lineItem.label;
                        NSString *value = lineItem.value;
                        
                        [receipt_merchantDetails setObject:value forKey:label];
                        [receipt_paymentDetails setObject:value forKey:label];
                    }
                     NSLog(@"Merchant Details \n %@", receipt_merchantDetails );
                    // NSLog(@" ");
                    
                    // NSLog(@"%@: %@", receipt.receiptType.label, receipt.receiptType.value);
                    [receipt_paymentDetails setObject:receipt.receiptType.value forKey:receipt.receiptType.label];
                    
                    // NSLog(@"%@: %@", receipt.transactionType.label, receipt.transactionType.value);
                    [receipt_paymentDetails setObject:receipt.transactionType.value forKey:receipt.transactionType.label];
                    
                    
                    // NSLog(@"%@: %@", receipt.amountAndCurrency.label, receipt.amountAndCurrency.value);
                    [receipt_paymentDetails setObject:receipt.amountAndCurrency.value forKey:receipt.amountAndCurrency.label];
                    NSLog(@" ");
                    
                     NSLog(@"PAYMENT DETAILS");
                    for (MPReceiptLineItem* lineItem in receipt.paymentDetails)
                    {
                        NSString *label = lineItem.label;
                        NSString *value = lineItem.value;
                       // [receipt_merchantDetails setObject:label forKey:value];
                        [receipt_paymentDetails setObject:value forKey:label];
                        NSLog(@"%ld :%@", (long)lineItem.key, value);
                    }
                     NSLog(@"Payment Details \n %@", receipt_paymentDetails);
                    
                    NSLog(@" ");
                    
                    //NSLog(@"%@: %@", receipt.statusText.label, receipt.statusText.value);
                    [receipt_paymentDetails setObject:receipt.statusText.value forKey:receipt.statusText.label];
                    // NSLog(@"%@: %@", receipt.date.label, receipt.date.value);
                    [receipt_paymentDetails setObject:receipt.date.value forKey:receipt.date.label];
                    
                    // NSLog(@"%@: %@", receipt.time.label, receipt.time.value);
                    [receipt_paymentDetails setObject:receipt.time.value forKey:receipt.time.label];
                    
                    NSLog(@" ");
                    
                     NSLog(@"CLEARING DETAILS");
                    for (MPReceiptLineItem* lineItem in receipt.clearingDetails)
                    {
                        NSString *label = lineItem.label;
                        NSString *value = lineItem.value;
                        [receipt_clearingDetails setObject:value forKey:label];
                        [receipt_paymentDetails setObject:value forKey:label];
                    }
                     NSLog(@"Clearing Details \n %@", receipt_clearingDetails);
                    // NSLog(@" ");
                    
                    // --- Optional
                    // NSLog(@"%@: %@", receipt.identifier.label, receipt.identifier.value);
                    [receipt_paymentDetails setObject:receipt.identifier.value forKey:receipt.identifier.label];
                                       
                    NSLog(@"Receipt Details: AlertViewClicked \n %@", receipt_paymentDetails);
               

                    // send receipt in mail
                  //  [[AppDelegate delegate] sendMailWithSubject:[NSString stringWithFormat:@"%@", [Language get:@"Receipt" alter:@"!Receipt"]]  sendFrom:@"" ToReciepents:@"" messageHtmlBodyContent:@""];
                    
                   
                    
                    
                    
               // }
           
            
            
                }
            }
            
        }
        
    }
    
}

/*
 
 {
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
 
 if([receiptType containsString:@"Summa"])
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
 
 */

-(void)saveCardTransactionDetails:(int)receiptID
{
    
    NSMutableDictionary  *receipt_paymentDetails;
   //receipt_merchantDetails = [[NSMutableDictionary alloc]init];
    receipt_paymentDetails = [[NSMutableDictionary alloc]init];
   // receipt_clearingDetails = [[NSMutableDictionary alloc]init];
    
    NSDictionary *pwid_dict = nil;
    MPReceipt *receipt = nil;
    //if (self.customerReceipt != nil) {
    
    receipt = completedTransaction.customerReceipt;
    // For the Customer Receipt
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
        
        [receipt_paymentDetails  setObject:value forKey:label];
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
        
        
        [receipt_paymentDetails  setObject:receipt.receiptType.value forKey:receiptType];
        [receipt_paymentDetails  setObject:receipt.transactionType.value forKey:payment];
        [receipt_paymentDetails  setObject:receipt.amountAndCurrency.value forKey:amount];
    
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
            
            [receipt_paymentDetails  setObject:value forKey:label];
        }
    
        [receipt_paymentDetails  setObject:receipt.statusText.value forKey:receipt.statusText.label];
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
        [receipt_paymentDetails  setObject:receipt.date.value forKey:dateKey];
        [receipt_paymentDetails  setObject:receipt.time.value forKey:timeKey];
    
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
            [receipt_paymentDetails  setObject:value forKey:label];
        }
        
    [receipt_paymentDetails  setObject:receipt.identifier.value forKey:receipt.identifier.label];
//    NSString *pwid_part1 = [receipt.identifier.value substringWithRange:NSMakeRange(0,receipt.identifier.value.length/2)];
//    NSString *pwid_part2 = [receipt.identifier.value substringWithRange:NSMakeRange(receipt.identifier.value.length/2 -1, receipt.identifier.value.length/2)];
//    // NSDictionary *pwid_dict = @{@"pwid_part1":pwid_part1,@"pwid_part2":pwid_part2};
//    [receipt_paymentDetails  setObject:pwid_part1 forKey:@"pwid_part1"];
//    [receipt_paymentDetails  setObject:pwid_part2 forKey:@"pwid_part2"];
    
        NSLog(@"Receipt Details : saveCardTransactionDetails \n %@", receipt_paymentDetails);

   
    AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context =[delegate managedObjectContext];
    NSError *error;
    NSManagedObject *newContactRec;
    
    newContactRec = [NSEntityDescription insertNewObjectForEntityForName:@"Recepit_CardPayment" inManagedObjectContext:context];
 
    [newContactRec setValue:[receipt_paymentDetails valueForKey:@"Contact"] forKey:@"merchant_contact"];
    [newContactRec setValue:[receipt_paymentDetails valueForKey:@"Merchant ID"] forKey:@"merchant_id"];
    [newContactRec setValue:[receipt_paymentDetails valueForKey:@"Terminal ID"] forKey:@"receipt_terminal_id"];
    [newContactRec setValue:[receipt_paymentDetails valueForKey:@"Card Number"] forKey:@"receipt_card_number"];
    [newContactRec setValue:completedTransaction.identifier forKey:@"receipt_transaction_id"];
    [newContactRec setValue:[receipt_paymentDetails valueForKey:@"Time"] forKey:@"receipt_time"];
    [newContactRec setValue:[receipt_paymentDetails valueForKey:@"Authorization"] forKey:@"receipt_authorization_id"];
    [newContactRec setValue:[receipt_paymentDetails valueForKey:@"Date"] forKey:@"receipt_date"];
    [newContactRec setValue:[receipt_paymentDetails valueForKey:@"Zip"] forKey:@"merchant_zipcode"];
    [newContactRec setValue:[receipt_paymentDetails valueForKey:@"AID"] forKey:@"receipt_aid"];
    [newContactRec setValue:[receipt_paymentDetails valueForKey:@"PWID"] forKey:@"receipt_pwid"];
    [newContactRec setValue:[receipt_paymentDetails valueForKey:@"Receipt Type"] forKey:@"receipt_type"];
    [newContactRec setValue:[receipt_paymentDetails valueForKey:@"Entry Mode"] forKey:@"receipt_entry_mode"];
    [newContactRec setValue:[receipt_paymentDetails valueForKey:@"Country"] forKey:@"merchant_country"];
    
    [newContactRec setValue:[receipt_paymentDetails valueForKey:@"Address"] forKey:@"merchant_address"];
    [newContactRec setValue:[receipt_paymentDetails valueForKey:@"City"] forKey:@"merchant_city"];
   // [newContactRec setValue:[receipt_paymentDetails valueForKey:@"Verification"] forKey:@"payment_verification_type"];
    [newContactRec setValue:[receipt_paymentDetails valueForKey:@"Card"] forKey:@"receipt_card"];
    [newContactRec setValue:[receipt_paymentDetails valueForKey:@"Name"] forKey:@"merchant_name"];
    [newContactRec setValue:[receipt_paymentDetails valueForKey:@"Account"] forKey:@"receipt_account"];
    [newContactRec setValue:[receipt_paymentDetails valueForKey:@"Additional Information"] forKey:@"merchant_additional_information"];
    [newContactRec setValue:[receipt_paymentDetails valueForKey:@"Amount"] forKey:@"receipt_amount"];
    [newContactRec setValue:[receipt_paymentDetails valueForKey:@"Information"] forKey:@"receipt_information"];
    [newContactRec setValue:[NSNumber numberWithInt:receiptID] forKey:@"receipt_id"];
  
    [newContactRec setValue:[receipt_paymentDetails valueForKey:@"Transaction"] forKey:@"receipt_transaction_reference_number"];

    NSLog(@"Saved Card Payment details -- \n%@",newContactRec);
    [context save:&error];
}

-(void)saveData
{
    arrayAmount=[NSMutableArray new];
    arrayVat=[NSMutableArray new];
    
    NSManagedObjectContext *context =[appDelegate managedObjectContext];
    
    NSEntityDescription *entityDesc =[NSEntityDescription entityForName:@"Cart" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    
    NSEntityDescription *entityDescRec =[NSEntityDescription entityForName:@"ReceiptNo" inManagedObjectContext:context];
    NSFetchRequest *requestRec = [[NSFetchRequest alloc] init];
    [requestRec setEntity:entityDescRec];
    
    NSArray *objectsRec = [context executeFetchRequest:requestRec error:&error];
    NSManagedObject *persoRec = (NSManagedObject *)[objectsRec lastObject];
    
    int x=[[persoRec valueForKey:@"id"] intValue]+1;
    str_transactionId=[NSString stringWithFormat:@"%d",x];
    
    
    
    //Save card transcation details in a sepearte table
    if ([str_PaymentMethod isEqualToString:@"2"]) {
        [self saveCardTransactionDetails:x];
    }
    
    
    NSManagedObject *newContactRec;
    
    newContactRec = [NSEntityDescription insertNewObjectForEntityForName:@"ReceiptNo" inManagedObjectContext:context];
    [newContactRec setValue:[NSDate date] forKey:@"receiptdate"];
    [newContactRec setValue:[NSNumber numberWithInt:x] forKey:@"id"];
    
    [context save:&error];
    
    NSEntityDescription *entityDes =[NSEntityDescription entityForName:@"Trasections" inManagedObjectContext:context];
    NSFetchRequest *reques = [[NSFetchRequest alloc] init];
    [reques setEntity:entityDes];
    //NSArray *object = [context executeFetchRequest:reques error:&error];
    //NSManagedObject *perso = (NSManagedObject *)[object lastObject];
    
    float total=0.0;
    for(int i=0;i<objects.count;i++)
    {
        NSManagedObject *person = (NSManagedObject *)[objects objectAtIndex:i];
        NSManagedObject *newContact;
        newContact = [NSEntityDescription insertNewObjectForEntityForName:@"Trasections" inManagedObjectContext:context];
        
        [newContact setValue:[person valueForKey:@"name" ] forKey:@"name"];
        [newContact setValue:[NSNumber numberWithInt:[[person valueForKey:@"count"] intValue]] forKey:@"count"];
        [newContact setValue:[person valueForKey:@"article_id" ] forKey:@"article_id"];
        [newContact setValue:currencySign forKey:@"currency"];
        [newContact setValue:[NSNumber numberWithInt:0] forKey:@"zdayStatus"];
        [newContact setValue:[NSNumber numberWithInt:0] forKey:@"printStatus"];
        [newContact setValue:[NSNumber numberWithInt:0] forKey:@"mailStatus"];
        [newContact setValue:[person valueForKey:@"discountType"] forKey:@"discountType"];
        float discountperproduct;
        
        
        if([[person valueForKey:@"discountType"] isEqualToString:@"%"]|| [person valueForKey:@"discountType"] == nil)
        {
          
            discountperproduct=([[person valueForKey:@"price"]floatValue]*[[person valueForKey:@"count"]intValue]*[[person valueForKey:@"discount"]floatValue])/100;
        }
        else
        {
      
            discountperproduct=[[person valueForKey:@"discount"]floatValue];
        }
        
        
        [newContact setValue:[NSNumber numberWithFloat:[[person valueForKey:@"vat" ] floatValue]] forKey:@"vat"];
        //float  zzzz = (([[person valueForKey:@"price"] floatValue]*[[person valueForKey:@"count"] integerValue])-discountperproduct) / (1 + [[person valueForKey:@"vat"] floatValue]/100);
        //zzzz=(([[person valueForKey:@"price"] floatValue] *[[person valueForKey:@"count"] integerValue])-discountperproduct)-zzzz;
        [arrayVat addObject:[person valueForKey:@"vat"]];
        [newContact setValue:[NSNumber numberWithFloat:[[person valueForKey:@"price" ] floatValue]] forKey:@"price"];
        [arrayAmount addObject:[NSString stringWithFormat:@"%.2f",[[person valueForKey:@"price" ] floatValue]*[[person valueForKey:@"count"] intValue]-discountperproduct]];
        
        [newContact setValue:[person valueForKey:@"discount"] forKey:@"discount"];
        [newContact setValue:[person valueForKey:@"image"] forKey:@"image"];
        [newContact setValue:[NSDate date] forKey:@"date"];
        [newContact setValue:[NSNumber numberWithInt:x] forKey:@"id"];
        [newContact setValue:str_PaymentMethod forKey:@"paymentMethod"];
        
        if ([str_trnsCode isEqualToString:@""]) {
            
            [newContact setValue:@"" forKeyPath:@"code"];
        }
        else
        {
            [newContact setValue:str_trnsCode forKeyPath:@"code"];
        }
        
        total=([[person valueForKey:@"price"] floatValue] *[[person valueForKey:@"count"] integerValue]-discountperproduct)+ total;
        
//        total=(([[person valueForKey:@"price"] floatValue] *[[person valueForKey:@"count"] integerValue])-discountperproduct);
        
        NSEntityDescription *entityDesc1111 =[NSEntityDescription entityForName:@"Article" inManagedObjectContext:context];
        NSFetchRequest *request11111 = [[NSFetchRequest alloc] init];
        [request11111 setEntity:entityDesc1111];
        NSPredicate *pred =[NSPredicate predicateWithFormat:@"(article_no = %@)",[person valueForKey:@"article_id"]];
        [request11111 setPredicate:pred];
        NSArray *objects1 = [context executeFetchRequest:request11111 error:&error];
        NSManagedObject *matches = nil;
        if ([objects1 count] == 0) {
            [newContact setValue:[person valueForKey:@"article_id"] forKey:@"discription"];
        }
        else
        {
            matches = [objects1 objectAtIndex:0];
            [newContact setValue:[matches valueForKey:@"barc_img_url"] forKey:@"bar_img_url"];
            [newContact setValue:[CommonMethods validateDictionaryValueForKey:[matches valueForKey:@"article_description"]]?[matches valueForKey:@"article_description"]:@"" forKey:@"discription"];
        }
        
        [context save:&error];
        
    }
  
    
    NSEntityDescription *entityDesc2 =[NSEntityDescription entityForName:@"CustomDiscount" inManagedObjectContext:context];
    NSFetchRequest *request11 = [[NSFetchRequest alloc] init];
    [request11 setEntity:entityDesc2];
    NSPredicate *predicate;
    predicate = [NSPredicate predicateWithFormat:@"(id = %@)",@"1S"];
    [request11 setPredicate:predicate];
    NSArray *objects2 = [context executeFetchRequest:request11 error:&error];
    
    if(objects2.count==0)
    {
        
    }
    else
    {
        NSManagedObject *obj=(NSManagedObject *)[objects2 objectAtIndex:0];
        
        if ([[obj valueForKey:@"type"] isEqualToString:@"%"])
        {
            
            float discount = (total*popupDiscount)/100;
            [obj setValue:[NSNumber numberWithFloat:discount] forKey:@"discount"];
            
            
            
        }
        else
        {
            [obj setValue:[NSNumber numberWithFloat:popupDiscount] forKey:@"discount"];
            
            
        }
        
        
//        [obj setValue:[NSNumber numberWithFloat:total-totalamount] forKey:@"discount"];
        [obj setValue: @"$" forKey:@"type"];
        [obj setValue: [NSString stringWithFormat:@"%d",x] forKey:@"id"];
        [obj setValue: str_PaymentMethod forKey:@"paymentMethod"];
        [obj setValue: [NSDate date] forKey:@"date"];
        
        [context save:&error];
    }
    
    
    //    api_obj=[[APIViewController alloc]init];
    //    [ api_obj loginuser:@selector(loginresult:) tempTarget:self :email_feild.text :password.text];
    //    HUD=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //    HUD.labelText=@"Logging In";
    
    [self getAllTrasection:[NSString stringWithFormat:@"%i",x]];
    
   
    
    
}



//Code to send receipt to infrasec api
//Replace infrasec with greengate api

/*
 
 
 Example register receipt
 Http post to http://195.84.248.134:8082/xccsp
 Basic authentication
 id: testpos
 password: testpos
 Receipt: 3
 PosId: 15555551111
 OrgNum: 5555551111
 Sales time: 7/11/2016 10:29
 Total amount: 10 SEK
 Vat:
 Rate: 25%
 Amount: 2 SEK
 
 Message Body:
 <?xml version="1.0" encoding="ISO-8859-1"?>
 <request xmlns="http://www.retailinnovation.se/xccsp">
 <type>RegisterReceipt</type>
 <data>
 <Receipt>
 <IsNewSession>1</IsNewSession>
 <SerialNo>500</SerialNo>
 <PosId>15555551111</PosId>
 <OrgNo>5555551111</OrgNo>
 <Date>201607111029</Date>
 <ReceiptId>3</ReceiptId>
 <ReceiptType>normal</ReceiptType>
 <ReceiptTotal>10,00</ReceiptTotal>
 <NegativeTotal>0,00</NegativeTotal>
 <VatList>
 <Vat>
 <Class>1</Class>
 <Percentage>25,00</Percentage>
 <Amount>2,00</Amount>
 </Vat>
 </VatList>
 </Receipt>
 </data>
 </request>
 
 Response:
 <?xml version="1.0" encoding="iso-8859-1"?>
 <response xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns="http://www.retailinnovation.se/xccsp">
 <type>RegisterReceiptResponse</type>
 <data>
 <RegisterResult>
 <Code>WKZQUH56H7X3DVQEJPHOYNWDV7HS223N;BA7WNV7ODW6RCY4ZLNLF4J66IM</Code>
 <UnitId>RIHTT131550010466</UnitId>
 <UnitMainStatus>0</UnitMainStatus>
 <UnitStorageStatus>0</UnitStorageStatus>
 </RegisterResult>
 </data>
 </response>
 
 
 

*/
static NSString * AFBase64EncodedStringFromString(NSString *string) {
    NSData *data = [NSData dataWithBytes:[string UTF8String] length:[string lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
    NSUInteger length = [data length];
    NSMutableData *mutableData = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    
    uint8_t *input = (uint8_t *)[data bytes];
    uint8_t *output = (uint8_t *)[mutableData mutableBytes];
    
    for (NSUInteger i = 0; i < length; i += 3) {
        NSUInteger value = 0;
        for (NSUInteger j = i; j < (i + 3); j++) {
            value <<= 8;
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        static uint8_t const kAFBase64EncodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
        
        NSUInteger idx = (i / 3) * 4;
        output[idx + 0] = kAFBase64EncodingTable[(value >> 18) & 0x3F];
        output[idx + 1] = kAFBase64EncodingTable[(value >> 12) & 0x3F];
        output[idx + 2] = (i + 1) < length ? kAFBase64EncodingTable[(value >> 6)  & 0x3F] : '=';
        output[idx + 3] = (i + 2) < length ? kAFBase64EncodingTable[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:mutableData encoding:NSASCIIStringEncoding];
}

#pragma mark Xml Start

-(void)getTransCodeXml
{
    NSString *urlString = [NSString stringWithFormat:@"http://greengate.dyndns.ws:8082/xccsp"];//http://195.84.248.134:8082/xccsp
    
    NSString *greeenGateId = [[NSUserDefaults standardUserDefaults]valueForKey:@"INFRASEC_USERNAME"];//@"testpos";
    NSString *greenGatePassword = [[NSUserDefaults standardUserDefaults]valueForKey:@"INFRASEC_PASSWORD"];//@"testpos";
    NSString * pos_id = [[NSUserDefaults standardUserDefaults]valueForKey:@"POS_ID"]; //@"15555551111";
    NSString *org_no = [[NSUserDefaults standardUserDefaults]valueForKey:@"ORGANIZATION_NUMBER"];//@"5555551111";
    
    // setting up the request object now
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    NSString *basicAuthCredentials = [NSString stringWithFormat:@"%@:%@", greeenGateId , greenGatePassword];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", AFBase64EncodedStringFromString(basicAuthCredentials)];
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    
    NSMutableString *str_postData =[[NSMutableString alloc] init];
    
    [str_postData appendString:@""];
    
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"INFRASEC_PASSWORD"])
    {
        
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        // Convert date object into desired format
        [dateFormatter setDateFormat:@"yyyyMMddHHmm"];
        NSString *Str_date;
        Str_date = [dateFormatter stringFromDate:[NSDate date]];
        NSLog(@"Date for greengate -  %@",Str_date);
        
        
      //  [str_postData appendFormat:@"%@",[NSString stringWithFormat:@"<CtuRequest><ApplicationID>%@</ApplicationID><RequestID>AffarsIT_VERIFY_003</RequestID><ControlData><DateTime>%@</DateTime><OrgNr>1414141414</OrgNr><ManRegisterID>%@</ManRegisterID><SequenceNumber>3</SequenceNumber><ReceiptType Type='normal'/>",[[NSUserDefaults standardUserDefaults]valueForKey:@"INFRASEC_USERNAME"],Str_date, [[NSUserDefaults standardUserDefaults]valueForKey:@"INFRASEC_PASSWORD"]]];
        

          // [str_postData appendFormat:@"%@",[NSString stringWithFormat:@"<CtuRequest><ApplicationID>%@</ApplicationID><RequestID>AffarsIT_VERIFY_003</RequestID><ControlData><DateTime>%@</DateTime><OrgNr>1414141414</OrgNr><ManRegisterID>%@</ManRegisterID><SequenceNumber>3</SequenceNumber><ReceiptType Type='normal'/>",greeenGateId,Str_date, greenGatePassword]];
      //  int numberOfSessions = 1;
        int serial_number = 500;
        int receipt_no = 3;
        
        NSString  *requiredRequest_URl, *date_string, *receipt_type, *receipt_total, *negative_total, *vat_class, *vat_percentage, *vat_amount;
        
        receipt_total = @"10.00";
        negative_total = @"0.00";
        vat_percentage = @"25.00";
        vat_amount = @"2.00";
        requiredRequest_URl = @"http://www.retailinnovation.se/xccsp";
        vat_class = @"1";
        receipt_type = @"normal";
        
        
        receipt_total  =[[receipt_total stringByReplacingOccurrencesOfString:@"." withString:@","] mutableCopy];
         negative_total  =[[negative_total stringByReplacingOccurrencesOfString:@"." withString:@","] mutableCopy];
        vat_percentage  =[[vat_percentage stringByReplacingOccurrencesOfString:@"." withString:@","] mutableCopy];
        vat_amount  =[[vat_amount stringByReplacingOccurrencesOfString:@"." withString:@","] mutableCopy];

        
       // [str_postData appendFormat:@"%@", [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>\n<request xmlns=\"http://www.retailinnovation.se/xccsp\">\n<type>RequestStatus</type>\n<data>\n<StatusRequest>\n<PosId>15555551111</PosId>\n<OrgNo>5555551111</OrgNo>\n</StatusRequest>\n</data>\n</request>"]];
        
        [str_postData appendFormat:@"%@",[NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>\n<request xmlns=\"%@\">\n<type>RegisterReceipt</type>\n<data>\n<Receipt>\n<IsNewSession>1</IsNewSession>\n<SerialNo>%d</SerialNo>\n<PosId>%@</PosId>\n<OrgNo>%@</OrgNo>\n<Date>%@</Date>\n<ReceiptId>%d</ReceiptId>\n<ReceiptType>%@</ReceiptType>\n<ReceiptTotal>%@</ReceiptTotal>\n<NegativeTotal>%@</NegativeTotal>\n<VatList>\n<Vat>\n<Class>%@</Class>\n<Percentage>%@</Percentage>\n<Amount>%@</Amount>\n</Vat>\n</VatList>\n</Receipt>\n</data>\n</request>", requiredRequest_URl, serial_number, pos_id, org_no,Str_date, receipt_no,receipt_type,receipt_total ,negative_total, vat_class, vat_percentage , vat_amount  ]];
       

        
     //   [str_postData appendFormat:@"%@",[NSString stringWithFormat:@"<PurchaseAmount>%@</PurchaseAmount>",self.str_PurchaseAmount]];
        
    }
    else
    {
      //  [str_postData appendFormat:@"%@",[NSString stringWithFormat:@"<PurchaseAmount>%@</PurchaseAmount>", self.str_PurchaseAmount]];
    }
    
//    for (int i=0; i<[self.vat_Variant count]; i++) {
//        
//        
//        [str_postData appendFormat:@"%@",[NSString stringWithFormat:@"<%@><Percent>%@</Percent><Amount>%@</Amount><%@>",[NSString stringWithFormat:@"VAT%d",i+1],[NSString stringWithFormat:@"%.2f",[[self.vat_Variant objectAtIndex:i ]floatValue]],[NSString stringWithFormat:@"%.2f",[[self.vat_Amount objectAtIndex:i ]floatValue]],[NSString stringWithFormat:@"/VAT%d",i+1]]];
//        
//    }
    
   // [str_postData appendFormat:@"%@",[NSString stringWithFormat:@"</ControlData></CtuRequest>"]];
    
    
 //   str_postData =[[str_postData stringByReplacingOccurrencesOfString:@"." withString:@","] mutableCopy];
    
    NSString * message= [NSString stringWithFormat:@"%@",str_postData];
    [request setValue:@"iso-8859-1" forHTTPHeaderField:@"Accept-Charset"];
     [request setValue:@"text/xml" forHTTPHeaderField:@"Accept"];
     [request setValue:@"ISUPOS/1.0" forHTTPHeaderField:@"User-Agent"];
    
    [request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:[message dataUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"\n%@", str_postData);
    NSLog(@"\nRequest - \n %@", request);
    
    // now lets make the connection to the web
    
    
    NSURLConnection *nsurl = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if ( !nsurl ) {
        NSLog(@"Connection Establisted");
    }
}

//-(void)getTransCodeXml
//{
//    NSString *urlString = [NSString stringWithFormat:@"https://affarsit.ccu.verify.infrasec.se/ctuserver"];
//    
// 
//    
//    // setting up the request object now
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//    [request setURL:[NSURL URLWithString:urlString]];
//    [request setHTTPMethod:@"POST"];
//    
//    NSMutableString *str_postData =[[NSMutableString alloc] init];
//    
//    [str_postData appendString:@""];
//    
//    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"INFRASEC_PASSWORD"])
//    {
//        
//        
//        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
//        // Convert date object into desired format
//        [dateFormatter setDateFormat:@"yyyyMMddHHmm"];
//        NSString *Str_date;
//        Str_date = [dateFormatter stringFromDate:[NSDate date]];
//     
//        
//        
//        [str_postData appendFormat:@"%@",[NSString stringWithFormat:@"<CtuRequest><ApplicationID>%@</ApplicationID><RequestID>AffarsIT_VERIFY_003</RequestID><ControlData><DateTime>%@</DateTime><OrgNr>1414141414</OrgNr><ManRegisterID>%@</ManRegisterID><SequenceNumber>3</SequenceNumber><ReceiptType Type='normal'/>",[[NSUserDefaults standardUserDefaults]valueForKey:@"INFRASEC_USERNAME"],Str_date, [[NSUserDefaults standardUserDefaults]valueForKey:@"INFRASEC_PASSWORD"]]];
//        
//        
//        [str_postData appendFormat:@"%@",[NSString stringWithFormat:@"<PurchaseAmount>%@</PurchaseAmount>",self.str_PurchaseAmount]];
//        
//    }
//    else
//    {
//        [str_postData appendFormat:@"%@",[NSString stringWithFormat:@"<PurchaseAmount>%@</PurchaseAmount>", self.str_PurchaseAmount]];
//    }
//    
//    for (int i=0; i<[self.vat_Variant count]; i++) {
//        
//        
//        [str_postData appendFormat:@"%@",[NSString stringWithFormat:@"<%@><Percent>%@</Percent><Amount>%@</Amount><%@>",[NSString stringWithFormat:@"VAT%d",i+1],[NSString stringWithFormat:@"%.2f",[[self.vat_Variant objectAtIndex:i ]floatValue]],[NSString stringWithFormat:@"%.2f",[[self.vat_Amount objectAtIndex:i ]floatValue]],[NSString stringWithFormat:@"/VAT%d",i+1]]];
//        
//    }
//    
//    [str_postData appendFormat:@"%@",[NSString stringWithFormat:@"</ControlData></CtuRequest>"]];
//    
//    
//    str_postData =[[str_postData stringByReplacingOccurrencesOfString:@"." withString:@","] mutableCopy];
//    
//    
//    NSString * message= [NSString stringWithFormat:@"%@",str_postData];
//    [request setHTTPBody:[message dataUsingEncoding:NSUTF8StringEncoding]];
//    [request addValue:@"application/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
//    
//    
//    // now lets make the connection to the web
//    
//    
//    NSURLConnection *nsurl = [[NSURLConnection alloc] initWithRequest:request delegate:self];
//    if ( !nsurl ) {
//        NSLog(@"Connection Establisted");
//    }
//    
//
//}

-(void)parserDidStartDocument:(NSXMLParser *)parser{
    

    
    self.mutDictionary = [[NSMutableDictionary alloc]init];
    
}

-(void)parserDidEndDocument:(NSXMLParser *)parser{
    

}


-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
    
    NSLog(@"%@", [parseError localizedDescription]);
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    
    
    NSLog(@"elementName : %@",elementName);
    
     if([elementName isEqualToString:@"CtuResponse"]){
          //  self.mutDictionary = [[NSMutableDictionary alloc]init];
    
}

    if ([elementName isEqualToString:@"type"])
    {
            //   self.mutDictionary = [[NSMutableDictionary alloc]init];
        
    }
    
    if ([elementName isEqualToString:@"response"])
    {
        //   self.mutDictionary = [[NSMutableDictionary alloc]init];
        
    }
    self.currentElement = elementName;
}


-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    
    NSLog(@"elementName : %@",elementName);
    
           //    if ([elementName isEqualToString:@"CtuResponse"])
    //    {
    //        [self.mutDictionary setObject:[NSString stringWithString:self.foundValue] forKey:@"CtuResponse"];
    //    }
    //    else if ([elementName isEqualToString:@"ResponseCode"])
    //    {
    //        [self.mutDictionary setObject:[NSString stringWithString:self.foundValue] forKey:@"ResponseCode"];
    //    }
    //    else if ([elementName isEqualToString:@"ResponseMessage"])
    //    {
    //        [self.mutDictionary setObject:[NSString stringWithString:self.foundValue] forKey:@"ResponseMessage"];
    //    }
    //    else if ([elementName isEqualToString:@"ResponseReason"])
    //    {
    //        [self.mutDictionary setObject:[NSString stringWithString:self.foundValue] forKey:@"CtuResponse"];
    //    }
    //    else if ([elementName isEqualToString:@"ApplicationID"])
    //    {
    //        [self.mutDictionary setObject:[NSString stringWithString:self.foundValue] forKey:@"ApplicationID"];
    //    }
    //    else if ([elementName isEqualToString:@"RequestID"])
    //    {
    //        [self.mutDictionary setObject:[NSString stringWithString:self.foundValue] forKey:@"RequestID"];
    //    }
    //    else if ([elementName isEqualToString:@"ControlCode"])
    //    {
    //        [self.mutDictionary setObject:[NSString stringWithString:self.foundValue] forKey:@"ControlCode"];
    //    }
    //    else if ([elementName isEqualToString:@"CTUID"])
    //    {
    //        [self.mutDictionary setObject:[NSString stringWithString:self.foundValue] forKey:@"CTUID"];
    //    }
    //    else if ([elementName isEqualToString:@"Code"])
    //    {
    //        [self.mutDictionary setObject:[NSString stringWithString:self.foundValue] forKey:@"Code"];
    //    }
    //    else if ([elementName isEqualToString:@"ControlCode"])
    //    {
    //        [self.mutDictionary setObject:[NSString stringWithString:self.foundValue] forKey:@"ControlCode"];
    //    }
    //    else if ([elementName isEqualToString:@"ControlCode"])
    //    {
    //        [self.mutDictionary setObject:[NSString stringWithString:self.foundValue] forKey:@"ControlCode"];
    //    }
    
}


-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    // Store the found characters if only we're interested in the current element.
    

    
    if ([self.currentElement isEqualToString:@"Code"]) {
        str_trnsCode=string;
    }
    
//    Old code for INFRASEC
//    if ([self.currentElement isEqualToString:@"CtuResponse"])
//    {
//        [self.mutDictionary setObject:string forKey:@"CtuResponse"];
//    }
//    else if ([self.currentElement isEqualToString:@"ResponseCode"])
//    {
//        [self.mutDictionary setObject:string forKey:@"ResponseCode"];
//    }
//    else if ([self.currentElement isEqualToString:@"ResponseMessage"])
//    {
//        [self.mutDictionary setObject:string forKey:@"ResponseMessage"];
//    }
//    else if ([self.currentElement isEqualToString:@"ResponseReason"])
//    {
//        [self.mutDictionary setObject:string forKey:@"CtuResponse"];
//    }
//    else if ([self.currentElement isEqualToString:@"ApplicationID"])
//    {
//        [self.mutDictionary setObject:string forKey:@"ApplicationID"];
//    }
//    else if ([self.currentElement isEqualToString:@"RequestID"])
//    {
//        [self.mutDictionary setObject:string forKey:@"RequestID"];
//    }
//    else if ([self.currentElement isEqualToString:@"ControlCode"])
//    {
//        [self.mutDictionary setObject:string forKey:@"ControlCode"];
//    }
//    else if ([self.currentElement isEqualToString:@"CTUID"])
//    {
//        [self.mutDictionary setObject:string forKey:@"CTUID"];
//    }
//    else if ([self.currentElement isEqualToString:@"Code"])
//    {
//        [self.mutDictionary setObject:string forKey:@"Code"];
//    }
//    else if ([self.currentElement isEqualToString:@"ControlCode"])
//    {
//        [self.mutDictionary setObject:string forKey:@"ControlCode"];
//    }
    
    
    if ([self.currentElement isEqualToString:@"response"])
    {
         [self.mutDictionary setObject:string forKey:@"response"];
    }
    else if ([self.currentElement isEqualToString:@"type"])
    {
        [self.mutDictionary setObject:string forKey:@"type"];
    }
    else if ([self.currentElement isEqualToString:@"data"])
    {
        [self.mutDictionary setObject:string forKey:@"data"];
    }
    else if ([self.currentElement isEqualToString:@"RegisterResult"])
    {
        [self.mutDictionary setObject:string forKey:@"RegisterResult"];
    }
    else if ([self.currentElement isEqualToString:@"Code"])
    {
        [self.mutDictionary setObject:string forKey:@"Code"];
    }
    else if ([self.currentElement isEqualToString:@"UnitId"])
    {
        [self.mutDictionary setObject:string forKey:@"UnitId"];
    }
    else if ([self.currentElement isEqualToString:@"UnitMainStatus"])
    {
        [self.mutDictionary setObject:string forKey:@"UnitMainStatus"];
    }
    else if ([self.currentElement isEqualToString:@"UnitStorageStatus"])
    {
        [self.mutDictionary setObject:string forKey:@"UnitStorageStatus"];
    }
    else if ([self.currentElement isEqualToString:@"ShortMessage"])
    {
        [self.mutDictionary setObject:string forKey:@"ShortMessage"];
        NSLog(@"Short message -\n %@",self.currentElement);
    }
    else if ([self.currentElement isEqualToString:@"Message"])
    {
        [self.mutDictionary setObject:string forKey:@"Message"];
    }
    else if([self.currentElement isEqualToString:@"FaultInfo"])
    {
        [self.mutDictionary setObject:string forKey:@"FaultInfo"];
    }
    
}

#pragma mark Xml end

-(void)getTransCode
{
    //    NSString *urlString = [NSString stringWithFormat:@"http://ganga.impingesolutions.com:9292/api/Isupos/postData"];
    NSString *urlString = [NSString stringWithFormat:@"https://affarsit.ccu.verify.infrasec.se/ctuserver/api/Isupos/postData"];
    
    NSMutableURLRequest *request3 = [[NSMutableURLRequest alloc] init];
    [request3 setURL:[NSURL URLWithString:urlString]];
    [request3 setHTTPMethod:@"POST"];
    
    //set headers
    NSString *contentType = [NSString stringWithFormat:@"text/json"];
    [request3 addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    //create the body
    NSMutableData *postBody = [NSMutableData data];
    
    
    
    NSMutableString *str_postData =[[NSMutableString alloc] init];
    
    [str_postData appendString:@""];
    
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"INFRASEC_PASSWORD"])
    {
        
        //        NSString *str_appId=@"AffarsIT VERIFY";
        //        NSString *str_appId=@"AffarsIT VERIFY";
        //
        //
        //        <CtuRequest><ApplicationID>AffarsIT VERIFY</ApplicationID><RequestID>AffarsIT_VERIFY_003</RequestID><ControlData><DateTime>201501301200</DateTime><OrgNr>1414141414</OrgNr><ManRegisterID>AT10000050312001</ManRegisterID><SequenceNumber>3</SequenceNumber><ReceiptType Type='normal'/>
        
        
        //    <ApplicationID>AffarsIT VERIFY</ApplicationID><ManRegisterID>AT10000050312001</ManRegisterID>
        
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        // Convert date object into desired format
        [dateFormatter setDateFormat:@"yyyyMMddHHmm"];
        NSString *Str_date;
        Str_date = [dateFormatter stringFromDate:[NSDate date]];
        
    
        
        [str_postData appendFormat:@"%@",[NSString stringWithFormat:@"{\"getReceipt\":\"<CtuRequest><ApplicationID>%@</ApplicationID><RequestID>AffarsIT_VERIFY_003</RequestID><ControlData><DateTime>%@</DateTime><OrgNr>1414141414</OrgNr><ManRegisterID>%@</ManRegisterID><SequenceNumber>3</SequenceNumber><ReceiptType Type='normal'/>",[[NSUserDefaults standardUserDefaults]valueForKey:@"INFRASEC_USERNAME"],Str_date, [[NSUserDefaults standardUserDefaults]valueForKey:@"INFRASEC_PASSWORD"]]];
        
        
        [str_postData appendFormat:@"%@",[NSString stringWithFormat:@"<PurchaseAmount>%@</PurchaseAmount>",self.str_PurchaseAmount]];
        
    }
    else
    {
        [str_postData appendFormat:@"%@",[NSString stringWithFormat:@"{\"getReceipt\":\"<PurchaseAmount>%@</PurchaseAmount>", self.str_PurchaseAmount]];
    }
    
    for (int i=0; i<[self.vat_Variant count]; i++) {
        
        
        [str_postData appendFormat:@"%@",[NSString stringWithFormat:@"<%@><Percent>%@</Percent><Amount>%@</Amount><%@>",[NSString stringWithFormat:@"VAT%d",i+1],[NSString stringWithFormat:@"%.2f",[[self.vat_Variant objectAtIndex:i ]floatValue]],[NSString stringWithFormat:@"%.2f",[[self.vat_Amount objectAtIndex:i ]floatValue]],[NSString stringWithFormat:@"/VAT%d",i+1]]];
        
    }
    
    [str_postData appendFormat:@"%@",[NSString stringWithFormat:@"</ControlData></CtuRequest>\"}"]];
    
    
    str_postData =[[str_postData stringByReplacingOccurrencesOfString:@"." withString:@","] mutableCopy];
    
    
    
    //    [postBody appendData:[[NSString stringWithFormat:@"{\"getReceipt\":\"<PurchaseAmount>10,00</PurchaseAmount><VAT1><Percent>25,00</Percent><Amount>2,00</Amount></VAT1><VAT2><Percent>12,00</Percent><Amount>0,00</Amount></VAT2><VAT3><Percent>6,00</Percent><Amount>0,00</Amount></VAT3><VAT4><Percent>0,00</Percent><Amount>0,00</Amount></VAT4></ControlData></CtuRequest>\""] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    [postBody appendData:[str_postData dataUsingEncoding:NSUTF8StringEncoding]];
    
   
    //post
    [request3 setHTTPBody:postBody];
    
    //get response
    //    NSHTTPURLResponse* urlResponse = nil;
    NSHTTPURLResponse* urlResponse;
    
    NSError *errorxxx = [[NSError alloc] init];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request3 returningResponse:&urlResponse error:&errorxxx];
    
    if (responseData == nil) {
        [[[UIAlertView alloc] initWithTitle:@"ISUPOS" message:[Language get:@"Please check your internet connection." alter:@"!Please check your internet connection."] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
    else
    {
        NSMutableDictionary *object =[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&errorxxx];
        
        NSString *result = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];

        
        if ([object isEqual:NULL] && [object isEqual:[NSNull null]])
        {
            [[[UIAlertView alloc] initWithTitle:@"ISUPOS" message:[Language get:@"Some error has occurred. Please check your Infrasec credntials" alter:@"!Some error has occurred. Please check your Infrasec credntials"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
        else if (![[[object valueForKey:@"CtuResponse"] valueForKey:@"ResponseCode"] isEqualToString:@"0"])
        {
            [[[UIAlertView alloc] initWithTitle:@"ISUPOS" message:[[object valueForKey:@"CtuResponse"] valueForKey:@"ResponseReason"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
        
        
        
        if ([urlResponse statusCode] >= 200 && [urlResponse statusCode] < 300)
            
            //    if([[[object valueForKey:@"CtuResponse"] valueForKey:@"ResponseMessage"] isEqualToString:@"Success"])
        {
       
  
            
            if (![[[[object valueForKey:@"CtuResponse"] valueForKey:@"ControlCode"] valueForKey:@"Code"] isEqual:NULL] && ![[[[object valueForKey:@"CtuResponse"] valueForKey:@"ControlCode"] valueForKey:@"Code"] isEqual:[NSNull null]] &&![[[[object valueForKey:@"CtuResponse"] valueForKey:@"ControlCode"] valueForKey:@"Code"] isEqualToString:@"<null>"]) {
                
                str_trnsCode=[[[object valueForKey:@"CtuResponse"] valueForKey:@"ControlCode"] valueForKey:@"Code"];
            }
            else
            {
                NSLog(@"Null");
            }
            
            
        }
        
        
        for(int i=0;i<arrayVat.count;i++)
        {
            
        }
        
        if (![[[[object valueForKey:@"CtuResponse"] valueForKey:@"ControlCode"] valueForKey:@"Code"] isEqual:NULL] && ![[[[object valueForKey:@"CtuResponse"] valueForKey:@"ControlCode"] valueForKey:@"Code"] isEqual:[NSNull null]] &&![[[[object valueForKey:@"CtuResponse"] valueForKey:@"ControlCode"] valueForKey:@"Code"] isEqualToString:@"<null>"])
        {
            [self saveData];
        }
        else
        {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            
        }
    }
}

-(void)clearCart
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    
    NSManagedObjectContext *context =[appDelegate managedObjectContext];
    NSError *error;
    
    NSFetchRequest *request2 = [NSFetchRequest fetchRequestWithEntityName:@"CustomDiscount"];
    NSPredicate *predicate;
    predicate = [NSPredicate predicateWithFormat:@"(id = %@)",@"1S"];
    [request2 setPredicate:predicate];
    
    NSArray *objects2 = [context executeFetchRequest:request2 error:&error];
    if (objects2 == nil) {
        // handle error
    } else {
        for (NSManagedObject *object in objects2) {
            [context deleteObject:object];
        }
        [context save:&error];
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
    
    [[NSUserDefaults standardUserDefaults] setObject:@"No" forKey:@"None"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"None"] isEqualToString:@"Yes"]) {
        
        paymentdone=NO;
        
    }
    else
    {
    paymentdone=YES;
    }
    [callBack performSelector:@selector(toDismissThePopover)];
}

#pragma mark SSL Certificate Verification Code
- (void) useCredential:(NSURLCredential *)credential forAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
    NSLog(@"forAuthenticationChallenge");
}

- (void) cancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    NSLog(@"cancelAuthenticationChallenge");
}

- (void) continueWithoutCredentialForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    NSLog(@"continueWithoutCredentialForAuthenticationChallenge");
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    NSLog(@"didReceiveAuthenticationChallenge");
    
    if ( [challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust] )
    {
        [challenge.sender useCredential:[NSURLCredential credentialForTrust: challenge.protectionSpace.serverTrust] forAuthenticationChallenge: challenge];
        return;
    }
    
    if ( [challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodHTTPBasic] )
    {
        
        NSString *p12Path = [[NSBundle mainBundle] pathForResource:@"clientNew" ofType:@"p12"];
        NSData *p12Data = [[NSData alloc] initWithContentsOfFile:p12Path];
        
        CFStringRef password = CFSTR("aq1sw2");
        const void *keys[] = { kSecImportExportPassphrase };
        const void *values[] = { password };
        CFDictionaryRef optionsDictionary = CFDictionaryCreate(NULL, keys, values, 1, NULL, NULL);
        CFArrayRef p12Items;
        
        OSStatus result = SecPKCS12Import((__bridge CFDataRef)p12Data, optionsDictionary, &p12Items);
        
        if(result == noErr) {
            CFDictionaryRef identityDict = CFArrayGetValueAtIndex(p12Items, 0);
            SecIdentityRef identityApp =(SecIdentityRef)CFDictionaryGetValue(identityDict,kSecImportItemIdentity);
            
            SecCertificateRef certRef;
            SecIdentityCopyCertificate(identityApp, &certRef);
            
            SecCertificateRef certArray[1] = { certRef };
            CFArrayRef myCerts = CFArrayCreate(NULL, (void *)certArray, 1, NULL);
            CFRelease(certRef);
            
            NSURLCredential *credential = [NSURLCredential credentialWithIdentity:identityApp certificates:(__bridge NSArray *)myCerts persistence:NSURLCredentialPersistencePermanent];
            CFRelease(myCerts);
            
            [[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
            
            NSLog(@"myCerts : %@",myCerts);
            
        }

        
        
    }
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"didReceiveResponse");
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"didReceiveData");
    
    
    
    if (data) {
        
        self.xmlParser = [[NSXMLParser alloc]initWithData:data];
        self.xmlParser.delegate = self;
        
        self.foundValue = [[NSMutableString alloc]init];
        [self.xmlParser parse];
        
        
        if (self.mutDictionary == nil) {
            [[[UIAlertView alloc] initWithTitle:@"ISUPOS" message:[Language get:@"Please check your internet connection." alter:@"!Please check your internet connection."] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
        else
        {
            
            NSLog(@"Greengate Response Data -- \n %@", self.mutDictionary);
            
            if ([self.mutDictionary isEqual:NULL] && [self.mutDictionary isEqual:[NSNull null]])
            {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [[[UIAlertView alloc] initWithTitle:@"ISUPOS" message:[Language get:@"Some error has occurred. Please check your Greengate credntials" alter:@"!Some error has occurred. Please check your Greengate credntials"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }
            else if ( [[self.mutDictionary valueForKey:@"type"] isEqualToString:@"RegisterReceiptResponse"])
            {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
               // [[[UIAlertView alloc] initWithTitle:@"ISUPOS" message:@"Success" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }
            else if( [[self.mutDictionary valueForKey:@"type"] isEqualToString:@"Fault"])
            {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                   [[[UIAlertView alloc] initWithTitle:@"ISUPOS" message:[self.mutDictionary valueForKey:@"Message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            }
                     
                     
                     
//            else if (![[self.mutDictionary valueForKey:@"ResponseCode"] isEqualToString:@"0"])
//            {
//                [[[UIAlertView alloc] initWithTitle:@"ISUPOS" message:[self.mutDictionary valueForKey:@"ResponseMessage"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
//            }
           
            
            
           if ( [[self.mutDictionary valueForKey:@"type"] isEqualToString:@"RegisterReceiptResponse"]) {
               
            if (![[self.mutDictionary valueForKey:@"Code"] isEqual:NULL] && ![[self.mutDictionary valueForKey:@"Code"] isEqual:[NSNull null]] &&![[self.mutDictionary valueForKey:@"Code"] isEqualToString:@"<null>"]&&[self.mutDictionary valueForKey:@"Code"] !=nil) {
                
                str_trnsCode=[self.mutDictionary valueForKey:@"Code"];
                [[NSUserDefaults standardUserDefaults] setObject:[self.mutDictionary valueForKey:@"Code"] forKey:@"Code"];
                [[NSUserDefaults standardUserDefaults] setObject:[self.mutDictionary valueForKey:@"UnitId"] forKey:@"UnitId"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            else
            {
          
                str_trnsCode=@"";
            }
           }
            
        }
        
        
        for(int i=0;i<arrayVat.count;i++)
        {
            
        }
        if ( [[self.mutDictionary valueForKey:@"type"] isEqualToString:@"RegisterReceiptResponse"]){
            if (![[self.mutDictionary valueForKey:@"Code"] isEqual:NULL] && ![[self.mutDictionary valueForKey:@"Code"] isEqual:[NSNull null]] &&![[self.mutDictionary valueForKey:@"Code"] isEqualToString:@"<null>"]&&[self.mutDictionary valueForKey:@"Code"] !=nil)
            {
                [self saveData];
            }
            else
            {
                [MBProgressHUD hideHUDForView:self.view animated:YES];

            }
        }
    }
    
    
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    // inform the user
    NSLog(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
    
    [[[UIAlertView alloc] initWithTitle:@"ISUPOS" message:[NSString stringWithFormat:@"Connection failed! Error - %@ %@",[error localizedDescription],[[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    
     [MBProgressHUD hideHUDForView:self.view animated:YES];
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"Succeeded! Received bytes of data");
    
}


- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace: (NSURLProtectionSpace *)protectionSpace
{
    NSLog(@"canAuthenticateAgainstProtectionSpace");
    NSLog(protectionSpace.authenticationMethod);
    return true;

}


-(NSData *)getData{
    NSLog(@"getData");
    return nil;
}

#pragma mark auto print and mail

-(void)getAllTrasection:(NSString*)receiptID
{
    dictAllItems = [NSMutableArray new];
    
    NSMutableArray *arraySub = [NSMutableArray new];
    NSMutableArray *arraySubb = [NSMutableArray new];
    NSMutableArray *arrayMain = [NSMutableArray new];
    
    NSString *cuDate = nil;
    
    int curId = -1;
    
    float tprice = 0;
    float tpricewithoutvat = 0;
    
    total=0.0;
    totalvat=0.0;
    
    float_TotalPrice = 0.0;
    int_TotalVat = 0;
    float_Discount = 0.0;
    str_Multiple = @"No";
    
    NSManagedObjectContext *context =[appDelegate managedObjectContext];
    NSEntityDescription *entityDesc =[NSEntityDescription entityForName:@"Trasections" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    NSPredicate *predicate;
    predicate = [NSPredicate predicateWithFormat:@"(id = %@)", receiptID];
    [request setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    
    NSArray *descriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:descriptors];
    
    NSError *error;
    
    NSArray *objects = [context executeFetchRequest:request error:&error];
    
    NSEntityDescription *entityDesc2 =[NSEntityDescription entityForName:@"CustomDiscount" inManagedObjectContext:context];
    NSFetchRequest *request11 = [[NSFetchRequest alloc] init];
    [request11 setEntity:entityDesc2];
    

    for(int i=0;i<objects.count;i++)
    {
        
        dictSub = [NSMutableDictionary new];
        
        
        NSManagedObject *person = (NSManagedObject *)[objects objectAtIndex:i];
        
        NSPredicate *predicate;
        predicate = [NSPredicate predicateWithFormat:@"(id = %@)", [person valueForKey:@"id"]];
        [request11 setPredicate:predicate];
        
        NSError *error2;
        NSArray *objects2 = [context executeFetchRequest:request11 error:&error2];
        
        NSManagedObject *person2;
        
        
        for(int i=0;i<objects2.count;i++)
        {
            person2 = (NSManagedObject *)[objects2 objectAtIndex:i];
            
            [dictSub setObject:[person2 valueForKey:@"discount"] forKey:@"discount"];
            [dictSub setObject:[person2 valueForKey:@"type"] forKey:@"type"];
            
        }
        
        NSData *da=[person valueForKey:@"image"];
        
        UIImage *img=[[UIImage alloc] initWithData:da];
        
        [dictSub setObject:img forKey:@"image"];
        [dictSub setObject:[CommonMethods validateDictionaryValueForKey:[person valueForKey:@"name"]]?[person valueForKey:@"name"]:@"" forKey:@"name"];
        [dictSub setObject:str_QuickBlockName?str_QuickBlockName:@"" forKey:@"groupName"];
        [dictSub setObject:[CommonMethods validateDictionaryValueForKey:[person valueForKey:@"count"]]?[person valueForKey:@"count"]:@"" forKey:@"count"];
        [dictSub setObject:[CommonMethods validateDictionaryValueForKey:[person valueForKey:@"price"]]?[person valueForKey:@"price"]:@"" forKey:@"price"];
        [dictSub setObject:[CommonMethods validateDictionaryValueForKey:[person valueForKey:@"vat"]]?[person valueForKey:@"vat"]:@"" forKey:@"vat"];
        [dictSub setObject:[CommonMethods validateDictionaryValueForKey:[person valueForKey:@"code"]]?[person valueForKey:@"code"]:@"" forKey:@"code"];
        [dictSub setObject:[CommonMethods validateDictionaryValueForKey:[person valueForKey:@"currency"]]?[person valueForKey:@"currency"]:@"" forKey:@"currency"];
        [dictSub setObject:[CommonMethods validateDictionaryValueForKey:[person valueForKey:@"discount"]]?[person valueForKey:@"discount"]:@"" forKey:@"discount1"];
        [dictSub setObject:[CommonMethods validateDictionaryValueForKey:[person valueForKey:@"printStatus"]]?[person valueForKey:@"printStatus"]:@"" forKey:@"printStatus"];
        [dictSub setObject:[CommonMethods validateDictionaryValueForKey:[person valueForKey:@"mailStatus"]]?[person valueForKey:@"mailStatus"]:@"" forKey:@"mailStatus"];
        [dictSub setObject:[CommonMethods validateDictionaryValueForKey:[person valueForKey:@"paymentMethod"]]?[person valueForKey:@"paymentMethod"]:@"" forKey:@"paymentMethod"];
        [dictSub setObject:[CommonMethods validateDictionaryValueForKey:[person valueForKey:@"article_id"]]?[person valueForKey:@"article_id"]:@"" forKey:@"article_id"];
        [dictSub setObject:[CommonMethods validateDictionaryValueForKey:[person valueForKey:@"rid"]]?[person valueForKey:@"rid"]:@"" forKey:@"rid"];
        [dictSub setObject:[CommonMethods validateDictionaryValueForKey:[person valueForKey:@"id"]]?[person valueForKey:@"id"]:@"" forKey:@"id"];
        
//        [dictSub setObject:[person valueForKey:@"name"] forKey:@"name"];
//        [dictSub setObject:[person valueForKey:@"count"] forKey:@"count"];
//        [dictSub setObject:[person valueForKey:@"price"] forKey:@"price"];
//        [dictSub setObject:[person valueForKey:@"vat"] forKey:@"vat"];
//        [dictSub setObject:[person valueForKey:@"code"] forKey:@"code"];
//        [dictSub setObject:[person valueForKey:@"currency"] forKey:@"currency"];
//        [dictSub setObject:[person valueForKey:@"discount"] forKey:@"discount1"];
//        [dictSub setObject:[person valueForKey:@"printStatus"] forKey:@"printStatus"];
//        [dictSub setObject:[person valueForKey:@"mailStatus"] forKey:@"mailStatus"];
//        [dictSub setObject:[person valueForKey:@"paymentMethod"] forKey:@"paymentMethod"];
//        [dictSub setObject:[person valueForKey:@"article_id"] forKey:@"article_id"];
//        
//        if ([person valueForKey:@"rid"] != nil)
//        {
//            [dictSub setObject:[person valueForKey:@"rid"] forKey:@"rid"];
//        }
//        else
//            [dictSub setObject:[NSNumber numberWithInt:0] forKey:@"rid"];
//        
//        
//        [dictSub setObject:[person valueForKey:@"id"] forKey:@"id"];
        [dictSub setObject:@"0" forKey:@"totalAmount"];
        
      
      //  [dictSub setObjectWithNilKeyValidation:[person valueForKey:@"discription"] forKey:@"discription"];
        [dictSub setObject:[CommonMethods validateDictionaryValueForKey:[person valueForKey:@"discription"]]?[person valueForKey:@"discription"]:@"" forKey:@"discription"];
      //  [dictSub setObject:[person valueForKey:@"discription"] forKey:@"discription"];
        NSLog(@"dictSub = /n %@", dictSub);
        NSDate *date  = [person valueForKey:@"date"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        // Convert date object into desired format
        [dateFormatter setDateFormat:@"dd MMMM yyyy"];
        NSString *newDateString = [dateFormatter stringFromDate:date];
        [dictSub setObject:newDateString forKey:@"date"];
        
        
        [dateFormatter setDateFormat:@"hh:mm:ss a"];
        NSString *timeString = [dateFormatter stringFromDate:date];
        [dictSub setObject:timeString forKey:@"time"];
        
        zzzz=[[dictSub valueForKey:@"price"] floatValue];//-[[person valueForKey:@"discount"]floatValue]);
        
        [dictSub setObject:[NSString stringWithFormat:@"%.02f",zzzz] forKey:@"peritemprice"];
        
        
        
        if(curId == -1)
            curId = [[dictSub valueForKey:@"id"] intValue];
        else if (curId != [[dictSub valueForKey:@"id"] intValue])
        {
            
            
            NSMutableDictionary *dictSubb = [NSMutableDictionary new];
            
            
            
            float totalPrice = 0.0;
            float vat = 0.0;
            float vatPercent = (totalvat*100)/tpricewithoutvat;
            
            if ([str_DiscountType isEqualToString:@"$"])
            {
                
                totalPrice = tprice - float_Discount;
                
                
            }
            else
            {
                totalPrice = tprice - ((tprice*float_Discount)/100);
                
            }
            vat = totalPrice-(totalPrice/(1+vatPercent/100));
            
            [dictSubb setObject:[NSString stringWithFormat:@"%.2f",totalPrice] forKey:@"tprice"];
            [dictSubb setObject:[NSString stringWithFormat:@"%f",vat] forKey:@"totalvat"];
            
            [dictSubb setObject:[NSNumber numberWithFloat:exchange] forKey:@"exchange"];
            
            [dictSubb setObject:[dictSub valueForKey:@"code"] forKey:@"code"];
            [dictSubb setObject:[NSString stringWithFormat:@"%d",curId] forKey:@"id"];
            
            
            
            [dictSubb setObject:arraySubb forKey:@"sub"];
            
            
            [arraySub addObject:dictSubb];
            
            total = 0;
            tprice = 0;
            tpricewithoutvat = 0;
            totalvat = 0;
            float_Discount = 0;
            arraySubb = [NSMutableArray new];
            curId = [[dictSub valueForKey:@"id"] intValue];
            
            
            str_Multiple = @"No";
            
        }
        else if(curId == [[dictSub valueForKey:@"id"] intValue])
        {
            
            str_Multiple = @"Yes";
            
            
        }
        
        if(cuDate == nil)
            cuDate = newDateString;
        else if (![cuDate isEqualToString:newDateString])
        {
            
        }
        
        
        
        
        //        total = ([[person valueForKey:@"price"] floatValue] * [[person valueForKey:@"count"] integerValue]);
        
        float discountperproduct;
        
        if([[person valueForKey:@"discountType"] isEqualToString:@"%"] || [person valueForKey:@"discountType"] == nil)
        {
            discountperproduct=([[person valueForKey:@"price"]floatValue]*[[person valueForKey:@"count"]intValue]*[[person valueForKey:@"discount"]floatValue])/100;
        }
        else
        {
            discountperproduct=[[person valueForKey:@"discount"]floatValue];
        }
        
        total=(([[dictSub valueForKey:@"price"] floatValue] *[[dictSub valueForKey:@"count"] integerValue])-discountperproduct);
        
        tpricewithoutvat = (([[dictSub valueForKey:@"price"] floatValue]*[[dictSub valueForKey:@"count"] integerValue])-discountperproduct) / (1 + [[dictSub valueForKey:@"vat"] floatValue]/100) + tpricewithoutvat;
        
        
        zzzz = (([[dictSub valueForKey:@"price"] floatValue]*[[dictSub valueForKey:@"count"] integerValue])-discountperproduct) / (1 + [[dictSub valueForKey:@"vat"] floatValue]/100);
        
        
        
        zzzz=(([[dictSub valueForKey:@"price"] floatValue] *[[dictSub valueForKey:@"count"] integerValue])-discountperproduct)-zzzz;
        
        //        zzzz=total-zzzz;
        
        totalvat = zzzz + totalvat;
        
        
        //        tpricewithoutvat = (([[person valueForKey:@"price"] floatValue]*[[person valueForKey:@"count"] integerValue])-[[person valueForKey:@"discount"]floatValue]) / (1 + [[person valueForKey:@"vat"] floatValue]/100) + tpricewithoutvat;
        
        
        
        
        tprice = tprice + total;
        
        NSString *str_IDs=[NSString stringWithFormat:@"%@",[dictSub valueForKey:@"id"]];
        
        if ([str_IDs hasPrefix:@","])
        {
            str_IDs = [str_IDs substringFromIndex:1];
        }
        
        float_Discount = [self GetDiscountList:str_IDs];
        
        total=total-float_Discount;
        
        [dictSub setObject:[NSString stringWithFormat:@"%ld", (long)total] forKey:@"price"];
        
        
        
        //        if (person2)
        //        {
        //
        //            if([[person2 valueForKey:@"type"] isEqualToString:currencySign])
        //            {
        //                str_DiscountType = @"$";
        //            }
        //            else
        //            {
        //                str_DiscountType = @"%";
        //            }
        //
        //            float_Discount = [[person2 valueForKey:@"discount"]intValue];
        //        }
        //        else
        //        {
        //            float_Discount = [[person valueForKey:@"discount"]intValue];
        //        }
        
        
        [arraySubb addObject:dictSub];
    }
    
    if (objects.count != 0)
    {
        
        
         NSMutableDictionary *dictSubb = [NSMutableDictionary new];
        [dictSubb setObject:[NSString stringWithFormat:@"%d",curId] forKey:@"id"];
        [dictSubb setObject:arraySubb forKey:@"sub"];
        
        
        
        float totalPrice = 0.0;
        float vat = 0.0;
        float vatPercent = (totalvat*100)/tpricewithoutvat;
        
        if ([str_DiscountType isEqualToString:@"$"])
        {
            totalPrice = tprice - float_Discount;
            
        }
        else
        {
            totalPrice = tprice - ((tprice*float_Discount)/100);
            
        }
        
        vat = totalPrice-(totalPrice/(1+vatPercent/100));
        
        [dictSubb setObject:[NSString stringWithFormat:@"%.2f",totalPrice] forKey:@"tprice"];
        [dictSubb setObject:[NSString stringWithFormat:@"%f",vat] forKey:@"totalvat"];
        
        [dictSubb setObject:[NSNumber numberWithFloat:exchange] forKey:@"exchange"];
        
        [arraySub addObject:dictSubb];
        
        
//        NSArray *sortedArray = [arraySub sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *a, NSDictionary *b)
//                                {
//                                    NSString *valueA = [[[a valueForKey:@"sub"] objectAtIndex:0] valueForKey:@"time"];
//                                    NSString *valueB = [[[b valueForKey:@"sub"] objectAtIndex:0] valueForKey:@"time"];
//                                    
//                                    return [valueB compare:valueA];
//                                }];
//        
//        
//        arraySub = [NSMutableArray arrayWithArray:sortedArray];
        
        
        NSMutableDictionary *dictMain = [NSMutableDictionary new];
        [dictMain setObject:cuDate forKey:@"date"];
        [dictMain setObject:arraySub forKey:@"main"];
        [dictMain setObject:@"NO" forKey:@"IsRepurchase"];
        [dictMain setObject:@"0.0" forKey:@"RefundableQuantity"];
        
        NSManagedObjectContext *context =[appDelegate managedObjectContext];
        
        NSEntityDescription *entityDesc2 =[NSEntityDescription entityForName:@"CustomDiscount" inManagedObjectContext:context];
        NSFetchRequest *request11 = [[NSFetchRequest alloc] init];
        [request11 setEntity:entityDesc2];
        NSPredicate *predicate;
        predicate = [NSPredicate predicateWithFormat:@"(id = %@)",@"1S"];
        [request11 setPredicate:predicate];
        NSError *error;
        NSArray *objects2 = [context executeFetchRequest:request11 error:&error];
        if(objects2.count>0)
        {
            NSManagedObject *person = (NSManagedObject *)[objects2 objectAtIndex:0];
            
            [dictMain setObject:[person valueForKey:@"discription"] forKey:@"DiscountComment"];
        }
        else
        {
            [dictMain setObject:@"" forKey:@"DiscountComment"];
        }
        
        
        
        
        [arrayMain addObject:dictMain];
    
        appDelegate.reciptArray=arrayMain;
        dictAllItems = arrayMain;
  
        
        ISUPosSoapService *service = [[ISUPosSoapService alloc] init];
        
        NSLog(@"app:%@",appDelegate.reciptArray);
        
        [service PostRegisterSale:self action:@selector(PostRegisterSaleData) ary:(NSMutableArray *)appDelegate.reciptArray];
        
        [self setMiddlePart];
        
        
    }
    else
    {
       
    }
    
    
    
   
}

-(float)GetDiscountList:(NSString *)IDs
{
    NSManagedObjectContext *context =[appDelegate managedObjectContext];
    
    
    NSEntityDescription *entityDesc2 =[NSEntityDescription entityForName:@"CustomDiscount" inManagedObjectContext:context];
    NSFetchRequest *request11 = [[NSFetchRequest alloc] init];
    [request11 setEntity:entityDesc2];
    NSError *error2;
    NSArray *objects2 = [context executeFetchRequest:request11 error:&error2];
    
    NSManagedObject *person2;
    
    float sumnew=0.0;
    float sumnewCash=0.0;
    float sumnewCard=0.0;
    
    for(int i=0;i<objects2.count;i++)
    {
        
        NSArray* ary_ID = [IDs componentsSeparatedByString: @","];
        
        
        str_DiscountType = @"$";
        
        
        if ([ary_ID count]>0)
        {
            if ([ary_ID containsObject:[NSString stringWithFormat:@"%@",[[objects2 objectAtIndex:i] valueForKey:@"id"]]])
            {
                person2 = (NSManagedObject *)[objects2 objectAtIndex:i];
                
                if ([str_PaymentMethod isEqualToString:@"2"]) {
                    
                    sumnewCard = [[person2 valueForKey:@"discount"] floatValue]+sumnew;

                }
                else{
                    
                    sumnewCash = [[person2 valueForKey:@"discount"] floatValue]+sumnew;

                    
                }
                
                sumnew = [[person2 valueForKey:@"discount"] floatValue]+sumnew;
                
            }
        }
        
    }
    
    if ([str_PaymentMethod isEqualToString:@"2"]) {
         return sumnewCard;
    }
    else
    {
        return sumnewCash;
    }
    
//    return sumnew;
}

-(void)setIndex
{
   
    for(int i=0; i<[[dictAllItems valueForKey:@"main"] count]; i++) {
        
//        [[[array_SearchData objectAtIndex:selectedSection] objectForKey:@"main"] objectAtIndex:selectedRow]
        
        for (int j=0; j<[[[dictAllItems valueForKey:@"main"] objectAtIndex:i] count];j++) {
            
            if ([str_transactionId isEqualToString:[[[[dictAllItems objectAtIndex:i]objectForKey:@"main"] objectAtIndex:j]  valueForKey:@"sub"]]) {
                
                selectedSection=i;
                selectedRow=j;
                
            }
            
        }
    
    }
    
    [self setMiddlePart];
    
}


-(void)setMiddlePart
{
    NSMutableArray * arrayItems;
    
 
        if ([dictAllItems count]>0)
            arrayItems = [[[dictAllItems objectAtIndex:selectedSection] objectForKey:@"main"] objectAtIndex:selectedRow];

    
    appDelegate.reciptArray=arrayItems;
    
    NSLog(@"app%@",appDelegate.reciptArray);

    if (receiptMethodTag==1) {
  
    [self select_printerAndPrintPayment];
    
    }
    else if(receiptMethodTag==2) {

        
        
        Reachability *reachability = [Reachability reachabilityForInternetConnection];
        NetworkStatus internetStatus = [reachability currentReachabilityStatus];
        if (internetStatus != NotReachable) {
            
            
            [[NSUserDefaults standardUserDefaults] setObject:@"Tran" forKey:@"MailType"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            NSString *email = txt_Email.text;
            [[NSUserDefaults standardUserDefaults] setObject:email forKey:@"EMAIL"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            // send receipt in mail
            [[AppDelegate delegate] sendMailWithSubject:[NSString stringWithFormat:@"%@", [Language get:@"Receipt" alter:@"!Receipt"]]  sendFrom:@"" ToReciepents:@"" messageHtmlBodyContent:@""];
            
            [appDelegate PrintAndMailCountUpdate:1 amount:0];
            
            [self clearCart];
            
        }
 
    }
    
}


#pragma mark Printer Methods


- (IBAction)select_printerAndPrintPayment
{
    [self setPortInfo];
    NSString *portName = [AppDelegate getPortName];
    NSString *portSettings = [AppDelegate getPortSettings];
    

    [[NSUserDefaults standardUserDefaults] setObject:@"Original" forKey:@"ReciptType"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
        
    [appDelegate PrintAndMailCountUpdate:2 amount:0];
  
    if([[[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:0] valueForKey:@"paymentMethod"] isEqualToString:@"2"]){
        
        appDelegate.customerReceipt = completedTransaction.customerReceipt;
        [appDelegate addReceiptData];

       // print for card payment
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"print_combined_receipt"];
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"print_merchant_receipt"];
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"print_customer_receipt"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    else{ // print for cash payment
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"print_combined_receipt"];
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"print_merchant_receipt"];
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"print_customer_receipt"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    [MiniPrinterFunctions PrintSampleReceiptWithPortname:portName
                                                portSettings:portSettings
                                                   widthInch:2];
        
     [self clearCart];
    
}

#pragma mark - EmailPopUp

-(IBAction)buttonDropDownOKCancel:(UIButton *)sender
{
    if (sender == btn_DropDown)
    {
        if (tbl_EmailList.hidden)
        {
            tbl_EmailList.hidden = NO;
            [tbl_EmailList reloadData];
        }
        else
        {
            tbl_EmailList.hidden = YES;
        }
        
    }
    else if (sender == btn_EmailOk)
    {
        
        if (txt_Email.text.length==0)
        {
            
            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"language"] isEqualToString:@"SE"])
            {
                UIMsg(@"Ange e-postadress");
            }
            else
            {
                UIMsg(@"Please Enter Your Email");
            }
        }
        else
        {
            if ([txt_Email validEmailAddress])
            {
                
                NSManagedObjectContext *context =[appDelegate managedObjectContext];
                NSEntityDescription *entityDesc =[NSEntityDescription entityForName:@"EmailList" inManagedObjectContext:context];
                NSFetchRequest *request = [[NSFetchRequest alloc] init];
                [request setEntity:entityDesc];
                NSPredicate *pred =[NSPredicate predicateWithFormat:@"(emailId = %@)",txt_Email.text];
                [request setPredicate:pred];
                
                
                NSArray *ary_Email = [context executeFetchRequest:request error:nil];
                
                if ([ary_Email count]==0)
                {
                    NSError *error;
                    NSManagedObject *newContact;
                    newContact = [NSEntityDescription insertNewObjectForEntityForName:@"EmailList" inManagedObjectContext:context];
                    [newContact setValue:txt_Email.text forKey:@"emailId"];
                    [context save:&error];
                    
                    
                    NSFetchRequest *request = [[NSFetchRequest alloc] init];
                    [request setEntity:entityDesc];
                    
                    NSArray *objects2 = [context executeFetchRequest:request error:nil];
                    NSManagedObject *matches = nil;
                    
                    [ary_EmailList removeAllObjects];
                    
                    for(int i=0;i<[objects2 count];i++)
                    {
                        matches=(NSManagedObject*)[objects2 objectAtIndex:i];
                        NSLog(@"arr:%@",[matches valueForKey:@"emailId"]);
                        [ary_EmailList addObject:[matches valueForKey:@"emailId"]];
                        
                    }
                }
                
                
                [[NSUserDefaults standardUserDefaults] setObject:@"No" forKey:@"None"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                
                Reachability *reachability = [Reachability reachabilityForInternetConnection];
                NetworkStatus internetStatus = [reachability currentReachabilityStatus];
                if (internetStatus != NotReachable) {
                    
                    receiptMethodTag=2;
                    
                    NSString *email = txt_Email.text;
                    [[NSUserDefaults standardUserDefaults] setObject:email forKey:@"EMAIL"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    appDelegate.customerReceipt = completedTransaction.customerReceipt;
                    
                    [[NSUserDefaults standardUserDefaults] setObject:@"Email" forKey:@"receipt_output_mode"];
                    [[NSUserDefaults standardUserDefaults] setObject:@"Original" forKey:@"ReciptType"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    [self VibrateandSound];
                    [self saveDataAfterpayment];
                    
                }
                else {
                    [[[UIAlertView alloc] initWithTitle:@"ISUPOS" message:[Language get:@"Please check your internet connection." alter:@"!Please check your internet connection."] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                }
               
            }
        
        }
       
    }
    else if (sender == btn_EmailCancel)
    {
        [UIView beginAnimations:@"animate" context:nil];
        [UIView setAnimationDuration:0.35f];
        [UIView setAnimationBeginsFromCurrentState: NO];
        CGRect frame = view_EmailPopUpBg.frame;
        frame.origin.x = 567;
        [view_EmailPopUpBg setFrame:frame];
        [UIView commitAnimations];
    }
}


- (IBAction)actionEmailBtn:(UIButton *)sender {
    

    [[NSUserDefaults standardUserDefaults] setObject:@"Email" forKey:@"receipt_output_mode"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    if (internetStatus != NotReachable) {
        
        NSManagedObjectContext *context =[appDelegate managedObjectContext];
        NSEntityDescription *entityDesc2 =[NSEntityDescription entityForName:@"EmailList" inManagedObjectContext:context];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entityDesc2];
        
        NSArray *objects2 = [context executeFetchRequest:request error:nil];
        NSManagedObject *matches = nil;
        
        [ary_EmailList removeAllObjects];
        
        for(int i=0;i<[objects2 count];i++)
        {
            matches=(NSManagedObject*)[objects2 objectAtIndex:i];
            [ary_EmailList addObject:[matches valueForKey:@"emailId"]];
            
        }
        
        [UIView beginAnimations:@"animate" context:nil];
        [UIView setAnimationDuration:0.35f];
        [UIView setAnimationBeginsFromCurrentState: NO];
        CGRect frame = view_EmailPopUpBg.frame;
        frame.origin.x = 0;
        [view_EmailPopUpBg setFrame:frame];
        [UIView commitAnimations];
        
//        if ([[NSUserDefaults standardUserDefaults]valueForKey:@"EMAIL"]) {
//            
//            txt_Email.text = [[NSUserDefaults standardUserDefaults]valueForKey:@"EMAIL"];
//        }
//        else
//        {
            txt_Email.text = @"";
//        }
        
        tbl_EmailList.hidden = YES;
        
        
        CGRect frame_EmailTable = tbl_EmailList.frame;
        if ([ary_EmailList count] >3)
        {
            frame_EmailTable.size.height = 180;
        }
        else
        {
            frame_EmailTable.size.height = [ary_EmailList count]*60;
        }
        
        tbl_EmailList.frame = frame_EmailTable;
        [tbl_EmailList reloadData];
        
        
//        alertView_payment=[[UIAlertView alloc]initWithTitle:@"ISUPOS" message:[Language get:@"Please enter your email" alter:@"!Please enter your email"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel",nil];
//        alertView_payment.tag=103;
//        alertView_payment.alertViewStyle=UIAlertViewStylePlainTextInput;
//        [[alertView_payment textFieldAtIndex:0] setDelegate:self];
//#if (TARGET_IPHONE_SIMULATOR)
//        [[alertView_payment textFieldAtIndex:0] setText:@"meghas@impingeonline.com"];
//        
//        
//#endif
//        
//        [alertView_payment show];
        
       


        
    }
    else {
        [[[UIAlertView alloc] initWithTitle:@"ISUPOS" message:[Language get:@"Please check your internet connection." alter:@"!Please check your internet connection."] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
    
}

- (IBAction)actionNonebtn:(UIButton *)sender {
    
    [[NSUserDefaults standardUserDefaults] setObject:@"Yes" forKey:@"None"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self clearCart];
    
}

- (IBAction)actionBuyCardReader:(UIButton *)sender {
    
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://www.isupos.se/app/buy_cardreader.html"]];
   
}

- (IBAction)actionGetHelp:(UIButton *)sender {
    
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://www.isupos.se/app/help.html"]];
}

- (IBAction)abortButton_action:(UIButton *)sender {
    [process requestAbort];
    
}
- (void)closeTransaction{
    self.transactionView.hidden = YES;
}


#pragma mark - UITableView Datasource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [ary_EmailList count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell=nil;
    if (cell == nil) {
        cell = nil;
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor=[UIColor clearColor];
    
    UILabel *lbl_Email = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, tbl_EmailList.frame.size.width-20, 48)];
    lbl_Email.text = [ary_EmailList objectAtIndex:indexPath.row];
    lbl_Email.textColor = [UIColor blackColor];
    lbl_Email.backgroundColor = [UIColor whiteColor];
    lbl_Email.font = [UIFont fontWithName:@"Helvetica" size:18.0f];
    [cell.contentView addSubview:lbl_Email];
    
    UILabel *lbl_Underline = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(lbl_Email.frame)+1, tbl_EmailList.frame.size.width, 1)];
    lbl_Underline.backgroundColor = [UIColor lightGrayColor];
    [cell.contentView addSubview:lbl_Underline];
    
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    txt_Email.text = [ary_EmailList objectAtIndex:indexPath.row];
    tbl_EmailList.hidden = YES;
}

@end
