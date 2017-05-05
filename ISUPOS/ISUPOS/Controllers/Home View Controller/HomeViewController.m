//
//  HomeViewController.m
//  ISUPOS
//
//  Created by Gurpreet on 02/04/15.
//  Copyright (c) 2015 Davinder. All rights reserved.
//


#import "HomeViewController.h"

// Other Classes
#import "SidePanelViewController.h"
#import "CustomCellQuickBlocks.h"
#import "CustomCellQuickButtons.h"
#import "CustomTableViewCell.h"
#import "quickBlocknextcell.h"
#import "quickButtonCartlongPrssView.h"
#import "quickBlocksButtonsView.h"
#import "helo&supportViewController.h"
#import "generalSettingViewController.h"
#import "thankyouViewController.h"
#import "receiptDataViewController.h"
#import "paymentViewController.h"
#import "ManageArticalViewController.h"
#import "reportViewController.h"
#import "LogViewController.h"
#import "customAmountViewController.h"
#import "customDiscountViewController.h"
#import "articlepopupViewController.h"

#import "Language.h"
@interface HomeViewController ()
{
    
    NSString *filterButton;
    NSString *filterBlock;
    UIView *moreButtonView,*popview;
    NSMutableArray *morebuttons;
    UIButton *morebutton;
    BOOL filterdone, filterdone1;
    int delblock,delbutton;
    IBOutlet UIButton *namebutton,*discriptionButton,*numberButton;
    int selectedblock;
    float total,totalvat;
    float matchedprice;
    
    UIPopoverController *popover;
    NSString *currencySign;
    
    IBOutlet UIButton *buttonCharge, *backbtn,*percetbutton;
    
    IBOutlet UITableView *tableViewSidePanel;
    
    NSMutableArray *arrayProductImage, *arrayProductName, *arrayProductQuantity, *arrayProductPrice ,*arrayProductVat ,*arrayProductDiscount,*arrayProductID,*arrayProductdiscountType,*arrayproductcomment,*arrayBarcode;
    
    IBOutlet UICollectionView *collectionViewQuickBlocks, *collectionQuickButtons, *collectionViewQuickNextButtons;
    
    NSMutableArray *arrayQuickBlocks, *arrayQuickBlocksID, *arrayQuickBlocksIconImages1, *arrayQuickBlocksIconImages2, *arrayQuickBlocksIconImages3, *arrayQuickBlocksIconImages4,*arrayQuickBlocksIDEdit;
    
    NSMutableArray *arrayQuickButtons, *arrayQuickButtonsImages, *arrayQuickButtonsVariantCount , *arrayQuickButtonsIds,*arrayQuickButtonsIDEdit;
    
    NSMutableArray *farrayQuickButtons, *farrayQuickButtonsImages, *farrayQuickButtonsVariantCount , *farrayQuickButtonsIds;
    
    
    NSMutableArray *arrayNextQuickButtons, *arrayNextQuickButtonsImages, *arrayNextQuickButtonsVariantCount , *arrayNextQuickButtonsIds;
    
    NSMutableArray *farrayNextQuickButtons, *farrayNextQuickButtonsImages, *farrayNextQuickButtonsVariantCount , *farrayNextQuickButtonsIds;

    
    NSMutableArray *array_tableCheck;
    
    NSString *selectedVariantname,*selectedVariantId, *selectedVariantPrice;
    NSMutableArray *arrayVariantPrice,*arrayVariantName;
    
    NSString *text_string;
    int selIndex;
    
    IBOutlet UIView *filterview, *quickblocknextview;
    IBOutlet  UILabel *totalPriceLbl,*totalVatLbl;
    
    NSMutableArray *VatVarient;
    NSMutableArray *VatAmount;

    NSString *str_totalAmount;
    BOOL bool_EditAlert;
    IBOutlet UIView *selectSearchView;
    
    
    IBOutlet UIView *view_ManualPriceEntry;
    IBOutlet UILabel *lbl_PriceTitle;
    IBOutlet UITextField *txt_Price;
    IBOutlet UIButton *btn_Ok,*btn_Cancel;
}

@property (weak, nonatomic) IBOutlet UIButton *buttonSearchName;
@property (weak, nonatomic) IBOutlet UIButton *buttonSearchNumber;

@property (weak, nonatomic) IBOutlet UIButton *buttonSelectByName;

@property (weak, nonatomic) IBOutlet UIButton *buttonSelectByNumber;


- (IBAction)actionSearchName:(UIButton *)sender;
- (IBAction)actionSearchNumber:(UIButton *)sender;

- (IBAction)actionSearchButtonName:(UIButton *)sender;
- (IBAction)actionSearchButtonNumber:(UIButton *)sender;



- (IBAction)actionSearchClick:(UIButton *)sender;

-(IBAction)name_filter_btn:(id)sender;
-(IBAction)back_btn:(id)sender;
-(IBAction)discription_filter_btn:(id)sender;
-(IBAction)number_filter_btn:(id)sender;
-(IBAction)filter_btn_click:(id)sender;
@property (strong, nonatomic)IBOutlet UITableView *tableViewSidePanel;

@property (weak, nonatomic) IBOutlet UIButton *button_Clear;
- (IBAction)actionBlockSearchClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *selectBlockSearchView;


@end


@implementation HomeViewController
@synthesize tableViewSidePanel;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        // Custom initialization
    }
    
    return self;
}


#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    //    customTotal.text = [NSString stringWithFormat:@"%@0.00",currencySign];
    
//    self.labelNew.hidden = NO;
    
    view_ManualPriceEntry.hidden = YES;
    selectSearchView.hidden = YES;
//    scrv.userInteractionEnabled = NO;
//    self.searhBarHome.userInteractionEnabled = NO;
    self.selectBlockSearchView.hidden = YES;
    filterBlock = @"name";
    filterButton = @"name";
    
    bool_EditAlert = NO;

    self.customBtnQuick.hidden = YES;
    self.searchIcon.hidden = YES;
    self.searhBarHome.hidden = YES;
    self.SearchImage.hidden = YES;
    array_tableCheck=[NSMutableArray new];
    
    
    [super viewDidLoad];
    
    str_totalAmount=@"0";
    
    // Splunk Mint Breadcrumb added
    [[Mint sharedInstance] leaveBreadcrumb:@"QuickButtonsViewController_ViewController"];
    
    filterview.hidden=YES;
    backbtn.hidden=YES;
    quickblocknextview.hidden=YES;
    //percetbutton.enabled=false;
    
    CGRect frame = variantView.frame;
    frame.origin.y =2024;
    [variantView setFrame:frame];
    
    //percetbutton.enabled=false;
    
//    [buttonClear addTarget:self action:@selector(clearCart:) forControlEvents:UIControlEventTouchUpInside];
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 0.5; //seconds
    lpgr.delegate = self;
    [tableViewSidePanel addGestureRecognizer:lpgr];
    
    [_button_Clear setTitle:[Language get:@"Clear" alter:@"!Clear"] forState:UIControlStateNormal];
    [buttonCharge setTitle:[Language get:@"Charge" alter:@"!Charge"] forState:UIControlStateNormal];
    
    selectedblock= -1;
    //[self.tabBarController.tabBar setBackgroundColor:[UIColor colorWithRed:111.0f/255.0f green:60.0f/255.0f blue:135.0f/255.0f alpha:1.0]];
    //[[UITabBar appearance] setBackgroundColor:[UIColor colorWithRed:111.0f/255.0f green:60.0f/255.0f blue:135.0f/255.0f alpha:1.0]];;
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.hidesBackButton = YES;
    
    //    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"CalculatorIcon.png"] style:UIBarButtonItemStylePlain target:self action:nil];
    //
    //    [[self navigationItem] setRightBarButtonItem:rightItem];
    
    UIButton *calculator = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIImage *calculatorBtnImage = [UIImage imageNamed:@"CalculatorIcon.png"];
    
    [calculator setBackgroundImage:calculatorBtnImage forState:UIControlStateNormal];
    
    calculator.frame = CGRectMake(0, 0, 25, 33);
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:calculator] ;
    
    //self.navigationItem.rightBarButtonItem = backButton;
    
    UILongPressGestureRecognizer *lpgr1
    = [[UILongPressGestureRecognizer alloc]
       initWithTarget:self action:@selector(quickBlockLongPress:)];
    lpgr1.minimumPressDuration = 2.0; //seconds
    lpgr1.delegate = self;
    lpgr.delaysTouchesBegan = true;
    [collectionViewQuickBlocks addGestureRecognizer:lpgr1];
    
    UILongPressGestureRecognizer *lpgr2
    = [[UILongPressGestureRecognizer alloc]
       initWithTarget:self action:@selector(quickButtonsLongPress:)];
    lpgr2.minimumPressDuration = 2.0; //seconds
    lpgr2.delegate = self;
    lpgr.delaysTouchesBegan = true;
    lpgr.allowableMovement = 50.0f;
    [collectionQuickButtons addGestureRecognizer:lpgr2];
    
    selectedVariantname=@"";
    
    
    for (UIView *view in self.navigationController.navigationBar.subviews )
    {
        if (view.tag == -1)
        {
            [view removeFromSuperview];
        }
        
    }
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    UILabel *lbl_manReg_ID = [[UILabel alloc]initWithFrame:CGRectMake(470, 22, 200, 30)];
    lbl_manReg_ID.tag = -1;
   // lbl_manReg_ID.text = [defaults objectForKey:@"INFRASEC_PASSWORD"];
    lbl_manReg_ID.text = [defaults objectForKey:@"POS_ID"];
    lbl_manReg_ID.textColor = [UIColor whiteColor];
    lbl_manReg_ID.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:11];
    
  //  [self.navigationController.navigationBar addSubview:lbl_manReg_ID];
    
//    
//    [self.manufacturer_BarButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//                                     [UIFont fontWithName:@"HelveticaNeue-Bold" size:11.0], NSFontAttributeName,
//                                     [UIColor whiteColor], NSForegroundColorAttributeName,
//                                     nil] forState:UIControlStateNormal];
   

    
    
    NSDictionary *dictRoot = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Product_Details" ofType:@"plist"]];
    
//    self.manufacturer_BarButton.title = [dictRoot valueForKey:@"Manufacturer"];
    
    
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
    
}
-(void)quickButtonsLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    
    if (bool_EditAlert) {
        
        return;
    }
    
    bool_EditAlert = YES;

    CGPoint p = [gestureRecognizer locationInView:collectionQuickButtons];
    
    NSIndexPath *indexPath = [collectionQuickButtons indexPathForItemAtPoint:p];
    if (indexPath == nil){
        NSLog(@"couldn't find index path");
    } else {
        
        delbutton=indexPath.row;
        UIAlertView* alert1 = [[UIAlertView alloc] init];
        [alert1 setDelegate:self];
        [alert1 setTitle:@"ISUPOS"];
        [alert1 setMessage:[NSString stringWithFormat:@"%@", [Language get:@"Are you want to delete or edit?" alter:@"!Are you want to delete or edit?"]]];
        [alert1 addButtonWithTitle:[NSString stringWithFormat:@"%@", [Language get:@"Cancel" alter:@"!Cancel"]]];
        [alert1 addButtonWithTitle:[NSString stringWithFormat:@"%@", [Language get:@"Delete" alter:@"!Delete"]]];
        [alert1 addButtonWithTitle:[NSString stringWithFormat:@"%@", [Language get:@"Edit" alter:@"!Edit"]]];

        
        alert1.tag=17;
        alert1.alertViewStyle = UIAlertViewStyleDefault;
        
        [alert1 show];
        
    }
    
}

