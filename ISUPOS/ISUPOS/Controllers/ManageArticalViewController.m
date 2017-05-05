//
//  ManageArticalViewController.m
//  ISUPOS
//
//  Created by Rohit Mahajan on 4/20/15.
//  Copyright (c) 2015 Impinge Solutions. All rights reserved.
//

#import "ManageArticalViewController.h"
#import "ManageArticleTableViewCell.h"
#import "EditProductVC.h"
#import "quickBlocksButtonsView.h"
#import "reportViewController.h"
#import "TrasectionsViewController.h"
#import "helo&supportViewController.h"
#import "generalSettingViewController.h"
#import "addNewProductView.h"
#import "articlepopupViewController.h"
#import "receiptDataViewController.h"
#import "linkToViewController.h"

#import "getArticleName.h"
#import "ISUPosSoapService.h"
#import "Reachability.h"
#import "MBProgressHUD.h"
#import "language.h"
#import "LogViewController.h"

@interface ManageArticalViewController ()
{
    NSMutableArray *array_ArticleDetails;
    int saveIndex;
    int articleLitCount;
    NSString *currencySign;
    
    
    UIView *moreButtonView;
    NSMutableArray *morebuttons;
    UIButton *morebutton;
    UIPopoverController *popover;
    NSMutableArray *arrayProductImage, *arrayProductName, *arrayProductQuantity, *arrayProductPrice;
    
    NSMutableArray *articleName,*articleId,*articleVat,*articlePrice,*articleImage,*articleBarcode;
    
    Reachability* internetReachable;
    Reachability* hostReachable;
    AppDelegate *appDelegate;
    
    UIView *view_Bg;
    articlepopupViewController *viewControllerForPopover;
    addNewProductView *viewControllerForPopover1;
    
}

@property (strong, nonatomic)IBOutlet UITableView *tableViewarticle;
@end

@implementation ManageArticalViewController




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
    
    [refreshbtn setTitle:[Language get:@"Refresh Article" alter:@"!Refresh Article"] forState:UIControlStateNormal];
    [addnew setTitle:[Language get:@"Add Article" alter:@"!Add Article"] forState:UIControlStateNormal];
    self.title=[Language get:@"Manage Articles" alter:@"!Manage Articles"];
    
    Namelbl.text=[Language get:@"Article Name" alter:@"!Article Name"];
    Numberlbl.text=[Language get:@"Article Number" alter:@"!Article Number"];
    Vatlbl.text=[Language get:@"VAT" alter:@"!VAT"];
    Barcodelbl.text=[Language get:@"Barcode" alter:@"!Barcode"];
    Pricelbl.text=[Language get:@"Price" alter:@"!Price"];
    
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    // Splunk Mint Breadcrumb added
    [[Mint sharedInstance] leaveBreadcrumb:@"ManageArticles_ViewController"];
    
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
    
    [self navigatetonextscreen];
    
    
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
   // lbl_manReg_ID.text = [defaults objectForKey:@"INFRASEC_PASSWORD"];
    lbl_manReg_ID.text = [defaults objectForKey:@"POS_ID"];
    lbl_manReg_ID.textColor = [UIColor whiteColor];
    lbl_manReg_ID.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:11];
    
//    [self.navigationController.navigationBar addSubview:lbl_manReg_ID];
    
    
//    UIBarButtonItem *version = [[UIBarButtonItem alloc]initWithTitle:@"Version" style:UIBarButtonItemStylePlain target:nil action:nil];
//    [version setTitleTextAttributes:
//     [NSDictionary dictionaryWithObjectsAndKeys:
//      [UIColor whiteColor], UITextAttributeTextColor,nil]
//                           forState:UIControlStateNormal];
//    
//    UIBarButtonItem *manufacturer = [[UIBarButtonItem alloc]initWithTitle:@"Manufacturer" style:UIBarButtonItemStylePlain target:nil action:nil];
//    [manufacturer setTitleTextAttributes:
//     [NSDictionary dictionaryWithObjectsAndKeys:
//      [UIColor whiteColor], UITextAttributeTextColor,nil]
//                                forState:UIControlStateNormal];
//    
//    self.navigationItem.rightBarButtonItem = manufacturer;
//    self.navigationItem.leftBarButtonItem = version;
    
    NSDictionary *dictRoot = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Product_Details" ofType:@"plist"]];
//    manufacturer.title = [dictRoot valueForKey:@"Manufacturer"];
    
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
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    [self Settitles];
    if(klm==1)
    {
        //        UIStoryboard* storyboard   = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        //        ManageArticalViewController *manage_artical = [storyboard instantiateViewControllerWithIdentifier:@"ManageArticalView"];
        //        [self.navigationController pushViewController:manage_artical animated:NO];
    }
    else if(klm==2)
    {
        UIStoryboard* storyboard   = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ManageArticalViewController *manage_artical = [storyboard instantiateViewControllerWithIdentifier:@"ManageArticalView"];
        [self.navigationController pushViewController:manage_artical animated:NO];
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
    
    
    self.navigationItem.hidesBackButton = YES;
    [super viewWillAppear:animated];
    [self add_button_on_tabbar];
    self.navigationController.navigationBarHidden = NO;
    [self getAllArticle];
    
    //Central API Credentials
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"PASSWORD"])
    {
        if ([[NSUserDefaults standardUserDefaults]valueForKey:@"USERNAME"])
        {
            refreshbtn.hidden=NO;
        }
    }
    else
    {
        refreshbtn.hidden=YES;
    }
    
    
