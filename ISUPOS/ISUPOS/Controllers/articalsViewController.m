//
//  articalsViewController.m
//  ISUPOS
//
//  Created by Rohit Mahajan on 4/15/15.
//  Copyright (c) 2015 Impinge Solutions. All rights reserved.
//

#import "articalsViewController.h"
#import "SidePanelViewController.h"
#import "CustomCellArticlestable.h"
#import "CustomTableViewCell.h"
#import "articlepopupViewController.h"
#import "quickBlocksButtonsView.h"
#import "helo&supportViewController.h"
#import "generalSettingViewController.h"
#import "thankyouViewController.h"
#import "paymentViewController.h"

#import "customAmountViewController.h"
#import "customDiscountViewController.h"
#include "language.h"
#import "LogViewController.h"
#import "CommonMethods.h"

@interface articalsViewController ()
{
    IBOutlet UIButton *buttonClear, *buttonCharge,*percetbutton;
    IBOutlet UIButton *namebutton,*discriptionButton,*numberButton;
    IBOutlet UITableView *tableViewSidePanel,*tablearticle;
    float matchedprice;
    NSString *currencySign;
    NSMutableArray *arrayProductImage, *arrayProductName, *arrayProductQuantity, *arrayProductPrice,*arrayProductVat, *Arraycheckedbox,*arrayProductID,*arrayProductDiscount,*arrayProductdiscountType;
    
    IBOutlet UIView *filterview;
    NSString *filter;
    BOOL filterdone;
    UIView *moreButtonView;
    NSMutableArray *morebuttons;
    UIButton *morebutton;
    UIPopoverController *popover;
    
    NSMutableArray *articleName,*articleId,*articleVat,*articlePrice,*articleImage,*articleBarImage,*articleDiscription,*articlevariant, *articleBarcode;
    NSMutableArray *farticleName,*farticleId,*farticleVat,*farticlePrice,*farticleImage,*farticleBarImage,*farticleDiscription,*farticlevariant,*farticleBarcode;
    
    float total,totalvat,PriceWithoutVat;
    IBOutlet  UILabel *totalPriceLbl,*totalVatLbl;
    
    NSString *str_totalAmount;
    
    NSString *text_string;
    
    NSMutableArray *popArticleid,*popArticlename;
    NSMutableArray *VatVarient;
    NSMutableArray *VatAmount;
    float totalvatnew;
    
    IBOutlet UIView *view_ManualPriceEntry;
    IBOutlet UILabel *lbl_PriceTitle;
    IBOutlet UITextField *txt_Price;
    IBOutlet UIButton *btn_Ok,*btn_Cancel;
    
}

@property (strong, nonatomic)IBOutlet UITableView *tableViewSidePanel;
@property (strong, nonatomic)IBOutlet UITableView *aticleTable;
-(IBAction)name_filter_btn:(id)sender;
-(IBAction)discription_filter_btn:(id)sender;
-(IBAction)number_filter_btn:(id)sender;
-(IBAction)filter_btn_click:(id)sender;
@end

@implementation articalsViewController
@synthesize tableViewSidePanel;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.customBtn.hidden = YES;
    
    str_totalAmount=@"0";
    
    // Splunk Mint Breadcrumb added
    [[Mint sharedInstance] leaveBreadcrumb:@"ArticlesViewController_ViewController"];
    
    filter=@"name";
    filterview.hidden=YES;
    // Do any additional setup after loading the view.
   
    view_ManualPriceEntry.hidden = YES;
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 0.5; //seconds
    lpgr.delegate = self;
    [_aticleTable addGestureRecognizer:lpgr];
    
    
    UIButton *calculator = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIImage *calculatorBtnImage = [UIImage imageNamed:@"CalculatorIcon.png"];
    
    [calculator setBackgroundImage:calculatorBtnImage forState:UIControlStateNormal];
    
    calculator.frame = CGRectMake(0, 0, 25, 33);
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:calculator] ;
    
    //self.navigationItem.rightBarButtonItem = backButton;
    
    
    //    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //
    //    SidePanelViewController *sidePanelVC = [story instantiateViewControllerWithIdentifier:@"sidepanel"];
    //
    //    sidePanelVC.view.frame = CGRectMake(690, 0, 334, 768);
    //
    //    [self.view addSubview:sidePanelVC.view];
    
    //    arrayProductImage = [[NSMutableArray alloc] initWithObjects:@"2.jpg", @"1.jpg", nil];
    //
    //    arrayProductName = [[NSMutableArray alloc] initWithObjects:@"Chocolate Truffle", @"Dairy Milk", nil];
    //
    //    arrayProductQuantity = [[NSMutableArray alloc] initWithObjects:@"2", @"2", nil];
    //
    //    arrayProductPrice = [[NSMutableArray alloc] initWithObjects:@"€ 42.40", @"€ 42.40", nil];
    Arraycheckedbox=[[NSMutableArray alloc]init];
    
    
    
    for (UIView *view in self.navigationController.navigationBar.subviews )
    {
        if (view.tag == -1)
        {
            [view removeFromSuperview];
        }
        
    }
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    
    UILabel *lbl_manReg_ID = [[UILabel alloc]initWithFrame:CGRectMake(465, 22, 200, 30)];
    lbl_manReg_ID.tag = -1;
   // lbl_manReg_ID.text = [defaults objectForKey:@"INFRASEC_PASSWORD"];
    lbl_manReg_ID.text = [defaults objectForKey:@"POS_ID"];
    lbl_manReg_ID.textColor = [UIColor whiteColor];
    lbl_manReg_ID.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:11];
    
//    [self.navigationController.navigationBar addSubview:lbl_manReg_ID];
    
    NSDictionary *dictRoot = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Product_Details" ofType:@"plist"]];
//    manufacturer_BarButton.title = [dictRoot valueForKey:@"Manufacturer"];
    
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
//    lbl_LeftBarItem.text = [NSString stringWithFormat:@"%@ %@ Ver: %@", string1, string2, [dictRoot valueForKey:@"Version"]];
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
    
//    btnproduct_code.title = [NSString stringWithFormat:@"Product: %@ %@ %@", string1, string2, [dictRoot valueForKey:@"Version"]];
    
    
}
-(void)Settitles
{
    self.title=[Language get:@"Articles" alter:@"!Articles"];
    [buttonClear setTitle:[Language get:@"Clear" alter:@"!Clear"] forState:UIControlStateNormal];
    [buttonCharge setTitle:[Language get:@"Charge" alter:@"!Charge"] forState:UIControlStateNormal];
    scrv.placeholder=[Language get:@"Search Article" alter:@"!Search Article"];
    
    Namelbl.text=[Language get:@"Name" alter:@"!Name"];
    Numberlbl.text=[Language get:@"Article Number" alter:@"!Article Number"];
    Vatlbl.text=[Language get:@"VAT" alter:@"!VAT"];
    Barcodelbl.text=[Language get:@"Barcode" alter:@"!Barcode"];
    Pricelbl.text=[Language get:@"Price" alter:@"!Price"];
    [Addbtn setTitle:[Language get:@"Add" alter:@"!Add"] forState:UIControlStateNormal];
    [art_custom_cancelBtn setTitle:[Language get:@"Cancel" alter:@"!Cancel"] forState:UIControlStateNormal];
    [add_custom__addBtn setTitle:[Language get:@"Add" alter:@"!Add"] forState:UIControlStateNormal];


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
    NSString *localPortName = [NSString stringWithString: text_string];
    [articalsViewController setPortName:localPortName];
    
    NSString *localPortSettings = @"mini";
    
    [articalsViewController setPortSettings:localPortSettings];
}



- (void) viewWillAppear:(BOOL)animated
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
    [super viewWillAppear:animated];
    totalPriceLbl.text=[NSString stringWithFormat:@"00000.00"];
    totalVatLbl.text=[NSString stringWithFormat:@"Including %@ 00.00 VAT",currencySign];
    [self add_button_on_tabbar];
    [self getAllArticle];
    [self getCartData];
    self.navigationController.navigationBarHidden = NO;
    
    
    totalVatLbl.backgroundColor = [UIColor clearColor];
   
    
