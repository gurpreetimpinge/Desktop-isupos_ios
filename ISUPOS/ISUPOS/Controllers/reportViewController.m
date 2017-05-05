//
//  reportViewController.m
//  ISUPOS
//
//  Created by Rohit Mahajan on 4/21/15.
//  Copyright (c) 2015 Impinge Solutions. All rights reserved.
//

#import "reportViewController.h"
#import "TrasectionsViewController.h"
#import "ManageArticalViewController.h"
#import "quickBlocksButtonsView.h"
#import "helo&supportViewController.h"
#import "generalSettingViewController.h"
#import "receiptDataViewController.h"
#import "linkToViewController.h"
#import "UITextField+Validations.h"
#import "language.h"
#import "Reachability.h"
#import "AppDelegate.h"
#import "LogViewController.h"
#import "CommonMethods.h"

@class AppDelegate;
@interface reportViewController ()
{
    AppDelegate *appDelegate;
    
    UIView *moreButtonView;
    NSMutableArray *morebuttons;
    UIButton *morebutton;
    UIPopoverController *popover;
    NSMutableArray *arrayName,*arrayId,*arrayPrice,*arrayCount,*arrayVat,*arrayDate,*arrayDiscription,*arrayImage,*arrayDiscount,*temparray,*temparr2,*timearr;
    
    int selectedRow,selectedSection;
    
    NSMutableArray *dictAllTransaction;
    NSMutableArray *dictAllItems;
    NSMutableArray *dictAllZDayItems;
    NSString *str_datefrom;
    NSString *currencySign;
    
    float zzzz, total, totalvat;
    
    NSString *str_trnsId;
    
    UIAlertView *alertViewChangeName;
    NSString *str_DiscountType;
    NSString *text_string;
    int printCount;
    
    NSMutableArray *vatArray;
    
    NSString *currentDate;
    
    float grandTotalSale;
    float grandTotalSaleCash;
    float grandTotalSaleCard;
    float grandTotalSaleSwish;
    float grandTotalSaleOther;
    float grandTotalRefund;
    float grandTotalSales_Refund;
    
    float grandTotalDiscunt;
    float totalRefundCount;
    float totalPaymetCount;
    float totalCashPaymetCount;
    float totalCardPaymetCount;
    float totalSwishPaymetCount;
    float totalOtherPaymetCount;
    
    NSDate *selectedDate;
    
    BOOL genrateZDay;
    
    
    NSString *zcardPayment;
    NSString *zcashPayment;
    NSString *zswishPayment;
    NSString *zotherPayment;
    NSDate   *zdate;
    NSString *zdiscunts;
    NSString *zgrandTotalRefund;
    NSString *zgrandTotalSale;
    NSString *zgrandtotalSale_Refund;
    NSString *zrefund;
    NSString *zrefundCountTotal;
    NSString *zrefundcount;
    NSString *ztotalAmountMail;
    NSString *ztotalAmountPrint;
    NSString *ztotalEmail;
    NSString *ztotalEmailCopies;
    NSString *ztotalPayments;
    NSString *ztotalCashPayments;
    NSString *ztotalCardPayments;
    NSString *ztotalSwishPayments;
    NSString *ztotalOtherPayments;
    NSString *ztotalPrint;
    NSString *ztotalPrintCopies;
    NSString *ztotalProduct;
    NSString *ztotalPayment;
    NSString *zvat;
    
    NSMutableArray *zDayArray;
    NSMutableArray *refundZArray;
    
    NSString  *zDayLogIndexStr;
    NSDate *zDayLogIndexDate;
    BOOL isPrintTran;
    
    
    IBOutlet UIView *view_EmailPopUpBg,*view_EmailBg;
    IBOutlet UITextField *txt_Email;
    IBOutlet UIButton *btn_DropDown,*btn_EmailOk,*btn_EmailCancel;
    IBOutlet UITableView *tbl_EmailList;
    IBOutlet UIButton *btn_Exchange;

    NSMutableArray *ary_EmailList;
    
    
    IBOutlet UIView *view_ManualPriceEntry;
    IBOutlet UILabel *lbl_PriceTitle;
    IBOutlet UITextField *txt_Price;
    IBOutlet UIButton *btn_Ok,*btn_Cancel;
    
    
    IBOutlet UICollectionView *collectionView_ReportDetail;
    
    NSMutableArray *ary_DetailList;
    
}
@end

@implementation reportViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)Settitles
{
    
    self.title=[Language get:@"Reports" alter:@"!Reports"];
    labelTopSelling.text=[Language get:@"Top Selling Products" alter:@"!Top Selling Products"];
    labelTotalSale.text=[Language get:@"Total Sales" alter:@"!Total Sales"];
    labelTotalSale.text=[Language get:@"Payments" alter:@"!Payments"];
    labelCardPayment.text = [Language get:@"Card payments" alter:@"!Card payments"];
    labelDis.text = [Language get:@"Discounts" alter:@"!Discounts"];
    labelCashPayment.text = [Language get:@"Cash payments" alter:@"!Cash payments"];
    labelRefund.text = [Language get:@"Refund" alter:@"!Refund"];
    labelFee.text = [Language get:@"VAT" alter:@"!VAT"];
    labelPayments.text = [Language get:@"Payments" alter:@"!Payments"];
    [self.dayMonthSegmentBtn setTitle:[NSString stringWithFormat:@"%@",[Language get:@"By day" alter:@"!By day"] ] forSegmentAtIndex:0];
    [self.dayMonthSegmentBtn setTitle:[NSString stringWithFormat:@"%@",[Language get:@"By Month" alter:@"!By Month"] ] forSegmentAtIndex:1];
    [self.dayMonthSegmentBtn setTitle:[NSString stringWithFormat:@"%@",[Language get:@"Z Day" alter:@"!Z Day"] ] forSegmentAtIndex:2];
    [self.reportPrinterCopies setText:[NSString stringWithFormat:@"1 %@",[Language get:@"Copy" alter:@"!Copy"]]];
    self.lbl_Emailed.text = [Language get:@"Receipt email" alter:@"!Receipt email"];
    self.lbl_Printed.text = [Language get:@"Receipt print" alter:@"!Receipt print"];
    self.lbl_GrandTotSales.text = [Language get:@"Grand total sales" alter:@"!Grand total sales"];
    self.lbl_Grandrefund.text = [Language get:@"Grand total refund" alter:@"!Grand total refund"];
    self.lbl_grandSaleRef.text = [Language get:@"Grand total sales-refund" alter:@"!Grand total sales-refund"];
    self.lbl_Products.text = [Language get:@"Products" alter:@"!Products"];
    self.lbl_PrinterReport.text = [Language get:@"Printer" alter:@"!Printer"];
    self.lbl_PrinterOptionsReport.text = [Language get:@"Printer Options" alter:@"!Printer Options"];
    [self.btn_Print setTitle:[Language get:@"Print" alter:@"!Print"] forState:UIControlStateNormal];
    [self.btnGenerateZDay setTitle:[Language get:@"Generate Z day report" alter:@"!Generate Z day report"] forState:UIControlStateNormal];
    self.labelCopiesEmail.text = [Language get:@"Copies email" alter:@"Copies email"];
    self.labelCopiesPrint.text = [Language get:@"Copies print" alter:@"Copies print"];
    
    
    [ary_DetailList removeAllObjects];
    
    
    NSMutableDictionary *dict1 = [NSMutableDictionary new];
    [dict1 setValue:@"report-ico3.png" forKey:@"img"];
    [dict1 setValue:[Language get:@"Card payments" alter:@"!Card payments"] forKey:@"title"];
    [dict1 setValue:@"" forKey:@"value"];
    [ary_DetailList addObject:dict1];
    
    NSMutableDictionary *dict2 = [NSMutableDictionary new];
    [dict2 setValue:@"report-ico2.png" forKey:@"img"];
    [dict2 setValue:[Language get:@"Cash payments" alter:@"!Cash payments"] forKey:@"title"];
    [dict2 setValue:@"" forKey:@"value"];
    [ary_DetailList addObject:dict2];
    
    NSMutableDictionary *dict3 = [NSMutableDictionary new];
    [dict3 setValue:@"report-ico2.png" forKey:@"img"];
    [dict3 setValue:[Language get:@"Swish payments" alter:@"!Swish payments"] forKey:@"title"];
    [dict3 setValue:@"" forKey:@"value"];
    [ary_DetailList addObject:dict3];
    
    
    NSMutableDictionary *dict4 = [NSMutableDictionary new];
    [dict4 setValue:@"report-ico2.png" forKey:@"img"];
    [dict4 setValue:[Language get:@"Other payments" alter:@"!Other payments"] forKey:@"title"];
    [dict4 setValue:@"" forKey:@"value"];
    [ary_DetailList addObject:dict4];
    
    
    NSMutableDictionary *dict5 = [NSMutableDictionary new];
    [dict5 setValue:@"report-ico6.png" forKey:@"img"];
    [dict5 setValue:[Language get:@"Receipt email" alter:@"!Receipt email"] forKey:@"title"];
    [dict5 setValue:@"" forKey:@"value"];
    [ary_DetailList addObject:dict5];
    
    
    NSMutableDictionary *dict6 = [NSMutableDictionary new];
    [dict6 setValue:@"report-ico4.png" forKey:@"img"];
    [dict6 setValue:[Language get:@"Refund" alter:@"!Refund"] forKey:@"title"];
    [dict6 setValue:@"" forKey:@"value"];
    [ary_DetailList addObject:dict6];
    
    
    NSMutableDictionary *dict7 = [NSMutableDictionary new];
    [dict7 setValue:@"report-ico1.png" forKey:@"img"];
    [dict7 setValue:[Language get:@"Discounts" alter:@"!Discounts"] forKey:@"title"];
    [dict7 setValue:@"" forKey:@"value"];
    [ary_DetailList addObject:dict7];
    
    
    NSMutableDictionary *dict8 = [NSMutableDictionary new];
    [dict8 setValue:@"report-ico7.png" forKey:@"img"];
    [dict8 setValue:[Language get:@"Receipt print" alter:@"!Receipt print"] forKey:@"title"];
    [dict8 setValue:@"" forKey:@"value"];
    [ary_DetailList addObject:dict8];
    
    
    NSMutableDictionary *dict9 = [NSMutableDictionary new];
    [dict9 setValue:@"report-ico8.png" forKey:@"img"];
    [dict9 setValue:[Language get:@"Grand total sales" alter:@"!Grand total sales"] forKey:@"title"];
    [dict9 setValue:@"" forKey:@"value"];
    [ary_DetailList addObject:dict9];
    
    
    NSMutableDictionary *dict10 = [NSMutableDictionary new];
    [dict10 setValue:@"report-ico9.png" forKey:@"img"];
    [dict10 setValue:[Language get:@"Grand total refund" alter:@"!Grand total refund"] forKey:@"title"];
    [dict10 setValue:@"" forKey:@"value"];
    [ary_DetailList addObject:dict10];
    
    
    NSMutableDictionary *dict11 = [NSMutableDictionary new];
    [dict11 setValue:@"report-ico10.png" forKey:@"img"];
    [dict11 setValue:[Language get:@"Grand total sales-refund" alter:@"!Grand total sales-refund"] forKey:@"title"];
    [dict11 setValue:@"" forKey:@"value"];
    [ary_DetailList addObject:dict11];
    
    
    NSMutableDictionary *dict12 = [NSMutableDictionary new];
    [dict12 setValue:@"report-ico11.png" forKey:@"img"];
    [dict12 setValue:[Language get:@"Products" alter:@"!Products"] forKey:@"title"];
    [dict12 setValue:@"" forKey:@"value"];
    [ary_DetailList addObject:dict12];
    
    
    NSMutableDictionary *dict13 = [NSMutableDictionary new];
    [dict13 setValue:@"report-ico5.png" forKey:@"img"];
    [dict13 setValue:[Language get:@"VAT" alter:@"!VAT"] forKey:@"title"];
    [dict13 setValue:@"" forKey:@"value"];
    [ary_DetailList addObject:dict13];

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
    [reportViewController setPortName:localPortName];
    
    NSString *localPortSettings = @"mini";
    
    [reportViewController setPortSettings:localPortSettings];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    ary_DetailList = [NSMutableArray new];
    
    zcardPayment=@"0.0";
    zcashPayment=@"0.0";
    zswishPayment=@"0.0";
    zotherPayment=@"0.0";
    zdate=[NSDate date];
    zdiscunts=@"0.0";
    zgrandTotalRefund=@"0.0";
    zgrandTotalSale=@"0.0";
    zgrandtotalSale_Refund=@"0.0";
    zrefund=@"0.0";
    ztotalEmail=@"0";
    ztotalEmailCopies=@"0";
    ztotalPayments=@"0";
    ztotalCashPayments=@"0";
    ztotalCardPayments=@"0";
    ztotalSwishPayments=@"0";
    ztotalOtherPayments=@"0";
    ztotalPrint=@"0";
    ztotalPrintCopies=@"0";
    ztotalProduct=@"0";
    zvat=@"0.0";
        
    self.btnGenerateZDay.hidden = YES;
    
    self.backgroundView.layer.borderColor = [UIColor grayColor].CGColor;
    self.backgroundView.layer.borderWidth = 0.5f;
    
    currentDate=nil;
    
    selectedDate=[NSDate date];
    [[NSUserDefaults standardUserDefaults] setObject:@"Day" forKey:@"Report_Type"];
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    printCount=1;
    // Splunk Mint Breadcrumb added
    [[Mint sharedInstance] leaveBreadcrumb:@"ReportViewController_ViewController"];
    
    
    for (UIView *view in self.navigationController.navigationBar.subviews )
    {
        if (view.tag == -1)
        {
            [view removeFromSuperview];
        }
        
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    UILabel *lbl_manReg_ID = [[UILabel alloc]initWithFrame:CGRectMake(464, 22, 200, 30)];
    lbl_manReg_ID.tag = -1;
    //lbl_manReg_ID.text = [defaults objectForKey:@"INFRASEC_PASSWORD"];
    lbl_manReg_ID.text = [defaults objectForKey:@"POS_ID"];
    lbl_manReg_ID.textColor = [UIColor whiteColor];
    lbl_manReg_ID.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:11];
    
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
    
    vatArray=[[NSMutableArray alloc]init];
    refundZArray=[[NSMutableArray alloc]init];
    
    str_datefrom=@"Day";
    
    self.btnMailReceipt.hidden=YES;
    self.btnPrintReceipt.hidden=YES;
    
    zDayLogIndexStr=@"";
    
    zDayLogIndexDate=[NSDate date];
    self.labelReportNumber.hidden = YES;
    isPrintTran=NO;
    
    view_EmailBg.layer.borderWidth = 1;
    view_EmailBg.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    
    tbl_EmailList.layer.borderWidth = 1;
    tbl_EmailList.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    
    ary_EmailList = [NSMutableArray new];
    
    btn_Exchange.layer.cornerRadius = 12.2f;
    btn_Exchange.layer.masksToBounds = YES;
    
    txt_Price.layer.borderWidth = 1;
    txt_Price.inputView = [[[NSBundle mainBundle] loadNibNamed:@"LNNumberpad" owner:self options:nil] objectAtIndex:0];
    UIView *leftPadding = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 0)];
    txt_Price.leftView = leftPadding;
    txt_Price.leftViewMode = UITextFieldViewModeAlways;
    
    lbl_PriceTitle.text = [Language get:@"Exchange" alter:@"!Exchange"];
    
}
- (void) viewWillAppear:(BOOL)animated
{
    btn_Exchange.hidden = YES;
    view_ManualPriceEntry.hidden = YES;
    view_EmailPopUpBg.hidden = YES;
    
    [self Settitles];
    
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
    
    text_string = @"BT:PRNT Star";
    
    
    //    self.title=@"Reports";
    printerview.hidden=YES;
    self.navigationItem.hidesBackButton = YES;
    [super viewWillAppear:animated];
    [self add_button_on_tabbar];
    self.navigationController.navigationBarHidden = NO;
    [self getVatarray];
    [self getAllTrasection];
    
    
    //    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
    //
    //    [maintablev selectRowAtIndexPath:indexPath animated:YES  scrollPosition:UITableViewScrollPositionBottom];
    
    
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
        UIStoryboard* storyboard   = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        TrasectionsViewController *manage_artical = [storyboard instantiateViewControllerWithIdentifier:@"TrasectionsView"];
        [self.navigationController pushViewController:manage_artical animated:NO];
    }
    else if(klm==5)
    {
        //        UIStoryboard* storyboard   = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        //        reportViewController *manage_artical = [storyboard instantiateViewControllerWithIdentifier:@"reportView"];
        //        [self.navigationController pushViewController:manage_artical animated:NO];
    }
    else if(klm==6)
    {
        UIStoryboard* storyboard   = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        linkToViewController *manage_artical = [storyboard instantiateViewControllerWithIdentifier:@"linkToViewController"];
        [self.navigationController pushViewController:manage_artical animated:NO];
    }
    
    
    //    NSManagedObject *newContact;
    //    newContact = [NSEntityDescription insertNewObjectForEntityForName:@"Log" inManagedObjectContext:context];
    //
    //    [newContact setValue:[NSDate date] forKey:@"date"];
    //    [newContact setValue:[Language get:@"Reports" alter:@"!Reports"] forKey:@"discription"];
    //    [newContact setValue:@"" forKey:@"sno"];
    //
    //    [context save:&error];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"Copy" forKey:@"ReciptType"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    self.report_PrinterView.hidden = YES;
    
    [maintablev selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:0];
    
}

-(void)toDismissThePopover
{
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
            [popover setPopoverContentSize:CGSizeMake(567, 564)];
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
    
    if (alertView.tag==6)
    {
        if(buttonIndex==0)
        {
            [appDelegate clearCart];
            UIViewController* rootController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"LoginViewController"];
            UINavigationController* navigation = [[UINavigationController alloc] initWithRootViewController:rootController];
            appDelegate.window.rootViewController = navigation;
        }
        
    }
    
    if (alertView.tag == 104) {
        if (buttonIndex == 0) {
            if ([[alertView textFieldAtIndex:0] validEmailAddress]) {
                
                
                [[NSUserDefaults standardUserDefaults] setObject:@"Repo" forKey:@"MailType"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                NSString *email = [alertViewChangeName textFieldAtIndex:0].text;
                [[NSUserDefaults standardUserDefaults] setObject:email forKey:@"EMAIL"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                //                if([[[NSUserDefaults standardUserDefaults] valueForKey:@"Report_Type"] isEqualToString:@"Month"])
                //                {
                //                    [[AppDelegate delegate] sendMailWithSubject:[NSString stringWithFormat:@"%@", [Language get:@"Receipt" alter:@"!Receipt"]]  sendFrom:@"" ToReciepents:@"" messageHtmlBodyContent:@""];
                //                }
                //                else
                //                {
                
                
//                if (genrateZDay==YES) {
//                    if(zDayArray.count>0)
//                    {
//                        
//                        [self editTransactionForMailStatus:[[zDayArray objectAtIndex:selectedRow] valueForKey:@"id"]];
//                        
//                    }
//                }
                
                
                [[AppDelegate delegate] sendXZdayReportMailWithSubject:@"Receipt" sendFrom:@"" ToReciepents:@"" messageHtmlBodyContent:@""];
             
//                if(genrateZDay==YES)
//                {
//                
//                if ([[NSUserDefaults standardUserDefaults] valueForKey:@"emailedCopies"]) {
//                    
//                    int emailNo =[[[NSUserDefaults standardUserDefaults] valueForKey:@"emailedCopies"] intValue];
//                    
//                    emailNo=emailNo+1;
//                    
//                    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",emailNo] forKey:@"emailedCopies"];
//                    [[NSUserDefaults standardUserDefaults] synchronize];
//                    
//                }
//                else
//                {
//                    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"emailedCopies"];
//                    [[NSUserDefaults standardUserDefaults] synchronize];
//                }
//                
//                }
                
                if (genrateZDay==YES) {
                    [self createLogDetails:[NSString stringWithFormat:@"to %@",email]];
                }
                //                }
                
                
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
    moreButtonView=nil;
    
    self.report_PrinterView.hidden=YES;
    
    view_ManualPriceEntry.hidden = YES;
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
    else if (klm==3)
    {
        
        UIStoryboard* storyboard   = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        receiptDataViewController *manage_artical = [storyboard instantiateViewControllerWithIdentifier:@"receiptDataViewController"];
        [self.navigationController pushViewController:manage_artical animated:NO];
    }
    else if(klm==4)
    {
        UIStoryboard* storyboard   = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        TrasectionsViewController *manage_artical = [storyboard instantiateViewControllerWithIdentifier:@"TrasectionsView"];
        [self.navigationController pushViewController:manage_artical animated:NO];
    }
    else if(klm==5)
    {
        [self add_button_on_tabbar];
    }
    else if(klm==6)
    {
        UIStoryboard* storyboard   = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        linkToViewController *manage_artical = [storyboard instantiateViewControllerWithIdentifier:@"linkToViewController"];
        [self.navigationController pushViewController:manage_artical animated:NO];
    }
    
}

- (IBAction)steeper_action:(UIStepper*)sender
{
    double value = [sender value];
    
    printCount=[sender value];
    
    
    sender.minimumValue = 1;
    
    [printerCopies setText:[NSString stringWithFormat:@"%d %@",(int)value,[Language get:@"Copy" alter:@"!Copy"]]];
    if((int)value>1)
        [printerCopies setText:[NSString stringWithFormat:@"%d %@", (int)value,[Language get:@"Copies" alter:@"!Copies"]]];
}

- (IBAction)select_printerAndPrint:(UIButton*)sender
{
    
}

- (IBAction)printSelectAndMessage:(UIButton*)sender
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    if (internetStatus != NotReachable) {
        
        
        if(self.btnGenerateZDay.hidden ==NO)
        {
            if(zDayArray.count>0)
            {
                printerview.hidden=NO;
                
                
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
                
                if ([[NSUserDefaults standardUserDefaults]valueForKey:@"EMAIL"]) {
                    
                    txt_Email.text = [[NSUserDefaults standardUserDefaults]valueForKey:@"EMAIL"];
                }
                else
                {
                    txt_Email.text = @"";
                }
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
                
                
//                alertViewChangeName=[[UIAlertView alloc]initWithTitle:@"ISUPOS" message:[Language get:@"Please enter your email" alter:@"!Please enter your email"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                alertViewChangeName.alertViewStyle=UIAlertViewStylePlainTextInput;
//                alertViewChangeName.tag=104;
//                [alertViewChangeName show];
            }
            
        }
        else
        {
        
            printerview.hidden=NO;
            
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
            
            if ([[NSUserDefaults standardUserDefaults]valueForKey:@"EMAIL"]) {
                
                txt_Email.text = [[NSUserDefaults standardUserDefaults]valueForKey:@"EMAIL"];
            }
            else
            {
                txt_Email.text = @"";
            }
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
            
//        alertViewChangeName=[[UIAlertView alloc]initWithTitle:@"ISUPOS" message:[Language get:@"Please enter your email" alter:@"!Please enter your email"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        alertViewChangeName.alertViewStyle=UIAlertViewStylePlainTextInput;
//        alertViewChangeName.tag=104;
//        [alertViewChangeName show];
        }
        
    }
    else {
        [[[UIAlertView alloc] initWithTitle:@"ISUPOS" message:[Language get:@"Please check your internet connection." alter:@"!Please check your internet connection."] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}


-(void)getAllTrasection
{
    [self getDataDayWise:[NSDate date]];
    //    [self getDataMonthWise];
    NSDate *cuDate=[NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd MMMM yyyy"];
    currentDate = [dateFormatter stringFromDate:cuDate];
    selectedDate=[NSDate date];
    [self CurrentDateRefund];
    
    [tableViewItems reloadData];
    
    [maintablev reloadData];
}




-(void)bydayFilter
{
    
    for (NSString *obj in arrayDate) {
        if ([temparray containsObject:obj] == NO) {
            [temparray addObject:obj];
        }
    }
}


#pragma mark - EmailPopUp

-(IBAction)buttonExchange:(id)sender
{
    view_ManualPriceEntry.hidden = NO;
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"ExchangePrice"])
    {
        txt_Price.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"ExchangePrice"];
    }
}

-(IBAction)buttonOKCancel:(UIButton *)sender
{
    if (sender == btn_Ok)
    {
        if (txt_Price.text.length == 0)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ISUPOS" message:[Language get:@"Please enter valid price." alter:@"!Please enter valid price."] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        else
        {
            [view_ManualPriceEntry setHidden:YES];
            
            [[NSUserDefaults standardUserDefaults] setValue:txt_Price.text forKey:@"ExchangePrice"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
    }
    else
    {
        [view_ManualPriceEntry setHidden:YES];
    }
    
    
}

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
                
                
                [[NSUserDefaults standardUserDefaults] setObject:@"Repo" forKey:@"MailType"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                NSString *email = txt_Email.text;
                [[NSUserDefaults standardUserDefaults] setObject:email forKey:@"EMAIL"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [[AppDelegate delegate] sendXZdayReportMailWithSubject:@"Receipt" sendFrom:@"" ToReciepents:@"" messageHtmlBodyContent:@""];
                
                if (genrateZDay==YES) {
                    [self createLogDetails:[NSString stringWithFormat:@"to %@",email]];
                }
                
                
                view_EmailPopUpBg.hidden = YES;
            }
            
        }
        
    }
    else if (sender == btn_EmailCancel)
    {
        view_EmailPopUpBg.hidden = YES;
    }
}

#pragma mark UiCollectionView Delegate Methods

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [ary_DetailList count];
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView1 cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell=[collectionView1 dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    for (UIView *view in cell.contentView.subviews)
    {
        [view removeFromSuperview];
    }
    
    UIImageView *img_bg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 16, 32, 33)];
    [img_bg setImage:[UIImage imageNamed:[[ary_DetailList objectAtIndex:indexPath.row] valueForKey:@"img"]]];
    img_bg.backgroundColor = [UIColor clearColor];
    [cell.contentView addSubview:img_bg];
    
    if (indexPath.row == 11)
    {
        UILabel * lbl_Title = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(img_bg.frame)+5,10,167,45)];
        lbl_Title.textColor = [UIColor darkGrayColor];
        lbl_Title.numberOfLines = 0;
        lbl_Title.textAlignment = NSTextAlignmentLeft;
        lbl_Title.font = [UIFont systemFontOfSize:14];
        [lbl_Title setBackgroundColor:[UIColor clearColor]];
        lbl_Title.text = [[ary_DetailList objectAtIndex:indexPath.row] valueForKey:@"title"];
        [cell.contentView  addSubview:lbl_Title];
    }
    else
    {
        UILabel * lbl_Title = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(img_bg.frame)+5,17,167,18)];
        lbl_Title.textColor = [UIColor darkGrayColor];
        lbl_Title.numberOfLines = 0;
        lbl_Title.textAlignment = NSTextAlignmentLeft;
        lbl_Title.font = [UIFont systemFontOfSize:14];
        [lbl_Title setBackgroundColor:[UIColor clearColor]];
        lbl_Title.text = [[ary_DetailList objectAtIndex:indexPath.row] valueForKey:@"title"];
        [cell.contentView  addSubview:lbl_Title];
        
        UILabel * lbl_Value = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(img_bg.frame)+5,CGRectGetMaxY(lbl_Title.frame)+4,167,18)];
        if (indexPath.row==[ary_DetailList count]-1)
        {
            lbl_Value.frame = CGRectMake(CGRectGetMaxX(img_bg.frame)+5,CGRectGetMaxY(lbl_Title.frame)+4,167+125,18);
        }
        else
        {
            lbl_Value.frame = CGRectMake(CGRectGetMaxX(img_bg.frame)+5,CGRectGetMaxY(lbl_Title.frame)+4,167,18);
        }
        
        if (indexPath.row == 5 || (indexPath.row == 10 && [[[ary_DetailList objectAtIndex:indexPath.row] valueForKey:@"value"] intValue]<1))
        {
            lbl_Value.textColor = [UIColor redColor];
        }
        else
        {
            lbl_Value.textColor = [UIColor lightGrayColor];
        }
        
        lbl_Value.numberOfLines = 0;
        lbl_Value.textAlignment = NSTextAlignmentLeft;
        lbl_Value.font = [UIFont systemFontOfSize:12];
        [lbl_Value setBackgroundColor:[UIColor clearColor]];
        lbl_Value.text = [[ary_DetailList objectAtIndex:indexPath.row] valueForKey:@"value"];
        [cell.contentView  addSubview:lbl_Value];
        
        
    }
   
    
    if (indexPath.row<[ary_DetailList count]-1)
    {
        UIView * view_Underline = [[UIView alloc]initWithFrame:CGRectMake(0,64,225,1)];
        [view_Underline setBackgroundColor:[UIColor lightGrayColor]];
        [cell.contentView  addSubview:view_Underline];
    }
   
    
    return cell;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [ary_DetailList count]-1)
    {
        return CGSizeMake(350, 65);
    }
    else
    {
        return CGSizeMake(225, 65);
    }
    
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - UITableView Datasource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == maintablev)
    {
        if (genrateZDay==YES) {
            
            return [zDayArray count];
        }
        else
        {
            return [[[dictAllItems objectAtIndex:section] objectForKey:@"main"] count];
        }
    }
    else if (tableView == tbl_EmailList)
    {
        return [ary_EmailList count];
    }
    else
    {
        if (dictAllItems.count == 0)
            return 0;
        else
            return [[[[[dictAllItems objectAtIndex:selectedSection] objectForKey:@"main"] objectAtIndex:selectedRow] valueForKey:@"sub"] count];
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    if (tableView == maintablev)
    {
        if (genrateZDay==YES) {
            return 1;
        }
        else
        {
            return [dictAllItems count];
        }
    }
    else if (tableView == tbl_EmailList)
    {
        return 1;
    }
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (genrateZDay==NO) {
        
        if (tableView == maintablev)
        {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(5, 0, tableView.frame.size.width+100, 38)];
            // Create custom view to display section header...
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, tableView.frame.size.width+100, 38)];
            label.textAlignment=NSTextAlignmentLeft;
            [label setFont:[UIFont boldSystemFontOfSize:18]];
            [label setTextColor:[UIColor colorWithRed:91.0f/255.0f green:41.0f/255.0f blue:117.0f/255.0f alpha:1.0f]];
            //   Section header is in 0th index...
            
            NSMutableDictionary *dict = [dictAllItems objectAtIndex:section];
            
            
            NSString *stringDateTime;
            
            if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"time_format"] isEqualToString:@"12"])
            {
                
                stringDateTime = [dict objectForKey:@"month"];
                
                
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
                
                if([str_datefrom isEqualToString:@"Month"])
                {
                    [dateFormatter setDateFormat:@"yyyy"];
                }
                else
                {
                    [dateFormatter setDateFormat:@"MMMM yyyy"];
                }
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
                
                [dateFormatter setDateFormat:@"yyyy"];
                
                NSString *str_year = [dateFormatter stringFromDate:currDate];
                
                [dateFormatter setDateFormat:@"hh:mm:ss a"];
                
                NSString *dateString=[NSString stringWithFormat:@"%@ %@",str_month,str_year];
                
                //        [dateFormatter setDateFormat:@"dd-MMMM-yyyy hh:mm:ss a"];
                //         NSString *dateString = [dateFormatter stringFromDate:currDate];
                
                if([str_datefrom isEqualToString:@"Month"])
                {
                    dateString=[NSString stringWithFormat:@"%@",str_year];
                }
                else
                {
                    dateString=[NSString stringWithFormat:@"%@ %@",str_month,str_year];
                }
                
                
                label.text = dateString;
                
            }
            else{
                
                stringDateTime = [dict objectForKey:@"month"];
                
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
                if([str_datefrom isEqualToString:@"Month"])
                {
                    [dateFormatter setDateFormat:@"yyyy"];
                }
                else
                {
                    [dateFormatter setDateFormat:@"MMMM yyyy"];
                }
                
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
                
                [dateFormatter setDateFormat:@"yyyy"];
                
                NSString *str_year = [dateFormatter stringFromDate:currDate];
                
                [dateFormatter setDateFormat:@"HH:mm"];
                
                
                NSString *dateString;
                
                if([str_datefrom isEqualToString:@"Month"])
                {
                    dateString=[NSString stringWithFormat:@"%@",str_year];
                }
                else
                {
                    dateString=[NSString stringWithFormat:@"%@ %@",str_month,str_year];
                }
                
                label.text = dateString;
                
            }
           
            [view addSubview:label];
            [view setBackgroundColor:[UIColor colorWithRed:234.0f/255.0f green:234.0f/255.0f blue:234.0f/255.0f alpha:1.0f]]; //your background color...
            
            
            return view;
        }
    }
    return NO;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == maintablev)
    {
        if (genrateZDay==YES) {
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
            
            if(cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
            }
            
            UIFont * myFont = [UIFont fontWithName:@"Arial" size:15];
            CGRect labelFrame = CGRectMake (20, 15, cell.frame.size.width-40, 25);
            UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
            [label setFont:myFont];
            //    label.lineBreakMode=NSLineBreakByWordWrapping;
            label.numberOfLines=5;
            label.textColor=[UIColor grayColor];
            
            
            NSDate *zdayDate=[[zDayArray valueForKey:@"date"]objectAtIndex:indexPath.row];
            
            
            if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"time_format"] isEqualToString:@"12"])
            {
                
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
                
                [dateFormatter setDateFormat:@"hh:mm:ss a"];
                
                NSString *str_time = [dateFormatter stringFromDate:currDate];
                
                NSString *dateString=[NSString stringWithFormat:@"%@-%@-%@ %@",str_day,str_month,str_year,str_time];
                
                
                [label setText:dateString];
                
                labelFooterDate.text = dateString;
                labelHeaderDate.text =[NSString stringWithFormat:@"%@",[Language get:@"Z-REPORT" alter:@"!Z-REPORT"]];
                
                
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
                
                NSString *dateString=[NSString stringWithFormat:@"%@-%@-%@ %@",str_day,str_month,str_year,str_time];
                
                
                [label setText:dateString];
                
                labelFooterDate.text = dateString;
                labelHeaderDate.text =[NSString stringWithFormat:@"%@",[Language get:@"Z-REPORT" alter:@"!Z-REPORT"]];
            }
            
            
            [cell addSubview:label];
            
            
            return cell;
            
        }
        else
        {
            
            NSManagedObjectContext *context =[appDelegate managedObjectContext];
            
            NSEntityDescription *entityDesc2 =[NSEntityDescription entityForName:@"CustomDiscount" inManagedObjectContext:context];
            NSFetchRequest *request11 = [[NSFetchRequest alloc] init];
            [request11 setEntity:entityDesc2];
            NSError *error2;
            NSArray *objects2 = [context executeFetchRequest:request11 error:&error2];
            
            NSManagedObject *person2;
            
            
            for(int i=0;i<objects2.count;i++)
            {
                
                NSArray* ary_ID = [[[[[dictAllItems objectAtIndex:indexPath.section] objectForKey:@"main"] objectAtIndex:indexPath.row] valueForKey:@"finalid"] componentsSeparatedByString: @","];
                
                
                if ([ary_ID count]>0)
                {
                    if ([ary_ID containsObject:[NSString stringWithFormat:@"%@",[[objects2 objectAtIndex:i] valueForKey:@"id"]]])
                    {
                        person2 = (NSManagedObject *)[objects2 objectAtIndex:i];
                        
//                        if ([_str_paymentMethod isEqualToString:@"2"]) {
//                            
//                            sumnewCard = [[person2 valueForKey:@"discount"] floatValue]+sumnew;
//                            
//                        }
//                        else{
//                            
//                            sumnewCash = [[person2 valueForKey:@"discount"] floatValue]+sumnew;
//                            
//                            
//                        }
                    }
                }
                
                //            person2 = (NSManagedObject *)[objects2 objectAtIndex:i];
                //
                //            sumnew = [[person2 valueForKey:@"discount"] floatValue]+sumnew;
            }
            
            NSMutableDictionary *dicSub =[[[dictAllItems objectAtIndex:indexPath.section] objectForKey:@"main"] objectAtIndex:indexPath.row];
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
            
            if(cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
            }
            
            UIFont * myFont = [UIFont fontWithName:@"Arial" size:15];
            CGRect labelFrame = CGRectMake (cell.frame.size.width-120, 15, 100, 25);
            UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
            [label setFont:myFont];
            //    label.lineBreakMode=NSLineBreakByWordWrapping;
            label.numberOfLines=5;
            label.textColor=[UIColor grayColor];
            

            [label setText:[NSString stringWithFormat:@"%@ %.02f",currencySign,[[dicSub valueForKey:@"totalSum"] floatValue]-[[dicSub valueForKey:@"totaldiscount"] floatValue]]];
            
            [cell addSubview:label];
            
            UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake (50, 5, 80, 20)];
            [label1 setFont:myFont];
            label1.textAlignment=NSTextAlignmentLeft;
            label1.textColor=[UIColor grayColor];
            label1.backgroundColor=[UIColor clearColor];
            
            
            [label1 setText:[dicSub valueForKey:@"dayE"]];
            
            
            NSString *str_month = [dicSub valueForKey:@"dayE"];
            
            
            if([str_month isEqualToString:@"Monday"])
            {
                str_month=[Language get:@"Monday" alter:@"!Monday"];
            }
            else if([str_month isEqualToString:@"Tuesday"])
            {
                str_month=[Language get:@"Tuesday" alter:@"!Tuesday"];
            }
            else if([str_month isEqualToString:@"Wednesday"])
            {
                str_month=[Language get:@"Wednesday" alter:@"!Wednesday"];
            }
            else if([str_month isEqualToString:@"Thursday"])
            {
                str_month=[Language get:@"Thursday" alter:@"!Thursday"];
            }
            else if([str_month isEqualToString:@"Friday"])
            {
                str_month=[Language get:@"Friday" alter:@"!Friday"];
            }
            else if([str_month isEqualToString:@"Saturday"])
            {
                str_month=[Language get:@"Saturday" alter:@"!Saturday"];
            }
            else if([str_month isEqualToString:@"Sunday"])
            {
                str_month=[Language get:@"Sunday" alter:@"!Sunday"];
            }
            
            else if([str_month isEqualToString:@"January"])
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
            
            [label1 setText:str_month];
            
            [cell addSubview:label1];
            
            
            UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake (50, 30, 120, 25)];
            [label2 setFont:myFont];
            label2.textAlignment=NSTextAlignmentLeft;
            label2.textColor=[UIColor grayColor];
            label2.backgroundColor=[UIColor clearColor];
            
            //    if ([[dicSub valueForKey:@"countPayment"] count] == 1)
            //    {
            //        [label2 setText:[NSString stringWithFormat:@"%@ Payment",[dicSub valueForKey:@"countPayment"]]];
            //    }
            //    else
            //    {
            //        [label2 setText:[NSString stringWithFormat:@"%@ Payments",[dicSub valueForKey:@"countPayment"]]];
            //    }
            
            
            int i = [[dicSub valueForKey:@"countPayment"] intValue] + [[dicSub valueForKey:@"cardPayment"] intValue] + [[dicSub valueForKey:@"swishPayment"] intValue] + [[dicSub valueForKey:@"otherPayment"] intValue];
            
            if([[dicSub valueForKey:@"countPayment"]intValue]>1)
            {
                [label2 setText:[NSString stringWithFormat:@"%d %@",i,  labelPayments.text = [Language get:@"Payments" alter:@"!Payments"]]];
            }
            else
                [label2 setText:[NSString stringWithFormat:@"%d %@",i, labelPayments.text = [Language get:@"Payments" alter:@"!Payments"]]];
            [cell addSubview:label2];
            
            
            
            UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake (10, 15, 30, 25)];
            [label3 setFont:myFont];
            label3.textAlignment=NSTextAlignmentCenter;
            label3.textColor=[UIColor whiteColor];
            label3.backgroundColor=[UIColor colorWithRed:91.0f/255.0f green:41.0f/255.0f blue:117.0f/255.0f alpha:1.0f];
            
            [label3 setText:[dicSub valueForKey:@"day"]];
            
            label3.layer.cornerRadius = 12.2f;
            label3.layer.masksToBounds = YES;
            [cell.contentView addSubview:label3];
            
            
            return cell;
            
        }
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
        //        NSMutableDictionary *dicSub = [[[dictAllItems objectAtIndex:selectedSection] objectForKey:@"main"] objectAtIndex:selectedRow];
        
        static NSString *cellIdentifier = @"cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
        
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        }
        
        UIFont * myFont = [UIFont fontWithName:@"Arial" size:15];
        CGRect labelFrame = CGRectMake (480, 15, 100, 20);
        UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
        [label setFont:myFont];
        //    label.lineBreakMode=NSLineBreakByWordWrapping;
        label.numberOfLines=5;
        label.textColor=[UIColor grayColor];
        
        //        NSString *str = [NSString stringWithFormat:@"€%.02f", [[[[[dictAllItems objectAtIndex:selectedSection] objectForKey:@"main"]  objectAtIndex:selectedRow ] valueForKey:@"totalSum"]floatValue]];
        
        
        
        
        //        [label setText:[NSString stringWithFormat:@"%@", [[arrayItems1 valueForKey:@"price"] objectAtIndex:indexPath.row]]];
        
        //        [label setText:[NSString stringWithFormat:@"€%.02f",[[dicSub valueForKey:@"totalSum"] floatValue]]];
        
        [cell addSubview:label];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake (50, 15, 300, 20)];
        [label1 setFont:myFont];
        label1.textAlignment=NSTextAlignmentLeft;
        label1.textColor=[UIColor grayColor];
        label1.backgroundColor=[UIColor clearColor];
        ;
        
        NSMutableDictionary *dictAllItem = [[[[dictAllItems objectAtIndex:selectedSection] objectForKey:@"main"] objectAtIndex:selectedRow] valueForKey:@"sub"];
        
        NSMutableArray * arrayItems = [NSMutableArray new];
        
        
        for (NSString *key in dictAllItem)
        {
            [arrayItems addObject:[dictAllItem objectForKey:key]];
        }
        
        
        NSArray *sortedArray = [arrayItems sortedArrayUsingComparator:^NSComparisonResult(NSDictionary *a, NSDictionary *b) {
            
            int valueA = [[a valueForKey:@"price"] intValue] * [[a valueForKey:@"count"] intValue];
            int valueB = [[b valueForKey:@"price"] intValue] * [[b valueForKey:@"count"] intValue];
            
            return (valueA<valueB);
        }];
        
        
        arrayItems = [NSMutableArray arrayWithArray:sortedArray];
        
        
        [label1 setText:[NSString stringWithFormat:@"%@", [[arrayItems valueForKey:@"name"] objectAtIndex:indexPath.row]]];
        
        [cell addSubview:label1];
        
        
        
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake (10, 15, 30, 20)];
        [label3 setFont:myFont];
        label3.textAlignment=NSTextAlignmentCenter;
        label3.textColor=[UIColor whiteColor];
        label3.backgroundColor=[UIColor colorWithRed:91.0f/255.0f green:41.0f/255.0f blue:117.0f/255.0f alpha:1.0f];
        
        
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        
        for (NSMutableArray *array in [[[[dictAllItems objectAtIndex:selectedSection] objectForKey:@"main"] objectAtIndex:0] valueForKey:@"sub"])
        {
            [arr addObject:array];
        }
        
        
        float str = [[[arrayItems valueForKey:@"price"] objectAtIndex:indexPath.row] floatValue] *[[[arrayItems valueForKey:@"count"] objectAtIndex:indexPath.row] floatValue];
        