//    appDelegate = [[UIApplication sharedApplication] delegate];
//    NSManagedObjectContext *context =[appDelegate managedObjectContext];
//    NSError *error;
//    
//    NSManagedObject *newContact;
//    newContact = [NSEntityDescription insertNewObjectForEntityForName:@"Log" inManagedObjectContext:context];
//    
//    [newContact setValue:[NSDate date] forKey:@"date"];
//    [newContact setValue:[Language get:@"Manage Articles" alter:@"!Manage Articles"] forKey:@"discription"];
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
    //[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - IBActions
-(void)navigatetonextscreen
{
    if(klm==1)
    {
        [self add_button_on_tabbar];
    }
    else if(klm==4)
    {
        UIStoryboard* storyboard   = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        TrasectionsViewController *manage_artical = [storyboard instantiateViewControllerWithIdentifier:@"TrasectionsView"];
        [self.navigationController pushViewController:manage_artical animated:NO];
    }
    
    else if (klm==3)
    {
        UIStoryboard* storyboard   = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        receiptDataViewController *manage_artical = [storyboard instantiateViewControllerWithIdentifier:@"receiptDataViewController"];
        [self.navigationController pushViewController:manage_artical animated:NO];
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
-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    //    CGPoint p = [gestureRecognizer locationInView:_tableViewarticle];
    //
    //    NSIndexPath *indexPath = [_tableViewarticle indexPathForRowAtPoint:p];
    //    if (indexPath == nil) {
    //        NSLog(@"long press on table view but not on a row");
    //    } else if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
    //        NSLog(@"long press on table view at row %d", (int)indexPath.row);
    //
    //        pressedArticleindex=articleId[indexPath.row];
    //        articlepopupViewController *viewControllerForPopover = [self.storyboard instantiateViewControllerWithIdentifier:@"articlepopupView"];
    //        popover = [[UIPopoverController alloc] initWithContentViewController:viewControllerForPopover];
    //        [popover setPopoverContentSize:CGSizeMake(587, 641)];
    //        CGRect rect = CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/2, 1, 1);
    //        [popover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:0 animated:YES];
    //        viewControllerForPopover.callBack = self;
    //        popover.delegate=self;
    //
    //
    //    } else {
    //       // NSLog(@"gestureRecognizer.state = %d", gestureRecognizer.state);
    //    }
}
//addNewProductView
- (IBAction)AddNewArticle_Action:(id)button
{
    
    
    view_Bg = [[UIView alloc]init];
    view_Bg.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    view_Bg.backgroundColor = [UIColor blackColor];
    [view_Bg setAlpha:0.5];
    [self.view addSubview:view_Bg];
    
    viewControllerForPopover1 = [self.storyboard instantiateViewControllerWithIdentifier:@"addNewProductView"];
    viewControllerForPopover1.view.frame = CGRectMake((1024-587)/2, (768-600)/2, 587, 600);
    viewControllerForPopover1.callBack = self;
    
    [self.view addSubview:viewControllerForPopover1.view];
    [self addChildViewController:viewControllerForPopover1];
    [viewControllerForPopover1 didMoveToParentViewController:self];
    
    
//    addNewProductView *viewControllerForPopover = [self.storyboard instantiateViewControllerWithIdentifier:@"addNewProductView"];
//    popover = [[UIPopoverController alloc] initWithContentViewController:viewControllerForPopover];
//    [popover setPopoverContentSize:CGSizeMake(587, 560)];
//    CGRect rect = CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/2, 1, 1);
//    [popover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:0 animated:YES];
//    viewControllerForPopover.callBack = self;
//    popover.delegate=self;
    
//    [self.navigationController pushViewController:viewControllerForPopover animated:YES];
    
     
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
//            
//            
//            LogViewController *logViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LogViewController"];
//            [self.navigationController presentViewController:logViewController animated:NO completion:nil];
//        }

    }
    [self.view setNeedsDisplay];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    if (alertView.tag==3)
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
    
}

#pragma mark - UITableView Datasource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return articleId.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"ManageArticleTableView";
    
    ManageArticleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[ManageArticleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.backgroundColor = [UIColor clearColor];
    //    UIView *bgColorView = [[UIView alloc] init];
    //    bgColorView.backgroundColor = [UIColor colorWithRed:111.0f/255.0f green:60.0f/255.0f blue:135.0f/255.0f alpha:1.0];
    //    [cell setSelectedBackgroundView:bgColorView];
    
    
    cell.labelProductName.text= articleName[indexPath.row];
    
    cell.productimage.image= articleImage[indexPath.row];//[UIImage imageWithData:[NSData dataWithData:articleImage[indexPath.row]]];
    cell.labelProductNumber.text= articleId[indexPath.row];
    cell.labelVat.text=[NSString stringWithFormat:@"%.0f%@",[articleVat[indexPath.row] floatValue],@"%"];
    if([articlePrice[indexPath.row] intValue]==0)
    {
        cell.labelPrice.text= [NSString stringWithFormat:@"%@",@"n/a"];
    }
    else
        cell.labelPrice.text= [NSString stringWithFormat:@"%@ %.0f",currencySign,[articlePrice[indexPath.row] floatValue]];
    
    cell.labelBarCode.text= articleBarcode[indexPath.row];
    //cell.selectedBackgroundView.backgroundColor=[UIColor purpleColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 48;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    view_Bg = [[UIView alloc]init];
    view_Bg.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    view_Bg.backgroundColor = [UIColor blackColor];
    [view_Bg setAlpha:0.5];
    [self.view addSubview:view_Bg];
    
    pressedArticleindex=articleId[indexPath.row];
    viewControllerForPopover = [self.storyboard instantiateViewControllerWithIdentifier:@"articlepopupView"];
    viewControllerForPopover.view.frame = CGRectMake(437/2, 63.5, 587, 641);
    viewControllerForPopover.callBack = self;
    
    [self.view addSubview:viewControllerForPopover.view];
    [self addChildViewController:viewControllerForPopover];
    [viewControllerForPopover didMoveToParentViewController:self];
    
    
//    popover = [[UIPopoverController alloc] initWithContentViewController:viewControllerForPopover];
//    [popover setPopoverContentSize:CGSizeMake(587, 641)];
//    CGRect rect = CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/2, 1, 1);
//    [popover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:0 animated:YES];
//    viewControllerForPopover.callBack = self;
//    popover.delegate=self;
    
}