//    NSManagedObject *newContact;
//    newContact = [NSEntityDescription insertNewObjectForEntityForName:@"Log" inManagedObjectContext:context];
//    
//    [newContact setValue:[NSDate date] forKey:@"date"];
//    [newContact setValue:[Language get:@"Articles" alter:@"!Articles"] forKey:@"discription"];
//    [newContact setValue:@"" forKey:@"sno"];
//    
//    [context save:&error];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [morebutton removeFromSuperview];
    [moreButtonView removeFromSuperview];
    moreButtonView=nil;
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITableView Datasource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView.tag==110)
    {
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context =[appDelegate managedObjectContext];
        
        NSEntityDescription *entityDesc2 =[NSEntityDescription entityForName:@"CustomDiscount" inManagedObjectContext:context];
        NSFetchRequest *request11 = [[NSFetchRequest alloc] init];
        [request11 setEntity:entityDesc2];
        NSPredicate *predicate;
        predicate = [NSPredicate predicateWithFormat:@"(id = %@)",@"1S"];
        [request11 setPredicate:predicate];
        NSError *error;
        NSArray *objects2 = [context executeFetchRequest:request11 error:&error];
        if(objects2.count==0)
        {
            
            return arrayProductName.count;
        }
        else
        {
            return arrayProductName.count+1;
        }
        
    }
    else
        if(filterdone)
            return farticleId.count;
        else
            return articleId.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.tag==110)
    {
        static NSString *CellIdentifier = @"Cell";
        
        CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            cell = [[CustomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.backgroundColor=[UIColor lightGrayColor];
        imgView.frame = CGRectMake(0, 84, 334, 1);
        [cell.contentView addSubview:imgView];
        
        cell.backgroundColor = [UIColor clearColor];
        
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
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
            if(indexPath.row==arrayProductName.count)
            {
                NSManagedObject *person = (NSManagedObject *)[objects2 objectAtIndex:0];
                
                cell.imageViewProduct.image = [UIImage imageNamed:@"coupon-512.png"];
                cell.labelProductName.text =[person valueForKey:@"discription"];
                cell.labelProductQuantity.text=@"";
                cell.buttonIncrease.hidden=YES;
                cell.buttonDecrease.hidden=YES;
                if([[person valueForKey:@"type"] isEqualToString:currencySign])
                {
                    cell.labelProductPrice.text=[NSString stringWithFormat:@"%.02f",[[person valueForKey:@"discount"] floatValue]];
                }
                else
                {
                    cell.labelProductPrice.text=[NSString stringWithFormat:@"%.02f",((total*[[person valueForKey:@"discount"] floatValue])/100)];
                }
                
                //totalPriceLbl.text=[NSString stringWithFormat:@"%@%0.2f",currencySign,total-[cell.labelProductPrice.text floatValue]];
                
                float cc;
                if([[person valueForKey:@"type"] isEqualToString:currencySign])
                {
                    cell.labelProductPrice.text=[NSString stringWithFormat:@"%.02f",[[person valueForKey:@"discount"] floatValue]];
                    cc=[[person valueForKey:@"discount"] floatValue];
                    
//                    totalVatLbl.text=[NSString stringWithFormat:@"%@ %@ %.02f %@",[Language get:@"Including" alter:@"!Including"],currencySign,totalvat-[[person valueForKey:@"discount"] floatValue], [Language get:@"VAT" alter:@"!VAT"]];
                    
                    

                    
                }
                else
                {
                    cell.labelProductPrice.text=[NSString stringWithFormat:@"%.02f",((total*[[person valueForKey:@"discount"] floatValue])/100)];
                    cc=((total*[[person valueForKey:@"discount"] floatValue])/100);
//                    totalVatLbl.text=[NSString stringWithFormat:@"%@ %@ %.02f %@",[Language get:@"Including" alter:@"!Including"],currencySign,totalvat-((totalvat*[[person valueForKey:@"discount"] floatValue])/100), [Language get:@"VAT" alter:@"!VAT"]];
//                    
                 
                }
                
                
                float price = 0;
                
                if(total-cc<0)
                {
                    totalPriceLbl.text=[NSString stringWithFormat:@"-%@ %0.2f",currencySign,fabsf(total-cc)];
                    
                    price = fabsf(total-cc);
                    
                    
                    
                }
                else
                {
                    totalPriceLbl.text=[NSString stringWithFormat:@"%@ %0.2f",currencySign,total-cc];
                    
                    price = total-cc;
                    
                }
                
                
                
                
                float vatPercent = totalvat*100/PriceWithoutVat;
                float final = price - (price/(1+vatPercent/100));
                
                
                
                if (final==0.00) {
                    totalVatLbl.text=[NSString stringWithFormat:@"%@",[Language get:@"Including VAT" alter:@"!Including VAT"]];
                }
                
                totalVatLbl.text=[NSString stringWithFormat:@"%@ %@ %.02f %@",[Language get:@"Including" alter:@"!Including"],currencySign,final, [Language get:@"VAT" alter:@"!VAT"]];
                
                
                cell.labelProductPrice.text=[NSString stringWithFormat:@"- %@%@",currencySign,cell.labelProductPrice.text];          //totalPriceLbl.text=[NSString stringWithFormat:@"€%0.2f",total-[cell.labelProductPrice.text floatValue]];
            }
            else
            {
                cell.imageViewProduct.image = [arrayProductImage objectAtIndex:indexPath.row];
                
                cell.labelProductName.text = [arrayProductName objectAtIndex:indexPath.row];
                
                
                
                cell.labelProductPrice.text = [NSString stringWithFormat:@"%@ %.2f",currencySign,([[arrayProductPrice objectAtIndex:indexPath.row] floatValue]- [[arrayProductDiscount objectAtIndex:indexPath.row]floatValue])*[[arrayProductQuantity objectAtIndex:indexPath.row] intValue]];
                
                cell.buttonIncrease.tag=indexPath.row;
                cell.buttonDecrease.tag=indexPath.row;
                [cell.buttonIncrease addTarget:self action:@selector(IncreaseAction:) forControlEvents:UIControlEventTouchUpInside];
                [cell.buttonDecrease addTarget:self action:@selector(decreaseAction:) forControlEvents:UIControlEventTouchUpInside];
                if([UIImagePNGRepresentation(arrayProductImage[indexPath.row]) isEqualToData: UIImagePNGRepresentation([UIImage imageNamed:@"ca.png"])])
                {
                    cell.labelProductQuantity.text =@"";
                    cell.buttonIncrease.hidden=YES;
                    cell.buttonDecrease.hidden=YES;
                }
                else
                {
                    cell.labelProductQuantity.text = [NSString stringWithFormat:@"%@",[arrayProductQuantity objectAtIndex:indexPath.row]];
                    cell.buttonIncrease.hidden=NO;
                    cell.buttonDecrease.hidden=NO;
                }
                
                
            }
        }
        else
        {
            
            cell.imageViewProduct.image = [arrayProductImage objectAtIndex:indexPath.row];
            
            cell.labelProductName.text = [arrayProductName objectAtIndex:indexPath.row];
            
            
//            cell.labelProductPrice.text = [NSString stringWithFormat:@"%@ %.2f",currencySign,([[arrayProductPrice objectAtIndex:indexPath.row] floatValue]- [[arrayProductDiscount objectAtIndex:indexPath.row]floatValue])*[[arrayProductQuantity objectAtIndex:indexPath.row] intValue]];
            float discountperproduct;
            
            
            if([[arrayProductdiscountType objectAtIndex:indexPath.row] isEqualToString:@"%"])
            {
                discountperproduct=([[arrayProductPrice objectAtIndex:indexPath.row] floatValue]*[[arrayProductQuantity objectAtIndex:indexPath.row] intValue]*[[arrayProductDiscount objectAtIndex:indexPath.row]floatValue])/100;
            }
            else
            {
                discountperproduct=[[arrayProductDiscount objectAtIndex:indexPath.row]floatValue];
            }
            
            
            cell.labelProductPrice.text = [NSString stringWithFormat:@"%@ %.2f",currencySign,[[arrayProductPrice objectAtIndex:indexPath.row] floatValue]*[[arrayProductQuantity objectAtIndex:indexPath.row] intValue]- discountperproduct];
            
            cell.buttonIncrease.tag=indexPath.row;
            cell.buttonDecrease.tag=indexPath.row;
            [cell.buttonIncrease addTarget:self action:@selector(IncreaseAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.buttonDecrease addTarget:self action:@selector(decreaseAction:) forControlEvents:UIControlEventTouchUpInside];
            if([UIImagePNGRepresentation(arrayProductImage[indexPath.row]) isEqualToData: UIImagePNGRepresentation([UIImage imageNamed:@"ca.png"])])
            {
                cell.buttonIncrease.hidden=YES;
                cell.buttonDecrease.hidden=YES;
                cell.labelProductQuantity.text = @"";
            }
            else
            {
                cell.labelProductQuantity.text = [NSString stringWithFormat:@"%@",[arrayProductQuantity objectAtIndex:indexPath.row]];
                cell.buttonIncrease.hidden=NO;
                cell.buttonDecrease.hidden=NO;
            }
            
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
        
    }
    else
    {
        static NSString *simpleTableIdentifier = @"Articlestablecell";
        
        CustomCellArticlestable *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if (cell == nil) {
            cell = [[CustomCellArticlestable alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
            
        }
        
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.backgroundColor=[UIColor lightGrayColor];
        imgView.frame = CGRectMake(0, 47, 655, 1);
        [cell.contentView addSubview:imgView];
        
       
        if(filterdone)
        {
            cell.labelProductName.text= farticleName[indexPath.row];
            //cell.barcodeImage.image= articleName[indexPath.row];
            cell.label_Barcode.text= [farticleBarcode objectAtIndex:indexPath.row];
            cell.labelProductNumber.text= farticleId[indexPath.row];
            cell.labelVat.text=[NSString stringWithFormat:@"%d%@",[farticleVat[indexPath.row] intValue],@"%"];
            cell.labelPrice.text= [NSString stringWithFormat:@"%@ %.2f",currencySign,[farticlePrice[indexPath.row] floatValue]];
            if([farticlevariant[indexPath.row] isEqualToString:@"y"])
                cell.labelvariant.text=@"(Variant)";
            else
                cell.labelvariant.text=@"";
            
            [cell.checkboxImage addTarget:self action:@selector(changeimage:) forControlEvents:UIControlEventTouchUpInside];
            cell.checkboxImage.tag=indexPath.row;
            
            if (![Arraycheckedbox containsObject:[NSString stringWithFormat:@"%d",(int)indexPath.row]]) {
                [cell.checkboxImage setImage:[UIImage imageNamed:@"Check-box.png"] forState:UIControlStateNormal];
            }
            else
            {
                [cell.checkboxImage setImage:[UIImage imageNamed:@"Tick-ico.png"] forState:UIControlStateNormal];
            }
            
        }
        else
        {
            cell.labelProductName.text= articleName[indexPath.row];
            cell.label_Barcode.text= [articleBarcode objectAtIndex:indexPath.row];
            if([articlevariant[indexPath.row] isEqualToString:@"y"])
            cell.labelvariant.text=@"(Variant)";
            else
                cell.labelvariant.text=@"";
            //cell.barcodeImage.image= articleName[indexPath.row];
            cell.labelProductNumber.text= articleId[indexPath.row];
            cell.labelVat.text=[NSString stringWithFormat:@"%.2f%@",[articleVat[indexPath.row] floatValue],@"%"];
            cell.labelPrice.text= [NSString stringWithFormat:@"%@ %.2f",currencySign,[articlePrice[indexPath.row] floatValue]];
            
            
            [cell.checkboxImage addTarget:self action:@selector(changeimage:) forControlEvents:UIControlEventTouchUpInside];
            cell.checkboxImage.tag=indexPath.row;
            
            if (![Arraycheckedbox containsObject:[NSString stringWithFormat:@"%d",(int)indexPath.row]]) {
                [cell.checkboxImage setImage:[UIImage imageNamed:@"Check-box.png"] forState:UIControlStateNormal];
            }
            else
            {
                [cell.checkboxImage setImage:[UIImage imageNamed:@"Tick-ico.png"] forState:UIControlStateNormal];
                
            }
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.tag==110)
    {
        return 85;
        
    }
    else
        return 48;
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
#pragma mark - IBActions


-(IBAction)chargeamount_btn:(id)sender
{
    BOOL bool_ValidPrice = NO;
    
    for (int i=0; i<[arrayProductPrice count]; i++)
    {
        if ([[arrayProductPrice objectAtIndex:i]floatValue]<=0)
        {
            //shpw popup;
            bool_ValidPrice = NO;
            [self showManualPriceEntryPopUp:i];
            break;
        }
        
        bool_ValidPrice = YES;
        
    }
    
    if (bool_ValidPrice)
    {
        
        miniPrinterFunctions = [[MiniPrinterFunctions alloc] init];
        
        text_string = @"BT:PRNT Star";
        
        [self setPortInfo];
        NSString *portName = [AppDelegate getPortName];
        NSString *portSettings = [AppDelegate getPortSettings];
        [MiniPrinterFunctions CheckStatusWithPortname:portName portSettings:portSettings sensorSetting:SensorActiveHigh];
        
        
        //    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"PrinterStatus"] isEqualToString:@"Online"]) {
        
        
        //    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"INFRASEC_PASSWORD"]) {
        
        
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context =[appDelegate managedObjectContext];
        NSEntityDescription *entityDesc =[NSEntityDescription entityForName:@"Cart" inManagedObjectContext:context];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entityDesc];
        NSError *error;
        NSArray *objects = [context executeFetchRequest:request error:&error];
        
        if(objects.count>0)
        {
            
            
            if([currencySign  isEqual: @"$"])
            {
                totalamount=[[totalPriceLbl.text substringFromIndex:1] floatValue];
                
            }
            else
                
            {
                totalamount=[[totalPriceLbl.text substringFromIndex:3] floatValue];
                
            }
            
            paymentViewController *viewControllerForPopover = [self.storyboard instantiateViewControllerWithIdentifier:@"paymentViewController"];
            viewControllerForPopover.vat_Amount=VatAmount;
            viewControllerForPopover.vat_Variant=VatVarient;
            viewControllerForPopover.str_QuickBlockName = @"";
            viewControllerForPopover.str_PurchaseAmount=[NSString stringWithFormat:@"%.02f",totalvat];
            popover = [[UIPopoverController alloc] initWithContentViewController:viewControllerForPopover];
            [popover setPopoverContentSize:CGSizeMake(567, 564)];
            CGRect rect = CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/2, 1, 1);
            [popover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:0 animated:YES];
            
            viewControllerForPopover.callBack = self;
        }
        
        //    }
        //    else
        //    {
        //        [[[UIAlertView alloc] initWithTitle:@"ISUPOS" message:[Language get:@"The receipt CTU server is not accepting the receipt" alter:@"!The receipt CTU server is not accepting the receipt"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        //
        //    }
        
        //    }
        //    else
        //    {
        //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ISUPOS" message:@"Printer not connected." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        //        [alert show];
        //    }
    }
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    if (alertView.tag==11)
    {
        if(buttonIndex==0)
        {
            [self saveDataAfterpayment];
        }
        else if(buttonIndex==1)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ISUPOS" message:[Language get:@"Card payment method not available." alter:@"!Card payment method not available."] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ISUPOS" message:[Language get:@"Payment cancelled." alter:@"!Payment cancelled."] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
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
    else if (alertView.tag==3)
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
    
}

-(void)saveDataAfterpayment
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context =[appDelegate managedObjectContext];
    
    NSEntityDescription *entityDesc =[NSEntityDescription entityForName:@"Cart" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    

    NSEntityDescription *entityDes =[NSEntityDescription entityForName:@"Trasections" inManagedObjectContext:context];
    NSFetchRequest *reques = [[NSFetchRequest alloc] init];
    [reques setEntity:entityDes];
    NSArray *object = [context executeFetchRequest:reques error:&error];
    NSManagedObject *perso = (NSManagedObject *)[object lastObject];
    int x=[[perso valueForKey:@"id"] intValue]+1;
    
    for(int i=0;i<objects.count;i++)
    {
        NSManagedObject *person = (NSManagedObject *)[objects objectAtIndex:i];
        NSManagedObject *newContact;
        newContact = [NSEntityDescription insertNewObjectForEntityForName:@"Trasections" inManagedObjectContext:context];
        
        
        [newContact setValue:[NSNumber numberWithFloat:[[person valueForKey:@"vat" ] floatValue]] forKey:@"vat"];
        [newContact setValue:[NSNumber numberWithFloat:[[person valueForKey:@"price" ] floatValue]] forKey:@"price"];
        [newContact setValue:[person valueForKey:@"name" ] forKey:@"name"];
        [newContact setValue:[NSNumber numberWithInt:[[person valueForKey:@"count"] intValue]] forKey:@"count"];
        [newContact setValue:[person valueForKey:@"article_id" ] forKey:@"article_id"];
        [newContact setValue:[person valueForKey:@"discount"] forKey:@"discount"];
        [newContact setValue:[person valueForKey:@"image"] forKey:@"image"];
        [newContact setValue:[NSDate date] forKey:@"date"];
        [newContact setValue:[NSNumber numberWithInt:x] forKey:@"id"];
//        [newContact setValue:currencySign forKey:@"currency"];
        
        
        NSEntityDescription *entityDesc1111 =[NSEntityDescription entityForName:@"Article" inManagedObjectContext:context];
        NSFetchRequest *request11111 = [[NSFetchRequest alloc] init];
        [request11111 setEntity:entityDesc1111];
        NSPredicate *pred =[NSPredicate predicateWithFormat:@"(article_no = %@)",[person valueForKey:@"article_id"]];
        [request11111 setPredicate:pred];
        NSArray *objects1 = [context executeFetchRequest:request11111 error:&error];
        NSManagedObject *matches = nil;
        if ([objects1 count] == 0) {
        }
        else
        {
            matches = [objects1 objectAtIndex:0];
            [newContact setValue:[matches valueForKey:@"barc_img_url"] forKey:@"bar_img_url"];
            [newContact setValue:[matches valueForKey:@"article_description"] forKey:@"discription"];
        }
        
        [context save:&error];
        
    }
    [self clearCart:0];
    //    thankyouViewController *viewControllerForPopover = [self.storyboard instantiateViewControllerWithIdentifier:@"thankyouViewController"];
    //
    //    popover = [[UIPopoverController alloc] initWithContentViewController:viewControllerForPopover];
    //
    //    [popover setPopoverContentSize:CGSizeMake(587, 464)];
    //
    //    CGRect rect = CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/2, 1, 1);
    //
    //    [popover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:0 animated:YES];
    //
    //    viewControllerForPopover.callBack = self;
}


- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController
{
    return NO;
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

    
    
    [popover dismissPopoverAnimated:YES];
    [self getAllArticle];
    [self getCartData];
    [self Settitles];
    if(paymentdone)
    {
        thankyouViewController *viewControllerForPopover = [self.storyboard instantiateViewControllerWithIdentifier:@"thankyouViewController"];
        
        popover = [[UIPopoverController alloc] initWithContentViewController:viewControllerForPopover];
        
        [popover setPopoverContentSize:CGSizeMake(587, 464)];
        
        CGRect rect = CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/2, 1, 1);
        
        [popover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:0 animated:YES];
        
        viewControllerForPopover.callBack = self;
        popover.delegate=self;
        
        paymentdone=NO;
    }
    
}
-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    CGPoint p = [gestureRecognizer locationInView:_aticleTable];
    
    NSIndexPath *indexPath = [_aticleTable indexPathForRowAtPoint:p];
    if (indexPath == nil) {
        NSLog(@"long press on table view but not on a row");
    } else if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        NSLog(@"long press on table view at row %d", (int)indexPath.row);
        
        
        NSArray* foo = [articleId[indexPath.row] componentsSeparatedByString: @"_"];
        if(foo.count>0)
            pressedArticleindex = [foo objectAtIndex: 0];
        else
            pressedArticleindex = articleId[indexPath.row];
        
        
        //pressedArticleindex=articleId[indexPath.row];
        articlepopupViewController *viewControllerForPopover = [self.storyboard instantiateViewControllerWithIdentifier:@"articlepopupView"];
        
        
        popover = [[UIPopoverController alloc] initWithContentViewController:viewControllerForPopover];
        [popover setPopoverContentSize:CGSizeMake(587, 641)];
        CGRect rect = CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/2, 1, 1);
        [popover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:0 animated:YES];
        viewControllerForPopover.callBack = self;
        popover.delegate=self;
        
    } else {
        // NSLog(@"gestureRecognizer.state = %d", gestureRecognizer.state);
    }
}
- (void)changeimage:(UIButton*)button
{

    if (![Arraycheckedbox containsObject:[NSString stringWithFormat:@"%d",(int)button.tag]])
    {
        [Arraycheckedbox addObject:[NSString stringWithFormat:@"%d",(int)button.tag]];
    }
    else
    {
        [Arraycheckedbox removeObject:[NSString stringWithFormat:@"%d",(int)button.tag]];
    }
    [_aticleTable reloadData];
    
}
- (void)aMethod:(UIButton*)button
{
    
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"CompanyId"])
    {
        if(moreButtonView==nil||button.tag==999)
        {
            //,[Language get:@"Printers" alter:@"!Printers"]
            [moreButtonView removeFromSuperview];
            
            
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
            [self.tabBarController setSelectedIndex:4];
            
        }
        else if (button.tag==4)
        {
            [moreButtonView removeFromSuperview];
            klm=4;
            [self.tabBarController setSelectedIndex:4];
            
        }
        else if (button.tag==5)
        {
            [moreButtonView removeFromSuperview];
            klm=5;
            [self.tabBarController setSelectedIndex:4];
            
        }
        else if (button.tag==6)
        {
            [moreButtonView removeFromSuperview];
            klm=6;
            [self.tabBarController setSelectedIndex:4];
            
        }
        else if (button.tag==7)
        {
            [moreButtonView removeFromSuperview];
            klm=8;
            helo_supportViewController *viewControllerForPopover = [self.storyboard instantiateViewControllerWithIdentifier:@"helo&supportView"];
            popover = [[UIPopoverController alloc] initWithContentViewController:viewControllerForPopover];
            [popover setPopoverContentSize:CGSizeMake(567,480)];
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
//        else if (button.tag==10){
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
                
                int y=75+70;
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
            [self.tabBarController setSelectedIndex:4];
            
        }
        else if (button.tag==4)
        {
            [moreButtonView removeFromSuperview];
            klm=4;
            [self.tabBarController setSelectedIndex:4];
            
        }
        else if (button.tag==5)
        {
            [moreButtonView removeFromSuperview];
            klm=5;
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
//            
//            
//            LogViewController *logViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LogViewController"];
//            [self.navigationController presentViewController:logViewController animated:NO completion:nil];
//        }
        
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

-(IBAction)addToCartBtn:(id)sender
{
    popArticleid=[NSMutableArray new];
    popArticlename=[NSMutableArray new];
    
    NSString *articleidd;
 
    if(filterdone)
    {
        for(int i=0;i<farticleId.count;i++)
        {
            if ([Arraycheckedbox containsObject:[NSString stringWithFormat:@"%d",i]])
            {
                NSArray* foo = [farticleId[i] componentsSeparatedByString: @"_"];
                if(foo.count>0)
                    articleidd = [foo objectAtIndex: 0];
                else
                    articleidd = farticleId[i];
                
                
                
                AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
                NSManagedObjectContext *context =[appDelegate managedObjectContext];
                
                NSError *error;
                NSEntityDescription *entityDesc2 =[NSEntityDescription entityForName:@"Article" inManagedObjectContext:context];
                NSFetchRequest *requestt = [[NSFetchRequest alloc] init];
                [requestt setEntity:entityDesc2];
                NSPredicate *predicate1;
                predicate1 = [NSPredicate predicateWithFormat:@"(article_no = %@)",articleidd];
                [requestt setPredicate:predicate1];
                NSArray *objects = [context executeFetchRequest:requestt error:&error];
                NSManagedObject *matches = [objects objectAtIndex:0];
                
                NSEntityDescription *entityDesc1 =[NSEntityDescription entityForName:@"Cart" inManagedObjectContext:context];
                NSFetchRequest *request11 = [[NSFetchRequest alloc] init];
                [request11 setEntity:entityDesc1];
                
                NSMutableArray *predicatesArray=[[NSMutableArray alloc]init];
                
                NSPredicate *predicate;
                predicate = [NSPredicate predicateWithFormat:@"(article_id = %@)",articleidd];
                [predicatesArray addObject:predicate];
                
                predicate = [NSPredicate predicateWithFormat:@"(name = %@)",farticleName[i]];
                [predicatesArray addObject:predicate];
                
                if([predicatesArray count]){
                    NSPredicate * finalPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicatesArray];
                    [request11 setPredicate:finalPredicate];
                }
                NSArray *objects11 = [context executeFetchRequest:request11 error:&error];
                
                
                if ([objects11 count] == 0) {
                    
                    if([[matches valueForKey:@"unit_type" ]integerValue]==1)
                    {
                        
                        
                        [popArticleid addObject:articleidd];
                        [popArticlename addObject:farticleName[i]];
                        
                        
                    }
                    else
                    {
                        
                        
                        
                        NSEntityDescription *entityDesc =[NSEntityDescription entityForName:@"Article" inManagedObjectContext:context];
                        NSFetchRequest *request = [[NSFetchRequest alloc] init];
                        [request setEntity:entityDesc];
                        
                        
                        NSPredicate *predicate;
                        predicate = [NSPredicate predicateWithFormat:@"(article_no = %@)",articleidd];
                        
                        
                        
                        [request setPredicate:predicate];
                        
                        
                        
                        NSArray *objects = [context executeFetchRequest:request error:&error];
                        
                        NSManagedObject *matches = nil;
                        if ([objects count] == 0) {
                            
                        }
                        else
                        {
                            matches = [objects objectAtIndex:0];
                            NSManagedObject *newContact;
                            newContact = [NSEntityDescription insertNewObjectForEntityForName:@"Cart" inManagedObjectContext:context];
                            [newContact setValue:[NSNumber numberWithFloat:[[matches valueForKey:@"vat" ] floatValue]] forKey:@"vat"];
                            [newContact setValue:[NSNumber numberWithFloat:[[matches valueForKey:@"price" ] floatValue]] forKey:@"price"];
                            [newContact setValue:farticleName[i] forKey:@"name"];
                            [newContact setValue:farticleBarcode[i] forKey:@"barcode"];
                            [newContact setValue:[matches valueForKey:@"article_img_url"] forKey:@"image"];
                            [newContact setValue:[NSNumber numberWithInt:[[matches valueForKey:@"discount"] floatValue]] forKey:@"discount"];
                            //                        [newContact setValue:[matches valueForKey:@"discount"] forKey:@"discount"];
                            
                            [newContact setValue:[NSNumber numberWithInt:1] forKey:@"count"];
                            [newContact setValue:articleidd forKey:@"article_id"];
                            
                            NSEntityDescription *entityDesc2 =[NSEntityDescription entityForName:@"Variant" inManagedObjectContext:context];
                            NSFetchRequest *request11 = [[NSFetchRequest alloc] init];
                            [request11 setEntity:entityDesc2];
                            
                            NSMutableArray *predicatesArray=[[NSMutableArray alloc]init];
                            NSPredicate *predicate;
                            predicate = [NSPredicate predicateWithFormat:@"(article_id = %@)",articleidd];
                            [predicatesArray addObject:predicate];
                            predicate = [NSPredicate predicateWithFormat:@"(name = %@)",farticleName[i]];
                            [predicatesArray addObject:predicate];
                            if([predicatesArray count]){
                                NSPredicate * finalPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicatesArray];
                                [request11 setPredicate:finalPredicate];
                            }
                            NSError *error;
                            NSArray *objects2 = [context executeFetchRequest:request11 error:&error];
                            NSManagedObject *matches1 = nil;
                            if(objects2.count>0)
                            {
                                matches1=[objects2 objectAtIndex:0];
                                [newContact setValue:[NSNumber numberWithFloat:[[matches1 valueForKey:@"price"] floatValue]] forKey:@"price"];
                                
                            }
                            
                            
                            
                            [context save:&error];
                        }
                    }
                    
                    
                }
                else
                {
                    if([[matches valueForKey:@"unit_type" ]integerValue]==1)
                    {
                        [popArticleid addObject:articleidd];
                        [popArticlename addObject:farticleName[i]];
                        
                        
                    }
                    else
                    {
                        
                        for (NSManagedObject *obj in objects11) {
                            [obj setValue:[NSNumber numberWithInt:[[objects11 valueForKey:@"count"][0] intValue]+1] forKey:@"count"];
                            [context save:&error];
                        }
                        
                    }
                    
                }
                
                
            }
        }
    }
    else
    {
        for(int i=0;i<articleId.count;i++)
        {
            if ([Arraycheckedbox containsObject:[NSString stringWithFormat:@"%d",i]])
            {
                NSArray* foo = [articleId[i] componentsSeparatedByString: @"_"];
                if(foo.count>0)
                    articleidd = [foo objectAtIndex: 0];
                else
                    articleidd = articleId[i];
                
                
                
                AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
                NSManagedObjectContext *context =[appDelegate managedObjectContext];
                
                NSError *error;
                NSEntityDescription *entityDesc2 =[NSEntityDescription entityForName:@"Article" inManagedObjectContext:context];
                NSFetchRequest *requestt = [[NSFetchRequest alloc] init];
                [requestt setEntity:entityDesc2];
                NSPredicate *predicate1;
                predicate1 = [NSPredicate predicateWithFormat:@"(article_no = %@)",articleidd];
                [requestt setPredicate:predicate1];
                NSArray *objects = [context executeFetchRequest:requestt error:&error];
                NSManagedObject *matches = [objects objectAtIndex:0];
                
                NSEntityDescription *entityDesc1 =[NSEntityDescription entityForName:@"Cart" inManagedObjectContext:context];
                NSFetchRequest *request11 = [[NSFetchRequest alloc] init];
                [request11 setEntity:entityDesc1];
                
                NSMutableArray *predicatesArray=[[NSMutableArray alloc]init];
                
                NSPredicate *predicate;
                predicate = [NSPredicate predicateWithFormat:@"(article_id = %@)",articleidd];
                [predicatesArray addObject:predicate];
                
                predicate = [NSPredicate predicateWithFormat:@"(name = %@)",articleName[i]];
                [predicatesArray addObject:predicate];
                
                if([predicatesArray count]){
                    NSPredicate * finalPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicatesArray];
                    [request11 setPredicate:finalPredicate];
                }
                NSArray *objects11 = [context executeFetchRequest:request11 error:&error];
                
                
                if ([objects11 count] == 0) {
                    
                    if([[matches valueForKey:@"unit_type" ]integerValue]==1)
                    {
                        
                        
                        [popArticleid addObject:articleidd];
                        [popArticlename addObject:articleName[i]];
                        
                        
                    }
                    else
                    {
                        
                        
                        
                        NSEntityDescription *entityDesc =[NSEntityDescription entityForName:@"Article" inManagedObjectContext:context];
                        NSFetchRequest *request = [[NSFetchRequest alloc] init];
                        [request setEntity:entityDesc];
                        
                        
                        NSPredicate *predicate;
                        predicate = [NSPredicate predicateWithFormat:@"(article_no = %@)",articleidd];
                        
                        
                        
                        [request setPredicate:predicate];
                        
                        
                        
                        NSArray *objects = [context executeFetchRequest:request error:&error];
                        
                        NSManagedObject *matches = nil;
                        if ([objects count] == 0) {
                            
                        }
                        else
                        {
                            matches = [objects objectAtIndex:0];
                            NSManagedObject *newContact;
                            newContact = [NSEntityDescription insertNewObjectForEntityForName:@"Cart" inManagedObjectContext:context];
                            [newContact setValue:[NSNumber numberWithFloat:[[matches valueForKey:@"vat" ] floatValue]] forKey:@"vat"];
                            [newContact setValue:[NSNumber numberWithFloat:[[matches valueForKey:@"price" ] floatValue]] forKey:@"price"];
                            [newContact setValue:articleName[i] forKey:@"name"];
                            [newContact setValue:articleBarcode[i] forKey:@"barcode"];
                            [newContact setValue:[matches valueForKey:@"article_img_url"] forKey:@"image"];
                            [newContact setValue:[NSNumber numberWithInt:[[matches valueForKey:@"discount"] floatValue]] forKey:@"discount"];
                            //                        [newContact setValue:[matches valueForKey:@"discount"] forKey:@"discount"];
                            
                            [newContact setValue:[NSNumber numberWithInt:1] forKey:@"count"];
                            [newContact setValue:articleidd forKey:@"article_id"];
                            
                            NSEntityDescription *entityDesc2 =[NSEntityDescription entityForName:@"Variant" inManagedObjectContext:context];
                            NSFetchRequest *request11 = [[NSFetchRequest alloc] init];
                            [request11 setEntity:entityDesc2];
                            
                            NSMutableArray *predicatesArray=[[NSMutableArray alloc]init];
                            NSPredicate *predicate;
                            predicate = [NSPredicate predicateWithFormat:@"(article_id = %@)",articleidd];
                            [predicatesArray addObject:predicate];
                            predicate = [NSPredicate predicateWithFormat:@"(name = %@)",articleName[i]];
                            [predicatesArray addObject:predicate];
                            if([predicatesArray count]){
                                NSPredicate * finalPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicatesArray];
                                [request11 setPredicate:finalPredicate];
                            }
                            NSError *error;
                            NSArray *objects2 = [context executeFetchRequest:request11 error:&error];
                            NSManagedObject *matches1 = nil;
                            if(objects2.count>0)
                            {
                                matches1=[objects2 objectAtIndex:0];
                                [newContact setValue:[NSNumber numberWithFloat:[[matches1 valueForKey:@"price"] floatValue]] forKey:@"price"];
                                
                            }
                            
                            
                            
                            [context save:&error];
                        }
                    }
                    
                    
                }
                else
                {
                    if([[matches valueForKey:@"unit_type" ]integerValue]==1)
                    {
                        [popArticleid addObject:articleidd];
                        [popArticlename addObject:articleName[i]];
                        
                        
                    }
                    else
                    {
                        
                        for (NSManagedObject *obj in objects11) {
                            [obj setValue:[NSNumber numberWithInt:[[objects11 valueForKey:@"count"][0] intValue]+1] forKey:@"count"];
                            [context save:&error];
                        }
                        
                    }
                    
                }
                
                
            }
        }
    }
    
    
    [Arraycheckedbox removeAllObjects];
    [self getAllArticle];
    [self getCartData];
    [self showpopUp];
}