//        float totalPrice = str-[[[arrayItems valueForKey:@"customdiscount"] objectAtIndex:indexPath.row] floatValue];
        
        
        [label setText:[NSString stringWithFormat:@"%.02f", str]];
        
        
        [label3 setText:[NSString stringWithFormat:@"%@", [[arrayItems valueForKey:@"count"] objectAtIndex:indexPath.row]]];
        
        label3.layer.cornerRadius = 10.0f;
        label3.layer.masksToBounds = YES;
        [cell.contentView addSubview:label3];
        
        
        return cell;
    }
    return nil;
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
        if (genrateZDay==YES) {
            
            [self viewZdayData:indexPath.row];
            
        }
        else
        {
            selectedRow = indexPath.row;
            selectedSection = indexPath.section;
            
            NSString *stringDateTime;
            stringDateTime = [NSString stringWithFormat:@"%@",[[[[dictAllItems objectAtIndex:selectedSection] objectForKey:@"main"] objectAtIndex:selectedRow] valueForKey:@"totaldatetime"]];
            
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:@"dd-MMMM-yyyy, hh:mm a"];
            
            selectedDate=[dateFormatter dateFromString:stringDateTime];
            
            [self setMiddlePart];
            
            [tableViewItems reloadData];
        }
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
        if (genrateZDay==YES) {
            return 0;
        }
        else
        {
            return 38;
        }
    }
    
}


#pragma mark -------------------- Set Middle Part -----------------------
-(void)setMiddlePart
{
    
    NSMutableArray * arrayItems1 = [NSMutableArray new];
    
    arrayItems1=[[[dictAllItems objectAtIndex:selectedSection] objectForKey:@"main"] objectAtIndex:selectedRow];
    
    appDelegate.reciptArray=arrayItems1;
    
    
    NSMutableDictionary *dictAllItem = [[[[dictAllItems objectAtIndex:selectedSection] objectForKey:@"main"] objectAtIndex:selectedRow] valueForKey:@"sub"];
    
    NSMutableArray * arrayItems = [NSMutableArray new];
    
    
    for (NSString *key in dictAllItem)
    {
        [arrayItems addObject:[dictAllItem objectForKey:key]];
    }
    
    
    labelQuantity.layer.cornerRadius = 11.5f;
    
    if ([arrayItems count] == 1)
    {
        
    }
    else if ([[arrayItems valueForKey:@"sub"] count] >= 2)
    {
        
    }
    else
    {
        
    }
    
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"newprice" ascending:YES];
    [arrayItems sortUsingDescriptors:[NSArray arrayWithObject:sort]];
    
    
    NSInteger sum = 0;
    
    for (NSDictionary *dict in arrayItems)
    {
        sum += [[dict valueForKey:@"price"] intValue] * [[dict valueForKey:@"count"] intValue];
    }
    
    
    NSString *stringDateTime;
    
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"time_format"] isEqualToString:@"12"])
    {
        
        stringDateTime = [NSString stringWithFormat:@"%@",[[[[dictAllItems objectAtIndex:selectedSection] objectForKey:@"main"] objectAtIndex:selectedRow] valueForKey:@"totaldatetime"]];
        
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"dd-MMMM-yyyy, hh:mm a"];
        
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
        
        [dateFormatter setDateFormat:@"hh:mm:ss a"];
        
        NSString *str_time = [dateFormatter stringFromDate:currDate];
        
        NSString *dateString=[NSString stringWithFormat:@"%@-%@-%@ %@",str_day,str_month,str_year,str_time];
        
        
        
        labelFooterDate.text = dateString;
        
        [[NSUserDefaults standardUserDefaults] setObject:dateString forKey:@"totalTime"];
        
        [dateFormatter setDateFormat:@"dd-MMMM-yyyy"];
        
        
        labelHeaderDate.text =[NSString stringWithFormat:@"%@ %@ %@",str_day,str_month,str_year];
        
    }
    else{
        
        stringDateTime = [NSString stringWithFormat:@"%@",[[[[dictAllItems objectAtIndex:selectedSection] objectForKey:@"main"] objectAtIndex:selectedRow] valueForKey:@"totaldatetime"]];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"dd-MMMM-yyyy, hh:mm a"];
        
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
        
        NSString *dateString=[NSString stringWithFormat:@"%@-%@-%@ %@",str_day,str_month,str_year,str_time];
        
        
        labelFooterDate.text = dateString;
        
        [dateFormatter setDateFormat:@"dd-MMMM-yyyy"];
        
        [[NSUserDefaults standardUserDefaults] setObject:dateString forKey:@"totalTime"];
        
        
        labelHeaderDate.text =[NSString stringWithFormat:@"%@ %@ %@",str_day,str_month,str_year];
        
    }
  
    
//    labelCardPayment.text = [NSString stringWithFormat:@"%@ %@ ",[[[[dictAllItems objectAtIndex:selectedSection] objectForKey:@"main"] objectAtIndex:selectedRow] valueForKey:@"cardPayment"],  labelCardPayment.text = [Language get:@"Card payments" alter:@"!Card payments"]];
//        
//    labelCashPayment.text = [NSString stringWithFormat:@"%@ %@ ",[[[[dictAllItems objectAtIndex:selectedSection] objectForKey:@"main"] objectAtIndex:selectedRow] valueForKey:@"countPayment"],  labelCashPayment.text = [Language get:@"Cash payments" alter:@"!Cash payments"]];
    
    [[NSUserDefaults standardUserDefaults] setObject:[[[[dictAllItems objectAtIndex:selectedSection] objectForKey:@"main"] objectAtIndex:selectedRow] valueForKey:@"countPayment"] forKey:@"cashPayments"];
    [[NSUserDefaults standardUserDefaults] setObject:[[[[dictAllItems objectAtIndex:selectedSection] objectForKey:@"main"] objectAtIndex:selectedRow] valueForKey:@"swishPayment"] forKey:@"swishPayment"];
    [[NSUserDefaults standardUserDefaults] setObject:[[[[dictAllItems objectAtIndex:selectedSection] objectForKey:@"main"] objectAtIndex:selectedRow] valueForKey:@"otherPayment"] forKey:@"otherPayment"];
    [[NSUserDefaults standardUserDefaults] setObject:[[[[dictAllItems objectAtIndex:selectedSection] objectForKey:@"main"] objectAtIndex:selectedRow] valueForKey:@"cardPayment"] forKey:@"cardPayments"];
    
    
    
    int i = [[[[[dictAllItems objectAtIndex:selectedSection] objectForKey:@"main"] objectAtIndex:selectedRow] valueForKey:@"countPayment"]intValue] + [[[[[dictAllItems objectAtIndex:selectedSection] objectForKey:@"main"] objectAtIndex:selectedRow] valueForKey:@"cardPayment"] intValue] + [[[[[dictAllItems objectAtIndex:selectedSection] objectForKey:@"main"] objectAtIndex:selectedRow] valueForKey:@"swishPayment"]intValue] + [[[[[dictAllItems objectAtIndex:selectedSection] objectForKey:@"main"] objectAtIndex:selectedRow] valueForKey:@"otherPayment"]intValue];
       
    labelQuantity.text = [NSString stringWithFormat:@"%i", i];
    float sumnewCard=0.00;
    float sumnewCash=0.00;
    float sumnewSwish=0.00;
    float sumnewOther=0.00;
    

    sumnewCard = [[[[[dictAllItems objectAtIndex:selectedSection] objectForKey:@"main"] objectAtIndex:selectedRow] valueForKey:@"totaldiscountCard"] floatValue];

    sumnewCash = [[[[[dictAllItems objectAtIndex:selectedSection] objectForKey:@"main"] objectAtIndex:selectedRow] valueForKey:@"totaldiscountCash"] floatValue];

    sumnewSwish = [[[[[dictAllItems objectAtIndex:selectedSection] objectForKey:@"main"] objectAtIndex:selectedRow] valueForKey:@"totaldiscountSwish"] floatValue];
    
    sumnewOther = [[[[[dictAllItems objectAtIndex:selectedSection] objectForKey:@"main"] objectAtIndex:selectedRow] valueForKey:@"totaldiscountOther"] floatValue];
    
    
    
    float sumnew = [[[[[dictAllItems objectAtIndex:selectedSection] objectForKey:@"main"] objectAtIndex:selectedRow] valueForKey:@"totaldiscount"] floatValue];
    
    
    
    stringDateTime = [NSString stringWithFormat:@"%@",[[[[dictAllItems objectAtIndex:selectedSection] objectForKey:@"main"] objectAtIndex:selectedRow] valueForKey:@"totaldatetime"]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd-MMMM-yyyy, hh:mm a"];
    
    NSDate *cuDate=[dateFormatter dateFromString:stringDateTime];
    
    [dateFormatter setDateFormat:@"dd MMMM yyyy"];
    
    
    currentDate = [dateFormatter stringFromDate:cuDate];
    
    
    [self CurrentDateRefund];
    
    
//    labelDiscount.text = @"";
//    labelDiscount.text = [NSString stringWithFormat:@"-%@ %.02f",currencySign, sumnew];
    
    labelTotal.text = [NSString stringWithFormat:@"%@ %.02f",currencySign,[[[[[dictAllItems objectAtIndex:selectedSection] objectForKey:@"main"] objectAtIndex:selectedRow] valueForKey:@"totalSum"] floatValue]-sumnew];

    
    NSMutableDictionary *dict1 = [[NSMutableDictionary alloc]initWithDictionary:[ary_DetailList objectAtIndex:0]];
    [dict1 setObject:[NSString stringWithFormat:@"%@ %@ ",[[[[dictAllItems objectAtIndex:selectedSection] objectForKey:@"main"] objectAtIndex:selectedRow] valueForKey:@"cardPayment"],[Language get:@"Card payments" alter:@"!Card payments"]] forKey:@"title"];
    [dict1 setObject:[NSString stringWithFormat:@"%@ %.02f",currencySign,[[[[[dictAllItems objectAtIndex:selectedSection] objectForKey:@"main"] objectAtIndex:selectedRow] valueForKey:@"totalSumCard"] floatValue]-sumnewCard] forKey:@"value"];
    [ary_DetailList replaceObjectAtIndex:0 withObject:dict1];
    
    
    NSMutableDictionary *dict2 = [[NSMutableDictionary alloc]initWithDictionary:[ary_DetailList objectAtIndex:1]];
    [dict2 setObject:[NSString stringWithFormat:@"%@ %@ ",[[[[dictAllItems objectAtIndex:selectedSection] objectForKey:@"main"] objectAtIndex:selectedRow] valueForKey:@"countPayment"],[Language get:@"Cash payments" alter:@"!Cash payments"]] forKey:@"title"];
    [dict2 setObject:[NSString stringWithFormat:@"%@ %.02f",currencySign,[[[[[dictAllItems objectAtIndex:selectedSection] objectForKey:@"main"] objectAtIndex:selectedRow] valueForKey:@"totalSumCash"] floatValue]-sumnewCash] forKey:@"value"];
    [ary_DetailList replaceObjectAtIndex:1 withObject:dict2];
    
    
    NSMutableDictionary *dict3 = [[NSMutableDictionary alloc]initWithDictionary:[ary_DetailList objectAtIndex:2]];
    [dict3 setObject:[NSString stringWithFormat:@"%@ %@ ",[[[[dictAllItems objectAtIndex:selectedSection] objectForKey:@"main"] objectAtIndex:selectedRow] valueForKey:@"swishPayment"],[Language get:@"Swish payments" alter:@"!Swish payments"]] forKey:@"title"];
    [dict3 setObject:[NSString stringWithFormat:@"%@ %.02f",currencySign,[[[[[dictAllItems objectAtIndex:selectedSection] objectForKey:@"main"] objectAtIndex:selectedRow] valueForKey:@"totalSumSwish"] floatValue]-sumnewSwish] forKey:@"value"];
    [ary_DetailList replaceObjectAtIndex:2 withObject:dict3];
    
    
    NSMutableDictionary *dict4 = [[NSMutableDictionary alloc]initWithDictionary:[ary_DetailList objectAtIndex:3]];
    [dict4 setObject:[NSString stringWithFormat:@"%@ %@ ",[[[[dictAllItems objectAtIndex:selectedSection] objectForKey:@"main"] objectAtIndex:selectedRow] valueForKey:@"otherPayment"],[Language get:@"Other payments" alter:@"!Other payments"]] forKey:@"title"];
    [dict4 setObject:[NSString stringWithFormat:@"%@ %.02f",currencySign,[[[[[dictAllItems objectAtIndex:selectedSection] objectForKey:@"main"] objectAtIndex:selectedRow] valueForKey:@"totalSumOther"] floatValue]-sumnewOther] forKey:@"value"];
    [ary_DetailList replaceObjectAtIndex:3 withObject:dict4];
    
    
    NSMutableDictionary *dict5 = [[NSMutableDictionary alloc]initWithDictionary:[ary_DetailList objectAtIndex:4]];
    [dict5 setObject:[NSString stringWithFormat:@"%@ %@",[[appDelegate.arrayGlobalData objectAtIndex:0] valueForKey:@"originalMail"], [Language get:@"Receipt email" alter:@"Receipt email"]] forKey:@"title"];
    [dict5 setObject:[NSString stringWithFormat:@"%@ %@",[[appDelegate.arrayGlobalData objectAtIndex:0] valueForKey:@"copyMail"], [Language get:@"Copies email" alter:@"Receipt email"]] forKey:@"value"];
    [ary_DetailList replaceObjectAtIndex:4 withObject:dict5];
    
    
    NSString *str = [[[[dictAllItems objectAtIndex:selectedSection] objectForKey:@"main"] objectAtIndex:selectedRow] valueForKey:@"refundTotal"];
    str = [str stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    NSMutableDictionary *dict6 = [[NSMutableDictionary alloc]initWithDictionary:[ary_DetailList objectAtIndex:5]];
    [dict6 setObject:[NSString stringWithFormat:@"%@ %@",[[[[dictAllItems objectAtIndex:selectedSection] objectForKey:@"main"] objectAtIndex:selectedRow] valueForKey:@"refundCount"],[Language get:@"Refund" alter:@"!Refund"]] forKey:@"title"];
    [dict6 setObject:[NSString stringWithFormat:@"-%@ %@", currencySign, str] forKey:@"value"];
    [ary_DetailList replaceObjectAtIndex:5 withObject:dict6];
    
    
    NSMutableDictionary *dict7 = [[NSMutableDictionary alloc]initWithDictionary:[ary_DetailList objectAtIndex:6]];
    [dict7 setObject:[NSString stringWithFormat:@"-%@ %.02f",currencySign, sumnew] forKey:@"value"];
    [ary_DetailList replaceObjectAtIndex:6 withObject:dict7];
    
    
    NSMutableDictionary *dict8 = [[NSMutableDictionary alloc]initWithDictionary:[ary_DetailList objectAtIndex:7]];
    [dict8 setObject:[NSString stringWithFormat:@"%@ %@",[[appDelegate.arrayGlobalData objectAtIndex:0] valueForKey:@"originalPrint"],[Language get:@"Receipt print" alter:@"Receipt print"]] forKey:@"title"];
    [dict8 setObject:[NSString stringWithFormat:@"%@ %@",[[appDelegate.arrayGlobalData objectAtIndex:0] valueForKey:@"copyPrint"],[Language get:@"Copies print" alter:@"Receipt print"]] forKey:@"value"];
    [ary_DetailList replaceObjectAtIndex:7 withObject:dict8];
    
    
    NSMutableDictionary *dict12 = [[NSMutableDictionary alloc]initWithDictionary:[ary_DetailList objectAtIndex:11]];
    [dict12 setObject:[NSString stringWithFormat:@"%@ %@",[[[[dictAllItems objectAtIndex:selectedSection] objectForKey:@"main"] objectAtIndex:selectedRow] valueForKey:@"proCount"], [Language get:@"Products" alter:@"Products"]] forKey:@"title"];
    [ary_DetailList replaceObjectAtIndex:11 withObject:dict12];
    
    
    
    
    
//    labelCashPaymentValue.text = [NSString stringWithFormat:@"%@ %.02f",currencySign,[[[[[dictAllItems objectAtIndex:selectedSection] objectForKey:@"main"] objectAtIndex:selectedRow] valueForKey:@"totalSumCash"] floatValue]-sumnewCash];
//    
//    labelCardPaymentValue.text = [NSString stringWithFormat:@"%@ %.02f",currencySign,[[[[[dictAllItems objectAtIndex:selectedSection] objectForKey:@"main"] objectAtIndex:selectedRow] valueForKey:@"totalSumCard"] floatValue]-sumnewCard];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%.02f",[[[[[dictAllItems objectAtIndex:selectedSection] objectForKey:@"main"] objectAtIndex:selectedRow] valueForKey:@"totalSumCash"] floatValue]-sumnewCash] forKey:@"totalSumCash"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%.02f",[[[[[dictAllItems objectAtIndex:selectedSection] objectForKey:@"main"] objectAtIndex:selectedRow] valueForKey:@"totalSumCard"] floatValue]-sumnewCard] forKey:@"totalSumCard"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%.02f",[[[[[dictAllItems objectAtIndex:selectedSection] objectForKey:@"main"] objectAtIndex:selectedRow] valueForKey:@"totalSumSwish"] floatValue]-sumnewCash] forKey:@"totalSumSwish"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%.02f",[[[[[dictAllItems objectAtIndex:selectedSection] objectForKey:@"main"] objectAtIndex:selectedRow] valueForKey:@"totalSumOther"] floatValue]-sumnewCard] forKey:@"totalSumOther"];
    
    
//    self.grandTotSaleValue.text= [NSString stringWithFormat:@"-%@ %.02f",currencySign,[[[[[dictAllItems objectAtIndex:selectedSection] objectForKey:@"main"] objectAtIndex:selectedRow] valueForKey:@"totalSum"] floatValue]-sumnew];
//    
//    
//    labelRefund.text = [NSString stringWithFormat:@"%@ %@",[[[[dictAllItems objectAtIndex:selectedSection] objectForKey:@"main"] objectAtIndex:selectedRow] valueForKey:@"refundCount"],
//                        
//    labelRefund.text = [Language get:@"Refund" alter:@"!Refund"]];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@ %.02f",currencySign,[[[[[dictAllItems objectAtIndex:selectedSection] objectForKey:@"main"] objectAtIndex:selectedRow] valueForKey:@"totalSum"] floatValue]-sumnew] forKey:@"cashPayment"];
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"-%@ %.02f",currencySign,sumnew] forKey:@"totaldiscount"];
    
    
//    labelRefundTotal.text = [NSString stringWithFormat:@"-%@ %@", currencySign, str];
//    
//    
//    self.grandRefundValue.text = [NSString stringWithFormat:@"%@ %@", currencySign, str];
    
    
    
 //   self.grandSaleRefundValue.text=[NSString stringWithFormat:@"-%.02f",sumGrandTotal-sumGrandRefund];
    
    
   
    [self GrandTotal];
    
//    self.lbl_Products.text=[NSString stringWithFormat:@"%@ %@",[[[[dictAllItems objectAtIndex:selectedSection] objectForKey:@"main"] objectAtIndex:selectedRow] valueForKey:@"proCount"], [Language get:@"Products" alter:@"Products"]];
    
//    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%lu",(unsigned long)objects.count] forKey:@"productCount"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",[[[[dictAllItems objectAtIndex:selectedSection] objectForKey:@"main"] objectAtIndex:selectedRow] valueForKey:@"proCount"]] forKey:@"productCount"];
    
    
    if (dictAllItems.count>0) {
        self.btnMailReceipt.hidden=NO;
        self.btnPrintReceipt.hidden=NO;
    }
    
    [appDelegate fetch_globalData];
    
    [collectionView_ReportDetail reloadData];

//    self.lbl_Emailed.text = [NSString stringWithFormat:@"%@ %@",[[appDelegate.arrayGlobalData objectAtIndex:0] valueForKey:@"originalMail"], [Language get:@"Receipt email" alter:@"Receipt email"]];
//    
//    self.lbl_Printed.text = [NSString stringWithFormat:@"%@ %@",[[appDelegate.arrayGlobalData objectAtIndex:0] valueForKey:@"originalPrint"],[Language get:@"Receipt print" alter:@"Receipt print"]];
//    
//    self.labelCopiesEmail.text = [NSString stringWithFormat:@"%@ %@",[[appDelegate.arrayGlobalData objectAtIndex:0] valueForKey:@"copyMail"], [Language get:@"Copies email" alter:@"Receipt email"]];
//    
//    self.labelCopiesPrint.text = [NSString stringWithFormat:@"%@ %@",[[appDelegate.arrayGlobalData objectAtIndex:0] valueForKey:@"copyPrint"],[Language get:@"Copies print" alter:@"Receipt print"]];
//    
//    labelRefund.text = [NSString stringWithFormat:@"%@ %@",[[appDelegate.arrayGlobalData objectAtIndex:0] valueForKey:@"refundZDay"],labelRefund.text = [Language get:@"Refund" alter:@"!Refund"]];
//    
//    self.lbl_Grandrefund.text = [NSString stringWithFormat:@"%@ %@",[[appDelegate.arrayGlobalData objectAtIndex:0] valueForKey:@"refund"],[Language get:@"Grand total refund" alter:@"!Grand total refund"]];
    
}

#pragma mark -------------------- Segment Value changed -----------------------
-(IBAction)sengmentcontrolValueChanged:(id)sender
{
    
    [self getVatarray];
    
    UISegmentedControl *segmentControl =(UISegmentedControl *)sender;
    
    if(segmentControl.selectedSegmentIndex==0)
    {
        btn_Exchange.hidden = YES;
        
        genrateZDay=NO;
        appDelegate.arrayZDayReport=nil;
        [[NSUserDefaults standardUserDefaults] setObject:@"Day" forKey:@"Report_Type"];
       
        [self getDataDayWise:selectedDate];
        NSDate *cuDate=[NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"dd MMMM yyyy"];
        currentDate = [dateFormatter stringFromDate:cuDate];
        selectedDate=[NSDate date];
        [self CurrentDateRefund];
    }
    else if(segmentControl.selectedSegmentIndex==1)
    {
        btn_Exchange.hidden = YES;
        
        genrateZDay=NO;
        appDelegate.arrayZDayReport=nil;
        [[NSUserDefaults standardUserDefaults] setObject:@"Month" forKey:@"Report_Type"];
        
        [self getDataMonthWise];
        
        
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *comp = [gregorian components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:[NSDate date]];
        [comp setDay:1];
        NSDate *firstDayOfMonthDate1 = [gregorian dateFromComponents:comp];
      
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear
                                                                       fromDate:[NSDate date]];
        components.day = 1;
        NSDate *firstDayOfMonthDate = [[NSCalendar currentCalendar] dateFromComponents: components];

        NSDate *cuDate=firstDayOfMonthDate;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"dd MMMM yyyy"];
        currentDate = [dateFormatter stringFromDate:firstDayOfMonthDate];
        
   
        NSDate *curDate = [NSDate date];
        NSCalendar* calendar = [NSCalendar currentCalendar];
        NSDateComponents* comps = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSWeekCalendarUnit|NSWeekdayCalendarUnit fromDate:curDate]; // Get necessary date components
        
        // set last of month
        [comps setMonth:[comps month]+1];
        [comps setDay:0];
        NSDate *tDateMonth = [calendar dateFromComponents:comps];
      
        
        selectedDate=tDateMonth;

    }
    else
    {
        btn_Exchange.hidden = NO;
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",[Language get:@"Z-REPORT" alter:@"!Z-REPORT"]] forKey:@"repType"];
        
        genrateZDay=YES;
        
        self.btnGenerateZDay.hidden = NO;
        self.viewBaseTopSelling.hidden = YES;
        tableViewItems.hidden = YES;
        self.labelReportNumber.hidden = NO;
        
        [[NSUserDefaults standardUserDefaults] setObject:@"Day" forKey:@"Report_Type"];
        
        //        [self getDataDayWise:selectedDate];
        
        [self getZDayData];
        [self fetch_ZdayData];
        
        [self viewZdayData:selectedRow];
    }
    
    
    [maintablev reloadData];
    [maintablev selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:0];
    
 
}





-(void)getDataMonthWise
{
    
    self.dayMonthSegmentBtn.selectedSegmentIndex = 1;
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",[Language get:@"Month Report" alter:@"Month Report"]] forKey:@"repType"];
    
    self.btnGenerateZDay.hidden = YES;
    self.viewBaseTopSelling.hidden = NO;
    tableViewItems.hidden = NO;
    self.labelReportNumber.hidden = YES;
    dictAllItems = [NSMutableArray new];
    
    str_datefrom=@"Month";
    NSString *str_IDs=@"";
    
    //    labelFirstProductQntity.layer.cornerRadius = 11.0f;
    //    labelSecondProductQntity.layer.cornerRadius = 11.0f;
    
    NSMutableArray *arraySub = [NSMutableArray new];
    NSMutableDictionary *dictSubbM = [NSMutableDictionary new];
    NSMutableArray *arrayMain = [NSMutableArray new];
    
    NSString *curMonth = nil;
    NSString *curDay = nil;
    NSString *curDayE=nil;
    
    
    NSString *totaldatetime = nil;
    NSString *totaldate=nil;
    
    
    
    float tpricewithoutvat = 0.0;
    int countPayment = 0;
    int swishPayment = 0;
    int otherPayment = 0;
    int cardPayment = 0;
    
    int curId=-1;
    
    total=0.0;
    totalvat=0.0;
    float totalSum=0.0;
    float totalSumCash=0.0;
    float totalSumCard=0.0;
    float totalSumSwish=0.0;
    float totalSumOther=0.0;
    
    int totalProCount=0;
    int proCount=0;
    
    NSManagedObjectContext *context =[appDelegate managedObjectContext];
    NSEntityDescription *entityDesc =[NSEntityDescription entityForName:@"Trasections" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    
    NSArray *descriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:descriptors];
    
    
    NSEntityDescription *entityDesc2 =[NSEntityDescription entityForName:@"CustomDiscount" inManagedObjectContext:context];
    NSFetchRequest *request11 = [[NSFetchRequest alloc] init];
    [request11 setEntity:entityDesc2];
    //    NSPredicate *predicate;
    
    
    NSError *error;
    
    NSArray *objects = [context executeFetchRequest:request error:&error];
    
    int sum=0;
    
    NSArray *objects2;
    
    NSMutableDictionary *dictSub;
    
    for(int i=0;i<objects.count;i++)
    {
        //        NSMutableDictionary *dictMain = [NSMutableDictionary new];
        dictSub = [NSMutableDictionary new];
        
        
        NSManagedObject *person = (NSManagedObject *)[objects objectAtIndex:i];
        
        NSData *da=[person valueForKey:@"image"];
        
        UIImage *img=[[UIImage alloc] initWithData:da];
        
        [dictSub setObject:img forKey:@"image"];
        [dictSub setObject:[person valueForKey:@"name"] forKey:@"name"];
        [dictSub setObject:[person valueForKey:@"count"] forKey:@"count"];
        
        float newPrice = [[person valueForKey:@"price"] floatValue];// - [[person valueForKey:@"discount"] floatValue];
        
        [dictSub setObject:[NSString stringWithFormat:@"%f",newPrice] forKey:@"price"];
        [dictSub setObject:[person valueForKey:@"vat"] forKey:@"vat"];
        [dictSub setObject:[person valueForKey:@"discount"] forKey:@"discount"];
        [dictSub setObject:[person valueForKey:@"id"] forKey:@"id"];
        [dictSub setObject:[CommonMethods validateDictionaryValueForKey:[person valueForKey:@"discription"]]?[person valueForKey:@"discription"]:@"" forKey:@"discription"];
       // [dictSub setObject:[person valueForKey:@"discription"] forKey:@"discription"];
        [dictSub setObject:[person valueForKey:@"paymentMethod"] forKey:@"paymentMethod"];
        
        
        _str_paymentMethod = [NSString stringWithFormat:@"%@",[person valueForKey:@"paymentMethod"]];

        
        
        NSDate *date  = [person valueForKey:@"date"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        // Convert date object into desired format
        [dateFormatter setDateFormat:@"yyyy"];
        NSString *newDateString = [dateFormatter stringFromDate:date];
        [dictSub setObject:newDateString forKey:@"month"];
        
        [dateFormatter setDateFormat:@"MM"];
        NSString *day =[dateFormatter stringFromDate:date];
        
        
        [dateFormatter setDateFormat:@"MMMM"];
        NSString *dayE = [dateFormatter stringFromDate:date];
        
        NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
        // Convert date object into desired format
        [dateFormatter1 setDateFormat:@"dd-MMMM-yyyy, hh:mm a"];
        
        NSString *tdatetime = [dateFormatter1 stringFromDate:date];
        
        
        NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
        // Convert date object into desired format
        [dateFormatter2 setDateFormat:@"dd MMMM yyyy"];
        
        NSString *tDate = [dateFormatter2 stringFromDate:date];
        
        
        total=([[person valueForKey:@"price"] floatValue] *[[person valueForKey:@"count"] integerValue]-[[person valueForKey:@"discount"]floatValue]) + total;
        
        
        //        zzzz = (([[person valueForKey:@"price"] floatValue]*[[person valueForKey:@"count"] integerValue])-[[person valueForKey:@"discount"]floatValue]) / (1 + [[person valueForKey:@"vat"] floatValue]/100);
        //        zzzz=(([[person valueForKey:@"price"] floatValue] *[[person valueForKey:@"count"] integerValue])-[[person valueForKey:@"discount"]floatValue])-zzzz;
        
        //        zzzz=(([[person valueForKey:@"price"] floatValue]*[[person valueForKey:@"count"] integerValue]-[[person valueForKey:@"discount"]floatValue])  *[[person valueForKey:@"vat"] floatValue])/100;
        //        zzzz=(([[person valueForKey:@"price"] floatValue] *[[person valueForKey:@"count"] integerValue])-[[person valueForKey:@"discount"]floatValue])-zzzz;
        
        //        totalvat = zzzz  + totalvat;
        
        
        // [dictSub setObject:[NSString stringWithFormat:@"%ld", (long)total] forKey:@"price"];
        
        
        if(curDay == nil)
        {
            
            NSArray* ary_ID = [str_IDs componentsSeparatedByString: @","];
            
            
            if ([ary_ID count]>0)
            {
                if (![ary_ID containsObject:[NSString stringWithFormat:@"%@",[person valueForKey:@"id"]]])
                {
                    str_IDs = [NSString stringWithFormat:@"%@,%@",str_IDs,[person valueForKey:@"id"]];
                }
            }
            
            
            if ([_str_paymentMethod isEqualToString:@"1"]){
                countPayment =1;
            }
            else if ([_str_paymentMethod isEqualToString:@"2"]) {
                cardPayment =1;
            }
            else if ([_str_paymentMethod isEqualToString:@"3"]){
                swishPayment =1;
            }
            else if ([_str_paymentMethod isEqualToString:@"4"]){
                otherPayment =1;
            }
            
            curDay = day;
            curDayE = dayE;
            curId =  [[person valueForKey:@"id"] intValue];
            totaldate=tDate;
            totaldatetime = tdatetime;
        }
        
        else if (![curDay isEqualToString:day])
        {
            
            
            int refundCount = 0 ;
            float totalammount = 0;
            
            NSManagedObjectContext *context =
            [appDelegate managedObjectContext];
            
            NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"RefundAmount"
                                                          inManagedObjectContext:context];
            
            NSFetchRequest *request = [[NSFetchRequest alloc] init];
            [request setEntity:entityDesc];
            
            //            NSPredicate *pred =
            //            [NSPredicate predicateWithFormat:@"(date = %@)",totaldate];
            //            [request setPredicate:pred];
            //    NSManagedObject *matches = nil;
            
            NSError *error;
            NSArray *objects = [context executeFetchRequest:request
                                                      error:&error];
            
            NSString *compareDate = [totaldate substringFromIndex:3];
            
            for (NSManagedObject *personRefund in objects)
            {
                
                NSString *refundDate = [personRefund valueForKey:@"date"];
                NSString *refundMonth = [refundDate substringFromIndex:3];
                
                if([refundMonth isEqualToString:compareDate])
                {
                    refundCount ++;
                    //                    totalammount = totalammount + [[personRefund valueForKey:@"totalAmount"] floatValue];
                    totalammount =  [[personRefund valueForKey:@"totalAmount"] floatValue];
                }
            }
            
            
            if ([str_IDs hasPrefix:@","])
            {
                str_IDs = [str_IDs substringFromIndex:1];
            }
            
            float discount = [self GetDiscountList:str_IDs];
            
            
            float totalPrice = 0.0;
            float vat = 0.0;
            float vatPercent = (totalvat*100)/tpricewithoutvat;
            
            if ([str_DiscountType isEqualToString:@"$"])
            {
                
                totalPrice = totalSum - discount;
                
            }
            else
            {
                totalPrice = totalSum - ((totalSum*discount)/100);
                
            }
            
            
            vat = totalPrice-(totalPrice/(1+vatPercent/100));
            
            
            
            float discountCard = 0.0;
            float discountCash = 0.0;
            
            NSManagedObjectContext *contextCustomDiscount =[appDelegate managedObjectContext];
            
            
            NSEntityDescription *entityDesc2 =[NSEntityDescription entityForName:@"CustomDiscount" inManagedObjectContext:contextCustomDiscount];
            NSFetchRequest *request11 = [[NSFetchRequest alloc] init];
            [request11 setEntity:entityDesc2];
            NSError *error2;
            NSArray *objects2 = [contextCustomDiscount executeFetchRequest:request11 error:&error2];
            
            NSManagedObject *person2;
            
            float sumnew=0.0;
            float sumnewCash=0.0;
            float sumnewCard=0.0;
            
            for(int i=0;i<objects2.count;i++)
            {
                
                //                NSArray* ary_ID = [IDs componentsSeparatedByString: @","];
                
                
                str_DiscountType = @"$";
                
                
                person2 = (NSManagedObject *)[objects2 objectAtIndex:i];
                
                
                NSDate *date  = [person2 valueForKey:@"date"];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"MMMM"];
                NSString *discountDateTime = [dateFormatter stringFromDate:date];
               
                
                if ([dayE isEqualToString:discountDateTime]) {
                    
         
                    _str_paymentMethod = [NSString stringWithFormat:@"%@",[person2 valueForKey:@"paymentMethod"]];
                    
//                    if ([[person2 valueForKey:@"paymentMethod"] isEqualToString:@"2"]) {
//                        
//                        _str_paymentMethod = @"2";
//                    }
//                    else{
//                        _str_paymentMethod = @"1";
//                    }
                    
                    if ([_str_paymentMethod isEqualToString:@"2"]) {
                        
                        //                            discountCard = [self GetDiscountList:str_IDs];
                        discountCard = [[person2 valueForKey:@"discount"] floatValue]+discountCard;
                        
                    }
                    else
                    {
                        
                        //                            discountCash= [self GetDiscountList:str_IDs];
                        discountCash = [[person2 valueForKey:@"discount"] floatValue]+discountCash;
                        
                    }
                    
                }
                
                
            }
            
            
            
            
            NSMutableDictionary *dictSubb = [NSMutableDictionary new];
            [dictSubb setObject:curDay forKey:@"day"];
            [dictSubb setObject:curDayE forKey:@"dayE"];
            [dictSubb setObject:dictSubbM forKey:@"sub"];
            [dictSubb setObject:[NSString stringWithFormat:@"%d",countPayment] forKey:@"countPayment"];
            [dictSubb setObject:[NSString stringWithFormat:@"%d",swishPayment] forKey:@"swishPayment"];
            [dictSubb setObject:[NSString stringWithFormat:@"%d",otherPayment] forKey:@"otherPayment"];
            [dictSubb setObject:[NSString stringWithFormat:@"%d",cardPayment] forKey:@"cardPayment"];
            [dictSubb setObject:[NSString stringWithFormat:@"%f",totalSum] forKey:@"totalSum"];
            [dictSubb setObject:[NSString stringWithFormat:@"%f",totalSumCash] forKey:@"totalSumCash"];
            [dictSubb setObject:[NSString stringWithFormat:@"%f",totalSumCard] forKey:@"totalSumCard"];
            [dictSubb setObject:[NSString stringWithFormat:@"%f",totalSumSwish] forKey:@"totalSumSwish"];
            [dictSubb setObject:[NSString stringWithFormat:@"%f",totalSumOther] forKey:@"totalSumOther"];
            [dictSubb setObject:[NSString stringWithFormat:@"%f",vat] forKey:@"totalvat"];
            [dictSubb setObject:[NSString stringWithFormat:@"%d",refundCount] forKey:@"refundCount"];
            [dictSubb setObject:[NSString stringWithFormat:@"%.2f",totalammount] forKey:@"refundTotal"];
            [dictSubb setObject:totaldatetime forKey:@"totaldatetime"];
            [dictSubb setObject:str_IDs forKey:@"finalid"];
            [dictSubb setObject:[NSString stringWithFormat:@"%.2f",discount] forKey:@"totaldiscount"];
            [dictSubb setObject:[NSString stringWithFormat:@"%.2f",discountCash] forKey:@"totaldiscountCash"];
            [dictSubb setObject:[NSString stringWithFormat:@"%.2f",discountCash] forKey:@"totaldiscountSwish"];
            [dictSubb setObject:[NSString stringWithFormat:@"%.2f",discountCash] forKey:@"totaldiscountOther"];
            [dictSubb setObject:[NSString stringWithFormat:@"%.2f",discountCard] forKey:@"totaldiscountCard"];
            [dictSubb setObject:[NSString stringWithFormat:@"%d",totalProCount] forKey:@"proCount"];
            [dictSubb setObject:_str_paymentMethod forKey:@"paymentMethod"];
            
            totalProCount=0;
            proCount=0;
            [dictSubb setObject:totaldate forKey:@"totaldate"];
            [arraySub addObject:dictSubb];
            
            total = 0;
            totalvat = 0;
            str_IDs = @"";
            tpricewithoutvat = 0;
            totalSum = 0;
            sum = 0;
            dictSubbM = [NSMutableDictionary new];
            totaldate=tDate;
            totaldatetime = tdatetime;
            countPayment=0;
            swishPayment = 0;
            otherPayment = 0;
            cardPayment=0;
            curDay = day;
            curDayE = dayE;
            
            totalSumCash = 0;
            totalSumCard = 0;
            totalSumSwish = 0;
            totalSumOther = 0;
        }
        else
        {
            
            if(curId!=[[person valueForKey:@"id"] intValue])
            {
                
                if ([_str_paymentMethod isEqualToString:@"1"]) {
                    countPayment++;
                }
                else if ([_str_paymentMethod isEqualToString:@"2"])
                {
                    cardPayment++;
                }
                else if ([_str_paymentMethod isEqualToString:@"3"])
                {
                    swishPayment++;
                }
                else if ([_str_paymentMethod isEqualToString:@"4"])
                {
                    otherPayment++;
                }
                
            }
            
            
            NSArray* ary_ID = [str_IDs componentsSeparatedByString: @","];
            
            
            if ([ary_ID count]>0)
            {
                if (![ary_ID containsObject:[NSString stringWithFormat:@"%@",[person valueForKey:@"id"]]])
                {
                    str_IDs = [NSString stringWithFormat:@"%@,%@",str_IDs,[person valueForKey:@"id"]];
                }
            }
        }
        
        
        if(curMonth==nil)
            curMonth = newDateString;
        else if (![curMonth isEqualToString:newDateString])
        {
            
            NSMutableDictionary *dictMain = [NSMutableDictionary new];
            [dictMain setObject:curMonth forKey:@"month"];
            [dictMain setObject:arraySub forKey:@"main"];
            [arrayMain addObject:dictMain];
            
            
            arraySub = [NSMutableArray new];
            curMonth = newDateString;
            currentDate=newDateString;
        }
        
        
        if(curId!=[[person valueForKey:@"id"] intValue])
        {
            //            countPayment++;
            curId=[[person valueForKey:@"id"] intValue];
        }
        
        
        
        NSPredicate *predicate;
        predicate = [NSPredicate predicateWithFormat:@"(id = %@)", [person valueForKey:@"id"]];
        [request11 setPredicate:predicate];
        NSError *error2;
        objects2 = [context executeFetchRequest:request11 error:&error2];
        
        NSManagedObject *person2;
        
        for(int i=0;i<objects2.count;i++)
        {
            person2 = (NSManagedObject *)[objects2 objectAtIndex:i];
            
            [dictSub setObject:[person2 valueForKey:@"discount"] forKey:@"customdiscount"];
            
            //            if (![[person2 valueForKey:@"type"] isEqualToString:@"%"])
            //                [dictSub setObject:@"%%" forKey:@"type"];
            //            else
            //                [dictSub setObject:[person2 valueForKey:@"type"] forKey:@"type"];
        }
        
        
//        total=([[person valueForKey:@"price"] floatValue] *[[person valueForKey:@"count"] integerValue])-[[person valueForKey:@"discount"]floatValue] ;
        
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
        
        zzzz = (([[person valueForKey:@"price"] floatValue]*[[person valueForKey:@"count"] integerValue])-[[person valueForKey:@"discount"]floatValue]) / (1 + [[person valueForKey:@"vat"] floatValue]/100);
        
        zzzz=(([[person valueForKey:@"price"] floatValue] *[[person valueForKey:@"count"] integerValue])-[[person valueForKey:@"discount"]floatValue])-zzzz;
        
        totalvat = zzzz  + totalvat;
        
        proCount=[[person valueForKey:@"count"] intValue];
        
        totalProCount=totalProCount+proCount;
        
        
        tpricewithoutvat = (([[person valueForKey:@"price"] floatValue]*[[person valueForKey:@"count"] integerValue])-[[person valueForKey:@"discount"]floatValue]) / (1 + [[person valueForKey:@"vat"] floatValue]/100) + tpricewithoutvat;
        
        
        //
        float discount = 0;
        total = total - discount;
        totalSum = totalSum + total;
        
        if ([_str_paymentMethod isEqualToString:@"2"]) {
            
            totalSumCard=totalSumCard + total;
            
        }
        else if ([_str_paymentMethod isEqualToString:@"1"])
        {
            totalSumCash=totalSumCash + total;
        }
        else if ([_str_paymentMethod isEqualToString:@"3"])
        {
            totalSumSwish=totalSumSwish + total;
        }
        else if ([_str_paymentMethod isEqualToString:@"4"])
        {
            totalSumOther=totalSumOther + total;
        }
        
        
        if([dictSubbM objectForKey:[dictSub valueForKey:@"name"]])
        {
            
            NSMutableDictionary *dictTemp = [dictSubbM  objectForKey:[dictSub valueForKey:@"name"]];
            int countTemp = [[dictTemp valueForKey:@"count"] intValue] + [[dictSub valueForKey:@"count"] intValue];
            [dictTemp setObject:[NSString stringWithFormat:@"%d",countTemp] forKey:@"count"];
            [dictSubbM setObject:dictTemp forKey:[dictSub valueForKey:@"name"]];
            
        }
        else
        {
            [dictSubbM setObject:dictSub forKey:[dictSub valueForKey:@"name"]];
        }
        
        
        //        for (int i = 0; i<[[[[dictSub valueForKey:@"discount"] valueForKey:@"sub"] objectAtIndex:0] count]; i++)
        //        {
        //            sum += [[[arrayMain valueForKey:@"discount"] objectAtIndex:i]intValue];
        //        }
        sum += [[dictSub valueForKey:@"discount"] intValue];
        
        
    }
    
    if (objects.count != 0)
    {
        
        int refundCount = 0 ;
        float totalammount = 0;
        
        NSManagedObjectContext *context =
        [appDelegate managedObjectContext];
        
        NSEntityDescription *entityDesc =
        [NSEntityDescription entityForName:@"RefundAmount"
                    inManagedObjectContext:context];
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entityDesc];
        
        //            NSPredicate *pred =
        //            [NSPredicate predicateWithFormat:@"(date = %@)",totaldate];
        //            [request setPredicate:pred];
        //    NSManagedObject *matches = nil;
        
        NSError *error;
        NSArray *objects = [context executeFetchRequest:request
                                                  error:&error];
        
        
        
        NSString *compareDate = [totaldate substringFromIndex:3];
        for (NSManagedObject *personRefund in objects)
        {
            
            NSString *refundDate = [personRefund valueForKey:@"date"];
            NSString *refundMonth = [refundDate substringFromIndex:3];
            
            if([refundMonth isEqualToString:compareDate])
            {
                refundCount ++;
                totalammount = totalammount + [[personRefund valueForKey:@"totalAmount"] floatValue];
            }
        }
        
        
        if ([str_IDs hasPrefix:@","])
        {
            str_IDs = [str_IDs substringFromIndex:1];
        }
        
        float discount = [self GetDiscountList:str_IDs];

        
        