-(void)toDismissThePopover
{
    
    [view_Bg removeFromSuperview];
    [viewControllerForPopover.view removeFromSuperview];
    [viewControllerForPopover1.view removeFromSuperview];
    
    
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
    [self getAllArticle];
    [popover dismissPopoverAnimated:YES];
    
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"PASSWORD"])
    {
        if ([[NSUserDefaults standardUserDefaults]valueForKey:@"USERNAME"])
        {
            refreshbtn.hidden=NO;
        }
    }
    else
    {
        refreshbtn.hidden=YES;
    }
    
}

- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController
{
    return NO;
}

-(void)getAllArticle
{
    articleName=[[NSMutableArray alloc]init];
    articleId =[[NSMutableArray alloc]init];
    articleVat =[[NSMutableArray alloc]init];
    articlePrice =[[NSMutableArray alloc]init];
    articleImage =[[NSMutableArray alloc]init];
    articleBarcode =[[NSMutableArray alloc]init];
    
    appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context =[appDelegate managedObjectContext];
    NSEntityDescription *entityDesc =[NSEntityDescription entityForName:@"Article" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    
    
    for(int i=0;i<objects.count;i++)
    {
        NSManagedObject *person = (NSManagedObject *)[objects objectAtIndex:i];

        
        if (![[person valueForKey:@"article_img_url"] isEqual:NULL] && ![[person valueForKey:@"article_img_url"] isEqual:[NSNull null]]&&![[person valueForKey:@"article_img_url"] isEqual:nil]&&[person valueForKey:@"article_img_url"]!=nil)
        {
            NSData *da=[person valueForKey:@"article_img_url"];
            UIImage *img=[[UIImage alloc] initWithData:da];
            [articleImage addObject:img];
        }
        else
        {
            [articleImage addObject:@""];
        }
        if (![[person valueForKey:@"name"] isEqual:NULL] && ![[person valueForKey:@"name"] isEqual:[NSNull null]] &&![[person valueForKey:@"name"] isEqual:nil]&&[person valueForKey:@"name"]!=nil)
        {
            [articleName  addObject:[person valueForKey:@"name"]];
        }
        else
        {
            [articleName  addObject:@""];
        }
        if (![[person valueForKey:@"article_no"] isEqual:NULL] && ![[person valueForKey:@"article_no"] isEqual:[NSNull null]] &&![[person valueForKey:@"article_no"] isEqual:nil]&&[person valueForKey:@"article_no"]!=nil)
        {
            [articleId    addObject:[person valueForKey:@"article_no"]];
        }
        else
        {
            [articleId    addObject:@""];
        }
        if (![[person valueForKey:@"vat"] isEqual:NULL] && ![[person valueForKey:@"vat"] isEqual:[NSNull null]] &&![[person valueForKey:@"vat"] isEqual:nil]&&[person valueForKey:@"vat"]!=nil)
        {
            [articleVat   addObject:[person valueForKey:@"vat"]];
        }
        else
        {
            [articleVat   addObject:@""];
        }
        if(![[person valueForKey:@"price"] isEqual:NULL] && ![[person valueForKey:@"price"] isEqual:[NSNull null]] &&![[person valueForKey:@"price"] isEqual:nil]&&[person valueForKey:@"price"]!=nil)
        {
            [articlePrice addObject:[person valueForKey:@"price"]];
        }
        else
        {
            [articlePrice addObject:@""];
        }
        
        if(![[person valueForKey:@"barcode"] isEqual:NULL] && ![[person valueForKey:@"barcode"] isEqual:[NSNull null]] &&![[person valueForKey:@"barcode"] isEqual:nil]&&[person valueForKey:@"barcode"]!=nil)
        {
            [articleBarcode addObject:[person valueForKey:@"barcode"]];
        }
        else
        {
            [articleBarcode addObject:@""];
        }
        
    }
    
    [_tableViewarticle reloadData];
    
    
    
    if (_tableViewarticle.contentSize.height > _tableViewarticle.frame.size.height)
    {
        CGPoint offset = CGPointMake(0, _tableViewarticle.contentSize.height - _tableViewarticle.frame.size.height);
        [_tableViewarticle setContentOffset:offset animated:YES];
    }
    
}

- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}

