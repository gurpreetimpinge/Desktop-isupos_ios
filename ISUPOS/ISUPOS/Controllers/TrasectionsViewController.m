//
//  TrasectionsViewController.m
//  ISUPOS
//
//  Created by Rohit Mahajan on 4/21/15.
//  Copyright (c) 2015 Impinge Solutions. All rights reserved.
//


#import "AppDelegate.h"

#import "TrasectionsViewController.h"
#import "reportViewController.h"
#import "ManageArticalViewController.h"
#import "quickBlocksButtonsView.h"
#import "helo&supportViewController.h"
#import "generalSettingViewController.h"
#import "receiptDataViewController.h"
#import "linkToViewController.h"

#import "IOS_SDKViewControllerPortable.h"
#import "StarIO/SMPort.h"
#import "PrinterFunctions.h"
#import "CheckConnectionViewController.h"
#import "BarcodeSelector.h"
#import "BarcodeSelector2D.h"
#import "Cut.h"
#import "TextFormating.h"
#import "rasterPrinting.h"
#import "StandardHelp.h"
#import "BarcodePrintingMini.h"
#import "TextFormatingMini.h"
#import "JpKnjFormating.h"
#import "JpKnjFormatingMini.h"
#import "CommonEnum.h"
#import "Language.h"
#import "UITextField+Validations.h"
#import "Reachability.h"
#import "LogViewController.h"
#import <mpos.core/mpos-extended.h>
#import "CommonMethods.h"
#import "ISUPosSoapService.h"

@interface TrasectionsViewController ()
{
    AppDelegate *appDelegate;
    
    UIView *moreButtonView;
    NSMutableArray *morebuttons;
    UIButton *morebutton;
    UIPopoverController *popover;
    NSMutableArray *arr2;
    
    int selectedRow,selectedSection;
    
    NSMutableArray *dictAllItems;
    
    NSString *text_string;
    
    float zzzz, total, totalvat;
    
    NSMutableDictionary *dictSub;
    NSString *currencySign;
    int printCount;
    NSMutableArray *array_refunddata;
    int refund;
    
    NSMutableArray *array_SearchData;
    BOOL filterdone;
    
    UIAlertView *alertViewChangeName;
    NSArray *backUpArray;
    NSString *str_datefrom;
    
    
    NSString *str_Multiple;
    NSString *str_DiscountType;
    int int_TotalVat;
    float float_Discount;
    float float_TotalPrice;
    
    BOOL isRefundTran;
    BOOL isPrintTran;
    BOOL bool_RegisterSale;
    
    
    IBOutlet UIView *view_EmailPopUpBg,*view_EmailBg;
    IBOutlet UITextField *txt_Email;
    IBOutlet UIButton *btn_DropDown,*btn_EmailOk,*btn_EmailCancel;
    IBOutlet UITableView *tbl_EmailList;
    
    NSMutableArray *ary_EmailList;
    
}

@property (weak, nonatomic) IBOutlet UIButton *btnPrintTransection;


// IBActions
- (IBAction) buttonRefund:(id)sender;

- (IBAction) buttonViewPayment:(id)sender;


@end

@implementation TrasectionsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
    [TrasectionsViewController setPortName:localPortName];
    
    NSString *localPortSettings = @"mini";
    
    [TrasectionsViewController setPortSettings:localPortSettings];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Splunk Mint Breadcrumb added
    [[Mint sharedInstance] leaveBreadcrumb:@"TransactionsViewController_ViewController"];
    
    arr2=[NSMutableArray new];
    // Do any additional setup after loading the view.
    
    array_refunddata=[[NSMutableArray alloc] init];
    refund=0;
    array_SearchData=[[NSMutableArray alloc]init];
    
    bool_RegisterSale = NO;
    
    for (UIView *view in self.navigationController.navigationBar.subviews )
    {
        if (view.tag == -1)
        {
            [view removeFromSuperview];
        }
        
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    UILabel *lbl_manReg_ID = [[UILabel alloc]initWithFrame:CGRectMake(460, 22, 200, 30)];
    lbl_manReg_ID.tag = -1;
    //lbl_manReg_ID.text = [defaults objectForKey:@"INFRASEC_PASSWORD"];
     lbl_manReg_ID.text = [defaults objectForKey:@"POS_ID"];
    lbl_manReg_ID.textColor = [UIColor whiteColor];
    lbl_manReg_ID.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:11];
    lbl_manReg_ID.textAlignment = NSTextAlignmentCenter;
    lbl_manReg_ID.center =  CGPointMake(self.view.frame.size.width/2, lbl_manReg_ID.frame.origin.y+lbl_manReg_ID.frame.size.height/2);
//    [self.navigationController.navigationBar addSubview:lbl_manReg_ID];


    
    NSDictionary *dictRoot = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Product_Details" ofType:@"plist"]];

    
    NSDictionary *dict1 = [dictRoot valueForKey:@"Product_Code"];
    NSString *string1 = [dict1 valueForKey:@"Prefix"];
    NSString *string2 = [dict1 valueForKey:@"Suffix"];
    

    
    UIWindow* currentWindow = [UIApplication sharedApplication].keyWindow;
    
    for (UIView *view in currentWindow.subviews )
    {
        if (view.tag == -100 || view.tag == -200)
        {
            [view removeFromSuperview];
        }
        
    }
    
    
    UILabel *lbl_LeftBarItem = [[UILabel alloc]initWithFrame:CGRectMake(7, 50, 100, 15)];
    lbl_LeftBarItem.text = [NSString stringWithFormat:@"%@ %@ Ver: %@", string1, string2, [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    lbl_LeftBarItem.tag = -100;
    lbl_LeftBarItem.textColor = [UIColor whiteColor];
    lbl_LeftBarItem.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:11];
    
    
    
    
    UILabel *lbl_RightBarItem = [[UILabel alloc]initWithFrame:CGRectMake(858, 50, 160, 15)];
    lbl_RightBarItem.tag = -200;
    lbl_RightBarItem.textAlignment = NSTextAlignmentRight;
    lbl_RightBarItem.text = [NSString stringWithFormat:@"%@:%@",[dictRoot valueForKey:@"Manufacturer"],[defaults objectForKey:@"POS_ID"]];
    lbl_RightBarItem.textColor = [UIColor whiteColor];
    lbl_RightBarItem.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:11];
    
    
    
    [currentWindow addSubview:lbl_LeftBarItem];
    [currentWindow addSubview:lbl_RightBarItem];


     self.btnPrintTransection.hidden=YES;
    mailSendButton.hidden=YES;
    isPrintTran=NO;
    
    
    view_EmailBg.layer.borderWidth = 1;
    view_EmailBg.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    
    tbl_EmailList.layer.borderWidth = 1;
    tbl_EmailList.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    
    ary_EmailList = [NSMutableArray new];
}


-(void)Settitles
{
    self.title=[Language get:@"Transactions" alter:@"!Transactions"];
    labelSearchTop.text=[Language get:@"Amount, receipt no" alter:@"!Amount, receipt no"];
    searchBarTest.placeholder = [Language get:@"Find Transaction" alter:@"!Find Transaction"];
    [buttonViewOriginal setTitle:[Language get:@"View Original Payment" alter:@"!View Original Payment"] forState:UIControlStateNormal];
    
    [buttonRefundAmount setTitle:[Language get:@"Refund" alter:@"!Refund"] forState:UIControlStateNormal];
    [labelViewMap setTitle:[Language get:@"View on map" alter:@"!View on map"] forState:UIControlStateNormal];
    
    Label_PrinterName.text=[Language get:@"Amount, receipt no" alter:@"!Amount, receipt no"];
    self.print_Options_lbl.text=[Language get:@"Printer Options" alter:@"!Printer Options"];
    [self.print_status setTitle:[Language get:@"Print" alter:@"!Print"] forState:UIControlStateNormal];
    self.printer_label.text=[Language get:@"Printer" alter:@"!Printer"];
    [printerCopies setText:[NSString stringWithFormat:@"1 %@",[Language get:@"Copy" alter:@"!Copy"]]];
    labelReceipt.text = [Language get:@"Receipt" alter:@"!Receipt"];

    
}


- (void) viewWillAppear:(BOOL)animated
{
    view_EmailPopUpBg.hidden = YES;
    bool_RegisterSale = NO;
    [self Settitles];
    
    AppDelegate *appDelegate1 = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context =[appDelegate1 managedObjectContext];
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
    
    filterdone=NO;
    
    miniPrinterFunctions = [[MiniPrinterFunctions alloc] init];
    
    text_string = @"BT:PRNT Star";
    
    [self setPortInfo];
    NSString *portName = [AppDelegate getPortName];
    NSString *portSettings = [AppDelegate getPortSettings];
    [MiniPrinterFunctions CheckStatusWithPortname:portName portSettings:portSettings sensorSetting:SensorActiveHigh];
    
    printCount=1;
    Label_PrinterName.text=[[NSUserDefaults standardUserDefaults] valueForKey:@"PrinterStatus"];
    
    tableViewItems.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    labelRefundedAmount.hidden = YES;
    
    buttonViewOriginal.hidden = YES;
    
    printerview.hidden=YES;
    self.navigationItem.hidesBackButton = YES;
    [super viewWillAppear:animated];
    if(klm==1)
    {
        UIStoryboard* storyboard   = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ManageArticalViewController *manage_artical = [storyboard instantiateViewControllerWithIdentifier:@"ManageArticalView"];
        [self.navigationController pushViewController:manage_artical animated:NO];
    }
    else if(klm==2)
    {
        //        UIStoryboard* storyboard   = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        //        ManageArticalViewController *manage_artical = [storyboard instantiateViewControllerWithIdentifier:@"ManageArticalView"];
        //        [self.navigationController pushViewController:manage_artical animated:NO];
    }
    else if(klm==3)
    {
        UIStoryboard* storyboard   = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        receiptDataViewController *manage_artical = [storyboard instantiateViewControllerWithIdentifier:@"receiptDataViewController"];
        [self.navigationController pushViewController:manage_artical animated:NO];
    }
    else if(klm==4)
    {
        //        UIStoryboard* storyboard   = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        //        TrasectionsViewController *manage_artical = [storyboard instantiateViewControllerWithIdentifier:@"TrasectionsView"];
        //        [self.navigationController pushViewController:manage_artical animated:NO];
    }
    else if(klm==5)
    {
        UIStoryboard* storyboard   = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        reportViewController *manage_artical = [storyboard instantiateViewControllerWithIdentifier:@"reportView"];
        [self.navigationController pushViewController:manage_artical animated:NO];
    }
    else if(klm==6)
    {
        UIStoryboard* storyboard   = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        linkToViewController *manage_artical = [storyboard instantiateViewControllerWithIdentifier:@"linkToViewController"];
        [self.navigationController pushViewController:manage_artical animated:NO];
    }
    //    self.title=@"Transactions";
    [self add_button_on_tabbar];
    [self getAllTrasection];
    
    if (dictAllItems.count == 0)
    {
        
    }
    else
    {
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
        
        [tablev selectRowAtIndexPath:indexPath animated:YES  scrollPosition:UITableViewScrollPositionBottom];
    }
    self.navigationController.navigationBarHidden = NO;
    

    [[NSUserDefaults standardUserDefaults] setObject:@"Copy" forKey:@"ReciptType"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
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
- (void) viewWillDisappear:(BOOL)animated
{
    self.title=@"";
    //[self.navigationController popToRootViewControllerAnimated:YES];
    [super viewWillDisappear:animated];
    
    
}
- (void)aMethod:(UIButton*)button
{
  
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"CompanyId"])
    {
        if(moreButtonView==nil||button.tag==999)
        {
            //,[Language get:@"Printers" alter:@"!Printers"]
            
            
           morebuttons=[[NSMutableArray alloc]initWithObjects:[Language get:@"Manage Articles" alter:@"!Manage Articles"],[Language get:@"Quick Button/Blocks" alter:@"!Quick Button/Blocks"],[Language get:@"Receipt Data" alter:@"!Receipt Data"], [Language get:@"Transactions" alter:@"!Transactions"],[Language get:@"Reports" alter:@"!Reports"],[Language get:@"Link of TimeDo" alter:@"!Link of TimeDo"], [Language get:@"About ISUPOS" alter:@"!About ISUPOS"],[Language get:@"General Settings" alter:@"!General Settings"], [Language get:@"Sign Out" alter:@"!Sign Out"], nil];
            
            if(button.tag==999){
                
                [moreButtonView removeFromSuperview];
                
                moreButtonView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 1034, 768)];
                moreButtonView.backgroundColor=[UIColor clearColor];
                
                UIImageView *popimage=[[UIImageView alloc]initWithFrame:CGRectMake(1034-204, 64, 208, 650)];
                popimage.image=[UIImage imageNamed:@"more-bg.png"];
                //popimage.backgroundColor=[UIColor blackColor];
                [moreButtonView addSubview:popimage];
                
                int y=75;
                for(int i=0;i<morebuttons.count;i++)
                {
                    UIButton *manage_buttons = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                    [manage_buttons addTarget:self action:@selector(aMethod:)forControlEvents:UIControlEventTouchUpInside];
                    [manage_buttons setTitle:morebuttons[i] forState:UIControlStateNormal];
                    [manage_buttons setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    manage_buttons.frame = CGRectMake(1030-184, y, 164, 50);
                    manage_buttons.layer.borderColor=[UIColor darkGrayColor].CGColor;
                    manage_buttons.layer.borderWidth=1.0;
                    manage_buttons.tag=i+1;
                    [moreButtonView addSubview:manage_buttons];
                    y=y+63;
                }
                
                [self.view addSubview:moreButtonView];
            }
        }
        else if (button.tag==1)
        {
            [moreButtonView removeFromSuperview];
            klm=1;
            [self navigatetonextscreen];
            [self.tabBarController setSelectedIndex:4];
            
        }
        else if (button.tag==2)
        {
            [moreButtonView removeFromSuperview];
            klm=2;
            quickBlocksButtonsView *viewControllerForPopover = [self.storyboard instantiateViewControllerWithIdentifier:@"quickBlocksButtonsView"];
            popover = [[UIPopoverController alloc] initWithContentViewController:viewControllerForPopover];
            [popover setPopoverContentSize:CGSizeMake(567, 500)];
            CGRect rect = CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/2, 1, 1);
            [popover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:0 animated:YES];
            viewControllerForPopover.callBack = self;
            popover.delegate=self;
            moreButtonView=nil;
            [self add_button_on_tabbar];
            
        }
        else if (button.tag==3)
        {
            [moreButtonView removeFromSuperview];
            klm=3;
            [self navigatetonextscreen];
            [self.tabBarController setSelectedIndex:4];
            
        }
        else if (button.tag==4)
        {
            [moreButtonView removeFromSuperview];
            klm=4;
            [self navigatetonextscreen];
            [self.tabBarController setSelectedIndex:4];
            
        }
        else if (button.tag==5)
        {
            [moreButtonView removeFromSuperview];
            klm=5;
            [self navigatetonextscreen];
            [self.tabBarController setSelectedIndex:4];
            
        }
        else if (button.tag==6)
        {
            [moreButtonView removeFromSuperview];
            klm=6;
            [self navigatetonextscreen];
            [self.tabBarController setSelectedIndex:4];
            
        }
        else if (button.tag==7)
        {
            [moreButtonView removeFromSuperview];
            klm=8;
            helo_supportViewController *viewControllerForPopover = [self.storyboard instantiateViewControllerWithIdentifier:@"helo&supportView"];
            popover = [[UIPopoverController alloc] initWithContentViewController:viewControllerForPopover];
            [popover setPopoverContentSize:CGSizeMake(567, 550)];
            CGRect rect = CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/2, 1, 1);
            [popover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:0 animated:YES];
            viewControllerForPopover.callBack = self;
            moreButtonView=nil;
            popover.delegate=self;
            [self add_button_on_tabbar];
            
            
        }
        else if (button.tag==8)
        {
            [moreButtonView removeFromSuperview];
            
            generalSettingViewController *viewControllerForPopover = [self.storyboard instantiateViewControllerWithIdentifier:@"generalSettingView"];
            UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:viewControllerForPopover];
            popover = [[UIPopoverController alloc] initWithContentViewController:navController];
            
            [popover setPopoverContentSize:CGSizeMake(567, 564)];
            CGRect rect = CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/2, 1, 1);
            [popover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:0 animated:YES];
            viewControllerForPopover.callBack = self;
            klm=9;
            popover.delegate=self;
            moreButtonView=nil;
            [self add_button_on_tabbar];
            
            
        }
        else if(button.tag==9)
        {
            UIAlertView* alert1 = [[UIAlertView alloc] init];
            [alert1 setDelegate:self];
            [alert1 setTitle:@"ISUPOS"];
            [alert1 setMessage:[NSString stringWithFormat:@"%@", [Language get:@"Do you want to logout? " alter:@"!Do you want to logout? "]]];
            [alert1 addButtonWithTitle:[NSString stringWithFormat:@"%@", [Language get:@"Yes" alter:@"!Yes"]]];
            [alert1 addButtonWithTitle:[NSString stringWithFormat:@"%@", [Language get:@"No" alter:@"!No"]]];
            alert1.tag=6;
            alert1.alertViewStyle = UIAlertViewStyleDefault;
            
            [alert1 show];
            
            
        }
        