//        if ([_str_paymentMethod isEqualToString:@"2"]) {
//            
//            discountCard = [self GetDiscountList:str_IDs];
//            
//        }
//        else
//        {
//            discountCash= [self GetDiscountList:str_IDs];
//            
//        }
        
        float totalPrice = 0.0;
        float vat = 0.0;
        float vatPercent = (totalvat*100)/tpricewithoutvat;
        
        if ([str_DiscountType isEqualToString:@"$"])
        {
            
            totalPrice = totalSum - discount;
            
        }
        else
        {
            totalPrice = totalSum - ((totalSum*discount)/100);
            
        }
        vat = totalPrice-(totalPrice/(1+vatPercent/100));
        
        
        float discountCard = 0.0;
        float discountCash = 0.0;
        
        NSManagedObjectContext *contextCustomDiscount =[appDelegate managedObjectContext];
        
        
        NSEntityDescription *entityDesc2 =[NSEntityDescription entityForName:@"CustomDiscount" inManagedObjectContext:contextCustomDiscount];
        NSFetchRequest *request11 = [[NSFetchRequest alloc] init];
        [request11 setEntity:entityDesc2];
        NSError *error2;
        NSArray *objects2 = [contextCustomDiscount executeFetchRequest:request11 error:&error2];
        
        NSManagedObject *person2;
        
        float sumnew=0.0;
        float sumnewCash=0.0;
        float sumnewCard=0.0;
        
        for(int i=0;i<objects2.count;i++)
        {
            
            //                NSArray* ary_ID = [IDs componentsSeparatedByString: @","];
            
            
            str_DiscountType = @"$";
            
            
            person2 = (NSManagedObject *)[objects2 objectAtIndex:i];
            
            
            NSDate *date  = [person2 valueForKey:@"date"];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"MMMM"];
            NSString *discountDateTime = [dateFormatter stringFromDate:date];
 
            
            if ([curDayE isEqualToString:discountDateTime]) {
                
                
                _str_paymentMethod = [NSString stringWithFormat:@"%@",[person2 valueForKey:@"paymentMethod"]];
//                if ([[person2 valueForKey:@"paymentMethod"] isEqualToString:@"2"]) {
//                    
//                    _str_paymentMethod = @"2";
//                }
//                else{
//                    _str_paymentMethod = @"1";
//                }
                
                if ([_str_paymentMethod isEqualToString:@"2"]) {
                    
                    //                            discountCard = [self GetDiscountList:str_IDs];
                    discountCard = [[person2 valueForKey:@"discount"] floatValue]+discountCard;
                    
                }
                else
                {
                    
                    //                            discountCash= [self GetDiscountList:str_IDs];
                    discountCash = [[person2 valueForKey:@"discount"] floatValue]+discountCash;
                    
                }
                
            }
            
            
        }
 
        
      
        
        
        
        NSMutableDictionary *dictSubb = [NSMutableDictionary new];
        [dictSubb setObject:curDay forKey:@"day"];
        [dictSubb setObject:dictSubbM forKey:@"sub"];
        [dictSubb setObject:curDayE forKey:@"dayE"];
        [dictSubb setObject:[NSString stringWithFormat:@"%f",totalSum] forKey:@"totalSum"];
        [dictSubb setObject:[NSString stringWithFormat:@"%f",totalSumCash] forKey:@"totalSumCash"];
        [dictSubb setObject:[NSString stringWithFormat:@"%f",totalSumCard] forKey:@"totalSumCard"];
        [dictSubb setObject:[NSString stringWithFormat:@"%f",totalSumSwish] forKey:@"totalSumSwish"];
        [dictSubb setObject:[NSString stringWithFormat:@"%f",totalSumOther] forKey:@"totalSumOther"];
        [dictSubb setObject:[NSString stringWithFormat:@"%d",countPayment] forKey:@"countPayment"];
        [dictSubb setObject:[NSString stringWithFormat:@"%d",cardPayment] forKey:@"cardPayment"];
        [dictSubb setObject:[NSString stringWithFormat:@"%d",swishPayment] forKey:@"swishPayment"];
        [dictSubb setObject:[NSString stringWithFormat:@"%d",otherPayment] forKey:@"otherPayment"];
        [dictSubb setObject:[NSString stringWithFormat:@"%f",vat] forKey:@"totalvat"];
        [dictSubb setObject:totaldatetime forKey:@"totaldatetime"];
        [dictSubb setObject:str_IDs forKey:@"finalid"];
        [dictSubb setObject:totaldate forKey:@"totaldate"];
        [dictSubb setObject:[NSString stringWithFormat:@"%d",refundCount] forKey:@"refundCount"];
        [dictSubb setObject:[NSString stringWithFormat:@"%.2f",totalammount] forKey:@"refundTotal"];
        [dictSubb setObject:[NSString stringWithFormat:@"%.2f",discount] forKey:@"totaldiscount"];
        [dictSubb setObject:[NSString stringWithFormat:@"%.2f",discountCash] forKey:@"totaldiscountCash"];
        [dictSubb setObject:[NSString stringWithFormat:@"%.2f",discountCash] forKey:@"totaldiscountSwish"];
        [dictSubb setObject:[NSString stringWithFormat:@"%.2f",discountCash] forKey:@"totaldiscountOther"];
        [dictSubb setObject:[NSString stringWithFormat:@"%.2f",discountCard] forKey:@"totaldiscountCard"];
        [dictSubb setObject:[NSString stringWithFormat:@"%d",totalProCount] forKey:@"proCount"];
        
        totalProCount=0;
        proCount=0;
        [arraySub addObject:dictSubb];
        
        
//        float totalCashPrice = [[NSString stringWithFormat:@"%f",totalSumCash] floatValue]-[[NSString stringWithFormat:@"%.2f",discountCash] floatValue];
//        
//        float totalCardPrice = [[NSString stringWithFormat:@"%f",totalSumCard] floatValue]-[[NSString stringWithFormat:@"%.2f",discountCard] floatValue];
//        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%0.2f",totalCashPrice] forKey:@"totalSumCash"];
//        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%0.2f",totalCardPrice] forKey:@"totalSumCard"];
//        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",countPayment] forKey:@"cashPayments"];
//        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",cardPayment] forKey:@"cardPayments"];
        
        
        NSMutableDictionary *dictMain = [NSMutableDictionary new];
        [dictMain setObject:curMonth forKey:@"month"];
        [dictMain setObject:arraySub forKey:@"main"];
        [arrayMain addObject:dictMain];
        
        
        str_IDs = @"";
        dictAllItems = arrayMain;
        selectedSection=0;
        sum = 0;
        selectedRow=0;
        [self setMiddlePart];
      
        
    }
    else
    {
        
        NSMutableDictionary *dict1 = [[NSMutableDictionary alloc]initWithDictionary:[ary_DetailList objectAtIndex:0]];
        [dict1 setObject:[NSString stringWithFormat:@"0 %@ ",[Language get:@"Card payments" alter:@"!Card payments"]] forKey:@"title"];
        [dict1 setObject:[NSString stringWithFormat:@"%@ 0.00", currencySign] forKey:@"value"];
        [ary_DetailList replaceObjectAtIndex:0 withObject:dict1];
        
        NSMutableDictionary *dict2 = [[NSMutableDictionary alloc]initWithDictionary:[ary_DetailList objectAtIndex:1]];
        [dict2 setObject:[NSString stringWithFormat:@"0 %@ ",[Language get:@"Cash payments" alter:@"!Cash payments"]] forKey:@"title"];
        [dict2 setObject:[NSString stringWithFormat:@"%@ 0.00", currencySign] forKey:@"value"];
        [ary_DetailList replaceObjectAtIndex:1 withObject:dict2];
        
        NSMutableDictionary *dict3 = [[NSMutableDictionary alloc]initWithDictionary:[ary_DetailList objectAtIndex:2]];
        [dict3 setObject:[NSString stringWithFormat:@"0 %@ ",[Language get:@"Swish payments" alter:@"!Swish payments"]] forKey:@"title"];
        [dict3 setObject:[NSString stringWithFormat:@"%@ 0.00", currencySign] forKey:@"value"];
        [ary_DetailList replaceObjectAtIndex:2 withObject:dict3];
        
        NSMutableDictionary *dict4 = [[NSMutableDictionary alloc]initWithDictionary:[ary_DetailList objectAtIndex:3]];
        [dict4 setObject:[NSString stringWithFormat:@"0 %@ ",[Language get:@"Other payments" alter:@"!Other payments"]] forKey:@"title"];
        [dict4 setObject:[NSString stringWithFormat:@"%@ 0.00", currencySign] forKey:@"value"];
        [ary_DetailList replaceObjectAtIndex:3 withObject:dict4];
        
        NSMutableDictionary *dict6 = [[NSMutableDictionary alloc]initWithDictionary:[ary_DetailList objectAtIndex:5]];
        [dict6 setObject:[NSString stringWithFormat:@"%@ 0.00", currencySign] forKey:@"value"];
        [ary_DetailList replaceObjectAtIndex:5 withObject:dict6];
        
        NSMutableDictionary *dict7 = [[NSMutableDictionary alloc]initWithDictionary:[ary_DetailList objectAtIndex:6]];
        [dict7 setObject:[NSString stringWithFormat:@"%@ 0.00", currencySign] forKey:@"value"];
        [ary_DetailList replaceObjectAtIndex:6 withObject:dict7];
        
        NSMutableDictionary *dict13 = [[NSMutableDictionary alloc]initWithDictionary:[ary_DetailList objectAtIndex:12]];
        [dict13 setObject:[NSString stringWithFormat:@"%@ 0.00", currencySign] forKey:@"value"];
        [ary_DetailList replaceObjectAtIndex:12 withObject:dict13];
        
        [collectionView_ReportDetail reloadData];
        
//        labelCardPaymentValue.text = [NSString stringWithFormat:@"%@ 0.00", currencySign];
//        labelFeeValue.text = [NSString stringWithFormat:@"%@ 0.00", currencySign];
//        labelCashPaymentValue.text = [NSString stringWithFormat:@"%@ 0.00", currencySign];
        
//        labelRefundTotal.text = [NSString stringWithFormat:@"%@ 0.00", currencySign];
        labelTotal.text = [NSString stringWithFormat:@"%@ 0.00", currencySign];
        
//        labelDiscount.text = [NSString stringWithFormat:@"%@ 0.00", currencySign];
        
        //        labelTopSeFirstProduct.text = @"";
        //        labelTopSeSecondProduct.text = @"";
        //        labelTopSeFirstProductQunt.text = @"";
        //        labelTopSeSecondProductQunt.text = @"";
        //        labelTopSeFirstProductValue.text = @"";
        //        labelTopSeSecondProductValue.text = @"";
        
    }
    
}


#pragma mark -------------------- GetDayWise-----------------------
-(void)getDataDayWise:(NSDate *)Date
{
    
    self.dayMonthSegmentBtn.selectedSegmentIndex = 0;
    
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",[Language get:@"Day Report" alter:@"Day Report"]] forKey:@"repType"];
    
    genrateZDay=NO;
    appDelegate.arrayZDayReport=nil;
    
    
    self.btnGenerateZDay.hidden = YES;
    self.viewBaseTopSelling.hidden = NO;
    tableViewItems.hidden = NO;
    self.labelReportNumber.hidden = YES;
    
    dictAllItems = [NSMutableArray new];
    
    str_datefrom=@"Day";
    
    //    labelFirstProductQntity.layer.cornerRadius = 11.0f;
    //    labelSecondProductQntity.layer.cornerRadius = 11.0f;
    
    NSMutableArray *arraySub = [NSMutableArray new];
    NSMutableDictionary *dictSubbM = [NSMutableDictionary new];
    NSMutableArray *arrayMain = [NSMutableArray new];
    
    NSString *curMonth = nil;
    NSString *curDay = nil;
    NSString *curDayE=nil;
    NSString *str_IDs=@"";
    
    
    NSString *totaldatetime = nil;
    NSString *totaldate=nil;
    
    
    int countPayment = 0;
    int swishPayment = 0;
    int otherPayment = 0;
    int cardPayment = 0;
    
    int curId=-1;
    
    float tpricewithoutvat = 0.0;
    total=0.0;
    totalvat=0.0;
    float totalSum=0.0;
    float totalSumCash=0.0;
    float totalSumCard=0.0;
    float totalSumSwish=0.0;
    float totalSumOther=0.0;
    
    int totalProCount=0;
    int proCount=0;
    
    NSManagedObjectContext *context =[appDelegate managedObjectContext];
    NSEntityDescription *entityDesc =[NSEntityDescription entityForName:@"Trasections" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    
    NSArray *descriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:descriptors];
    
    
    
    NSEntityDescription *entityDesc2 =[NSEntityDescription entityForName:@"CustomDiscount" inManagedObjectContext:context];
    NSFetchRequest *request11 = [[NSFetchRequest alloc] init];
    [request11 setEntity:entityDesc2];
    //    NSPredicate *predicate;
    
    
    NSError *error;
    
    NSArray *objects = [context executeFetchRequest:request error:&error];
    
    int sum=0;
    
    NSArray *objects2;
    
    NSMutableDictionary *dictSub;
    
    int finalID = 0;
    
    for(int i=0;i<objects.count;i++)
    {
        //        NSMutableDictionary *dictMain = [NSMutableDictionary new];
        dictSub = [NSMutableDictionary new];
        
        NSManagedObject *person = (NSManagedObject *)[objects objectAtIndex:i];
        
        
        finalID = [[person valueForKey:@"id"] intValue];
        
        NSData *da=[person valueForKey:@"image"];
        
        UIImage *img=[[UIImage alloc] initWithData:da];
    
        [dictSub setObject:img forKey:@"image"];
        [dictSub setObject:[person valueForKey:@"name"] forKey:@"name"];
        [dictSub setObject:[person valueForKey:@"count"] forKey:@"count"];
        
        float newPrice = [[person valueForKey:@"price"] floatValue] ;//- [[person valueForKey:@"discount"] floatValue];
        
        [dictSub setObject:[NSString stringWithFormat:@"%f",newPrice] forKey:@"price"];
        
        
        float str = newPrice * [[person valueForKey:@"count"] floatValue];
        
        [dictSub setObject:[NSString stringWithFormat:@"%.02f", str] forKey:@"newprice"];
        
        [dictSub setObject:[person valueForKey:@"vat"] forKey:@"vat"];
        
        [dictSub setObject:[person valueForKey:@"discount"] forKey:@"discount"];
        [dictSub setObject:[person valueForKey:@"id"] forKey:@"id"];
        
        [dictSub setObject:[CommonMethods validateDictionaryValueForKey:[person valueForKey:@"discription"]]?[person valueForKey:@"discription"]:@"" forKey:@"discription"];
//        if ([CommonMethods validateDictionaryValueForKey:[person valueForKey:@"discription"]])  {
//            [dictSub setObject:[person valueForKey:@"discription"] forKey:@"discription"];
//
//        }
//        else {
//            [dictSub setObject:@"" forKey:@"discription"];
//        }
        [dictSub setObject:[person valueForKey:@"paymentMethod"] forKey:@"paymentMethod"];
        
        _str_paymentMethod = [NSString stringWithFormat:@"%@",[person valueForKey:@"paymentMethod"]];
//        if ([[person valueForKey:@"paymentMethod"] isEqualToString:@"2"]) {
//            
//            _str_paymentMethod = @"2";
//        }
//        else{
//            _str_paymentMethod = @"1";
//        }

        
        NSDate *date  = [person valueForKey:@"date"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        // Convert date object into desired format
        [dateFormatter setDateFormat:@"MMMM yyyy"];
        NSString *newDateString = [dateFormatter stringFromDate:date];
        [dictSub setObject:newDateString forKey:@"month"];
        
        
        [dateFormatter setDateFormat:@"dd"];
        NSString *day =[dateFormatter stringFromDate:date];
        
        
        [dateFormatter setDateFormat:@"EEEE"];
        NSString *dayE = [dateFormatter stringFromDate:date];
        
        NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
        // Convert date object into desired format
        [dateFormatter1 setDateFormat:@"dd-MMMM-yyyy, hh:mm a"];
        
        NSString *tdatetime = [dateFormatter1 stringFromDate:date];
        
        
        NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
        // Convert date object into desired format
        [dateFormatter2 setDateFormat:@"dd MMMM yyyy"];
        
        NSString *tDate = [dateFormatter2 stringFromDate:date];
        
        
        
        total=([[person valueForKey:@"price"] floatValue] *[[person valueForKey:@"count"] integerValue]-[[person valueForKey:@"discount"]floatValue]) + total;
        

//        total=([[person valueForKey:@"price"] floatValue] *[[person valueForKey:@"count"] integerValue])-[[person valueForKey:@"discount"]floatValue] ;
        
        
        if(curDay== nil)
        {
            if ([_str_paymentMethod isEqualToString:@"1"]){
                countPayment =1;
            }
            else if ([_str_paymentMethod isEqualToString:@"2"]) {
                cardPayment =1;
            }
            else if ([_str_paymentMethod isEqualToString:@"3"]){
                swishPayment =1;
            }
            else if ([_str_paymentMethod isEqualToString:@"4"]){
                otherPayment =1;
            }
            
            curDay = day;
            curDayE = dayE;
            curId =  [[person valueForKey:@"id"] intValue];
            totaldate=tDate;
            totaldatetime = tdatetime;
            currentDate=tDate;
            
            NSArray* ary_ID = [str_IDs componentsSeparatedByString: @","];
            
            
            if ([ary_ID count]>0)
            {
                if (![ary_ID containsObject:[NSString stringWithFormat:@"%@",[person valueForKey:@"id"]]])
                {
                    str_IDs = [NSString stringWithFormat:@"%@,%@",str_IDs,[person valueForKey:@"id"]];
                }
            }
            
        }
        
        else if (![curDay isEqualToString:day])
        {
            
            int refundCount = 0 ;
            float totalammount = 0;
            
            NSManagedObjectContext *context =
            [appDelegate managedObjectContext];
            
            NSEntityDescription *entityDesc =
            [NSEntityDescription entityForName:@"RefundAmount"
                        inManagedObjectContext:context];
            
            NSFetchRequest *request = [[NSFetchRequest alloc] init];
            [request setEntity:entityDesc];
            
            NSPredicate *pred =
            [NSPredicate predicateWithFormat:@"(date = %@)",totaldate];
            [request setPredicate:pred];
            //    NSManagedObject *matches = nil;
            
            NSError *error;
            NSArray *objects = [context executeFetchRequest:request
                                                      error:&error];
            
            
            
            for (NSManagedObject *personRefund in objects)
            {
                //Problem
                refundCount ++;
                //                totalammount = totalammount + [[personRefund valueForKey:@"totalAmount"] floatValue];
                totalammount = [[personRefund valueForKey:@"totalAmount"] floatValue];
            }
            
            
            if ([str_IDs hasPrefix:@","])
            {
                str_IDs = [str_IDs substringFromIndex:1];
            }
            
            float discount = [self GetDiscountList:str_IDs];
//            float discountCard = 0.0;
//            float discountCash = 0.0;
//
//            
//            if ([_str_paymentMethod isEqualToString:@"2"]) {
//                
//                discountCard = [self GetDiscountList:str_IDs];
//
//            }
//            else
//            {
//                discountCash= [self GetDiscountList:str_IDs];
//
//            }
            
            float discountCard = 0.0;
            float discountCash = 0.0;
            
            
            float totalPrice = 0.0;
            float vat = 0.0;
            float vatPercent = (totalvat*100)/tpricewithoutvat;
            
            if ([str_DiscountType isEqualToString:@"$"])
            {
                
                totalPrice = totalSum - discount;
                
            }
            else
            {
                totalPrice = totalSum - ((totalSum*discount)/100);
                
            }
            vat = totalPrice-(totalPrice/(1+vatPercent/100));
            
           
            NSManagedObjectContext *contextCustomDiscount =[appDelegate managedObjectContext];
            
            
            NSEntityDescription *entityDesc2 =[NSEntityDescription entityForName:@"CustomDiscount" inManagedObjectContext:contextCustomDiscount];
            NSFetchRequest *request11 = [[NSFetchRequest alloc] init];
            [request11 setEntity:entityDesc2];
            NSError *error2;
            NSArray *objects2 = [contextCustomDiscount executeFetchRequest:request11 error:&error2];
            
            NSManagedObject *person2;
            
            
            for(int i=0;i<objects2.count;i++)
            {
                
                //                NSArray* ary_ID = [IDs componentsSeparatedByString: @","];
                
                
                str_DiscountType = @"$";
                
                
                person2 = (NSManagedObject *)[objects2 objectAtIndex:i];
                
                
                NSDate *date  = [person2 valueForKey:@"date"];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"dd MMMM yyyy"];
                NSString *discountDateTime = [dateFormatter stringFromDate:date];
                
                
                
                if ([totaldate isEqual:discountDateTime]) {
                    
                
                
                //
                //                        sumnew = [[person2 valueForKey:@"discount"] floatValue]+sumnew;
                
                    _str_paymentMethod = [NSString stringWithFormat:@"%@",[person valueForKey:@"paymentMethod"]];
                    
//                if ([[person2 valueForKey:@"paymentMethod"] isEqualToString:@"2"]) {
//                    
//                    _str_paymentMethod = @"2";
//                }
//                else{
//                    _str_paymentMethod = @"1";
//                }
                
                if ([_str_paymentMethod isEqualToString:@"2"]) {
                    
                    //                            discountCard = [self GetDiscountList:str_IDs];
                    discountCard = [[person2 valueForKey:@"discount"] floatValue]+discountCard;
                    
                }
                else
                {
                    
                    //                            discountCash= [self GetDiscountList:str_IDs];
                    discountCash = [[person2 valueForKey:@"discount"] floatValue]+discountCash;
                    
                }
                
                }
                
                
            }

            
            
           
            NSMutableDictionary *dictSubb = [NSMutableDictionary new];
            [dictSubb setObject:curDay forKey:@"day"];
            [dictSubb setObject:curDayE forKey:@"dayE"];
            [dictSubb setObject:dictSubbM forKey:@"sub"];
            [dictSubb setObject:[NSString stringWithFormat:@"%d",countPayment] forKey:@"countPayment"];
            [dictSubb setObject:[NSString stringWithFormat:@"%d",cardPayment] forKey:@"cardPayment"];
            [dictSubb setObject:[NSString stringWithFormat:@"%d",swishPayment] forKey:@"swishPayment"];
            [dictSubb setObject:[NSString stringWithFormat:@"%d",otherPayment] forKey:@"otherPayment"];
            [dictSubb setObject:[NSString stringWithFormat:@"%f",totalSum] forKey:@"totalSum"];
            [dictSubb setObject:[NSString stringWithFormat:@"%f",totalSumCash] forKey:@"totalSumCash"];
            [dictSubb setObject:[NSString stringWithFormat:@"%f",totalSumCard] forKey:@"totalSumCard"];
            [dictSubb setObject:[NSString stringWithFormat:@"%f",totalSumSwish] forKey:@"totalSumSwish"];
            [dictSubb setObject:[NSString stringWithFormat:@"%f",totalSumOther] forKey:@"totalSumOther"];
            [dictSubb setObject:[NSString stringWithFormat:@"%f",vat] forKey:@"totalvat"];
            [dictSubb setObject:totaldatetime forKey:@"totaldatetime"];
            [dictSubb setObject:str_IDs forKey:@"finalid"];
            [dictSubb setObject:totaldate forKey:@"totaldate"];
            [dictSubb setObject:[NSString stringWithFormat:@"%.2f",discount] forKey:@"totaldiscount"];
            [dictSubb setObject:[NSString stringWithFormat:@"%.2f",discountCash] forKey:@"totaldiscountCash"];
            [dictSubb setObject:[NSString stringWithFormat:@"%.2f",discountCard] forKey:@"totaldiscountCard"];
            [dictSubb setObject:[NSString stringWithFormat:@"%.2f",discountCash] forKey:@"totaldiscountSwish"];
            [dictSubb setObject:[NSString stringWithFormat:@"%.2f",discountCash] forKey:@"totaldiscountOther"];
            [dictSubb setObject:[NSString stringWithFormat:@"%d",refundCount] forKey:@"refundCount"];
            [dictSubb setObject:[NSString stringWithFormat:@"%.2f",totalammount] forKey:@"refundTotal"];
            [dictSubb setObject:[NSString stringWithFormat:@"%d",totalProCount] forKey:@"proCount"];

            [arraySub addObject:dictSubb];
            
            totalProCount=0;
            
            total = 0;
            totalvat = 0;
            tpricewithoutvat = 0;
            
            
            cardPayment = 0;
            countPayment = 0;
            swishPayment = 0;
            otherPayment = 0;

            str_IDs = @"";
            totalSum = 0;
            totalSumCash = 0;
            totalSumCard = 0;
            totalSumSwish = 0;
            totalSumOther = 0;
            sum = 0;
            dictSubbM = [NSMutableDictionary new];
            totaldate=tDate;
            currentDate=tDate;
            totaldatetime = tdatetime;
            if ([_str_paymentMethod isEqualToString:@"2"]) {
                cardPayment =1;
            }
            else if ([_str_paymentMethod isEqualToString:@"1"]) {
                countPayment =1;
            }
            else if ([_str_paymentMethod isEqualToString:@"3"]) {
                swishPayment =1;
            }
            else if ([_str_paymentMethod isEqualToString:@"4"]) {
                otherPayment =1;
            }
            
            curDay = day;
            curDayE = dayE;
            
        }
        else
        {
            
            if(curId!=[[person valueForKey:@"id"] intValue])
            {
                if ([_str_paymentMethod isEqualToString:@"2"])
                {
                    cardPayment++;
                }
                else if ([_str_paymentMethod isEqualToString:@"1"])
                {
                    countPayment++;
                }
                else if ([_str_paymentMethod isEqualToString:@"3"])
                {
                    swishPayment++;
                }
                else if([_str_paymentMethod isEqualToString:@"4"])
                {
                    otherPayment++;
                }
               
            }
            
            NSArray* ary_ID = [str_IDs componentsSeparatedByString: @","];
            
            
            if ([ary_ID count]>0)
            {
                if (![ary_ID containsObject:[NSString stringWithFormat:@"%@",[person valueForKey:@"id"]]])
                {
                    str_IDs = [NSString stringWithFormat:@"%@,%@",str_IDs,[person valueForKey:@"id"]];
                }
            }
        }
        

        if(curMonth==nil)
            curMonth = newDateString;
        else if (![curMonth isEqualToString:newDateString])
        {
            
            NSMutableDictionary *dictMain = [NSMutableDictionary new];
            [dictMain setObject:curMonth forKey:@"month"];
            [dictMain setObject:arraySub forKey:@"main"];
            [arrayMain addObject:dictMain];
            
            arraySub = [NSMutableArray new];
            curMonth = newDateString;
            currentDate= newDateString;
        }
        
        
        if(curId!=[[person valueForKey:@"id"] intValue])
        {
            //            countPayment++;
            curId=[[person valueForKey:@"id"] intValue];
        }
        
        
        
        NSPredicate *predicate;
        predicate = [NSPredicate predicateWithFormat:@"(id = %@)", [person valueForKey:@"id"]];
        [request11 setPredicate:predicate];
        
        
        NSError *error2;
        objects2 = [context executeFetchRequest:request11 error:&error2];
        
        NSManagedObject *person2;
        
        for(int i=0;i<objects2.count;i++)
        {
            person2 = (NSManagedObject *)[objects2 objectAtIndex:i];
            
            float discount = 0.0;
            
            [dictSub setObject:[person2 valueForKey:@"discount"] forKey:@"customdiscount"];
            
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
        
        
//        total=([[person valueForKey:@"price"] floatValue] *[[person valueForKey:@"count"] integerValue])-[[person valueForKey:@"discount"]floatValue] ;
        
        
        
        zzzz = (([[person valueForKey:@"price"] floatValue]*[[person valueForKey:@"count"] integerValue])-[[person valueForKey:@"discount"]floatValue]) / (1 + [[person valueForKey:@"vat"] floatValue]/100);
        
        
        
        zzzz=(([[person valueForKey:@"price"] floatValue] *[[person valueForKey:@"count"] integerValue])-[[person valueForKey:@"discount"]floatValue])-zzzz;
        
        
        tpricewithoutvat = (([[person valueForKey:@"price"] floatValue]*[[person valueForKey:@"count"] integerValue])-[[person valueForKey:@"discount"]floatValue]) / (1 + [[person valueForKey:@"vat"] floatValue]/100) + tpricewithoutvat;
        
        totalvat = zzzz + totalvat;
        
        proCount=[[person valueForKey:@"count"] intValue];
        
        totalSum = totalSum + total;
        
        if ([_str_paymentMethod isEqualToString:@"2"]) {
            
            totalSumCard=totalSumCard + total;
            
        }
        else if ([_str_paymentMethod isEqualToString:@"1"])
        {
            totalSumCash=totalSumCash + total;
        }
        else if ([_str_paymentMethod isEqualToString:@"3"])
        {
            totalSumSwish=totalSumSwish + total;
        }
        else if ([_str_paymentMethod isEqualToString:@"4"])
        {
            totalSumOther=totalSumOther + total;
        }
        
        
        if([dictSubbM objectForKey:[dictSub valueForKey:@"name"]])
        {
            
            NSMutableDictionary *dictTemp = [dictSubbM  objectForKey:[dictSub valueForKey:@"name"]];
            int countTemp = [[dictTemp valueForKey:@"count"] intValue] + [[dictSub valueForKey:@"count"] intValue];
            [dictTemp setObject:[NSString stringWithFormat:@"%d",countTemp] forKey:@"count"];
            [dictSubbM setObject:dictTemp forKey:[dictSub valueForKey:@"name"]];
            
        }
        else
        {
            [dictSubbM setObject:dictSub forKey:[dictSub valueForKey:@"name"]];
        }

        totalProCount=totalProCount+proCount;
    
    }
    
    if (objects.count != 0)
    {
        
        int refundCount = 0 ;
        float totalammount = 0;
        
        NSManagedObjectContext *context =
        [appDelegate managedObjectContext];
        
        NSEntityDescription *entityDesc =
        [NSEntityDescription entityForName:@"RefundAmount"
                    inManagedObjectContext:context];
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entityDesc];
        
        NSPredicate *pred =
        [NSPredicate predicateWithFormat:@"(date = %@)",totaldate];
        [request setPredicate:pred];
        //    NSManagedObject *matches = nil;
        
        
        NSError *error;
        NSArray *objects = [context executeFetchRequest:request
                                                  error:&error];
        
        for (NSManagedObject *personRefund in objects)
        {
            refundCount ++;
            //            totalammount = totalammount + [[personRefund valueForKey:@"totalAmount"] floatValue];
            totalammount =  [[personRefund valueForKey:@"totalAmount"] floatValue];
        }
        
        
        
        if ([str_IDs hasPrefix:@","])
        {
            str_IDs = [str_IDs substringFromIndex:1];
        }
        float discount = [self GetDiscountList:str_IDs];
        
        float discountCard = 0.0;
        float discountCash = 0.0;
        
        
//        if ([_str_paymentMethod isEqualToString:@"2"]) {
//            
//            discountCard = [self GetDiscountList:str_IDs];
//            
//        }
//        else
//        {
//            discountCash= [self GetDiscountList:str_IDs];
//            
//        }
        
        
        float totalPrice = 0.0;
        float vat = 0.0;
        float vatPercent = (totalvat*100)/tpricewithoutvat;
        
        if ([str_DiscountType isEqualToString:@"$"])
        {
            
            totalPrice = totalSum - discount;
        }
        else
        {
            totalPrice = totalSum - ((totalSum*discount)/100);
            
        }
        vat = totalPrice-(totalPrice/(1+vatPercent/100));
        
   
            NSManagedObjectContext *contextCustomDiscount =[appDelegate managedObjectContext];
            
            
            NSEntityDescription *entityDesc2 =[NSEntityDescription entityForName:@"CustomDiscount" inManagedObjectContext:contextCustomDiscount];
            NSFetchRequest *request11 = [[NSFetchRequest alloc] init];
            [request11 setEntity:entityDesc2];
            NSError *error2;
            NSArray *objects2 = [contextCustomDiscount executeFetchRequest:request11 error:&error2];
            
            NSManagedObject *person2;
            
//            float sumnew=0.0;
//            float sumnewCash=0.0;
//            float sumnewCard=0.0;
        
            for(int i=0;i<objects2.count;i++)
            {
                
//                NSArray* ary_ID = [IDs componentsSeparatedByString: @","];
                
                
                         str_DiscountType = @"$";
                
             
                        person2 = (NSManagedObject *)[objects2 objectAtIndex:i];
      
                NSDate *date  = [person2 valueForKey:@"date"];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"dd MMMM yyyy"];
                NSString *discountDateTime = [dateFormatter stringFromDate:date];
                
                
                
                if ([totaldate isEqual:discountDateTime]) {
//                        
//                        sumnew = [[person2 valueForKey:@"discount"] floatValue]+sumnew;
                
                    _str_paymentMethod = [NSString stringWithFormat:@"%@",[person2 valueForKey:@"paymentMethod"]];
                    
//                if ([[person2 valueForKey:@"paymentMethod"] isEqualToString:@"2"]) {
//                    
//                    _str_paymentMethod = @"2";
//                }
//                else{
//                    _str_paymentMethod = @"1";
//                }
                    
                        if ([_str_paymentMethod isEqualToString:@"2"]) {
                            
//                            discountCard = [self GetDiscountList:str_IDs];
                            discountCard = [[person2 valueForKey:@"discount"] floatValue]+discountCard;
                            
                        }
                        else
                        {
                            
//                            discountCash= [self GetDiscountList:str_IDs];
                            discountCash = [[person2 valueForKey:@"discount"] floatValue]+discountCash;
                            
                        }
                        
                        
                }
                
            }

        
        
        
        
        
        
        NSMutableDictionary *dictSubb = [NSMutableDictionary new];
        [dictSubb setObject:curDay forKey:@"day"];
        [dictSubb setObject:dictSubbM forKey:@"sub"];
        [dictSubb setObject:curDayE forKey:@"dayE"];
        [dictSubb setObject:[NSString stringWithFormat:@"%f",totalSum] forKey:@"totalSum"];
        [dictSubb setObject:[NSString stringWithFormat:@"%f",totalSumCash] forKey:@"totalSumCash"];
        [dictSubb setObject:[NSString stringWithFormat:@"%f",totalSumCard] forKey:@"totalSumCard"];
        [dictSubb setObject:[NSString stringWithFormat:@"%f",totalSumSwish] forKey:@"totalSumSwish"];
        [dictSubb setObject:[NSString stringWithFormat:@"%f",totalSumOther] forKey:@"totalSumOther"];
        [dictSubb setObject:[NSString stringWithFormat:@"%d",countPayment] forKey:@"countPayment"];
        [dictSubb setObject:[NSString stringWithFormat:@"%d",swishPayment] forKey:@"swishPayment"];
        [dictSubb setObject:[NSString stringWithFormat:@"%d",otherPayment] forKey:@"otherPayment"];
        [dictSubb setObject:[NSString stringWithFormat:@"%d",cardPayment] forKey:@"cardPayment"];
        [dictSubb setObject:[NSString stringWithFormat:@"%f",vat] forKey:@"totalvat"];
        [dictSubb setObject:totaldatetime forKey:@"totaldatetime"];
        [dictSubb setObject:str_IDs forKey:@"finalid"];
        [dictSubb setObject:totaldate forKey:@"totaldate"];
        [dictSubb setObject:[NSString stringWithFormat:@"%0.02f",discount] forKey:@"totaldiscount"];
        [dictSubb setObject:[NSString stringWithFormat:@"%.2f",discountCash] forKey:@"totaldiscountCash"];
        [dictSubb setObject:[NSString stringWithFormat:@"%.2f",discountCard] forKey:@"totaldiscountCard"];
        [dictSubb setObject:[NSString stringWithFormat:@"%.2f",discountCash] forKey:@"totaldiscountSwish"];
        [dictSubb setObject:[NSString stringWithFormat:@"%.2f",discountCash] forKey:@"totaldiscountOther"];
        [dictSubb setObject:[NSString stringWithFormat:@"%d",refundCount] forKey:@"refundCount"];
        [dictSubb setObject:[NSString stringWithFormat:@"%.2f",totalammount] forKey:@"refundTotal"];
        [dictSubb setObject:[NSString stringWithFormat:@"%d",totalProCount] forKey:@"proCount"];
        
//        [dictSubb setObject:_str_paymentMethod forKey:@"paymentMethod"];
        
        totalProCount=0;
        proCount=0;
        [arraySub addObject:dictSubb];
        
        
        NSMutableDictionary *dictMain = [NSMutableDictionary new];
        [dictMain setObject:curMonth forKey:@"month"];
        [dictMain setObject:arraySub forKey:@"main"];
        [arrayMain addObject:dictMain];
        
        
        
//        if ([_str_paymentMethod isEqualToString:@"2"]) {
//            cardPayment =1;
//        }
//        else{
//            countPayment =1;
//        }
        str_IDs = @"";
        dictAllItems = arrayMain;
        selectedSection=0;
        sum = 0;
        selectedRow=0;
        [self setMiddlePart];

       
//        NSMutableDictionary *dict13 = [[NSMutableDictionary alloc]initWithDictionary:[ary_DetailList objectAtIndex:12]];
//        [dict13 setObject:[NSString stringWithFormat:@"%@ 0.00", currencySign] forKey:@"value"];
//        [ary_DetailList replaceObjectAtIndex:12 withObject:dict13];
        
        [collectionView_ReportDetail reloadData];
        
     //   labelFeeValue.text = [NSString stringWithFormat:@"%@ 0.00", currencySign];
    }
    else
    {
        
        NSMutableDictionary *dict1 = [[NSMutableDictionary alloc]initWithDictionary:[ary_DetailList objectAtIndex:0]];
        [dict1 setObject:[NSString stringWithFormat:@"0 %@ ",[Language get:@"Card payments" alter:@"!Card payments"]] forKey:@"title"];
        [dict1 setObject:[NSString stringWithFormat:@"%@ 0.00", currencySign] forKey:@"value"];
        [ary_DetailList replaceObjectAtIndex:0 withObject:dict1];
        
        
        NSMutableDictionary *dict2 = [[NSMutableDictionary alloc]initWithDictionary:[ary_DetailList objectAtIndex:1]];
        [dict2 setObject:[NSString stringWithFormat:@"0 %@ ",[Language get:@"Cash payments" alter:@"!Cash payments"]] forKey:@"title"];
        [dict2 setObject:[NSString stringWithFormat:@"%@ 0.00", currencySign] forKey:@"value"];
        [ary_DetailList replaceObjectAtIndex:1 withObject:dict2];
        
        
        NSMutableDictionary *dict3 = [[NSMutableDictionary alloc]initWithDictionary:[ary_DetailList objectAtIndex:2]];
        [dict3 setObject:[NSString stringWithFormat:@"0 %@ ",[Language get:@"Swish payments" alter:@"!Swish payments"]] forKey:@"title"];
        [dict3 setObject:[NSString stringWithFormat:@"%@ 0.00", currencySign] forKey:@"value"];
        [ary_DetailList replaceObjectAtIndex:2 withObject:dict3];
        
        
        NSMutableDictionary *dict4 = [[NSMutableDictionary alloc]initWithDictionary:[ary_DetailList objectAtIndex:3]];
        [dict4 setObject:[NSString stringWithFormat:@"0 %@ ",[Language get:@"Other payments" alter:@"!Other payments"]] forKey:@"title"];
        [dict4 setObject:[NSString stringWithFormat:@"%@ 0.00", currencySign] forKey:@"value"];
        [ary_DetailList replaceObjectAtIndex:3 withObject:dict4];
        
        
        NSMutableDictionary *dict6 = [[NSMutableDictionary alloc]initWithDictionary:[ary_DetailList objectAtIndex:5]];
        [dict6 setObject:[NSString stringWithFormat:@"%@ 0.00", currencySign] forKey:@"value"];
        [ary_DetailList replaceObjectAtIndex:5 withObject:dict6];
        
        
        NSMutableDictionary *dict7 = [[NSMutableDictionary alloc]initWithDictionary:[ary_DetailList objectAtIndex:6]];
        [dict7 setObject:[NSString stringWithFormat:@"%@ 0.00", currencySign] forKey:@"value"];
        [ary_DetailList replaceObjectAtIndex:6 withObject:dict7];
        
        
        NSMutableDictionary *dict13 = [[NSMutableDictionary alloc]initWithDictionary:[ary_DetailList objectAtIndex:12]];
        [dict13 setObject:[NSString stringWithFormat:@"%@ 0.00", currencySign] forKey:@"value"];
        [ary_DetailList replaceObjectAtIndex:12 withObject:dict13];
        
        
        [collectionView_ReportDetail reloadData];
        
       // labelCardPaymentValue.text = [NSString stringWithFormat:@"%@ 0.00", currencySign];
       // labelFeeValue.text = [NSString stringWithFormat:@"%@ 0.00", currencySign];
       // labelCashPaymentValue.text = [NSString stringWithFormat:@"%@ 0.00", currencySign];
        
      //  labelRefundTotal.text = [NSString stringWithFormat:@"%@ 0.00", currencySign];
        labelTotal.text = [NSString stringWithFormat:@"%@ 0.00", currencySign];
        
       // labelDiscount.text = [NSString stringWithFormat:@"%@ 0.00", currencySign];
 
    }
    
    
    
    NSMutableString *str_vat=[[NSMutableString alloc] init];
    NSString *str_per=@"%";
    
    float TotalVat=00;
    
    [str_vat appendString:@"( "];
    
    
    
    for (int i=0; i<[vatArray count]; i++) {
     
        
        if ([[[vatArray objectAtIndex:i] valueForKey:@"vatTotal"]floatValue]>0) {
            
            TotalVat=TotalVat+[[[vatArray objectAtIndex:i] valueForKey:@"vatTotal"] floatValue];
            
            [str_vat appendString:[NSString stringWithFormat:@"%@%@ : %@, ",[[vatArray objectAtIndex:i] valueForKey:@"vat"],str_per,[[vatArray objectAtIndex:i] valueForKey:@"vatTotal"]]];
            
        }
    }
    
    [str_vat deleteCharactersInRange:NSMakeRange([str_vat length]-2, 1)];
    if (TotalVat>0) {
    [str_vat appendString:@")"];
    }

    
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%.02f %@",TotalVat,str_vat] forKey:@"totalVat"];
    
    
}