-(IBAction)name_filter_btn:(id)sender
{
    filter=@"name";
    [namebutton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [discriptionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [numberButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button_Barcode setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    filterview.hidden=YES;
}

-(IBAction)discription_filter_btn:(id)sender
{
    filter=@"discription";
    [namebutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [discriptionButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [numberButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button_Barcode setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    filterview.hidden=YES;
}

-(IBAction)number_filter_btn:(id)sender
{
    filter=@"number";
    [namebutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [discriptionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [numberButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [button_Barcode setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    filterview.hidden=YES;
}

-(IBAction)Barcode_filter_action:(id)sender
{
    filter=@"barcode";
    [namebutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [discriptionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [numberButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button_Barcode setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    filterview.hidden=YES;
}

-(IBAction)filter_btn_click:(id)sender
{
    filterview.hidden=NO;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    filterview.hidden=YES;
    [moreButtonView removeFromSuperview];
    [self add_button_on_tabbar];
    moreButtonView=nil;
    
    view_ManualPriceEntry.hidden = YES;
    
    //[search_b resignFirstResponder];
}
#pragma mark - UISearchBar Delegates

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)string
{
    string=[string lowercaseString];
    
    if([string isEqualToString:@""])
    {
        filterdone=NO;
    }
    else
    {
        filterdone=YES;
    }
    farticleName=[[NSMutableArray alloc]init];
    farticleId =[[NSMutableArray alloc]init];
    farticleVat =[[NSMutableArray alloc]init];
    farticlePrice =[[NSMutableArray alloc]init];
    farticleImage =[[NSMutableArray alloc]init];
    farticleDiscription =[[NSMutableArray alloc]init];
    farticlevariant =[[NSMutableArray alloc]init];
    farticleBarcode=[[NSMutableArray alloc]init];
    
    if([filter isEqualToString:@"name"])
    {
        for(int i=0;i<articleId.count;i++)
        {
            
            if ([[articleName[i] lowercaseString] rangeOfString:string].location == NSNotFound)
            {
                
            }
            else
            {
                [farticleName addObject:articleName[i]];
                [farticleId addObject:articleId[i]];
                [farticleVat addObject:articleVat[i]];
                [farticlePrice addObject:articlePrice[i]];
                [farticleImage addObject:articleImage[i]];
                [farticleDiscription addObject:articleDiscription[i]];
                [farticlevariant addObject:articlevariant[i]];
                [farticleBarcode addObject:articleBarcode[i]];
            }
            [tablearticle reloadData];
        }
    }
    else if([filter isEqualToString:@"discription"])
    {
        for(int i=0;i<articleId.count;i++)
        {
            if ([[articleDiscription[i] lowercaseString] rangeOfString:string].location == NSNotFound ) {
                
                
            }
            else
            {
                [farticleName addObject:articleName[i]];
                [farticleId addObject:articleId[i]];
                [farticleVat addObject:articleVat[i]];
                [farticlePrice addObject:articlePrice[i]];
                [farticleImage addObject:articleImage[i]];
                [farticleDiscription addObject:articleDiscription[i]];
                [farticlevariant addObject:articlevariant[i]];
                [farticleBarcode addObject:articleBarcode[i]];
            }
            [tablearticle reloadData];
        }
    }
    else if([filter isEqualToString:@"number"])
    {
        
        for(int i=0;i<articleId.count;i++)
        {
            if ([[articleId[i] lowercaseString] rangeOfString:string].location == NSNotFound) {
                
            }
            else
            {
                [farticleName addObject:articleName[i]];
                [farticleId addObject:articleId[i]];
                [farticleVat addObject:articleVat[i]];
                [farticlePrice addObject:articlePrice[i]];
                [farticleImage addObject:articleImage[i]];
                [farticleDiscription addObject:articleDiscription[i]];
                [farticlevariant addObject:articlevariant[i]];
                [farticleBarcode addObject:articleBarcode[i]];
                
            }
            [tablearticle reloadData];
        }
    }
    else if([filter isEqualToString:@"barcode"])
    {
        
        for(int i=0;i<articleBarcode.count;i++)
        {
            if ([[articleBarcode[i] lowercaseString] rangeOfString:string].location == NSNotFound) {
                
            }
            else
            {
                [farticleName addObject:articleName[i]];
                [farticleId addObject:articleId[i]];
                [farticleVat addObject:articleVat[i]];
                [farticlePrice addObject:articlePrice[i]];
                [farticleImage addObject:articleImage[i]];
                [farticleDiscription addObject:articleDiscription[i]];
                [farticlevariant addObject:articlevariant[i]];
                [farticleBarcode addObject:articleBarcode[i]];
                
            }
            [tablearticle reloadData];
        }
    }
    
    
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    //    [UIView beginAnimations:@"animate" context:nil];
    //    [UIView setAnimationDuration:0.35f];
    //    [UIView setAnimationBeginsFromCurrentState: NO];
    //    self.view.frame = CGRectMake(self.view.frame.origin.x, -60 , self.view.frame.size.width, self.view.frame.size.height);
    //
    //
    //    [UIView commitAnimations];
    return YES;
    
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    //    [UIView beginAnimations:@"animate" context:nil];
    //    [UIView setAnimationDuration:0.35f];
    //    [UIView setAnimationBeginsFromCurrentState: NO];
    //    self.view.frame = CGRectMake(self.view.frame.origin.x, 0 , self.view.frame.size.width, self.view.frame.size.height);
    //    [UIView commitAnimations];
    
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //    [UIView beginAnimations:@"animate" context:nil];
    //    [UIView setAnimationDuration:0.35f];
    //    [UIView setAnimationBeginsFromCurrentState: NO];
    //    self.view.frame = CGRectMake(self.view.frame.origin.x, 0 , self.view.frame.size.width, self.view.frame.size.height);
    //    [UIView commitAnimations];
    [textField resignFirstResponder];
    return YES;
}


-(void)getAllArticle
{
    articleName=[[NSMutableArray alloc]init];
    articleId =[[NSMutableArray alloc]init];
    articleVat =[[NSMutableArray alloc]init];
    articlePrice =[[NSMutableArray alloc]init];
    articleImage =[[NSMutableArray alloc]init];
    articleDiscription =[[NSMutableArray alloc]init];
    articlevariant=[[NSMutableArray alloc]init];
    articleBarcode=[[NSMutableArray alloc]init];
    //articleBarImage =[[NSMutableArray alloc]init];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context =[appDelegate managedObjectContext];
    NSEntityDescription *entityDesc =[NSEntityDescription entityForName:@"Article" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    for(int i=0;i<objects.count;i++)
    {
        NSManagedObject *person = (NSManagedObject *)[objects objectAtIndex:i];
        
        NSEntityDescription *entityDesc2 =[NSEntityDescription entityForName:@"Variant" inManagedObjectContext:context];
        NSFetchRequest *request2 = [[NSFetchRequest alloc] init];
        [request2 setEntity:entityDesc2];
        NSPredicate *pred1 =[NSPredicate predicateWithFormat:@"(article_id = %@)",[person valueForKey:@"article_no"]];
        [request2 setPredicate:pred1];
        NSError *error;
        NSArray *objects2 = [context executeFetchRequest:request2 error:&error];
        if(objects2.count>0)
        {
            for(int j=0;j<objects2.count;j++)
            {
                [articleId addObject:[NSString stringWithFormat:@"%@_%d",[person valueForKey:@"article_no"],j+1]];
                NSManagedObject *person1 = (NSManagedObject *)[objects2 objectAtIndex:j];
                [articleName addObject:[NSString stringWithFormat:@"%@",[person1 valueForKey:@"name"]]];
                [articleVat addObject:[person valueForKey:@"vat"]==nil?@"":[person valueForKey:@"vat"]];
                [articlePrice addObject:[person1 valueForKey:@"price"]==nil?@"":[person1 valueForKey:@"price"]];
                [articleImage addObject:[person valueForKey:@"article_img_url"]==nil?@"":[person valueForKey:@"article_img_url"]];
                [articleDiscription addObject:[person valueForKey:@"article_description"]==nil?@"":[person valueForKey:@"article_description"]];
                [articlevariant addObject:@"y"];
                [articleBarcode addObject:[person valueForKey:@"barcode"]==nil?@"":[person valueForKey:@"barcode"]];
            }
        }
        else
        {
            
            [articleId addObject:[person valueForKey:@"article_no"]];
            [articleName addObject:[CommonMethods validateDictionaryValueForKey:[person valueForKey:@"name"]]?[person valueForKey:@"name"]:@""];
            [articleVat addObject:[CommonMethods validateDictionaryValueForKey:[person valueForKey:@"vat"]]?[person valueForKey:@"vat"]:@""];
            [articlePrice addObject:[CommonMethods validateDictionaryValueForKey:[person valueForKey:@"price"]]?[person valueForKey:@"price"]:@""];
            [articleImage addObject:[CommonMethods validateDictionaryValueForKey:[person valueForKey:@"article_img_url"]]?[person valueForKey:@"article_img_url"]:@""];
            [articleDiscription addObject:[CommonMethods validateDictionaryValueForKey:[person valueForKey:@"article_description"]]?[person valueForKey:@"article_description"]:@""];
            [articleBarcode addObject:[CommonMethods validateDictionaryValueForKey:[person valueForKey:@"barcode"]]?[person valueForKey:@"barcode"]:@""];
            [articleBarImage addObject:[CommonMethods validateDictionaryValueForKey:[person valueForKey:@"barc_img_url"]]?[person valueForKey:@"barc_img_url"]:@""];
            [articlevariant addObject:@"n"];
            
//            [articleName addObject:[person valueForKey:@"name"]];
//            [articleVat addObject:[person valueForKey:@"vat"]==nil?@"":[person valueForKey:@"vat"]];
//            [articlePrice addObject:[person valueForKey:@"price"]==nil?@"":[person valueForKey:@"price"]];
//            [articleImage addObject:[person valueForKey:@"article_img_url"]==nil?@"":[person valueForKey:@"article_img_url"]];
//            [articleDiscription addObject:[person valueForKey:@"article_description"]==nil?@"":[person valueForKey:@"article_description"]];
//            
//            [articleBarcode addObject:[person valueForKey:@"barcode"]==nil?@"":[person valueForKey:@"barcode"]];
            //[articleBarImage addObject:[person valueForKey:@"barc_img_url"]];
        }
      
    }
    [_aticleTable reloadData];
    
    
    if (_aticleTable.contentSize.height > _aticleTable.frame.size.height)
    {
        CGPoint offset = CGPointMake(0, _aticleTable.contentSize.height - _aticleTable.frame.size.height);
        [_aticleTable setContentOffset:offset animated:YES];
    }
    
}


-(void)UpdateCardData:(int)selectedIndex
{
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context =[appDelegate managedObjectContext];
    
    NSEntityDescription *entityDesc1 =[NSEntityDescription entityForName:@"Cart" inManagedObjectContext:context];
    NSFetchRequest *request11 = [[NSFetchRequest alloc] init];
    [request11 setEntity:entityDesc1];
    
    NSMutableArray *predicatesArray=[[NSMutableArray alloc]init];
    
    NSPredicate *predicate;
    predicate = [NSPredicate predicateWithFormat:@"(article_id = %@)",arrayProductID[selectedIndex]];
    [predicatesArray addObject:predicate];
    
    predicate = [NSPredicate predicateWithFormat:@"(name = %@)",arrayProductName[selectedIndex]];
    [predicatesArray addObject:predicate];
    
    if([predicatesArray count]){
        NSPredicate * finalPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicatesArray];
        [request11 setPredicate:finalPredicate];
    }
    
    
    NSError *error;
    NSArray *objects11 = [context executeFetchRequest:request11 error:&error];
    
    
    
    for (NSManagedObject *obj in objects11) {
        
        int price = [txt_Price.text intValue];
        [obj setValue:[NSNumber numberWithInt:price] forKey:@"price"];
        [context save:&error];
    }
    
    [self getCartData];
    
}


-(void)getCartData
{
    totalvat=0.0;
    total=0.0;
    PriceWithoutVat = 0.0;
        
    arrayProductImage=[[NSMutableArray alloc]init];
    arrayProductName=[[NSMutableArray alloc]init];
    arrayProductQuantity=[[NSMutableArray alloc]init];
    arrayProductPrice=[[NSMutableArray alloc]init];
    arrayProductVat=[[NSMutableArray alloc]init];
    arrayProductID=[[NSMutableArray alloc]init];
    arrayProductDiscount=[[NSMutableArray alloc]init];
     arrayProductdiscountType=[[NSMutableArray alloc]init];
    float zzzz;
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context =[appDelegate managedObjectContext];
    NSEntityDescription *entityDesc =[NSEntityDescription entityForName:@"Cart" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    if(objects.count>0)
    {
        buttonCharge.backgroundColor=[UIColor colorWithRed:91.0f/255.0f green:41.0f/255.0f blue:117.0f/255.0f alpha:1.0f];
        buttonCharge.enabled=true;
    }
    else
    {
        buttonCharge.backgroundColor=[UIColor grayColor];
        buttonCharge.enabled=false;
    }
    
    NSMutableSet * processed = [NSMutableSet setWithArray:[objects valueForKey:@"vat"]];
    
    
    NSArray *array =[processed allObjects];
    VatVarient=[NSMutableArray new];
    VatAmount=[NSMutableArray new];
    
    
    
    for(int i=0;i<objects.count;i++)
    {
        NSManagedObject *person = (NSManagedObject *)[objects objectAtIndex:i];
        
        NSData *da=[person valueForKey:@"image"];
        UIImage *img=[[UIImage alloc] initWithData:da];
        [arrayProductImage addObject:img];
        [arrayProductName addObject:[CommonMethods validateDictionaryValueForKey:[person valueForKey:@"name"]]?[person valueForKey:@"name"]:@""];
        [arrayProductQuantity addObject:[CommonMethods validateDictionaryValueForKey:[person valueForKey:@"count"]]?[person valueForKey:@"count"]:@""];
        
//        [arrayProductName addObject:[person valueForKey:@"name"]];
//        [arrayProductQuantity addObject:[person valueForKey:@"count"]];
        
        [arrayProductPrice addObject:[CommonMethods validateDictionaryValueForKey:[person valueForKey:@"price"]]?[person valueForKey:@"price"]:@"0"];
        
        [arrayProductVat addObject:[CommonMethods validateDictionaryValueForKey:[person valueForKey:@"vat"]]?[person valueForKey:@"vat"]:@""];
        [arrayProductID addObject:[CommonMethods validateDictionaryValueForKey:[person valueForKey:@"article_id"]]?[person valueForKey:@"article_id"]:@""];
        [arrayProductDiscount addObject:[CommonMethods validateDictionaryValueForKey:[person valueForKey:@"discount"]]?[person valueForKey:@"discount"]:@""];
        
//        [arrayProductVat addObject:[person valueForKey:@"vat"]];
//        [arrayProductID addObject:[person valueForKey:@"article_id"]];
//        [arrayProductDiscount addObject:[person valueForKey:@"discount"]];
        if([person valueForKey:@"discountType"] == nil)
        {
            [arrayProductdiscountType addObject:@"%"];
        }
        else
        {
            [arrayProductdiscountType addObject:[person valueForKey:@"discountType"]];
        }
        float discountperproduct;
        
        
        
        if([[person valueForKey:@"discountType"] isEqualToString:@"%"] || [person valueForKey:@"discountType"] == nil)
        {
            discountperproduct=([[arrayProductPrice objectAtIndex:i]floatValue]*[[person valueForKey:@"count"]intValue]*[[person valueForKey:@"discount"]floatValue])/100;
          
        }
        else
        {
            discountperproduct=[[person valueForKey:@"discount"]floatValue];
            
        }
        
        total=(([[arrayProductPrice objectAtIndex:i] floatValue] *[[person valueForKey:@"count"] integerValue])-discountperproduct) + total;
        PriceWithoutVat = (([[arrayProductPrice objectAtIndex:i] floatValue]*[[person valueForKey:@"count"] integerValue])-discountperproduct) / (1 + [[person valueForKey:@"vat"] floatValue]/100) + PriceWithoutVat;
        
        
        zzzz = (([[arrayProductPrice objectAtIndex:i] floatValue]*[[person valueForKey:@"count"] integerValue])-discountperproduct) / (1 + [[person valueForKey:@"vat"] floatValue]/100);
        

        zzzz=(([[arrayProductPrice objectAtIndex:i] floatValue] *[[person valueForKey:@"count"] integerValue])-discountperproduct)-zzzz;
        
        totalvat= zzzz  + totalvat;
        
        
        
        totalvatnew=0.0;
        float totalnew=0.0;
        float discountperproductnew=0.0;
        float zzzznew=0.0;
        
        
        
        for (int j=0; j<[array count]; j++) {
        
            
            
                if ([[NSString stringWithFormat:@"%@",[person valueForKey:@"vat"]] isEqualToString:[NSString stringWithFormat:@"%@",[array objectAtIndex:j]]] ) {
                    
                    
                    if (![VatVarient containsObject:[person valueForKey:@"vat"]]) {
                        
                        
                        totalvatnew=0.0;
                        totalnew=0.0;
                        discountperproductnew=0.0;
                        zzzznew=0.0;
                        
                        
                        
                        [VatVarient addObject:[person valueForKey:@"vat"]];
                        
                        
                        totalnew=(([[arrayProductPrice objectAtIndex:i] floatValue] *[[person valueForKey:@"count"] integerValue])-discountperproductnew) + totalnew;
                        
                        zzzznew = (([[arrayProductPrice objectAtIndex:i] floatValue]*[[person valueForKey:@"count"] integerValue])-discountperproductnew) / (1 + [[person valueForKey:@"vat"] floatValue]/100);
                        
                        zzzznew=(([[arrayProductPrice objectAtIndex:i] floatValue] *[[person valueForKey:@"count"] integerValue])-discountperproductnew)-zzzznew;
                        
                        totalvatnew= zzzznew  + totalvatnew;
                        
                        
                        [VatAmount addObject:[NSString stringWithFormat:@"%f",totalvatnew]];
                        
                    }
                    else
                    {
                        
                        totalvatnew=0.0;
                        totalnew=0.0;
                        discountperproductnew=0.0;
                        zzzznew=0.0;
                        
                        
                        int ind=-1;
                        
                        
                        for (int k=0; k<[VatVarient count]; k++)
                        {
                            
                           if([[NSString stringWithFormat:@"%@",[VatVarient objectAtIndex:k]] isEqualToString:[NSString stringWithFormat:@"%@",[person valueForKey:@"vat"]]])
                               
                           {
                               
                               ind=k;
                            
                           }
                            
                            
                        }
                        
                        if (!ind==-1) {
                            
                            
                            float Sum;
                            Sum=[[VatAmount objectAtIndex:ind] floatValue];
                            
                            [VatAmount removeObjectAtIndex:ind];
                            
                            
                            totalnew=(([[arrayProductPrice objectAtIndex:i] floatValue] *[[person valueForKey:@"count"] integerValue])-discountperproductnew) + totalnew;
                            
                            zzzznew = (([[arrayProductPrice objectAtIndex:i] floatValue]*[[person valueForKey:@"count"] integerValue])-discountperproductnew) / (1 + [[person valueForKey:@"vat"] floatValue]/100);
                            
                            zzzznew=(([[arrayProductPrice objectAtIndex:i] floatValue] *[[person valueForKey:@"count"] integerValue])-discountperproductnew)-zzzznew;
                            
                            totalvatnew= zzzznew  + totalvatnew +Sum;
                            
                            
                            [VatAmount insertObject:[NSString stringWithFormat:@"%f",totalvatnew] atIndex:ind];
                            
                        }
                        
                            
                    }
            
            }
            
        }
        
        
        
    }
    
    
    //Check-box.png
    //totalPriceLbl.text=[NSString stringWithFormat:@"%@%.02f",currencySign,total];
    if(total<0)
    {
        totalPriceLbl.text=[NSString stringWithFormat:@"-%@ %.02f",currencySign,fabsf(total)];
    }
    else
        totalPriceLbl.text=[NSString stringWithFormat:@"%@ %.02f",currencySign,total];
    
    
    str_totalAmount=[NSString stringWithFormat:@"%f",total];
    
    
    totalVatLbl.text=[NSString stringWithFormat:@"%@ %@ %.02f %@",[Language get:@"Including" alter:@"!Including"],currencySign,totalvat, [Language get:@"VAT" alter:@"!VAT"]];
    
    if (totalvat==0.00) {
        totalVatLbl.text=[NSString stringWithFormat:@"%@",[Language get:@"Including VAT" alter:@"!Including VAT"]];
    }
    [tableViewSidePanel reloadData];
    
    
    if (tableViewSidePanel.contentSize.height > tableViewSidePanel.frame.size.height)
    {
        CGPoint offset = CGPointMake(0, tableViewSidePanel.contentSize.height - tableViewSidePanel.frame.size.height);
        [self.tableViewSidePanel setContentOffset:offset animated:YES];
    }
    
}
-(IBAction)clearCart:(UIButton*)sender
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
    
    
    [self getCartData];
}

-(void)IncreaseAction:(UIButton*)sender
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context =[appDelegate managedObjectContext];
    
    NSEntityDescription *entityDesc1 =[NSEntityDescription entityForName:@"Cart" inManagedObjectContext:context];
    NSFetchRequest *request11 = [[NSFetchRequest alloc] init];
    [request11 setEntity:entityDesc1];
    
    NSMutableArray *predicatesArray=[[NSMutableArray alloc]init];
    
    NSPredicate *predicate;
    predicate = [NSPredicate predicateWithFormat:@"(article_id = %@)",arrayProductID[sender.tag]];
    [predicatesArray addObject:predicate];
    
    predicate = [NSPredicate predicateWithFormat:@"(name = %@)",arrayProductName[sender.tag]];
    [predicatesArray addObject:predicate];
    
    if([predicatesArray count]){
        NSPredicate * finalPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicatesArray];
        [request11 setPredicate:finalPredicate];
    }
    
    
    NSError *error;
    NSArray *objects11 = [context executeFetchRequest:request11 error:&error];
    
    
    
    for (NSManagedObject *obj in objects11) {
        [obj setValue:[NSNumber numberWithInt:[[objects11 valueForKey:@"count"][0] intValue]+1] forKey:@"count"];
        [context save:&error];
    }
    
    [self getCartData];
    
}
-(void)decreaseAction:(UIButton*)sender
{
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context =[appDelegate managedObjectContext];
    
    NSEntityDescription *entityDesc1 =[NSEntityDescription entityForName:@"Cart" inManagedObjectContext:context];
    NSFetchRequest *request11 = [[NSFetchRequest alloc] init];
    [request11 setEntity:entityDesc1];
    
    NSMutableArray *predicatesArray=[[NSMutableArray alloc]init];
    
    NSPredicate *predicate;
    predicate = [NSPredicate predicateWithFormat:@"(article_id = %@)",arrayProductID[sender.tag]];
    [predicatesArray addObject:predicate];
    
    predicate = [NSPredicate predicateWithFormat:@"(name = %@)",arrayProductName[sender.tag]];
    [predicatesArray addObject:predicate];
    
    if([predicatesArray count]){
        NSPredicate * finalPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicatesArray];
        [request11 setPredicate:finalPredicate];
    }
    
    
    NSError *error;
    NSArray *objects11 = [context executeFetchRequest:request11 error:&error];
    
    
    
    for (NSManagedObject *obj in objects11) {
        if([[objects11 valueForKey:@"count"][0] intValue]>1)
        {
            [obj setValue:[NSNumber numberWithInt:[[objects11 valueForKey:@"count"][0] intValue]-1] forKey:@"count"];
            [context save:&error];
        }
    }
    [self getCartData];
}
-(IBAction)customAmountAndDiscountbtn:(UIButton*)sender
{
    if(sender.tag==1)
    {
        pressedindex=@"";
        
        customAmountViewController *viewControllerForPopover = [self.storyboard instantiateViewControllerWithIdentifier:@"customAmountViewController"];
        
        popover = [[UIPopoverController alloc] initWithContentViewController:viewControllerForPopover];
        
        [popover setPopoverContentSize:CGSizeMake(567, 516)];
        
        CGRect rect = CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/2, 1, 1);
        
        [popover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:0 animated:YES];
        
        viewControllerForPopover.callBack = self;
        
        popover.delegate=self;
        
    }
    else
    {
        
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context =[appDelegate managedObjectContext];
        
        
        NSEntityDescription *entityDesc2 =[NSEntityDescription entityForName:@"CustomDiscount" inManagedObjectContext:context];
        NSFetchRequest *request11 = [[NSFetchRequest alloc] init];
        [request11 setEntity:entityDesc2];
        NSPredicate *predicate;
        predicate = [NSPredicate predicateWithFormat:@"(id = %@)",@"1S"];
        [request11 setPredicate:predicate];
        
        NSError *error;
        NSArray *objects2 = [context executeFetchRequest:request11 error:&error];
        
        if(objects2.count==0)
        {
            
            customDiscountViewController *viewControllerForPopover = [self.storyboard instantiateViewControllerWithIdentifier:@"customDiscountViewController"];
            
            popover = [[UIPopoverController alloc] initWithContentViewController:viewControllerForPopover];
            
            [popover setPopoverContentSize:CGSizeMake(567, 400)];
            
            CGRect rect = CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/2, 1, 1);
            
            [popover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:0 animated:YES];
            popover.delegate=self;
            
            viewControllerForPopover.str_TotalAmount=str_totalAmount;
            viewControllerForPopover.callBack = self;
        }
        else
        {
            UIAlertView *al=[[UIAlertView alloc]initWithTitle:@"ISUPOS" message:[Language get:@"Only one discount allowed on Cart." alter:@"!Only one discount allowed on Cart."] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [al show];
        }
        
    }
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
  
    NSString *v=[NSString stringWithFormat:@"%@%@",textField.text,string];
    [self multiplyamount:v];
    return YES;
}
-(void)multiplyamount:(NSString*)v
{
  
    customTotal.text=[NSString stringWithFormat:@"%.02f",[v floatValue]*matchedprice];
}
-(IBAction)customUnitCancelandDoneBtn:(UIButton*)sender
{
    if(sender.tag==9)
    {
        if([customUnit.text isEqualToString:@""])
        {
            UIAlertView *al=[[UIAlertView alloc]initWithTitle:@"ISUPOS" message:[Language get:@"Please enter units" alter:@"!Please enter units"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [al show];
        }
        
        else
        {
            
                        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
                        NSManagedObjectContext *context =[appDelegate managedObjectContext];
            
                        NSError *error;
                        NSEntityDescription *entityDesc =[NSEntityDescription entityForName:@"Article" inManagedObjectContext:context];
                        NSFetchRequest *request = [[NSFetchRequest alloc] init];
                        [request setEntity:entityDesc];
                        NSPredicate *predicate;
                        predicate = [NSPredicate predicateWithFormat:@"(article_no = %@)",[popArticleid lastObject]];
                        [request setPredicate:predicate];
                        NSArray *objects = [context executeFetchRequest:request error:&error];
                        NSManagedObject *matches = nil;
                        matches = [objects objectAtIndex:0];
            
            
                        NSManagedObject *newContact;
                        newContact = [NSEntityDescription insertNewObjectForEntityForName:@"Cart" inManagedObjectContext:context];
                        [newContact setValue:[NSNumber numberWithFloat:[[matches valueForKey:@"vat" ] floatValue]] forKey:@"vat"];
                        [newContact setValue:[NSString stringWithFormat:@"%@",[popArticlename lastObject]] forKey:@"name"];
                        //[newContact setValue:[NSString stringWithFormat:@"%@  %.2f%@",selectedVariantname,[customUnit.text floatValue],customUnitName.text] forKey:@"name"];
                        [newContact setValue:UIImagePNGRepresentation([UIImage imageNamed:@"ca.png"]) forKey:@"image"];
                        [newContact setValue:[NSNumber numberWithInt:1] forKey:@"count"];
                        [newContact setValue:[popArticlename lastObject] forKey:@"article_id"];
                        [newContact setValue:[matches valueForKey:@"discount"] forKey:@"discount"];
            
            
                        NSEntityDescription *entityDesc2 =[NSEntityDescription entityForName:@"Variant" inManagedObjectContext:context];
                        NSFetchRequest *request11 = [[NSFetchRequest alloc] init];
                        [request11 setEntity:entityDesc2];
                        NSMutableArray *predicatesArray=[[NSMutableArray alloc]init];
                        NSPredicate *predicate1;
                        predicate1= [NSPredicate predicateWithFormat:@"(article_id = %@)",[popArticleid lastObject]];
                        [predicatesArray addObject:predicate1];
                        predicate1 = [NSPredicate predicateWithFormat:@"(name = %@)",[popArticlename lastObject]];
                        [predicatesArray addObject:predicate1];
                        if([predicatesArray count]){
                            NSPredicate * finalPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicatesArray];
                            [request11 setPredicate:finalPredicate];
                        }
                        NSArray *objects2 = [context executeFetchRequest:request11 error:&error];
                        NSManagedObject *matches1 = nil;
                        matches1=[objects2 objectAtIndex:0];
                        [newContact setValue:[NSNumber numberWithFloat:[[matches1 valueForKey:@"price"] floatValue]*[customUnit.text floatValue]] forKey:@"price"];
                        [context save:&error];
          
            [UIView beginAnimations:@"animate" context:nil];
            [UIView setAnimationDuration:0.35f];
            [UIView setAnimationBeginsFromCurrentState: NO];
            CGRect frame = customUnitView.frame;
            frame.origin.x = 1024;
            [customUnitView setFrame:frame];
            [UIView commitAnimations];
            
            customName.text=@"";
            CustomAmount.text=@"";
            customUnitName.text=@"";
            customUnit.text=@"";
            
            [popArticleid removeLastObject];
            [popArticlename removeLastObject];
            [self showpopUp];
            
        }
    }
    else
    {
        
        [UIView beginAnimations:@"animate" context:nil];
        [UIView setAnimationDuration:0.35f];
        [UIView setAnimationBeginsFromCurrentState: NO];
        CGRect frame = customUnitView.frame;
        frame.origin.x = 1024;
        [customUnitView setFrame:frame];
        [UIView commitAnimations];
        
        customName.text=@"";
        CustomAmount.text=@"";
        customUnitName.text=@"";
        customUnit.text=@"";
        
    }
    [self getCartData];
    
}
-(void)showManualPriceEntryPopUp:(int)selectedIndex
{
    view_ManualPriceEntry.hidden = NO;
    
    txt_Price.layer.borderWidth = 1;
    
    txt_Price.inputView = [[[NSBundle mainBundle] loadNibNamed:@"LNNumberpad" owner:self options:nil] objectAtIndex:0];
    
    txt_Price.text = @"";
    UIView *leftPadding = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 0)];
    txt_Price.leftView = leftPadding;
    txt_Price.leftViewMode = UITextFieldViewModeAlways;
    
    lbl_PriceTitle.text = [NSString stringWithFormat:@"Please enter valid price for %@",[arrayProductName objectAtIndex:selectedIndex]];
    
    btn_Ok.tag = selectedIndex;
    
}

-(IBAction)buttonOKCancel:(UIButton *)sender
{
    if (sender == btn_Ok)
    {
        if (txt_Price.text.length == 0 || [txt_Price.text intValue] == 0)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ISUPOS" message:[Language get:@"Please enter valid price." alter:@"!Please enter valid price."] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        else
        {
            [view_ManualPriceEntry setHidden:YES];
            [self UpdateCardData:(int)sender.tag];
        }
        
    }
    else
    {
        [view_ManualPriceEntry setHidden:YES];
    }
    
}


-(void)showpopUp
{
    if(popArticleid.count>0)
    {
        [self addcustomunitincart];
    }
    else
    {
        [customUnit resignFirstResponder];
    }
    
}
-(void)addcustomunitincart
{
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context =[appDelegate managedObjectContext];
    
    NSError *error;
    

    NSEntityDescription *entityDesc2 =[NSEntityDescription entityForName:@"Article" inManagedObjectContext:context];
    NSFetchRequest *requestt = [[NSFetchRequest alloc] init];
    [requestt setEntity:entityDesc2];
    NSPredicate *predicate1;
    predicate1 = [NSPredicate predicateWithFormat:@"(article_no = %@)",[popArticleid lastObject]];
    [requestt setPredicate:predicate1];
    NSArray *objects = [context executeFetchRequest:requestt error:&error];
    NSManagedObject *matches = [objects objectAtIndex:0];

   

    NSEntityDescription *entityDescw =[NSEntityDescription entityForName:@"Variant" inManagedObjectContext:context];
    NSFetchRequest *request3= [[NSFetchRequest alloc] init];
    [request3 setEntity:entityDescw];

    NSMutableArray *predicatesArray1=[[NSMutableArray alloc]init];
    NSPredicate *predicate11;
    predicate11 = [NSPredicate predicateWithFormat:@"(article_id = %@)",[popArticleid lastObject]];
    [predicatesArray1 addObject:predicate11];
    predicate11 = [NSPredicate predicateWithFormat:@"(name = %@)",[popArticlename lastObject]];
    [predicatesArray1 addObject:predicate11];
    if([predicatesArray1 count]){
        NSPredicate * finalPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicatesArray1];
        [request3 setPredicate:finalPredicate];
    }
        NSArray *objects3 = [context executeFetchRequest:request3 error:&error];

        NSManagedObject *matches1 = nil;
        matches1=[objects3 objectAtIndex:0];
    
    
    
    customName.text=[popArticlename lastObject];

    CustomAmount.text=[NSString stringWithFormat:@"%@ %0.2f / %@",currencySign,[[matches1 valueForKey:@"price"] floatValue],[matches valueForKey:@"unitName"]];
    customUnitName.text=[matches valueForKey:@"unitName" ];
    customUnit.text=@"";
    [customUnit becomeFirstResponder];
    matchedprice=[[matches1 valueForKey:@"price"] floatValue];
    
    [UIView beginAnimations:@"animate" context:nil];
    [UIView setAnimationDuration:0.35f];
    [UIView setAnimationBeginsFromCurrentState: NO];
    CGRect frame = customUnitView.frame;
    frame.origin.x = 0;
    [customUnitView setFrame:frame];
    [UIView commitAnimations];

    customTotal.text=[NSString stringWithFormat:@"%@ 0.00",currencySign];
}

@end