//        else if (button.tag==9){
//            [moreButtonView removeFromSuperview];
//            klm=10;
//            [self.tabBarController setSelectedIndex:4];
//            
//            
//            LogViewController *logViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LogViewController"];
//            [self.navigationController presentViewController:logViewController animated:NO completion:nil];
//        }
        
    }
    else
    {
        if(moreButtonView==nil||button.tag==999)
        {
            //,[Language get:@"Printers" alter:@"!Printers"]
            
            morebuttons=[[NSMutableArray alloc]initWithObjects:[Language get:@"Manage Articles" alter:@"!Manage Articles"],[Language get:@"Quick Button/Blocks" alter:@"!Quick Button/Blocks"],[Language get:@"Receipt Data" alter:@"!Receipt Data"], [Language get:@"Transactions" alter:@"!Transactions"],[Language get:@"Reports" alter:@"!Reports"], [Language get:@"About ISUPOS" alter:@"!About ISUPOS"],[Language get:@"General Settings" alter:@"!General Settings"], [Language get:@"Sign Out" alter:@"!Sign Out"] ,nil];
            
            if(button.tag==999){
                
                [moreButtonView removeFromSuperview];
                
                moreButtonView=[[UIView alloc]initWithFrame:CGRectMake(0,0,1034,768)];
                moreButtonView.backgroundColor=[UIColor clearColor];
                
                UIImageView *popimage=[[UIImageView alloc]initWithFrame:CGRectMake(1034-204,64+50, 208, 650-50)];
                popimage.image=[UIImage imageNamed:@"more-bg.png"];
                //popimage.backgroundColor=[UIColor blackColor];
                [moreButtonView addSubview:popimage];
                
                int y=75+60;
                for(int i=0;i<morebuttons.count;i++)
                {
                    UIButton *manage_buttons = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                    [manage_buttons addTarget:self action:@selector(aMethod:)forControlEvents:UIControlEventTouchUpInside];
                    [manage_buttons setTitle:morebuttons[i] forState:UIControlStateNormal];
                    [manage_buttons setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    manage_buttons.frame = CGRectMake(1030-184, y, 164, 50);
                    manage_buttons.layer.borderColor=[UIColor darkGrayColor].CGColor;
                    manage_buttons.layer.borderWidth=1.0;
                    manage_buttons.tag=i+1;
                    [moreButtonView addSubview:manage_buttons];
                    y=y+63;
                }
                
                [self.view addSubview:moreButtonView];
            }
        }
        else if (button.tag==1)
        {
            [moreButtonView removeFromSuperview];
            klm=1;
            [self navigatetonextscreen];
            [self.tabBarController setSelectedIndex:4];
            
        }
        else if (button.tag==2)
        {
            [moreButtonView removeFromSuperview];
            klm=2;
            quickBlocksButtonsView *viewControllerForPopover = [self.storyboard instantiateViewControllerWithIdentifier:@"quickBlocksButtonsView"];
            popover = [[UIPopoverController alloc] initWithContentViewController:viewControllerForPopover];
            [popover setPopoverContentSize:CGSizeMake(567, 500)];
            CGRect rect = CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/2, 1, 1);
            [popover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:0 animated:YES];
            viewControllerForPopover.callBack = self;
            popover.delegate=self;
            moreButtonView=nil;
            [self add_button_on_tabbar];
            
        }
        else if (button.tag==3)
        {
            [moreButtonView removeFromSuperview];
            klm=3;
            [self navigatetonextscreen];
            [self.tabBarController setSelectedIndex:4];
            
        }
        else if (button.tag==4)
        {
            [moreButtonView removeFromSuperview];
            klm=4;
            [self navigatetonextscreen];
            
            [self.tabBarController setSelectedIndex:4];
            
        }
        else if (button.tag==5)
        {
            [moreButtonView removeFromSuperview];
            klm=5;
            [self navigatetonextscreen];
            
            [self.tabBarController setSelectedIndex:4];
            
        }
        //        else if (button.tag==6)
        //        {
        //            [moreButtonView removeFromSuperview];
        //            klm=6;
        //            [self.tabBarController setSelectedIndex:4];
        //
        //        }
        else if (button.tag==6)
        {
            [moreButtonView removeFromSuperview];
            klm=8;
            helo_supportViewController *viewControllerForPopover = [self.storyboard instantiateViewControllerWithIdentifier:@"helo&supportView"];
            popover = [[UIPopoverController alloc] initWithContentViewController:viewControllerForPopover];
            [popover setPopoverContentSize:CGSizeMake(567, 550)];
            CGRect rect = CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/2, 1, 1);
            [popover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:0 animated:YES];
            viewControllerForPopover.callBack = self;
            moreButtonView=nil;
            popover.delegate=self;
            [self add_button_on_tabbar];
            
            
        }
        else if (button.tag==7)
        {
            [moreButtonView removeFromSuperview];
            
            generalSettingViewController *viewControllerForPopover = [self.storyboard instantiateViewControllerWithIdentifier:@"generalSettingView"];
            UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:viewControllerForPopover];
            popover = [[UIPopoverController alloc] initWithContentViewController:navController];
            
            [popover setPopoverContentSize:CGSizeMake(567, 564)];
            CGRect rect = CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/2, 1, 1);
            [popover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:0 animated:YES];
            viewControllerForPopover.callBack = self;
            klm=9;
            popover.delegate=self;
            moreButtonView=nil;
            [self add_button_on_tabbar];
            
            
        }
        else if(button.tag==8)
        {
            UIAlertView* alert1 = [[UIAlertView alloc] init];
            [alert1 setDelegate:self];
            [alert1 setTitle:@"ISUPOS"];
            [alert1 setMessage:[NSString stringWithFormat:@"%@", [Language get:@"Do you want to logout? " alter:@"!Do you want to logout? "]]];
            [alert1 addButtonWithTitle:[NSString stringWithFormat:@"%@", [Language get:@"Yes" alter:@"!Yes"]]];
            [alert1 addButtonWithTitle:[NSString stringWithFormat:@"%@", [Language get:@"No" alter:@"!No"]]];
            alert1.tag=6;
            alert1.alertViewStyle = UIAlertViewStyleDefault;
            
            [alert1 show];
            
            
        }
        
//        else if (button.tag==9){
//            [moreButtonView removeFromSuperview];
//            klm=10;
//            [self.tabBarController setSelectedIndex:4];
//            [self navigatetonextscreen];
//            
//            LogViewController *logViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LogViewController"];
//            [self.navigationController presentViewController:logViewController animated:NO completion:nil];
//        }
        
    }
    [self.view setNeedsDisplay];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==7)
    {
        if(buttonIndex==1)
        {
            [self getRefundData];
            
            
//            NSManagedObjectContext *context =[appDelegate managedObjectContext];
//            NSEntityDescription *entityDesc1 =[NSEntityDescription entityForName:@"RefundAmount" inManagedObjectContext:context];
//            NSFetchRequest *request1 = [[NSFetchRequest alloc] init];
//            [request1 setEntity:entityDesc1];
//            NSError *error1;
//            
//            NSArray *objects = [context executeFetchRequest:request1 error:&error1];
//            for(int i=0;i<objects.count;i++)
//            {
//             
//            }
            
        }
        
    }
    else if (alertView.tag==6)
    {
        if(buttonIndex==0)
        {
            AppDelegate *appDelegateTemp = [[UIApplication sharedApplication]delegate];
            [appDelegateTemp clearCart];
            UIViewController* rootController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"LoginViewController"];
            UINavigationController* navigation = [[UINavigationController alloc] initWithRootViewController:rootController];
            appDelegateTemp.window.rootViewController = navigation;
        }
        
    }
    else if (alertView.tag==119)
    {
        if (buttonIndex==0) {
            
            searchBarTest.text = @"";
            labelFooterDate.hidden = NO;
            [searchBarTest resignFirstResponder];
            
            [tablev reloadData];
          //  [self setMiddlePart];
            
        }
    }
    
    else if (alertView.tag==120)
    {
        if (buttonIndex==0) {
            
            searchBarTest.text = @"";
            labelFooterDate.hidden = NO;
            [searchBarTest resignFirstResponder];
            
            [tablev reloadData];
            //  [self setMiddlePart];
            
        }
    }
    
    if (alertView.tag == 103) {
        if (buttonIndex == 0) {
            if ([[alertView textFieldAtIndex:0] validEmailAddress]) {
                
                
                Reachability *reachability = [Reachability reachabilityForInternetConnection];
                NetworkStatus internetStatus = [reachability currentReachabilityStatus];
                if (internetStatus != NotReachable) {
                
                [[NSUserDefaults standardUserDefaults] setObject:@"Tran" forKey:@"MailType"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                NSString *email = [alertViewChangeName textFieldAtIndex:0].text;
                [[NSUserDefaults standardUserDefaults] setObject:email forKey:@"EMAIL"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [[AppDelegate delegate] sendMailWithSubject:[NSString stringWithFormat:@"%@", [Language get:@"Receipt" alter:@"!Receipt"]]  sendFrom:@"" ToReciepents:@"" messageHtmlBodyContent:@""];
                
                    
                    
                    if (isRefundTran==NO) {
                        
                        [self editTransactionForMailStatus:[[[[dictAllItems objectAtIndex:selectedSection] objectForKey:@"main"] objectAtIndex:selectedRow] valueForKey:@"id"]];
                        
                        
                        [appDelegate PrintAndMailCountUpdate:3 amount:float_TotalPrice];
                    }
                    else
                    {
                        [self editRefundForMailStatus:[[[[dictAllItems objectAtIndex:selectedSection] objectForKey:@"main"] objectAtIndex:selectedRow] valueForKey:@"id"]];
                    }
                    
                }
                else {
                    
                    [[[UIAlertView alloc] initWithTitle:@"ISUPOS" message:[Language get:@"Please check your internet connection." alter:@"!Please check your internet connection."] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                }
            }
            
        }
    }
}

-(void)add_button_on_tabbar
{
    [moreButtonView removeFromSuperview];
    [morebutton removeFromSuperview];
    
    morebutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [morebutton addTarget:self action:@selector(aMethod:)forControlEvents:UIControlEventTouchUpInside];
    [morebutton setBackgroundImage:[UIImage imageNamed:@"morebutton.png"] forState:UIControlStateNormal];
    [morebutton setTitleEdgeInsets:UIEdgeInsetsMake(28.0f, 2.0f, 0.0f, 0.0f)];
    [morebutton setTitle:[NSString stringWithFormat:@"%@",[Language get:@"More" alter:@"!More"]] forState:UIControlStateNormal];
    [morebutton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    morebutton.frame = CGRectMake(1024-204, 0, 208, 59);
    morebutton.tag=999;
    [self.tabBarController.tabBar addSubview:morebutton];
    
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [moreButtonView removeFromSuperview];
    [self add_button_on_tabbar];
    //moreButtonView=nil;
    printerview.hidden=YES;
    
    view_EmailPopUpBg.hidden = YES;
    
}

-(void)navigatetonextscreen
{
    if(klm==1)
    {
        UIStoryboard* storyboard   = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ManageArticalViewController *manage_artical = [storyboard instantiateViewControllerWithIdentifier:@"ManageArticalView"];
        [self.navigationController pushViewController:manage_artical animated:NO];
    }
    if(klm==3)
    {
        UIStoryboard* storyboard   = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        receiptDataViewController *manage_artical = [storyboard instantiateViewControllerWithIdentifier:@"receiptDataViewController"];
        [self.navigationController pushViewController:manage_artical animated:NO];
    }
    if(klm==4)
    {
        [self add_button_on_tabbar];
        moreButtonView=nil;
    }
    else if(klm==5)
    {
        UIStoryboard* storyboard   = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        reportViewController *manage_artical = [storyboard instantiateViewControllerWithIdentifier:@"reportView"];
        
        [self.navigationController pushViewController:manage_artical animated:NO];
    }
    else if(klm==6)
    {
        UIStoryboard* storyboard   = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        linkToViewController *manage_artical = [storyboard instantiateViewControllerWithIdentifier:@"linkToViewController"];
        [self.navigationController pushViewController:manage_artical animated:NO];
    }
    else if(klm==9)
    {
        UIStoryboard* storyboard   = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        linkToViewController *manage_artical = [storyboard instantiateViewControllerWithIdentifier:@"LogViewController"];
        [self.navigationController pushViewController:manage_artical animated:NO];
    }

    
}
- (IBAction)steeper_action:(UIStepper*)sender
{
    double value = [sender value];
    
    printCount=[sender value];
    
    sender.minimumValue = 1;
    
    
    [printerCopies setText:[NSString stringWithFormat:@"%d %@", (int)value,[Language get:@"Copy" alter:@"!Copy"]]];
    if((int)value>1)
        [printerCopies setText:[NSString stringWithFormat:@"%d %@", (int)value,[Language get:@"Copies" alter:@"!Copies"]]];
}

#pragma mark Printer Methods


- (IBAction)select_printerAndPrint:(UIButton*)sender
{
   
    [self setPortInfo];
    NSString *portName = [AppDelegate getPortName];
    NSString *portSettings = [AppDelegate getPortSettings];
    
    
        //[MiniPrinterFunctions showFirmwareInformation:portName portSettings:portSettings];
    
    
    
   [MiniPrinterFunctions CheckStatusWithPortname:portName portSettings:portSettings sensorSetting:SensorActiveHigh];

    
    [[NSUserDefaults standardUserDefaults] setObject:@"Copy" forKey:@"ReciptType"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"PrinterStatus"] isEqualToString:@"Online"]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"print_merchant_receipt"];
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"print_customer_receipt"];
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"print_combined_receipt"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    
    for (int i =1; i<=printCount; i++) {
        
        [MiniPrinterFunctions PrintSampleReceiptWithPortname:portName
                                                portSettings:portSettings
                                                   widthInch:2];
        
    }
        
        
        
        
        if (isRefundTran==NO) {
            
            [appDelegate PrintAndMailCountUpdate:4 amount:float_TotalPrice];
            
        [self editTransactionForPrintStatus:[[[[dictAllItems objectAtIndex:selectedSection] objectForKey:@"main"] objectAtIndex:selectedRow] valueForKey:@"id"]];
        }
        else
        {
        [self editRefundForPrintStatus:[[[[dictAllItems objectAtIndex:selectedSection] objectForKey:@"main"] objectAtIndex:selectedRow] valueForKey:@"id"]];
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ISUPOS" message:@"Printer not connected." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
    printerview.hidden=YES;
    
}
- (IBAction)printSelectAndMessage:(UIButton*)sender
{
    //printerview.hidden=NO;
    [self setPortInfo];
    NSString *portName = [AppDelegate getPortName];
    NSString *portSettings = [AppDelegate getPortSettings];
    
    
    //    [MiniPrinterFunctions showFirmwareInformation:portName portSettings:portSettings];
    
    
    
    [MiniPrinterFunctions CheckStatusWithPortname:portName portSettings:portSettings sensorSetting:SensorActiveHigh];
    
    if (buttonRefundAmount.isHidden)
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"Refund" forKey:@"ReciptType"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"Copy" forKey:@"ReciptType"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"PrinterStatus"] isEqualToString:@"Online"]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"print_merchant_receipt"];
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"print_customer_receipt"];
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"print_combined_receipt"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        for (int i =1; i<=printCount; i++) {
            
            [MiniPrinterFunctions PrintSampleReceiptWithPortname:portName
                                                    portSettings:portSettings
                                                       widthInch:2];
            
        }
        
        
        
        
        if (isRefundTran==NO) {
            
            [appDelegate PrintAndMailCountUpdate:4 amount:float_TotalPrice];
            
            [self editTransactionForPrintStatus:[[[[dictAllItems objectAtIndex:selectedSection] objectForKey:@"main"] objectAtIndex:selectedRow] valueForKey:@"id"]];
        }
        else
        {
            [self editRefundForPrintStatus:[[[[dictAllItems objectAtIndex:selectedSection] objectForKey:@"main"] objectAtIndex:selectedRow] valueForKey:@"id"]];
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ISUPOS" message:@"Printer not connected." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
    }
    
    printerview.hidden=YES;
    
}