-(void)getZDayData
{
    
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
//                
//                if ([_str_paymentMethod isEqualToString:@"2"]) {
//                    sumnewCard = [[person2 valueForKey:@"discount"] floatValue]+sumnew;
//
//                }
//                else
//                {
//                    sumnewCash = [[person2 valueForKey:@"discount"] floatValue]+sumnew;
//
//                }
                
                sumnew = [[person2 valueForKey:@"discount"] floatValue]+sumnew;
                
            }
        }
        
    }
    
//    if ([_str_paymentMethod isEqualToString:@"2"]) {
//        
//        return sumnewCard;
//    }
//    else
//    {
//        return sumnewCash;
//    }
    
    return sumnew;
}

- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController
{
    return NO;
}
- (IBAction)btn_Printer_Action:(UIButton *)sender {
    
    [self setPortInfo];
    NSString *portName = [AppDelegate getPortName];
    NSString *portSettings = [AppDelegate getPortSettings];
    [MiniPrinterFunctions CheckStatusWithPortname:portName portSettings:portSettings sensorSetting:SensorActiveHigh];
    
    self.label_PrinterName.text=[[NSUserDefaults standardUserDefaults] valueForKey:@"PrinterStatus"];
    
    if(self.btnGenerateZDay.hidden ==NO)
    {
        
        if(zDayArray.count>0)
        {
            
    self.report_PrinterView.hidden = NO;
            
        }
    }
    else
    {
        self.report_PrinterView.hidden = NO;
    }
}
- (IBAction)actionBtnZDayReport:(UIButton *)sender {
 
    
    selectedDate=[NSDate date];
    [self getZdayReport:selectedDate];
    [self ZDayRefund];
    if(dictAllZDayItems.count>0) {
        [self allTransaction];
        [self zDaySet];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"dd MMMM yyyy"];
        currentDate = [dateFormatter stringFromDate:[NSDate date]];
        [self ZDayRefund];
        [self ZdayPayment];
        [self ZDayGrandTotal];
        [self saveZDayReoprt];
        [self viewZdayData:0];
    }
    else if(refundZArray.count>0) {
        
        [self ZDayRefund];
        [self zDaySetRefund];
        [self ZDayGrandTotal];
        [self saveZDayReoprt];
        [self viewZdayData:0];
    }
    else
    {
        if (zDayArray.count>0) {
            [self viewZdayData:0];
        }
        
        
        [[[UIAlertView alloc] initWithTitle:@"ISUPOS" message:[Language get:@"There are no new transaction to generate report" alter:@"!There are no new transaction to generate report"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
    [maintablev reloadData];
    
    [maintablev selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:0];
    
    //    zcardPayment
    //    zcashPayment
    //    zdate
    //    zdiscunts
    //    zgrandTotalRefund
    //    zgrandTotalSale
    //    zgrandtotalSale_Refund
    //    zrefund
    //    ztotalEmail
    //    ztotalPayments
    //    ztotalPrint
    //    ztotalProduct
    //
    
    
}

- (IBAction)select_printReceipt:(id)sender {
    
    [self setPortInfo];
    NSString *portName = [AppDelegate getPortName];
    NSString *portSettings = [AppDelegate getPortSettings];
    

    
    [[NSUserDefaults standardUserDefaults] setObject:@"Yes" forKey:@"ReportRecipt"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    [[NSUserDefaults standardUserDefaults] setObject:@"Copy" forKey:@"ReciptType"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
//    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"PrinterStatus"] isEqualToString:@"Online"]) {
    
    
//    if(genrateZDay==YES)
//    {
//        if(zDayArray.count>0)
//        {
//            
//            [self editTransactionForPrintStatus:[[zDayArray objectAtIndex:selectedRow] valueForKey:@"id"]];
//            
//        }
//    }
    
    if(self.btnGenerateZDay.hidden ==NO)
    {
        
        if(zDayArray.count>0)
        {
        
        for (int i =1; i<=printCount; i++) {
            
            [MiniPrinterFunctions PrintSampleReceiptWithPortname:portName
                                                    portSettings:portSettings
                                                       widthInch:2];
            
            
        }
        
        if(genrateZDay==YES)
        {
            if ([[NSUserDefaults standardUserDefaults] valueForKey:@"printedZday"]) {
                
                int emailNo =[[[NSUserDefaults standardUserDefaults] valueForKey:@"printedZday"] intValue];
                
                emailNo=emailNo+1;
                
                [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",emailNo] forKey:@"printedZday"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
            }
            else
            {
                [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"printedZday"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            
        }
        
        self.report_PrinterView.hidden=YES;
        if (genrateZDay==YES) {
            [self createLogDetails:[NSString stringWithFormat:@"Printed report of"]];
        }
        }
        
    }
    else
    {
    
    for (int i =1; i<=printCount; i++) {
        
        [MiniPrinterFunctions PrintSampleReceiptWithPortname:portName
                                                portSettings:portSettings
                                                   widthInch:2];
        
        
    }
    
  
    if(genrateZDay==YES)
    {
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"printedZday"]) {
        
        int emailNo =[[[NSUserDefaults standardUserDefaults] valueForKey:@"printedZday"] intValue];
        
        emailNo=emailNo+1;
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",emailNo] forKey:@"printedZday"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"printedZday"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    }
          
    self.report_PrinterView.hidden=YES;
    if (genrateZDay==YES) {
        [self createLogDetails:[NSString stringWithFormat:@"Printed report of"]];
    }
    
    }
}
    

- (IBAction)stepper_Action:(UIStepper *)sender {
    
    double value = [sender value];
    
    printCount=[sender value];
    
    sender.minimumValue = 1;
    
    
    [self.reportPrinterCopies setText:[NSString stringWithFormat:@"%d %@", (int)value,[Language get:@"Copy" alter:@"!Copy"]]];
    if((int)value>1)
        [self.reportPrinterCopies setText:[NSString stringWithFormat:@"%d %@", (int)value,[Language get:@"Copies" alter:@"!Copies"]]];
    
}

//-(void)editTransactionForMailStatus:(NSString *)Id
//{
//    NSManagedObjectContext *context =[appDelegate managedObjectContext];
//    NSError *error;
//    NSEntityDescription *entityDescc =[NSEntityDescription entityForName:@"ZDay" inManagedObjectContext:context];
//    NSFetchRequest *requestt = [[NSFetchRequest alloc] init];
//    NSPredicate *predicate;
//    predicate = [NSPredicate predicateWithFormat:@"(id = %@)", Id];
//    [requestt setPredicate:predicate];
//    [requestt setEntity:entityDescc];
//    
//    NSArray *objectss = [context executeFetchRequest:requestt error:&error];
//    
//    NSManagedObject *persoRec = (NSManagedObject *)[objectss lastObject];
//    int x=[[persoRec valueForKey:@"totalEmailCopies"] intValue]+1;
//    
//    if ([objectss count] == 0) {
//        
//    }
//    else
//    {
//        for (int i=0; i<[objectss count]; i++) {
//            
//            NSManagedObject *obj=(NSManagedObject *)[objectss objectAtIndex:i];
//            [obj setValue:[persoRec valueForKey:@"totalEmail"] forKey:@"totalEmail"];
//         
//            [obj setValue:[NSString stringWithFormat:@"%d",x] forKey:@"totalEmailCopies"];
//            [context save:&error];
//        }
//     
//    }
//    
//    [self fetch_ZdayData];
//    [self viewZdayData:selectedRow];
//}
//
//-(void)editTransactionForPrintStatus:(NSString *)Id
//{
//    NSManagedObjectContext *context =[appDelegate managedObjectContext];
//    NSError *error;
//    NSEntityDescription *entityDescc =[NSEntityDescription entityForName:@"ZDay" inManagedObjectContext:context];
//    NSFetchRequest *requestt = [[NSFetchRequest alloc] init];
//    NSPredicate *predicate;
//    predicate = [NSPredicate predicateWithFormat:@"(id = %@)", Id];
//    [requestt setPredicate:predicate];
//    [requestt setEntity:entityDescc];
//    
//    NSArray *objectss = [context executeFetchRequest:requestt error:&error];
//    
//    NSManagedObject *persoRec = (NSManagedObject *)[objectss lastObject];
////    int x=[[persoRec valueForKey:@"totalPrint"] intValue]+1;
//    int x=[[persoRec valueForKey:@"totalPrintCopies"] intValue]+1;
//
//    
//    
//    if ([objectss count] == 0) {
//        
//    }
//    else
//    {
//        for (int i=0; i<[objectss count]; i++) {
//            
//            NSManagedObject *obj=(NSManagedObject *)[objectss objectAtIndex:i];
//            [obj setValue:[persoRec valueForKey:@"totalPrint"] forKey:@"totalPrint"];
//            
//            [obj setValue:[NSString stringWithFormat:@"%d",x] forKey:@"totalPrintCopies"];
//            [context save:&error];
//        }
//        
//        
//        
//        
//    }
//    
//    [self fetch_ZdayData];
//    [self viewZdayData:0];
//}

#pragma mark Additional changes

#pragma mark Vat

-(void)getVatarray
{
    vatArray=[[NSMutableArray alloc] init];
    
    NSManagedObjectContext *context =[appDelegate managedObjectContext];
    NSEntityDescription *entityDescc =[NSEntityDescription entityForName:@"VatVariation" inManagedObjectContext:context];
    NSFetchRequest *requestt = [[NSFetchRequest alloc] init];
    [requestt setEntity:entityDescc];
    NSManagedObject *matches = nil;
    NSError *error;
    NSArray *objectss = [context executeFetchRequest:requestt error:&error];
    if ([objectss count] == 0) {
        
    } else {
        for(int i=0;i<[objectss count];i++)
        {
            matches=(NSManagedObject*)[objectss objectAtIndex:i];
            
            NSString *strVat;
            
            strVat=[matches valueForKey:@"vat"];
            
            strVat=[strVat stringByReplacingOccurrencesOfString:@"%" withString:@""];
            
            NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
            
            [dict setValue:strVat forKey:@"vat"];
            [dict setValue:@"0" forKey:@"vatTotal"];
            
            
            [vatArray addObject:dict];
            
        }
        
    }

}


#pragma mark CurrentDate

-(void)CurrentDateRefund
{
    
    NSMutableArray *arrayZdayRefundCount=[NSMutableArray new];
    NSMutableArray *arrayRefundCount=[NSMutableArray new];
    int refundZday;
    
    int refundCount;
    
    NSManagedObjectContext *context =
    [appDelegate managedObjectContext];
    
    NSEntityDescription *entityDesc =
    [NSEntityDescription entityForName:@"RefundAmount"
                inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
    NSPredicate *pred =
    [NSPredicate predicateWithFormat:@"(date = %@)",currentDate];
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
        
        
        
        //            if(index != [[personRefund valueForKey:@"rid"]intValue])
        //            {
        
        if (![[arrayZdayRefundCount valueForKey:@"id"]containsObject:[personRefund valueForKey:@"id"]])
        {
            NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
            
            [dic setObject:[personRefund valueForKey:@"id"] forKey:@"id"];
            
            [arrayZdayRefundCount addObject:dic];
        }
        
        index = [[personRefund valueForKey:@"rid"]intValue];
        
        dictSubR = [NSMutableDictionary new];
        
        //Anu: 21June2016 crash issue
        str_id=[personRefund valueForKey:@"id"];
        
        if ([personRefund valueForKey:@"totalAmount"] == nil)
            str_price=@"0";
            else
        str_price=[personRefund valueForKey:@"totalAmount"];
        
        str_code=[personRefund valueForKey:@"code"];
       
        if ([personRefund valueForKey:@"vat"] == nil)
           str_vat=@"0";
            else
                str_vat=[personRefund valueForKey:@"vat"];
        
        [dictSubR setObject:str_price forKey:@"totalAmount"];
        
        if ([personRefund valueForKey:@"price"] == nil)
            [dictSubR setObject:@"0" forKey:@"price"];
            else
                [dictSubR setObject:[personRefund valueForKey:@"price"] forKey:@"price"];
        
        
        [dictSubR setObject:[personRefund valueForKey:@"refundDate"] forKey:@"refundDate"];
        
        if ([personRefund valueForKey:@"vat"] == nil)
            [dictSubR setObject:@"0" forKey:@"vat"];
        else
        [dictSubR setObject:[personRefund valueForKey:@"vat"] forKey:@"vat"];
        
        [dictSubR setObject:[personRefund valueForKey:@"id"] forKey:@"id"];
        [dictSubR setObject:[personRefund valueForKey:@"code"] forKey:@"code"];
        
        if ([personRefund valueForKey:@"rid"] == nil)
            [dictSubR setObject:@"" forKey:@"rid"];
            else
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
        [dictSubR setObject:[CommonMethods validateDictionaryValueForKey:[personRefund valueForKey:@"discription"]]?[personRefund valueForKey:@"discription"]:@"" forKey:@"discription"];
       // [dictSubR setObject:[personRefund valueForKey:@"discription"] forKey:@"discription"];
        [dictSubR setObject:@"" forKey:@"image"];
        [dictSubR setObject:[personRefund valueForKey:@"name"] forKey:@"name"];
        
        if ([personRefund valueForKey:@"discount"] == nil)
        {
            [dictSubR setObject:@"0" forKey:@"discount"];
            
        }
        else
        {
            [dictSubR setObject:[personRefund valueForKey:@"discount"] forKey:@"discount"];
        }
        [dictSubR setObject:[personRefund valueForKey:@"time"] forKey:@"time"];
        [dictSubR setObject:[personRefund valueForKey:@"date"] forKey:@"date"];
        
        if ([personRefund valueForKey:@"peritemprice"] == nil)
            [dictSubR setObject:@"0" forKey:@"peritemdiscount"];
              else
               [dictSubR setObject:[personRefund valueForKey:@"peritemprice"] forKey:@"peritemprice"];
        
        
        [arr_sub addObject:dictSubR];
        
    }
    
    refundZday=[arrayZdayRefundCount count];
    
    [appDelegate refundCountUpdate:refundZday :2];

    
    NSMutableArray *arr_subFinal=[NSMutableArray new];
    NSMutableArray *arr_subFinalDiferentId=[NSMutableArray new];
    
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
            
            NSString *stringDateTime;
            
            stringDateTime = [NSString stringWithFormat:@"%@",[[arr_sub valueForKey:@"date"] objectAtIndex:i]];
            
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:@"dd MMMM yyyy"];
            
            NSDate *date_get=[dateFormatter dateFromString:stringDateTime];
            NSDate *TranDate = date_get;
            
            
            [dateFormatter setDateFormat:@"MM"];
            
            NSString *str_monthT = [dateFormatter stringFromDate:TranDate];
            NSString *str_monthC = [dateFormatter stringFromDate:selectedDate];
            
            [dateFormatter setDateFormat:@"dd"];
            
            NSString *str_dayT = [dateFormatter stringFromDate:TranDate];
            NSString *str_dayC = [dateFormatter stringFromDate:selectedDate];
            
            [dateFormatter setDateFormat:@"yyyy"];
            
            NSString *str_yearT = [dateFormatter stringFromDate:TranDate];
            NSString *str_yearC = [dateFormatter stringFromDate:selectedDate];
            
            int yearT,yearC,monthT,monthC,dayT,dayC;
            
            
            yearT=[str_yearT intValue];
            yearC=[str_yearC intValue];
            
            monthT=[str_monthT intValue];
            monthC=[str_monthC intValue];
            
            dayT=[str_dayT intValue];
            dayC=[str_dayC intValue];
            
            if (str_prev!=str_next) {
                
                arr_subFinal=[NSMutableArray new];
                [arr_subFinal addObject:[arr_sub objectAtIndex:i]];

                
                if (yearC<=yearT) {
                    
                    if (monthC<=monthT) {
                        
                        if (dayC>=dayT) {
                            
                            [arr_subFinalDiferentId addObject:[arr_sub objectAtIndex:i]];
                            
                            
                        }
                        
                    }
                    
                }
                
            }
            else
            {
                [arr_subFinal addObject:[arr_sub objectAtIndex:i]];
                
                if (i==0) {
                    
                    if (yearC<=yearT) {
                        
                        if (monthC<=monthT) {
                            
                            if (dayC>=dayT) {
                                
                                [arr_subFinalDiferentId addObject:[arr_sub objectAtIndex:i]];
                                
                                
                            }
                            
                        }
                        
                    }
                }
            }
            
            
        }
        else
        {
            
            arr_subFinal=arr_sub;
            arr_subFinalDiferentId=arr_sub;
        }
        
        
    }
    
    
//    labelRefund.text = [NSString stringWithFormat:@"%@ %@",[NSString stringWithFormat:@"%lu",(unsigned long)arr_subFinalDiferentId.count],
//                        
//    labelRefund.text = [Language get:@"Refund" alter:@"!Refund"]];
    
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%lu", (unsigned long)arr_subFinalDiferentId.count] forKey:@"totalRefundCount"];
    [[NSUserDefaults standardUserDefaults] synchronize];


    
    float refundAmountTotal=0.0;
    
    for (int i=0; i<[arr_subFinalDiferentId count]; i++) {
        
        
        NSString *refund;
        
        refund= [NSString stringWithFormat:@"%@",[[arr_subFinalDiferentId objectAtIndex:i] valueForKey:@"totalAmount"]];
        
        refund=[refund stringByReplacingOccurrencesOfString:@"-" withString:@""];
        
        float refundAmount=0.0;
        
        refundAmount=[refund floatValue];
        
        refundAmountTotal=refundAmountTotal+refundAmount;
        
    }

    
  //  labelRefundTotal.text = [NSString stringWithFormat:@"-%@ %0.2f", currencySign, refundAmountTotal];
    
    
    NSMutableDictionary *dict6 = [[NSMutableDictionary alloc]initWithDictionary:[ary_DetailList objectAtIndex:5]];
    [dict6 setObject:[NSString stringWithFormat:@"%@ %@",[NSString stringWithFormat:@"%lu",(unsigned long)arr_subFinalDiferentId.count],[Language get:@"Refund" alter:@"!Refund"]] forKey:@"title"];
    [dict6 setObject:[NSString stringWithFormat:@"-%@ %0.2f", currencySign, refundAmountTotal] forKey:@"value"];
    [ary_DetailList replaceObjectAtIndex:5 withObject:dict6];
    
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"-%@ %0.2f", currencySign, refundAmountTotal] forKey:@"totalRefund"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
#pragma mark Grand total for refund
    
    
    //// Grand total for refundd
    
    
    arr_sub=[[NSMutableArray alloc] init];
    
    
    entityDesc = [NSEntityDescription entityForName:@"RefundAmount"
                inManagedObjectContext:context];
    
    request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
    objects = [context executeFetchRequest:request
                                     error:&error];
    
    
    
    
    for (personRefund in objects)
    {
        //        get error here
        
        
        
        //            if(index != [[personRefund valueForKey:@"rid"]intValue])
        //            {
        
        if (![[arrayRefundCount valueForKey:@"id"]containsObject:[personRefund valueForKey:@"id"]])
        {
            NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
            
            [dic setObject:[personRefund valueForKey:@"id"] forKey:@"id"];
            
            [arrayRefundCount addObject:dic];
        }
        
        index = [[personRefund valueForKey:@"rid"]intValue];
        
        dictSubR = [NSMutableDictionary new];
        
        
        str_id=[personRefund valueForKey:@"id"];
       
        if ([personRefund valueForKey:@"totalAmount"] == nil)
            str_price=@"0";
        else
            str_price=[personRefund valueForKey:@"totalAmount"];
        
        str_code=[personRefund valueForKey:@"code"];
        
        if ([personRefund valueForKey:@"vat"] == nil)
            str_vat=@"0";
        else
        str_vat=[personRefund valueForKey:@"vat"];
        
        [dictSubR setObject:str_price forKey:@"totalAmount"];
        [dictSubR setObject:[personRefund valueForKey:@"price"] forKey:@"price"];
        
        [dictSubR setObject:[personRefund valueForKey:@"refundDate"] forKey:@"refundDate"];
        [dictSubR setObject:str_vat forKey:@"vat"];
        
        [dictSubR setObject:[personRefund valueForKey:@"id"] forKey:@"id"];
        [dictSubR setObject:[personRefund valueForKey:@"code"] forKey:@"code"];
        [dictSubR setObject:[personRefund valueForKey:@"rid"] forKey:@"rid"];
        
        if ([personRefund valueForKey:@"type"] == nil)
            [dictSubR setObject:@"$" forKey:@"type"];
        else
            [dictSubR setObject:[personRefund valueForKey:@"type"] forKey:@"type"];
        
        [dictSubR setObject:[personRefund valueForKey:@"currency"] forKey:@"currency"];
        [dictSubR setObject:[personRefund valueForKey:@"count"] forKey:@"count"];
        [dictSubR setObject:[CommonMethods validateDictionaryValueForKey:[personRefund valueForKey:@"discription"]]?[personRefund valueForKey:@"discription"]:@"" forKey:@"discription"];
       // [dictSubR setObject:[personRefund valueForKey:@"discription"] forKey:@"discription"];
        [dictSubR setObject:@"" forKey:@"image"];
        [dictSubR setObject:[personRefund valueForKey:@"name"] forKey:@"name"];
        
        if ([personRefund valueForKey:@"discount"] == nil)
        {
            [dictSubR setObject:@"0" forKey:@"discount"];
            
        }
        else
        {
            [dictSubR setObject:[personRefund valueForKey:@"discount"] forKey:@"discount"];
        }
        [dictSubR setObject:[personRefund valueForKey:@"time"] forKey:@"time"];
        [dictSubR setObject:[personRefund valueForKey:@"date"] forKey:@"date"];
        
         if ([personRefund valueForKey:@"peritemprice"] == nil)
             [dictSubR setObject:@"0" forKey:@"peritemprice"];
             else
                 [dictSubR setObject:[personRefund valueForKey:@"peritemprice"] forKey:@"peritemprice"];
        
        
        [arr_sub addObject:dictSubR];
        
    }

    refundCount=[arrayRefundCount count];
    
    [appDelegate refundCountUpdate:refundCount :1];
    
    
    arr_subFinal=[[NSMutableArray alloc] init];
    arr_subFinalDiferentId=[[NSMutableArray alloc] init];
    
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
            
            NSString *stringDateTime;
            
            stringDateTime = [NSString stringWithFormat:@"%@",[[arr_sub valueForKey:@"date"] objectAtIndex:i]];
            
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:@"dd MMMM yyyy"];
            
            NSDate *date_get=[dateFormatter dateFromString:stringDateTime];
            NSDate *TranDate = date_get;
            
            
            [dateFormatter setDateFormat:@"MM"];
            
            NSString *str_monthT = [dateFormatter stringFromDate:TranDate];
            NSString *str_monthC = [dateFormatter stringFromDate:selectedDate];
            
            [dateFormatter setDateFormat:@"dd"];
            
            NSString *str_dayT = [dateFormatter stringFromDate:TranDate];
            NSString *str_dayC = [dateFormatter stringFromDate:selectedDate];
            
            [dateFormatter setDateFormat:@"yyyy"];
            
            NSString *str_yearT = [dateFormatter stringFromDate:TranDate];
            NSString *str_yearC = [dateFormatter stringFromDate:selectedDate];
            
            int yearT,yearC,monthT,monthC,dayT,dayC;
            
            
            yearT=[str_yearT intValue];
            yearC=[str_yearC intValue];
            
            monthT=[str_monthT intValue];
            monthC=[str_monthC intValue];
            
            dayT=[str_dayT intValue];
            dayC=[str_dayC intValue];
            
            
            
            if (str_prev!=str_next) {
                
                arr_subFinal=[NSMutableArray new];
                [arr_subFinal addObject:[arr_sub objectAtIndex:i]];
                
                if (yearC<=yearT) {
                    
                    if (monthC<=monthT) {
                        
                        if (dayC>=dayT) {
                            
                            [arr_subFinalDiferentId addObject:[arr_sub objectAtIndex:i]];
                            
                            
                        }
                        
                    }
                    
                }
            }
            else
            {
                [arr_subFinal addObject:[arr_sub objectAtIndex:i]];
                
                if (i==0) {
                    
                    if (yearC<=yearT) {
                        
                        if (monthC<=monthT) {
                            
                            if (dayC>=dayT) {
                                
                                [arr_subFinalDiferentId addObject:[arr_sub objectAtIndex:i]];
                                
                                
                            }
                            
                        }
                        
                    }
                }
            }
            
            
        }
        else
        {
            
            arr_subFinal=arr_sub;
            arr_subFinalDiferentId=arr_sub;
        }
        
        
    }
    

    
    refundAmountTotal=0.0;
    grandTotalRefund=0.0;
    
    for (int i=0; i<[arr_subFinalDiferentId count]; i++) {
        
        
        NSString *refund;
        
        refund= [NSString stringWithFormat:@"%@",[[arr_subFinalDiferentId objectAtIndex:i] valueForKey:@"totalAmount"]];
        
        refund=[refund stringByReplacingOccurrencesOfString:@"-" withString:@""];
        
        float refundAmount=0.0;
        
        refundAmount=[refund floatValue];
        
        grandTotalRefund=grandTotalRefund+refundAmount;
        
    }
    
    
    NSMutableDictionary *dict9 = [[NSMutableDictionary alloc]initWithDictionary:[ary_DetailList objectAtIndex:8]];
    [dict9 setObject:[NSString stringWithFormat:@"%@ %0.2f", currencySign, grandTotalSale] forKey:@"value"];
    [ary_DetailList replaceObjectAtIndex:8 withObject:dict9];
    
    NSMutableDictionary *dict10 = [[NSMutableDictionary alloc]initWithDictionary:[ary_DetailList objectAtIndex:9]];
    [dict10 setObject:[NSString stringWithFormat:@"-%@ %0.2f", currencySign, grandTotalRefund] forKey:@"value"];
    [ary_DetailList replaceObjectAtIndex:9 withObject:dict10];
    
    NSMutableDictionary *dict11 = [[NSMutableDictionary alloc]initWithDictionary:[ary_DetailList objectAtIndex:10]];
    [dict11 setObject:[NSString stringWithFormat:@"%@ %0.2f", currencySign, grandTotalSales_Refund] forKey:@"value"];
    [ary_DetailList replaceObjectAtIndex:10 withObject:dict11];
    
    [collectionView_ReportDetail reloadData];
    
  //  self.grandRefundValue.text = [NSString stringWithFormat:@"%@ %0.2f", currencySign, grandTotalSale];
 //   self.grandSaleRefundValue.text = [NSString stringWithFormat:@"-%@ %0.2f", currencySign, grandTotalRefund];
 //   self.grandTotSaleValue.text = [NSString stringWithFormat:@"%@ %0.2f", currencySign, grandTotalSales_Refund];
    
    
}



-(void)GrandTotal
{
    
    NSMutableArray *arrayTotalSum;
    NSMutableArray *arrayTotalRefund;
    NSMutableArray *arrayTotalSale_Refund;
    NSMutableArray *arrayTotalDiscunt;
    NSMutableArray *arrayTotalSumView;
    
    arrayTotalSum=[NSMutableArray new];
    arrayTotalRefund=[NSMutableArray new];
    arrayTotalSale_Refund=[NSMutableArray new];
    arrayTotalDiscunt=[NSMutableArray new];
    
    arrayTotalSumView=[NSMutableArray new];
    
    
    for (int j=0 ; j<[[dictAllItems valueForKey:@"main"] count];j++) {
        
    
    
    
    for (int i= 0; i < [[[dictAllItems valueForKey:@"main"] objectAtIndex:j] count] ; i++) {
        
        
        NSString *stringDateTime;
        
        stringDateTime = [NSString stringWithFormat:@"%@",[[[[dictAllItems valueForKey:@"main"] objectAtIndex:j] valueForKey:@"totaldatetime"] objectAtIndex:i]];
        
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"dd-MMMM-yyyy, hh:mm a"];
        
        NSDate *date_get=[dateFormatter dateFromString:stringDateTime];
        NSDate *TranDate = date_get;
        
        
        [dateFormatter setDateFormat:@"MM"];
        
        NSString *str_monthT = [dateFormatter stringFromDate:TranDate];
        NSString *str_monthC = [dateFormatter stringFromDate:selectedDate];
        
        [dateFormatter setDateFormat:@"dd"];
        
        NSString *str_dayT = [dateFormatter stringFromDate:TranDate];
        NSString *str_dayC = [dateFormatter stringFromDate:selectedDate];
        
        [dateFormatter setDateFormat:@"yyyy"];
        
        NSString *str_yearT = [dateFormatter stringFromDate:TranDate];
        NSString *str_yearC = [dateFormatter stringFromDate:selectedDate];
        
        int yearT,yearC,monthT,monthC,dayT,dayC;
        
        
        yearT=[str_yearT intValue];
        yearC=[str_yearC intValue];
        
        monthT=[str_monthT intValue];
        monthC=[str_monthC intValue];
        
        dayT=[str_dayT intValue];
        dayC=[str_dayC intValue];
        
        
        if (yearC==yearT) {
            
            if (monthC==monthT) {
                
                if (dayC>=dayT) {
                    
                    [arrayTotalSum addObject:[[[[dictAllItems valueForKey:@"main"] objectAtIndex:j] valueForKey:@"totalSum"] objectAtIndex:i]];
                    [arrayTotalDiscunt addObject:[[[[dictAllItems valueForKey:@"main"] objectAtIndex:j] valueForKey:@"totaldiscount"]objectAtIndex:i]];
                }
                
            }
            else if (monthC>monthT) {
            
                [arrayTotalSum addObject:[[[[dictAllItems valueForKey:@"main"] objectAtIndex:j] valueForKey:@"totalSum"] objectAtIndex:i]];
                [arrayTotalDiscunt addObject:[[[[dictAllItems valueForKey:@"main"] objectAtIndex:j] valueForKey:@"totaldiscount"]objectAtIndex:i]];
            }
            
        }
        else if (yearC>yearT) {
            
            [arrayTotalSum addObject:[[[[dictAllItems valueForKey:@"main"] objectAtIndex:j] valueForKey:@"totalSum"] objectAtIndex:i]];
            [arrayTotalDiscunt addObject:[[[[dictAllItems valueForKey:@"main"] objectAtIndex:j] valueForKey:@"totaldiscount"]objectAtIndex:i]];
        }
        
      }
        
    }
    
    //    for (int i= 0; i < [[[dictAllItems valueForKey:@"main"] objectAtIndex:0] count] ; i++) {
    //
    //
    //
    //        [arrayTotalDiscunt addObject:[[[[dictAllItems valueForKey:@"main"] objectAtIndex:0] valueForKey:@"totaldiscount"]objectAtIndex:i]];
    //
    //
    //
    //    }
    
    
    for (int i= 0; i < [arrayTotalSum count] ; i++) {
        
        
        float sum;
        float dis;
        float sumView;
        
        sum=0.0;
        dis=0.0;
        sumView=0.0;
        
        sum=[[NSString stringWithFormat:@"%@",[arrayTotalSum objectAtIndex:i]]floatValue];
        dis=[[NSString stringWithFormat:@"%@",[arrayTotalDiscunt objectAtIndex:i]]floatValue];
   
        sumView=sum-dis;

        [arrayTotalSumView addObject:[NSString stringWithFormat:@"%0.2f",sumView]];
        
        
    }

    float sum;
    grandTotalSale=0.0;
    
    for (int i= 0; i < [arrayTotalSumView count] ; i++) {
        
        
        sum=0.0;
        
        sum=[[NSString stringWithFormat:@"%@",[arrayTotalSumView objectAtIndex:i]]floatValue];
    
        grandTotalSale=grandTotalSale+sum;
        
        
    }
    grandTotalSales_Refund=grandTotalSale-grandTotalRefund;
    
    
    NSMutableDictionary *dict9 = [[NSMutableDictionary alloc]initWithDictionary:[ary_DetailList objectAtIndex:8]];
    [dict9 setObject:[NSString stringWithFormat:@"%@ %0.2f", currencySign, grandTotalSale] forKey:@"value"];
    [ary_DetailList replaceObjectAtIndex:8 withObject:dict9];
    
    NSMutableDictionary *dict10 = [[NSMutableDictionary alloc]initWithDictionary:[ary_DetailList objectAtIndex:9]];
    [dict10 setObject:[NSString stringWithFormat:@"-%@ %0.2f", currencySign, grandTotalRefund] forKey:@"value"];
    [ary_DetailList replaceObjectAtIndex:9 withObject:dict10];
    
    NSMutableDictionary *dict11 = [[NSMutableDictionary alloc]initWithDictionary:[ary_DetailList objectAtIndex:10]];
    [dict11 setObject:[NSString stringWithFormat:@"%@ %0.2f", currencySign, grandTotalSales_Refund] forKey:@"value"];
    [ary_DetailList replaceObjectAtIndex:10 withObject:dict11];
    
    [collectionView_ReportDetail reloadData];
    
//    self.grandRefundValue.text = [NSString stringWithFormat:@"%@ %0.2f", currencySign, grandTotalSale];
//    self.grandSaleRefundValue.text = [NSString stringWithFormat:@"-%@ %0.2f", currencySign, grandTotalRefund];
//    self.grandTotSaleValue.text = [NSString stringWithFormat:@"%@ %0.2f", currencySign, grandTotalSales_Refund];
    
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%0.2f", grandTotalSale] forKey:@"grandTotalSale"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%0.2f", grandTotalRefund] forKey:@"grandTotalRefund"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%0.2f", grandTotalSales_Refund] forKey:@"grandTotalSale_Refund"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self VatCalculation];
    
}