-(void)quickBlockLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (bool_EditAlert) {
        
        return;
    }
    
    bool_EditAlert = YES;

    CGPoint p = [gestureRecognizer locationInView:collectionViewQuickBlocks];
    
    NSIndexPath *indexPath = [collectionViewQuickBlocks indexPathForItemAtPoint:p];
    if (indexPath == nil){
        NSLog(@"couldn't find index path");
    } else {
        // get the cell at indexPath (the one you long pressed)
        
        delblock=indexPath.row;
        UIAlertView* alert1 = [[UIAlertView alloc] init];
        [alert1 setDelegate:self];
        [alert1 setTitle:@"ISUPOS"];
        [alert1 setMessage:[NSString stringWithFormat:@"%@", [Language get:@"Are you want to delete or edit?" alter:@"!Are you want to delete or edit?"]]];
        
        [alert1 addButtonWithTitle:[NSString stringWithFormat:@"%@", [Language get:@"Cancel" alter:@"!Cancel"]]];
        [alert1 addButtonWithTitle:[NSString stringWithFormat:@"%@", [Language get:@"Delete" alter:@"!Delete"]]];
        [alert1 addButtonWithTitle:[NSString stringWithFormat:@"%@", [Language get:@"Edit" alter:@"!Edit"]]];

        alert1.tag=18;
        alert1.alertViewStyle = UIAlertViewStyleDefault;
        
        [alert1 show];
        
    }
    
}

-(void)Settitles
{
    self.title=[Language get:@"Quick Blocks" alter:@"!Quick Blocks"];
    self.labelNew.text=[Language get:@"Quick Blocks" alter:@"!Quick Blocks"];
    self.labelNew1.text=[Language get:@"Quick Buttons" alter:@"!Quick Buttons"];
    quickbutton12.text=[Language get:@"Quick Blocks" alter:@"!Quick Blocks"];
    [self.button_Clear setTitle:[Language get:@"Clear" alter:@"!Clear"] forState:UIControlStateNormal];
    [buttonCharge setTitle:[Language get:@"Charge" alter:@"!Charge"] forState:UIControlStateNormal];
    scrv.placeholder=[Language get:@"Search Quick Buttons" alter:@"!Search Quick Buttons"];
    self.select_Variant.text = [Language get:@"Select Variant" alter:@"!Select Variant"];
    [self.CancelButtonAddItem setTitle:[Language get:@"Cancel" alter:@"!Cancel"] forState:UIControlStateNormal];
//    [self.add_Item setTitle:[Language get:@"ADD ITEM" alter:@"!ADD ITEM"] forState:UIControlStateNormal];
    [self.buttonCancelCustom setTitle:[Language get:@"Cancel" alter:@"!Cancel"] forState:UIControlStateNormal];
    [self.add_Button setTitle:[Language get:@"Add" alter:@"!Add"] forState:UIControlStateNormal];
//    self.searhBarHome.text=[Language get:@"Search Article" alter:@"!Search Article"];
    self.searhBarHome.placeholder=[Language get:@"Search Article" alter:@"!Search Article"];

//    self.button_Clear.backgroundColor = [UIColor greenColor];
    
}
- (void) viewWillAppear:(BOOL)animated
{
    selectSearchView.hidden = YES;
//    scrv.userInteractionEnabled = NO;
//    self.searhBarHome.userInteractionEnabled = NO;
    self.selectBlockSearchView.hidden = YES;
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
    totalPriceLbl.text=[NSString stringWithFormat:@"00.00"];
//    totalVatLbl.text=[NSString stringWithFormat:@"Including %@00.00 VAT",currencySign];
    

    [self add_button_on_tabbar];
    self.navigationController.navigationBarHidden = NO;
    
    [self getDataFromDataBase];
    [self getCartData];
    
    
    
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


#pragma mark - IBActions

-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    CGPoint p = [gestureRecognizer locationInView:tableViewSidePanel];
    
    NSIndexPath *indexPath = [tableViewSidePanel indexPathForRowAtPoint:p];
    if (indexPath == nil) {
        NSLog(@"long press on table view but not on a row");
    } else if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        NSLog(@"long press on table view at row %d", (int)indexPath.row);
        
        
        if(indexPath.row==arrayProductID.count)
        {
            
            customDiscountViewController *viewControllerForPopover = [self.storyboard instantiateViewControllerWithIdentifier:@"customDiscountViewController"];
            
            popover = [[UIPopoverController alloc] initWithContentViewController:viewControllerForPopover];
            
            [popover setPopoverContentSize:CGSizeMake(567, 400)];
            
            CGRect rect = CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/2, 1, 1);
            
            [popover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:0 animated:YES];
            
            popover.delegate=self;
            
            viewControllerForPopover.callBack = self;
            
        }
        else if([UIImagePNGRepresentation(arrayProductImage[indexPath.row]) isEqualToData: UIImagePNGRepresentation([UIImage imageNamed:@"ca.png"])])
        {
            pressedindex=arrayProductID[ indexPath.row];
            pressedname=arrayProductName[indexPath.row];
            
            customAmountViewController *viewControllerForPopover = [self.storyboard instantiateViewControllerWithIdentifier:@"customAmountViewController"];
            
            popover = [[UIPopoverController alloc] initWithContentViewController:viewControllerForPopover];
            
            [popover setPopoverContentSize:CGSizeMake(567, 516)];
            
            CGRect rect = CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/2, 1, 1);
            
            [popover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:0 animated:YES];
            
            popover.delegate=self;
            viewControllerForPopover.callBack = self;
        }
        else
        {
            pressedindex=arrayProductID[ indexPath.row];
            pressedname=arrayProductName[indexPath.row];
       
            quickButtonCartlongPrssView *viewControllerForPopover = [self.storyboard instantiateViewControllerWithIdentifier:@"quickButtonCartlongPrss"];
            popover = [[UIPopoverController alloc] initWithContentViewController:viewControllerForPopover];
            [popover setPopoverContentSize:CGSizeMake(587, 564)];
            CGRect rect = CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/2, 1, 1);
            [popover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:0 animated:YES];
            popover.delegate=self;
            viewControllerForPopover.callBack = self;
        }
        
    } else {
        // NSLog(@"gestureRecognizer.state = %d", gestureRecognizer.state);
    }
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
            [popover setPopoverContentSize:CGSizeMake(567, 550)];
            CGRect rect = CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/2, 1, 1);
            [popover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:0 animated:YES];
            viewControllerForPopover.callBack = self;
            moreButtonView=nil;
            popover.delegate=self;
            [self add_button_on_tabbar];
            [popover setPopoverContentSize:CGSizeMake(567, 480)];
            
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
////            LogViewController *logViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LogViewController"];
////            [self.navigationController presentViewController:logViewController animated:NO completion:nil];
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
            [popover setPopoverContentSize:CGSizeMake(567,550)];
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
////           LogViewController *logViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LogViewController"];
////            [self.navigationController presentViewController:logViewController animated:NO completion:nil];
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