- (IBAction) buttonRefund:(id)sender
{
    if (dictAllItems.count>0) {
    
    UIAlertView* alert1 = [[UIAlertView alloc] initWithTitle:@"ISUPOS" message:[Language get:@"Refund can't be undone" alter:@"!Refund can't be undone"] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    alert1.tag=7;
    alert1.alertViewStyle = UIAlertViewStyleDefault;
    
    [alert1 show];
    
    }
    
}

- (void) animateView
{
    CATransition *t = [CATransition animation];
    t.type = kCATransitionPush;
    [t setDuration:0.2];
    t.subtype = kCATransitionFromRight;
    [tableViewItems.layer addAnimation:t forKey:nil];
}

- (IBAction) buttonViewPayment:(id)sender
{
    
    [self animateView];
    
    labelTotalAmount.text = [labelTotalAmount.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    labelVat.text = [labelVat.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    labelTotalAmount.textColor = [UIColor darkGrayColor];
    
    tableViewItems.hidden = NO;
    
    buttonViewOriginal.hidden = YES;
    
    labelRefundedAmount.hidden = NO;
    
    [self setSectionAndRowForAmmount:labelTotalAmount.text andZid:labelTotalAmount.tag];
    
    
    
    [tablev reloadData];
    
    [tableViewItems reloadData];
    
   
    
}


-(void)getRefundData
{
    appDelegate =[[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context =
    [appDelegate managedObjectContext];
    
    NSEntityDescription *entityDesc =
    [NSEntityDescription entityForName:@"RefundAmount"
                inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
    
    
    NSPredicate *pred =
    [NSPredicate predicateWithFormat:@"(id = %@)",
     [[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:0] valueForKey:@"id"]];

    [request setPredicate:pred];

    
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request
                                              error:&error];
    
    if ([objects count] == 0) {
        
        [self SaveRefundData];
        
    } else {
        
        NSLog(@"Id alreday exist");
        
    }
}

-(void)getRefundID:(NSString *)Id
{
    appDelegate =
    [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context =
    [appDelegate managedObjectContext];
    
    NSEntityDescription *entityDesc =
    [NSEntityDescription entityForName:@"RefundAmount"
                inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
    NSPredicate *pred =
    [NSPredicate predicateWithFormat:@"(id = %@)",
     Id];
    [request setPredicate:pred];
    //    NSManagedObject *matches = nil;
    
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request
                                              error:&error];
    
    if ([objects count] == 0) {
        
        
        
    } else {
        
        
        array_refunddata=[NSMutableArray new];
        NSManagedObject *person = (NSManagedObject *)[objects objectAtIndex:0];
      
        //Anu:21July2016
        NSString *str_price=[person valueForKey:@"totalAmount"];
        
        if ([str_price isEqual:[NSNull null]])
            [dictSub setObject:@"" forKey:@"totalAmount"];
        else
            [dictSub setObject:str_price forKey:@"totalAmount"];
        //[dictSub setObject:[person valueForKey:@"totalAmount"] forKey:@"totalAmount"];

        [dictSub setObject:[person valueForKey:@"price"] forKey:@"price"];
        [dictSub setObject:[person valueForKey:@"refundDate"] forKey:@"refundDate"];
        [dictSub setObject:[person valueForKey:@"vat"] forKey:@"vat"];
        [dictSub setObject:[person valueForKey:@"id"] forKey:@"rid"];
        [dictSub setObject:[person valueForKey:@"code"] forKey:@"code"];
        [dictSub setObject:[person valueForKey:@"count"] forKey:@"count"];
        [dictSub setObject:[person valueForKey:@"discription"] forKey:@"discription"];
        [dictSub setObject:[person valueForKey:@"image"] forKey:@"image"];
        [dictSub setObject:[person valueForKey:@"name"] forKey:@"name"];
        [dictSub setObject:[person valueForKey:@"discount"] forKey:@"peritemdiscount"];
        [dictSub setObject:[person valueForKey:@"time"] forKey:@"time"];
        [dictSub setObject:[person valueForKey:@"date"] forKey:@"date"];
        [dictSub setObject:[person valueForKey:@"type"] forKey:@"type"];
        [dictSub setObject:[person valueForKey:@"currency"] forKey:@"currency"];
        [dictSub setObject:[person valueForKey:@"paymentMethod"] forKey:@"paymentMethod"];

        zzzz=[[person valueForKey:@"price"] floatValue];//-[[person valueForKey:@"discount"]floatValue]);
        
        [dictSub setObject:[NSString stringWithFormat:@"%.02f",zzzz] forKey:@"peritemprice"];
        
        //        [array_refunddata addObject:dictSub];
    }
}



-(void)SaveRefundData
{
    
    appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context =[appDelegate managedObjectContext];
    
    // Check for card transactions
    if([[[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:0] valueForKey:@"paymentMethod"] isEqualToString:@"2"])
    {
        
        //get transaction details from DB
        
        NSError *error;
        
        NSEntityDescription *entityDescRec =[NSEntityDescription entityForName:@"Recepit_CardPayment" inManagedObjectContext:context];
        NSFetchRequest *requestRec = [[NSFetchRequest alloc] init];
        [requestRec setEntity:entityDescRec];
        NSPredicate *cardPredicate = [NSPredicate predicateWithFormat:@"receipt_id = %@",[[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:0] valueForKey:@"id"]];
        [requestRec setPredicate:cardPredicate];
        NSArray *cardObjects = [context executeFetchRequest:requestRec error:&error];
        NSString *transactionID=@"";
        if(cardObjects.count)
        {
            NSManagedObject *record = (NSManagedObject *)[cardObjects firstObject];
            transactionID = [record valueForKey:@"receipt_transaction_id"];
        }
        
        MPTransactionParameters *parameters =
        [MPTransactionParameters refundForTransactionIdentifier:transactionID
                                                      optionals:
         ^(id<MPTransactionParametersRefundOptionals>  _Nonnull optionals)
         {
             optionals.subject = @"Refund for sale";
             optionals.customIdentifier = @"yourReferenceForTheTransaction";
             
             // For partial refunds, specify the amount to be refunded
             // and the currency from the original transaction
             // [optionals setAmount:[NSDecimalNumber decimalNumberWithString:@"1.00"] currency:MPCurrencyEUR];
         }];
        
        MPTransactionProvider *transactionProvider =[MPMpos transactionProviderForMode:MPProviderModeTEST  //MPProviderModeLIVE
                                                                        merchantIdentifier:[[NSUserDefaults standardUserDefaults] valueForKey:KPAYWORKS_MERCHANT_IDENTIFIER]
                                                                         merchantSecretKey:[[NSUserDefaults standardUserDefaults] valueForKey:KPAYWORKS_MERCHANT_SECRET]];

        
        
        
        [transactionProvider amendTransactionWithParameters:parameters statusChanged:^(MPTransactionProcess * _Nonnull transactionProcess, MPTransaction * _Nullable transaction, MPTransactionProcessDetails * _Nonnull details) {
            
            NSLog(@"Status Changed");

            
        } completed:^(MPTransactionProcess * _Nonnull transactionProcess, MPTransaction * _Nullable transaction, MPTransactionProcessDetails * _Nonnull details) {
            NSLog(@" Refund Process Completed");
            if(transaction)
               {
                   if(transaction.refundDetails.status == MPRefundDetailsStatusRefunded)
                   {
            NSError *error;
            
            NSEntityDescription *entityDescRec =[NSEntityDescription entityForName:@"ReceiptNo" inManagedObjectContext:context];
            NSFetchRequest *requestRec = [[NSFetchRequest alloc] init];
            [requestRec setEntity:entityDescRec];
            
            NSArray *objectsRec = [context executeFetchRequest:requestRec error:&error];
            NSManagedObject *persoRec = (NSManagedObject *)[objectsRec lastObject];
            
            int x=[[persoRec valueForKey:@"id"] intValue]+1;
            
            NSManagedObject *newContactRec;
            
            newContactRec = [NSEntityDescription insertNewObjectForEntityForName:@"ReceiptNo" inManagedObjectContext:context];
            [newContactRec setValue:[NSDate date] forKey:@"receiptdate"];
            [newContactRec setValue:[NSNumber numberWithInt:x] forKey:@"id"];
            
            [context save:&error];
            
            
            NSEntityDescription *entityDesc =[NSEntityDescription entityForName:@"RefundAmount" inManagedObjectContext:context];
            NSFetchRequest *request = [[NSFetchRequest alloc] init];
            [request setEntity:entityDesc];
            
            //    NSArray *objects = [context executeFetchRequest:request error:&error];
            
            
            for (int i = 0; i<[[appDelegate.reciptArray valueForKey:@"sub"] count]; i++)
            {
                
                NSManagedObject *newContact;
                newContact = [NSEntityDescription insertNewObjectForEntityForName:@"RefundAmount" inManagedObjectContext:context];
                
                //Anu:22June2016
                NSNumberFormatter *formatString = [[NSNumberFormatter alloc] init];
                //f.numberStyle = NSNumberFormatterNoStyle;
                
                // NSNumber *NumberVat = [formatString numberFromString:[appDelegate.reciptArray valueForKey:@"totalvat"]];
                
                NSNumber  *NumberVat = [NSNumber numberWithFloat: [[appDelegate.reciptArray valueForKey:@"totalvat"] floatValue]];
                
                
                [newContact setValue:NumberVat forKey:@"vat"];
                
                // NSNumber *NumberId = [formatString numberFromString:[appDelegate.reciptArray valueForKey:@"id"]];
                NSNumber *NumberId = [NSNumber numberWithFloat: [[appDelegate.reciptArray valueForKey:@"id"] floatValue]];
                
                [newContact setValue:[NSNumber numberWithInt:x] forKey:@"id"];
                
                [newContact setValue:NumberId forKey:@"rid"];
                
                NSNumber *name = [[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:i] valueForKey:@"name"];
                NSLog(@"name : %@",[[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:i] valueForKey:@"name"]);
                
                NSString *str=[[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:i] valueForKey:@"price"];
                NSNumber *NumberPrice = [NSNumber numberWithFloat: [str floatValue]];
                
                //NSNumber *NumberPrice = [formatString numberFromString:[NSString stringWithFormat:@"%@",[[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:i] valueForKey:@"price"]]];
                
                NSLog(@"NumberPrice : %@",[formatString numberFromString:[NSString stringWithFormat:@"%@",[[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:i] valueForKey:@"price"]]]);
                
                
                NSNumber *NumberDiscunt = [formatString numberFromString:[NSString stringWithFormat:@"%@",[[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:i] valueForKey:@"discount1"]]];
                NSLog(@"NumberDiscunt : %@",[formatString numberFromString:[NSString stringWithFormat:@"%@",[[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:i] valueForKey:@"discount1"]]]);
                
                
                NSString *str1=[[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:i] valueForKey:@"peritemprice"];
                NSNumber *NumberPerPrice = [NSNumber numberWithFloat: [str1 floatValue]];
                
                
                //NSNumber *NumberPerPrice = [formatString numberFromString:[NSString stringWithFormat:@"%@",[[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:i] valueForKey:@"peritemprice"]]];
                NSLog(@"NumberPerPrice : %@",[formatString numberFromString:[NSString stringWithFormat:@"%@",[[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:i] valueForKey:@"peritemprice"]]]);
                
                
                [newContact setValue:name forKey:@"name"];
                [newContact setValue:NumberPrice forKey:@"price"];
                [newContact setValue:NumberPerPrice forKey:@"peritemprice"];
                [newContact setValue:NumberDiscunt forKey:@"discount"];
                [newContact setValue:[NSDate date] forKey:@"refundDate"];
                [newContact setValue:[NSNumber numberWithInt:0] forKey:@"zdayStatus"];
                [newContact setValue:[NSNumber numberWithInt:0] forKey:@"printStatus"];
                [newContact setValue:[NSNumber numberWithInt:0] forKey:@"mailStatus"];
                
                float totalPr;
                float dis;
                float toDis;
                totalPr=[[appDelegate.reciptArray valueForKey:@"tprice"] floatValue];
                dis=[[[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:i] valueForKey:@"discount1"] floatValue];
                toDis=totalPr-dis;
                
                NSString *strTotPrice = [NSString stringWithFormat:@"-%.02f",totalPr];
                // NSNumber *NumberTotalPrice = [formatString numberFromString:[NSString stringWithFormat:@"-%.02f",totalPr]];
                NSNumber *NumberTotalPrice = [NSNumber numberWithFloat: [strTotPrice floatValue]];
                if (NumberTotalPrice ==nil)
                    [newContact setValue:@"0" forKey:@"totalAmount"];
                else
                    [newContact setValue:NumberTotalPrice forKey:@"totalAmount"];
                
                [newContact setValue:[[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:i] valueForKey:@"discription"] forKey:@"discription"];
                [newContact setValue:[[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:i] valueForKey:@"count"] forKey:@"count"];
               
                [newContact setValue:[[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:i] valueForKey:@"paymentMethod"] forKey:@"paymentMethod"];

                
                NSDate *currDate = [NSDate date];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
                [dateFormatter setDateFormat:@"dd MMMM yyyy"];
                NSString *dateString = [dateFormatter stringFromDate:currDate];
                
                [newContact setValue:dateString forKey:@"date"];
                
                NSDate *currDate1 = [NSDate date];
                NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc]init];
                [dateFormatter1 setDateFormat:@"hh:mm:ss a"];
                NSString *dateString1 = [dateFormatter1 stringFromDate:currDate1];
                
                [newContact setValue:dateString1 forKey:@"time"];
                
                [newContact setValue:[[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:i] valueForKey:@"name"] forKey:@"name"];
                [newContact setValue:[[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:i] valueForKey:@"code"] forKey:@"code"];
                [newContact setValue:[[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:i] valueForKey:@"type"] forKey:@"type"];
                [newContact setValue:[[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:i] valueForKey:@"currency"] forKey:@"currency"];
                [newContact setValue:[[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:i] valueForKey:@"article_id"] forKey:@"article_id"];
                [context save:&error];
                
                
                NSEntityDescription *entityDesc2 =[NSEntityDescription entityForName:@"Trasections" inManagedObjectContext:context];
                NSFetchRequest *request11 = [[NSFetchRequest alloc] init];
                [request11 setEntity:entityDesc2];
                NSPredicate *predicate;
                predicate = [NSPredicate predicateWithFormat:@"(id = %@)",NumberId];
                [request11 setPredicate:predicate];
                
                
                NSArray *objects2 = [context executeFetchRequest:request11 error:&error];
                
                for (NSManagedObject *obj in objects2) {
                    [obj setValue:[NSNumber numberWithBool:YES] forKey:@"isrefund"];
                    //[obj setValue:@"2" forKey:@"paymentMethod"];
                    [obj setValue:NumberId forKey:@"rid"];
                    
                    [context save:&error];
                    
                }
            }

        isPrintTran=NO;
        [self getAllTrasection];
                       
            }
        }
            
        }];
    
    }
    else
    {
    
    NSError *error;
    
    NSEntityDescription *entityDescRec =[NSEntityDescription entityForName:@"ReceiptNo" inManagedObjectContext:context];
    NSFetchRequest *requestRec = [[NSFetchRequest alloc] init];
    [requestRec setEntity:entityDescRec];
   
    NSArray *objectsRec = [context executeFetchRequest:requestRec error:&error];
    NSManagedObject *persoRec = (NSManagedObject *)[objectsRec lastObject];
    
    int x=[[persoRec valueForKey:@"id"] intValue]+1;
    
    NSManagedObject *newContactRec;
    
    newContactRec = [NSEntityDescription insertNewObjectForEntityForName:@"ReceiptNo" inManagedObjectContext:context];
    [newContactRec setValue:[NSDate date] forKey:@"receiptdate"];
    [newContactRec setValue:[NSNumber numberWithInt:x] forKey:@"id"];
    
    [context save:&error];
    
    
    NSEntityDescription *entityDesc =[NSEntityDescription entityForName:@"RefundAmount" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
    //    NSArray *objects = [context executeFetchRequest:request error:&error];
    
    
    for (int i = 0; i<[[appDelegate.reciptArray valueForKey:@"sub"] count]; i++)
    {
    
    NSManagedObject *newContact;
    newContact = [NSEntityDescription insertNewObjectForEntityForName:@"RefundAmount" inManagedObjectContext:context];

     //Anu:22June2016
    NSNumberFormatter *formatString = [[NSNumberFormatter alloc] init];
    //f.numberStyle = NSNumberFormatterNoStyle;
        
   // NSNumber *NumberVat = [formatString numberFromString:[appDelegate.reciptArray valueForKey:@"totalvat"]];
        
    NSNumber  *NumberVat = [NSNumber numberWithFloat: [[appDelegate.reciptArray valueForKey:@"totalvat"] floatValue]];
       

    [newContact setValue:NumberVat forKey:@"vat"];
    
   // NSNumber *NumberId = [formatString numberFromString:[appDelegate.reciptArray valueForKey:@"id"]];
    NSNumber *NumberId = [NSNumber numberWithFloat: [[appDelegate.reciptArray valueForKey:@"id"] floatValue]];
        
    [newContact setValue:[NSNumber numberWithInt:x] forKey:@"id"];
    
    [newContact setValue:NumberId forKey:@"rid"];

        NSNumber *name = [[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:i] valueForKey:@"name"];
        NSLog(@"name : %@",[[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:i] valueForKey:@"name"]);
        
        NSString *str=[[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:i] valueForKey:@"price"];
        NSNumber *NumberPrice = [NSNumber numberWithFloat: [str floatValue]];
        
        //NSNumber *NumberPrice = [formatString numberFromString:[NSString stringWithFormat:@"%@",[[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:i] valueForKey:@"price"]]];
        
        NSLog(@"NumberPrice : %@",[formatString numberFromString:[NSString stringWithFormat:@"%@",[[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:i] valueForKey:@"price"]]]);

        
        NSNumber *NumberDiscunt = [formatString numberFromString:[NSString stringWithFormat:@"%@",[[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:i] valueForKey:@"discount1"]]];
        NSLog(@"NumberDiscunt : %@",[formatString numberFromString:[NSString stringWithFormat:@"%@",[[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:i] valueForKey:@"discount1"]]]);
        
        
        NSString *str1=[[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:i] valueForKey:@"peritemprice"];
        NSNumber *NumberPerPrice = [NSNumber numberWithFloat: [str1 floatValue]];
        
        
        //NSNumber *NumberPerPrice = [formatString numberFromString:[NSString stringWithFormat:@"%@",[[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:i] valueForKey:@"peritemprice"]]];
        NSLog(@"NumberPerPrice : %@",[formatString numberFromString:[NSString stringWithFormat:@"%@",[[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:i] valueForKey:@"peritemprice"]]]);


        [newContact setValue:name forKey:@"name"];
        [newContact setValue:NumberPrice forKey:@"price"];
        [newContact setValue:NumberPerPrice forKey:@"peritemprice"];
        [newContact setValue:NumberDiscunt forKey:@"discount"];
        [newContact setValue:[NSDate date] forKey:@"refundDate"];
        [newContact setValue:[NSNumber numberWithInt:0] forKey:@"zdayStatus"];
        [newContact setValue:[NSNumber numberWithInt:0] forKey:@"printStatus"];
        [newContact setValue:[NSNumber numberWithInt:0] forKey:@"mailStatus"];
        

    float totalPr;
    float dis;
    float toDis;
    totalPr=[[appDelegate.reciptArray valueForKey:@"tprice"] floatValue];
    dis=[[[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:i] valueForKey:@"discount1"] floatValue];
    toDis=totalPr-dis;
   
    NSString *strTotPrice = [NSString stringWithFormat:@"-%.02f",totalPr];
   // NSNumber *NumberTotalPrice = [formatString numberFromString:[NSString stringWithFormat:@"-%.02f",totalPr]];
        NSNumber *NumberTotalPrice = [NSNumber numberWithFloat: [strTotPrice floatValue]];
        if (NumberTotalPrice ==nil)
          [newContact setValue:@"0" forKey:@"totalAmount"];
        else
            [newContact setValue:NumberTotalPrice forKey:@"totalAmount"];
        
    [newContact setValue:[[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:i] valueForKey:@"discription"] forKey:@"discription"];
    [newContact setValue:[[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:i] valueForKey:@"count"] forKey:@"count"];

    
    NSDate *currDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd MMMM yyyy"];
    NSString *dateString = [dateFormatter stringFromDate:currDate];
    
    [newContact setValue:dateString forKey:@"date"];
    
    NSDate *currDate1 = [NSDate date];
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc]init];
    [dateFormatter1 setDateFormat:@"hh:mm:ss a"];
    NSString *dateString1 = [dateFormatter1 stringFromDate:currDate1];
    
    [newContact setValue:dateString1 forKey:@"time"];
    
    [newContact setValue:[[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:i] valueForKey:@"name"] forKey:@"name"];
    [newContact setValue:[[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:i] valueForKey:@"code"] forKey:@"code"];
    [newContact setValue:[[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:i] valueForKey:@"type"] forKey:@"type"];
    [newContact setValue:[[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:i] valueForKey:@"currency"] forKey:@"currency"];
        [newContact setValue:[[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:i] valueForKey:@"paymentMethod"] forKey:@"paymentMethod"];
  
    [context save:&error];
        
        
        NSEntityDescription *entityDesc2 =[NSEntityDescription entityForName:@"Trasections" inManagedObjectContext:context];
        NSFetchRequest *request11 = [[NSFetchRequest alloc] init];
        [request11 setEntity:entityDesc2];
        NSPredicate *predicate;
        predicate = [NSPredicate predicateWithFormat:@"(id = %@)",NumberId];
        [request11 setPredicate:predicate];

        
        NSArray *objects2 = [context executeFetchRequest:request11 error:&error];
        
        for (NSManagedObject *obj in objects2) {
            [obj setValue:[NSNumber numberWithBool:YES] forKey:@"isrefund"];
            
            [obj setValue:NumberId forKey:@"rid"];
            
            [context save:&error];
            
            
        }
  }

        isPrintTran=NO;
        bool_RegisterSale = YES;
        [self getAllTrasection];
        
    }
    
    
    
    
}

-(void)getAllTrasection
{
    dictAllItems = [NSMutableArray new];
    
    labelFirstProductQntity.layer.cornerRadius = 11.0f;
    labelSecondProductQntity.layer.cornerRadius = 11.0f;
    
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
    
    appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context =[appDelegate managedObjectContext];
    NSEntityDescription *entityDesc =[NSEntityDescription entityForName:@"Trasections" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
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
        [dictSub setObject:[person valueForKey:@"name"] forKey:@"name"];
        [dictSub setObject:[person valueForKey:@"article_id"] forKey:@"article_id"];
        [dictSub setObject:[person valueForKey:@"count"] forKey:@"count"];
        [dictSub setObject:[person valueForKey:@"price"] forKey:@"price"];
        [dictSub setObject:[person valueForKey:@"vat"] forKey:@"vat"];
        [dictSub setObject:[person valueForKey:@"code"] forKey:@"code"];
        [dictSub setObject:[person valueForKey:@"currency"] forKey:@"currency"];
        [dictSub setObject:[person valueForKey:@"discount"] forKey:@"discount1"];
        [dictSub setObject:[person valueForKey:@"printStatus"] forKey:@"printStatus"];
        [dictSub setObject:[person valueForKey:@"mailStatus"] forKey:@"mailStatus"];
        [dictSub setObject:[person valueForKey:@"paymentMethod"] forKey:@"paymentMethod"];

        
        
        if ([person valueForKey:@"rid"] != nil)
        {
            [dictSub setObject:[person valueForKey:@"rid"] forKey:@"rid"];
        }
        else
            [dictSub setObject:[NSNumber numberWithInt:0] forKey:@"rid"];
        

        [dictSub setObject:[person valueForKey:@"id"] forKey:@"id"];
        [dictSub setObject:@"0" forKey:@"totalAmount"];
        
        if ([CommonMethods validateDictionaryValueForKey:[person valueForKey:@"discription"]]) {
            [dictSub setObject:[person valueForKey:@"discription"] forKey:@"discription"];
        }
        else{
            [dictSub setObject:@"" forKey:@"discription"];
        }
        
        
        NSDate *date  = [person valueForKey:@"date"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        // Convert date object into desired format
        [dateFormatter setDateFormat:@"dd MMMM yyyy"];
        NSString *newDateString = [dateFormatter stringFromDate:date];
        [dictSub setObject:newDateString forKey:@"date"];
        
        
        [dateFormatter setDateFormat:@"hh:mm:ss a"];
        NSString *timeString = [dateFormatter stringFromDate:date];
        [dictSub setObject:timeString forKey:@"time"];
        
        zzzz=[[person valueForKey:@"price"] floatValue];//-[[person valueForKey:@"discount"]floatValue]);
        
        [dictSub setObject:[NSString stringWithFormat:@"%.02f",zzzz] forKey:@"peritemprice"];
        
        
        
        if(curId == -1)
            curId = [[person valueForKey:@"id"] intValue];
        else if (curId != [[person valueForKey:@"id"] intValue])
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
            
            [dictSubb setObject:[person valueForKey:@"code"] forKey:@"code"];
            [dictSubb setObject:[NSString stringWithFormat:@"%d",curId] forKey:@"id"];
            

            
            [dictSubb setObject:arraySubb forKey:@"sub"];
            
            
            [arraySub addObject:dictSubb];
            
            total = 0;
            tprice = 0;
            tpricewithoutvat = 0;
            totalvat = 0;
            float_Discount = 0;
            arraySubb = [NSMutableArray new];
            curId = [[person valueForKey:@"id"] intValue];
            
            
            str_Multiple = @"No";
            
        }
        else if(curId == [[person valueForKey:@"id"] intValue])
        {
            
            str_Multiple = @"Yes";

            
        }
        
        if(cuDate == nil)
            cuDate = newDateString;
        else if (![cuDate isEqualToString:newDateString])
        {
            appDelegate =
            [[UIApplication sharedApplication] delegate];
            
            NSManagedObjectContext *context =
            [appDelegate managedObjectContext];
            
            NSEntityDescription *entityDesc =
            [NSEntityDescription entityForName:@"RefundAmount"
                        inManagedObjectContext:context];
            
            NSFetchRequest *request = [[NSFetchRequest alloc] init];
            [request setEntity:entityDesc];
            
            NSPredicate *pred =
            [NSPredicate predicateWithFormat:@"(date = %@)",cuDate];
            [request setPredicate:pred];
            //    NSManagedObject *matches = nil;
            
            NSError *error;
            NSArray *objects = [context executeFetchRequest:request
                                                      error:&error];
            
            NSMutableDictionary  *dictSubR;
            int index = -1;
            
            NSMutableArray *arr_sub=[NSMutableArray new];
            
            NSString *str_id;
            NSString *str_price;
            NSString *str_code;
            NSString *str_vat;
            
            for (NSManagedObject *personRefund in objects)
            {

                    index = [[personRefund valueForKey:@"rid"]intValue];
                    
                    dictSubR = [NSMutableDictionary new];
        
                    str_id=[personRefund valueForKey:@"id"];
                    str_code=[personRefund valueForKey:@"code"];
                
                //Anu: 21June2016
                if ([personRefund valueForKey:@"totalAmount"]==nil)
                    str_price=@"0";
                else
                    str_price=[personRefund valueForKey:@"totalAmount"];
                
                if ([personRefund valueForKey:@"vat"]==nil)
                    str_vat=@"0";
                else
                    str_vat=[personRefund valueForKey:@"vat"];
                
                    [dictSubR setObject:[personRefund valueForKey:@"mailStatus"] forKey:@"mailStatus"];
                    [dictSubR setObject:[personRefund valueForKey:@"printStatus"] forKey:@"printStatus"];
                    //[dictSubR setObject:[personRefund valueForKey:@"totalAmount"] forKey:@"totalAmount"];
                
                    [dictSubR setObject:str_price forKey:@"totalAmount"];
                
                if ([personRefund valueForKey:@"price"]==nil)
                    [dictSubR setObject:@"0" forKey:@"price"];
                    else
                        [dictSubR setObject:[personRefund valueForKey:@"price"] forKey:@"price"];
                
                    [dictSubR setObject:[personRefund valueForKey:@"refundDate"] forKey:@"refundDate"];
                
                    [dictSubR setObject:str_vat forKey:@"vat"];
                
                    [dictSubR setObject:[personRefund valueForKey:@"id"] forKey:@"id"];
                    [dictSubR setObject:[personRefund valueForKey:@"code"] forKey:@"code"];
                
                    if ([personRefund valueForKey:@"type"] == nil)
                    {
                    [dictSubR setObject:@"$" forKey:@"type"];
                    }
                    else
                    {
                    [dictSubR setObject:[personRefund valueForKey:@"type"] forKey:@"type"];
                    }
                
                    [dictSubR setObject:[personRefund valueForKey:@"rid"] forKey:@"rid"];
                    [dictSubR setObject:[personRefund valueForKey:@"currency"] forKey:@"currency"];
                    [dictSubR setObject:[personRefund valueForKey:@"count"] forKey:@"count"];
                    [dictSubR setObject:[personRefund valueForKey:@"discription"] forKey:@"discription"];
                    [dictSubR setObject:@"" forKey:@"image"];
                    [dictSubR setObject:[personRefund valueForKey:@"name"] forKey:@"name"];
                    if([personRefund valueForKey:@"paymentMethod"]!=nil)
                    [dictSubR setObject:[personRefund valueForKey:@"paymentMethod"] forKey:@"paymentMethod"];

                    if ([personRefund valueForKey:@"discount"] == nil)
                    {
                        [dictSubR setObject:@"0" forKey:@"discount"];
                        [dictSubR setObject:@"0" forKey:@"peritemdiscount"];
                    }
                    else
                    {
                        [dictSubR setObject:[personRefund valueForKey:@"discount"] forKey:@"discount"];
                        [dictSubR setObject:[personRefund valueForKey:@"discount"] forKey:@"peritemdiscount"];
                    }
                    [dictSubR setObject:[personRefund valueForKey:@"time"] forKey:@"time"];
                    [dictSubR setObject:[personRefund valueForKey:@"date"] forKey:@"date"];
                    
                if ([personRefund valueForKey:@"peritemprice"] == nil)
                [dictSubR setObject:@"0" forKey:@"peritemdiscount"];
                    else
                    [dictSubR setObject:[personRefund valueForKey:@"peritemprice"] forKey:@"peritemprice"];
                
                    [arr_sub addObject:dictSubR];
                
            }
            
            NSMutableArray *arr_subFinal=[NSMutableArray new];
            
            for (int i=0; i<[arr_sub count]; i++) {
                
                int str_prev;
                int str_next;
                
                int int_pre;
                
                
                if ([arr_sub count]>=2){
                    
//                    if (i==0) {
//                        str_prev =[[[arr_sub objectAtIndex:i] valueForKey:@"rid"] intValue];
//                        str_next =[[[arr_sub objectAtIndex:i] valueForKey:@"rid"] intValue];
//                    }
//                    else
//                    {
//                        int_pre=i-1;
//                        str_prev =[[[arr_sub objectAtIndex:int_pre] valueForKey:@"rid"] intValue];
//                        str_next =[[[arr_sub objectAtIndex:i] valueForKey:@"rid"]intValue];
//                    }
                    
                    if (i==0) {
                        str_prev =[[[arr_sub objectAtIndex:i] valueForKey:@"rid"] intValue];
                        str_next =[[[arr_sub objectAtIndex:i] valueForKey:@"rid"] intValue];
                        
                        str_id=[[arr_sub objectAtIndex:i] valueForKey:@"id"];
                        str_price=[[arr_sub objectAtIndex:i] valueForKey:@"totalAmount"];
                        str_code=[[arr_sub objectAtIndex:i] valueForKey:@"code"];
                        str_vat=[[arr_sub objectAtIndex:i] valueForKey:@"vat"];
                    }
                    else
                    {
                        int_pre=i-1;
                        str_prev =[[[arr_sub objectAtIndex:int_pre] valueForKey:@"rid"] intValue];
                        str_next =[[[arr_sub objectAtIndex:i] valueForKey:@"rid"]intValue];
                        
                        str_id=[[arr_sub objectAtIndex:int_pre] valueForKey:@"id"];
                        str_price=[[arr_sub objectAtIndex:int_pre] valueForKey:@"totalAmount"];
                        str_code=[[arr_sub objectAtIndex:int_pre] valueForKey:@"code"];
                        str_vat=[[arr_sub objectAtIndex:int_pre] valueForKey:@"vat"];
                        
                    }
                    
                    
                
                    
                    if (str_prev!=str_next) {
                        
                        NSMutableDictionary *dictSubb1 = [NSMutableDictionary new];
                        [dictSubb1 setObject:str_id forKey:@"id"];
                        [dictSubb1 setObject:str_price forKey:@"tprice"];
                        [dictSubb1 setObject:str_code forKey:@"code"];
                        [dictSubb1 setObject:arr_subFinal forKey:@"sub"];
                        [dictSubb1 setObject:str_vat forKey:@"totalvat"];
                        
                        //                [arraySubb addObject:dictSubb];
                        
                        [arraySub insertObject:dictSubb1 atIndex:0];
                        
                        arr_subFinal=[NSMutableArray new];
                        [arr_subFinal addObject:[arr_sub objectAtIndex:i]];
                        
                        
                        if (i==[arr_sub count]-1) {
                            
                            str_id=[[arr_sub objectAtIndex:i] valueForKey:@"id"];
                            str_price=[[arr_sub objectAtIndex:i] valueForKey:@"totalAmount"];
                            str_code=[[arr_sub objectAtIndex:i] valueForKey:@"code"];
                            str_vat=[[arr_sub objectAtIndex:i] valueForKey:@"vat"];
                            
                            NSMutableDictionary *dictSubb1 = [NSMutableDictionary new];
                            [dictSubb1 setObject:str_id forKey:@"id"];
                            [dictSubb1 setObject:str_price forKey:@"tprice"];
                            [dictSubb1 setObject:str_code forKey:@"code"];
                            [dictSubb1 setObject:arr_subFinal forKey:@"sub"];
                            [dictSubb1 setObject:str_vat forKey:@"totalvat"];
                            
                            //                [arraySubb addObject:dictSubb];
                            
                            [arraySub insertObject:dictSubb1 atIndex:0];
                            
                            arr_subFinal=[NSMutableArray new];
                            
                        }
                        
                    }
                    else
                    {
                        [arr_subFinal addObject:[arr_sub objectAtIndex:i]];
                        
                        if (i==[arr_sub count]-1) {
                            
                            NSMutableDictionary *dictSubb1 = [NSMutableDictionary new];
                            [dictSubb1 setObject:str_id forKey:@"id"];
                            [dictSubb1 setObject:str_price forKey:@"tprice"];
                            [dictSubb1 setObject:str_code forKey:@"code"];
                            [dictSubb1 setObject:arr_subFinal forKey:@"sub"];
                            [dictSubb1 setObject:str_vat forKey:@"totalvat"];
                            
                            //                [arraySubb addObject:dictSubb];
                            
                            [arraySub insertObject:dictSubb1 atIndex:0];
                            
                            arr_subFinal=[NSMutableArray new];
                            
                        }
                    }
                    
                    
                }
                else
                {
                    NSMutableDictionary *dictSubb1 = [NSMutableDictionary new];
                    [dictSubb1 setObject:str_id forKey:@"id"];
                    [dictSubb1 setObject:str_price forKey:@"tprice"];
                    [dictSubb1 setObject:str_code forKey:@"code"];
                    [dictSubb1 setObject:arr_sub forKey:@"sub"];
                    [dictSubb1 setObject:str_vat forKey:@"totalvat"];
                    
                    //                [arraySubb addObject:dictSubb];
                    
                    [arraySub insertObject:dictSubb1 atIndex:0];
                    
                    arr_sub=[NSMutableArray new];
                }
      
            }
            
            NSArray *sortedArray = [arraySub sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *a, NSDictionary *b)
                                    {
                                        NSString *valueA = [[[a valueForKey:@"sub"] objectAtIndex:0] valueForKey:@"time"];
                                        NSString *valueB = [[[b valueForKey:@"sub"] objectAtIndex:0] valueForKey:@"time"];
                                        
                                        return [valueB compare:valueA];
                                    }];
            
            
            arraySub = [NSMutableArray arrayWithArray:sortedArray];

            
            
            NSMutableDictionary *dictMain = [NSMutableDictionary new];
            [dictMain setObject:cuDate forKey:@"date"];
            [dictMain setObject:arraySub forKey:@"main"];
            [arrayMain addObject:dictMain];
            
            arraySub = [NSMutableArray new];
            cuDate = newDateString;
        }
        
        
        
        
//        total = ([[person valueForKey:@"price"] floatValue] * [[person valueForKey:@"count"] integerValue]);
        
        float discountperproduct;
        
        if([[person valueForKey:@"discountType"] isEqualToString:@"%"]|| [person valueForKey:@"discountType"] == nil)
        {
            discountperproduct=([[person valueForKey:@"price"]floatValue]*[[person valueForKey:@"count"]intValue]*[[person valueForKey:@"discount"]floatValue])/100;
        }
        else
        {
            discountperproduct=[[person valueForKey:@"discount"]floatValue];
        }
        
        total=(([[person valueForKey:@"price"] floatValue] *[[person valueForKey:@"count"] integerValue])-discountperproduct);
        
         tpricewithoutvat = (([[person valueForKey:@"price"] floatValue]*[[person valueForKey:@"count"] integerValue])-discountperproduct) / (1 + [[person valueForKey:@"vat"] floatValue]/100) + tpricewithoutvat;

        
        zzzz = (([[person valueForKey:@"price"] floatValue]*[[person valueForKey:@"count"] integerValue])-discountperproduct) / (1 + [[person valueForKey:@"vat"] floatValue]/100);

        
        
        zzzz=(([[person valueForKey:@"price"] floatValue] *[[person valueForKey:@"count"] integerValue])-discountperproduct)-zzzz;
        
//        zzzz=total-zzzz;
        
        totalvat = zzzz + totalvat;
        
        
//        tpricewithoutvat = (([[person valueForKey:@"price"] floatValue]*[[person valueForKey:@"count"] integerValue])-[[person valueForKey:@"discount"]floatValue]) / (1 + [[person valueForKey:@"vat"] floatValue]/100) + tpricewithoutvat;
        
        
        
        
        tprice = tprice + total;
        
        NSString *str_IDs=[NSString stringWithFormat:@"%@",[person valueForKey:@"id"]];
        
        if ([str_IDs hasPrefix:@","])
        {
            str_IDs = [str_IDs substringFromIndex:1];
        }
        
        float_Discount = [self GetDiscountList:str_IDs];
        
        total=total-float_Discount;
        
        [dictSub setObject:[NSString stringWithFormat:@"%ld", (long)total] forKey:@"price"];
        
        [dictSub setObject:[person valueForKey:@"paymentMethod"] forKey:@"paymentMethod"];

        
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
        
        appDelegate =
        [[UIApplication sharedApplication] delegate];
        
        NSManagedObjectContext *context =
        [appDelegate managedObjectContext];
        
        NSEntityDescription *entityDesc =
        [NSEntityDescription entityForName:@"RefundAmount"
                    inManagedObjectContext:context];
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entityDesc];
        
        NSPredicate *pred =
        [NSPredicate predicateWithFormat:@"(date = %@)",cuDate];
        [request setPredicate:pred];
        //    NSManagedObject *matches = nil;
        
        NSError *error;
        NSArray *objects = [context executeFetchRequest:request
                                                  error:&error];
       
        NSMutableDictionary  *dictSubR;
        
        NSMutableArray *arr_sub=[NSMutableArray new];
        NSManagedObject *personRefund;
        
        NSString *str_id;
        NSString *str_price;
        NSString *str_code;
        NSString *str_vat;
        
        
        int index = -1;
        
        for (personRefund in objects)
        {
            //        get error here

                index = [[personRefund valueForKey:@"rid"]intValue];
                
                dictSubR = [NSMutableDictionary new];
                
            //Anu: crashing issue 21June2016
                str_id=[personRefund valueForKey:@"id"];
            
                if ([personRefund valueForKey:@"totalAmount"] == nil)
                    str_price=@"0";
                    else
                        str_price=[personRefund valueForKey:@"totalAmount"];
            
                if ([personRefund valueForKey:@"code"] == nil)
                    str_price=@"";
                else
                str_code=[personRefund valueForKey:@"code"];
            
            if ([personRefund valueForKey:@"vat"] == nil)
                str_vat=@"0";
            else
                str_vat=[personRefund valueForKey:@"vat"];
            
                [dictSubR setObject:[personRefund valueForKey:@"mailStatus"] forKey:@"mailStatus"];
                [dictSubR setObject:[personRefund valueForKey:@"printStatus"] forKey:@"printStatus"];
               // [dictSubR setObject:[personRefund valueForKey:@"paymentMethod"] forKey:@"printStatus"];

            //Anu:21June2016
                //[dictSubR setObject:[personRefund valueForKey:@"totalAmount"] forKey:@"totalAmount"];
            
            if ([str_price isEqual:[NSNull null]]|| str_price == nil)
                [dictSubR setObject:@"0" forKey:@"totalAmount"];
            else
                [dictSubR setObject:str_price forKey:@"totalAmount"];
            
                [dictSubR setObject:[personRefund valueForKey:@"price"] forKey:@"price"];
                [dictSubR setObject:[personRefund valueForKey:@"refundDate"] forKey:@"refundDate"];
            //Anu:21June2016
                if ([personRefund valueForKey:@"vat"] == nil)
                 [dictSubR setObject:@"0" forKey:@"vat"];
                else
                [dictSubR setObject:[personRefund valueForKey:@"vat"] forKey:@"vat"];
           
            if ([personRefund valueForKey:@"id"] == nil)
                [dictSubR setObject:@"" forKey:@"id"];
            else
                [dictSubR setObject:[personRefund valueForKey:@"id"] forKey:@"id"];
            
                [dictSubR setObject:[personRefund valueForKey:@"code"] forKey:@"code"];
                [dictSubR setObject:[personRefund valueForKey:@"rid"] forKey:@"rid"];
            
            if ([personRefund valueForKey:@"type"] == nil)
                {
                [dictSubR setObject:@"$" forKey:@"type"];
                }
                else
                {
                [dictSubR setObject:[personRefund valueForKey:@"type"] forKey:@"type"];
                }
                [dictSubR setObject:[personRefund valueForKey:@"currency"] forKey:@"currency"];
                [dictSubR setObject:[personRefund valueForKey:@"count"] forKey:@"count"];
                [dictSubR setObject:[personRefund valueForKey:@"discription"] forKey:@"discription"];
                [dictSubR setObject:@"" forKey:@"image"];
                [dictSubR setObject:[personRefund valueForKey:@"name"] forKey:@"name"];
                
                if ([personRefund valueForKey:@"discount"] == nil)
                {
                    [dictSubR setObject:@"0" forKey:@"discount"];
                    [dictSubR setObject:@"0" forKey:@"peritemdiscount"];
                }
                else
                {
                    [dictSubR setObject:[personRefund valueForKey:@"discount"] forKey:@"discount"];
                    [dictSubR setObject:[personRefund valueForKey:@"discount"] forKey:@"peritemdiscount"];
                }
                [dictSubR setObject:[personRefund valueForKey:@"time"] forKey:@"time"];
                [dictSubR setObject:[personRefund valueForKey:@"date"] forKey:@"date"];
                
            if ([personRefund valueForKey:@"peritemprice"] == nil)
                [dictSubR setObject:@"0" forKey:@"peritemprice"];
            else
                [dictSubR setObject:[personRefund valueForKey:@"peritemprice"] forKey:@"peritemprice"];
            
                if([personRefund valueForKey:@"paymentMethod"]!=nil)
                [dictSubR setObject:[personRefund valueForKey:@"paymentMethod"] forKey:@"paymentMethod"];

                [arr_sub addObject:dictSubR];
                
            
            
            
            }
        
        
        NSMutableArray *arr_subFinal=[NSMutableArray new];
        
        for (int i=0; i<[arr_sub count]; i++) {
            
            int str_prev;
            int str_next;
            
            int int_pre;
            
            
            if ([arr_sub count]>=2) {
                
                if (i==0) {
                    str_prev =[[[arr_sub objectAtIndex:i] valueForKey:@"rid"] intValue];
                    str_next =[[[arr_sub objectAtIndex:i] valueForKey:@"rid"] intValue];
                    
                    str_id=[[arr_sub objectAtIndex:i] valueForKey:@"id"];
                    str_price=[[arr_sub objectAtIndex:i] valueForKey:@"totalAmount"];
                    str_code=[[arr_sub objectAtIndex:i] valueForKey:@"code"];
                    str_vat=[[arr_sub objectAtIndex:i] valueForKey:@"vat"];
                }
                else
                {
                    int_pre=i-1;
                    str_prev =[[[arr_sub objectAtIndex:int_pre] valueForKey:@"rid"] intValue];
                    str_next =[[[arr_sub objectAtIndex:i] valueForKey:@"rid"]intValue];
                    
                    str_id=[[arr_sub objectAtIndex:int_pre] valueForKey:@"id"];
                    str_price=[[arr_sub objectAtIndex:int_pre] valueForKey:@"totalAmount"];
                    str_code=[[arr_sub objectAtIndex:int_pre] valueForKey:@"code"];
                    str_vat=[[arr_sub objectAtIndex:int_pre] valueForKey:@"vat"];
                    
                }
                
                if (str_prev!=str_next) {
                    
                    NSMutableDictionary *dictSubb1 = [NSMutableDictionary new];
                    [dictSubb1 setObject:str_id forKey:@"id"];
                    [dictSubb1 setObject:str_price forKey:@"tprice"];
                    [dictSubb1 setObject:str_code forKey:@"code"];
                    [dictSubb1 setObject:arr_subFinal forKey:@"sub"];
                    [dictSubb1 setObject:str_vat forKey:@"totalvat"];
                    
                    //                [arraySubb addObject:dictSubb];
                    
                    [arraySub insertObject:dictSubb1 atIndex:0];
                    
                     arr_subFinal=[NSMutableArray new];
                    [arr_subFinal addObject:[arr_sub objectAtIndex:i]];
                    
                    if (i==[arr_sub count]-1) {
                        
                        
                        str_id=[[arr_sub objectAtIndex:i] valueForKey:@"id"];
                        str_price=[[arr_sub objectAtIndex:i] valueForKey:@"totalAmount"];
                        str_code=[[arr_sub objectAtIndex:i] valueForKey:@"code"];
                        str_vat=[[arr_sub objectAtIndex:i] valueForKey:@"vat"];
                        
                        
                        NSMutableDictionary *dictSubb1 = [NSMutableDictionary new];
                        [dictSubb1 setObject:str_id forKey:@"id"];
                        [dictSubb1 setObject:str_price forKey:@"tprice"];
                        [dictSubb1 setObject:str_code forKey:@"code"];
                        [dictSubb1 setObject:arr_subFinal forKey:@"sub"];
                        [dictSubb1 setObject:str_vat forKey:@"totalvat"];
                        
                        //                [arraySubb addObject:dictSubb];
                        
                        [arraySub insertObject:dictSubb1 atIndex:0];
                        
                        arr_subFinal=[NSMutableArray new];
                        
                    }
                    
                }
                else
                {
                    [arr_subFinal addObject:[arr_sub objectAtIndex:i]];
                    
                    if (i==[arr_sub count]-1) {
                        
                        NSMutableDictionary *dictSubb1 = [NSMutableDictionary new];
                        [dictSubb1 setObject:str_id forKey:@"id"];
                        [dictSubb1 setObject:str_price forKey:@"tprice"];
                        [dictSubb1 setObject:str_code forKey:@"code"];
                        [dictSubb1 setObject:arr_subFinal forKey:@"sub"];
                        [dictSubb1 setObject:str_vat forKey:@"totalvat"];
                        
                        //                [arraySubb addObject:dictSubb];
                        
                        [arraySub insertObject:dictSubb1 atIndex:0];
                        
                        arr_subFinal=[NSMutableArray new];
                        
                    }
                }
                
            }
            else
            {
                NSMutableDictionary *dictSubb1 = [NSMutableDictionary new];
                [dictSubb1 setObject:str_id forKey:@"id"];
                [dictSubb1 setObject:str_price forKey:@"tprice"];
                [dictSubb1 setObject:str_code forKey:@"code"];
                [dictSubb1 setObject:arr_sub forKey:@"sub"];
                [dictSubb1 setObject:str_vat forKey:@"totalvat"];
                
                //                [arraySubb addObject:dictSubb];
                
                [arraySub insertObject:dictSubb1 atIndex:0];
                
                arr_sub=[NSMutableArray new];
            }
            
            
        }
        

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

        [arraySub addObject:dictSubb];
     
        
        NSArray *sortedArray = [arraySub sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *a, NSDictionary *b)
                                {
                                    NSString *valueA = [[[a valueForKey:@"sub"] objectAtIndex:0] valueForKey:@"time"];
                                    NSString *valueB = [[[b valueForKey:@"sub"] objectAtIndex:0] valueForKey:@"time"];
                                    
                                    return [valueB compare:valueA];
                                }];
        
        
        arraySub = [NSMutableArray arrayWithArray:sortedArray];
        
        NSMutableDictionary *dictMain = [NSMutableDictionary new];
        [dictMain setObject:cuDate forKey:@"date"];
        [dictMain setObject:arraySub forKey:@"main"];
        [dictMain setObject:@"Yes" forKey:@"IsRepurchase"];
        

        [arrayMain addObject:dictMain];
        
        
        appDelegate.reciptArray=arrayMain;
        dictAllItems = arrayMain;
        
        if (bool_RegisterSale)
        {
            NSMutableArray *ary_Selected = [NSMutableArray new];
            NSMutableDictionary *dictMain1 = [NSMutableDictionary new];
            
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
                
                [dictMain1 setObject:[person valueForKey:@"discription"] forKey:@"DiscountComment"];
            }
            else
            {
                [dictMain1 setObject:@"" forKey:@"DiscountComment"];
            }

            NSMutableArray * arrayItems;
            
            if(filterdone)
            {
                if ([array_SearchData count]>0)
                    arrayItems = [[[array_SearchData objectAtIndex:selectedSection] objectForKey:@"main"] objectAtIndex:selectedRow];
            }
            else
            {
                if ([dictAllItems count]>0)
                    arrayItems = [[[dictAllItems objectAtIndex:selectedSection] objectForKey:@"main"] objectAtIndex:selectedRow];
            }
            
            
            [dictMain1 setObject:arraySub forKey:@"main"];
            [dictMain1 setObject:@"YES" forKey:@"IsRepurchase"];
            
            [ary_Selected addObject:dictMain1];
            
            ISUPosSoapService *service = [[ISUPosSoapService alloc] init];
            
            [service PostRegisterSale:self action:nil ary:ary_Selected];
        }
        
        bool_RegisterSale = NO;
        
        if(isPrintTran==NO)
        {
        selectedSection=0;
        selectedRow=0;
        }
        
        [self setMiddlePart];

        
    }
    else
    {
        float_TotalPrice = 0.0;
        labelTotalAmount.text = [NSString stringWithFormat:@"%@ 0.00", currencySign];
        labelVat.text = [NSString stringWithFormat:@"%@ 0.00", currencySign];
    }

    
    
    [tableViewItems reloadData];
    
    [tablev reloadData];
}