-(void)VatCalculation
{
    
    [self getVatarray];
    
    
    //    labelFirstProductQntity.layer.cornerRadius = 11.0f;
    //    labelSecondProductQntity.layer.cornerRadius = 11.0f;
    
    NSMutableArray *arraySub = [NSMutableArray new];
    NSMutableDictionary *dictSubbM = [NSMutableDictionary new];
    NSMutableArray *arrayMain = [NSMutableArray new];
    
    NSString *curMonth = nil;
    NSString *curDay = nil;
    NSString *curDayE=nil;
    NSString *str_IDs=@"";
    
    
    NSString *totaldatetime = nil;
    NSString *totaldate=nil;
    
    
    int countPayment = 0;
    int swishPayment = 0;
    int otherPayment = 0;
    int cardPayment = 0;
    
    
    int curId=-1;
    
    float tpricewithoutvat = 0.0;
    total=0.0;
    totalvat=0.0;
    float totalSum=0.0;
    
    NSManagedObjectContext *context =[appDelegate managedObjectContext];
    NSEntityDescription *entityDesc =[NSEntityDescription entityForName:@"Trasections" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    
    NSArray *descriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:descriptors];
    
    
    NSEntityDescription *entityDesc2 =[NSEntityDescription entityForName:@"CustomDiscount" inManagedObjectContext:context];
    NSFetchRequest *request11 = [[NSFetchRequest alloc] init];
    [request11 setEntity:entityDesc2];
    //    NSPredicate *predicate;
    
    
    NSError *error;
    
    NSArray *objects = [context executeFetchRequest:request error:&error];
    
    int sum=0;
    
    NSArray *objects2;
    
    NSMutableDictionary *dictSub;
    
    int finalID = 0;
    
    for(int i=0;i<objects.count;i++)
    {
        
        //        NSMutableDictionary *dictMain = [NSMutableDictionary new];
        dictSub = [NSMutableDictionary new];
        
        NSManagedObject *person = (NSManagedObject *)[objects objectAtIndex:i];
        
        
        finalID = [[person valueForKey:@"id"] intValue];
        
        NSData *da=[person valueForKey:@"image"];
        
        UIImage *img=[[UIImage alloc] initWithData:da];
        
        [dictSub setObject:img forKey:@"image"];
        [dictSub setObject:[person valueForKey:@"name"] forKey:@"name"];
        [dictSub setObject:[person valueForKey:@"count"] forKey:@"count"];
        
        float newPrice = [[person valueForKey:@"price"] floatValue] ;//- [[person valueForKey:@"discount"] floatValue];
        
        [dictSub setObject:[NSString stringWithFormat:@"%f",newPrice] forKey:@"price"];
        
        
        float str = newPrice * [[person valueForKey:@"count"] floatValue];
        
        [dictSub setObject:[NSString stringWithFormat:@"%.02f", str] forKey:@"newprice"];
        
        [dictSub setObject:[person valueForKey:@"vat"] forKey:@"vat"];
        
        
        
        [dictSub setObject:[person valueForKey:@"discount"] forKey:@"discount"];
        [dictSub setObject:[person valueForKey:@"id"] forKey:@"id"];
        
        [dictSub setObject:[CommonMethods validateDictionaryValueForKey:[person valueForKey:@"discription"]]?[person valueForKey:@"discription"]:@"" forKey:@"discription"];
     //   [dictSub setObject:[person valueForKey:@"discription"] forKey:@"discription"];
        
        
        NSDate *date  = [person valueForKey:@"date"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        // Convert date object into desired format
        [dateFormatter setDateFormat:@"MMMM yyyy"];
        NSString *newDateString = [dateFormatter stringFromDate:date];
        [dictSub setObject:newDateString forKey:@"month"];
        
        [dateFormatter setDateFormat:@"dd"];
        NSString *day =[dateFormatter stringFromDate:date];
        
        
        [dateFormatter setDateFormat:@"EEEE"];
        NSString *dayE = [dateFormatter stringFromDate:date];
        
        NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
        // Convert date object into desired format
        [dateFormatter1 setDateFormat:@"dd-MMMM-yyyy, hh:mm a"];
        
        NSString *tdatetime = [dateFormatter1 stringFromDate:date];
        
        
        NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
        // Convert date object into desired format
        [dateFormatter2 setDateFormat:@"dd MMMM yyyy"];
        
        NSString *tDate = [dateFormatter2 stringFromDate:date];
        
        
        
        total=([[person valueForKey:@"price"] floatValue] *[[person valueForKey:@"count"] integerValue]-[[person valueForKey:@"discount"]floatValue]) + total;
        
        
        
        
        if(curDay== nil)
        {
            
            if ([_str_paymentMethod isEqualToString:@"2"]) {
                cardPayment =1;
            }
            else if ([_str_paymentMethod isEqualToString:@"1"])
            {
                countPayment =1;
            }
            else if ([_str_paymentMethod isEqualToString:@"3"])
            {
                swishPayment =1;
            }
            else if([_str_paymentMethod isEqualToString:@"4"])
            {
                otherPayment =1;
            }
            
            curDay = day;
            curDayE = dayE;
            curId =  [[person valueForKey:@"id"] intValue];
            totaldate=tDate;
            totaldatetime = tdatetime;
            currentDate=tDate;
            
            NSArray* ary_ID = [str_IDs componentsSeparatedByString: @","];
            
            
            if ([ary_ID count]>0)
            {
                if (![ary_ID containsObject:[NSString stringWithFormat:@"%@",[person valueForKey:@"id"]]])
                {
                    str_IDs = [NSString stringWithFormat:@"%@,%@",str_IDs,[person valueForKey:@"id"]];
                }
            }
            
        }
        
        else if (![curDay isEqualToString:day])
        {
            
            int refundCount = 0 ;
            float totalammount = 0;
            
            NSManagedObjectContext *context =
            [appDelegate managedObjectContext];
            
            NSEntityDescription *entityDesc =
            [NSEntityDescription entityForName:@"RefundAmount"
                        inManagedObjectContext:context];
            
            NSFetchRequest *request = [[NSFetchRequest alloc] init];
            [request setEntity:entityDesc];
            
            NSPredicate *pred =
            [NSPredicate predicateWithFormat:@"(date = %@)",totaldate];
            [request setPredicate:pred];
            //    NSManagedObject *matches = nil;
            
            NSError *error;
            NSArray *objects = [context executeFetchRequest:request
                                                      error:&error];
            
            
            
            for (NSManagedObject *personRefund in objects)
            {
                //Problem
                refundCount ++;
                //                totalammount = totalammount + [[personRefund valueForKey:@"totalAmount"] floatValue];
                totalammount = [[personRefund valueForKey:@"totalAmount"] floatValue];
            }
            
            
            if ([str_IDs hasPrefix:@","])
            {
                str_IDs = [str_IDs substringFromIndex:1];
            }
            
            float discount = [self GetDiscountList:str_IDs];
            
            float totalPrice = 0.0;
            float vat = 0.0;
            float vatPercent = (totalvat*100)/tpricewithoutvat;
            
            if ([str_DiscountType isEqualToString:@"$"])
            {
                
                totalPrice = totalSum - discount;
                
            }
            else
            {
                totalPrice = totalSum - ((totalSum*discount)/100);
                
            }
            vat = totalPrice-(totalPrice/(1+vatPercent/100));
            
            
            NSMutableDictionary *dictSubb = [NSMutableDictionary new];
            [dictSubb setObject:curDay forKey:@"day"];
            [dictSubb setObject:curDayE forKey:@"dayE"];
            [dictSubb setObject:dictSubbM forKey:@"sub"];
            [dictSubb setObject:[NSString stringWithFormat:@"%d",countPayment] forKey:@"countPayment"];
            [dictSubb setObject:[NSString stringWithFormat:@"%d",cardPayment] forKey:@"cardPayment"];
            [dictSubb setObject:[NSString stringWithFormat:@"%d",swishPayment] forKey:@"swishPayment"];
            [dictSubb setObject:[NSString stringWithFormat:@"%d",otherPayment] forKey:@"otherPayment"];
            [dictSubb setObject:[NSString stringWithFormat:@"%f",totalSum] forKey:@"totalSum"];
            [dictSubb setObject:[NSString stringWithFormat:@"%f",vat] forKey:@"totalvat"];
            [dictSubb setObject:totaldatetime forKey:@"totaldatetime"];
            [dictSubb setObject:str_IDs forKey:@"finalid"];
            [dictSubb setObject:totaldate forKey:@"totaldate"];
            [dictSubb setObject:[NSString stringWithFormat:@"%.2f",discount] forKey:@"totaldiscount"];
            [dictSubb setObject:[NSString stringWithFormat:@"%d",refundCount] forKey:@"refundCount"];
            [dictSubb setObject:[NSString stringWithFormat:@"%.2f",totalammount] forKey:@"refundTotal"];
            [arraySub addObject:dictSubb];
            
            total = 0;
            totalvat = 0;
            tpricewithoutvat = 0;
            
            str_IDs = @"";
            totalSum = 0;
            sum = 0;
            dictSubbM = [NSMutableDictionary new];
            totaldate=tDate;
            currentDate=tDate;
            totaldatetime = tdatetime;
            if ([_str_paymentMethod isEqualToString:@"2"]) {
                cardPayment =1;
            }
            else if ([_str_paymentMethod isEqualToString:@"1"])
            {
                countPayment =1;
            }
            else if ([_str_paymentMethod isEqualToString:@"3"])
            {
                swishPayment =1;
            }
            else if([_str_paymentMethod isEqualToString:@"4"])
            {
                otherPayment =1;
            }
            
            curDay = day;
            curDayE = dayE;
            
        }
        else
        {
            
            if(curId!=[[person valueForKey:@"id"] intValue])
            {
                if ([_str_paymentMethod isEqualToString:@"2"]) {
                    cardPayment++;
                }
                else if ([_str_paymentMethod isEqualToString:@"1"])
                {
                    countPayment++;
                }
                else if ([_str_paymentMethod isEqualToString:@"3"])
                {
                    swishPayment++;
                }
                else if([_str_paymentMethod isEqualToString:@"4"])
                {
                    otherPayment++;
                }
            }
            
            NSArray* ary_ID = [str_IDs componentsSeparatedByString: @","];
            
            
            if ([ary_ID count]>0)
            {
                if (![ary_ID containsObject:[NSString stringWithFormat:@"%@",[person valueForKey:@"id"]]])
                {
                    str_IDs = [NSString stringWithFormat:@"%@,%@",str_IDs,[person valueForKey:@"id"]];
                }
            }
        }

        if(curMonth==nil)
            curMonth = newDateString;
        else if (![curMonth isEqualToString:newDateString])
        {
            
            NSMutableDictionary *dictMain = [NSMutableDictionary new];
            [dictMain setObject:curMonth forKey:@"month"];
            [dictMain setObject:arraySub forKey:@"main"];
            [arrayMain addObject:dictMain];
            
            arraySub = [NSMutableArray new];
            curMonth = newDateString;
            currentDate= newDateString;
        }
        
        
        if(curId!=[[person valueForKey:@"id"] intValue])
        {
            //            countPayment++;
            curId=[[person valueForKey:@"id"] intValue];
        }
        
        
        
        NSPredicate *predicate;
        predicate = [NSPredicate predicateWithFormat:@"(id = %@)", [person valueForKey:@"id"]];
        [request11 setPredicate:predicate];
        
        
        NSError *error2;
        objects2 = [context executeFetchRequest:request11 error:&error2];
        
        NSManagedObject *person2;
        
        for(int i=0;i<objects2.count;i++)
        {
            person2 = (NSManagedObject *)[objects2 objectAtIndex:i];
            
            float discount = 0.0;
            
            [dictSub setObject:[person2 valueForKey:@"discount"] forKey:@"customdiscount"];
            
            
        }
        
        
//        total = ([[person valueForKey:@"price"] floatValue] * [[person valueForKey:@"count"] integerValue]);
        
        total=([[person valueForKey:@"price"] floatValue] *[[person valueForKey:@"count"] integerValue]-[[person valueForKey:@"discount"]floatValue]) + total;
        
        zzzz = (([[person valueForKey:@"price"] floatValue]*[[person valueForKey:@"count"] integerValue])-[[person valueForKey:@"discount"]floatValue]) / (1 + [[person valueForKey:@"vat"] floatValue]/100);
        
        
        
        zzzz=(([[person valueForKey:@"price"] floatValue] *[[person valueForKey:@"count"] integerValue])-[[person valueForKey:@"discount"]floatValue])-zzzz;
        
        
        tpricewithoutvat = (([[person valueForKey:@"price"] floatValue]*[[person valueForKey:@"count"] integerValue])-[[person valueForKey:@"discount"]floatValue]) / (1 + [[person valueForKey:@"vat"] floatValue]/100) + tpricewithoutvat;
        
        totalvat = zzzz + totalvat;
        
        
        //        NSString *stringDateTime;
        //
        //        stringDateTime = [NSString stringWithFormat:@"%@",[person valueForKey:@"date"]];
        //
        //
        //        dateFormatter = [[NSDateFormatter alloc]init];
        //        [dateFormatter setDateFormat:@"dd-MMMM-yyyy, hh:mm a"];
        //
        //        NSDate *date_get=[dateFormatter dateFromString:stringDateTime];
        //        NSDate *TranDate = date_get;
        
        NSDate *TranDate=[person valueForKey:@"date"];
        
        [dateFormatter setDateFormat:@"MM"];
        
        NSString *str_monthT = [dateFormatter stringFromDate:TranDate];
        NSString *str_monthC = [dateFormatter stringFromDate:selectedDate];
        
        [dateFormatter setDateFormat:@"dd"];
        
        NSString *str_dayT = [dateFormatter stringFromDate:TranDate];
        NSString *str_dayC = [dateFormatter stringFromDate:selectedDate];
        
        [dateFormatter setDateFormat:@"yyyy"];
        
        NSString *str_yearT = [dateFormatter stringFromDate:TranDate];
        NSString *str_yearC = [dateFormatter stringFromDate:selectedDate];
        
        int yearT,yearC,monthT,monthC,dayT,dayC;
        
        
        yearT=[str_yearT intValue];
        yearC=[str_yearC intValue];
        
        monthT=[str_monthT intValue];
        monthC=[str_monthC intValue];
        
        dayT=[str_dayT intValue];
        dayC=[str_dayC intValue];
        
        
        if (yearC==yearT) {
            
            if (monthC==monthT) {
                
                if (dayC>=dayT) {
                    
                    
                    int jCount=[[person valueForKey:@"count"] intValue];
                    
                    for (int j=0; j<jCount; j++) {
                        
                        
                        for (int i=0; i<[vatArray count]; i++) {

                            if ([[[vatArray objectAtIndex:i] valueForKey:@"vat"]isEqualToString:[NSString stringWithFormat:@"%@",[person valueForKey:@"vat"]]]) {
                                
                                
                                float vat_value=0.0;
                                
                                float str_ProPrice=0.0;
                                float str_ProVat=0.0;
                                float str_proDis=0.0;
                                float str_proDisAmount=0.0;
                                float str_proTotalAmount=0.0;
                                float str_perProVat=0.0;
                                float str_perProPrice=0.0;
                               
                                
                                str_ProPrice=([[person valueForKey:@"price"] floatValue]-[[person valueForKey:@"discount"]floatValue]);

                                
                                str_ProVat=[[person valueForKey:@"vat"] floatValue];
    
                                if (objects2.count>0) {
                                    
                                    str_proDisAmount=[[person2 valueForKey:@"discount"] floatValue];
                                    
                                    
                                    
                                    str_proTotalAmount=[[person2 valueForKey:@"totalAmount"] floatValue];
                                    
                                    
                                    str_proDis=(str_proDisAmount/str_proTotalAmount)*100;
                                    
                                }
                                else
                                {
                                    str_proDisAmount=0.0;
                                    str_proTotalAmount=0.0;
                                    
                                    str_proDis=0.0;
                                }
                                

                                
                                str_perProPrice=str_ProPrice/(1+str_ProVat/100);
           
                                
                                str_perProVat=str_ProPrice-str_perProPrice;
           
                                float A=0;
                                float B=0;
                                float C=0;
                                float D=0;
                                
                                A=(str_perProVat*100)/str_perProPrice;
                                
                                
                                B=(str_proDis/100)*str_ProPrice;
                                
                                //                   C=str_ProPrice-(B/100)*str_ProPrice;
                                C=str_ProPrice-B;
                                
                                
                                
                                
                                D=C-(C/(1+A/100));
                                
           
                                
                                vat_value=[[[vatArray objectAtIndex:i] valueForKey:@"vatTotal"] floatValue];
                                
                                vat_value=vat_value+D;
                                
                                
                                for(NSMutableDictionary *dict in vatArray)
                                {
                                    
                                    
                                    if ([[dict valueForKey:@"vat"]isEqualToString:[NSString stringWithFormat:@"%@",[person valueForKey:@"vat"]]])
                                    {
                                        [dict setObject:[NSString stringWithFormat:@"%.02f",vat_value] forKey:@"vatTotal"];
                                    }
                                    
                                }
                                
                                
                                //            }
                                
                            }
                        }
                    }
                    
                    
                    
                }
                
            }
            else if(monthC>monthT)
            {
                
                int jCount=[[person valueForKey:@"count"] intValue];
                
                for (int j=0; j<jCount; j++) {
                    
                    
                    for (int i=0; i<[vatArray count]; i++) {
               
                        
                        if ([[[vatArray objectAtIndex:i] valueForKey:@"vat"]isEqualToString:[NSString stringWithFormat:@"%@",[person valueForKey:@"vat"]]]) {
                            
                            
                            float vat_value=0.0;
                            
                            float str_ProPrice=0.0;
                            float str_ProVat=0.0;
                            float str_proDis=0.0;
                            float str_proDisAmount=0.0;
                            float str_proTotalAmount=0.0;
                            float str_perProVat=0.0;
                            float str_perProPrice=0.0;
                    
                            
                            str_ProPrice=([[person valueForKey:@"price"] floatValue]-[[person valueForKey:@"discount"]floatValue]);
                            
                            
                            str_ProVat=[[person valueForKey:@"vat"] floatValue];

                            
                            if (objects2.count>0) {
                                
                                str_proDisAmount=[[person2 valueForKey:@"discount"] floatValue];
                                
                                
                                str_proTotalAmount=[[person2 valueForKey:@"totalAmount"] floatValue];
                                
                                
                                str_proDis=(str_proDisAmount/str_proTotalAmount)*100;
                                
                            }
                            else
                            {
                                str_proDisAmount=0.0;
                                str_proTotalAmount=0.0;
                                
                                str_proDis=0.0;
                            }


                            
                            str_perProPrice=str_ProPrice/(1+str_ProVat/100);
                  
                            str_perProVat=str_ProPrice-str_perProPrice;
          
                            float A=0;
                            float B=0;
                            float C=0;
                            float D=0;
                            
                            A=(str_perProVat*100)/str_perProPrice;
                            
                            
                            B=(str_proDis/100)*str_ProPrice;
                            
                            //                   C=str_ProPrice-(B/100)*str_ProPrice;
                            C=str_ProPrice-B;
                            
                            
                            D=C-(C/(1+A/100));
                            

                            
                            vat_value=[[[vatArray objectAtIndex:i] valueForKey:@"vatTotal"] floatValue];
                            
                            vat_value=vat_value+D;
                            
                            
                            for(NSMutableDictionary *dict in vatArray)
                            {
                                
                                
                                if ([[dict valueForKey:@"vat"]isEqualToString:[NSString stringWithFormat:@"%@",[person valueForKey:@"vat"]]])
                                {
                                    [dict setObject:[NSString stringWithFormat:@"%.02f",vat_value] forKey:@"vatTotal"];
                                }
                                
                            }
                            
                        }
                    }
                }
                
                
                
            }
            
        }
        else if(yearC>yearT)
        {
            
            
            int jCount=[[person valueForKey:@"count"] intValue];
            
            for (int j=0; j<jCount; j++) {
                
                
                for (int i=0; i<[vatArray count]; i++) {

                    
                    if ([[[vatArray objectAtIndex:i] valueForKey:@"vat"]isEqualToString:[NSString stringWithFormat:@"%@",[person valueForKey:@"vat"]]]) {
                     
                        float vat_value=0.0;
                        
                        float str_ProPrice=0.0;
                        float str_ProVat=0.0;
                        float str_proDis=0.0;
                        float str_proDisAmount=0.0;
                        float str_proTotalAmount=0.0;
                        float str_perProVat=0.0;
                        float str_perProPrice=0.0;
                        
                        
                        str_ProPrice=([[person valueForKey:@"price"] floatValue]-[[person valueForKey:@"discount"]floatValue]);
                        

                        
                        str_ProVat=[[person valueForKey:@"vat"] floatValue];
                
                        if (objects2.count>0) {
                            
                            str_proDisAmount=[[person2 valueForKey:@"discount"] floatValue];
                            
                            
                            
                            str_proTotalAmount=[[person2 valueForKey:@"totalAmount"] floatValue];
                            
                            
                            str_proDis=(str_proDisAmount/str_proTotalAmount)*100;
                            
                        }
                        else
                        {
                            str_proDisAmount=0.0;
                            str_proTotalAmount=0.0;
                            
                            str_proDis=0.0;
                        }
                        
 
                        
                        str_perProPrice=str_ProPrice/(1+str_ProVat/100);
      
                        str_perProVat=str_ProPrice-str_perProPrice;
   
                        float A=0;
                        float B=0;
                        float C=0;
                        float D=0;
                        
                        A=(str_perProVat*100)/str_perProPrice;
                        
                        
                        B=(str_proDis/100)*str_ProPrice;
                        
                        //                   C=str_ProPrice-(B/100)*str_ProPrice;
                        C=str_ProPrice-B;
                        
                        
                        
                        D=C-(C/(1+A/100));
                        
    
                        
                        vat_value=[[[vatArray objectAtIndex:i] valueForKey:@"vatTotal"] floatValue];
                        
                        vat_value=vat_value+D;
                        
                        
                        for(NSMutableDictionary *dict in vatArray)
                        {
                            
                            
                            if ([[dict valueForKey:@"vat"]isEqualToString:[NSString stringWithFormat:@"%@",[person valueForKey:@"vat"]]])
                            {
                                [dict setObject:[NSString stringWithFormat:@"%.02f",vat_value] forKey:@"vatTotal"];
                            }
                            
                        }
                        
                    }
                }
            }
            
            
            
        }

        
        totalSum = totalSum + total;
        
        if([dictSubbM objectForKey:[dictSub valueForKey:@"name"]])
        {
            
            NSMutableDictionary *dictTemp = [dictSubbM  objectForKey:[dictSub valueForKey:@"name"]];
            int countTemp = [[dictTemp valueForKey:@"count"] intValue] + [[dictSub valueForKey:@"count"] intValue];
            [dictTemp setObject:[NSString stringWithFormat:@"%d",countTemp] forKey:@"count"];
            [dictSubbM setObject:dictTemp forKey:[dictSub valueForKey:@"name"]];
            
        }
        else
        {
            [dictSubbM setObject:dictSub forKey:[dictSub valueForKey:@"name"]];
        }

    }

    
    NSMutableString *str_vat=[[NSMutableString alloc] init];
    NSString *str_per=@"%";
    
    float TotalVat=00;
    
    [str_vat appendString:@"( "];
    
    
    
    for (int i=0; i<[vatArray count]; i++) {

        if ([[[vatArray objectAtIndex:i] valueForKey:@"vatTotal"]floatValue]>0) {
            
            TotalVat=TotalVat+[[[vatArray objectAtIndex:i] valueForKey:@"vatTotal"] floatValue];
            
            [str_vat appendString:[NSString stringWithFormat:@"%@%@ : %@, ",[[vatArray objectAtIndex:i] valueForKey:@"vat"],str_per,[[vatArray objectAtIndex:i] valueForKey:@"vatTotal"]]];
            
        }
    }
    
    [str_vat deleteCharactersInRange:NSMakeRange([str_vat length]-2, 1)];
    if (TotalVat>0) {
        [str_vat appendString:@")"];
    }

    
    NSMutableDictionary *dict13 = [[NSMutableDictionary alloc]initWithDictionary:[ary_DetailList objectAtIndex:12]];
    [dict13 setObject:[NSString stringWithFormat:@"%@ %.02f %@",currencySign,TotalVat,str_vat] forKey:@"value"];
    [ary_DetailList replaceObjectAtIndex:12 withObject:dict13];
    
    
   // labelFeeValue.text=[NSString stringWithFormat:@"%@ %.02f %@",currencySign,TotalVat,str_vat];

    
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%.02f %@",TotalVat,str_vat] forKey:@"totalVat"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%lu",(unsigned long)objects.count] forKey:@"productCount"];
    
}

#pragma mark start ZDayReport

