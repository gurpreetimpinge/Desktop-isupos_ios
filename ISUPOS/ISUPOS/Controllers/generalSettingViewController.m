//
//  generalSettingViewController.m
//  ISUPOS
//
//  Created by Rohit Mahajan on 4/24/15.
//  Copyright (c) 2015 Impinge Solutions. All rights reserved.
//

#import "generalSettingViewController.h"
#import "vatvariantsViewController.h"
#import "Language.h"
#import "ManageArticalViewController.h"
#import "AppDelegate.h"
#import "LogViewController.h"
#import "EmailListViewController.h"

@interface generalSettingViewController ()
{
    NSString *currencySign;
    
    AppDelegate *appDelegate;
    UIPopoverController *popover;
    
    
}
@property (weak, nonatomic) IBOutlet UITextField *txtFld_merchantIdentifier;
@property (weak, nonatomic) IBOutlet UITextField *txtFld_merchantSecret;

@end

@implementation generalSettingViewController
@synthesize callBack;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)settext
{
    
    
    //    emailid=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"Luser"]];
    //    password=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"Lpass"]];
    //    confirmPassword=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"Lpass"]];
    
    
    lblgeneralsetting.text=[Language get:@"General Settings" alter:@"!General Settings"];
    lblcashpayment.text=[Language get:@"Cash Payments" alter:@"!Cash Payments"];
    lblautofill.text=[Language get:@"Auto fill amount" alter:@"!Auto fill amount"];
    lblautofill1.text=[Language get:@"Auto fill exact amount tendered" alter:@"!Auto fill exact amount tendered"];
    lblskip.text=[Language get:@"Skip" alter:@"!Skip"];
    lblskip1.text=[Language get:@"Skip amount tendered view" alter:@"!Skip amount tendered view"];
    lblthank.text=[Language get:@"Thank you view" alter:@"!Thank you view"];
    lblautodismiss.text=[Language get:@"Auto dismiss" alter:@"!Auto dismiss"];
    lblautodismiss1.text=[Language get:@"Always auto dismiss thank you view" alter:@"!Always auto dismiss thank you view"];
    lblsoundeffect.text=[Language get:@"Sound effects" alter:@"!Sound effects"];
    lblplaysound.text=[Language get:@"Play sound effects in app" alter:@"!Play sound effects in app"];
    lblvat.text=[Language get:@"Vat" alter:@"!Vat"];
    lblvatvariantion.text=[Language get:@"Vat Variations" alter:@"!Vat Variations"];
    lbllanguage.text=[Language get:@"Language" alter:@"!Language"];
    lblemail.text=[Language get:@"Account Settings" alter:@"!Account Settings"];
    lblCurrency.text=[Language get:@"Currency" alter:@"!Currency"];
    lblVat.text=[Language get:@"Vat" alter:@"!Vat"];
    lblTimeDo.text=[Language get:@"TimeDo" alter:@"!TimeDo"];
    
    lblSoundInApp.text=[Language get:@"Sounds in app" alter:@"!Sounds in app"];
    email_feild.placeholder = [Language get:@"Email" alter:@"!Email"];
    password_feild.placeholder = [Language get:@"New Password" alter:@"!New Password"];
    confirmPassword_feild.placeholder = [Language get:@"Confirm Password" alter:@"!Confirm Password"];
    lblTimeDo.text = [Language get:@"TimeDo" alter:@"!TimeDo"];
    self.timeDoTextField.placeholder = [Language get:@"Enter Company ID" alter:@"!Enter Company ID"];
    lblCentralKey.text = [Language get:@"Central Key" alter:@"!Central Key"];
    centralUsername.placeholder = [Language get:@"Username" alter:@"!Username"];
    centralPassword.placeholder = [Language get:@"Password" alter:@"!Password"];
    lblInfrasecKey.text = [Language get:@"Greengate Credentials" alter:@"!Greengate Credentials"];
    lblInfrasecStatus.text = [Language get:@"Enable" alter:@"!Enable"];
    infrasecUsername.placeholder = [Language get:@"Username" alter:@"!Username"];
    infrasecPassword.placeholder = [Language get:@"Password" alter:@"!Password"];
    time_Field.placeholder = [Language get:@"Select Format" alter:@"!Select Format"];
    Time_Formatlbl.text=[Language get:@"Time Format" alter:@"!Time Format"];
    [self.Hours_12_Button setTitle:[Language get:@"12 Hours" alter:@"!12 Hours"] forState:UIControlStateNormal];
    [self.Hours_24_Button setTitle:[Language get:@"24 Hours" alter:@"!24 Hours"] forState:UIControlStateNormal];
    [self.label_LogDetails setTitle:[Language get:@"Audit Log" alter:@"!Audit Log"] forState:UIControlStateNormal];

    self.txtFld_merchantSecret.placeholder = [Language get:@"Merchant Secret Key" alter:@"!Merchant Secret Key"];
    
    lblPayworksCredentials.text = [Language get:@"Payworks Credentials" alter:@"!Payworks Credentials"];
    
    lbl_Email.text = [Language get:@"Emails" alter:@"!Emails"];
    btn_Email.titleLabel.text = [Language get:@"Emails" alter:@"!Emails"];

  
}
- (void)viewDidLoad
{
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [super viewDidLoad];
    
    // Splunk Mint Breadcrumb added
    [[Mint sharedInstance] leaveBreadcrumb:@"GeneralSettingViewController_ViewController"];
    
    //    emailid=@"";
    //    password=@"";
    //    confirmPassword=@"";
    
    [self settext];
    

    
  //    language_feild.text = @"SE";
//    time_Field.text = @"24 Hours";
    currency_view.hidden=YES;
    lang_view.hidden=YES;
    Time_View.hidden=YES;
//    [autofill setOn:true animated:YES];

    language_feild.text= language;
    //    email_feild.text= emailid;
    //    password_feild.text = password;
    //    confirmPassword_feild.text = confirmPassword;
    
  //  scrv.contentSize=CGSizeMake(400,1845);
    scrv.contentSize = CGSizeMake(400, CGRectGetMaxY(view_PayTimeJournal.frame)+10);
  //    scrv.contentSize=CGSizeMake(400,2100);//2170
    self.navigationController.navigationBarHidden=YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    NSManagedObjectContext *context =[appDelegate managedObjectContext];
    NSError *error;
    NSEntityDescription *entityDes =[NSEntityDescription entityForName:@"VatandCurrency" inManagedObjectContext:context];
    NSFetchRequest *reques = [[NSFetchRequest alloc] init];
    [reques setEntity:entityDes];
    NSManagedObject *matches1 = nil;
    NSArray *object = [context executeFetchRequest:reques error:&error];
    if ([object count] == 0) {
        NSManagedObject *newContact;
        newContact = [NSEntityDescription insertNewObjectForEntityForName:@"VatandCurrency" inManagedObjectContext:context];
        [newContact setValue:@"$" forKey:@"currency"];
        currencySign=@"$";
        [context save:&error];
        
    } else {
        
        matches1=(NSManagedObject*)[object objectAtIndex:0];
        currencySign=[matches1 valueForKey:@"currency"];
        if([[matches1 valueForKey:@"language"] isEqualToString:@"SE"])
        {
            [Language setLanguage:@"sv"];
            language_feild.text=@"SE";
        }
        else
        {
            [Language setLanguage:@"en"];
            language_feild.text=@"EN";
        }
    }
    
    
    currency_feild.text=currencySign;
    
    
    NSEntityDescription *entityDesc =[NSEntityDescription entityForName:@"Setting" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    NSPredicate *pred =[NSPredicate predicateWithFormat:@"(id = %@)",@"1"];
    [request setPredicate:pred];
    NSArray *objects = [context executeFetchRequest:request error:&error];
    if(objects.count==0)
    {
        [thankyou setOn:false];
        [autofill setOn:false];
        [skip setOn:false];
        [soundinapp setOn:false];
    }
    else
    {
    
        
        NSManagedObject *person = (NSManagedObject *)[objects objectAtIndex:0];
    
        if ([[person valueForKey:@"appTimeFormat"] isEqualToString:@"24"]) {
        
            time_Field.text = [Language get:@"24 Hours" alter:@"!24 Hours"];
            [[NSUserDefaults standardUserDefaults] setObject:@"24" forKey:@"time_format"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        else
        {
            time_Field.text = [Language get:@"12 Hours" alter:@"!12 Hours"];
            [[NSUserDefaults standardUserDefaults] setObject:@"12" forKey:@"time_format"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        
        
        
        if([[person valueForKey:@"autoDismissThankyou"]boolValue])
        {
            [thankyou setOn:true];
            
        }
        else
        {
            [thankyou setOn:false];
        }
        if([[person valueForKey:@"skipTenderedView"]boolValue])
        {
            [skip setOn:true];
            
        }
        else
        {
            [skip setOn:false];
        }
        if([[person valueForKey:@"autoFillAmount"]boolValue])
        {
            [autofill setOn:true];
            
        }
        else
        {
            [autofill setOn:false];
        }
        if([[person valueForKey:@"soundInApp"]boolValue])
        {
            [soundinapp setOn:true];
            
        }
        else
        {
            [soundinapp setOn:false];
        }
        
    }
    
    
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    
    //Display text of TimeDo
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.timeDoTextField.text = [defaults objectForKey:@"CompanyId"];
    
    //Display central credentials
    centralUsername.text = [defaults objectForKey:@"USERNAME"];
    centralPassword.text = [defaults objectForKey:@"PASSWORD"];
    
    //Display Infrasec credentials
    if ([defaults boolForKey:@"INFRASEC_STATUS"])
    {
        [switch_InfrasecStatus setOn:YES];
        view_InfrasecDetail.hidden = NO;
        
        view_Infrasec.frame = CGRectMake(1, 1233, 567, 392);
        view_InfrasecDetail.frame = CGRectMake(9, 102, 550, 290);
        view_PayTimeJournal.frame = CGRectMake(0, 1635, 567, 740);
    }
    else
    {
        [switch_InfrasecStatus setOn:NO];
        view_InfrasecDetail.hidden = YES;
        
        view_Infrasec.frame = CGRectMake(1, 1233, 567, 92);
        view_InfrasecDetail.frame = CGRectMake(9, 102, 550, 0);
        view_PayTimeJournal.frame = CGRectMake(0, 1335, 567, 740);
    }
    
    
    if ([defaults boolForKey:@"SwishPaymentOn"])
    {
        [switch_Swish setOn:YES];
    }
    else
    {
        [switch_Swish setOn:NO];
    }
    
    if ([defaults boolForKey:@"OtherPaymentOn"])
    {
        [switch_Other setOn:YES];
    }
    else
    {
        [switch_Other setOn:NO];
    }
    
    scrv.contentSize = CGSizeMake(400, CGRectGetMaxY(view_PayTimeJournal.frame)+10);
    
    infrasecUsername.text = [defaults objectForKey:@"INFRASEC_USERNAME"];
    infrasecPassword.text = [defaults objectForKey:@"INFRASEC_PASSWORD"];
    self.txtFeild_posId.text = [defaults objectForKey:@"POS_ID"];
    self.txtFeild_organizationNumber.text = [defaults objectForKey:@"ORGANIZATION_NUMBER"];
    self.txtFld_merchantIdentifier.text = [defaults objectForKey:KPAYWORKS_MERCHANT_IDENTIFIER];
     self.txtFld_merchantSecret.text = [defaults objectForKey:KPAYWORKS_MERCHANT_SECRET];
    
//    time_Field.text = [defaults objectForKey:@"time_format"];
    
    email_feild.text = [defaults objectForKey:@"Luser"];
    
//    if ([language_feild.text isEqualToString:@"SE"])
//    {
//        currency_feild.text = @"SEK";
//        vat_feild.text = @"25%";
//    }
//    else{
//        currency_feild.text = @"$";
//    }
    
    
    NSManagedObjectContext *context =[appDelegate managedObjectContext];
    NSError *error;
    NSEntityDescription *entityDescc =[NSEntityDescription entityForName:@"VatVariation" inManagedObjectContext:context];
    NSFetchRequest *requestt = [[NSFetchRequest alloc] init];
    [requestt setEntity:entityDescc];
    NSManagedObject *matches = nil;
    NSArray *objectss = [context executeFetchRequest:requestt error:&error];
    if ([objectss count] == 0) {
        
    } else {
        NSString *st=@"";
        for(int i=0;i<[objectss count];i++)
        {
            matches=(NSManagedObject*)[objectss objectAtIndex:i];
            if([st isEqualToString:@""])
                st=[NSString stringWithFormat:@"%@",[[matches valueForKey:@"vat"] substringToIndex:[[matches valueForKey:@"vat"] length] - 1]];
            else
                st=[NSString stringWithFormat:@"%@,%@",st,[[matches valueForKey:@"vat"] substringToIndex:[[matches valueForKey:@"vat"] length] - 1]];
        }
        vat_feild.text=[NSString stringWithFormat:@"%@",st];
    }
    
    [popover setPopoverContentSize:CGSizeMake(567, 550)];
    self.view.superview.layer.cornerRadius = 0;
    CGSize size = CGSizeMake(567, 568); // size of view in popover
    self.preferredContentSize = size;
    

    
   // infrasecUsername.text = @"testpos";//@"AffarsIT VERIFY";
   // infrasecPassword.text = @"testpos";//@"AT10000050312001";

//    NSManagedObject *newContact;
//    newContact = [NSEntityDescription insertNewObjectForEntityForName:@"Log" inManagedObjectContext:context];
//    
//    [newContact setValue:[NSDate date] forKey:@"date"];
//    [newContact setValue:[Language get:@"General Settings" alter:@"!General Settings"] forKey:@"discription"];
//    [newContact setValue:@"" forKey:@"sno"];
//    
//    [context save:&error];

    //#if (TARGET_OS_SIMULATOR)
    
 //  [self prefillDataForTesting];

    //#endif

    
    
}


- (void)prefillDataForTesting {
    
    centralUsername.text = @"rdev_rdev_appuser"; //@"dem_danielkassa";
    centralPassword.text = @"Wg!39kP+37"; //@"ab3219244";
    infrasecUsername.text = @"testpos";
    infrasecPassword.text = @"testpos";
    self.txtFeild_posId.text = @"15555551111";
    self.txtFeild_organizationNumber.text = @"5555551111";
    self.txtFld_merchantIdentifier.text = @"33fe74a0-837f-4eb2-9802-f9ddfb065c21";
    self.txtFld_merchantSecret.text = @"pmFBdg1jt3yNBeoUAfLbExvjzhKeDTdw";
    [[NSUserDefaults standardUserDefaults] setObject:@"33fe74a0-837f-4eb2-9802-f9ddfb065c21" forKey:KPAYWORKS_MERCHANT_IDENTIFIER];//  14aeff7e-786c-4ae8-891a-54140b81a868
    [[NSUserDefaults standardUserDefaults] setObject:@"pmFBdg1jt3yNBeoUAfLbExvjzhKeDTdw" forKey:KPAYWORKS_MERCHANT_SECRET];//727BjJhyPZiR0rBogbJZrd79RwVjMgPX
    [[NSUserDefaults standardUserDefaults] synchronize];
    
   }

- (void)keyboardDidShow: (NSNotification *) notif{
    
    scrv.contentSize = CGSizeMake(400, CGRectGetMaxY(view_PayTimeJournal.frame)+20);
    
}

- (void)keyboardDidHide: (NSNotification *) notif{
    scrv.contentSize = CGSizeMake(400, CGRectGetMaxY(view_PayTimeJournal.frame)+10);
  //  scrv.contentSize=CGSizeMake(400,2100);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

-(IBAction)switchSwishOther:(UISwitch *)sender
{
//    if (sender.isOn)
//    {
//        [sender setOn:YES];
//    }
//    else
//    {
//        [sender setOn:NO];
//    }
    
}

- (IBAction)InfrasecStatus:(UISwitch *)sender
{
    if (sender.isOn)
    {
        [sender setOn:YES];
        view_InfrasecDetail.hidden = NO;
        
        view_Infrasec.frame = CGRectMake(1, 1233, 567, 392);
        view_InfrasecDetail.frame = CGRectMake(9, 102, 550, 290);
        view_PayTimeJournal.frame = CGRectMake(0, 1635, 567, 740);
    }
    else
    {
        [sender setOn:NO];
        view_InfrasecDetail.hidden = YES;
        
        view_Infrasec.frame = CGRectMake(1, 1233, 567, 92);
        view_InfrasecDetail.frame = CGRectMake(9, 102, 550, 0);
        view_PayTimeJournal.frame = CGRectMake(0, 1335, 567, 740);
    }
    
    scrv.contentSize = CGSizeMake(400, CGRectGetMaxY(view_PayTimeJournal.frame)+10);
}

- (IBAction)toOkBtn:(UIButton*)sender
{
    
    //UserDefaults for TimeDo
    if (self.timeDoTextField.text.length>0)
    {
        [[NSUserDefaults standardUserDefaults] setObject:self.timeDoTextField.text forKey:@"CompanyId"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    else{
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CompanyId"];
    }
    
    
    //UserDefaults for Central Credentials
    if (centralUsername.text.length>0)
    {
        [[NSUserDefaults standardUserDefaults] setObject:centralUsername.text forKey:@"USERNAME"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"USERNAME"];
    }
    
    if (centralPassword.text.length>0)
    {
        [[NSUserDefaults standardUserDefaults] setObject:centralPassword.text forKey:@"PASSWORD"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PASSWORD"];
    }
    
    if (self.txtFld_merchantIdentifier.text.length>0) {
        [[NSUserDefaults standardUserDefaults] setObject:self.txtFld_merchantIdentifier.text forKey:KPAYWORKS_MERCHANT_IDENTIFIER];
         [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else {
         [[NSUserDefaults standardUserDefaults] removeObjectForKey:KPAYWORKS_MERCHANT_IDENTIFIER];
       }
    
    
    if (self.txtFld_merchantSecret.text.length>0 ) {
         [[NSUserDefaults standardUserDefaults] setObject:self.txtFld_merchantSecret.text forKey:KPAYWORKS_MERCHANT_SECRET];
         [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else{
         [[NSUserDefaults standardUserDefaults] removeObjectForKey:KPAYWORKS_MERCHANT_SECRET];
    }
    
//    [[NSUserDefaults standardUserDefaults] setObject:infrasecUsername.text forKey:@"INFRASEC_USERNAME"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //UserDefaults for infrasec credentials
    
    [[NSUserDefaults standardUserDefaults] setBool:switch_InfrasecStatus.isOn forKey:@"INFRASEC_STATUS"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (infrasecUsername.text.length>0)
    {
        [[NSUserDefaults standardUserDefaults] setObject:infrasecUsername.text forKey:@"INFRASEC_USERNAME"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"INFRASEC_USERNAME"];
    }
    
    if (infrasecPassword.text.length>0)
    {
        [[NSUserDefaults standardUserDefaults] setObject:infrasecPassword.text forKey:@"INFRASEC_PASSWORD"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"INFRASEC_PASSWORD"];
    }
   
    if (self.txtFeild_posId.text.length>0)
    {
        [[NSUserDefaults standardUserDefaults] setObject:self.txtFeild_posId.text forKey:@"POS_ID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"POS_ID"];
    }
    
    if (self.txtFeild_organizationNumber.text.length>0)
    {
        [[NSUserDefaults standardUserDefaults] setObject:self.txtFeild_organizationNumber.text forKey:@"ORGANIZATION_NUMBER"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"ORGANIZATION_NUMBER"];
    }
    
    [[NSUserDefaults standardUserDefaults] setBool:switch_Swish.isOn forKey:@"SwishPaymentOn"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSUserDefaults standardUserDefaults] setBool:switch_Other.isOn forKey:@"OtherPaymentOn"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSManagedObjectContext *context =[appDelegate managedObjectContext];
    NSError *error;
    NSEntityDescription *entityDescc =[NSEntityDescription entityForName:@"VatandCurrency" inManagedObjectContext:context];
    NSFetchRequest *requestt = [[NSFetchRequest alloc] init];
    [requestt setEntity:entityDescc];
    
    NSArray *objectss = [context executeFetchRequest:requestt error:&error];
    if ([objectss count] == 0) {
        NSManagedObject *newContact;
        newContact = [NSEntityDescription insertNewObjectForEntityForName:@"VatandCurrency" inManagedObjectContext:context];
        [newContact setValue:@"€" forKey:@"currency"];
        currencySign=@"€";
        language_feild.text=@"SE";
        [context save:&error];
        
    } else {
        
        NSManagedObject *obj=(NSManagedObject *)[objectss objectAtIndex:0];
        
        if (![email_feild.text isEqualToString:@""]) {
            [obj setValue: [NSString stringWithFormat:@"%@",email_feild.text] forKey:@"email"];
            [[NSUserDefaults standardUserDefaults] setObject:email_feild.text forKey:@"Luser"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        //        if([password_feild.text isEqualToString:confirmPassword_feild.text])
        //        {
        //   [obj setValue: [NSString stringWithFormat:@"%@",password_feild.text] forKey:@"password"];
        //        [obj setValue: [NSString stringWithFormat:@"%@",confirmPassword_feild.text] forKey:@"confirm_password"];
        //       }
        
        [obj setValue: [NSString stringWithFormat:@"%@",language_feild.text] forKey:@"language"];
        if([language_feild.text isEqualToString:@"SE"])
        {
            [Language setLanguage:@"sv"];
            [[NSUserDefaults standardUserDefaults] setObject:@"SE" forKey:@"language"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        else
        {
            [Language setLanguage:@"en"];
            [[NSUserDefaults standardUserDefaults] setObject:@"EN" forKey:@"language"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        [obj setValue:currency_feild.text forKey:@"currency"];
        
        [context save:&error];
        
        //        emailid=@"";
        //        password=@"";
        //        confirmPassword=@"";
        
        currencySign=currency_feild.text;
        language=language_feild.text;
        //        emailid= email_feild.text;
        //        password = password_feild.text;
        //        confirmPassword = confirmPassword_feild.text;
        
    }
    
    if (![email_feild.text isEqualToString:@""])
    {
        
        NSManagedObjectContext *context =[appDelegate managedObjectContext];
        NSError *error;
        NSEntityDescription *entityDescc =[NSEntityDescription entityForName:@"User" inManagedObjectContext:context];
        NSFetchRequest *requestt = [[NSFetchRequest alloc] init];
        [requestt setEntity:entityDescc];
        
        
        //        NSPredicate *predicate;
        //        predicate = [NSPredicate predicateWithFormat:@"(user_id = %@)",pressedindex];
        //        [requestt setPredicate:predicate];
        
        
        NSArray *objectss = [context executeFetchRequest:requestt error:&error];
        if ([objectss count] == 0) {
            
        }
        else
        {
            NSManagedObject *obj=(NSManagedObject *)[objectss objectAtIndex:0];
            [obj setValue: [NSString stringWithFormat:@"%@",email_feild.text] forKey:@"email"];
            [[NSUserDefaults standardUserDefaults] setObject:email_feild.text forKey:@"Luser"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [context save:&error];
        }
    }
    
    
    if (![password_feild.text isEqualToString:@""])
    {
        
        if(confirmPassword_feild.text)
        {
            if(![password_feild.text isEqualToString:confirmPassword_feild.text])
            {
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:[Language get:@"Sorry" alter:@"Sorry"] message:[Language get:@"Password did not match" alter:@"!Password did not match"] delegate:nil
                                                         cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alertView show];
            }
            else
            {
                
                NSManagedObjectContext *context =[appDelegate managedObjectContext];
                NSError *error;
                NSEntityDescription *entityDescc =[NSEntityDescription entityForName:@"User" inManagedObjectContext:context];
                NSFetchRequest *requestt = [[NSFetchRequest alloc] init];
                [requestt setEntity:entityDescc];
                
                
                //        NSPredicate *predicate;
                //        predicate = [NSPredicate predicateWithFormat:@"(user_id = %@)",pressedindex];
                //        [requestt setPredicate:predicate];
                
                
                NSArray *objectss = [context executeFetchRequest:requestt error:&error];
                if ([objectss count] == 0) {
                    
                }
                else
                {
                    NSManagedObject *obj=(NSManagedObject *)[objectss objectAtIndex:0];
                    [obj setValue:password_feild.text forKey:@"password"];
                    [[NSUserDefaults standardUserDefaults] setObject:password_feild.text forKey:@"Lpass"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    [context save:&error];
                }
            }
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Language" object:nil userInfo:nil];
    
    if(callBack!= nil && [callBack respondsToSelector:@selector(toDismissThePopover)] )
    {
        [callBack performSelector:@selector(toDismissThePopover)];
    }
    
}

#pragma mark - UITextField
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == password_feild)
    {
        [confirmPassword_feild becomeFirstResponder];
    }
    else if(textField == confirmPassword_feild)
    {
        if(![password_feild.text isEqualToString:confirmPassword_feild.text])
        {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:[Language get:@"Sorry" alter:@"Sorry"] message:[Language get:@"Password did not match" alter:@"!Password did not match"] delegate:nil
                                                     cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }
    else if (textField == centralUsername)
    {
        [centralPassword becomeFirstResponder];
    }
    else if (textField == centralUsername)
    {
        [centralPassword resignFirstResponder];
    }
    else if (textField == infrasecUsername)
    {
        [infrasecPassword becomeFirstResponder];
    }
    else if (textField == infrasecPassword)
    {
        [self.txtFeild_posId becomeFirstResponder];
    }
    else if (textField == self.txtFeild_posId)
    {
        [self.txtFeild_organizationNumber becomeFirstResponder];
    }
    else if (textField == self.txtFeild_organizationNumber)
    {
        [self.txtFeild_organizationNumber resignFirstResponder];
    }
    else if (textField == time_Field)
    {
        [time_Field resignFirstResponder];
    }
    return YES;
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if(textField.tag == 11)
    {
        if([textField.text isEqualToString:@""])
        {
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"CompanyId"];
            
        }
    }
    return YES;
}

- (IBAction)autoDismissThankyouView:(UISwitch*)sender
{
    NSManagedObjectContext *context =[appDelegate managedObjectContext];
    NSEntityDescription *entityDesc =[NSEntityDescription entityForName:@"Setting" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    NSPredicate *pred =[NSPredicate predicateWithFormat:@"(id = %@)",@"1"];
    [request setPredicate:pred];
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    if(objects.count==0)
    {
        NSManagedObject *newContact;
        newContact = [NSEntityDescription insertNewObjectForEntityForName:@"Setting" inManagedObjectContext:context];
        if(sender.on)
        {
           
            [newContact setValue:[NSNumber numberWithBool:YES] forKey:@"autoDismissThankyou"];
        }
        else
        {
      
            [newContact setValue:[NSNumber numberWithBool:NO] forKey:@"autoDismissThankyou"];
        }
        
        [newContact setValue:[NSNumber numberWithInt:1] forKey:@"id"];
        
        [context save:&error];
    }
    else
    {
        NSManagedObject *person = (NSManagedObject *)[objects objectAtIndex:0];
        
        if(sender.on)
        {
        
            [person setValue:[NSNumber numberWithBool:YES] forKey:@"autoDismissThankyou"];
        }
        else
        {
          
            [person setValue:[NSNumber numberWithBool:NO] forKey:@"autoDismissThankyou"];
        }
        
        [context save:&error];
        
        
    }
    //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ISUPOS" message:@"Setting Changed." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //    [alert show];
    
    
}
- (IBAction)skipAmountTenderdView:(UISwitch*)sender
{
    NSManagedObjectContext *context =[appDelegate managedObjectContext];
    NSEntityDescription *entityDesc =[NSEntityDescription entityForName:@"Setting" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    NSPredicate *pred =[NSPredicate predicateWithFormat:@"(id = %@)",@"1"];
    [request setPredicate:pred];
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    if(objects.count==0)
    {
        NSManagedObject *newContact;
        newContact = [NSEntityDescription insertNewObjectForEntityForName:@"Setting" inManagedObjectContext:context];
        if(sender.on)
        {
        
            [newContact setValue:[NSNumber numberWithBool:YES] forKey:@"skipTenderedView"];
        }
        else
        {
           
            [newContact setValue:[NSNumber numberWithBool:NO] forKey:@"skipTenderedView"];
        }
        
        [newContact setValue:[NSNumber numberWithInt:1] forKey:@"id"];
        
        [context save:&error];
    }
    else
    {
        NSManagedObject *person = (NSManagedObject *)[objects objectAtIndex:0];
        
        if(sender.on)
        {
          
            [person setValue:[NSNumber numberWithBool:YES] forKey:@"skipTenderedView"];
        }
        else
        {
           
            [person setValue:[NSNumber numberWithBool:NO] forKey:@"skipTenderedView"];
        }
        
        
        
        [context save:&error];
        
        
    }
    //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ISUPOS" message:@"Setting Changed." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //    [alert show];
    
}
- (IBAction)autoFillAmount:(UISwitch*)sender
{
    NSManagedObjectContext *context =[appDelegate managedObjectContext];
    NSEntityDescription *entityDesc =[NSEntityDescription entityForName:@"Setting" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    NSPredicate *pred =[NSPredicate predicateWithFormat:@"(id = %@)",@"1"];
    [request setPredicate:pred];
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    if(objects.count==0)
    {
        NSManagedObject *newContact;
        newContact = [NSEntityDescription insertNewObjectForEntityForName:@"Setting" inManagedObjectContext:context];
        if(sender.on)
        {
     
            [newContact setValue:[NSNumber numberWithBool:YES] forKey:@"autoFillAmount"];
        }
        else
        {
        
            [newContact setValue:[NSNumber numberWithBool:NO] forKey:@"autoFillAmount"];
        }
        
        [newContact setValue:[NSNumber numberWithInt:1] forKey:@"id"];
        
        [context save:&error];
    }
    else
    {
        NSManagedObject *person = (NSManagedObject *)[objects objectAtIndex:0];
        
        if(sender.on)
        {
     
            [person setValue:[NSNumber numberWithBool:YES] forKey:@"autoFillAmount"];
        }
        else
        {
     
            [person setValue:[NSNumber numberWithBool:NO] forKey:@"autoFillAmount"];
        }
        
        
        
        [context save:&error];
        
        
    }
    //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ISUPOS" message:@"Setting Changed." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //    [alert show];
    
}
- (IBAction)soundInApp:(UISwitch*)sender
{
    NSManagedObjectContext *context =[appDelegate managedObjectContext];
    NSEntityDescription *entityDesc =[NSEntityDescription entityForName:@"Setting" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    NSPredicate *pred =[NSPredicate predicateWithFormat:@"(id = %@)",@"1"];
    [request setPredicate:pred];
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    if(objects.count==0)
    {
        NSManagedObject *newContact;
        newContact = [NSEntityDescription insertNewObjectForEntityForName:@"Setting" inManagedObjectContext:context];
        if(sender.on)
        {
        
            [newContact setValue:[NSNumber numberWithBool:YES] forKey:@"soundInApp"];
        }
        else
        {
          
            [newContact setValue:[NSNumber numberWithBool:NO] forKey:@"soundInApp"];
        }
        
        [newContact setValue:[NSNumber numberWithInt:1] forKey:@"id"];
        
        [context save:&error];
    }
    else
    {
        NSManagedObject *person = (NSManagedObject *)[objects objectAtIndex:0];
        
        if(sender.on)
        {
        
            [person setValue:[NSNumber numberWithBool:YES] forKey:@"soundInApp"];
        }
        else
        {
          
            [person setValue:[NSNumber numberWithBool:NO] forKey:@"soundInApp"];
        }
        
        [context save:&error];
        
        
    }
    //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ISUPOS" message:@"Setting Changed." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //    [alert show];
    
}
-(void)toDismissThePopover
{
    //[popover dismissPopoverAnimated:YES];
}

- (IBAction)TimeFomatSet:(UIButton *)sender {
    
    
    
    
    
//    time_Field.text=[sender titleForState:UIControlStateNormal];
//    [[NSUserDefaults standardUserDefaults] setObject:time_Field.text forKey:@"time_format"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//    Time_View.hidden = YES;
    
    
    //    if([time_Field.text isEqualToString:@"12 Hours"])
    //    {
    //
    //        NSDate *currDate = [NSDate date];
    //        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    //        [dateFormatter setDateFormat:@"dd-MMMM-yyyy hh:mm:ss a"];
    //        NSString *dateString = [dateFormatter stringFromDate:currDate];
    //        time_Field.text = @"12 Hours";
    //
    //        [[NSUserDefaults standardUserDefaults] setObject:dateString forKey:@"time_format"];
    //        [[NSUserDefaults standardUserDefaults] synchronize];
    //        Time_View.hidden = YES;
    //    }
    //    else
    //    {
    //
    //        NSDate *currDate = [NSDate date];
    //        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    //        [dateFormatter setDateFormat:@"dd-MMMM-yyyy hh:mm:ss"];
    //        NSString *dateString = [dateFormatter stringFromDate:currDate];
    //        time_Field.text = @"24 Hours";
    //
    //        [[NSUserDefaults standardUserDefaults] setObject:dateString forKey:@"time_format"];
    //        [[NSUserDefaults standardUserDefaults] synchronize];
    //        Time_View.hidden = YES;
    
    
    
    // }
    
    
}

- (IBAction)toCurrencyBtn:(UIButton*)sender
{
    
    currency_feild.text=[sender titleForState:UIControlStateNormal];
    currency_view.hidden=YES;
    lang_view.hidden=YES;
}
- (IBAction)tolanguageBtn:(UIButton*)sender
{
    language_feild.text=[sender titleForState:UIControlStateNormal];
//    if([language_feild.text isEqualToString:@"SE"])
//    {
//        //        lblCurrency.text = @"SEK";
//        currency_feild.text= @"SEK";
//    }
//    else{
//        //        lblCurrency.text = @"$";
//        currency_feild.text= @"$";
//    }
    
    
    
    //    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    //    NSManagedObjectContext *context =[appDelegate managedObjectContext];
    //
    //    NSError *error = nil;
    //
    //    NSEntityDescription *entityDesccd =[NSEntityDescription entityForName:@"VatVariation" inManagedObjectContext:context];
    //    NSFetchRequest *requesttt = [[NSFetchRequest alloc] init];
    //    [requesttt setEntity:entityDesccd];
    //
    //    NSArray *objectss3 = [context executeFetchRequest:requesttt error:&error];
    //
    //
    //    for (NSManagedObject *car in objectss3) {
    //        [context deleteObject:car];
    //    }
    //
    ////    if ([objectss3 count] == 0) {
    //
    //        NSManagedObject *newContact;
    //
    //    if ([language_feild.text isEqualToString:@"SE"])
    //    {
    //            for(int i=0;i<1;i++)
    //            {
    //                newContact = [NSEntityDescription insertNewObjectForEntityForName:@"VatVariation" FscrinManagedObjectContext:context];
    //
    //                if(i==0)
    //                    [newContact setValue:@"25%" forKey:@"vat"];
    //
    //                [context save:&error];
    //            }
    ////        }
    //    }
    //    else
    //    {
    //        for(int i=0;i<3;i++)
    //        {
    //            newContact = [NSEntityDescription insertNewObjectForEntityForName:@"VatVariation" inManagedObjectContext:context];
    //                        if(i==0)
    //                    [newContact setValue:@"6%" forKey:@"vat"];
    //                        if(i==1)
    //                    [newContact setValue:@"12%" forKey:@"vat"];
    //                        if(i==2)
    //                    [newContact setValue:@"25%" forKey:@"vat"];
    //
    //            [context save:&error];
    //        }
    //    }
    //
    //    [self viewWillAppear:YES];
    
    currency_view.hidden=YES;
    lang_view.hidden=YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(textField.tag==5)
    {
        if(currency_view.hidden)
        {
            currency_view.hidden=NO;
            lang_view.hidden=YES;
            Time_View.hidden=YES;
        }
        else
            currency_view.hidden=YES;
        return NO;
    }
    else if (textField.tag==6)
    {
        if(lang_view.hidden)
        {
            lang_view.hidden=NO;
            currency_view.hidden=YES;
            Time_View.hidden=YES;
        }
        else
            lang_view.hidden=YES;
        
        return NO;
    }
    else if (textField.tag==99)
    {
        UIStoryboard* storyboard   = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        vatvariantsViewController *manage_artical = [storyboard instantiateViewControllerWithIdentifier:@"vatvariantsViewController"];
        [self.navigationController pushViewController:manage_artical animated:NO];
        return NO;
        
    }
    
    else if (textField.tag==11)
    {
        if(Time_View.hidden)
        {
            Time_View.hidden=NO;
            currency_view.hidden=YES;
            lang_view.hidden=YES;
        }
        else
            Time_View.hidden=YES;
        return NO;
    }
    //    else if(textField.tag==11)
    //    {
    //        [scrv setContentOffset:CGPointMake(400,1225)];
    //    }
    
    currency_view.hidden=YES;
    lang_view.hidden=YES;
    Time_View.hidden = YES;
    return YES;
}
- (IBAction)time_Format_button:(UIButton *)sender {
    
    
    NSManagedObjectContext *context =[appDelegate managedObjectContext];
    NSError *error;
    NSEntityDescription *entityDescc =[NSEntityDescription entityForName:@"Setting" inManagedObjectContext:context];
    NSFetchRequest *requestt = [[NSFetchRequest alloc] init];
    NSPredicate *predicate;
    predicate = [NSPredicate predicateWithFormat:@"(id = %@)", @"1"];
    [requestt setPredicate:predicate];
    [requestt setEntity:entityDescc];
    
    NSArray *objectss = [context executeFetchRequest:requestt error:&error];
    if ([objectss count] == 0) {
        
    }
    else
    {
//        for (int i=0; i<[objectss count]; i++) {
        
            NSManagedObject *obj=(NSManagedObject *)[objectss objectAtIndex:0];
            
        if (sender.tag==12) {
            [obj setValue:@"12" forKey:@"appTimeFormat"];
            [[NSUserDefaults standardUserDefaults] setObject:@"12" forKey:@"time_format"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        else
        {
            [obj setValue:@"24" forKey:@"appTimeFormat"];
            [[NSUserDefaults standardUserDefaults] setObject:@"24" forKey:@"time_format"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
            [context save:&error];
//        }
        
      }
    
    
    
    
//    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
//    NSManagedObjectContext *context =[appDelegate managedObjectContext];
//    NSEntityDescription *entityDesc =[NSEntityDescription entityForName:@"Setting" inManagedObjectContext:context];
//    NSFetchRequest *request = [[NSFetchRequest alloc] init];
//    [request setEntity:entityDesc];
//    NSPredicate *pred =[NSPredicate predicateWithFormat:@"(id = %@)",@"1"];
//    [request setPredicate:pred];
//    NSError *error;
//    NSArray *objects = [context executeFetchRequest:request error:&error];
////    if(objects.count==0)
////    {
//        NSManagedObject *newContact;
//        newContact = [NSEntityDescription insertNewObjectForEntityForName:@"Setting" inManagedObjectContext:context];
//        
//        if (sender.tag==12) {
//            [newContact setValue:@"12" forKey:@"appTimeFormat"];
//            [[NSUserDefaults standardUserDefaults] setObject:@"12" forKey:@"time_format"];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//        }
//        else
//        {
//            [newContact setValue:@"24" forKey:@"appTimeFormat"];
//            [[NSUserDefaults standardUserDefaults] setObject:@"24" forKey:@"time_format"];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//        }
//        
//        
//        
//        [context save:&error];
////    }
    
    
    time_Field.text=[sender titleForState:UIControlStateNormal];
//    [[NSUserDefaults standardUserDefaults] setObject:time_Field.text forKey:@"time_format"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    Time_View.hidden = YES;

}



- (IBAction)btn_LogDetail:(id)sender {
    
    NSManagedObjectContext *context =[appDelegate managedObjectContext];
    NSEntityDescription *entityDesc =[NSEntityDescription entityForName:@"Log" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    
//    if ([objects count]>0) {
    
    LogViewController *logView = [self.storyboard instantiateViewControllerWithIdentifier:@"LogViewControllerid"];
//    [self.navigationController pushViewController:logView animated:YES];
    [self presentViewController:logView animated:YES completion:nil];
        
//    }
    
}

- (IBAction)buttonEmailList:(UIButton*)sender
{
    EmailListViewController *emailView = [self.storyboard instantiateViewControllerWithIdentifier:@"EmailListViewController"];
    //    [self.navigationController pushViewController:logView animated:YES];
    [self presentViewController:emailView animated:YES completion:nil];
}

@end