-(float)GetDiscountList:(NSString *)IDs
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context =[appDelegate managedObjectContext];
    
    
    NSEntityDescription *entityDesc2 =[NSEntityDescription entityForName:@"CustomDiscount" inManagedObjectContext:context];
    NSFetchRequest *request11 = [[NSFetchRequest alloc] init];
    [request11 setEntity:entityDesc2];
    NSError *error2;
    NSArray *objects2 = [context executeFetchRequest:request11 error:&error2];
    
    NSManagedObject *person2;
    
    float sumnew=0.0;
    
    for(int i=0;i<objects2.count;i++)
    {
        
        NSArray* ary_ID = [IDs componentsSeparatedByString: @","];
        
        
        str_DiscountType = @"$";
        
        
        if ([ary_ID count]>0)
        {
            if ([ary_ID containsObject:[NSString stringWithFormat:@"%@",[[objects2 objectAtIndex:i] valueForKey:@"id"]]])
            {
                person2 = (NSManagedObject *)[objects2 objectAtIndex:i];
                
                sumnew = [[person2 valueForKey:@"discount"] floatValue]+sumnew;
                
            }
        }
        
    }
    
    return sumnew;
}


-(void)toDismissThePopover
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
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
    
    [self Settitles];
    
    [self getAllTrasection];
    
    [popover dismissPopoverAnimated:YES];
}
-(void)isRefund:(NSString *)Id
{
    appDelegate =
    [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context =
    [appDelegate managedObjectContext];
    
    NSEntityDescription *entityDesc =
    [NSEntityDescription entityForName:@"Trasections"
                inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
    NSPredicate *pred =
    [NSPredicate predicateWithFormat:@"(id = %d)", [Id intValue]];
    
    
    [request setPredicate:pred];
    //    NSManagedObject *matches = nil;
    
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request
                                              error:&error];
    
    if ([objects count] == 0) {
        
        buttonRefundAmount.hidden=NO;
        
        labelRefundedAmount.hidden = YES;
        
    } else
    {
        NSManagedObject *mana = (NSManagedObject *) [objects objectAtIndex:0];
        
        if ([[mana valueForKey:@"isrefund"] boolValue])
        {
            buttonRefundAmount.hidden=YES;
            
            if (labelRefundedAmount.text.length == 0)
            {
                labelRefundedAmount.hidden = YES;
            }
            else
                labelRefundedAmount.hidden = NO;
        }
        else
        {
            buttonRefundAmount.hidden=NO;
            
            labelRefundedAmount.hidden = YES;
        }
        
    }
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
                    
                    [[NSUserDefaults standardUserDefaults] setObject:@"Tran" forKey:@"MailType"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    NSString *email = txt_Email.text;
                    [[NSUserDefaults standardUserDefaults] setObject:email forKey:@"EMAIL"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    [[AppDelegate delegate] sendMailWithSubject:[NSString stringWithFormat:@"%@", [Language get:@"Receipt" alter:@"!Receipt"]]  sendFrom:@"" ToReciepents:@"" messageHtmlBodyContent:@""];
                    
                    
                    
                    if (isRefundTran==NO) {
                        
                        [self editTransactionForMailStatus:[[[[dictAllItems objectAtIndex:selectedSection] objectForKey:@"main"] objectAtIndex:selectedRow] valueForKey:@"id"]];
                        
                        [appDelegate PrintAndMailCountUpdate:3 amount:float_TotalPrice];
                    }
                    else
                    {
                        [self editRefundForMailStatus:[[[[dictAllItems objectAtIndex:selectedSection] objectForKey:@"main"] objectAtIndex:selectedRow] valueForKey:@"id"]];
                    }
                    
                    
                    view_EmailPopUpBg.hidden = YES;
                    
                }
                else {
                    
                    [[[UIAlertView alloc] initWithTitle:@"ISUPOS" message:[Language get:@"Please check your internet connection." alter:@"!Please check your internet connection."] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                }
                
            }
            
        }
        
    }
    else if (sender == btn_EmailCancel)
    {
        view_EmailPopUpBg.hidden = YES;
    }
}

#pragma mark - UISearchBar Delegates

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)string
{
    
    labelFooterDate.hidden = NO;

    string=[string lowercaseString];
    
    if (![string isEqualToString:@"0"] && ![string isEqualToString:@"00"]) {
        
        
        if([string isEqualToString:@""])
        {
            filterdone=NO;
        }
        else
        {
            filterdone=YES;
        }
        
        
        NSMutableArray * newMain = [[NSMutableArray alloc] init];
        int flag = 0;
        
        
        for (NSDictionary *dict in dictAllItems)
        {
            
            NSMutableArray *arr = [dict objectForKey:@"main"];
            flag = 0;
            
            NSMutableArray *newArr = [[NSMutableArray alloc]init];
            
            for (NSDictionary *dictIn in arr)
            {
                
                float sumTotal = [[[[dictIn valueForKey:@"sub"] objectAtIndex:0] valueForKey:@"totalAmount"]floatValue];
                
                if (sumTotal >= -1)
                    sumTotal = [[dictIn valueForKey:@"tprice"] floatValue]-[[[[dictIn valueForKey:@"sub"] objectAtIndex:0] valueForKey:@"discount"]floatValue];
                
                
                NSString *riid=[NSString stringWithFormat:@"%d",[[[[dictIn valueForKey:@"sub"] objectAtIndex:0] valueForKey:@"id"]intValue] ];
                NSString *str = [NSString stringWithFormat:@"%.2f",sumTotal];
                
                //            if([str rangeOfString:string].location != NSNotFound  || [riid rangeOfString:string].location != NSNotFound)
                if([str rangeOfString:string].location != NSNotFound)
                {
                    [newArr addObject:dictIn];
                    flag = 1;
                }
                
                
            }
            
            
            if(flag==1)
            {
                NSMutableDictionary *dictTemp = [[NSMutableDictionary alloc]initWithDictionary:dict];
                
                [dictTemp setValue:newArr forKey:@"main"];
                [newMain addObject:dictTemp];
            }
            
        }
        
        array_SearchData = newMain;
        
        [tablev reloadData];
        //[self setMiddlePart];
        
    }
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    if([array_SearchData count] == 0 && filterdone)
    {
        filterdone = NO;
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"ISUPOS" message:[Language get:@"No Results Found." alter:@"!No Results Found."]  delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        alert.tag = 119;
        [alert show];
        labelFooterDate.hidden = YES;
        [searchBarTest resignFirstResponder];
        [self.view endEditing:YES];
     
        
    }

}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if([array_SearchData count] == 0 && filterdone)
    {
        filterdone = NO;
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"ISUPOS" message:[Language get:@"No Results Found." alter:@"!No Results Found."]  delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        alert.tag = 120;
        [alert show];
        labelFooterDate.hidden = YES;
        [searchBarTest resignFirstResponder];
        [self.view endEditing:YES];
        
    }

}