-(void)getZdayReport:(NSDate *)Date
{
    
    self.dayMonthSegmentBtn.selectedSegmentIndex = 2;
    
    self.btnGenerateZDay.hidden = NO;
    self.viewBaseTopSelling.hidden = YES;
    tableViewItems.hidden = YES;
    self.labelReportNumber.hidden = NO;
    
    dictAllZDayItems = [NSMutableArray new];
    
    str_datefrom=@"Day";
    
    
    NSMutableArray *arraySub = [NSMutableArray new];
    NSMutableDictionary *dictSubbM = [NSMutableDictionary new];
    NSMutableArray *arrayMain = [NSMutableArray new];
    
    NSString *curMonth = nil;
    NSString *curDay = nil;
    NSString *curDayE=nil;
    NSString *str_IDs=@"";
    
    
    NSString *totaldatetime = nil;
    NSString *totaldate=nil;
    
    
    int countPayment = 0;
    int swishPayment = 0;
    int otherPayment = 0;
    int cardPayment = 0;
    
    int curId=-1;
    
    float tpricewithoutvat = 0.0;
    total=0.0;
    totalvat=0.0;
    float totalSum=0.0;
    float totalSumCard=0.0;
    float totalSumCash=0.0;
    float totalSumSwish=0.0;
    float totalSumOther=0.0;
    

    NSManagedObjectContext *context =[appDelegate managedObjectContext];
    NSEntityDescription *entityDesc =[NSEntityDescription entityForName:@"Trasections" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    
    NSArray *descriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:descriptors];
    
    
    
    NSEntityDescription *entityDesc2 =[NSEntityDescription entityForName:@"CustomDiscount" inManagedObjectContext:context];
    NSFetchRequest *request11 = [[NSFetchRequest alloc] init];
    [request11 setEntity:entityDesc2];
    //    NSPredicate *predicate;
    
    
    NSError *error;
    
    NSArray *objects = [context executeFetchRequest:request error:&error];
    
    int sum=0;
    
    NSArray *objects2;
    
    NSMutableDictionary *dictSub;
    
    NSMutableDictionary *dictProCount;
    NSMutableArray *arrayProCount;
    arrayProCount=[[NSMutableArray alloc] init];
    
    int finalID = 0;
    
    int proCount=0;
    
    
    arraySub=[[NSMutableArray alloc] init];
    for(int i=0;i<objects.count;i++)
    {
        dictSub = [NSMutableDictionary new];
        
        NSManagedObject *person = (NSManagedObject *)[objects objectAtIndex:i];
      
        
        if ([[person valueForKey:@"zdayStatus"] intValue]==0) {
            

//            if ([[arrayProCount valueForKey:@"article_id"]containsObject:[person valueForKey:@"article_id"]])
//            {
                NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
                
                [dic setObject:[person valueForKey:@"article_id"] forKey:@"article_id"];
                [dic setObject:[person valueForKey:@"count"] forKey:@"count"];
                
                [arrayProCount addObject:dic];
//            }
            
            
            
         //            dictProCount = [[NSMutableDictionary alloc]initWithObjectsAndKeys:[person valueForKey:@"id"],@"ProId", [person valueForKey:@"count"],@"proCount" ,nil];
//            arrayProCount = [[NSMutableArray alloc]initWithObjects:dictProCount, nil];
            
           
            
                
            proCount=proCount+[[person valueForKey:@"count"]intValue];

           
            
            ztotalProduct=[NSString stringWithFormat:@"%lu",(unsigned long)proCount];
            
            
            finalID = [[person valueForKey:@"id"] intValue];
            
            NSData *da=[person valueForKey:@"image"];
            
            UIImage *img=[[UIImage alloc] initWithData:da];
            
            [dictSub setObject:img forKey:@"image"];
            [dictSub setObject:[person valueForKey:@"name"] forKey:@"name"];
            [dictSub setObject:[person valueForKey:@"count"] forKey:@"count"];
           
            float newPrice = [[person valueForKey:@"price"] floatValue] ;//- [[person valueForKey:@"discount"] floatValue];
            
            [dictSub setObject:[NSString stringWithFormat:@"%f",newPrice] forKey:@"price"];
            
            
            float str = newPrice * [[person valueForKey:@"count"] floatValue];
            
            [dictSub setObject:[NSString stringWithFormat:@"%.02f", str] forKey:@"newprice"];
            
            [dictSub setObject:[person valueForKey:@"vat"] forKey:@"vat"];
            
            
            
            [dictSub setObject:[person valueForKey:@"discount"] forKey:@"discount"];
            [dictSub setObject:[person valueForKey:@"id"] forKey:@"id"];
            
            [dictSub setObject:[CommonMethods validateDictionaryValueForKey:[person valueForKey:@"discription"]]?[person valueForKey:@"discription"]:@"" forKey:@"discription"];
        //    [dictSub setObject:[person valueForKey:@"discription"] forKey:@"discription"];
            [dictSub setObject:[person valueForKey:@"paymentMethod"] forKey:@"paymentMethod"];
            
            
            _str_paymentMethod = [NSString stringWithFormat:@"%@",[person valueForKey:@"paymentMethod"]];
            
//            if ([[person valueForKey:@"paymentMethod"] isEqualToString:@"2"]) {
//                
//                _str_paymentMethod = @"2";
//            }
//            else{
//                _str_paymentMethod = @"1";
//            }
            
            NSDate *date  = [person valueForKey:@"date"];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            // Convert date object into desired format
            [dateFormatter setDateFormat:@"MMMM yyyy"];
            NSString *newDateString = [dateFormatter stringFromDate:date];
            [dictSub setObject:newDateString forKey:@"month"];
            
            [dateFormatter setDateFormat:@"dd"];
            NSString *day =[dateFormatter stringFromDate:date];
            
            
            [dateFormatter setDateFormat:@"EEEE"];
            NSString *dayE = [dateFormatter stringFromDate:date];
            
            NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
            // Convert date object into desired format
            [dateFormatter1 setDateFormat:@"dd-MMMM-yyyy, hh:mm a"];
            
            NSString *tdatetime = [dateFormatter1 stringFromDate:date];
            
            
            NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
            // Convert date object into desired format
            [dateFormatter2 setDateFormat:@"dd MMMM yyyy"];
            
            NSString *tDate = [dateFormatter2 stringFromDate:date];
            
            
            
            total=([[person valueForKey:@"price"] floatValue] *[[person valueForKey:@"count"] integerValue]-[[person valueForKey:@"discount"]floatValue]) + total;
            
            
            if(curDay== nil)
            {
                
                if ([_str_paymentMethod isEqualToString:@"2"])
                {
                    cardPayment=1;
                }
                else if ([_str_paymentMethod isEqualToString:@"1"])
                {
                    countPayment=1;
                }
                else if ([_str_paymentMethod isEqualToString:@"3"])
                {
                    swishPayment=1;
                }
                else if([_str_paymentMethod isEqualToString:@"4"])
                {
                    otherPayment=1;
                }
                
                curDay = day;
                curDayE = dayE;
                curId =  [[person valueForKey:@"id"] intValue];
                totaldate=tDate;
                totaldatetime = tdatetime;
                currentDate=tDate;
                
                NSArray* ary_ID = [str_IDs componentsSeparatedByString: @","];
                
                
                if ([ary_ID count]>0)
                {
                    if (![ary_ID containsObject:[NSString stringWithFormat:@"%@",[person valueForKey:@"id"]]])
                    {
                        str_IDs = [NSString stringWithFormat:@"%@,%@",str_IDs,[person valueForKey:@"id"]];
                    }
                }
                
            }
            
            else if (![curDay isEqualToString:day])
            {
                
                int refundCount = 0 ;
                float totalammount = 0;
                
                NSManagedObjectContext *context =
                [appDelegate managedObjectContext];
                
                NSEntityDescription *entityDesc =
                [NSEntityDescription entityForName:@"RefundAmount"
                            inManagedObjectContext:context];
                
                NSFetchRequest *request = [[NSFetchRequest alloc] init];
                [request setEntity:entityDesc];
                
                NSPredicate *pred =
                [NSPredicate predicateWithFormat:@"(date = %@)",totaldate];
                [request setPredicate:pred];
                //    NSManagedObject *matches = nil;
                
                NSError *error;
                NSArray *objects = [context executeFetchRequest:request
                                                          error:&error];
                
                
                
                for (NSManagedObject *personRefund in objects)
                {
                    //Problem
                    refundCount ++;
                    //                totalammount = totalammount + [[personRefund valueForKey:@"totalAmount"] floatValue];
                    totalammount = [[personRefund valueForKey:@"totalAmount"] floatValue];
                }
                
                
                if ([str_IDs hasPrefix:@","])
                {
                    str_IDs = [str_IDs substringFromIndex:1];
                }
                
                float discount = [self GetDiscountList:str_IDs];
                
                float totalPrice = 0.0;
                float vat = 0.0;
                float vatPercent = (totalvat*100)/tpricewithoutvat;
                
                if ([str_DiscountType isEqualToString:@"$"])
                {
                    
                    totalPrice = totalSum - discount;
                    
                }
                else
                {
                    totalPrice = totalSum - ((totalSum*discount)/100);
                    
                }
                
                vat = totalPrice-(totalPrice/(1+vatPercent/100));

                NSMutableDictionary *dictSubb = [NSMutableDictionary new];
                [dictSubb setObject:curDay forKey:@"day"];
                [dictSubb setObject:curDayE forKey:@"dayE"];
                [dictSubb setObject:dictSubbM forKey:@"sub"];
                [dictSubb setObject:[NSString stringWithFormat:@"%d",countPayment] forKey:@"countPayment"];
                [dictSubb setObject:[NSString stringWithFormat:@"%d",cardPayment] forKey:@"cardPayment"];
                [dictSubb setObject:[NSString stringWithFormat:@"%d",swishPayment] forKey:@"swishPayment"];
                [dictSubb setObject:[NSString stringWithFormat:@"%d",otherPayment] forKey:@"otherPayment"];
                [dictSubb setObject:[NSString stringWithFormat:@"%f",totalSum] forKey:@"totalSum"];
                [dictSubb setObject:[NSString stringWithFormat:@"%f",totalSumCard] forKey:@"totalSumCard"];
                [dictSubb setObject:[NSString stringWithFormat:@"%f",totalSumCash] forKey:@"totalSumCash"];
                [dictSubb setObject:[NSString stringWithFormat:@"%f",totalSumSwish] forKey:@"totalSumSwish"];
                [dictSubb setObject:[NSString stringWithFormat:@"%f",totalSumOther] forKey:@"totalSumOther"];
                [dictSubb setObject:[NSString stringWithFormat:@"%f",vat] forKey:@"totalvat"];
                [dictSubb setObject:totaldatetime forKey:@"totaldatetime"];
                [dictSubb setObject:str_IDs forKey:@"finalid"];
                [dictSubb setObject:totaldate forKey:@"totaldate"];
                [dictSubb setObject:[NSString stringWithFormat:@"%.2f",discount] forKey:@"totaldiscount"];
                [dictSubb setObject:[NSString stringWithFormat:@"%d",refundCount] forKey:@"refundCount"];
                [dictSubb setObject:[NSString stringWithFormat:@"%.2f",totalammount] forKey:@"refundTotal"];
                [arraySub addObject:dictSubb];
                
                total = 0;
                totalvat = 0;
                tpricewithoutvat = 0;
                
                str_IDs = @"";
                totalSum = 0;
                totalSumCash = 0;
                totalSumCard = 0;
                totalSumSwish = 0;
                totalSumOther = 0;
                sum = 0;
                dictSubbM = [NSMutableDictionary new];
                totaldate=tDate;
                currentDate=tDate;
                totaldatetime = tdatetime;
                if ([_str_paymentMethod isEqualToString:@"2"]) {
                    cardPayment =1;
                }
                else if ([_str_paymentMethod isEqualToString:@"1"])
                {
                    countPayment=1;
                }
                else if ([_str_paymentMethod isEqualToString:@"3"])
                {
                    swishPayment=1;
                }
                else if([_str_paymentMethod isEqualToString:@"4"])
                {
                    otherPayment=1;
                }
                
                curDay = day;
                curDayE = dayE;
                
            }
            else
            {
                if(curId!=[[person valueForKey:@"id"] intValue])
                {
                    if ([_str_paymentMethod isEqualToString:@"2"]) {
                        cardPayment++;
                    }
                    else if ([_str_paymentMethod isEqualToString:@"1"])
                    {
                        countPayment++;
                    }
                    else if ([_str_paymentMethod isEqualToString:@"3"])
                    {
                        swishPayment++;
                    }
                    else if([_str_paymentMethod isEqualToString:@"4"])
                    {
                        otherPayment++;
                    }
                }
                
                NSArray* ary_ID = [str_IDs componentsSeparatedByString: @","];
                
                
                if ([ary_ID count]>0)
                {
                    if (![ary_ID containsObject:[NSString stringWithFormat:@"%@",[person valueForKey:@"id"]]])
                    {
                        str_IDs = [NSString stringWithFormat:@"%@,%@",str_IDs,[person valueForKey:@"id"]];
                    }
                }
            }
            

            if(curMonth==nil)
                curMonth = newDateString;
            else if (![curMonth isEqualToString:newDateString])
            {
                
                NSMutableDictionary *dictMain = [NSMutableDictionary new];
                [dictMain setObject:curMonth forKey:@"month"];
                [dictMain setObject:arraySub forKey:@"main"];
                [arrayMain addObject:dictMain];
         
                arraySub = [NSMutableArray new];
                curMonth = newDateString;
                currentDate= newDateString;
            }
            
            
            if(curId!=[[person valueForKey:@"id"] intValue])
            {
                //            countPayment++;
                curId=[[person valueForKey:@"id"] intValue];
            }
            
            
            
            NSPredicate *predicate;
            predicate = [NSPredicate predicateWithFormat:@"(id = %@)", [person valueForKey:@"id"]];
            [request11 setPredicate:predicate];
            
            
            NSError *error2;
            objects2 = [context executeFetchRequest:request11 error:&error2];
            
            NSManagedObject *person2;
            
            for(int i=0;i<objects2.count;i++)
            {
                person2 = (NSManagedObject *)[objects2 objectAtIndex:i];
                
                float discount = 0.0;
                
                [dictSub setObject:[person2 valueForKey:@"discount"] forKey:@"customdiscount"];
                
            }
            
            
            
//            total = ([[person valueForKey:@"price"] floatValue] * [[person valueForKey:@"count"] integerValue]);
            
//            total=([[person valueForKey:@"price"] floatValue] *[[person valueForKey:@"count"] integerValue])-[[person valueForKey:@"discount"]floatValue] ;

            
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
            
            zzzz = (([[person valueForKey:@"price"] floatValue]*[[person valueForKey:@"count"] integerValue])-[[person valueForKey:@"discount"]floatValue]) / (1 + [[person valueForKey:@"vat"] floatValue]/100);
            
            
            
            zzzz=(([[person valueForKey:@"price"] floatValue] *[[person valueForKey:@"count"] integerValue])-[[person valueForKey:@"discount"]floatValue])-zzzz;
            
            
            tpricewithoutvat = (([[person valueForKey:@"price"] floatValue]*[[person valueForKey:@"count"] integerValue])-[[person valueForKey:@"discount"]floatValue]) / (1 + [[person valueForKey:@"vat"] floatValue]/100) + tpricewithoutvat;
            
            totalvat = zzzz + totalvat;
            
            
            if ([_str_paymentMethod isEqualToString:@"2"]) {
                
                totalSumCard=totalSumCard + total;
                
            }
            else if ([_str_paymentMethod isEqualToString:@"1"])
            {
                totalSumCash=totalSumCash + total;
            }
            else if ([_str_paymentMethod isEqualToString:@"3"])
            {
                totalSumSwish=totalSumSwish + total;
            }
            else if ([_str_paymentMethod isEqualToString:@"4"])
            {
                totalSumOther=totalSumOther + total;
            }
            
            
            
            totalSum = totalSum + total;
            
            if([dictSubbM objectForKey:[dictSub valueForKey:@"name"]])
            {
                
                NSMutableDictionary *dictTemp = [dictSubbM  objectForKey:[dictSub valueForKey:@"name"]];
                int countTemp = [[dictTemp valueForKey:@"count"] intValue] + [[dictSub valueForKey:@"count"] intValue];
                [dictTemp setObject:[NSString stringWithFormat:@"%d",countTemp] forKey:@"count"];
                [dictSubbM setObject:dictTemp forKey:[dictSub valueForKey:@"name"]];
                
            }
            else
            {
                [dictSubbM setObject:dictSub forKey:[dictSub valueForKey:@"name"]];
            }
            

        }
        else
        {
      
        }
    }

    
    int pro_product;
    pro_product=0;
    
    for (int i =0; i<[arrayProCount count]; i++) {
        
        pro_product=pro_product+[[NSString stringWithFormat:@"%@",[[arrayProCount objectAtIndex:i] valueForKey:@"count"]] intValue];
        
    }
    
    ztotalProduct=[NSString stringWithFormat:@"%lu",(unsigned long)pro_product];

    
    if (objects.count != 0)
    {
        
        if(totaldate) {
            
            int refundCount = 0 ;
            float totalammount = 0;
            
            NSManagedObjectContext *context =
            [appDelegate managedObjectContext];
            
            NSEntityDescription *entityDesc =
            [NSEntityDescription entityForName:@"RefundAmount"
                        inManagedObjectContext:context];
            
            NSFetchRequest *request = [[NSFetchRequest alloc] init];
            [request setEntity:entityDesc];
            
            NSPredicate *pred =
            [NSPredicate predicateWithFormat:@"(date = %@)",totaldate];
            [request setPredicate:pred];
            //    NSManagedObject *matches = nil;
            
            
            NSError *error;
            NSArray *objects = [context executeFetchRequest:request
                                                      error:&error];
            
            for (NSManagedObject *personRefund in objects)
            {
                
                if ([[personRefund valueForKey:@"zdayStatus"] intValue]==0) {
                    refundCount ++;
                    
                    totalammount =  [[personRefund valueForKey:@"totalAmount"] floatValue];
                }
            }
            
            
            
            if ([str_IDs hasPrefix:@","])
            {
                str_IDs = [str_IDs substringFromIndex:1];
            }
            float discount = [self GetDiscountList:str_IDs];

            
            
            float totalPrice = 0.0;
            float vat = 0.0;
            float vatPercent = (totalvat*100)/tpricewithoutvat;
            
            if ([str_DiscountType isEqualToString:@"$"])
            {
                
                totalPrice = totalSum - discount;
            }
            else
            {
                totalPrice = totalSum - ((totalSum*discount)/100);
                
            }
            vat = totalPrice-(totalPrice/(1+vatPercent/100));
   
            
            NSMutableDictionary *dictSubb = [NSMutableDictionary new];
            [dictSubb setObject:curDay forKey:@"day"];
            [dictSubb setObject:dictSubbM forKey:@"sub"];
            [dictSubb setObject:curDayE forKey:@"dayE"];
            [dictSubb setObject:[NSString stringWithFormat:@"%f",totalSum] forKey:@"totalSum"];
            [dictSubb setObject:[NSString stringWithFormat:@"%f",totalSumCard] forKey:@"totalSumCard"];
            [dictSubb setObject:[NSString stringWithFormat:@"%f",totalSumCash] forKey:@"totalSumCash"];
            [dictSubb setObject:[NSString stringWithFormat:@"%f",totalSumSwish] forKey:@"totalSumSwish"];
            [dictSubb setObject:[NSString stringWithFormat:@"%f",totalSumOther] forKey:@"totalSumOther"];
            [dictSubb setObject:[NSString stringWithFormat:@"%d",countPayment] forKey:@"countPayment"];
            [dictSubb setObject:[NSString stringWithFormat:@"%d",cardPayment] forKey:@"cardPayment"];
            [dictSubb setObject:[NSString stringWithFormat:@"%d",swishPayment] forKey:@"swishPayment"];
            [dictSubb setObject:[NSString stringWithFormat:@"%d",otherPayment] forKey:@"otherPayment"];
            [dictSubb setObject:[NSString stringWithFormat:@"%f",vat] forKey:@"totalvat"];
            [dictSubb setObject:totaldatetime forKey:@"totaldatetime"];
            [dictSubb setObject:str_IDs forKey:@"finalid"];
            [dictSubb setObject:totaldate forKey:@"totaldate"];
            [dictSubb setObject:[NSString stringWithFormat:@"%0.02f",discount] forKey:@"totaldiscount"];
            [dictSubb setObject:[NSString stringWithFormat:@"%d",refundCount] forKey:@"refundCount"];
            [dictSubb setObject:[NSString stringWithFormat:@"%.2f",totalammount] forKey:@"refundTotal"];
            [arraySub addObject:dictSubb];
         
            
            NSMutableDictionary *dictMain = [NSMutableDictionary new];
            [dictMain setObject:curMonth forKey:@"month"];
            [dictMain setObject:arraySub forKey:@"main"];
            [arrayMain addObject:dictMain];
            
            
            if ([_str_paymentMethod isEqualToString:@"2"]) {
                cardPayment =1;
            }
            else if ([_str_paymentMethod isEqualToString:@"1"])
            {
                countPayment=1;
            }
            else if ([_str_paymentMethod isEqualToString:@"3"])
            {
                swishPayment=1;
            }
            else if([_str_paymentMethod isEqualToString:@"4"])
            {
                otherPayment=1;
            }
            
            str_IDs = @"";
            dictAllZDayItems = arrayMain;
            selectedSection=0;
            sum = 0;
            selectedRow=0;
     
        }
    }
    else
    {
        NSMutableDictionary *dict1 = [[NSMutableDictionary alloc]initWithDictionary:[ary_DetailList objectAtIndex:0]];
        [dict1 setObject:[NSString stringWithFormat:@"0 %@ ",[Language get:@"Card payments" alter:@"!Card payments"]] forKey:@"title"];
        [dict1 setObject:[NSString stringWithFormat:@"%@ 0.00", currencySign] forKey:@"value"];
        [ary_DetailList replaceObjectAtIndex:0 withObject:dict1];
        
        NSMutableDictionary *dict2 = [[NSMutableDictionary alloc]initWithDictionary:[ary_DetailList objectAtIndex:1]];
        [dict2 setObject:[NSString stringWithFormat:@"0 %@ ",[Language get:@"Cash payments" alter:@"!Cash payments"]] forKey:@"title"];
        [dict2 setObject:[NSString stringWithFormat:@"%@ 0.00", currencySign] forKey:@"value"];
        [ary_DetailList replaceObjectAtIndex:1 withObject:dict2];
        
        NSMutableDictionary *dict3 = [[NSMutableDictionary alloc]initWithDictionary:[ary_DetailList objectAtIndex:2]];
        [dict3 setObject:[NSString stringWithFormat:@"0 %@ ",[Language get:@"Swish payments" alter:@"!Swish payments"]] forKey:@"title"];
        [dict3 setObject:[NSString stringWithFormat:@"%@ 0.00", currencySign] forKey:@"value"];
        [ary_DetailList replaceObjectAtIndex:2 withObject:dict3];
        
        NSMutableDictionary *dict4 = [[NSMutableDictionary alloc]initWithDictionary:[ary_DetailList objectAtIndex:3]];
        [dict4 setObject:[NSString stringWithFormat:@"0 %@ ",[Language get:@"Other payments" alter:@"!Other payments"]] forKey:@"title"];
        [dict4 setObject:[NSString stringWithFormat:@"%@ 0.00", currencySign] forKey:@"value"];
        [ary_DetailList replaceObjectAtIndex:3 withObject:dict4];
        
        NSMutableDictionary *dict6 = [[NSMutableDictionary alloc]initWithDictionary:[ary_DetailList objectAtIndex:5]];
        [dict6 setObject:[NSString stringWithFormat:@"%@ 0.00", currencySign] forKey:@"value"];
        [ary_DetailList replaceObjectAtIndex:5 withObject:dict6];
        
        NSMutableDictionary *dict7 = [[NSMutableDictionary alloc]initWithDictionary:[ary_DetailList objectAtIndex:6]];
        [dict7 setObject:[NSString stringWithFormat:@"%@ 0.00", currencySign] forKey:@"value"];
        [ary_DetailList replaceObjectAtIndex:6 withObject:dict7];
        
        NSMutableDictionary *dict13 = [[NSMutableDictionary alloc]initWithDictionary:[ary_DetailList objectAtIndex:12]];
        [dict13 setObject:[NSString stringWithFormat:@"%@ 0.00", currencySign] forKey:@"value"];
        [ary_DetailList replaceObjectAtIndex:12 withObject:dict13];
        
        [collectionView_ReportDetail reloadData];
        
 //       labelCardPaymentValue.text = [NSString stringWithFormat:@"%@ 0.00", currencySign];
 //       labelFeeValue.text = [NSString stringWithFormat:@"%@ 0.00", currencySign];
 //       labelCashPaymentValue.text = [NSString stringWithFormat:@"%@ 0.00", currencySign];
        
 //       labelRefundTotal.text = [NSString stringWithFormat:@"%@ 0.00", currencySign];
        labelTotal.text = [NSString stringWithFormat:@"%@ 0.00", currencySign];
        
 //       labelDiscount.text = [NSString stringWithFormat:@"%@ 0.00", currencySign];
        
    }
    
    
}


-(void)zDaySet
{

    NSMutableArray * arrayItems1 = [NSMutableArray new];
    
    arrayItems1=[[[dictAllZDayItems objectAtIndex:selectedSection] objectForKey:@"main"] objectAtIndex:selectedRow];
    
    
    NSMutableDictionary *dictAllItem = [[[[dictAllZDayItems objectAtIndex:selectedSection] objectForKey:@"main"] objectAtIndex:selectedRow] valueForKey:@"sub"];
    
    NSMutableArray * arrayItems = [NSMutableArray new];
    
    
    for (NSString *key in dictAllItem)
    {
        [arrayItems addObject:[dictAllItem objectForKey:key]];
    }
    
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"newprice" ascending:YES];
    [arrayItems sortUsingDescriptors:[NSArray arrayWithObject:sort]];
    
    
    NSInteger sum = 0;
    
    for (NSDictionary *dict in arrayItems)
    {
        sum += [[dict valueForKey:@"price"] intValue] * [[dict valueForKey:@"count"] intValue];
    }
    
    
    labelHeaderDate.text =[NSString stringWithFormat:@"%@",[Language get:@"Z-REPORT" alter:@"!Z-REPORT"]];
    
    
    ztotalPayment=[[[[dictAllZDayItems objectAtIndex:selectedSection] objectForKey:@"main"] objectAtIndex:selectedRow] valueForKey:@"countPayment"];
    
//    zcardPayment=[[[[dictAllZDayItems objectAtIndex:selectedSection] objectForKey:@"main"] objectAtIndex:selectedRow] valueForKey:@"cardPayment"];
    float sumnewCard=0.00;
    float sumnewCash=0.00;
    
    
//    if ([_str_paymentMethod isEqualToString:@"2"]) {
    
        if ([[[[[dictAllZDayItems objectAtIndex:selectedSection] objectForKey:@"main"] objectAtIndex:selectedRow] valueForKey:@"totaldiscountCard"] floatValue]==0.00) {
            sumnewCard = [[[[[dictAllZDayItems objectAtIndex:selectedSection] objectForKey:@"main"] objectAtIndex:selectedRow] valueForKey:@"totaldiscountCard"] floatValue];
        }
        else
        {
            sumnewCard = 0.00;
        }
//    }
//    else
//    {
        if ([[[[[dictAllZDayItems objectAtIndex:selectedSection] objectForKey:@"main"] objectAtIndex:selectedRow] valueForKey:@"totaldiscountCash"] floatValue] != 0.00) {
            sumnewCash = [[[[[dictAllZDayItems objectAtIndex:selectedSection] objectForKey:@"main"] objectAtIndex:selectedRow] valueForKey:@"totaldiscountCash"] floatValue];
        }
        else
        {
            sumnewCash = 0.00;
        }
//    }
    
    float sumnew = [[[[[dictAllZDayItems objectAtIndex:selectedSection] objectForKey:@"main"] objectAtIndex:selectedRow] valueForKey:@"totaldiscount"] floatValue];
    
    zdiscunts=[NSString stringWithFormat:@"%.02f", sumnew];
    
//    zcashPayment=[NSString stringWithFormat:@"%.02f",[[[[[dictAllZDayItems objectAtIndex:selectedSection] objectForKey:@"main"] objectAtIndex:selectedRow] valueForKey:@"totalSumCash"] floatValue]-sumnewCash];
//    
//    zcardPayment=[NSString stringWithFormat:@"%.02f",[[[[[dictAllZDayItems objectAtIndex:selectedSection] objectForKey:@"main"] objectAtIndex:selectedRow] valueForKey:@"totalSumCard"] floatValue]-sumnewCard];
    
    zrefundcount=[NSString stringWithFormat:@"%@",[[[[dictAllZDayItems objectAtIndex:selectedSection] objectForKey:@"main"] objectAtIndex:selectedRow] valueForKey:@"refundCount"]];
    
    
    NSString *str = [[[[dictAllZDayItems objectAtIndex:selectedSection] objectForKey:@"main"] objectAtIndex:selectedRow] valueForKey:@"refundTotal"];
    
    str = [str stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    zrefund=str;
    
    
}

-(void)zDaySetRefund
{
    
    labelHeaderDate.text =[NSString stringWithFormat:@"%@",[Language get:@"Z-REPORT" alter:@"!Z-REPORT"]];
    ztotalPayment=@"0";
    zdiscunts=@"0.0";
    ztotalPayments=@"0";
    ztotalCashPayments=@"0";
    ztotalCardPayments=@"0";
    ztotalSwishPayments=@"0";
    ztotalOtherPayments=@"0";
    zcashPayment=@"0.0";
    zcardPayment=@"0.0";
    zswishPayment=@"0.0";
    zotherPayment=@"0.0";
    zvat=@"0.0";
    ztotalProduct=@"0";
    
}


-(void)ZDayRefund
{
    
    NSManagedObjectContext *context =
    [appDelegate managedObjectContext];
    
    NSEntityDescription *entityDesc =
    [NSEntityDescription entityForName:@"RefundAmount"
                inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
    //    NSPredicate *pred =
    //    [NSPredicate predicateWithFormat:@"(date = %@)",currentDate];
    //    [request setPredicate:pred];
    //    NSManagedObject *matches = nil;
    
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request
                                              error:&error];
    
    
    
    NSMutableDictionary  *dictSubR;
    
    NSMutableArray *arr_sub=[NSMutableArray new];
    
    NSMutableArray *arrayZdayRefundCount=[NSMutableArray new];
    NSMutableArray *arrayRefundCount=[NSMutableArray new];
    NSManagedObject *personRefund;
    
    NSString *str_id;
    NSString *str_price;
    NSString *str_code;
    NSString *str_vat;
    
    
    int index = -1;
    
    int refundZday;
    
    refundZday=0;
    
    for (personRefund in objects)
    {
        if ([[personRefund valueForKey:@"zdayStatus"] intValue]==0) {
            
            if (![[arrayZdayRefundCount valueForKey:@"id"]containsObject:[personRefund valueForKey:@"id"]])
            {
                NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
                
                [dic setObject:[personRefund valueForKey:@"id"] forKey:@"id"];
                
                [arrayZdayRefundCount addObject:dic];
            }
            
            
            index = [[personRefund valueForKey:@"rid"]intValue];
            
            dictSubR = [NSMutableDictionary new];
            
            //Anu: 21June2016
            str_id=[personRefund valueForKey:@"id"];
            str_code=[personRefund valueForKey:@"code"];
            
            if ([personRefund valueForKey:@"totalAmount"]==nil)
                str_price=@"0";
            else
            str_price=[personRefund valueForKey:@"totalAmount"];
            
            if ([personRefund valueForKey:@"vat"]==nil)
                str_vat=@"0";
            else
            str_vat=[personRefund valueForKey:@"vat"];
            
            
            [dictSubR setObject:str_price forKey:@"totalAmount"];
            
            if ([personRefund valueForKey:@"price"]==nil)
            [dictSubR setObject:@"0" forKey:@"price"];
            else
                [dictSubR setObject:[personRefund valueForKey:@"price"] forKey:@"price"];
            
            [dictSubR setObject:[personRefund valueForKey:@"refundDate"] forKey:@"refundDate"];
            [dictSubR setObject:str_vat forKey:@"vat"];
            [dictSubR setObject:[personRefund valueForKey:@"id"] forKey:@"id"];
            [dictSubR setObject:[personRefund valueForKey:@"code"] forKey:@"code"];
            [dictSubR setObject:[personRefund valueForKey:@"rid"] forKey:@"rid"];
            
            if ([personRefund valueForKey:@"type"] == nil)
                [dictSubR setObject:@"$" forKey:@"type"];
            else
                [dictSubR setObject:[personRefund valueForKey:@"type"] forKey:@"type"];
            
            [dictSubR setObject:[personRefund valueForKey:@"currency"] forKey:@"currency"];
            [dictSubR setObject:[personRefund valueForKey:@"count"] forKey:@"count"];
            [dictSubR setObject:[CommonMethods validateDictionaryValueForKey:[personRefund valueForKey:@"discription"]]?[personRefund valueForKey:@"discription"]:@"" forKey:@"discription"];
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
            
            
            if ([personRefund valueForKey:@"discount"] == nil)
                [dictSubR setObject:@"0" forKey:@"peritemprice"];
            else
                [dictSubR setObject:[personRefund valueForKey:@"peritemprice"] forKey:@"peritemprice"];

            [arr_sub addObject:dictSubR];
    
        }
        
    }
    
   
    refundZday=[arrayZdayRefundCount count];
    
    [appDelegate refundCountUpdate:refundZday :2];
    
    
    
    refundZArray=[[NSMutableArray alloc]init];
    
    refundZArray=arr_sub;

    
    NSMutableArray *arr_subFinal=[NSMutableArray new];
    NSMutableArray *arr_subFinalDiferentId=[NSMutableArray new];
    
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
            
            NSString *stringDateTime;
            
            stringDateTime = [NSString stringWithFormat:@"%@",[[arr_sub valueForKey:@"date"] objectAtIndex:i]];
            
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:@"dd MMMM yyyy"];
            
            NSDate *date_get=[dateFormatter dateFromString:stringDateTime];
            NSDate *TranDate = date_get;
            
            
            [dateFormatter setDateFormat:@"MM"];
            
            NSString *str_monthT = [dateFormatter stringFromDate:TranDate];
            NSString *str_monthC = [dateFormatter stringFromDate:selectedDate];
            
            [dateFormatter setDateFormat:@"dd"];
            
            NSString *str_dayT = [dateFormatter stringFromDate:TranDate];
            NSString *str_dayC = [dateFormatter stringFromDate:selectedDate];
            
            [dateFormatter setDateFormat:@"yyyy"];
            
            NSString *str_yearT = [dateFormatter stringFromDate:TranDate];
            NSString *str_yearC = [dateFormatter stringFromDate:selectedDate];
            
            int yearT,yearC,monthT,monthC,dayT,dayC;
            
            
            yearT=[str_yearT intValue];
            yearC=[str_yearC intValue];
            
            monthT=[str_monthT intValue];
            monthC=[str_monthC intValue];
            
            dayT=[str_dayT intValue];
            dayC=[str_dayC intValue];
            
            
            if (str_prev!=str_next) {
                
                arr_subFinal=[NSMutableArray new];
                [arr_subFinal addObject:[arr_sub objectAtIndex:i]];
                
                
                
                if (yearC==yearT) {
                    
                    if (monthC==monthT) {
                        
                        if (dayC>=dayT) {
                            
                            [arr_subFinalDiferentId addObject:[arr_sub objectAtIndex:i]];
                            
                            
                        }
                        
                    }
                    else  if (monthC>monthT) {
                        
                        [arr_subFinalDiferentId addObject:[arr_sub objectAtIndex:i]];
                    }
                    
                }
                else if (yearC>yearT)
                {
                    [arr_subFinalDiferentId addObject:[arr_sub objectAtIndex:i]];
                }
                
            }
            else
            {
                [arr_subFinal addObject:[arr_sub objectAtIndex:i]];
                
                if (i==0) {
                    
                    if (yearC==yearT) {
                        
                        if (monthC==monthT) {
                            
                            if (dayC>=dayT) {
                                
                                [arr_subFinalDiferentId addObject:[arr_sub objectAtIndex:i]];
                                
                                
                            }
                            
                        }
                        else  if (monthC>monthT) {
                            
                            [arr_subFinalDiferentId addObject:[arr_sub objectAtIndex:i]];
                        }
                        
                    }
                    else if (yearC>yearT)
                    {
                        [arr_subFinalDiferentId addObject:[arr_sub objectAtIndex:i]];
                    }
                }
            }
            
            
        }
        else
        {
            
            arr_subFinal=arr_sub;
            arr_subFinalDiferentId=arr_sub;
        }
        
        
    }
    
    
//    labelRefund.text = [NSString stringWithFormat:@"%@ %@",[NSString stringWithFormat:@"%lu",(unsigned long)arr_subFinalDiferentId.count],
//                        
//                        labelRefund.text = [Language get:@"Refund" alter:@"!Refund"]];
    
    zrefundcount=[NSString stringWithFormat:@"%lu",(unsigned long)arr_subFinalDiferentId.count];
    
    
    float refundAmountTotal=0.0;
    
    for (int i=0; i<[arr_subFinalDiferentId count]; i++) {
        
        
        NSString *refund;
        
        refund= [NSString stringWithFormat:@"%@",[[arr_subFinalDiferentId objectAtIndex:i] valueForKey:@"totalAmount"]];
        
        refund=[refund stringByReplacingOccurrencesOfString:@"-" withString:@""];
        
        float refundAmount=0.0;
        
        refundAmount=[refund floatValue];
        
        refundAmountTotal=refundAmountTotal+refundAmount;
        
    }

    
  //  labelRefundTotal.text = [NSString stringWithFormat:@"-%@ %0.2f", currencySign, refundAmountTotal];
    
    
    NSMutableDictionary *dict6 = [[NSMutableDictionary alloc]initWithDictionary:[ary_DetailList objectAtIndex:5]];
    [dict6 setObject:[NSString stringWithFormat:@"%@ %@",[NSString stringWithFormat:@"%lu",(unsigned long)arr_subFinalDiferentId.count],[Language get:@"Refund" alter:@"!Refund"]] forKey:@"title"];
    [dict6 setObject:[NSString stringWithFormat:@"-%@ %0.2f", currencySign, refundAmountTotal] forKey:@"value"];
    [ary_DetailList replaceObjectAtIndex:5 withObject:dict6];
    
    [collectionView_ReportDetail reloadData];
    
    zrefund=[NSString stringWithFormat:@"%0.2f", refundAmountTotal];
    
    
#pragma mark Grand total for refund ZDayReoprt
    
    
    //// Grand total for refundd
    
    
    arr_sub=[[NSMutableArray alloc] init];
    
    
    entityDesc =
    [NSEntityDescription entityForName:@"RefundAmount"
                inManagedObjectContext:context];
    
    request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
    objects = [context executeFetchRequest:request
                                     error:&error];
    
    int refundCount;
    refundCount=0;
    
    for (personRefund in objects)
    {
        
        if (![[arrayRefundCount valueForKey:@"id"]containsObject:[personRefund valueForKey:@"id"]])
        {
            NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
            
            [dic setObject:[personRefund valueForKey:@"id"] forKey:@"id"];
            
            [arrayRefundCount addObject:dic];
        }
        
            index = [[personRefund valueForKey:@"rid"]intValue];
            
            dictSubR = [NSMutableDictionary new];
            
            
            str_id=[personRefund valueForKey:@"id"];
            str_code=[personRefund valueForKey:@"code"];
        
        if ([personRefund valueForKey:@"totalAmount"] == nil)
            str_price=@"0";
        else
            str_price=[personRefund valueForKey:@"totalAmount"];
       
        if ([personRefund valueForKey:@"vat"] == nil)
            str_vat=@"0";
        else
            str_vat=[personRefund valueForKey:@"vat"];
            
            [dictSubR setObject:str_price forKey:@"totalAmount"];
        
        if ([personRefund valueForKey:@"price"] == nil)
            [dictSubR setObject:@"0" forKey:@"price"];
        else
            [dictSubR setObject:[personRefund valueForKey:@"price"] forKey:@"price"];
        
            [dictSubR setObject:[personRefund valueForKey:@"refundDate"] forKey:@"refundDate"];
            [dictSubR setObject:str_vat forKey:@"vat"];
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
            [dictSubR setObject:[CommonMethods validateDictionaryValueForKey:[personRefund valueForKey:@"discription"]]?[personRefund valueForKey:@"discription"]:@"" forKey:@"discription"];
           // [dictSubR setObject:[personRefund valueForKey:@"discription"] forKey:@"discription"];
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
            [dictSubR setObject:@"0" forKey:@"peritemdiscount"];
        else
            [dictSubR setObject:[personRefund valueForKey:@"peritemprice"] forKey:@"peritemprice"];
        
            [arr_sub addObject:dictSubR];
        
    }

    refundCount=[arrayRefundCount count];
    
    [appDelegate refundCountUpdate:refundCount :1];
    
    
    arr_subFinal=[[NSMutableArray alloc] init];
    arr_subFinalDiferentId=[[NSMutableArray alloc] init];
    
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
            
            NSString *stringDateTime;
            
            stringDateTime = [NSString stringWithFormat:@"%@",[[arr_sub valueForKey:@"date"] objectAtIndex:i]];
            
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:@"dd MMMM yyyy"];
            
            NSDate *date_get=[dateFormatter dateFromString:stringDateTime];
            NSDate *TranDate = date_get;
            
            
            [dateFormatter setDateFormat:@"MM"];
            
            NSString *str_monthT = [dateFormatter stringFromDate:TranDate];
            NSString *str_monthC = [dateFormatter stringFromDate:selectedDate];
            
            [dateFormatter setDateFormat:@"dd"];
            
            NSString *str_dayT = [dateFormatter stringFromDate:TranDate];
            NSString *str_dayC = [dateFormatter stringFromDate:selectedDate];
            
            [dateFormatter setDateFormat:@"yyyy"];
            
            NSString *str_yearT = [dateFormatter stringFromDate:TranDate];
            NSString *str_yearC = [dateFormatter stringFromDate:selectedDate];
            
            int yearT,yearC,monthT,monthC,dayT,dayC;
            
            
            yearT=[str_yearT intValue];
            yearC=[str_yearC intValue];
            
            monthT=[str_monthT intValue];
            monthC=[str_monthC intValue];
            
            dayT=[str_dayT intValue];
            dayC=[str_dayC intValue];
            
            
            if (str_prev!=str_next) {
                
                arr_subFinal=[NSMutableArray new];
                [arr_subFinal addObject:[arr_sub objectAtIndex:i]];
                
                if (yearC==yearT) {
                    
                    if (monthC==monthT) {
                        
                        if (dayC>=dayT) {
                            
                            [arr_subFinalDiferentId addObject:[arr_sub objectAtIndex:i]];
                            
                            
                        }
                        
                    }
                    else if (monthC>monthT) {
                        
                        [arr_subFinalDiferentId addObject:[arr_sub objectAtIndex:i]];
                        
                        
                    }
                    
                }
                else if (yearC>yearT) {
                    
                    [arr_subFinalDiferentId addObject:[arr_sub objectAtIndex:i]];
                    
                    
                }
            }
            else
            {
                [arr_subFinal addObject:[arr_sub objectAtIndex:i]];
                
                if (i==0) {
                    
                    if (yearC==yearT) {
                        
                        if (monthC==monthT) {
                            
                            if (dayC>=dayT) {
                                
                                [arr_subFinalDiferentId addObject:[arr_sub objectAtIndex:i]];
                                
                                
                            }
                            
                        }
                        else if (monthC>monthT) {
                            
                            [arr_subFinalDiferentId addObject:[arr_sub objectAtIndex:i]];
                            
                            
                        }
                            
                        
                    }
                    if (yearC>yearT) {
                        
                        [arr_subFinalDiferentId addObject:[arr_sub objectAtIndex:i]];
                        
                        
                    }
                    
                }
            }
            
            
        }
        else
        {
            
            arr_subFinal=arr_sub;
            arr_subFinalDiferentId=arr_sub;
        }
        
        
    }
    

    refundAmountTotal=0.0;
    grandTotalRefund=0.0;
    
    for (int i=0; i<[arr_subFinalDiferentId count]; i++) {
        
        
        NSString *refund;
        
        refund= [NSString stringWithFormat:@"%@",[[arr_subFinalDiferentId objectAtIndex:i] valueForKey:@"totalAmount"]];
        
        refund=[refund stringByReplacingOccurrencesOfString:@"-" withString:@""];
        
        float refundAmount=0.0;
        
        refundAmount=[refund floatValue];
        
        grandTotalRefund=grandTotalRefund+refundAmount;
        
    }
    
    NSMutableDictionary *dict10 = [[NSMutableDictionary alloc]initWithDictionary:[ary_DetailList objectAtIndex:9]];
    [dict10 setObject:[NSString stringWithFormat:@"-%@ %0.2f", currencySign, grandTotalRefund] forKey:@"value"];
    [ary_DetailList replaceObjectAtIndex:9 withObject:dict10];
    
    [collectionView_ReportDetail reloadData];
  //  self.grandSaleRefundValue.text = [NSString stringWithFormat:@"-%@ %0.2f",currencySign,grandTotalRefund];
    
    zgrandTotalRefund=[NSString stringWithFormat:@"%0.2f", grandTotalRefund];
    
    zgrandtotalSale_Refund=[NSString stringWithFormat:@"%0.2f", grandTotalRefund];
}