- (IBAction)actionSearchName:(UIButton *)sender {
    
    filterBlock = @"name";

    [self.buttonSearchName setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.buttonSearchNumber setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
        self.selectBlockSearchView.hidden = YES;
        self.searhBarHome.userInteractionEnabled = YES;
}


- (IBAction)actionSearchNumber:(UIButton *)sender {
    
    filterBlock = @"number";
    
    [self.buttonSearchName setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.buttonSearchNumber setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
        self.selectBlockSearchView.hidden = YES;
        self.searhBarHome.userInteractionEnabled = YES;
}

- (IBAction)actionSearchButtonName:(UIButton *)sender {
    
    filterButton = @"name";
    
    [self.buttonSelectByName setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.buttonSelectByNumber setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
        selectSearchView.hidden=YES;
        scrv.userInteractionEnabled = YES;


}

- (IBAction)actionSearchButtonNumber:(UIButton *)sender {
    
    filterButton = @"number";
    
    [self.buttonSelectByName setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.buttonSelectByNumber setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
        selectSearchView.hidden=YES;
        scrv.userInteractionEnabled = YES;

    
}

- (IBAction)actionSearchClick:(UIButton *)sender {
    
    selectSearchView.hidden = NO;
}



-(IBAction)name_filter_btn:(id)sender
{
    [namebutton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [discriptionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [numberButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    selectSearchView.hidden=YES;
}
-(IBAction)discription_filter_btn:(id)sender
{
    [namebutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [discriptionButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [numberButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    filterview.hidden=YES;
}
-(IBAction)number_filter_btn:(id)sender
{
    [namebutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [discriptionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [numberButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    filterview.hidden=YES;
}
-(IBAction)filter_btn_click:(id)sender
{
    filterview.hidden=NO;
 
}
-(IBAction)back_btn:(id)sender
{
    backbtn.hidden=YES;
    quickblocknextview.hidden=YES;
    selectedblock= -1;
    [collectionViewQuickBlocks reloadData];
    
    self.searchIcon.hidden = YES;
    self.searhBarHome.hidden = YES;
    self.SearchImage.hidden = YES;
    
}
-(void)targetMethod:(NSTimer *)timer {
    
    [collectionViewQuickNextButtons reloadData];
    backbtn.hidden=NO;
    quickblocknextview.hidden=NO;
//    self.labelNew.hidden = YES;
    self.searhBarHome.hidden = NO;
    self.searchIcon.hidden = NO;
    self.searchIcon.hidden = NO;
    
}
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
        if([totalPriceLbl.text hasPrefix:@"-"])
        {
            //totalamount=[[totalPriceLbl.text substringFromIndex:2] floatValue];
            UIAlertView* alert1 = [[UIAlertView alloc] init];
            [alert1 setDelegate:self];
            [alert1 setTitle:@"ISUPOS"];
            [alert1 setMessage:[NSString stringWithFormat:@"%.2f %@",totalamount,[Language get:@"can't be Charge" alter:@"!can't be Charge"]]];
            [alert1 addButtonWithTitle:@"OK"];
            alert1.tag=8;
            alert1.alertViewStyle = UIAlertViewStyleDefault;
            
            [alert1 show];
        }
        else
        {
            totalamount=[[totalPriceLbl.text substringFromIndex:1] floatValue];
            
            //            if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"PrinterStatus"] isEqualToString:@"Online"]) {
            
            
            AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
            NSManagedObjectContext *context =[appDelegate managedObjectContext];
            NSEntityDescription *entityDesc =[NSEntityDescription entityForName:@"Cart" inManagedObjectContext:context];
            NSFetchRequest *request = [[NSFetchRequest alloc] init];
            [request setEntity:entityDesc];
            NSError *error;
            NSArray *objects = [context executeFetchRequest:request error:&error];
            
            if(objects.count>0)
            {
                //    UIAlertView* alert1 = [[UIAlertView alloc] init];
                //    [alert1 setDelegate:self];
                //    [alert1 setTitle:@"ISUPOS"];
                //    [alert1 setMessage:@"Select payment method."];
                //    [alert1 addButtonWithTitle:@"Cash Payment"];
                //    [alert1 addButtonWithTitle:@"Card Payment"];
                //    [alert1 addButtonWithTitle:@"Cancel"];
                //    alert1.tag=11;
                //    alert1.alertViewStyle = UIAlertViewStyleDefault;
                //    [alert1 show];
                ;
                
                if([currencySign isEqual:@"$"])
                {
                    totalamount=[[totalPriceLbl.text substringFromIndex:1] floatValue];
                }
                else{
                    totalamount=[[totalPriceLbl.text substringFromIndex:3] floatValue];
                    
                }
                
                paymentViewController *viewControllerForPopover = [self.storyboard instantiateViewControllerWithIdentifier:@"paymentViewController"];
                viewControllerForPopover.vat_Amount=VatAmount;
                viewControllerForPopover.vat_Variant=VatVarient;
                if (selectedblock>-1)
                {
                    viewControllerForPopover.str_QuickBlockName = [arrayQuickBlocks objectAtIndex:selectedblock];
                }
                else
                {
                    viewControllerForPopover.str_QuickBlockName = @"";
                }
                viewControllerForPopover.str_PurchaseAmount=[NSString stringWithFormat:@"%.02f",totalvat];
                popover = [[UIPopoverController alloc] initWithContentViewController:viewControllerForPopover];
                [popover setPopoverContentSize:CGSizeMake(567, 564)];
                CGRect rect = CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/2, 1, 1);
                [popover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:0 animated:YES];
                viewControllerForPopover.callBack = self;popover.delegate=self;
                
            }
        }
        
        
        //            else
        //            {
        //                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ISUPOS" message:@"Printer not connected." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        //                [alert show];
        //            }
        //    }
    }
    
   
    
    
}

-(void)showManualPriceEntryPopUp:(int)selectedIndex
{
    view_ManualPriceEntry.hidden = NO;
    
    txt_Price.inputView = [[[NSBundle mainBundle] loadNibNamed:@"LNNumberpad" owner:self options:nil] objectAtIndex:0];
    
    txt_Price.layer.borderWidth = 1;
    
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
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ISUPOS" message:[Language get:@"Card Payment method not available" alter:@"!Card Payment method not available"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ISUPOS" message:[Language get:@"Payment cancelled." alter:@"Payment cancelled."] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
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
    else if (alertView.tag==17)
    {
        
        bool_EditAlert = NO;
        if(buttonIndex==1)
        {
            AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
            NSManagedObjectContext *context =[appDelegate managedObjectContext];
            NSError *error;
            NSFetchRequest *request1 = [NSFetchRequest fetchRequestWithEntityName:@"QuickBlocks"];
            NSPredicate *pred2 =[NSPredicate predicateWithFormat:@"(name = %@)",arrayQuickButtons[delbutton]];
            [request1 setPredicate:pred2];
            NSArray *objects1 = [context executeFetchRequest:request1 error:&error];
            if (objects1 == nil) {
                // handle error
            } else {
                for (NSManagedObject *object in objects1) {
                    [context deleteObject:object];
                }
                [context save:&error];
                [self getDataFromDataBase];
            }
            
        }
        
        else if (buttonIndex==2)
        {
            
            
            quickBlocksButtonsView *viewControllerForPopover = [self.storyboard instantiateViewControllerWithIdentifier:@"quickBlocksButtonsView"];
            popover = [[UIPopoverController alloc] initWithContentViewController:viewControllerForPopover];
            [popover setPopoverContentSize:CGSizeMake(567, 500)];
            CGRect rect = CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/2, 1, 1);
            [popover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:0 animated:YES];
            viewControllerForPopover.callBack = self;
            viewControllerForPopover.isEdit=YES;
            viewControllerForPopover.str_id=arrayQuickButtonsIDEdit[delbutton];
            popover.delegate=self;

        }
        
    }
    else if (alertView.tag==18)
    {
        
        bool_EditAlert = NO;
        
        if(buttonIndex==1)
        {
            
            AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
            NSManagedObjectContext *context =[appDelegate managedObjectContext];
            NSError *error;
            NSFetchRequest *request1 = [NSFetchRequest fetchRequestWithEntityName:@"QuickBlocks"];
            NSPredicate *pred2 =[NSPredicate predicateWithFormat:@"(name = %@)",arrayQuickBlocks[delblock]];
            [request1 setPredicate:pred2];
            NSArray *objects1 = [context executeFetchRequest:request1 error:&error];
            if (objects1 == nil) {
                // handle error
            } else {
                for (NSManagedObject *object in objects1) {
                    [context deleteObject:object];
                }
                [context save:&error];
                [self getDataFromDataBase];
            }
            
            
        }
        
        else if (buttonIndex==2)
        {
            
            [popover dismissPopoverAnimated:YES];
 

            
            quickBlocksButtonsView *viewControllerForPopover = [self.storyboard instantiateViewControllerWithIdentifier:@"quickBlocksButtonsView"];
//            [self.navigationController pushViewController:viewControllerForPopover animated:YES];
            popover = [[UIPopoverController alloc] initWithContentViewController:viewControllerForPopover];
            [popover setPopoverContentSize:CGSizeMake(567, 500)];
            CGRect rect = CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/2, 1, 1);
            [popover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:0 animated:YES];
            viewControllerForPopover.callBack = self;
            viewControllerForPopover.isEdit=YES;
            viewControllerForPopover.str_id=arrayQuickBlocksIDEdit[delblock];
            popover.delegate=self;
            paymentdone=NO;
            
        }

        
    }
    
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    selectSearchView.hidden = YES;
    self.selectBlockSearchView.hidden = YES;
    filterview.hidden=YES;
    [moreButtonView removeFromSuperview];
    moreButtonView=nil;
    [self add_button_on_tabbar];
    
    view_ManualPriceEntry.hidden = YES;
    
}
#pragma mark - UICollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == collectionViewQuickBlocks)
    {
        return arrayQuickBlocks.count;
    }
    else if (collectionView.tag==23)
    {
        if (filterdone1)
            return farrayNextQuickButtons.count;
        else
        return arrayNextQuickButtons.count;
    }
    else
    {
        if(filterdone)
            return farrayQuickButtons.count;
        else
            return arrayQuickButtons.count;
    }
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == collectionViewQuickBlocks)
    {
        CustomCellQuickBlocks *cell = (CustomCellQuickBlocks *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
        
        cell.labelProductName.text = [arrayQuickBlocks objectAtIndex:indexPath.item];
        
        if(arrayQuickBlocksIconImages1.count)
            cell.imageViewIcon1.image = [arrayQuickBlocksIconImages1 objectAtIndex:indexPath.item];
        
        if(arrayQuickBlocksIconImages2.count)
            cell.imageViewIcon2.image =  [arrayQuickBlocksIconImages2 objectAtIndex:indexPath.item];
        
        if(arrayQuickBlocksIconImages3.count)
            cell.imageViewIcon3.image =  [arrayQuickBlocksIconImages3 objectAtIndex:indexPath.item];
        
        if(arrayQuickBlocksIconImages4.count)
            cell.imageViewIcon4.image =  [arrayQuickBlocksIconImages4 objectAtIndex:indexPath.item];
        
        
        
        if(indexPath.item==selectedblock)
            cell.backMainImage.image=[UIImage imageNamed:@"BlockSelectedIcon.png"];
        else
            cell.backMainImage.image=[UIImage imageNamed:@"BlockIcon.png"];
        
        return cell;
    }
    else if (collectionView.tag==23)
    {
        if (filterdone1) {
            
        quickBlocknextcell *cell = (quickBlocknextcell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"quickBlockNext" forIndexPath:indexPath];
        cell.labelProductName.text = [farrayNextQuickButtons objectAtIndex:indexPath.item];
            cell.labelAddItem.hidden = YES;
//        cell.labelAddItem.text = [NSString stringWithFormat:@"%@", [Language get:@"Add Item" alter:@"!Add Item"]];
        
        
        if([arrayNextQuickButtonsVariantCount[indexPath.item] integerValue]==0)
        {
            cell.labelProductVariantCount.hidden=YES;
            cell.imageProductVariantCount.hidden=YES;
        }
        else
        {
            cell.labelProductVariantCount.hidden=NO;
            cell.imageProductVariantCount.hidden=NO;
            cell.labelProductVariantCount.text=[NSString stringWithFormat:@"+%@ %@",arrayNextQuickButtonsVariantCount[indexPath.item], [Language get:@"More" alter:@"!More"] ];
        }
        
        
        cell.imageViewProduct.image = [farrayNextQuickButtonsImages objectAtIndex:indexPath.item];
        
        collectionQuickButtons.allowsMultipleSelection = YES;
        
        return cell;
        
    }
        else
        {
            quickBlocknextcell *cell = (quickBlocknextcell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"quickBlockNext" forIndexPath:indexPath];
            cell.labelProductName.text = [arrayNextQuickButtons objectAtIndex:indexPath.item];
//            cell.labelAddItem.text = [NSString stringWithFormat:@"%@", [Language get:@"Add Item" alter:@"!Add Item"]];
            
            
            if([arrayNextQuickButtonsVariantCount[indexPath.item] integerValue]==0)
            {
                cell.labelProductVariantCount.hidden=YES;
                cell.imageProductVariantCount.hidden=YES;
            }
            else
            {
                cell.labelProductVariantCount.hidden=NO;
                cell.imageProductVariantCount.hidden=NO;
                cell.labelProductVariantCount.text=[NSString stringWithFormat:@"+%@ %@",arrayNextQuickButtonsVariantCount[indexPath.item], [Language get:@"More" alter:@"!More"] ];
            }
            
            
            cell.imageViewProduct.image = [arrayNextQuickButtonsImages objectAtIndex:indexPath.item];
            
            collectionQuickButtons.allowsMultipleSelection = YES;
            
            
            return cell;
        }
        
        
    }
    else
    {
        CustomCellQuickButtons *cell = (CustomCellQuickButtons *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifierQuickButtons" forIndexPath:indexPath];
        if(filterdone)
        {
            
            cell.labelProductName.text = [farrayQuickButtons objectAtIndex:indexPath.item];
            
            cell.imageViewProduct.image =  [farrayQuickButtonsImages objectAtIndex:indexPath.item];
            
            //cell.labelProductVariantCount.text=[NSString stringWithFormat:@"+%@ more",farrayQuickButtonsVariantCount[indexPath.item] ];
            if([arrayQuickButtonsVariantCount[indexPath.item] integerValue]==0)
            {
                cell.labelProductVariantCount.hidden=YES;
                cell.imageProductVariantCount.hidden=YES;
            }
            else
            {
                cell.labelProductVariantCount.hidden=NO;
                cell.imageProductVariantCount.hidden=NO;
                
                if(![arrayQuickButtonsVariantCount[indexPath.item] isEqual:NULL] && ![arrayQuickButtonsVariantCount[indexPath.item] isEqual:[NSNull null]] &&![arrayQuickButtonsVariantCount[indexPath.item] isEqual:nil]&&arrayQuickButtonsVariantCount[indexPath.item]!=nil)
                {
                    
                    cell.labelProductVariantCount.text=[NSString stringWithFormat:@"+%@ %@",arrayQuickButtonsVariantCount[indexPath.item], [Language get:@"More" alter:@"!More"] ];
                }
                else
                {
                    cell.labelProductVariantCount.text=[NSString stringWithFormat:@"+1 %@",[Language get:@"More" alter:@"!More"] ];
                }
    
            }
            
            cell.addItembutton.tag=indexPath.row;
//            [cell.addItembutton setTitle:[Language get:@"Add Item" alter:@"!Add Item"] forState:UIControlStateNormal];
            [cell.addItembutton addTarget:self action:@selector(addItemToCart:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        else
        {
            cell.labelProductName.text = [arrayQuickButtons objectAtIndex:indexPath.item];
            
            cell.imageViewProduct.image =  [arrayQuickButtonsImages objectAtIndex:indexPath.item];
            
            //cell.labelProductVariantCount.text=[NSString stringWithFormat:@"+%@ more",arrayQuickButtonsVariantCount[indexPath.item] ];
            if([arrayQuickButtonsVariantCount[indexPath.item] integerValue]==0)
            {
                cell.labelProductVariantCount.hidden=YES;
                cell.imageProductVariantCount.hidden=YES;
            }
            else
            {
                cell.labelProductVariantCount.hidden=NO;
                cell.imageProductVariantCount.hidden=NO;
                
//                if(![arrayNextQuickButtonsVariantCount[indexPath.item] isEqual:NULL] && ![arrayNextQuickButtonsVariantCount[indexPath.item] isEqual:[NSNull null]] &&![arrayNextQuickButtonsVariantCount[indexPath.item] isEqual:nil]&&arrayNextQuickButtonsVariantCount[indexPath.item]!=nil)
//                {
//             
//                cell.labelProductVariantCount.text=[NSString stringWithFormat:@"+%@ %@",arrayNextQuickButtonsVariantCount[indexPath.item], [Language get:@"More" alter:@"!More"] ];
//                }
//                else
//                {
//                cell.labelProductVariantCount.text=[NSString stringWithFormat:@"+1 %@",[Language get:@"More" alter:@"!More"] ];
//                }
                
                if(![arrayQuickButtonsVariantCount[indexPath.item] isEqual:NULL] && ![arrayQuickButtonsVariantCount[indexPath.item] isEqual:[NSNull null]] &&![arrayQuickButtonsVariantCount[indexPath.item] isEqual:nil]&&arrayQuickButtonsVariantCount[indexPath.item]!=nil)
                {
                    
                    cell.labelProductVariantCount.text=[NSString stringWithFormat:@"+%@ %@",arrayQuickButtonsVariantCount[indexPath.item], [Language get:@"More" alter:@"!More"] ];
                }
                else
                {
                    cell.labelProductVariantCount.text=[NSString stringWithFormat:@"+1 %@",[Language get:@"More" alter:@"!More"] ];
                }
                }
            
            
            cell.addItembutton.tag=indexPath.row;
//            [cell.addItembutton setTitle:[Language get:@"Add Item" alter:@"!Add Item"] forState:UIControlStateNormal];
            [cell.addItembutton addTarget:self action:@selector(addItemToCart:) forControlEvents:UIControlEventTouchUpInside];
            
            collectionQuickButtons.allowsMultipleSelection = YES;
        }
        return cell;
    }
    
    return NO;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Returns nil
    if (collectionView == collectionViewQuickBlocks)
    {
        
        selectedblock=(int)indexPath.item;
  
        [collectionViewQuickBlocks reloadData];
        [self getBlockDetailFromDataBase];
        
    }
    else if (collectionView.tag==23)
    {
        selectedblock=-1;
        
        if([arrayNextQuickButtonsVariantCount[indexPath.item] integerValue]>=1)
        {
            selectedVariantId=arrayNextQuickButtonsIds[indexPath.row];
            arrayVariantName=[[NSMutableArray alloc]init];
            arrayVariantPrice=[[NSMutableArray alloc]init];
            
            [UIView beginAnimations:@"animate" context:nil];
            [UIView setAnimationDuration:0.35f];
            [UIView setAnimationBeginsFromCurrentState: NO];
            CGRect frame = variantView.frame;
            frame.origin.y = 60;
            [variantView setFrame:frame];
            [UIView commitAnimations];
            
            AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
            NSManagedObjectContext *context =[appDelegate managedObjectContext];
            NSEntityDescription *entityDesc2 =[NSEntityDescription entityForName:@"Variant" inManagedObjectContext:context];
            NSFetchRequest *request2 = [[NSFetchRequest alloc] init];
            [request2 setEntity:entityDesc2];
            NSPredicate *pred1 =[NSPredicate predicateWithFormat:@"(article_id = %@)",arrayNextQuickButtonsIds[indexPath.row]];
            [request2 setPredicate:pred1];
            NSError *error;
            NSArray *objects2 = [context executeFetchRequest:request2 error:&error];
            
            arrayVariantName =[objects2 valueForKey:@"name"];
            arrayVariantPrice =[objects2 valueForKey:@"price"];
            
            
            [array_tableCheck removeAllObjects];
            for (int i =0; i <[arrayVariantName count] ; i++) {
                
                NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
                
                [dict setValue:@"NO" forKey:@"check"];
                [dict setValue:[NSString stringWithFormat:@"%d",i] forKey:@"sno"];
                [dict setValue:[arrayVariantName objectAtIndex:i] forKey:@"name"];
                
                [array_tableCheck addObject:dict];
                
            }
            
            [tableview_varient reloadData];

            
            
        }
        else{
            
            
            AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
            NSManagedObjectContext *context =[appDelegate managedObjectContext];
            
            NSEntityDescription *entityDesc1 =[NSEntityDescription entityForName:@"Cart" inManagedObjectContext:context];
            NSFetchRequest *request11 = [[NSFetchRequest alloc] init];
            [request11 setEntity:entityDesc1];
            
            NSPredicate *pred1 =[NSPredicate predicateWithFormat:@"(article_id = %@)",arrayNextQuickButtonsIds[indexPath.item]];
            [request11 setPredicate:pred1];
            
            NSError *error;
            NSArray *objects11 = [context executeFetchRequest:request11 error:&error];
            
            
            if ([objects11 count] == 0) {
                
                NSEntityDescription *entityDesc =[NSEntityDescription entityForName:@"Article" inManagedObjectContext:context];
                NSFetchRequest *request = [[NSFetchRequest alloc] init];
                [request setEntity:entityDesc];
                NSPredicate *pred =[NSPredicate predicateWithFormat:@"(article_no = %@)",arrayNextQuickButtonsIds[indexPath.item]];
                [request setPredicate:pred];
                
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
                    [newContact setValue:[matches valueForKey:@"name" ] forKey:@"name"];
                    [newContact setValue:[matches valueForKey:@"article_img_url"] forKey:@"image"];
                    [newContact setValue:[NSNumber numberWithInt:1] forKey:@"count"];
                    [newContact setValue:arrayNextQuickButtonsIds[indexPath.item] forKey:@"article_id"];
                    [newContact setValue:[matches valueForKey:@"discount"] forKey:@"discount"];
                    [context save:&error];
                    
                }
                
                
                
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
    
    [self getCartData];
}

#pragma mark - UITextField Delegates

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
}


#pragma mark - Memory Handling

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITableView Datasource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView.tag==221)
    {
        return arrayVariantName.count;
    }
    else{
        
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
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.tag==221)
    {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        }
        
        UIButton *uim=[[UIButton alloc]initWithFrame:CGRectMake(460, 0 ,45, 45)];
        uim.tag=indexPath.row;
        if([[[array_tableCheck objectAtIndex:indexPath.row]valueForKey:@"check"] isEqualToString:@"YES"])
            [uim setImage:[UIImage imageNamed:@"Tick-ico.png"] forState:UIControlStateNormal];
        else
            [uim setImage:[UIImage imageNamed:@"Check-box.png"] forState:UIControlStateNormal];
        
        [uim addTarget:self action:@selector(buttonclickcheck:) forControlEvents:UIControlEventTouchUpInside];
        
        //        cell.accessoryView =uim;
        //        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //        cell.backgroundColor=[UIColor clearColor];
        [cell addSubview:uim];
        
        UIFont * myFont = [UIFont fontWithName:@"Arial" size:18];
        CGRect labelFrame = CGRectMake (30, 10, 150, 25);
        UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
        [label setFont:myFont];
        label.lineBreakMode=NSLineBreakByWordWrapping;
        label.numberOfLines=5;
        label.textColor=[UIColor grayColor];
        label.backgroundColor=[UIColor clearColor];
        [label setText:arrayVariantName[indexPath.row]];
        [cell addSubview:label];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake (250, 10, 180, 20)];
        [label1 setFont:myFont];
        label1.textAlignment=NSTextAlignmentRight;
        label1.textColor=[UIColor grayColor];
        label1.backgroundColor=[UIColor clearColor];
        [label1 setText:[NSString stringWithFormat:@"%@ %@",currencySign,arrayVariantPrice[indexPath.row]]];
        [cell addSubview:label1];
        
        //        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        
        
        
        return cell;
        
    }
    else
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
     
        if(indexPath.row==arrayProductName.count)
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
            NSManagedObject *person = (NSManagedObject *)[objects2 objectAtIndex:0];
            
            cell.imageViewProduct.image = [UIImage imageNamed:@"coupon-512.png"];
            cell.labelProductName.text =[person valueForKey:@"discription"];
            cell.labelProductQuantity.text=@"";
            cell.buttonIncrease.hidden=YES;
            cell.buttonDecrease.hidden=YES;
            
            
            float cc;
            if([[person valueForKey:@"type"] isEqualToString:currencySign])
            {
                cell.labelProductPrice.text=[NSString stringWithFormat:@"%.02f",[[person valueForKey:@"discount"] floatValue]];
                cc=[[person valueForKey:@"discount"] floatValue];
            }
            else
            {
                cell.labelProductPrice.text=[NSString stringWithFormat:@"%.02f",((total*[[person valueForKey:@"discount"] floatValue])/100)];
                cc=((total*[[person valueForKey:@"discount"] floatValue])/100);
                totalVatLbl.text=[NSString stringWithFormat:@"%@ %@ %.02f %@",[Language get:@"Including" alter:@"!Including"],currencySign,totalvat-((totalvat*[[person valueForKey:@"discount"] floatValue])/100), [Language get:@"VAT" alter:@"!VAt"]];
                
                if (totalvat-((totalvat*[[person valueForKey:@"discount"] floatValue])/100)==0.00) {
                    totalVatLbl.text=[NSString stringWithFormat:@"%@",[Language get:@"Including $0.00 VAT" alter:@"!Including $0.00 VAT"]];
                }
            }
            
            if(total-cc<0)
                totalPriceLbl.text=[NSString stringWithFormat:@"-%@ %0.2f",currencySign,fabsf(total-cc)];
            else
                totalPriceLbl.text=[NSString stringWithFormat:@"%@ %0.2f",currencySign,total-cc];
            
            
            cell.labelProductPrice.text=[NSString stringWithFormat:@"-%@ %@",currencySign,cell.labelProductPrice.text];
            
        }
        else
        {
            cell.imageViewProduct.image = [arrayProductImage objectAtIndex:indexPath.row];
            
            
            cell.labelProductName.text = [arrayProductName objectAtIndex:indexPath.row];
            
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
            
            if([UIImagePNGRepresentation(arrayProductImage[indexPath.row]) isEqualToData: UIImagePNGRepresentation([UIImage imageNamed:@"ca.png"])])
            {
                cell.buttonIncrease.hidden=YES;
                cell.buttonDecrease.hidden=YES;
                cell.labelProductQuantity.text =@"";
            }
            else
            {
                cell.labelProductQuantity.text = [NSString stringWithFormat:@"%@",[arrayProductQuantity objectAtIndex:indexPath.row]];
                cell.buttonIncrease.hidden=NO;
                cell.buttonDecrease.hidden=NO;
            }
            cell.buttonIncrease.tag=indexPath.row;
            cell.buttonDecrease.tag=indexPath.row;
            [cell.buttonIncrease addTarget:self action:@selector(IncreaseAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.buttonDecrease addTarget:self action:@selector(decreaseAction:) forControlEvents:UIControlEventTouchUpInside];
            
            cell.labelComment.text=arrayproductcomment[indexPath.row];
        }
        UIView *bgColorView = [[UIView alloc] init];
        bgColorView.backgroundColor = [UIColor colorWithRed:111.0f/255.0f green:60.0f/255.0f blue:135.0f/255.0f alpha:1.0];
        [cell setSelectedBackgroundView:nil];
        
        
        return cell;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.tag==221)
    {
        variantFeild.text=arrayVariantName[indexPath.row];
        [popview removeFromSuperview];
    }
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
    
    [self getDataFromDataBase];
    [self getCartData];
    [self Settitles];
    [popover dismissPopoverAnimated:YES];
    
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
- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController
{
    return NO;
}
-(void)getDataFromDataBase
{
    arrayQuickButtons = [[NSMutableArray alloc]init];
    arrayQuickButtonsImages = [[NSMutableArray alloc]init];
    arrayQuickButtonsVariantCount= [[NSMutableArray alloc]init];
    arrayQuickButtonsIds= [[NSMutableArray alloc]init];
    
    arrayQuickBlocksIDEdit=[[NSMutableArray alloc]init];
    arrayQuickButtonsIDEdit=[[NSMutableArray alloc]init];
    
    arrayQuickBlocks= [[NSMutableArray alloc]init];
    arrayQuickBlocksIconImages1= [[NSMutableArray alloc]init];
    arrayQuickBlocksIconImages2= [[NSMutableArray alloc]init];
    arrayQuickBlocksIconImages3= [[NSMutableArray alloc]init];
    arrayQuickBlocksIconImages4= [[NSMutableArray alloc]init];
    
    arrayQuickBlocksID= [[NSMutableArray alloc]init];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context =[appDelegate managedObjectContext];
    NSEntityDescription *entityDesc =[NSEntityDescription entityForName:@"QuickBlocks" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    NSLog(@"%d",(int)objects.count);
    
    for(int i=0;i<objects.count;i++)
    {
        NSManagedObject *person = (NSManagedObject *)[objects objectAtIndex:i];
        
        NSString *dumyno=[person valueForKey:@"quick_article_nos"];
        
        if (![dumyno isEqualToString:@""]) {
            NSArray* foo = [dumyno componentsSeparatedByString: @","];
          
            if ([foo count] != 0)
            {
                if(foo.count==1)
                {
                    [arrayQuickButtonsIDEdit addObject:[person valueForKey:@"id"]];
                    [arrayQuickButtons addObject:[person valueForKey:@"name"]];
                    [arrayQuickButtonsIds addObject:dumyno];
                    
                    
                    NSEntityDescription *entityDesc1 =[NSEntityDescription entityForName:@"Article" inManagedObjectContext:context];
                    NSFetchRequest *request1 = [[NSFetchRequest alloc] init];
                    [request1 setEntity:entityDesc1];
                    NSPredicate *pred =[NSPredicate predicateWithFormat:@"(article_no = %@)",dumyno];
                    [request1 setPredicate:pred];
                    NSArray *objects1 = [context executeFetchRequest:request1 error:&error];
                    
                    
                    NSManagedObject *person1 = (NSManagedObject *)[objects1 objectAtIndex:0];
                    NSData *da=[person1 valueForKey:@"article_img_url"];
                    UIImage *img=[[UIImage alloc] initWithData:da];
                    [arrayQuickButtonsImages addObject:img];
                    
                    
                    NSEntityDescription *entityDesc2 =[NSEntityDescription entityForName:@"Variant" inManagedObjectContext:context];
                    NSFetchRequest *request2 = [[NSFetchRequest alloc] init];
                    [request2 setEntity:entityDesc2];
                    NSPredicate *pred1 =[NSPredicate predicateWithFormat:@"(article_id = %@)",dumyno];
                    [request2 setPredicate:pred1];
                    NSArray *objects2 = [context executeFetchRequest:request2 error:&error];
                    if([NSString stringWithFormat:@"%d",(int)objects2.count]!=nil)
                    {
                        [arrayQuickButtonsVariantCount addObject:[NSString stringWithFormat:@"%d",(int)objects2.count]];
                    }
                    else
                    {
                        [arrayQuickButtonsVariantCount addObject:[NSString stringWithFormat:@"1"]];
                    }

                }
                else
                {
                    [arrayQuickBlocksIDEdit addObject:[person valueForKey:@"id"]];
                    [arrayQuickBlocks addObject:[person valueForKey:@"name"]];
                    [arrayQuickBlocksID addObject:dumyno];
                    
                    for(int j=0;j<foo.count;j++)
                    {
                        
                        NSEntityDescription *entityDesc1 =[NSEntityDescription entityForName:@"Article" inManagedObjectContext:context];
                        NSFetchRequest *request1 = [[NSFetchRequest alloc] init];
                        [request1 setEntity:entityDesc1];
                        NSPredicate *pred =[NSPredicate predicateWithFormat:@"(article_no = %@)",foo[j]];
                        [request1 setPredicate:pred];
                        NSArray *objects1 = [context executeFetchRequest:request1 error:&error];
                        if(objects1.count>0)
                        {
                            NSManagedObject *person1 = (NSManagedObject *)[objects1 objectAtIndex:0];
                            NSData *da=[person1 valueForKey:@"article_img_url"];
                            UIImage *img=[[UIImage alloc] initWithData:da];
                            
                            
                            if(j==0)
                            {
                                [arrayQuickBlocksIconImages1 addObject:img];
                            }
                            else if(j==1)
                            {
                                [arrayQuickBlocksIconImages2 addObject:img];
                            }
                            else if(j==2)
                            {
                                [arrayQuickBlocksIconImages3 addObject:img];
                            }
                            else if(j==3)
                            {
                                [arrayQuickBlocksIconImages4 addObject:img];
                            }
                            else
                                break;
                            
                        }
                        
                        
                    }
                    
                    
                    if(foo.count<4)
                    {
                        [arrayQuickBlocksIconImages3 addObject:[UIImage imageNamed:@"SelectBoxBG.png"]];
                        [arrayQuickBlocksIconImages4 addObject:[UIImage imageNamed:@"SelectBoxBG.png"]];
                    }
                    else if(foo.count<3)
                    {
                        [arrayQuickBlocksIconImages4 addObject:[UIImage imageNamed:@"SelectBoxBG.png"]];
                    }
                    [collectionViewQuickBlocks reloadData];
                }
            }
            
        }
        
        
    }
    [collectionQuickButtons reloadData];
    [collectionViewQuickBlocks reloadData];
    
    
}
-(void)getBlockDetailFromDataBase
{
    //
    arrayNextQuickButtons = [[NSMutableArray alloc]init];
    arrayNextQuickButtonsImages = [[NSMutableArray alloc]init];
    arrayNextQuickButtonsVariantCount= [[NSMutableArray alloc]init];
    arrayNextQuickButtonsIds= [[NSMutableArray alloc]init];
    
    NSString *st=arrayQuickBlocks[selectedblock];
    nextlabel.text=[NSString stringWithFormat:@"%@",st];
    NSString *dumyno=arrayQuickBlocksID[selectedblock];
    NSArray* foo = [dumyno componentsSeparatedByString: @","];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context =[appDelegate managedObjectContext];
    NSError *error;
    
    for(int j=0;j<foo.count;j++)
    {
        
        [arrayNextQuickButtonsIds addObject:foo[j]];
        
        
        NSEntityDescription *entityDesc1 =[NSEntityDescription entityForName:@"Article" inManagedObjectContext:context];
        NSFetchRequest *request1 = [[NSFetchRequest alloc] init];
        [request1 setEntity:entityDesc1];
        NSPredicate *pred =[NSPredicate predicateWithFormat:@"(article_no = %@)",foo[j]];
        [request1 setPredicate:pred];
        NSArray *objects1 = [context executeFetchRequest:request1 error:&error];
        
        NSManagedObject *person1 = (NSManagedObject *)[objects1 objectAtIndex:0];
        [arrayNextQuickButtons addObject:[CommonMethods validateDictionaryValueForKey:[person1 valueForKey:@"name"]]?[person1 valueForKey:@"name"]:@""];
       // [arrayNextQuickButtons addObject:[person1 valueForKey:@"name"]];
        NSData *da=[person1 valueForKey:@"article_img_url"];
        
        if (da != nil && da.length>0)
        {
            UIImage *img=[[UIImage alloc] initWithData:da];
            [arrayNextQuickButtonsImages addObject:img];
        }
        else
        {
            UIImage *img=[UIImage new];
            [arrayNextQuickButtonsImages addObject:img];
        }
        
        
        
        NSEntityDescription *entityDesc2 =[NSEntityDescription entityForName:@"Variant" inManagedObjectContext:context];
        NSFetchRequest *request2 = [[NSFetchRequest alloc] init];
        [request2 setEntity:entityDesc2];
        NSPredicate *pred1 =[NSPredicate predicateWithFormat:@"(article_id = %@)",foo[j]];
        [request2 setPredicate:pred1];
        NSArray *objects2 = [context executeFetchRequest:request2 error:&error];
//        [arrayNextQuickButtonsVariantCount addObject:[NSString stringWithFormat:@"%d",(int)objects2.count]];
        if([NSString stringWithFormat:@"%d",(int)objects2.count]!=nil){
            [arrayNextQuickButtonsVariantCount addObject:[NSString stringWithFormat:@"%d",(int)objects2.count]];
        }
        else
        {
            [arrayNextQuickButtonsVariantCount addObject:[NSString stringWithFormat:@"1"]];
        }
    }
    [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(targetMethod:)userInfo:nil repeats:NO];
}

-(void)getCartData
{
    [self.view endEditing:YES];
    
    {
        totalvat=0.0;
        total=0.0;
        arrayProductImage=[[NSMutableArray alloc]init];
        arrayProductName=[[NSMutableArray alloc]init];
        arrayProductQuantity=[[NSMutableArray alloc]init];
        arrayProductPrice=[[NSMutableArray alloc]init];
        arrayProductVat=[[NSMutableArray alloc]init];
        arrayProductID=[[NSMutableArray alloc]init];
        arrayProductDiscount=[[NSMutableArray alloc]init];
        arrayProductdiscountType=[[NSMutableArray alloc]init];
        arrayBarcode=[[NSMutableArray alloc]init];

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
     
            if (![[person valueForKey:@"image"] isEqual:NULL] && ![[person valueForKey:@"image"] isEqual:[NSNull null]] &&![[person valueForKey:@"image"] isEqual:nil]&&[person valueForKey:@"image"]!=nil)
            {
                NSData *da=[person valueForKey:@"image"];
                UIImage *img=[[UIImage alloc] initWithData:da];
                [arrayProductImage addObject:img];
            }
            else
            {
                [arrayProductImage addObject:@""];
            }
            if (![[person valueForKey:@"name"] isEqual:NULL] && ![[person valueForKey:@"name"] isEqual:[NSNull null]] &&![[person valueForKey:@"name"] isEqual:nil]&&[person valueForKey:@"name"]!=nil)
            {
                [arrayProductName addObject:[person valueForKey:@"name"]];
            }
            
            else
            {
                [arrayProductName addObject:@""];
            }
            if (![[person valueForKey:@"count"] isEqual:NULL] && ![[person valueForKey:@"count"] isEqual:[NSNull null]] &&![[person valueForKey:@"count"] isEqual:nil]&&[person valueForKey:@"count"]!=nil)
            {
                [arrayProductQuantity addObject:[person valueForKey:@"count"]];
            }
            else
            {
                [arrayProductQuantity addObject:@""];
            }
            
            if (![[person valueForKey:@"price"] isEqual:NULL] && ![[person valueForKey:@"price"] isEqual:[NSNull null]] &&![[person valueForKey:@"price"] isEqual:nil]&&[person valueForKey:@"price"]!=nil)
            {
                [arrayProductPrice addObject:[person valueForKey:@"price"]];
            }
            else
            {
                [arrayProductPrice addObject:@"0"];
            }
            
            if (![[person valueForKey:@"vat"] isEqual:NULL] && ![[person valueForKey:@"vat"] isEqual:[NSNull null]] &&![[person valueForKey:@"vat"] isEqual:nil]&&[person valueForKey:@"vat"]!=nil)
            {
                [arrayProductVat addObject:[person valueForKey:@"vat"]];
            }
            else
            {
                [arrayProductVat addObject:@""];
            }
            if (![[person valueForKey:@"article_id"] isEqual:NULL] && ![[person valueForKey:@"article_id"] isEqual:[NSNull null]] &&![[person valueForKey:@"article_id"] isEqual:nil]&&[person valueForKey:@"article_id"]!=nil)
            {
                [arrayProductID addObject:[person valueForKey:@"article_id"]];
            }
            else
            {
                [arrayProductID addObject:@""];
            }
            
//            if (![[person valueForKey:@"barcode"] isEqual:NULL] && ![[person valueForKey:@"barcode"] isEqual:[NSNull null]] &&![[person valueForKey:@"barcode"] isEqual:nil]&&[person valueForKey:@"barcode"]!=nil)
//            {
//                [arrayBarcode addObject:[person valueForKey:@"barcode"]];
//            }
//            else
//            {
//                [arrayBarcode addObject:@""];
//            }
            if (![[person valueForKey:@"discount"] isEqual:NULL] && ![[person valueForKey:@"discount"] isEqual:[NSNull null]] &&![[person valueForKey:@"discount"] isEqual:nil]&&[person valueForKey:@"discount"]!=nil)
            {
                [arrayProductDiscount addObject:[person valueForKey:@"discount"]];
            }
            else
            {
                [arrayProductDiscount addObject:@""];
            }
            if([person valueForKey:@"discountType"] == nil)
            {
                [arrayProductdiscountType addObject:@"%"];
            }
            else
            {
                [arrayProductdiscountType addObject:[person valueForKey:@"discountType"]];
            }
            float discountperproduct;
            
            
            if([[person valueForKey:@"discountType"] isEqualToString:@"%"]|| [person valueForKey:@"discountType"] == nil)
            {
                discountperproduct=([[arrayProductPrice objectAtIndex:i]floatValue]*[[person valueForKey:@"count"]intValue]*[[person valueForKey:@"discount"]floatValue])/100;
            }
            else
            {
                discountperproduct=[[person valueForKey:@"discount"]floatValue];
            }
            
            if (![[arrayProductPrice objectAtIndex:i] isEqual:NULL] && ![[arrayProductPrice objectAtIndex:i] isEqual:[NSNull null]] &&![[arrayProductPrice objectAtIndex:i] isEqual:nil]&&[arrayProductPrice objectAtIndex:i]!=nil)
            {
                total=(([[arrayProductPrice objectAtIndex:i] floatValue] *[[person valueForKey:@"count"] integerValue])-discountperproduct) + total;
                
                zzzz = (([[arrayProductPrice objectAtIndex:i] floatValue]*[[person valueForKey:@"count"] integerValue])-discountperproduct) / (1 + [[person valueForKey:@"vat"] floatValue]/100);
                
                zzzz=(([[arrayProductPrice objectAtIndex:i] floatValue] *[[person valueForKey:@"count"] integerValue])-discountperproduct)-zzzz;
                
                totalvat= zzzz  + totalvat;
            }
            else
            {
                totalvat=0;
            }
            
        
            float totalvatnew=0.0;
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
    
//    selectedVariantname=@"";
    
}

-(void)addItemToCart:(UIButton *)button
{
    
    selectedVariantname=@"";
    
    
    if([arrayQuickButtonsVariantCount[button.tag] integerValue]>=1)
    {
        selectedVariantId=arrayQuickButtonsIds[button.tag];
        arrayVariantName=[[NSMutableArray alloc]init];
        arrayVariantPrice=[[NSMutableArray alloc]init];
        
        [UIView beginAnimations:@"animate" context:nil];
        [UIView setAnimationDuration:0.35f];
        [UIView setAnimationBeginsFromCurrentState: NO];
        CGRect frame = variantView.frame;
        frame.origin.y = 60;
        [variantView setFrame:frame];
        [UIView commitAnimations];
        
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context =[appDelegate managedObjectContext];
        NSEntityDescription *entityDesc2 =[NSEntityDescription entityForName:@"Variant" inManagedObjectContext:context];
        NSFetchRequest *request2 = [[NSFetchRequest alloc] init];
        [request2 setEntity:entityDesc2];
        NSPredicate *pred1 =[NSPredicate predicateWithFormat:@"(article_id = %@)",arrayQuickButtonsIds[button.tag]];
        [request2 setPredicate:pred1];
        NSError *error;
        NSArray *objects2 = [context executeFetchRequest:request2 error:&error];
        
        
        
        arrayVariantName =[objects2 valueForKey:@"name"];
        arrayVariantPrice =[objects2 valueForKey:@"price"];
        
        
        [array_tableCheck removeAllObjects];
        for (int i =0; i <[arrayVariantName count] ; i++) {
            
            NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
            
            [dict setValue:@"NO" forKey:@"check"];
            [dict setValue:[NSString stringWithFormat:@"%d",i] forKey:@"sno"];
            [dict setValue:[arrayVariantName objectAtIndex:i] forKey:@"name"];
            
            [array_tableCheck addObject:dict];
            
        }
        
        [tableview_varient reloadData];
    }
    else
    {
        
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context =[appDelegate managedObjectContext];
        
        NSEntityDescription *entityDesc1 =[NSEntityDescription entityForName:@"Cart" inManagedObjectContext:context];
        NSFetchRequest *request11 = [[NSFetchRequest alloc] init];
        [request11 setEntity:entityDesc1];
        
        NSPredicate *pred1 =[NSPredicate predicateWithFormat:@"(article_id = %@)",arrayQuickButtonsIds[button.tag]];
        [request11 setPredicate:pred1];
        
        NSError *error;
        NSArray *objects11 = [context executeFetchRequest:request11 error:&error];
        
        
        if ([objects11 count] == 0) {
            
            NSEntityDescription *entityDesc =[NSEntityDescription entityForName:@"Article" inManagedObjectContext:context];
            NSFetchRequest *request = [[NSFetchRequest alloc] init];
            [request setEntity:entityDesc];
            NSPredicate *pred =[NSPredicate predicateWithFormat:@"(article_no = %@)",arrayQuickButtonsIds[button.tag]];
            [request setPredicate:pred];
            
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
                [newContact setValue:[matches valueForKey:@"name" ] forKey:@"name"];
                [newContact setValue:[matches valueForKey:@"article_img_url"] forKey:@"image"];
                [newContact setValue:[NSNumber numberWithInt:1] forKey:@"count"];
                [newContact setValue:arrayQuickButtonsIds[button.tag] forKey:@"article_id"];
                [newContact setValue:[NSNumber numberWithInt:0] forKey:@"discount"];
                [newContact setValue:[NSNumber numberWithInt:[[matches valueForKey:@"discount"] floatValue]] forKey:@"discount"];
                [newContact setValue:[matches valueForKey:@"barcode" ] forKey:@"barcode"];

                [context save:&error];
            }
            
            
            
        }
        else
        {
            for (NSManagedObject *obj in objects11) {
                [obj setValue:[NSNumber numberWithInt:[[objects11 valueForKey:@"count"][0] intValue]+1] forKey:@"count"];
                [context save:&error];
            }
            
        }
        [self getCartData];
    }
    
    
 
}

-(void)UpdateCardData:(int)selectedIndex
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context =[appDelegate managedObjectContext];
    
    NSEntityDescription *entityDesc1 =[NSEntityDescription entityForName:@"Cart" inManagedObjectContext:context];
    NSFetchRequest *request11 = [[NSFetchRequest alloc] init];
    [request11 setEntity:entityDesc1];
    
    NSPredicate *pred1 =[NSPredicate predicateWithFormat:@"(article_id = %@)",arrayQuickButtonsIds[selectedIndex]];
    [request11 setPredicate:pred1];
    
    NSError *error;
    NSArray *objects11 = [context executeFetchRequest:request11 error:&error];
    
    for (NSManagedObject *obj in objects11) {
        
        int price = [txt_Price.text intValue];
        [obj setValue:[NSNumber numberWithInt:price] forKey:@"price"];
        [context save:&error];
    }
    
    [self getCartData];
    
}

-(IBAction)variantAdditemandCancelbtn:(UIButton*)sender
{
    
    //    selectedVariantname=variantFeild.text;
    
    //    selectedVariantname=[[array_tableCheck objectAtIndex:selIndex] valueForKey:@"name"];
    
    if ([selectedVariantname isEqualToString:@""])
    {
        if(sender.tag==2)
        {
            [UIView beginAnimations:@"animate" context:nil];
            [UIView setAnimationDuration:0.35f];
            [UIView setAnimationBeginsFromCurrentState: NO];
            CGRect frame = variantView.frame;
            frame.origin.y = 2024;
            [variantView setFrame:frame];
            [UIView commitAnimations];
        }
        else
        {
            UIAlertView *al=[[UIAlertView alloc]initWithTitle:@"ISUPOS" message:[Language get:@"Please select variant." alter:@"!Please select variant."] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [al show];
        }
        
        
        
//        selectedVariantname=@"";
    }
    else
    {
        variantFeild.text=@"";
        if(sender.tag==2)
        {
            [UIView beginAnimations:@"animate" context:nil];
            [UIView setAnimationDuration:0.35f];
            [UIView setAnimationBeginsFromCurrentState: NO];
            CGRect frame = variantView.frame;
            frame.origin.y = 2024;
            [variantView setFrame:frame];
            [UIView commitAnimations];
        }
        else
        {
            if(![selectedVariantname isEqualToString:@""])
            {
                AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
                NSManagedObjectContext *context =[appDelegate managedObjectContext];
                
                NSEntityDescription *entityDesc1 =[NSEntityDescription entityForName:@"Cart" inManagedObjectContext:context];
                NSFetchRequest *request11 = [[NSFetchRequest alloc] init];
                [request11 setEntity:entityDesc1];
                
                NSMutableArray *predicatesArray=[[NSMutableArray alloc]init];
                
                NSPredicate *predicate;
                predicate = [NSPredicate predicateWithFormat:@"(article_id = %@)",selectedVariantId];
                [predicatesArray addObject:predicate];
                
                predicate = [NSPredicate predicateWithFormat:@"(name = %@)",selectedVariantname];
                [predicatesArray addObject:predicate];
                
                if([predicatesArray count]){
                    NSPredicate * finalPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicatesArray];
                    [request11 setPredicate:finalPredicate];
                }
                
                
                NSError *error;
                NSArray *objects11 = [context executeFetchRequest:request11 error:&error];
                
                
                if ([objects11 count] == 0) {
                    
                    NSEntityDescription *entityDesc =[NSEntityDescription entityForName:@"Article" inManagedObjectContext:context];
                    NSFetchRequest *request = [[NSFetchRequest alloc] init];
                    [request setEntity:entityDesc];
                    NSPredicate *predicate;
                    predicate = [NSPredicate predicateWithFormat:@"(article_no = %@)",selectedVariantId];
                    [request setPredicate:predicate];
                    NSArray *objects = [context executeFetchRequest:request error:&error];
                    
                    
                    NSEntityDescription *entityDesc2 =[NSEntityDescription entityForName:@"Variant" inManagedObjectContext:context];
                    NSFetchRequest *request11 = [[NSFetchRequest alloc] init];
                    [request11 setEntity:entityDesc2];
                    NSMutableArray *predicatesArray=[[NSMutableArray alloc]init];
                    NSPredicate *predicate2;
                    predicate2 = [NSPredicate predicateWithFormat:@"(article_id = %@)",selectedVariantId];
                    [predicatesArray addObject:predicate2];
                    predicate2 = [NSPredicate predicateWithFormat:@"(name = %@)",selectedVariantname];
                    [predicatesArray addObject:predicate2];
                    if([predicatesArray count]){
                        NSPredicate * finalPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicatesArray];
                        [request11 setPredicate:finalPredicate];
                    }
                    NSError *error;
                    NSArray *objects2 = [context executeFetchRequest:request11 error:&error];
                    NSManagedObject *matches1 = nil;
                    if (objects2.count>0)
                    {
                        matches1=[objects2 objectAtIndex:0];
                    }
                    
                    
                    NSManagedObject *matches = nil;
                    if ([objects count] == 0) {
                        
                    }
                    else
                    {
                        matches = [objects objectAtIndex:0];
                        
                        if([[matches valueForKey:@"unit_type" ]integerValue]==1)
                        {
                            customTotal.text=[NSString stringWithFormat:@"%@ 0.00",currencySign];
                            
                            customName.text=selectedVariantname;
                            CustomAmount.text=[NSString stringWithFormat:@"%@ %0.2f / %@",currencySign,[selectedVariantPrice floatValue],[matches valueForKey:@"unitName"]];
                            customUnitName.text=[matches valueForKey:@"unitName" ];
                            customUnit.text=@"";
                            matchedprice=[[matches valueForKey:@"price"] floatValue];
                            [customUnit becomeFirstResponder];
                            [UIView beginAnimations:@"animate" context:nil];
                            [UIView setAnimationDuration:0.35f];
                            [UIView setAnimationBeginsFromCurrentState: NO];
                            CGRect frame = customUnitView.frame;
                            frame.origin.x = 0;
                            [customUnitView setFrame:frame];
                            [UIView commitAnimations];
                            
                        }
                        else
                        {
                            
                            NSManagedObject *newContact;
                            newContact = [NSEntityDescription insertNewObjectForEntityForName:@"Cart" inManagedObjectContext:context];
                            [newContact setValue:[NSNumber numberWithFloat:[[matches valueForKey:@"vat" ] floatValue]] forKey:@"vat"];
                            [newContact setValue:selectedVariantname forKey:@"name"];
                           // [newContact setValue:selectedVariantPrice forKey:@"price"];

                            [newContact setValue:[matches valueForKey:@"article_img_url"] forKey:@"image"];
                            [newContact setValue:[NSNumber numberWithInt:1] forKey:@"count"];
                            [newContact setValue:selectedVariantId forKey:@"article_id"];
                            [newContact setValue:[NSNumber numberWithInt:0] forKey:@"discount"];
                            
                            
                            //                    NSEntityDescription *entityDesc2 =[NSEntityDescription entityForName:@"Variant" inManagedObjectContext:context];
                            //                    NSFetchRequest *request11 = [[NSFetchRequest alloc] init];
                            //                    [request11 setEntity:entityDesc2];
                            //                    NSMutableArray *predicatesArray=[[NSMutableArray alloc]init];
                            //                    NSPredicate *predicate;
                            //                    predicate = [NSPredicate predicateWithFormat:@"(article_id = %@)",selectedVariantId];
                            //                    [predicatesArray addObject:predicate];
                            //                    predicate = [NSPredicate predicateWithFormat:@"(name = %@)",selectedVariantname];
                            //                    [predicatesArray addObject:predicate];
                            //                    if([predicatesArray count]){
                            //                        NSPredicate * finalPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicatesArray];
                            //                        [request11 setPredicate:finalPredicate];
                            //                    }
                            //                    NSError *error;
                            //                    NSArray *objects2 = [context executeFetchRequest:request11 error:&error];
                            //                    NSManagedObject *matches1 = nil;
                            //                    matches1=[objects2 objectAtIndex:0];
                            
                            [newContact setValue:[NSNumber numberWithFloat:[[matches1 valueForKey:@"price"] floatValue]] forKey:@"price"];
                            
                            [context save:&error];
                        }
                    }
                    
                    
                    
                }
                else
                {
                    
                    NSEntityDescription *entityDesc1 =[NSEntityDescription entityForName:@"Article" inManagedObjectContext:context];
                    NSFetchRequest *requestt = [[NSFetchRequest alloc] init];
                    [requestt setEntity:entityDesc1];
                    NSPredicate *predicate;
                    predicate = [NSPredicate predicateWithFormat:@"(article_no = %@)",selectedVariantId];
                    [requestt setPredicate:predicate];
                    NSArray *objects = [context executeFetchRequest:requestt error:&error];
                    NSManagedObject *matches = [objects objectAtIndex:0];
                    
                    
                    NSEntityDescription *entityDesc2 =[NSEntityDescription entityForName:@"Variant" inManagedObjectContext:context];
                    NSFetchRequest *request11 = [[NSFetchRequest alloc] init];
                    [request11 setEntity:entityDesc2];
                    NSMutableArray *predicatesArray=[[NSMutableArray alloc]init];
                    NSPredicate *predicate2;
                    predicate2 = [NSPredicate predicateWithFormat:@"(article_id = %@)",selectedVariantId];
                    [predicatesArray addObject:predicate2];
                    predicate2 = [NSPredicate predicateWithFormat:@"(name = %@)",selectedVariantname];
                    [predicatesArray addObject:predicate2];
                  //  predicate2 = [NSPredicate predicateWithFormat:@"(price = %@)",selectedVariantPrice];
                  //  [predicatesArray addObject:predicate2];
                    if([predicatesArray count]){
                        NSPredicate * finalPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicatesArray];
                        [request11 setPredicate:finalPredicate];
                    }
                    NSError *error;
                    NSArray *objects2 = [context executeFetchRequest:request11 error:&error];
                    NSManagedObject *matches1 = nil;
                    matches1=[objects2 objectAtIndex:0];
                    
                    if([[matches valueForKey:@"unit_type" ]integerValue]==1)
                    {
                        customName.text=selectedVariantname;
                       
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
                        
                    }
                    else
                    {
                        
                      
                        for (NSManagedObject *obj in objects11) {
                            [obj setValue:[NSNumber numberWithInt:[[objects11 valueForKey:@"count"][0] intValue]+1] forKey:@"count"];
                            [context save:&error];
                        }
                    }
                    
                    
                    
                    
                    
                }
                [UIView beginAnimations:@"animate" context:nil];
                [UIView setAnimationDuration:0.35f];
                [UIView setAnimationBeginsFromCurrentState: NO];
                CGRect frame = variantView.frame;
                frame.origin.y = 2024;
                [variantView setFrame:frame];
                [UIView commitAnimations];
            }
            else
            {
                UIAlertView *al=[[UIAlertView alloc]initWithTitle:@"ISUPOS" message:[Language get:@"Please select variant."  alter:@"!Please select variant." ]delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [al show];
            }
            
            [self getCartData];
        }
    }
    
    
    
}

-(void)buttonclickcheck:(UIButton *)sender
{
      CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tableview_varient];
    NSIndexPath *indexPath = [tableview_varient indexPathForRowAtPoint:buttonPosition];
    
    
    NSString *str_value=[[array_tableCheck objectAtIndex:indexPath.row]valueForKey:@"check"];
    NSString *str_sno=[[array_tableCheck objectAtIndex:indexPath.row]valueForKey:@"sno"];
    selectedVariantPrice=[arrayVariantPrice objectAtIndex:indexPath.row];
    

    if ([str_value isEqualToString:@"NO"]) {
        
        for(NSMutableDictionary *dict in array_tableCheck )
        {
            
            if ([[dict valueForKey:@"sno"]isEqualToString:str_sno])
            {
                [dict setObject:@"YES"  forKey:@"check"];
                selectedVariantname=[dict valueForKey:@"name"];
                
            }
            else
            {
                [dict setObject:@"NO"  forKey:@"check"];
                
            }
            
        }
        
    }
    else
    {
        
        for(NSMutableDictionary *dict in array_tableCheck )
        {
            
            
            if ([[dict valueForKey:@"sno"]isEqualToString:str_sno])
            {
                [dict setObject:@"NO"  forKey:@"check"];
                selectedVariantname=@"";
            }
            
        }
    }
    
   
    [tableview_varient reloadData];
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
            predicate = [NSPredicate predicateWithFormat:@"(article_no = %@)",selectedVariantId];
            [request setPredicate:predicate];
            NSArray *objects = [context executeFetchRequest:request error:&error];
            NSManagedObject *matches = nil;
            matches = [objects objectAtIndex:0];
            
            
            NSManagedObject *newContact;
            newContact = [NSEntityDescription insertNewObjectForEntityForName:@"Cart" inManagedObjectContext:context];
            [newContact setValue:[NSNumber numberWithFloat:[[matches valueForKey:@"vat" ] floatValue]] forKey:@"vat"];
            [newContact setValue:[NSString stringWithFormat:@"%@",selectedVariantname] forKey:@"name"];
            //[newContact setValue:[NSString stringWithFormat:@"%@  %.2f%@",selectedVariantname,[customUnit.text floatValue],customUnitName.text] forKey:@"name"];
            [newContact setValue:UIImagePNGRepresentation([UIImage imageNamed:@"ca.png"]) forKey:@"image"];
            [newContact setValue:[NSNumber numberWithInt:1] forKey:@"count"];
            [newContact setValue:selectedVariantId forKey:@"article_id"];
            [newContact setValue:[NSNumber numberWithInt:0] forKey:@"discount"];
            
            
            NSEntityDescription *entityDesc2 =[NSEntityDescription entityForName:@"Variant" inManagedObjectContext:context];
            NSFetchRequest *request11 = [[NSFetchRequest alloc] init];
            [request11 setEntity:entityDesc2];
            NSMutableArray *predicatesArray=[[NSMutableArray alloc]init];
            NSPredicate *predicate1;
            predicate1= [NSPredicate predicateWithFormat:@"(article_id = %@)",selectedVariantId];
            [predicatesArray addObject:predicate1];
            predicate1 = [NSPredicate predicateWithFormat:@"(name = %@)",selectedVariantname];
            [predicatesArray addObject:predicate1];
            if([predicatesArray count]){
                NSPredicate * finalPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicatesArray];
                [request11 setPredicate:finalPredicate];
            }
            NSArray *objects2 = [context executeFetchRequest:request11 error:&error];
            NSManagedObject *matches1 = nil;
            if (objects2.count>0)
            {
            matches1=[objects2 objectAtIndex:0];
            [newContact setValue:[NSNumber numberWithFloat:[[matches1 valueForKey:@"price"] floatValue]*[customUnit.text floatValue]] forKey:@"price"];
            }
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
#pragma mark- text feild deligate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField

{
    if(textField.tag==234)
    {
        popview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height)];
        popview.backgroundColor=[UIColor clearColor];
        
        UIView *popview1=[[UIView alloc]initWithFrame:CGRectMake(283, 270, 478,160)];
        popview1.backgroundColor=[UIColor whiteColor];
        popview1.layer.borderColor=[UIColor lightGrayColor].CGColor;
        popview1.layer.borderWidth=1.0;
        UITableView * poptable=[[UITableView alloc]initWithFrame:CGRectMake(0, 10, 475, 150) style:UITableViewStylePlain];
        poptable.tag=221;
        poptable.dataSource=self;
        poptable.delegate=self;
        poptable.backgroundColor=[UIColor clearColor];
        [poptable setBackgroundView:nil];
        poptable.separatorColor=[UIColor lightGrayColor];
        
        
        [popview1 addSubview:poptable];
        [popview addSubview:popview1];
        [variantView addSubview:popview];
        
        return NO;
        
    }
    return YES;
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
            [newContact setValue:[CommonMethods validateDictionaryValueForKey:[matches valueForKey:@"article_description"]]?[matches valueForKey:@"article_description"]:@"" forKey:@"discription"];
        }
        
        [context save:&error];
        
    }
    [self clearCart:0];
    
    thankyouViewController *viewControllerForPopover = [self.storyboard instantiateViewControllerWithIdentifier:@"thankyouViewController"];
    
    popover = [[UIPopoverController alloc] initWithContentViewController:viewControllerForPopover];
    
    [popover setPopoverContentSize:CGSizeMake(587, 464)];
    
    CGRect rect = CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/2, 1, 1);
    
    [popover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:0 animated:YES];
    popover.delegate=self;
    
    viewControllerForPopover.callBack = self;
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
    
//    predicate = [NSPredicate predicateWithFormat:@"(name = %@)",arrayProductName[sender.tag]];
//    [predicatesArray addObject:predicate];
    
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
    
//    predicate = [NSPredicate predicateWithFormat:@"(name = %@)",arrayProductName[sender.tag]];
//    [predicatesArray addObject:predicate];
    
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
-(void)clearCart:(UIButton*)sender
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
            
            viewControllerForPopover.str_TotalAmount=str_totalAmount;
            viewControllerForPopover.callBack = self;
            
            popover.delegate=self;
        }
        else
        {
            UIAlertView *al=[[UIAlertView alloc]initWithTitle:@"ISUPOS" message:[NSString stringWithFormat:@"%@", [Language get:@"Only one discount allowed on Cart." alter:@"!Only one discount allowed on Cart."]] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [al show];
        }
    }
    
}
#pragma mark - UISearchBar Delegates

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)string
{
    string=[string lowercaseString];
    
    if (searchBar == scrv) {

    
    if([string isEqualToString:@""])
    {
        filterdone=NO;
    }
    else
    {
        filterdone=YES;
    }
    
    
    farrayQuickButtons=[[NSMutableArray alloc]init];
    farrayQuickButtonsImages =[[NSMutableArray alloc]init];
    farrayQuickButtonsVariantCount =[[NSMutableArray alloc]init];
    farrayQuickButtonsIds =[[NSMutableArray alloc]init];
    
    
    for(int i=0;i<arrayQuickButtonsIds.count;i++)
    {
        
        if ([filterButton isEqualToString:@"name"]) {
        
        
        if ([[arrayQuickButtons[i] lowercaseString] rangeOfString:string].location == NSNotFound)
        {
//            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"ISUPOS" message:@"Match not found" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            [alert show];
        }
        else
        {
            [farrayQuickButtons addObject:arrayQuickButtons[i]];
            [farrayQuickButtonsImages addObject:arrayQuickButtonsImages[i]];
            [farrayQuickButtonsVariantCount addObject:arrayQuickButtonsVariantCount[i]];
            [farrayQuickButtonsIds addObject:arrayQuickButtonsIds[i]];
            
            
        }
        }
        else if ([filterButton isEqualToString:@"number"])
        {
            if ([[arrayQuickButtonsIds[i] lowercaseString] rangeOfString:string].location == NSNotFound)
            {
                //            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"ISUPOS" message:@"Match not found" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                //            [alert show];
            }
            else
            {
                [farrayQuickButtons addObject:arrayQuickButtons[i]];
                [farrayQuickButtonsImages addObject:arrayQuickButtonsImages[i]];
                [farrayQuickButtonsVariantCount addObject:arrayQuickButtonsVariantCount[i]];
                [farrayQuickButtonsIds addObject:arrayQuickButtonsIds[i]];
                
                
            }

        }
        [collectionQuickButtons reloadData];
    }
    }
    else
    {
        
        if([string isEqualToString:@""])
        {
            filterdone1=NO;
        }
        else
        {
            filterdone1=YES;
        }

        
        farrayNextQuickButtons=[[NSMutableArray alloc]init];
        farrayNextQuickButtonsImages =[[NSMutableArray alloc]init];
        farrayNextQuickButtonsVariantCount =[[NSMutableArray alloc]init];
        farrayNextQuickButtonsIds =[[NSMutableArray alloc]init];
        
        
        for(int i=0;i<arrayNextQuickButtonsIds.count;i++)
        {
            
            if ([filterBlock isEqualToString:@"name"]) {
            
            if ([[arrayNextQuickButtons[i] lowercaseString] rangeOfString:string].location == NSNotFound)
            {

            }
            else
            {
                [farrayNextQuickButtons addObject:arrayNextQuickButtons[i]];
                [farrayNextQuickButtonsImages addObject:arrayNextQuickButtonsImages[i]];
                [farrayNextQuickButtonsVariantCount addObject:arrayNextQuickButtonsVariantCount[i]];
                [farrayNextQuickButtonsIds addObject:arrayNextQuickButtonsIds[i]];
                
            }
            }
            else if ([filterBlock isEqualToString:@"number"])
            {
                if ([[arrayNextQuickButtonsIds[i] lowercaseString] rangeOfString:string].location == NSNotFound)
                {
    
                }
                else
                {
                    [farrayNextQuickButtons addObject:arrayNextQuickButtons[i]];
                    [farrayNextQuickButtonsImages addObject:arrayNextQuickButtonsImages[i]];
                    [farrayNextQuickButtonsVariantCount addObject:arrayNextQuickButtonsVariantCount[i]];
                    [farrayNextQuickButtonsIds addObject:arrayNextQuickButtonsIds[i]];
                    
                }
            }
            
            [collectionViewQuickNextButtons reloadData];

        }
        
       }
}

//- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
//{
//    selectSearchView.hidden = NO;
//    return YES;
//}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
  
    NSString *v=[NSString stringWithFormat:@"%@%@",textField.text,string];
    [self multiplyamount:v];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSString *v=[NSString stringWithFormat:@"%@",textField.text];
    [self multiplyamount:v];
    
}

-(void)multiplyamount:(NSString*)v
{
    CGFloat mPrice = (CGFloat)[selectedVariantPrice floatValue];
    customTotal.text=[NSString stringWithFormat:@"%@ %.02f",currencySign,[v floatValue]*mPrice];
}
- (IBAction)action_ClearButton:(UIButton *)sender {
    
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
- (IBAction)actionBlockSearchClick:(UIButton *)sender {
    
    self.selectBlockSearchView.hidden = NO;
    
}
@end