#pragma mark - UITableView Datasource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    

    if (tableView == tablev)
    {
        if(filterdone)
        {
            if ([array_SearchData count]>0) {
                
                return [[[array_SearchData objectAtIndex:section] objectForKey:@"main"] count];

            }
        }
        else
        {
            if ([dictAllItems count]>0) {
                return [[[dictAllItems objectAtIndex:section] objectForKey:@"main"] count];
            }
        }
    }
    else if (tableView == tbl_EmailList)
    {
       return [ary_EmailList count];
    }
    else
    {
        
        
        if(filterdone)
        {
            if ([array_SearchData count]>0) {
                
                return [[[[[array_SearchData objectAtIndex:selectedSection] objectForKey:@"main"] objectAtIndex:selectedRow] valueForKey:@"sub"] count];
            }
            
        }
        else
        {
            if ([dictAllItems count]>0) {
                return [[[[[dictAllItems objectAtIndex:selectedSection] objectForKey:@"main"] objectAtIndex:selectedRow] valueForKey:@"sub"] count];
            }
        }

    }
    
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // return temparray.count;
    if (tableView == tablev)
    {
        if(filterdone)
        {
            
            return [array_SearchData count];
            
        }
        else
        {
           //return 1000;
           return [dictAllItems count];
        }
    }
    return 1;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == tablev)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(5, 0, tableView.frame.size.width+100, 38)];
        // Create custom view to display section header...
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, tableView.frame.size.width+100, 38)];
        label.textAlignment=NSTextAlignmentLeft;
        [label setFont:[UIFont boldSystemFontOfSize:18]];
        [label setTextColor:[UIColor colorWithRed:91.0f/255.0f green:41.0f/255.0f blue:117.0f/255.0f alpha:1.0f]];
        //   Section header is in 0th index...
        
        NSMutableDictionary *dict;
        
        if(filterdone)
        {
            dict = [array_SearchData objectAtIndex:section];
            
        }
        else
        {
            dict = [dictAllItems objectAtIndex:section];
        }
        
        