-(void)ZdayPayment
{
    
    NSMutableArray *arrayTotalSum;
    NSMutableArray *arrayTotalSumCash;
    NSMutableArray *arrayTotalSumCard;
    NSMutableArray *arrayTotalSumSwish;
    NSMutableArray *arrayTotalSumOther;
    NSMutableArray *arrayTotalRefund;
    NSMutableArray *arrayTotalSale_Refund;
    NSMutableArray *arrayTotalDiscunt;
    NSMutableArray *arrayTotalSumView;
    NSMutableArray *arrayTotalCount;
    
    NSMutableArray *arrayPaymentCount;
    NSMutableArray *arrayCardPaymentCount;
    NSMutableArray *arrayRefundCount;
    
    arrayTotalSum=[NSMutableArray new];
    arrayTotalSumCash=[NSMutableArray new];
    arrayTotalSumCard=[NSMutableArray new];
    arrayTotalSumSwish=[NSMutableArray new];
    arrayTotalSumOther=[NSMutableArray new];
    arrayTotalRefund=[NSMutableArray new];
    arrayTotalSale_Refund=[NSMutableArray new];
    arrayTotalDiscunt=[NSMutableArray new];
    arrayTotalCount=[NSMutableArray new];
    arrayTotalSumView=[NSMutableArray new];
    arrayPaymentCount=[NSMutableArray new];
    arrayRefundCount=[NSMutableArray new];
    arrayCardPaymentCount=[NSMutableArray new];

    
     for (int j=0 ; j<[[dictAllZDayItems valueForKey:@"main"] count];j++) {
    
    
    for (int i= 0; i < [[[dictAllZDayItems valueForKey:@"main"] objectAtIndex:j] count] ; i++) {
        
        
        NSString *stringDateTime;
        
        stringDateTime = [NSString stringWithFormat:@"%@",[[[[dictAllZDayItems valueForKey:@"main"] objectAtIndex:j] valueForKey:@"totaldatetime"] objectAtIndex:i]];
        
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"dd-MMMM-yyyy, hh:mm a"];
        
        NSDate *date_get=[dateFormatter dateFromString:stringDateTime];
        NSDate *TranDate = date_get;
        
        
        [dateFormatter setDateFormat:@"MM"];
        
        NSString *str_monthT = [dateFormatter stringFromDate:TranDate];
        NSString *str_monthC = [dateFormatter stringFromDate:selectedDate];
        
        [dateFormatter setDateFormat:@"dd"];
        
        NSString *str_dayT = [dateFormatter stringFromDate:TranDate];
        NSString *str_dayC = [dateFormatter stringFromDate:selectedDate];
        
        [dateFormatter setDateFormat:@"yyyy"];
        
        NSString *str_yearT = [dateFormatter stringFromDate:TranDate];
        NSString *str_yearC = [dateFormatter stringFromDate:selectedDate];
        
        int yearT,yearC,monthT,monthC,dayT,dayC;
        
        
        yearT=[str_yearT intValue];
        yearC=[str_yearC intValue];
        
        monthT=[str_monthT intValue];
        monthC=[str_monthC intValue];
        
        dayT=[str_dayT intValue];
        dayC=[str_dayC intValue];
   
        
        if (yearC==yearT) {
            
            if (monthC==monthT) {
                
                if (dayC>=dayT) {
                    
                    [arrayTotalSum addObject:[[[[dictAllZDayItems valueForKey:@"main"] objectAtIndex:j] valueForKey:@"totalSum"] objectAtIndex:i]];
                    [arrayTotalSumCard addObject:[[[[dictAllZDayItems valueForKey:@"main"] objectAtIndex:j] valueForKey:@"totalSumCard"] objectAtIndex:i]];
                    [arrayTotalSumCash addObject:[[[[dictAllZDayItems valueForKey:@"main"] objectAtIndex:j] valueForKey:@"totalSumCash"] objectAtIndex:i]];
                    [arrayTotalSumCard addObject:[[[[dictAllZDayItems valueForKey:@"main"] objectAtIndex:j] valueForKey:@"totalSumSwish"] objectAtIndex:i]];
                    [arrayTotalSumCash addObject:[[[[dictAllZDayItems valueForKey:@"main"] objectAtIndex:j] valueForKey:@"totalSumOther"] objectAtIndex:i]];
                    [arrayTotalDiscunt addObject:[[[[dictAllZDayItems valueForKey:@"main"] objectAtIndex:j] valueForKey:@"totaldiscount"]objectAtIndex:i]];
                    [arrayRefundCount addObject:[[[[dictAllZDayItems valueForKey:@"main"] objectAtIndex:j] valueForKey:@"refundCount"]objectAtIndex:i]];
                    [arrayTotalCount addObject:[[[[dictAllZDayItems valueForKey:@"main"] objectAtIndex:j] valueForKey:@"countPayment"]objectAtIndex:i]];
                    [arrayTotalCount addObject:[[[[dictAllZDayItems valueForKey:@"main"] objectAtIndex:j] valueForKey:@"swishPayment"]objectAtIndex:i]];
                    [arrayTotalCount addObject:[[[[dictAllZDayItems valueForKey:@"main"] objectAtIndex:j] valueForKey:@"otherPayment"]objectAtIndex:i]];
                    [arrayCardPaymentCount addObject:[[[[dictAllZDayItems valueForKey:@"main"] objectAtIndex:j] valueForKey:@"cardPayment"]objectAtIndex:i]];
                    
                }
                
            }
            else if (monthC>monthT)
            {
                
                [arrayTotalSum addObject:[[[[dictAllZDayItems valueForKey:@"main"] objectAtIndex:j] valueForKey:@"totalSum"] objectAtIndex:i]];
                [arrayTotalSumCard addObject:[[[[dictAllZDayItems valueForKey:@"main"] objectAtIndex:j] valueForKey:@"totalSumCard"] objectAtIndex:i]];
                [arrayTotalSumCash addObject:[[[[dictAllZDayItems valueForKey:@"main"] objectAtIndex:j] valueForKey:@"totalSumCash"] objectAtIndex:i]];
                [arrayTotalSumCard addObject:[[[[dictAllZDayItems valueForKey:@"main"] objectAtIndex:j] valueForKey:@"totalSumSwish"] objectAtIndex:i]];
                [arrayTotalSumCash addObject:[[[[dictAllZDayItems valueForKey:@"main"] objectAtIndex:j] valueForKey:@"totalSumOther"] objectAtIndex:i]];
                [arrayTotalDiscunt addObject:[[[[dictAllZDayItems valueForKey:@"main"] objectAtIndex:j] valueForKey:@"totaldiscount"]objectAtIndex:i]];
                [arrayRefundCount addObject:[[[[dictAllZDayItems valueForKey:@"main"] objectAtIndex:j] valueForKey:@"refundCount"]objectAtIndex:i]];
                [arrayPaymentCount addObject:[[[[dictAllZDayItems valueForKey:@"main"] objectAtIndex:j] valueForKey:@"countPayment"]objectAtIndex:i]];
                [arrayTotalCount addObject:[[[[dictAllZDayItems valueForKey:@"main"] objectAtIndex:j] valueForKey:@"swishPayment"]objectAtIndex:i]];
                [arrayTotalCount addObject:[[[[dictAllZDayItems valueForKey:@"main"] objectAtIndex:j] valueForKey:@"otherPayment"]objectAtIndex:i]];
                [arrayCardPaymentCount addObject:[[[[dictAllZDayItems valueForKey:@"main"] objectAtIndex:j] valueForKey:@"cardPayment"]objectAtIndex:i]];
                
            }

        }
        else if (yearC>yearT)
        {
            
            [arrayTotalSum addObject:[[[[dictAllZDayItems valueForKey:@"main"] objectAtIndex:j] valueForKey:@"totalSum"] objectAtIndex:i]];
            [arrayTotalSumCard addObject:[[[[dictAllZDayItems valueForKey:@"main"] objectAtIndex:j] valueForKey:@"totalSumCard"] objectAtIndex:i]];
            [arrayTotalSumCash addObject:[[[[dictAllZDayItems valueForKey:@"main"] objectAtIndex:j] valueForKey:@"totalSumCash"] objectAtIndex:i]];
            [arrayTotalSumCard addObject:[[[[dictAllZDayItems valueForKey:@"main"] objectAtIndex:j] valueForKey:@"totalSumSwish"] objectAtIndex:i]];
            [arrayTotalSumCash addObject:[[[[dictAllZDayItems valueForKey:@"main"] objectAtIndex:j] valueForKey:@"totalSumOther"] objectAtIndex:i]];
            [arrayTotalDiscunt addObject:[[[[dictAllZDayItems valueForKey:@"main"] objectAtIndex:j] valueForKey:@"totaldiscount"]objectAtIndex:i]];
            [arrayRefundCount addObject:[[[[dictAllZDayItems valueForKey:@"main"] objectAtIndex:j] valueForKey:@"refundCount"]objectAtIndex:i]];
            [arrayPaymentCount addObject:[[[[dictAllZDayItems valueForKey:@"main"] objectAtIndex:j] valueForKey:@"countPayment"]objectAtIndex:i]];
            [arrayTotalCount addObject:[[[[dictAllZDayItems valueForKey:@"main"] objectAtIndex:j] valueForKey:@"swishPayment"]objectAtIndex:i]];
            [arrayTotalCount addObject:[[[[dictAllZDayItems valueForKey:@"main"] objectAtIndex:j] valueForKey:@"otherPayment"]objectAtIndex:i]];
            [arrayCardPaymentCount addObject:[[[[dictAllZDayItems valueForKey:@"main"] objectAtIndex:j] valueForKey:@"cardPayment"]objectAtIndex:i]];
            
        }

        }
     }
    
    
    for (int i= 0; i < [arrayTotalSum count] ; i++) {
        
        
        float sum;
        float sumCash;
        float sumcard;
        float dis;
        float sumView;
        
        sum=0.0;
        sumCash=0.0;
        sumcard=0.0;
        dis=0.0;
        sumView=0.0;
        
        
        if ([_str_paymentMethod isEqualToString:@"2"]) {
            
            sumcard=[[NSString stringWithFormat:@"%@",[arrayTotalSumCard objectAtIndex:i]]floatValue];
            dis=[[NSString stringWithFormat:@"%@",[arrayTotalDiscunt objectAtIndex:i]]floatValue];

            sumView=sumcard-dis;
        }
        else
        {
            sumCash=[[NSString stringWithFormat:@"%@",[arrayTotalSumCard objectAtIndex:i]]floatValue];
            dis=[[NSString stringWithFormat:@"%@",[arrayTotalDiscunt objectAtIndex:i]]floatValue];

            sumView=sumCash-dis;
        }
        
        sum=[[NSString stringWithFormat:@"%@",[arrayTotalSum objectAtIndex:i]]floatValue];
        dis=[[NSString stringWithFormat:@"%@",[arrayTotalDiscunt objectAtIndex:i]]floatValue];

        sumView=sum-dis;

        
        [arrayTotalSumView addObject:[NSString stringWithFormat:@"%0.2f",sumView]];
        
        
    }

    float discunt;
    grandTotalDiscunt=0.0;
    
    for (int i= 0; i < [arrayTotalDiscunt count] ; i++) {
        
        
        discunt=0.0;
        
        discunt=[[NSString stringWithFormat:@"%@",[arrayTotalDiscunt objectAtIndex:i]]floatValue];
 
        
        grandTotalDiscunt=grandTotalDiscunt+discunt;
        
        
    }
    
    float refundC;
    totalRefundCount=0.0;
    
    for (int i= 0; i < [arrayRefundCount count] ; i++) {
        
        
        refundC=0.0;
        
        refundC=[[NSString stringWithFormat:@"%@",[arrayRefundCount objectAtIndex:i]]floatValue];
 
        
        totalRefundCount=totalRefundCount+refundC;
        
        
    }
    
    float paymentC;
    totalPaymetCount=0.0;
    totalCashPaymetCount=0.0;
    totalCardPaymetCount=0.0;
    totalSwishPaymetCount=0.0;
    totalOtherPaymetCount=0.0;
    
    
    for (int i= 0; i < [arrayPaymentCount count] ; i++) {
        
        
        paymentC=0.0;
        
        
        if ([_str_paymentMethod isEqualToString:@"2"]) {
            
            paymentC=[[NSString stringWithFormat:@"%@",[arrayCardPaymentCount objectAtIndex:i]]floatValue];

        }
        else
        {
            paymentC=[[NSString stringWithFormat:@"%@",[arrayPaymentCount objectAtIndex:i]]floatValue];

        }
        
        paymentC=[[NSString stringWithFormat:@"%@",[arrayPaymentCount objectAtIndex:i]]floatValue];

        
        totalPaymetCount=totalPaymetCount+paymentC;
        
        
    }
    
    
    float sum;
    grandTotalSale=0.0;
    grandTotalSaleCash=0.0;
    grandTotalSaleCard=0.0;
    grandTotalSaleSwish=0.0;
    grandTotalSaleOther=0.0;
    
    for (int i= 0; i < [arrayTotalSumView count] ; i++) {
        
        sum=0.0;
        
        if ([_str_paymentMethod isEqualToString:@"2"]) {
            
            sum=[[NSString stringWithFormat:@"%@",[arrayTotalSumView objectAtIndex:i]]floatValue];
            grandTotalSaleCard=grandTotalSaleCard+sum;
        }
        else if ([_str_paymentMethod isEqualToString:@"1"])
        {
            sum=[[NSString stringWithFormat:@"%@",[arrayTotalSumView objectAtIndex:i]]floatValue];
            grandTotalSaleCash=grandTotalSaleCash+sum;
        }
        else if ([_str_paymentMethod isEqualToString:@"3"])
        {
            sum=[[NSString stringWithFormat:@"%@",[arrayTotalSumView objectAtIndex:i]]floatValue];
            grandTotalSaleSwish=grandTotalSaleSwish+sum;
        }
        else if ([_str_paymentMethod isEqualToString:@"4"])
        {
            sum=[[NSString stringWithFormat:@"%@",[arrayTotalSumView objectAtIndex:i]]floatValue];
            grandTotalSaleOther=grandTotalSaleOther+sum;
        }
        
        sum=[[NSString stringWithFormat:@"%@",[arrayTotalSumView objectAtIndex:i]]floatValue];
        
        grandTotalSale=grandTotalSale+sum;
        
    }
    
    grandTotalSales_Refund=grandTotalSale-grandTotalRefund;
    
    ztotalPayments=[NSString stringWithFormat:@"%.0f",totalPaymetCount];
    
    zdiscunts=[NSString stringWithFormat:@"%.02f", grandTotalDiscunt];
    
//    zcashPayment=[NSString stringWithFormat:@"%0.2f",grandTotalSaleCash];
//    zcardPayment=[NSString stringWithFormat:@"%0.2f",grandTotalSaleCard];
    
    zrefundcount=[NSString stringWithFormat:@"%.0f",totalRefundCount];
    
}
-(void)ZDayGrandTotal
{
    
    NSMutableArray *arrayTotalSum;
    NSMutableArray *arrayTotalRefund;
    NSMutableArray *arrayTotalSale_Refund;
    NSMutableArray *arrayTotalDiscunt;
    NSMutableArray *arrayTotalSumView;
    
    arrayTotalSum=[NSMutableArray new];
    arrayTotalRefund=[NSMutableArray new];
    arrayTotalSale_Refund=[NSMutableArray new];
    arrayTotalDiscunt=[NSMutableArray new];
    
    arrayTotalSumView=[NSMutableArray new];
    
    for (int j=0 ; j<[[dictAllItems valueForKey:@"main"] count];j++) {
    
    
    for (int i= 0; i < [[[dictAllItems valueForKey:@"main"] objectAtIndex:j] count] ; i++) {
        
        
        NSString *stringDateTime;
        
        stringDateTime = [NSString stringWithFormat:@"%@",[[[[dictAllItems valueForKey:@"main"] objectAtIndex:j] valueForKey:@"totaldatetime"] objectAtIndex:i]];
        
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"dd-MMMM-yyyy, hh:mm a"];
        
        NSDate *date_get=[dateFormatter dateFromString:stringDateTime];
        NSDate *TranDate = date_get;
        
        
        [dateFormatter setDateFormat:@"MM"];
        
        NSString *str_monthT = [dateFormatter stringFromDate:TranDate];
        NSString *str_monthC = [dateFormatter stringFromDate:selectedDate];
        
        [dateFormatter setDateFormat:@"dd"];
        
        NSString *str_dayT = [dateFormatter stringFromDate:TranDate];
        NSString *str_dayC = [dateFormatter stringFromDate:selectedDate];
        
        [dateFormatter setDateFormat:@"yyyy"];
        
        NSString *str_yearT = [dateFormatter stringFromDate:TranDate];
        NSString *str_yearC = [dateFormatter stringFromDate:selectedDate];
        
        int yearT,yearC,monthT,monthC,dayT,dayC;
        
        
        yearT=[str_yearT intValue];
        yearC=[str_yearC intValue];
        
        monthT=[str_monthT intValue];
        monthC=[str_monthC intValue];
        
        dayT=[str_dayT intValue];
        dayC=[str_dayC intValue];
        
        
        if (yearC==yearT) {
            
            if (monthC==monthT) {
                
                if (dayC>=dayT) {
                    
                    [arrayTotalSum addObject:[[[[dictAllItems valueForKey:@"main"] objectAtIndex:j] valueForKey:@"totalSum"] objectAtIndex:i]];
                    [arrayTotalDiscunt addObject:[[[[dictAllItems valueForKey:@"main"] objectAtIndex:j] valueForKey:@"totaldiscount"]objectAtIndex:i]];
                }
                
            }
            else if (monthC>monthT) {
                
                [arrayTotalSum addObject:[[[[dictAllItems valueForKey:@"main"] objectAtIndex:j] valueForKey:@"totalSum"] objectAtIndex:i]];
                [arrayTotalDiscunt addObject:[[[[dictAllItems valueForKey:@"main"] objectAtIndex:j] valueForKey:@"totaldiscount"]objectAtIndex:i]];
            }
            
        }
        else if (yearC>yearT) {
            
            [arrayTotalSum addObject:[[[[dictAllItems valueForKey:@"main"] objectAtIndex:j] valueForKey:@"totalSum"] objectAtIndex:i]];
            [arrayTotalDiscunt addObject:[[[[dictAllItems valueForKey:@"main"] objectAtIndex:j] valueForKey:@"totaldiscount"]objectAtIndex:i]];
        }
        
        
      }
    }
    
    
    
    for (int i= 0; i < [arrayTotalSum count] ; i++) {
        
        
        float sum;
        float dis;
        float sumView;
        
        sum=0.0;
        dis=0.0;
        sumView=0.0;
        
        sum=[[NSString stringWithFormat:@"%@",[arrayTotalSum objectAtIndex:i]]floatValue];
        dis=[[NSString stringWithFormat:@"%@",[arrayTotalDiscunt objectAtIndex:i]]floatValue];

        sumView=sum-dis;
    
        [arrayTotalSumView addObject:[NSString stringWithFormat:@"%0.2f",sumView]];
        
        
    }

    
    float sum;
    grandTotalSale=0.0;
    
    for (int i= 0; i < [arrayTotalSumView count] ; i++) {
        
        
        sum=0.0;
        
        
//        if ([_str_paymentMethod isEqualToString:@"2"]) {
//            sum=[[NSString stringWithFormat:@"%@",[arrayTotalSumView objectAtIndex:i]]floatValue];
//       
//        }
//        else if ([_str_paymentMethod isEqualToString:@"1"])
//        {
//            sum=[[NSString stringWithFormat:@"%@",[arrayTotalSumView objectAtIndex:i]]floatValue];
//    
//        }
        
        sum=[[NSString stringWithFormat:@"%@",[arrayTotalSumView objectAtIndex:i]]floatValue];
    
        grandTotalSale=grandTotalSale+sum;
        
        
    }
    grandTotalSales_Refund=grandTotalSale-grandTotalRefund;
    
    zgrandTotalSale=[NSString stringWithFormat:@"%0.2f", grandTotalSale];
    zgrandTotalRefund=[NSString stringWithFormat:@"%0.2f", grandTotalRefund];
    zgrandtotalSale_Refund=[NSString stringWithFormat:@"%0.2f", grandTotalSales_Refund];
    
    [self ZDayVatCalculation];
    
}

-(void)ZDayVatCalculation
{
    
    [self getVatarray];
    
    
    NSMutableArray *arraySub = [NSMutableArray new];
    NSMutableDictionary *dictSubbM = [NSMutableDictionary new];
    NSMutableArray *arrayMain = [NSMutableArray new];
    
    NSString *curMonth = nil;
    NSString *curDay = nil;
    NSString *curDayE=nil;
    NSString *str_IDs=@"";
    
    
    NSString *totaldatetime = nil;
    NSString *totaldate=nil;
    
    
    int countPayment = 0;
    int swishPayment = 0;
    int otherPayment = 0;
    int cardPayment = 0;
    
    int curId=-1;
    
    float tpricewithoutvat = 0.0;
    total=0.0;
    totalvat=0.0;
    float totalSum=0.0;
    
    NSManagedObjectContext *context =[appDelegate managedObjectContext];
    NSEntityDescription *entityDesc =[NSEntityDescription entityForName:@"Trasections" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    
    NSArray *descriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [request setSortDescriptors:descriptors];
    
    
    
    NSEntityDescription *entityDesc2 =[NSEntityDescription entityForName:@"CustomDiscount" inManagedObjectContext:context];
    NSFetchRequest *request11 = [[NSFetchRequest alloc] init];
    [request11 setEntity:entityDesc2];
    
    
    
    NSError *error;
    
    NSArray *objects = [context executeFetchRequest:request error:&error];
    
    int sum=0;
    
    NSArray *objects2;
    
    NSMutableDictionary *dictSub;
    
    int finalID = 0;
    
    for(int i=0;i<objects.count;i++)
    {
        
        
        dictSub = [NSMutableDictionary new];
        
        NSManagedObject *person = (NSManagedObject *)[objects objectAtIndex:i];
        
        
        finalID = [[person valueForKey:@"id"] intValue];
        
        NSData *da=[person valueForKey:@"image"];
        
        UIImage *img=[[UIImage alloc] initWithData:da];
        
        [dictSub setObject:img forKey:@"image"];
        [dictSub setObject:[person valueForKey:@"name"] forKey:@"name"];
        [dictSub setObject:[person valueForKey:@"count"] forKey:@"count"];
        
        float newPrice = [[person valueForKey:@"price"] floatValue] ;//- [[person valueForKey:@"discount"] floatValue];
        
        [dictSub setObject:[NSString stringWithFormat:@"%f",newPrice] forKey:@"price"];
        
        
        float str = newPrice * [[person valueForKey:@"count"] floatValue];
        
        [dictSub setObject:[NSString stringWithFormat:@"%.02f", str] forKey:@"newprice"];
        
        [dictSub setObject:[person valueForKey:@"vat"] forKey:@"vat"];
        
        
        
        [dictSub setObject:[person valueForKey:@"discount"] forKey:@"discount"];
        [dictSub setObject:[person valueForKey:@"id"] forKey:@"id"];
        
        [dictSub setObject:[CommonMethods validateDictionaryValueForKey:[person valueForKey:@"discription"]]?[person valueForKey:@"discription"]:@"" forKey:@"discription"];
     //   [dictSub setObject:[person valueForKey:@"discription"] forKey:@"discription"];
        
        
        NSDate *date  = [person valueForKey:@"date"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        // Convert date object into desired format
        [dateFormatter setDateFormat:@"MMMM yyyy"];
        NSString *newDateString = [dateFormatter stringFromDate:date];
        [dictSub setObject:newDateString forKey:@"month"];
        
        [dateFormatter setDateFormat:@"dd"];
        NSString *day =[dateFormatter stringFromDate:date];
        
        
        [dateFormatter setDateFormat:@"EEEE"];
        NSString *dayE = [dateFormatter stringFromDate:date];
        
        NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
        // Convert date object into desired format
        [dateFormatter1 setDateFormat:@"dd-MMMM-yyyy, hh:mm a"];
        
        NSString *tdatetime = [dateFormatter1 stringFromDate:date];
        
        
        NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
        // Convert date object into desired format
        [dateFormatter2 setDateFormat:@"dd MMMM yyyy"];
        
        NSString *tDate = [dateFormatter2 stringFromDate:date];
        
        
        
        total=([[person valueForKey:@"price"] floatValue] *[[person valueForKey:@"count"] integerValue]-[[person valueForKey:@"discount"]floatValue]);
        
        
        
        
        if(curDay== nil)
        {
            
            if ([_str_paymentMethod isEqualToString:@"1"]) {
                countPayment =1;
            }
            else if ([_str_paymentMethod isEqualToString:@"2"]) {
                cardPayment =1;
            }
            else if ([_str_paymentMethod isEqualToString:@"3"]){
                swishPayment =1;
            }
            else if ([_str_paymentMethod isEqualToString:@"4"]){
                otherPayment =1;
            }
            
            curDay = day;
            curDayE = dayE;
            curId =  [[person valueForKey:@"id"] intValue];
            totaldate=tDate;
            totaldatetime = tdatetime;
            currentDate=tDate;
            
            NSArray* ary_ID = [str_IDs componentsSeparatedByString: @","];
            
            
            if ([ary_ID count]>0)
            {
                if (![ary_ID containsObject:[NSString stringWithFormat:@"%@",[person valueForKey:@"id"]]])
                {
                    str_IDs = [NSString stringWithFormat:@"%@,%@",str_IDs,[person valueForKey:@"id"]];
                }
            }
            
        }
        
        else if (![curDay isEqualToString:day])
        {
            
            int refundCount = 0 ;
            float totalammount = 0;
            
            NSManagedObjectContext *context =
            [appDelegate managedObjectContext];
            
            NSEntityDescription *entityDesc =
            [NSEntityDescription entityForName:@"RefundAmount"
                        inManagedObjectContext:context];
            
            NSFetchRequest *request = [[NSFetchRequest alloc] init];
            [request setEntity:entityDesc];
            
            NSPredicate *pred =
            [NSPredicate predicateWithFormat:@"(date = %@)",totaldate];
            [request setPredicate:pred];
            //    NSManagedObject *matches = nil;
            
            NSError *error;
            NSArray *objects = [context executeFetchRequest:request
                                                      error:&error];
            
            
            
            for (NSManagedObject *personRefund in objects)
            {
                //Problem
                refundCount ++;
                //                totalammount = totalammount + [[personRefund valueForKey:@"totalAmount"] floatValue];
                totalammount = [[personRefund valueForKey:@"totalAmount"] floatValue];
            }
            
            
            if ([str_IDs hasPrefix:@","])
            {
                str_IDs = [str_IDs substringFromIndex:1];
            }
            
            float discount = [self GetDiscountList:str_IDs];
            
            float totalPrice = 0.0;
            float vat = 0.0;
            float vatPercent = (totalvat*100)/tpricewithoutvat;
            
            if ([str_DiscountType isEqualToString:@"$"])
            {
                
                totalPrice = totalSum - discount;
                
            }
            else
            {
                totalPrice = totalSum - ((totalSum*discount)/100);
                
            }
            vat = totalPrice-(totalPrice/(1+vatPercent/100));
            
            
            NSMutableDictionary *dictSubb = [NSMutableDictionary new];
            [dictSubb setObject:curDay forKey:@"day"];
            [dictSubb setObject:curDayE forKey:@"dayE"];
            [dictSubb setObject:dictSubbM forKey:@"sub"];
            [dictSubb setObject:[NSString stringWithFormat:@"%d",countPayment] forKey:@"countPayment"];
            [dictSubb setObject:[NSString stringWithFormat:@"%d",swishPayment] forKey:@"swishPayment"];
            [dictSubb setObject:[NSString stringWithFormat:@"%d",otherPayment] forKey:@"otherPayment"];
            [dictSubb setObject:[NSString stringWithFormat:@"%d",cardPayment] forKey:@"cardPayment"];
            [dictSubb setObject:[NSString stringWithFormat:@"%f",totalSum] forKey:@"totalSum"];
            [dictSubb setObject:[NSString stringWithFormat:@"%f",vat] forKey:@"totalvat"];
            [dictSubb setObject:totaldatetime forKey:@"totaldatetime"];
            [dictSubb setObject:str_IDs forKey:@"finalid"];
            [dictSubb setObject:totaldate forKey:@"totaldate"];
            [dictSubb setObject:[NSString stringWithFormat:@"%.2f",discount] forKey:@"totaldiscount"];
            [dictSubb setObject:[NSString stringWithFormat:@"%d",refundCount] forKey:@"refundCount"];
            [dictSubb setObject:[NSString stringWithFormat:@"%.2f",totalammount] forKey:@"refundTotal"];
            [arraySub addObject:dictSubb];
            
            total = 0;
            totalvat = 0;
            tpricewithoutvat = 0;
            
            str_IDs = @"";
            totalSum = 0;
            sum = 0;
            dictSubbM = [NSMutableDictionary new];
            totaldate=tDate;
            currentDate=tDate;
            totaldatetime = tdatetime;
            if ([_str_paymentMethod isEqualToString:@"1"]) {
                countPayment =1;
            }
            else if ([_str_paymentMethod isEqualToString:@"2"]) {
                cardPayment =1;
            }
            else if ([_str_paymentMethod isEqualToString:@"3"]){
                swishPayment =1;
            }
            else if ([_str_paymentMethod isEqualToString:@"4"]){
                otherPayment =1;
            }
            
            curDay = day;
            curDayE = dayE;
            
        }
        else
        {
            
            if(curId!=[[person valueForKey:@"id"] intValue])
            {
                if ([_str_paymentMethod isEqualToString:@"1"]) {
                    countPayment++;
                }
                else if ([_str_paymentMethod isEqualToString:@"2"]) {
                    cardPayment++;
                }
                else if ([_str_paymentMethod isEqualToString:@"3"]){
                    swishPayment++;
                }
                else if ([_str_paymentMethod isEqualToString:@"4"]){
                    otherPayment++;
                }
                
            }
            
            NSArray* ary_ID = [str_IDs componentsSeparatedByString: @","];
            
            
            if ([ary_ID count]>0)
            {
                if (![ary_ID containsObject:[NSString stringWithFormat:@"%@",[person valueForKey:@"id"]]])
                {
                    str_IDs = [NSString stringWithFormat:@"%@,%@",str_IDs,[person valueForKey:@"id"]];
                }
            }
        }

        
        if(curMonth==nil)
            curMonth = newDateString;
        else if (![curMonth isEqualToString:newDateString])
        {
            
            NSMutableDictionary *dictMain = [NSMutableDictionary new];
            [dictMain setObject:curMonth forKey:@"month"];
            [dictMain setObject:arraySub forKey:@"main"];
            [arrayMain addObject:dictMain];
            
            arraySub = [NSMutableArray new];
            curMonth = newDateString;
            currentDate= newDateString;
        }
        
        
        if(curId!=[[person valueForKey:@"id"] intValue])
        {
            //            countPayment++;
            curId=[[person valueForKey:@"id"] intValue];
        }
        
        
        
        NSPredicate *predicate;
        predicate = [NSPredicate predicateWithFormat:@"(id = %@)", [person valueForKey:@"id"]];
        [request11 setPredicate:predicate];
        
        
        NSError *error2;
        objects2 = [context executeFetchRequest:request11 error:&error2];
        
        NSManagedObject *person2;
        
        for(int i=0;i<objects2.count;i++)
        {
            person2 = (NSManagedObject *)[objects2 objectAtIndex:i];
            
            float discount = 0.0;
            
            [dictSub setObject:[person2 valueForKey:@"discount"] forKey:@"customdiscount"];
            
            
        }
        
        
        
//        total = ([[person valueForKey:@"price"] floatValue] * [[person valueForKey:@"count"] integerValue]);
        
        
        
        zzzz = (([[person valueForKey:@"price"] floatValue]*[[person valueForKey:@"count"] integerValue])-[[person valueForKey:@"discount"]floatValue]) / (1 + [[person valueForKey:@"vat"] floatValue]/100);
        
        
        
        zzzz=(([[person valueForKey:@"price"] floatValue] *[[person valueForKey:@"count"] integerValue])-[[person valueForKey:@"discount"]floatValue])-zzzz;
        
        
        tpricewithoutvat = (([[person valueForKey:@"price"] floatValue]*[[person valueForKey:@"count"] integerValue])-[[person valueForKey:@"discount"]floatValue]) / (1 + [[person valueForKey:@"vat"] floatValue]/100) + tpricewithoutvat;
        
        totalvat = zzzz + totalvat;
        
        
        NSDate *TranDate=[person valueForKey:@"date"];
        
        [dateFormatter setDateFormat:@"MM"];
        
        NSString *str_monthT = [dateFormatter stringFromDate:TranDate];
        NSString *str_monthC = [dateFormatter stringFromDate:selectedDate];
        
        [dateFormatter setDateFormat:@"dd"];
        
        NSString *str_dayT = [dateFormatter stringFromDate:TranDate];
        NSString *str_dayC = [dateFormatter stringFromDate:selectedDate];
        
        [dateFormatter setDateFormat:@"yyyy"];
        
        NSString *str_yearT = [dateFormatter stringFromDate:TranDate];
        NSString *str_yearC = [dateFormatter stringFromDate:selectedDate];
        
        int yearT,yearC,monthT,monthC,dayT,dayC;
        
        
        yearT=[str_yearT intValue];
        yearC=[str_yearC intValue];
        
        monthT=[str_monthT intValue];
        monthC=[str_monthC intValue];
        
        dayT=[str_dayT intValue];
        dayC=[str_dayC intValue];
        
        
        if([[person valueForKey:@"zdayStatus"] intValue]==0)
        {
            if (yearC==yearT) {
                
                if (monthC==monthT) {
                    
                    if (dayC>=dayT) {
                        
                        
                        
                        int jCount=[[person valueForKey:@"count"] intValue];
                        
                        for (int j=0; j<jCount; j++) {
                            
                            
                            
                            
                            for (int i=0; i<[vatArray count]; i++) {
                     
                                
                                if ([[[vatArray objectAtIndex:i] valueForKey:@"vat"]isEqualToString:[NSString stringWithFormat:@"%@",[person valueForKey:@"vat"]]]) {
                                    
                                    
                                    
                                    
                                    NSString *str;
                                    
                                    //                str=[NSString stringWithFormat:@"%@",[person valueForKey:@"id"]];
                                    //
                                    //                if (![str isEqualToString:str_trnsId]) {
                                    //
                                    //                str_trnsId=[NSString stringWithFormat:@"%@",[person valueForKey:@"id"]];
                                    
                                    float vat_value=0.0;
                                    
                                    float str_ProPrice=0.0;
                                    float str_ProVat=0.0;
                                    float str_proDis=0.0;
                                    float str_proDisAmount=0.0;
                                    float str_proTotalAmount=0.0;
                                    float str_perProVat=0.0;
                                    float str_perProPrice=0.0;
                                    float actualVatWDis=0.0;
                                    float actualVatDis=0.0;
                                    
                                    
                                    str_ProPrice=([[person valueForKey:@"price"] floatValue]-[[person valueForKey:@"discount"]floatValue]);

                                    
                                    str_ProVat=[[person valueForKey:@"vat"] floatValue];

                                    if (objects2.count>0) {
                                        
                                        str_proDisAmount=[[person2 valueForKey:@"discount"] floatValue];
                                        
                                        
                                        
                                        str_proTotalAmount=[[person2 valueForKey:@"totalAmount"] floatValue];
                                        
                                        
                                        str_proDis=(str_proDisAmount/str_proTotalAmount)*100;
                                        
                                    }
                                    else
                                    {
                                        str_proDisAmount=0.0;
                                        str_proTotalAmount=0.0;
                                        
                                        str_proDis=0.0;
                                    }

                                    
                                    str_perProPrice=str_ProPrice/(1+str_ProVat/100);
                                    

                                    
                                    str_perProVat=str_ProPrice-str_perProPrice;
                                    
            
                                    
                                    float A=0;
                                    float B=0;
                                    float C=0;
                                    float D=0;
                                    
                                    A=(str_perProVat*100)/str_perProPrice;
                                    
                                    
                                    B=(str_proDis/100)*str_ProPrice;
                                    
                                    //                   C=str_ProPrice-(B/100)*str_ProPrice;
                                    C=str_ProPrice-B;
                                    
                                    
                                    
                                    
                                    D=C-(C/(1+A/100));
                  
                                    
                                    vat_value=[[[vatArray objectAtIndex:i] valueForKey:@"vatTotal"] floatValue];
                                    
                                    vat_value=vat_value+D;
                                    
                                    
                                    for(NSMutableDictionary *dict in vatArray)
                                    {
                                        
                                        
                                        if ([[dict valueForKey:@"vat"]isEqualToString:[NSString stringWithFormat:@"%@",[person valueForKey:@"vat"]]])
                                        {
                                            [dict setObject:[NSString stringWithFormat:@"%.02f",vat_value] forKey:@"vatTotal"];
                                        }
                                        
                                    }
                                    
                                    
                                    //            }
                                    
                                }
                            }
                        }
                        
                        
                        
                    }
                    
                }
                else if(monthC>monthT)
                {
                    
                    
                    
                    int jCount=[[person valueForKey:@"count"] intValue];
                    
                    for (int j=0; j<jCount; j++) {
                        
                        
                        
                        
                        for (int i=0; i<[vatArray count]; i++) {
                            
              
                            
                            if ([[[vatArray objectAtIndex:i] valueForKey:@"vat"]isEqualToString:[NSString stringWithFormat:@"%@",[person valueForKey:@"vat"]]]) {
                                
                                
                                
                                
                                NSString *str;
                                
                                //                str=[NSString stringWithFormat:@"%@",[person valueForKey:@"id"]];
                                //
                                //                if (![str isEqualToString:str_trnsId]) {
                                //
                                //                str_trnsId=[NSString stringWithFormat:@"%@",[person valueForKey:@"id"]];
                                
                                float vat_value=0.0;
                                
                                float str_ProPrice=0.0;
                                float str_ProVat=0.0;
                                float str_proDis=0.0;
                                float str_proDisAmount=0.0;
                                float str_proTotalAmount=0.0;
                                float str_perProVat=0.0;
                                float str_perProPrice=0.0;
                                float actualVatWDis=0.0;
                                float actualVatDis=0.0;
                                
                                
                                str_ProPrice=([[person valueForKey:@"price"] floatValue]-[[person valueForKey:@"discount"]floatValue]);

                                
                                str_ProVat=[[person valueForKey:@"vat"] floatValue];
                                
                            
                                if (objects2.count>0) {
                                    
                                    str_proDisAmount=[[person2 valueForKey:@"discount"] floatValue];
                                    
                                    
                                    
                                    str_proTotalAmount=[[person2 valueForKey:@"totalAmount"] floatValue];
                                    
                                    
                                    str_proDis=(str_proDisAmount/str_proTotalAmount)*100;
                                    
                                }
                                else
                                {
                                    str_proDisAmount=0.0;
                                    str_proTotalAmount=0.0;
                                    
                                    str_proDis=0.0;
                                }
                                
                      
                                
                                str_perProPrice=str_ProPrice/(1+str_ProVat/100);
                                
                              
                                
                                str_perProVat=str_ProPrice-str_perProPrice;
                            
                                
                                float A=0;
                                float B=0;
                                float C=0;
                                float D=0;
                                
                                A=(str_perProVat*100)/str_perProPrice;
                                
                                
                                B=(str_proDis/100)*str_ProPrice;
                           
                                C=str_ProPrice-B;
                                
                                
                                
                                
                                D=C-(C/(1+A/100));
                                
                              
                                
                                vat_value=[[[vatArray objectAtIndex:i] valueForKey:@"vatTotal"] floatValue];
                                
                                vat_value=vat_value+D;
                                
                                
                                for(NSMutableDictionary *dict in vatArray)
                                {
                                    
                                    
                                    if ([[dict valueForKey:@"vat"]isEqualToString:[NSString stringWithFormat:@"%@",[person valueForKey:@"vat"]]])
                                    {
                                        [dict setObject:[NSString stringWithFormat:@"%.02f",vat_value] forKey:@"vatTotal"];
                                    }
                                    
                                }
                                
                                
                                //            }
                                
                            }
                        }
                    }
                    
                    
                    
                }
                
            }
            else if(yearC>yearT)
            {
                
                
                
                int jCount=[[person valueForKey:@"count"] intValue];
                
                for (int j=0; j<jCount; j++) {
                    
                    
                    
                    
                    for (int i=0; i<[vatArray count]; i++) {
                        
                        
                        if ([[[vatArray objectAtIndex:i] valueForKey:@"vat"]isEqualToString:[NSString stringWithFormat:@"%@",[person valueForKey:@"vat"]]]) {
                            
                            
                            
                            
                            NSString *str;
                            
                            //                str=[NSString stringWithFormat:@"%@",[person valueForKey:@"id"]];
                            //
                            //                if (![str isEqualToString:str_trnsId]) {
                            //
                            //                str_trnsId=[NSString stringWithFormat:@"%@",[person valueForKey:@"id"]];
                            
                            float vat_value=0.0;
                            
                            float str_ProPrice=0.0;
                            float str_ProVat=0.0;
                            float str_proDis=0.0;
                            float str_proDisAmount=0.0;
                            float str_proTotalAmount=0.0;
                            float str_perProVat=0.0;
                            float str_perProPrice=0.0;
                            float actualVatWDis=0.0;
                            float actualVatDis=0.0;
                            
                            
                            str_ProPrice=([[person valueForKey:@"price"] floatValue]-[[person valueForKey:@"discount"]floatValue]);
                            

                            
                            str_ProVat=[[person valueForKey:@"vat"] floatValue];
                            
                       
                            if (objects2.count>0) {
                                
                                str_proDisAmount=[[person2 valueForKey:@"discount"] floatValue];
                                
                                
                                
                                str_proTotalAmount=[[person2 valueForKey:@"totalAmount"] floatValue];
                                
                                
                                str_proDis=(str_proDisAmount/str_proTotalAmount)*100;
                                
                            }
                            else
                            {
                                str_proDisAmount=0.0;
                                str_proTotalAmount=0.0;
                                
                                str_proDis=0.0;
                            }
                            
                  
                            str_perProPrice=str_ProPrice/(1+str_ProVat/100);
                        
                            str_perProVat=str_ProPrice-str_perProPrice;
                            
                         
                            
                            float A=0;
                            float B=0;
                            float C=0;
                            float D=0;
                            
                            A=(str_perProVat*100)/str_perProPrice;
                            
                            
                            B=(str_proDis/100)*str_ProPrice;
                            
    
                            C=str_ProPrice-B;
                            
                            
                            
                            
                            D=C-(C/(1+A/100));

                            
                            vat_value=[[[vatArray objectAtIndex:i] valueForKey:@"vatTotal"] floatValue];
                            
                            vat_value=vat_value+D;
                            
                            
                            for(NSMutableDictionary *dict in vatArray)
                            {
                                
                                
                                if ([[dict valueForKey:@"vat"]isEqualToString:[NSString stringWithFormat:@"%@",[person valueForKey:@"vat"]]])
                                {
                                    [dict setObject:[NSString stringWithFormat:@"%.02f",vat_value] forKey:@"vatTotal"];
                                }
                                
                            }
                            
                            
                            //            }
                            
                        }
                    }
                }
                
                
                
            }

        }
        
        totalSum = totalSum + total;
        
        if([dictSubbM objectForKey:[dictSub valueForKey:@"name"]])
        {
            
            NSMutableDictionary *dictTemp = [dictSubbM  objectForKey:[dictSub valueForKey:@"name"]];
            int countTemp = [[dictTemp valueForKey:@"count"] intValue] + [[dictSub valueForKey:@"count"] intValue];
            [dictTemp setObject:[NSString stringWithFormat:@"%d",countTemp] forKey:@"count"];
            [dictSubbM setObject:dictTemp forKey:[dictSub valueForKey:@"name"]];
            
        }
        else
        {
            [dictSubbM setObject:dictSub forKey:[dictSub valueForKey:@"name"]];
        }
        
        
        
        
        
        
    }
    
    
    
    
    
    NSMutableString *str_vat=[[NSMutableString alloc] init];
    NSString *str_per=@"%";
    
    float TotalVat=00;
    
    [str_vat appendString:@"( "];
    
    
    
    for (int i=0; i<[vatArray count]; i++) {

        
        if ([[[vatArray objectAtIndex:i] valueForKey:@"vatTotal"]floatValue]>0) {
            
            TotalVat=TotalVat+[[[vatArray objectAtIndex:i] valueForKey:@"vatTotal"] floatValue];
            
            [str_vat appendString:[NSString stringWithFormat:@"%@%@ : %@, ",[[vatArray objectAtIndex:i] valueForKey:@"vat"],str_per,[[vatArray objectAtIndex:i] valueForKey:@"vatTotal"]]];
            
        }
    }
    
    
    [str_vat deleteCharactersInRange:NSMakeRange([str_vat length]-2, 1)];
    if (TotalVat>0) {
        [str_vat appendString:@")"];
    }
    

    NSMutableDictionary *dict13 = [[NSMutableDictionary alloc]initWithDictionary:[ary_DetailList objectAtIndex:12]];
    [dict13 setObject:[NSString stringWithFormat:@"%@ %.02f %@",currencySign,TotalVat,str_vat] forKey:@"value"];
    [ary_DetailList replaceObjectAtIndex:12 withObject:dict13];
    
    [collectionView_ReportDetail reloadData];
    
 //   labelFeeValue.text=[NSString stringWithFormat:@"%@ %.02f %@",currencySign,TotalVat,str_vat];

    
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%.02f %@",TotalVat,str_vat] forKey:@"totalVat"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%lu",(unsigned long)objects.count] forKey:@"productCount"];
    
    zvat=[NSString stringWithFormat:@"%.02f %@",TotalVat,str_vat];
    if (TotalVat>0) {
        
    }
}