-(IBAction)RefreshArticle:(UIButton*)btn
{
    if (![self connected]) {
        // not connected
        [[[UIAlertView alloc] initWithTitle:@"ISUPOS" message:[Language get:@"Please check your internet connection." alter:@"!Please check your internet connection."] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
    else
    {
        if ([[NSUserDefaults standardUserDefaults]valueForKey:@"PASSWORD"])
        {
            if ([[NSUserDefaults standardUserDefaults]valueForKey:@"USERNAME"])
            {
                
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                
                hud.labelText = @"Loading...";
                
                ISUPosSoapService *service = [[ISUPosSoapService alloc] init];
                [service GetArticleList:self action:@selector(getArticleList:)  UserId:nil];
                
            }
            
            
        }
        else
        {
            [[[UIAlertView alloc] initWithTitle:@"ISUPOS" message:[Language get:@"Please enter username and password on settings screen." alter:@"!Please enter username and password on settings screen."] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
    }
    
}
-(void)getArticlevalues:(id)index
{
    SoapArray *array=(SoapArray*)index;
    
    
    
    NSMutableDictionary *dict;
    dict=[[NSMutableDictionary alloc] init];
    
//    [dict setValue:[[array objectAtIndex:0] valueForKey:@"Active"] forKey:@"Active"];
//    [dict setValue:[[array objectAtIndex:0] valueForKey:@"ArticleNumber"] forKey:@"ArticleNumber"];
//    [dict setValue:[[array objectAtIndex:0] valueForKey:@"AttributeCombo"] forKey:@"AttributeCombo"];
//    [dict setValue:[[array objectAtIndex:0] valueForKey:@"Barcode"] forKey:@"Barcode"];
//    [dict setValue:[[array objectAtIndex:0] valueForKey:@"Brand"] forKey:@"Brand"];
//    [dict setValue:[[array objectAtIndex:0] valueForKey:@"CostPrice"] forKey:@"CostPrice"];
//    [dict setValue:[[array objectAtIndex:0] valueForKey:@"Description"] forKey:@"Description"];
//    [dict setValue:[[array objectAtIndex:0] valueForKey:@"GroupName"] forKey:@"GroupName"];
//    [dict setValue:[[array objectAtIndex:0] valueForKey:@"LastModified"] forKey:@"LastModified"];
//    [dict setValue:[[array objectAtIndex:0] valueForKey:@"Location"] forKey:@"Location"];
//    [dict setValue:[[array objectAtIndex:0] valueForKey:@"Name"] forKey:@"Name"];
//    [dict setValue:[[array objectAtIndex:0] valueForKey:@"PriceIncVat"] forKey:@"PriceIncVat"];
//    [dict setValue:[[array objectAtIndex:0] valueForKey:@"ProductModel"] forKey:@"ProductModel"];
//    [dict setValue:[[array objectAtIndex:0] valueForKey:@"Quantity"] forKey:@"Quantity"];
//    [dict setValue:[[array objectAtIndex:0] valueForKey:@"SalesAccount"] forKey:@"SalesAccount"];
//    [dict setValue:[[array objectAtIndex:0] valueForKey:@"SerialNumber"] forKey:@"SerialNumber"];
//    [dict setValue:[[array objectAtIndex:0] valueForKey:@"SubGroupName"] forKey:@"SubGroupName"];
//    [dict setValue:[[array objectAtIndex:0] valueForKey:@"Supplier"] forKey:@"Supplier"];
//    [dict setValue:[[array objectAtIndex:0] valueForKey:@"Unit"] forKey:@"Unit"];
//    [dict setValue:[[array objectAtIndex:0] valueForKey:@"Vat"] forKey:@"Vat"];
//    [dict setValue:[[array objectAtIndex:0] valueForKey:@"VatRateDec"] forKey:@"VatRateDec"];
    
    [dict setObjectWithNilKeyValidation:[[array objectAtIndex:0] valueForKey:@"Active"] forKey:@"Active"];
    [dict setObjectWithNilKeyValidation:[[array objectAtIndex:0] valueForKey:@"ArticleNumber"] forKey:@"ArticleNumber"];
    [dict setObjectWithNilKeyValidation:[[array objectAtIndex:0] valueForKey:@"AttributeCombo"] forKey:@"AttributeCombo"];
    [dict setObjectWithNilKeyValidation:[[array objectAtIndex:0] valueForKey:@"Barcode"] forKey:@"Barcode"];
    [dict setObjectWithNilKeyValidation:[[array objectAtIndex:0] valueForKey:@"Brand"] forKey:@"Brand"];
    [dict setObjectWithNilKeyValidation:[[array objectAtIndex:0] valueForKey:@"CostPrice"] forKey:@"CostPrice"];
    [dict setObjectWithNilKeyValidation:[[array objectAtIndex:0] valueForKey:@"Description"] forKey:@"Description"];
    [dict setObjectWithNilKeyValidation:[[array objectAtIndex:0] valueForKey:@"GroupName"] forKey:@"GroupName"];
    [dict setObjectWithNilKeyValidation:[[array objectAtIndex:0] valueForKey:@"LastModified"] forKey:@"LastModified"];
    [dict setObjectWithNilKeyValidation:[[array objectAtIndex:0] valueForKey:@"Location"] forKey:@"Location"];
    [dict setObjectWithNilKeyValidation:[[array objectAtIndex:0] valueForKey:@"Name"] forKey:@"Name"];
    [dict setObjectWithNilKeyValidation:[[array objectAtIndex:0] valueForKey:@"PriceIncVat"] forKey:@"PriceIncVat"];
    [dict setObjectWithNilKeyValidation:[[array objectAtIndex:0] valueForKey:@"ProductModel"] forKey:@"ProductModel"];
    [dict setObjectWithNilKeyValidation:[[array objectAtIndex:0] valueForKey:@"Quantity"] forKey:@"Quantity"];
    [dict setObjectWithNilKeyValidation:[[array objectAtIndex:0] valueForKey:@"SalesAccount"] forKey:@"SalesAccount"];
    [dict setObjectWithNilKeyValidation:[[array objectAtIndex:0] valueForKey:@"SerialNumber"] forKey:@"SerialNumber"];
    [dict setObjectWithNilKeyValidation:[[array objectAtIndex:0] valueForKey:@"SubGroupName"] forKey:@"SubGroupName"];
    [dict setObjectWithNilKeyValidation:[[array objectAtIndex:0] valueForKey:@"Supplier"] forKey:@"Supplier"];
    [dict setObjectWithNilKeyValidation:[[array objectAtIndex:0] valueForKey:@"Unit"] forKey:@"Unit"];
    [dict setObjectWithNilKeyValidation:[[array objectAtIndex:0] valueForKey:@"Vat"] forKey:@"Vat"];
    [dict setObjectWithNilKeyValidation:[[array objectAtIndex:0] valueForKey:@"VatRateDec"] forKey:@"VatRateDec"];

    
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
    if ([index isKindOfClass:[NSError class]]) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [[[UIAlertView alloc] initWithTitle:@"ISUPOS" message:[Language get:@"Please check your internet connection." alter:@"!Please check your internet connection."] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        
    }
    else
    {
        SoapArray *array=(SoapArray*)index;
        if(array.count)
        {
        NSMutableArray *ArticleList=[[NSMutableArray alloc] init];
        
        ArticleList= [NSMutableArray arrayWithArray:[[array objectAtIndex:0] valueForKey:@"Articles"]];
        
        array_ArticleDetails=[[NSMutableArray alloc] init];
        articleLitCount=(int)[ArticleList count];
        for (int i=0; i<[ArticleList count]; i++)
        {
            ISUPosSoapService *service = [[ISUPosSoapService alloc] init];
            
            [service GetArticleName:self action:@selector(getArticlevalues:) UserId:(NSNumber *)[NSString stringWithFormat:@"%@",[ArticleList objectAtIndex:i]]];
        
        }
        }
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
    
    
    
}

-(void)getUSER:(id)index
{
    
}


#pragma mark coredata Start

-(void)getData
{
    appDelegate =
    [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context =
    [appDelegate managedObjectContext];
    
    NSEntityDescription *entityDesc =
    [NSEntityDescription entityForName:@"Article"
                inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
    NSPredicate *pred =
    //    [NSPredicate predicateWithFormat:@"(article_no = %@) AND (old = %@)",
    //     [[array_ArticleDetails objectAtIndex:saveIndex] valueForKey:@"ArticleNumber"], [NSNumber numberWithBool:NO]];
    
    [NSPredicate predicateWithFormat:@"(article_ServerKey = %@)",
     [[array_ArticleDetails objectAtIndex:saveIndex] valueForKey:@"ArticleNumber"]];
    [request setPredicate:pred];
    NSManagedObject *matches = nil;
    
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request
                                              error:&error];
    
    if ([objects count] == 0) {
        
        [self saveArticleDetails];
        
    } else {
        
        //        [self editArticleDetails];
        
        [self EditExistingArticle:[objects firstObject]];
    }
}

-(void)EditExistingArticle:(NSManagedObjectContext*)newContact
{
   // NSString *articleid=@"";
    
    appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context =[appDelegate managedObjectContext];
   // NSEntityDescription *entityDesc =[NSEntityDescription entityForName:@"Article" inManagedObjectContext:context];
    NSError *error;
    
    
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    [f setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
    if (![[[array_ArticleDetails objectAtIndex:saveIndex] valueForKey:@"Vat"] isEqual:NULL] && ![[[array_ArticleDetails objectAtIndex:saveIndex] valueForKey:@"Vat"] isEqual:[NSNull null]] &&![[[array_ArticleDetails objectAtIndex:saveIndex] valueForKey:@"Vat"] isEqualToString:@"<null>"])
    {
        NSNumber *NumberVat = [f numberFromString:[[array_ArticleDetails objectAtIndex:saveIndex] valueForKey:@"Vat"]];
        [newContact setValue:NumberVat forKey:@"vat"];
    }
    //[newContact setValue:[[array_ArticleDetails objectAtIndex:saveIndex] valueForKey:@"Unit"] forKey:@"unit_type"];
    [newContact setValue:[NSNumber numberWithInt:0] forKey:@"unit_type"];
    if (![[[array_ArticleDetails objectAtIndex:saveIndex] valueForKey:@"PriceIncVat"] isEqual:NULL] && ![[[array_ArticleDetails objectAtIndex:saveIndex] valueForKey:@"PriceIncVat"] isEqual:[NSNull null]] &&![[[array_ArticleDetails objectAtIndex:saveIndex] valueForKey:@"PriceIncVat"] isEqualToString:@"<null>"])
    {
        NSNumber *NumberPrice = [f numberFromString:[[array_ArticleDetails objectAtIndex:saveIndex] valueForKey:@"PriceIncVat"]];
        [newContact setValue:NumberPrice forKey:@"price"];
    }
    if (![[[array_ArticleDetails objectAtIndex:saveIndex] valueForKey:@"CostPrice"] isEqual:NULL] && ![[[array_ArticleDetails objectAtIndex:saveIndex] valueForKey:@"CostPrice"] isEqual:[NSNull null]] &&![[[array_ArticleDetails objectAtIndex:saveIndex] valueForKey:@"CostPrice"] isEqualToString:@"<null>"])
    {
        NSNumber *NumberDiscount = [f numberFromString:[[array_ArticleDetails objectAtIndex:saveIndex] valueForKey:@"CostPrice"]];
        [newContact setValue:NumberDiscount forKey:@"discount"];
    }
    if (![[[array_ArticleDetails objectAtIndex:saveIndex] valueForKey:@"Description"] isEqual:NULL] && ![[[array_ArticleDetails objectAtIndex:saveIndex] valueForKey:@"Description"] isEqual:[NSNull null]] &&![[[array_ArticleDetails objectAtIndex:saveIndex] valueForKey:@"Description"] isEqualToString:@"<null>"])
    {
        [newContact setValue:[[array_ArticleDetails objectAtIndex:saveIndex] valueForKey:@"Description"] forKey:@"article_description"];
    }
    if (![[[array_ArticleDetails objectAtIndex:saveIndex] valueForKey:@"Name"] isEqual:NULL] && ![[[array_ArticleDetails objectAtIndex:saveIndex] valueForKey:@"Name"] isEqual:[NSNull null]] &&![[[array_ArticleDetails objectAtIndex:saveIndex] valueForKey:@"Name"] isEqualToString:@"<null>"])
    {
        [newContact setValue:[[array_ArticleDetails objectAtIndex:saveIndex] valueForKey:@"Name"] forKey:@"name"];
    }
    if (![[[array_ArticleDetails objectAtIndex:saveIndex] valueForKey:@"LastModified"] isEqual:NULL] && ![[[array_ArticleDetails objectAtIndex:saveIndex] valueForKey:@"LastModified"] isEqual:[NSNull null]] &&![[[array_ArticleDetails objectAtIndex:saveIndex] valueForKey:@"LastModified"] isEqualToString:@"<null>"])
    {
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        // Convert date object into desired format
        [dateFormatter setDateFormat:@"YYYY-MM-dd\'T\'HH:mm:ssZZZZZ"];
        NSDate *lastModiDate;
        lastModiDate = [dateFormatter dateFromString:[[array_ArticleDetails objectAtIndex:saveIndex] valueForKey:@"LastModified"]];
        
        
        [newContact setValue:lastModiDate forKey:@"modified_date"];
        [newContact setValue:lastModiDate forKey:@"created_date"];
        
        [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm"];
        
    }
    
    // Old value
    [newContact setValue:[NSNumber numberWithBool:YES] forKey:@"old"];
    
    
    //[newContact setValue:articleid forKey:@"article_no"];
    
    if (![[[array_ArticleDetails objectAtIndex:saveIndex] valueForKey:@"ArticleNumber"] isEqual:NULL] && ![[[array_ArticleDetails objectAtIndex:saveIndex] valueForKey:@"ArticleNumber"] isEqual:[NSNull null]] &&![[[array_ArticleDetails objectAtIndex:saveIndex] valueForKey:@"ArticleNumber"] isEqualToString:@"<null>"])
    {
        
        [newContact setValue:[[array_ArticleDetails objectAtIndex:saveIndex] valueForKey:@"ArticleNumber"] forKey:@"article_ServerKey"];
    }
    
    
    if (![[[array_ArticleDetails objectAtIndex:saveIndex] valueForKey:@"Barcode"] isEqual:NULL] && ![[[array_ArticleDetails objectAtIndex:saveIndex] valueForKey:@"Barcode"] isEqual:[NSNull null]] &&![[[array_ArticleDetails objectAtIndex:saveIndex] valueForKey:@"Barcode"] isEqualToString:@"<null>"])
    {
        
        [newContact setValue:[[array_ArticleDetails objectAtIndex:saveIndex] valueForKey:@"Barcode"] forKey:@"barcode"];
    }
    
    //[newContact setValue:[[array_ArticleDetails objectAtIndex:saveIndex] valueForKey:@"ArticleNumber"] forKey:@"article_no"];
    [newContact setValue:UIImagePNGRepresentation([UIImage imageNamed:@"block_Image.png"]) forKey:@"article_img_url"];
    [context save:&error];
    
    [self getAllArticle];


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
    
    
    int artId;
    int aid;
    
    if ([objects count]==0) {
        
        artId=1;
        
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"artID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    else
    {
      
        
        aid= [[[NSUserDefaults standardUserDefaults] valueForKey:@"artID"] intValue];
        artId=aid+1;
        
        
        articleid=[NSString stringWithFormat:@"IS%d",(int)(100000+artId)];
        
        
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context =[appDelegate managedObjectContext];
        NSEntityDescription *entityDesc =[NSEntityDescription entityForName:@"Article" inManagedObjectContext:context];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entityDesc];
        NSPredicate *pred =[NSPredicate predicateWithFormat:@"(article_no = %@)",articleid];
        [request setPredicate:pred];
        
        NSError *error;
        NSArray *objects = [context executeFetchRequest:request error:&error];
        
        if (objects.count>0) {
            
            artId=artId+1;
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",artId] forKey:@"artID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    
    articleid=[NSString stringWithFormat:@"IS%d",(int)(100000+artId)];
    
    
    NSManagedObject *newContact;
    newContact = [NSEntityDescription insertNewObjectForEntityForName:@"Article" inManagedObjectContext:context];
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    [f setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
    if (![[[array_ArticleDetails objectAtIndex:saveIndex] valueForKey:@"Vat"] isEqual:NULL] && ![[[array_ArticleDetails objectAtIndex:saveIndex] valueForKey:@"Vat"] isEqual:[NSNull null]] &&![[[array_ArticleDetails objectAtIndex:saveIndex] valueForKey:@"Vat"] isEqualToString:@"<null>"])
    {
        NSNumber *NumberVat = [f numberFromString:[[array_ArticleDetails objectAtIndex:saveIndex] valueForKey:@"Vat"]];
        [newContact setValue:NumberVat forKey:@"vat"];
    }
    //[newContact setValue:[[array_ArticleDetails objectAtIndex:saveIndex] valueForKey:@"Unit"] forKey:@"unit_type"];
    [newContact setValue:[NSNumber numberWithInt:0] forKey:@"unit_type"];
    if (![[[array_ArticleDetails objectAtIndex:saveIndex] valueForKey:@"PriceIncVat"] isEqual:NULL] && ![[[array_ArticleDetails objectAtIndex:saveIndex] valueForKey:@"PriceIncVat"] isEqual:[NSNull null]] &&![[[array_ArticleDetails objectAtIndex:saveIndex] valueForKey:@"PriceIncVat"] isEqualToString:@"<null>"])
    {
        NSNumber *NumberPrice = [f numberFromString:[[array_ArticleDetails objectAtIndex:saveIndex] valueForKey:@"PriceIncVat"]];
        [newContact setValue:NumberPrice forKey:@"price"];
    }
    if (![[[array_ArticleDetails objectAtIndex:saveIndex] valueForKey:@"CostPrice"] isEqual:NULL] && ![[[array_ArticleDetails objectAtIndex:saveIndex] valueForKey:@"CostPrice"] isEqual:[NSNull null]] &&![[[array_ArticleDetails objectAtIndex:saveIndex] valueForKey:@"CostPrice"] isEqualToString:@"<null>"])
    {
        NSNumber *NumberDiscount = [f numberFromString:[[array_ArticleDetails objectAtIndex:saveIndex] valueForKey:@"CostPrice"]];
        [newContact setValue:NumberDiscount forKey:@"discount"];
    }
    if (![[[array_ArticleDetails objectAtIndex:saveIndex] valueForKey:@"Description"] isEqual:NULL] && ![[[array_ArticleDetails objectAtIndex:saveIndex] valueForKey:@"Description"] isEqual:[NSNull null]] &&![[[array_ArticleDetails objectAtIndex:saveIndex] valueForKey:@"Description"] isEqualToString:@"<null>"])
    {
        [newContact setValue:[[array_ArticleDetails objectAtIndex:saveIndex] valueForKey:@"Description"] forKey:@"article_description"];
    }
    if (![[[array_ArticleDetails objectAtIndex:saveIndex] valueForKey:@"Name"] isEqual:NULL] && ![[[array_ArticleDetails objectAtIndex:saveIndex] valueForKey:@"Name"] isEqual:[NSNull null]] &&![[[array_ArticleDetails objectAtIndex:saveIndex] valueForKey:@"Name"] isEqualToString:@"<null>"])
    {
        [newContact setValue:[[array_ArticleDetails objectAtIndex:saveIndex] valueForKey:@"Name"] forKey:@"name"];
    }
    if (![[[array_ArticleDetails objectAtIndex:saveIndex] valueForKey:@"LastModified"] isEqual:NULL] && ![[[array_ArticleDetails objectAtIndex:saveIndex] valueForKey:@"LastModified"] isEqual:[NSNull null]] &&![[[array_ArticleDetails objectAtIndex:saveIndex] valueForKey:@"LastModified"] isEqualToString:@"<null>"])
    {
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        // Convert date object into desired format
        [dateFormatter setDateFormat:@"YYYY-MM-dd\'T\'HH:mm:ssZZZZZ"];
        NSDate *lastModiDate;
        lastModiDate = [dateFormatter dateFromString:[[array_ArticleDetails objectAtIndex:saveIndex] valueForKey:@"LastModified"]];
        
        
        [newContact setValue:lastModiDate forKey:@"modified_date"];
        [newContact setValue:lastModiDate forKey:@"created_date"];
        
        [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm"];

    }
    
    // Old value
    [newContact setValue:[NSNumber numberWithBool:YES] forKey:@"old"];
    
    
    [newContact setValue:articleid forKey:@"article_no"];
    
    if (![[[array_ArticleDetails objectAtIndex:saveIndex] valueForKey:@"ArticleNumber"] isEqual:NULL] && ![[[array_ArticleDetails objectAtIndex:saveIndex] valueForKey:@"ArticleNumber"] isEqual:[NSNull null]] &&![[[array_ArticleDetails objectAtIndex:saveIndex] valueForKey:@"ArticleNumber"] isEqualToString:@"<null>"])
    {
        
        [newContact setValue:[[array_ArticleDetails objectAtIndex:saveIndex] valueForKey:@"ArticleNumber"] forKey:@"article_ServerKey"];
    }
    
    
    if (![[[array_ArticleDetails objectAtIndex:saveIndex] valueForKey:@"Barcode"] isEqual:NULL] && ![[[array_ArticleDetails objectAtIndex:saveIndex] valueForKey:@"Barcode"] isEqual:[NSNull null]] &&![[[array_ArticleDetails objectAtIndex:saveIndex] valueForKey:@"Barcode"] isEqualToString:@"<null>"])
    {
        
        [newContact setValue:[[array_ArticleDetails objectAtIndex:saveIndex] valueForKey:@"Barcode"] forKey:@"barcode"];
    }
    
    //[newContact setValue:[[array_ArticleDetails objectAtIndex:saveIndex] valueForKey:@"ArticleNumber"] forKey:@"article_no"];
    [newContact setValue:UIImagePNGRepresentation([UIImage imageNamed:@"block_Image.png"]) forKey:@"article_img_url"];
    [newContact setValue:[NSNumber numberWithInt:(int)[objects count]+1] forKey:@"article_id"];
    [context save:&error];
    
    //    if(addVariantArray.count>1)
    //    {
    //
    //        NSEntityDescription *entityDesc1 =[NSEntityDescription entityForName:@"Variant" inManagedObjectContext:context];
    //        NSFetchRequest *request = [[NSFetchRequest alloc] init];
    //        [request setEntity:entityDesc1];
    //        NSError *error;
    //        NSArray *objects1 = [context executeFetchRequest:request error:&error];
    //
    //        NSManagedObject *newContact;
    //
    //        for(int i=1;i<addVariantArray.count;i++)
    //        {
    //            newContact = [NSEntityDescription insertNewObjectForEntityForName:@"Variant" inManagedObjectContext:context];
    //            [newContact setValue:articleid forKey:@"article_id"];
    //            [newContact setValue:addVariantArray[i] forKey:@"name"];
    //            [newContact setValue:[NSNumber numberWithFloat:[addVariantPriceArray[i] floatValue]] forKey:@"price"];
    //            [newContact setValue:[NSNumber numberWithInt:(int)objects1.count+i+1] forKey:@"variant_id"];
    //            [context save:&error];
    //        }
    //
    //
    //    }
    
    
        
//        [self saveArticleDetailsAuto];
    
    
    
    
    
    [self getAllArticle];
    
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

-(void)saveArticleDetailsAuto   ////To save Article data in database//////
{
    
    for (int i=0; i<50; i++) {
    
    NSString *articleid=@"";
    
    appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context =[appDelegate managedObjectContext];
    NSEntityDescription *entityDesc =[NSEntityDescription entityForName:@"Article" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    
    
    int artId;
    int aid;
    
    
    NSString *str_vat;
    NSString *str_barcode;
    NSString *str_name;
    NSString *str_dic;
    NSString *str_price;

    
    if ([objects count]==0) {
        
        artId=1;
        
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"artID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    else
    {

        aid= [[[NSUserDefaults standardUserDefaults] valueForKey:@"artID"] intValue];
        artId=aid+1;
        
        
        articleid=[NSString stringWithFormat:@"IS%d",(int)(100000+artId)];
        
        
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context =[appDelegate managedObjectContext];
        NSEntityDescription *entityDesc =[NSEntityDescription entityForName:@"Article" inManagedObjectContext:context];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entityDesc];
        NSPredicate *pred =[NSPredicate predicateWithFormat:@"(article_no = %@)",articleid];
        [request setPredicate:pred];
        
        NSError *error;
        NSArray *objects = [context executeFetchRequest:request error:&error];
        
        if (objects.count>0) {
            
            artId=artId+1;
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",artId] forKey:@"artID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    
    articleid=[NSString stringWithFormat:@"IS%d",(int)(100000+artId)];
    
    if (i%2==0) {
        
        str_vat=@"6";
    }
    else
    {
        str_vat=@"12";
    }
    
    
    str_barcode=[NSString stringWithFormat:@"1000%d",(int)(artId)];
    str_name=[NSString stringWithFormat:@"Product %d",(int)(artId)];
    str_dic=[NSString stringWithFormat:@"Discription%d",(int)(artId)];
    str_price=[NSString stringWithFormat:@"100"];
    
    
    NSManagedObject *newContact;
    newContact = [NSEntityDescription insertNewObjectForEntityForName:@"Article" inManagedObjectContext:context];
    
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    
    NSNumber *NumberVat = [f numberFromString:str_vat];
    [newContact setValue:NumberVat forKey:@"vat"];
    
    NSNumber *NumberPrice = [f numberFromString:str_price];
    
    [newContact setValue:NumberPrice forKey:@"price"];
    [newContact setValue:str_dic forKey:@"article_description"];
    [newContact setValue:str_name forKey:@"name"];
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        // Convert date object into desired format
    [dateFormatter setDateFormat:@"YYYY-MM-dd\'T\'HH:mm:ssZZZZZ"];
    NSDate *lastModiDate;
    lastModiDate = [dateFormatter dateFromString:[[array_ArticleDetails objectAtIndex:saveIndex] valueForKey:@"LastModified"]];
        
        
    [newContact setValue:lastModiDate forKey:@"modified_date"];
    [newContact setValue:lastModiDate forKey:@"created_date"];
        
    [dateFormatter setDateFormat:@"dd/MM/yyyy HH:mm"];

    
    // Old value
    [newContact setValue:[NSNumber numberWithBool:YES] forKey:@"old"];
    [newContact setValue:str_barcode forKey:@"barcode"];
    
    [newContact setValue:articleid forKey:@"article_no"];
    [newContact setValue:articleid forKey:@"article_ServerKey"];
    
    
    
    //[newContact setValue:[[array_ArticleDetails objectAtIndex:saveIndex] valueForKey:@"ArticleNumber"] forKey:@"article_no"];
    [newContact setValue:UIImagePNGRepresentation([UIImage imageNamed:@"block_Image.png"]) forKey:@"article_img_url"];
    [newContact setValue:[NSNumber numberWithInt:(int)[objects count]+1] forKey:@"article_id"];
    [context save:&error];
    
    }
    
    [self getAllArticle];
    
}


#pragma mark end core data
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