//        label.text = [dict objectForKey:@"date"];
        
        
        NSString *stringDateTime;
        
        if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"time_format"] isEqualToString:@"12"])
        {
            
            stringDateTime = [dict objectForKey:@"date"];
            
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
            
                [dateFormatter setDateFormat:@"dd MMMM yyyy"];

            NSDate *date_get=[dateFormatter dateFromString:stringDateTime];
            
            //        NSDate *currDate = [NSDate date];
            
            NSDate *currDate = date_get;
            
                        NSString *str_timeZone=nil;
            
                        if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"language"]isEqualToString:@"EN"]) {
            
                            str_timeZone=@"GMT";
                        }
                        else
                        {
                            str_timeZone=@"CET";
                        }
            
            //            [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:str_timeZone]];
            
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
            
            NSString *dateString=[NSString stringWithFormat:@"%@ %@",str_month,str_year];
            
            //        [dateFormatter setDateFormat:@"dd-MMMM-yyyy hh:mm:ss a"];
            //         NSString *dateString = [dateFormatter stringFromDate:currDate];
            
//            if([str_datefrom isEqualToString:@"Month"])
//            {
//                dateString=[NSString stringWithFormat:@"%@",str_year];
//            }
//            else
//            {
                dateString=[NSString stringWithFormat:@"%@ %@ %@",str_day,str_month,str_year];