-(void)saveZDayReoprt
{
    
    zdate=[NSDate date];

    
    [appDelegate fetch_globalData];
    
    ztotalEmail=[[appDelegate.arrayGlobalData objectAtIndex:0] valueForKey:@"originalMailZDay"];
    ztotalEmailCopies=[[appDelegate.arrayGlobalData objectAtIndex:0] valueForKey:@"copyMailZDay"];
    ztotalPrint=[[appDelegate.arrayGlobalData objectAtIndex:0] valueForKey:@"originalPrintZDay"];
    ztotalPrintCopies=[[appDelegate.arrayGlobalData objectAtIndex:0] valueForKey:@"copyPrintZDay"];
    zrefundcount=[[appDelegate.arrayGlobalData objectAtIndex:0] valueForKey:@"refundZDay"];
    zrefundCountTotal=[[appDelegate.arrayGlobalData objectAtIndex:0] valueForKey:@"refund"];
    ztotalAmountMail=[[appDelegate.arrayGlobalData objectAtIndex:0] valueForKey:@"totalCopyMailAmountZDay"];
    ztotalAmountPrint=[[appDelegate.arrayGlobalData objectAtIndex:0] valueForKey:@"totalCopyPrintAmountZDay"];

    
    NSManagedObjectContext *contextz =[appDelegate managedObjectContext];
    NSEntityDescription *entityDescRec =[NSEntityDescription entityForName:@"ZDay" inManagedObjectContext:contextz];
    NSFetchRequest *requestRec = [[NSFetchRequest alloc] init];
    [requestRec setEntity:entityDescRec];
    NSError *errorz;
    NSArray *objectsRec = [contextz executeFetchRequest:requestRec error:&errorz];
    NSManagedObject *persoRec = (NSManagedObject *)[objectsRec lastObject];
    
    int x=[[persoRec valueForKey:@"id"] intValue]+1;
    NSString *str_transactionId=[NSString stringWithFormat:@"%d",x];
    
    NSManagedObjectContext *context =[appDelegate managedObjectContext];
    NSEntityDescription *entityDesc =[NSEntityDescription entityForName:@"ZDay" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *NumberId = [f numberFromString:str_transactionId];
    
    
    NSManagedObject *newContact;
    newContact = [NSEntityDescription insertNewObjectForEntityForName:@"ZDay" inManagedObjectContext:context];
    
    [newContact setValue:NumberId  forKey:@"id"];
    [newContact setValue:zcardPayment forKey:@"cardPayment"];
    [newContact setValue:zcashPayment forKey:@"cashPayment"];
    [newContact setValue:zswishPayment forKey:@"swishPayment"];
    [newContact setValue:zotherPayment forKey:@"otherPayment"];
    [newContact setValue:zdate forKey:@"date"];
    [newContact setValue:zdiscunts forKey:@"discunts"];
    [newContact setValue:zgrandTotalRefund forKey:@"grandTotalRefund"];
    [newContact setValue:zgrandTotalSale forKey:@"grandTotalSale"];
    [newContact setValue:zgrandtotalSale_Refund forKey:@"grandtotalSale_Refund"];
    [newContact setValue:zrefund forKey:@"refund"];
    [newContact setValue:ztotalEmail forKey:@"totalEmail"];
    [newContact setValue:ztotalEmailCopies forKey:@"totalEmailCopies"];
    [newContact setValue:ztotalAmountMail forKey:@"totalCopyMailAmount"];
    [newContact setValue:ztotalPayments forKey:@"totalPayments"];
    [newContact setValue:ztotalCashPayments forKey:@"totalCashPayments"];
    [newContact setValue:ztotalCardPayments forKey:@"totalCardPayments"];
    [newContact setValue:ztotalSwishPayments forKey:@"totalSwishPayments"];
    [newContact setValue:ztotalOtherPayments forKey:@"totalOtherPayments"];
    [newContact setValue:ztotalPrint forKey:@"totalPrint"];
    [newContact setValue:ztotalPrintCopies forKey:@"totalPrintCopies"];
    [newContact setValue:ztotalAmountPrint forKey:@"totalCopyPrintAmount"];
    [newContact setValue:ztotalProduct forKey:@"totalProduct"];
    [newContact setValue:zvat forKey:@"vat"];
    [newContact setValue:zrefundcount forKey:@"refundcount"];
    [newContact setValue:zrefundCountTotal forKey:@"grandtotal_refundCount"];
    
    [context save:&error];
    
    [self createLogDetails:[Language get:@"Z-REPORT" alter:@"!Z-REPORT"]];
    
    [appDelegate resetZdayGlobalValue];
    [self fetch_ZdayData];
    [self editTransactionForZday];
    [self editRefundForZday];
    
    zcardPayment=@"0.0";
    zcashPayment=@"0.0";
    zswishPayment=@"0.0";
    zotherPayment=@"0.0";
    zdate=[NSDate date];
    zdiscunts=@"0.0";
    zgrandTotalRefund=@"0.0";
    zgrandTotalSale=@"0.0";
    zgrandtotalSale_Refund=@"0.0";
    zrefund=@"0.0";
    ztotalEmail=@"0";
    ztotalEmailCopies=@"0";
    ztotalAmountMail=@"0";
    ztotalPayments=@"0";
    ztotalPrint=@"0";
    ztotalPrintCopies=@"0";
    ztotalAmountPrint=@"0";
    ztotalProduct=@"0";
    zvat=@"0.0";
    
    
    isPrintTran = NO;
    
}


-(void)fetch_ZdayData
{
    zDayArray=[NSMutableArray new];
    
    
    NSManagedObjectContext *context =[appDelegate managedObjectContext];
    NSEntityDescription *entityDescc =[NSEntityDescription entityForName:@"ZDay" inManagedObjectContext:context];
    NSFetchRequest *requestt = [[NSFetchRequest alloc] init];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"id.intValue" ascending:NO];
    NSArray *descriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [requestt setSortDescriptors:descriptors];
    
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
            
            [dict setObject:[matches valueForKey:@"id"] forKey:@"id"];
            [dict setObject:[matches valueForKey:@"cashPayment"] forKey:@"cashPayment"];
            [dict setObject:[matches valueForKey:@"cardPayment"] forKey:@"cardPayment"];
            [dict setObject:[matches valueForKey:@"swishPayment"] forKey:@"swishPayment"];
            [dict setObject:[matches valueForKey:@"otherPayment"] forKey:@"otherPayment"];
            [dict setObject:[matches valueForKey:@"date"] forKey:@"date"];
            [dict setObject:[matches valueForKey:@"discunts"] forKey:@"discunts"];
            [dict setObject:[matches valueForKey:@"grandTotalRefund"] forKey:@"grandTotalRefund"];
            [dict setObject:[matches valueForKey:@"grandTotalSale"] forKey:@"grandTotalSale"];
            [dict setObject:[matches valueForKey:@"grandtotalSale_Refund"] forKey:@"grandtotalSale_Refund"];
            [dict setObject:[matches valueForKey:@"refund"] forKey:@"refund"];
            [dict setObject:[matches valueForKey:@"totalEmail"] forKey:@"totalEmail"];
            [dict setObject:[matches valueForKey:@"totalEmailCopies"] forKey:@"totalEmailCopies"];
            [dict setObject:[matches valueForKey:@"totalCopyMailAmount"] forKey:@"totalCopyMailAmount"];
            [dict setObject:[matches valueForKey:@"totalPayments"] forKey:@"totalPayments"];
            [dict setObject:[matches valueForKey:@"totalCashPayments"] forKey:@"totalCashPayments"];
            [dict setObject:[matches valueForKey:@"totalCardPayments"] forKey:@"totalCardPayments"];
            [dict setObject:[matches valueForKey:@"totalSwishPayments"] forKey:@"totalSwishPayments"];
            [dict setObject:[matches valueForKey:@"totalOtherPayments"] forKey:@"totalOtherPayments"];
            [dict setObject:[matches valueForKey:@"totalPrint"] forKey:@"totalPrint"];
            [dict setObject:[matches valueForKey:@"totalPrintCopies"] forKey:@"totalPrintCopies"];
            [dict setObject:[matches valueForKey:@"totalCopyPrintAmount"] forKey:@"totalCopyPrintAmount"];
            [dict setObject:[matches valueForKey:@"totalProduct"] forKey:@"totalProduct"];
            [dict setObject:[matches valueForKey:@"vat"] forKey:@"vat"];
            [dict setObject:[matches valueForKey:@"refundcount"] forKey:@"refundcount"];
            [dict setObject:[matches valueForKey:@"grandtotal_refundCount"] forKey:@"grandtotal_refundCount"];
            
            [zDayArray addObject:dict];
            
        }
    }

    
    [maintablev reloadData];
//    [tableViewItems reloadData];
}

-(void)editTransactionForZday
{
    NSManagedObjectContext *context =[appDelegate managedObjectContext];
    NSError *error;
    NSEntityDescription *entityDescc =[NSEntityDescription entityForName:@"Trasections" inManagedObjectContext:context];
    NSFetchRequest *requestt = [[NSFetchRequest alloc] init];
    [requestt setEntity:entityDescc];
    
    NSArray *objectss = [context executeFetchRequest:requestt error:&error];
    if ([objectss count] == 0) {
        
    }
    else
    {
        for (int i=0; i<[objectss count]; i++) {
            
            NSManagedObject *obj=(NSManagedObject *)[objectss objectAtIndex:i];
            
            [obj setValue:[NSNumber numberWithInt:1] forKey:@"zdayStatus"];
            [context save:&error];
        }
   
    }
}

-(void)editRefundForZday
{
    NSManagedObjectContext *context =[appDelegate managedObjectContext];
    NSError *error;
    NSEntityDescription *entityDescc =[NSEntityDescription entityForName:@"RefundAmount" inManagedObjectContext:context];
    NSFetchRequest *requestt = [[NSFetchRequest alloc] init];
    [requestt setEntity:entityDescc];
    
    NSArray *objectss = [context executeFetchRequest:requestt error:&error];
    if ([objectss count] == 0) {
        
    }
    else
    {
        
        for (int i=0; i<[objectss count]; i++) {
            NSManagedObject *obj=(NSManagedObject *)[objectss objectAtIndex:i];
            [obj setValue:[NSNumber numberWithInt:1] forKey:@"zdayStatus"];
            [context save:&error];
        }
        
        
    }
}


-(void)viewZdayData:(int)index
{
    
    if (zDayArray.count>0) {
        
        selectedRow=index;
        
        NSMutableArray * arrayItems1 = [NSMutableArray new];
        
        arrayItems1=[zDayArray objectAtIndex:index];
        
        appDelegate.arrayZDayReport=arrayItems1;
        
        
        NSMutableDictionary *dict1 = [[NSMutableDictionary alloc]initWithDictionary:[ary_DetailList objectAtIndex:0]];
        [dict1 setObject:[NSString stringWithFormat:@"%@ %@ ",[[zDayArray objectAtIndex:index] valueForKey:@"totalCashPayments"],[Language get:@"Card payments" alter:@"!Card payments"]] forKey:@"title"];
        [dict1 setObject:[NSString stringWithFormat:@"%@ %@",currencySign,[[zDayArray objectAtIndex:index] valueForKey:@"cardPayment"]] forKey:@"value"];
        [ary_DetailList replaceObjectAtIndex:0 withObject:dict1];
        
        
        NSMutableDictionary *dict2 = [[NSMutableDictionary alloc]initWithDictionary:[ary_DetailList objectAtIndex:1]];
        [dict2 setObject:[NSString stringWithFormat:@"%@ %@ ",[[zDayArray objectAtIndex:index] valueForKey:@"totalCardPayments"],[Language get:@"Cash payments" alter:@"!Cash payments"]] forKey:@"title"];
        [dict2 setObject:[NSString stringWithFormat:@"%@ %@",currencySign,[[zDayArray objectAtIndex:index] valueForKey:@"cashPayment"]] forKey:@"value"];
        [ary_DetailList replaceObjectAtIndex:1 withObject:dict2];
        
        
        NSMutableDictionary *dict3 = [[NSMutableDictionary alloc]initWithDictionary:[ary_DetailList objectAtIndex:2]];
        [dict3 setObject:[NSString stringWithFormat:@"%@ %@ ",[[zDayArray objectAtIndex:index] valueForKey:@"totalSwishPayments"],[Language get:@"Swish payments" alter:@"!Swish payments"]] forKey:@"title"];
        [dict3 setObject:[NSString stringWithFormat:@"%@ %@",currencySign,[[zDayArray objectAtIndex:index] valueForKey:@"swishPayment"]] forKey:@"value"];
        [ary_DetailList replaceObjectAtIndex:2 withObject:dict3];
        
        
        NSMutableDictionary *dict4 = [[NSMutableDictionary alloc]initWithDictionary:[ary_DetailList objectAtIndex:3]];
        [dict4 setObject:[NSString stringWithFormat:@"%@ %@ ",[[zDayArray objectAtIndex:index] valueForKey:@"totalOtherPayments"],[Language get:@"Other payments" alter:@"!Other payments"]] forKey:@"title"];
        [dict4 setObject:[NSString stringWithFormat:@"%@ %@",currencySign,[[zDayArray objectAtIndex:index] valueForKey:@"otherPayment"]] forKey:@"value"];
        [ary_DetailList replaceObjectAtIndex:3 withObject:dict4];
        
        
        NSMutableDictionary *dict5 = [[NSMutableDictionary alloc]initWithDictionary:[ary_DetailList objectAtIndex:4]];
        [dict5 setObject:[NSString stringWithFormat:@"%@ %@",[[zDayArray objectAtIndex:index] valueForKey:@"totalEmail"], [Language get:@"Receipt email" alter:@"Receipt email"]] forKey:@"title"];
        [dict5 setObject:[NSString stringWithFormat:@"%@ %@",[[zDayArray objectAtIndex:index] valueForKey:@"totalEmailCopies"], [Language get:@"Copies email" alter:@"Receipt email"]] forKey:@"value"];
        [ary_DetailList replaceObjectAtIndex:4 withObject:dict5];
        
        
        NSMutableDictionary *dict6 = [[NSMutableDictionary alloc]initWithDictionary:[ary_DetailList objectAtIndex:5]];
        [dict6 setObject:[NSString stringWithFormat:@"%@ %@",[[zDayArray objectAtIndex:index] valueForKey:@"refundcount"],[Language get:@"Refund" alter:@"!Refund"]] forKey:@"title"];
        [dict6 setObject:[NSString stringWithFormat:@"-%@ %@", currencySign, [[zDayArray objectAtIndex:index] valueForKey:@"refund"]] forKey:@"value"];
        [ary_DetailList replaceObjectAtIndex:5 withObject:dict6];
        
        
        NSMutableDictionary *dict7 = [[NSMutableDictionary alloc]initWithDictionary:[ary_DetailList objectAtIndex:6]];
        [dict7 setObject:[NSString stringWithFormat:@"-%@ %@",currencySign,[[zDayArray objectAtIndex:index] valueForKey:@"discunts"]] forKey:@"value"];
        [ary_DetailList replaceObjectAtIndex:6 withObject:dict7];
        
        
        NSMutableDictionary *dict8 = [[NSMutableDictionary alloc]initWithDictionary:[ary_DetailList objectAtIndex:7]];
        [dict8 setObject:[NSString stringWithFormat:@"%@ %@",[[zDayArray objectAtIndex:index] valueForKey:@"totalPrint"],[Language get:@"Receipt print" alter:@"Receipt print"]] forKey:@"title"];
        [dict8 setObject:[NSString stringWithFormat:@"%@ %@",[[zDayArray objectAtIndex:index] valueForKey:@"totalPrintCopies"],[Language get:@"Copies print" alter:@"Receipt print"]] forKey:@"value"];
        [ary_DetailList replaceObjectAtIndex:7 withObject:dict8];
        
        
        NSMutableDictionary *dict9 = [[NSMutableDictionary alloc]initWithDictionary:[ary_DetailList objectAtIndex:8]];
        [dict9 setObject:[NSString stringWithFormat:@"%@ %@", currencySign,[[zDayArray objectAtIndex:index] valueForKey:@"grandTotalSale"]] forKey:@"value"];
        [ary_DetailList replaceObjectAtIndex:8 withObject:dict9];
        
        
        NSMutableDictionary *dict10 = [[NSMutableDictionary alloc]initWithDictionary:[ary_DetailList objectAtIndex:9]];
        [dict10 setObject:[NSString stringWithFormat:@"%@ %@",[[zDayArray objectAtIndex:index] valueForKey:@"grandtotal_refundCount"],[Language get:@"Grand total refund" alter:@"!Grand total refund"]] forKey:@"title"];
        [dict10 setObject:[NSString stringWithFormat:@"-%@ %@", currencySign,[[zDayArray objectAtIndex:index] valueForKey:@"grandTotalRefund"]] forKey:@"value"];
        [ary_DetailList replaceObjectAtIndex:9 withObject:dict10];
        
        
        if ([[[zDayArray objectAtIndex:index] valueForKey:@"grandTotalSale"] intValue]<1) {
            
            NSMutableDictionary *dict11 = [[NSMutableDictionary alloc]initWithDictionary:[ary_DetailList objectAtIndex:10]];
            [dict11 setObject:[NSString stringWithFormat:@"-%@ %@", currencySign,[[zDayArray objectAtIndex:index] valueForKey:@"grandtotalSale_Refund"]] forKey:@"value"];
            [ary_DetailList replaceObjectAtIndex:10 withObject:dict11];
           
        }
        else
        {
            NSMutableDictionary *dict11 = [[NSMutableDictionary alloc]initWithDictionary:[ary_DetailList objectAtIndex:10]];
            [dict11 setObject:[NSString stringWithFormat:@"%@ %@", currencySign,[[zDayArray objectAtIndex:index] valueForKey:@"grandtotalSale_Refund"]] forKey:@"value"];
            [ary_DetailList replaceObjectAtIndex:10 withObject:dict11];
            
        }
        
        NSMutableDictionary *dict12 = [[NSMutableDictionary alloc]initWithDictionary:[ary_DetailList objectAtIndex:11]];
        [dict12 setObject:[NSString stringWithFormat:@"%@ %@",[[zDayArray objectAtIndex:index] valueForKey:@"totalProduct"], [Language get:@"Products" alter:@"Products"]] forKey:@"title"];
        [ary_DetailList replaceObjectAtIndex:11 withObject:dict12];
        
        
        NSMutableDictionary *dict13 = [[NSMutableDictionary alloc]initWithDictionary:[ary_DetailList objectAtIndex:12]];
        [dict13 setObject:[NSString stringWithFormat:@"%@ %@",currencySign,[[zDayArray objectAtIndex:index] valueForKey:@"vat"]] forKey:@"value"];
        [ary_DetailList replaceObjectAtIndex:12 withObject:dict13];
        
        
        [collectionView_ReportDetail reloadData];
        

        
        int i = [[[zDayArray objectAtIndex:index] valueForKey:@"totalCashPayments"] integerValue] + [[[zDayArray objectAtIndex:index] valueForKey:@"totalCardPayments"] integerValue] + [[[zDayArray objectAtIndex:index] valueForKey:@"totalSwishPayments"] integerValue] + [[[zDayArray objectAtIndex:index] valueForKey:@"totalOtherPayments"] intValue];
        
        
        labelQuantity.text = [NSString stringWithFormat:@"%d",i];
        
        
        float totalPayment=0.0;
        
        totalPayment=([[[zDayArray objectAtIndex:index] valueForKey:@"cashPayment"] floatValue]+[[[zDayArray objectAtIndex:index] valueForKey:@"cardPayment"] floatValue] + [[[zDayArray objectAtIndex:index] valueForKey:@"swishPayment"] floatValue] + [[[zDayArray objectAtIndex:index] valueForKey:@"otherPayment"] floatValue]);
        
        labelTotal.text = [NSString stringWithFormat:@"%@ %0.2f",currencySign,totalPayment];

        
        self.labelReportNumber.text = [NSString stringWithFormat:@"%@ %@",[Language get:@"Report Number" alter:@"!Report Number"], [[zDayArray objectAtIndex:index] valueForKey:@"id"]];
        
        
        NSDate *zdayDate=[[zDayArray valueForKey:@"date"]objectAtIndex:index];
        
        
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
            
            NSString *dateString=[NSString stringWithFormat:@"%@-%@-%@ %@",str_day,str_month,str_year,str_time];
            
            
            labelFooterDate.text = dateString;
            labelHeaderDate.text =[NSString stringWithFormat:@"%@",[Language get:@"Z-REPORT" alter:@"!Z-REPORT"]];
            
            
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
            
            NSString *dateString=[NSString stringWithFormat:@"%@-%@-%@ %@",str_day,str_month,str_year,str_time];
            
            
            
            labelFooterDate.text = dateString;
            labelHeaderDate.text =[NSString stringWithFormat:@"%@",[Language get:@"Z-REPORT" alter:@"!Z-REPORT"]];
            
            
        }
        zDayLogIndexDate=[[zDayArray valueForKey:@"date"]objectAtIndex:index];
    }
    else
    {
        
        NSMutableDictionary *dict1 = [[NSMutableDictionary alloc]initWithDictionary:[ary_DetailList objectAtIndex:0]];
        [dict1 setObject:[NSString stringWithFormat:@"0 %@ ",[Language get:@"Card payments" alter:@"!Card payments"]] forKey:@"title"];
        [dict1 setObject:[NSString stringWithFormat:@"%@ 0.00", currencySign] forKey:@"value"];
        [ary_DetailList replaceObjectAtIndex:0 withObject:dict1];
        
        
        NSMutableDictionary *dict2 = [[NSMutableDictionary alloc]initWithDictionary:[ary_DetailList objectAtIndex:1]];
        [dict2 setObject:[NSString stringWithFormat:@"0 %@ ",[Language get:@"Cash payments" alter:@"!Cash payments"]] forKey:@"title"];
        [dict2 setObject:[NSString stringWithFormat:@"%@ 0.00", currencySign] forKey:@"value"];
        [ary_DetailList replaceObjectAtIndex:1 withObject:dict2];
        
        
        NSMutableDictionary *dict3 = [[NSMutableDictionary alloc]initWithDictionary:[ary_DetailList objectAtIndex:2]];
        [dict3 setObject:[NSString stringWithFormat:@"0 %@ ",[Language get:@"Swish payments" alter:@"!Swish payments"]] forKey:@"title"];
        [dict3 setObject:[NSString stringWithFormat:@"%@ 0.00", currencySign] forKey:@"value"];
        [ary_DetailList replaceObjectAtIndex:2 withObject:dict3];
        
        
        NSMutableDictionary *dict4 = [[NSMutableDictionary alloc]initWithDictionary:[ary_DetailList objectAtIndex:3]];
        [dict4 setObject:[NSString stringWithFormat:@"0 %@ ",[Language get:@"Other payments" alter:@"!Other payments"]] forKey:@"title"];
        [dict4 setObject:[NSString stringWithFormat:@"%@ 0.00", currencySign] forKey:@"value"];
        [ary_DetailList replaceObjectAtIndex:3 withObject:dict4];
        
        
        NSMutableDictionary *dict5 = [[NSMutableDictionary alloc]initWithDictionary:[ary_DetailList objectAtIndex:4]];
        [dict5 setObject:[NSString stringWithFormat:@"0 %@", [Language get:@"Receipt email" alter:@"Receipt email"]] forKey:@"title"];
        [dict5 setObject:[NSString stringWithFormat:@"0 %@", [Language get:@"Copies email" alter:@"Receipt email"]] forKey:@"value"];
        [ary_DetailList replaceObjectAtIndex:4 withObject:dict5];
        
        
        NSMutableDictionary *dict6 = [[NSMutableDictionary alloc]initWithDictionary:[ary_DetailList objectAtIndex:5]];
        [dict6 setObject:[NSString stringWithFormat:@"0 %@",[Language get:@"Refund" alter:@"!Refund"]] forKey:@"title"];
        [dict6 setObject:[NSString stringWithFormat:@"-%@ 0.00", currencySign] forKey:@"value"];
        [ary_DetailList replaceObjectAtIndex:5 withObject:dict6];
        
        
        NSMutableDictionary *dict7 = [[NSMutableDictionary alloc]initWithDictionary:[ary_DetailList objectAtIndex:6]];
        [dict7 setObject:[NSString stringWithFormat:@"-%@ 0.00",currencySign] forKey:@"value"];
        [ary_DetailList replaceObjectAtIndex:6 withObject:dict7];
        
        
        NSMutableDictionary *dict8 = [[NSMutableDictionary alloc]initWithDictionary:[ary_DetailList objectAtIndex:7]];
        [dict8 setObject:[NSString stringWithFormat:@"0 %@",[Language get:@"Receipt print" alter:@"Receipt print"]] forKey:@"title"];
        [dict8 setObject:[NSString stringWithFormat:@"0 %@",[Language get:@"Copies print" alter:@"Receipt print"]] forKey:@"value"];
        [ary_DetailList replaceObjectAtIndex:7 withObject:dict8];
        
        
        NSMutableDictionary *dict9 = [[NSMutableDictionary alloc]initWithDictionary:[ary_DetailList objectAtIndex:8]];
        [dict9 setObject:[NSString stringWithFormat:@"%@ 0.00", currencySign] forKey:@"value"];
        [ary_DetailList replaceObjectAtIndex:8 withObject:dict9];
        
        
        NSMutableDictionary *dict10 = [[NSMutableDictionary alloc]initWithDictionary:[ary_DetailList objectAtIndex:9]];
        [dict10 setObject:[NSString stringWithFormat:@"%@",[Language get:@"Grand total refund" alter:@"!Grand total refund"]] forKey:@"title"];
        [dict10 setObject:[NSString stringWithFormat:@"-%@ 0.00", currencySign] forKey:@"value"];
        [ary_DetailList replaceObjectAtIndex:9 withObject:dict10];
        
        
        NSMutableDictionary *dict11 = [[NSMutableDictionary alloc]initWithDictionary:[ary_DetailList objectAtIndex:10]];
        [dict11 setObject:[NSString stringWithFormat:@"%@ 0.00", currencySign] forKey:@"value"];
        [ary_DetailList replaceObjectAtIndex:10 withObject:dict11];
        
        
        NSMutableDictionary *dict12 = [[NSMutableDictionary alloc]initWithDictionary:[ary_DetailList objectAtIndex:11]];
        [dict12 setObject:[NSString stringWithFormat:@"0 %@", [Language get:@"Products" alter:@"Products"]] forKey:@"title"];
        [ary_DetailList replaceObjectAtIndex:11 withObject:dict12];
        
        
        NSMutableDictionary *dict13 = [[NSMutableDictionary alloc]initWithDictionary:[ary_DetailList objectAtIndex:12]];
        [dict13 setObject:[NSString stringWithFormat:@"%@ 0.00",currencySign] forKey:@"value"];
        [ary_DetailList replaceObjectAtIndex:12 withObject:dict13];
        
        
        [collectionView_ReportDetail reloadData];
        
        labelQuantity.text = [NSString stringWithFormat:@"%@",@"0"];
        
        
        labelTotal.text = [NSString stringWithFormat:@"%@ %@",currencySign,@"0.00"];
   
        
        labelFooterDate.text = @"";
        labelHeaderDate.text =@"";
        
    }
    
    if (dictAllZDayItems.count>0) {
        self.btnMailReceipt.hidden=NO;
        self.btnPrintReceipt.hidden=NO;
    }
}



#pragma mark end ZDayReport

-(void)createLogDetails:(NSString *)logText
{
    NSString *articleid=@"";
    
    NSManagedObjectContext *context =[appDelegate managedObjectContext];
    NSEntityDescription *entityDesc =[NSEntityDescription entityForName:@"Log" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    
    
    int artId;
    int aid;
    
    if ([objects count]==0) {
        
        artId=1;
        
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"logID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    else
    {
    
        
        aid= [[[NSUserDefaults standardUserDefaults] valueForKey:@"logID"] intValue];
        artId=aid+1;
        
        
        articleid=[NSString stringWithFormat:@"%d",(int)(artId)];
        
        
        NSManagedObjectContext *context =[appDelegate managedObjectContext];
        NSEntityDescription *entityDesc =[NSEntityDescription entityForName:@"Log" inManagedObjectContext:context];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entityDesc];
        NSPredicate *pred =[NSPredicate predicateWithFormat:@"(sno = %@)",articleid];
        [request setPredicate:pred];
        
        NSError *error;
        NSArray *objects = [context executeFetchRequest:request error:&error];
        
        if (objects.count>0) {
            
            artId=artId+1;
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",artId] forKey:@"logID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    
    articleid=[NSString stringWithFormat:@"%d",(int)(artId)];
    
    context =[appDelegate managedObjectContext];
    
    
    NSManagedObject *newContact;
    newContact = [NSEntityDescription insertNewObjectForEntityForName:@"Log" inManagedObjectContext:context];
    
    [newContact setValue:[NSDate date] forKey:@"date"];
    [newContact setValue:articleid forKey:@"sno"];
    
    NSString *stringDateTime;
//    stringDateTime = [NSString stringWithFormat:@"%@",[[[[dictAllItems objectAtIndex:selectedSection] objectForKey:@"main"] objectAtIndex:selectedRow] valueForKey:@"totaldatetime"]];
    stringDateTime = [NSString stringWithFormat:@"%@",[[[dictAllItems objectAtIndex:selectedSection] objectForKey:@"main"] valueForKey:@"totaldatetime"]];
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd-MMMM-yyyy, hh:mm a"];
    
    NSDate *date_get=[dateFormatter dateFromString:stringDateTime];
    
    //        NSDate *currDate = [NSDate date];
    
    NSDate *currDate = zDayLogIndexDate;
    
    [dateFormatter setDateFormat:@"MMMM"];
//    
    
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
    
    
    
//    
    
//    NSString *str_month = [dateFormatter stringFromDate:currDate];
    
    [dateFormatter setDateFormat:@"dd"];
    
    NSString *str_day = [dateFormatter stringFromDate:currDate];
    
    [dateFormatter setDateFormat:@"yyyy"];
    
    NSString *str_year = [dateFormatter stringFromDate:currDate];
    
    [dateFormatter setDateFormat:@"hh:mm a"];
    
    NSString *str_time = [dateFormatter stringFromDate:currDate];
    
    NSString *dateString=[NSString stringWithFormat:@"%@-%@-%@ %@",str_day,str_month,str_year,str_time];

    
    [dateFormatter setDateFormat:@"dd-MMMM-yyyy"];
    
    
    NSString *str_DateSelected = [dateFormatter stringFromDate:currDate];
    NSString *str_DateCurrent = [dateFormatter stringFromDate:[NSDate date]];
    

    
    if ([logText containsString:@"Printed"]) {
        
        [newContact setValue:[NSString stringWithFormat:@"%@ %@",logText,dateString] forKey:@"discription"];
    }
    else if([logText containsString:@"to"])
    {
        [newContact setValue:[NSString stringWithFormat:@"Emailed report of %@ %@",dateString,logText] forKey:@"discription"];
    }
    else
    {
        [newContact setValue:[NSString stringWithFormat:@"%@ %@",logText,dateString] forKey:@"discription"];
    }
    
    
    [context save:&error];
    
}


#pragma mark get all transaction 

-(void)allTransaction
{
    dictAllTransaction = [NSMutableArray new];

    
    
    
    NSMutableArray *arraySub = [NSMutableArray new];
    NSMutableArray *arraySubb = [NSMutableArray new];
    NSMutableArray *arrayMain = [NSMutableArray new];
    
    NSString *cuDate = nil;
    
    int curId = -1;
    
    float tprice = 0;
    float tpricewithoutvat = 0;
    
    total=0.0;
    totalvat=0.0;
    
    float float_TotalPrice = 0.0;
    float int_TotalVat = 0;
    float float_Discount = 0.0;
    NSString *str_Multiple = @"No";
    
    NSString *str_paymentMode;
    
    NSMutableDictionary *dictSub;
    
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
        
        
        if ([[person valueForKey:@"zdayStatus"] intValue]==0) {
        
        
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
        
        [dictSub setObject:[CommonMethods validateDictionaryValueForKey:[person valueForKey:@"discription"]]?[person valueForKey:@"discription"]:@"" forKey:@"discription"];
       // [dictSub setObject:[person valueForKey:@"discription"] forKey:@"discription"];
        
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
            [dictSubb setObject:[person valueForKey:@"paymentMethod"] forKey:@"paymentMethod"];
            
            
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

        
        
        tprice = tprice + total;
        
        str_paymentMode=[person valueForKey:@"paymentMethod"];
            
        NSString *str_IDs=[NSString stringWithFormat:@"%@",[person valueForKey:@"id"]];
        
        if ([str_IDs hasPrefix:@","])
        {
            str_IDs = [str_IDs substringFromIndex:1];
        }
        
        float_Discount = [self GetDiscountList:str_IDs];
        
        total=total-float_Discount;
        
        [dictSub setObject:[NSString stringWithFormat:@"%ld", (long)total] forKey:@"price"];
        
        [arraySubb addObject:dictSub];
            
            
            
        }
    }
    
    if (objects.count != 0)
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
                
        [dictSubb setObject:[NSString stringWithFormat:@"%d",curId] forKey:@"id"];
        [dictSubb setObject:arraySubb forKey:@"sub"];
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
        
        
        [arrayMain addObject:dictMain];
        
     
        dictAllTransaction = arrayMain;
        
  
        
    }
    else
    {
        
      
    }
    
 
    [self amountCalculation];
}


#pragma mark calculate card and cash amount

-(void)amountCalculation
{
   
    float totalCash = 0.0;
    float totalCard= 0.0;
    float totalSwish = 0.0;
    float totalOther= 0.0;
    totalCashPaymetCount=0.0;
    totalCardPaymetCount=0.0;
    totalSwishPaymetCount=0.0;
    totalOtherPaymetCount=0.0;
    
    
    for (int k=0; k<dictAllTransaction.count; k++) {
        
    
    for (int i=0; i<[[[dictAllTransaction objectAtIndex:k] objectForKey:@"main"] count]; i++) {
        
    
        
        
    NSMutableArray * arrayItems;
    
        if ([dictAllTransaction count]>0)
            arrayItems = [[[dictAllTransaction objectAtIndex:k] objectForKey:@"main"] objectAtIndex:i];
    

    
        if ([[[[arrayItems valueForKey:@"sub"] objectAtIndex:0] valueForKey:@"paymentMethod"] intValue]==2) {
            
            
            totalCard=totalCard+[[arrayItems valueForKey:@"tprice"] floatValue];
            
            totalCardPaymetCount=totalCardPaymetCount+1;
        }
        else if ([[[[arrayItems valueForKey:@"sub"] objectAtIndex:0] valueForKey:@"paymentMethod"] intValue]==1)
        {
            
            totalCash=totalCash+[[arrayItems valueForKey:@"tprice"] floatValue];
            totalCashPaymetCount=totalCashPaymetCount+1;
        }
        else if ([[[[arrayItems valueForKey:@"sub"] objectAtIndex:0] valueForKey:@"paymentMethod"] intValue]==3)
        {
            
            totalSwish=totalSwish+[[arrayItems valueForKey:@"tprice"] floatValue];
            totalSwishPaymetCount=totalSwishPaymetCount+1;
        }
        else if ([[[[arrayItems valueForKey:@"sub"] objectAtIndex:0] valueForKey:@"paymentMethod"] intValue]==4)
        {
            
            totalOther=totalOther+[[arrayItems valueForKey:@"tprice"] floatValue];
            totalOtherPaymetCount=totalOtherPaymetCount+1;
        }

    
        }

    }
    
    zcashPayment=[NSString stringWithFormat:@"%0.2f",totalCash];
    zcardPayment=[NSString stringWithFormat:@"%0.2f",totalCard];
    zswishPayment=[NSString stringWithFormat:@"%0.2f",totalSwish];
    zotherPayment=[NSString stringWithFormat:@"%0.2f",totalOther];
    ztotalCashPayments=[NSString stringWithFormat:@"%.0f",totalCashPaymetCount];
    ztotalCardPayments=[NSString stringWithFormat:@"%.0f",totalCardPaymetCount];
    ztotalSwishPayments=[NSString stringWithFormat:@"%.0f",totalSwishPaymetCount];
    ztotalOtherPayments=[NSString stringWithFormat:@"%.0f",totalOtherPaymetCount];
    
}


@end