//            }
            
            
            label.text = dateString;
            
        }
        else{
            
            stringDateTime = [dict objectForKey:@"date"];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
//            if([str_datefrom isEqualToString:@"Month"])
//            {
//                [dateFormatter setDateFormat:@"yyyy"];
//            }
//            else
//            {
                [dateFormatter setDateFormat:@"dd MMMM yyyy"];
//            }
            
            NSDate *date_get=[dateFormatter dateFromString:stringDateTime];
            
            //        NSDate *currDate = [NSDate date];
            
            NSDate *currDate = date_get;
            
            
                        NSString *str_timeZone=nil;
            
                        if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"language"]isEqualToString:@"EN"]) {
            
                            str_timeZone=@"GMT";
                        }
                        else
                        {
                            str_timeZone=@"CET";
                        }
            
            //            [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:str_timeZone]];
            
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
            
            
            
            NSString *dateString;
            
//            if([str_datefrom isEqualToString:@"Month"])
//            {
//                dateString=[NSString stringWithFormat:@"%@",str_year];
//            }
//            else
//            {
                dateString=[NSString stringWithFormat:@"%@ %@ %@",str_day, str_month,str_year];
//            }
            
            label.text = dateString;
            
        }
        
  
        [view addSubview:label];
        [view setBackgroundColor:[UIColor colorWithRed:234.0f/255.0f green:234.0f/255.0f blue:234.0f/255.0f alpha:1.0f]]; //your background color...
        
        return view;
    }
    
    return NO;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tablev)
    {
        NSMutableDictionary *dicSub;
        
        if(filterdone)
        {
            
            dicSub =[[[array_SearchData objectAtIndex:indexPath.section] objectForKey:@"main"] objectAtIndex:indexPath.row];
//            dicSub =[[[array_SearchData objectAtIndex:selectedSection] objectForKey:@"main"] objectAtIndex:indexPath.row];
            
        }
        else
        {
            dicSub =[[[dictAllItems objectAtIndex:indexPath.section] objectForKey:@"main"] objectAtIndex:indexPath.row];
        }
        
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        }
        
        UIFont * myFont = [UIFont fontWithName:@"Arial" size:15];
        CGRect labelFrame = CGRectMake (cell.frame.size.width-100, 10, 120, 25);
        UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
        [label setFont:myFont];
        //    label.lineBreakMode=NSLineBreakByWordWrapping;
        label.numberOfLines=5;
        label.textColor=[UIColor grayColor];
        //label.backgroundColor=[UIColor yellowColor];
        
        
        NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc]init];
        [dateFormatter1 setDateFormat:@"hh:mm:ss a"];
        NSDate *dateString1 = [dateFormatter1 dateFromString:[[[dicSub valueForKey:@"sub"] objectAtIndex:0] valueForKey:@"time"]];
        
        [dateFormatter1 setDateFormat:@"hh:mm a"];
        
        [label setText:[NSString stringWithFormat:@"%@", [dateFormatter1 stringFromDate:dateString1]]];
        
     
        
        [cell addSubview:label];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake (10, 10, 100, 25)];
        [label1 setFont:myFont];
        label1.textAlignment=NSTextAlignmentLeft;
        label1.textColor=[UIColor grayColor];
        label1.backgroundColor=[UIColor clearColor];
    
        
        
        currencySign = [[[dicSub valueForKey:@"sub"] objectAtIndex:0] valueForKey:@"currency"];
        
        float sumTotal = 0;
        
        sumTotal = [[[[dicSub valueForKey:@"sub"] objectAtIndex:0] valueForKey:@"totalAmount"]floatValue];
        
        if (sumTotal < -1)
        {
            label1.textColor = [UIColor redColor];
            
            NSString *str = [NSString stringWithFormat:@"%.02f", sumTotal];
            
            str = [str stringByReplacingOccurrencesOfString:@"-" withString:@""];
            
            [label1 setText:[NSString stringWithFormat:@"-%@ %@", currencySign, str]];
        }
        else
        {
            label1.textColor = [UIColor darkGrayColor];
            
            [label1 setText:[NSString stringWithFormat:@"%@ %.2f",currencySign, [[dicSub valueForKey:@"tprice"] floatValue]]];
        }
        

        
        [cell addSubview:label1];
        
        return cell;
    }
    else if (tableView == tbl_EmailList)
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
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
        
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        }
        NSMutableDictionary *dicSub;

        if(filterdone)
        {
            
            dicSub =[[[array_SearchData objectAtIndex:selectedSection] objectForKey:@"main"] objectAtIndex:selectedRow];
            
        }
        else
        {
            dicSub =[[[dictAllItems objectAtIndex:selectedSection] objectForKey:@"main"] objectAtIndex:selectedRow];
        }
 
        if (indexPath.row == [[dicSub valueForKey:@"sub"] count])
        {
            UIFont * myFont = [UIFont fontWithName:@"Arial" size:15];
            
            UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake (10, 10, 200, 25)];
            [label1 setFont:myFont];
            label1.textAlignment=NSTextAlignmentLeft;
            label1.textColor=[UIColor grayColor];
            label1.backgroundColor=[UIColor clearColor];
            
            
            CGRect labelFrame = CGRectMake (440, 10, 100, 25);
            UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
            [label setFont:myFont];
            //    label.lineBreakMode=NSLineBreakByWordWrapping;
            label.numberOfLines=5;
            label.textColor=[UIColor grayColor];
            //label.backgroundColor=[UIColor yellowColor];
            
            if ([[[[dicSub valueForKey:@"sub"] objectAtIndex:0] valueForKey:@"discount"]floatValue] == 0)
            {
                [label1 setText:@""];
                [label setText:@""];
            }
            else
            {
                [label1 setText:@"Custom Discount"];
                [label setText:[NSString stringWithFormat:@"-%@ %.02f",currencySign, [[[[dicSub valueForKey:@"sub"] objectAtIndex:0] valueForKey:@"discount"]floatValue]]];
            }
            
            [cell addSubview:label1];
            
            [cell addSubview:label];
            
        }
        else
        {
            //        static NSString *cellIdentifier = @"cell";
            
            UIFont * myFont = [UIFont fontWithName:@"Arial" size:15];
            CGRect labelFrame = CGRectMake (440, 10, 100, 25);
            UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
            [label setFont:myFont];
            //    label.lineBreakMode=NSLineBreakByWordWrapping;
            label.numberOfLines=5;
            label.textColor=[UIColor grayColor];
            //label.backgroundColor=[UIColor yellowColor];
            
        
            
            float str = [[[[dicSub valueForKey:@"sub"] objectAtIndex:indexPath.row] valueForKey:@"peritemprice"] floatValue] * [[[[dicSub valueForKey:@"sub"] objectAtIndex:indexPath.row] valueForKey:@"count"] intValue] -[[[[dicSub valueForKey:@"sub"] objectAtIndex:indexPath.row] valueForKey:@"discount1"] floatValue];
            
            [label setText:[NSString stringWithFormat:@"%@ %.02f",currencySign, str]];
            
            [cell addSubview:label];
            
            UILabel *labelQuantity = [[UILabel alloc] initWithFrame:CGRectMake (370, 10, 30, 25)];
            [labelQuantity setFont:myFont];
            labelQuantity.numberOfLines=5;
            labelQuantity.textColor=[UIColor whiteColor];
            labelQuantity.textAlignment = NSTextAlignmentCenter;
            [labelQuantity setText:[NSString stringWithFormat:@"%@", [[[dicSub valueForKey:@"sub"] objectAtIndex:indexPath.row] valueForKey:@"count"]]];
            labelQuantity.layer.cornerRadius = 10.0f;
            labelQuantity.backgroundColor = [UIColor colorWithRed:91.0f/255.0f green:41.0f/255.0f blue:117.0f/255.0f alpha:1.0f];
            labelQuantity.layer.masksToBounds = YES;
            [cell addSubview:labelQuantity];
            
            
            
            UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake (10, 10, 300, 25)];
            [label1 setFont:myFont];
            label1.textAlignment=NSTextAlignmentLeft;
            label1.textColor=[UIColor grayColor];
            label1.backgroundColor=[UIColor clearColor];
            

            
            [label1 setText:[[[dicSub valueForKey:@"sub"] objectAtIndex:indexPath.row] valueForKey:@"name"]];
            
            [cell addSubview:label1];
            
            cell.backgroundColor = [UIColor clearColor];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }
    return NO;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tbl_EmailList)
    {
        txt_Email.text = [ary_EmailList objectAtIndex:indexPath.row];
        tbl_EmailList.hidden = YES;
    }
    else
    {
        selectedRow = (int)indexPath.row;
        selectedSection = (int)indexPath.section;
        
        [self setMiddlePart];
        
        [tableViewItems reloadData];
        
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == tbl_EmailList)
    {
        return 0;
    }
    else
    {
       return 38;
    }
    
}


-(void)setMiddlePart
{
    
    NSMutableArray * arrayItems;
    
    if(filterdone)
    {
        if ([array_SearchData count]>0)
            arrayItems = [[[array_SearchData objectAtIndex:selectedSection] objectForKey:@"main"] objectAtIndex:selectedRow];
    }
    else
    {
        if ([dictAllItems count]>0)
            arrayItems = [[[dictAllItems objectAtIndex:selectedSection] objectForKey:@"main"] objectAtIndex:selectedRow];
    }
    
    appDelegate.reciptArray=arrayItems;


 
    currencySign = [[[arrayItems valueForKey:@"sub"] objectAtIndex:0] valueForKey:@"currency"];
    
    
    if ([[arrayItems valueForKey:@"sub"] count] == 1)
    {
        //        labelFirstProduct.text = [NSString stringWithFormat:@"%@", [[[arrayItems valueForKey:@"sub"] objectAtIndex:0] valueForKey:@"name"]];
        //        labelFirstProductValue.text = [NSString stringWithFormat:@"%@", [[[arrayItems valueForKey:@"sub"] objectAtIndex:0] valueForKey:@"peritemprice"]];
        //        labelFirstProductQntity.text = [NSString stringWithFormat:@"%@", [[[arrayItems valueForKey:@"sub"] objectAtIndex:0] valueForKey:@"count"]];
        //        labelSecondProduct.hidden = YES;
        //        labelSecondProductValue.hidden = YES;
        //        labelSecondProductQntity.hidden = YES;
    }
    else if ([[arrayItems valueForKey:@"sub"] count] >= 2)
    {
        //        labelFirstProduct.text = [NSString stringWithFormat:@"%@", [[[arrayItems valueForKey:@"sub"] objectAtIndex:0] valueForKey:@"name"]];
        //        labelFirstProductValue.text = [NSString stringWithFormat:@"%@", [[[arrayItems valueForKey:@"sub"] objectAtIndex:0] valueForKey:@"peritemprice"]];
        //        labelFirstProductQntity.text = [NSString stringWithFormat:@"%@", [[[arrayItems valueForKey:@"sub"] objectAtIndex:0] valueForKey:@"count"]];
        //        labelSecondProduct.hidden = NO;
        //        labelSecondProductValue.hidden = NO;
        //        labelSecondProductQntity.hidden = NO;
        //        labelSecondProduct.text = [NSString stringWithFormat:@"%@", [[[arrayItems valueForKey:@"sub"] objectAtIndex:1] valueForKey:@"name"]];
        //        labelSecondProductValue.text = [NSString stringWithFormat:@"%@", [[[arrayItems valueForKey:@"sub"] objectAtIndex:1] valueForKey:@"peritemprice"]];
        //        labelSecondProductQntity.text = [NSString stringWithFormat:@"%@", [[[arrayItems valueForKey:@"sub"] objectAtIndex:1] valueForKey:@"count"]];
    }
    else
    {
        //        labelFirstProduct.text = @"";
        //        labelFirstProductValue.text = @"";
        //        labelFirstProductQntity.hidden = YES;
        //        labelSecondProduct.text = @"";
        //        labelSecondProductValue.text = @"";
        //        labelSecondProductQntity.hidden = YES;
        //        labelTotalAmount.text = @"€ 0.00";
        //        labelVat.text = @"€ 0.00";
    }
    float sum = 0;
    
    for (NSDictionary *dict in [arrayItems valueForKey:@"sub"])
    {
        //        sum += [[dict valueForKey:@"price"] intValue] * [[dict valueForKey:@"count"] intValue];
        sum += [[dict valueForKey:@"price"] floatValue];
    }
    
    if([[[[arrayItems valueForKey:@"sub"] objectAtIndex:0] valueForKey:@"paymentMethod"] isEqualToString:@"1"])
    {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"Cash" forKey:@"payment_mode"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [btnCash setTitle:[Language get:@"Cash" alter:@"!Cash"] forState:UIControlStateNormal];

    }
    else if([[[[arrayItems valueForKey:@"sub"] objectAtIndex:0] valueForKey:@"paymentMethod"] isEqualToString:@"2"])
    {
        [btnCash setTitle:[Language get:@"Card" alter:@"!Card"] forState:UIControlStateNormal];
        [[NSUserDefaults standardUserDefaults] setObject:@"Card" forKey:@"payment_mode"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    else if([[[[arrayItems valueForKey:@"sub"] objectAtIndex:0] valueForKey:@"paymentMethod"] isEqualToString:@"3"])
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"Swish" forKey:@"payment_mode"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [btnCash setTitle:[Language get:@"Swish" alter:@"!Swish"] forState:UIControlStateNormal];
    }
    else if([[[[arrayItems valueForKey:@"sub"] objectAtIndex:0] valueForKey:@"paymentMethod"] isEqualToString:@"4"])
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"Other" forKey:@"payment_mode"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [btnCash setTitle:[Language get:@"Other" alter:@"!Other"] forState:UIControlStateNormal];
    }


    
    NSString *stringDateTime;
    
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"time_format"] isEqualToString:[Language get:@"12 Hours" alter:@"!12 Hours"]])
    {
        
        stringDateTime = [NSString stringWithFormat:@"%@, %@", [[[arrayItems valueForKey:@"sub"] valueForKey:@"date"] objectAtIndex:0], [[[arrayItems valueForKey:@"sub"] valueForKey:@"time"] objectAtIndex:0]];
        
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"dd MMMM yyyy, hh:mm:ss a"];
        
        NSDate *date_get=[dateFormatter dateFromString:stringDateTime];
        
        //        NSDate *currDate = [NSDate date];
        
        NSDate *currDate = date_get;
        
        NSString *str_timeZone=nil;
        
        if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"language"]isEqualToString:@"EN"]) {
            
            str_timeZone=@"GMT";
        }
        else
        {
            str_timeZone=@"CET";
        }
//
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
        
        NSString *dateString=[NSString stringWithFormat:@"%@-%@-%@ %@ (%@)",str_day,str_month,str_year,str_time,str_timeZone];
        
        //        [dateFormatter setDateFormat:@"dd-MMMM-yyyy hh:mm:ss a"];
        //         NSString *dateString = [dateFormatter stringFromDate:currDate];
        
        labelFooterDate.text = dateString;
    }
    
    else{
        
       
        stringDateTime = [NSString stringWithFormat:@"%@, %@", [[[arrayItems valueForKey:@"sub"] valueForKey:@"date"] objectAtIndex:0], [[[arrayItems valueForKey:@"sub"] valueForKey:@"time"] objectAtIndex:0]];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"dd MMMM yyyy, hh:mm:ss a"];
        
        NSDate *date_get=[dateFormatter dateFromString:stringDateTime];
        
        //        NSDate *currDate = [NSDate date];
        
        NSDate *currDate = date_get;
        
        
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
        
        [dateFormatter setDateFormat:@"HH:mm:ss"];
        
        NSString *str_time = [dateFormatter stringFromDate:currDate];
        
        NSString *dateString=[NSString stringWithFormat:@"%@-%@-%@ %@ (%@)",str_day,str_month,str_year,str_time,str_timeZone];
        
        
        //        [dateFormatter setDateFormat:@"dd-MMMM-yyyy HH:mm:ss"];
        //        NSString *dateString = [dateFormatter stringFromDate:currDate];
        labelFooterDate.text = dateString;
    }
    
    
    
//    --------------------------------------------------------------
    
//    if ([[[arrayItems valueForKey:@"sub"]objectAtIndex:0]valueForKey:@"discount"] != nil)
//    {
//        sum = sum - [[[[arrayItems valueForKey:@"sub"] valueForKey:@"discount"] objectAtIndex:0] floatValue];
//    }
    
    float sumTotal = 0;
    
    sumTotal = [[[[arrayItems valueForKey:@"sub"] valueForKey:@"totalAmount"] objectAtIndex:0] floatValue];
    
    if (sumTotal < -1)
    {
        isRefundTran=YES;
        
        NSString *str1 = [NSString stringWithFormat:@"%.02f", [[[[arrayItems valueForKey:@"sub"] objectAtIndex:0] valueForKey:@"totalAmount"] floatValue]];
        
        str1 = [str1 stringByReplacingOccurrencesOfString:@"-" withString:@""];
        
        float_TotalPrice = [str1 intValue];
        
        labelTotalAmount.text = [NSString stringWithFormat:@"-%@ %@",currencySign, str1];
        
        labelTotalAmount.textColor = [UIColor redColor];
        
        labelVat.text = [NSString stringWithFormat:@"%@: -%@ %.02f",[Language get:@"VAT" alter:@"!VAT"], currencySign, [[[[arrayItems valueForKey:@"sub"] objectAtIndex:0] valueForKey:@"vat"] floatValue]];
        
        tableViewItems.hidden = YES;
        
        buttonViewOriginal.hidden = NO;
        
        labelRefundedAmount.hidden = NO;
        
        NSString *str = [NSString stringWithFormat:@"%.02f", [[[[arrayItems valueForKey:@"sub"] objectAtIndex:0] valueForKey:@"totalAmount"] floatValue]];
        
        str = [str stringByReplacingOccurrencesOfString:@"-" withString:@""];
        
        labelRefundedAmount.text = [NSString stringWithFormat:@"Refunded %@\n-%@ %@", stringDateTime,currencySign, str];
    }
    else
    {
        
        isRefundTran=NO;
        
        labelTotalAmount.textColor = [UIColor darkGrayColor];
        
        float_TotalPrice = [[arrayItems valueForKey:@"tprice"] floatValue];
//        labelTotalAmount.text = [NSString stringWithFormat:@"%@ %.02f", currencySign, sum];
        
        labelTotalAmount.text = [NSString stringWithFormat:@"%@ %.02f", currencySign, [[arrayItems valueForKey:@"tprice"] floatValue]];
        
        labelRefundedAmount.text = [NSString stringWithFormat:@"Refunded %@\n-%@ %.02f", stringDateTime,currencySign, [[arrayItems valueForKey:@"tprice"] floatValue]];
        
        labelVat.text = [NSString stringWithFormat:@"%@: %@ %.02f",[Language get:@"VAT" alter:@"!VAT"], currencySign, [[arrayItems valueForKey:@"totalvat"] floatValue]];
        
        tableViewItems.hidden = NO;
        
        buttonViewOriginal.hidden = YES;
        
        labelRefundedAmount.hidden = YES;
        
    }
    
    labelTotalAmount.tag = [[[[arrayItems valueForKey:@"sub"] objectAtIndex:0] valueForKey:@"rid"] intValue];
    
    [self isRefund:[[[arrayItems valueForKey:@"sub"] objectAtIndex:0]valueForKey:@"rid"]];
    
    //    labelReceipt.text = [NSString stringWithFormat:@"Receipt # %d", selectedRow+1];
    
    labelReceipt.text = [NSString stringWithFormat:@"%@ #%d",[Language get:@"Receipt" alter:@"!Receipt"], [[[[arrayItems valueForKey:@"sub"] objectAtIndex:0] valueForKey:@"id"] intValue]];
    
    
    if ([[arrayItems valueForKey:@"sub"] objectAtIndex:0]) {
        
        labelReceiptId.text = [NSString stringWithFormat:@"%@", [[[arrayItems valueForKey:@"sub"] objectAtIndex:0] valueForKey:@"code"]];
        
    }
    
    if ([[[[arrayItems valueForKey:@"sub"] objectAtIndex:0] valueForKey:@"printStatus"] intValue]==0) {
        
        self.btnPrintTransection.hidden=NO;
    }
    else
    {
        self.btnPrintTransection.hidden=YES;
    }
    
    
    if ([[[[arrayItems valueForKey:@"sub"] objectAtIndex:0] valueForKey:@"mailStatus"] intValue]==0) {
        
        mailSendButton.hidden=NO;
    }
    else
    {
        mailSendButton.hidden=YES;
    }

}


-(void)setSectionAndRowForAmmount:(NSString * )amount andZid:(int)zid
{
    amount = [amount stringByReplacingOccurrencesOfString:currencySign withString:@""];
    
    amount = [amount stringByReplacingOccurrencesOfString:currencySign withString:@""];
    
    int i= 0;
    
    if(filterdone)
    {
        for (NSDictionary *dict in array_SearchData)
        {
            NSArray *arr = [dict objectForKey:@"main"];
            
            
            int j = 0;
            
            for (NSDictionary *dictIn in arr)
            {
                
                NSString *valueString = [NSString stringWithFormat:@"%.2f", [[dictIn valueForKey:@"tprice"] floatValue]-[[[[dictIn valueForKey:@"sub"] objectAtIndex:0] valueForKey:@"discount"]floatValue]];
 
                if([valueString isEqualToString:amount] && [[dictIn valueForKey:@"id"]intValue]==zid && [[[[dictIn valueForKey:@"sub"] objectAtIndex:0] valueForKey:@"totalAmount"]floatValue] >= 0)
                {
                    selectedSection = i;
                    selectedRow = j;
                    return;
                }
                
                j++;
                
            }
            
            i++;
        }
    }
    else
    {
        for (NSDictionary *dict in dictAllItems)
        {
            NSArray *arr = [dict objectForKey:@"main"];
            
            
            int j = 0;
            
            for (NSDictionary *dictIn in arr)
            {
                
                NSString *valueString = [NSString stringWithFormat:@"%.2f", [[dictIn valueForKey:@"tprice"] floatValue]-[[[[dictIn valueForKey:@"sub"] objectAtIndex:0] valueForKey:@"discount"]floatValue]];
         
                if([valueString isEqualToString:amount] && [[dictIn valueForKey:@"id"]intValue]==zid && [[[[dictIn valueForKey:@"sub"] objectAtIndex:0] valueForKey:@"totalAmount"]floatValue] >= 0)
                {
                    selectedSection = i;
                    selectedRow = j;
                    return;
                }
                
                j++;
                
            }
            
            i++;
        }
    }
    
    
}

- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController
{
    return NO;
}
- (IBAction)mailSendAction:(UIButton *)sender {
    
    
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
        
        view_EmailPopUpBg.hidden = NO;
        
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
        
    
//    alertViewChangeName=[[UIAlertView alloc]initWithTitle:@"ISUPOS" message:[Language get:@"Please enter your email" alter:@"!Please enter your email"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    alertViewChangeName.tag=103;
//    alertViewChangeName.alertViewStyle=UIAlertViewStylePlainTextInput;
//    [alertViewChangeName show];
    }
    else {
        [[[UIAlertView alloc] initWithTitle:@"ISUPOS" message:[Language get:@"Please check your internet connection." alter:@"!Please check your internet connection."] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}

- (IBAction)cashButton:(UIButton *)sender {
    
}

#pragma mark print status 

-(void)editTransactionForPrintStatus:(NSString *)Id
{
    NSManagedObjectContext *context =[appDelegate managedObjectContext];
    NSError *error;
    NSEntityDescription *entityDescc =[NSEntityDescription entityForName:@"Trasections" inManagedObjectContext:context];
    NSFetchRequest *requestt = [[NSFetchRequest alloc] init];
    NSPredicate *predicate;
    predicate = [NSPredicate predicateWithFormat:@"(id = %@)", Id];
    [requestt setPredicate:predicate];
    [requestt setEntity:entityDescc];
    
    NSArray *objectss = [context executeFetchRequest:requestt error:&error];
    if ([objectss count] == 0) {
        
    }
    else
    {
        for (int i=0; i<[objectss count]; i++) {
            
            NSManagedObject *obj=(NSManagedObject *)[objectss objectAtIndex:i];
            
            [obj setValue:[NSNumber numberWithInt:1] forKey:@"printStatus"];
            [context save:&error];
        }
        
        
        
        
    }
    
    isPrintTran=YES;
    [self getAllTrasection];
}

-(void)editRefundForPrintStatus:(NSString *)Id
{
    NSManagedObjectContext *context =[appDelegate managedObjectContext];
    NSError *error;
    NSEntityDescription *entityDescc =[NSEntityDescription entityForName:@"RefundAmount" inManagedObjectContext:context];
    NSFetchRequest *requestt = [[NSFetchRequest alloc] init];
    NSPredicate *predicate;
    predicate = [NSPredicate predicateWithFormat:@"(id = %@)", Id];
    [requestt setPredicate:predicate];
    [requestt setEntity:entityDescc];
    
    NSArray *objectss = [context executeFetchRequest:requestt error:&error];
    if ([objectss count] == 0) {
        
    }
    else
    {
        
        for (int i=0; i<[objectss count]; i++) {
            NSManagedObject *obj=(NSManagedObject *)[objectss objectAtIndex:i];
            [obj setValue:[NSNumber numberWithInt:1] forKey:@"printStatus"];
            [context save:&error];
        }
        
        
    }
    
    isPrintTran=YES;
    [self getAllTrasection];
}

#pragma mark mail status

-(void)editTransactionForMailStatus:(NSString *)Id
{
    NSManagedObjectContext *context =[appDelegate managedObjectContext];
    NSError *error;
    NSEntityDescription *entityDescc =[NSEntityDescription entityForName:@"Trasections" inManagedObjectContext:context];
    NSFetchRequest *requestt = [[NSFetchRequest alloc] init];
    NSPredicate *predicate;
    predicate = [NSPredicate predicateWithFormat:@"(id = %@)", Id];
    [requestt setPredicate:predicate];
    [requestt setEntity:entityDescc];
    
    NSArray *objectss = [context executeFetchRequest:requestt error:&error];
    if ([objectss count] == 0) {
        
    }
    else
    {
        for (int i=0; i<[objectss count]; i++) {
            
            NSManagedObject *obj=(NSManagedObject *)[objectss objectAtIndex:i];
            
            [obj setValue:[NSNumber numberWithInt:1] forKey:@"mailStatus"];
            [context save:&error];
        }
        
        
        
        
    }
    
    isPrintTran=YES;
    [self getAllTrasection];
}

-(void)editRefundForMailStatus:(NSString *)Id
{
    NSManagedObjectContext *context =[appDelegate managedObjectContext];
    NSError *error;
    NSEntityDescription *entityDescc =[NSEntityDescription entityForName:@"RefundAmount" inManagedObjectContext:context];
    NSFetchRequest *requestt = [[NSFetchRequest alloc] init];
    NSPredicate *predicate;
    predicate = [NSPredicate predicateWithFormat:@"(id = %@)", Id];
    [requestt setPredicate:predicate];
    [requestt setEntity:entityDescc];
    
    NSArray *objectss = [context executeFetchRequest:requestt error:&error];
    if ([objectss count] == 0) {
        
    }
    else
    {
        
        for (int i=0; i<[objectss count]; i++) {
            NSManagedObject *obj=(NSManagedObject *)[objectss objectAtIndex:i];
            [obj setValue:[NSNumber numberWithInt:1] forKey:@"mailStatus"];
            [context save:&error];
        }
        
        
    }
    
    isPrintTran=YES;
    [self getAllTrasection];
}

@end
