//
//  receiptDataViewController.m
//  ISUPOS
//
//  Created by Rohit Mahajan on 6/22/15.
//  Copyright (c) 2015 Impinge Solutions. All rights reserved.
//

#import "receiptDataViewController.h"
#import "quickBlocksButtonsView.h"
#import "helo&supportViewController.h"
#import "generalSettingViewController.h"
#import "ManageArticalViewController.h"
#import "reportViewController.h"
#import "TrasectionsViewController.h"
#import "linkToViewController.h"
#import "language.h"
#import "LogViewController.h"


@interface receiptDataViewController ()
{
    UIView *moreButtonView;
    NSMutableArray *morebuttons;
    UIButton *morebutton;
    UIPopoverController *popover;
    NSMutableArray *arr2;
    NSString *currencySign;
}
@end

@implementation receiptDataViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void) settitles
{
    
    organization_name1.text=[Language get:@"Organization Number" alter:@"!Organization Number"];
    company_name1.text=[Language get:@"Company Name" alter:@"!Company Name"];
    address11.text=[Language get:@"Address 1" alter:@"!Address 1"];
    address21.text=[Language get:@"Address 2" alter:@"!Address 2"];
    zipcode1.text=[Language get:@"Zip Code" alter:@"!Zip Code"];
    city1.text=[Language get:@"City" alter:@"!City"];
    phone1.text=[Language get:@"Phone" alter:@"!Phone"];
    fax1.text=[Language get:@"Fax" alter:@"!Fax"];
    homepage1.text=[Language get:@"Homepage" alter:@"!Homepage"];
    row11.text=[Language get:@"Row 1" alter:@"!Row 1"];
    row21.text=[Language get:@"Row 2" alter:@"!Row 2"];
    row31.text=[Language get:@"Row 3" alter:@"!Row 3"];
    row41.text=[Language get:@"Row 4" alter:@"!Row 4"];
    row51.text=[Language get:@"Row 5" alter:@"!Row 5"];
    row61.text=[Language get:@"Row 1" alter:@"!Row 1"];
    row71.text=[Language get:@"Row 2" alter:@"!Row 2"];
    row81.text=[Language get:@"Row 3" alter:@"!Row 3"];
    row91.text=[Language get:@"Row 4" alter:@"!Row 4"];
    row101.text=[Language get:@"Row 5" alter:@"!Row 5"];
    
    l1.text=[Language get:@"Company Information" alter:@"!Company Information"];
    l2.text=[Language get:@"Tax at the top of Receipt" alter:@"!Tax at the top of Receipt"];
    l3.text=[Language get:@"Tax at the end of Receipt" alter:@"!Tax at the end of Receipt"];
    self.title=[Language get:@"Receipt Data" alter:@"!Receipt Data"];
    [Save_Button setTitle:[Language get:@"Save" alter:@"!Save"] forState:UIControlStateNormal];
    
    l1.backgroundColor=[UIColor colorWithRed:91.0f/255.0f green:41.0f/255.0f blue:117.0f/255.0f alpha:1.0f];
    l2.backgroundColor=[UIColor colorWithRed:91.0f/255.0f green:41.0f/255.0f blue:117.0f/255.0f alpha:1.0f];
    l3.backgroundColor=[UIColor colorWithRed:91.0f/255.0f green:41.0f/255.0f blue:117.0f/255.0f alpha:1.0f];
    
    zip_Code_lbl.text=[Language get:@"Zip Code" alter:@"!Zip Code"];
    
}
- (void) viewWillAppear:(BOOL)animated
{
    

    [self settitles];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
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

    
    if(klm==1)
    {
        UIStoryboard* storyboard   = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ManageArticalViewController *manage_artical = [storyboard instantiateViewControllerWithIdentifier:@"ManageArticalView"];
        [self.navigationController pushViewController:manage_artical animated:NO];
    }
    else if(klm==2)
    {
        UIStoryboard* storyboard   = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ManageArticalViewController *manage_artical = [storyboard instantiateViewControllerWithIdentifier:@"ManageArticalView"];
        [self.navigationController pushViewController:manage_artical animated:NO];
    }
    else if(klm==3)
    {
//        UIStoryboard* storyboard   = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        receiptDataViewController *manage_artical = [storyboard instantiateViewControllerWithIdentifier:@"receiptDataViewController"];
//        [self.navigationController pushViewController:manage_artical animated:NO];
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
   // self.title=@"Receipt Data";
    [self add_button_on_tabbar];
    [self getdata];
    self.navigationController.navigationBarHidden = NO;
    
    
//    NSManagedObject *newContact;
//    newContact = [NSEntityDescription insertNewObjectForEntityForName:@"Log" inManagedObjectContext:context];
//    
//    [newContact setValue:[NSDate date] forKey:@"date"];
//    [newContact setValue:[Language get:@"Receipt Data" alter:@"!Receipt Data"] forKey:@"discription"];
//    [newContact setValue:@"" forKey:@"sno"];
//    
//    [context save:&error];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    arr2=[NSMutableArray new];
    
    // Splunk Mint Breadcrumb added
    [[Mint sharedInstance] leaveBreadcrumb:@"ReceiptDataViewController_ViewController"];
    
    // Do any additional setup after loading the view.
    
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
    
//    [self.navigationController.navigationBar addSubview:lbl_manReg_ID];
    
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
//    version.title = [NSString stringWithFormat:@"Product: %@ %@ %@", string1, string2, [dictRoot valueForKey:@"Version"]];
    
    
    
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

-(void)toDismissThePopover
{
    [self settitles];
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
    
    
    if (alertView.tag==6)
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
        [self add_button_on_tabbar];
        
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
    else if(klm==9)
    {
        UIStoryboard* storyboard   = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        linkToViewController *manage_artical = [storyboard instantiateViewControllerWithIdentifier:@"LogViewController"];
        [self.navigationController pushViewController:manage_artical animated:NO];
    }
    
}
-(IBAction)savedata:(UIButton*)sender
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context =[appDelegate managedObjectContext];
    NSEntityDescription *entityDesc =[NSEntityDescription entityForName:@"ReceiptData" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    NSPredicate *pred =[NSPredicate predicateWithFormat:@"(id = %@)",@"1"];
    [request setPredicate:pred];
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    if(objects.count==0)
    {
        NSManagedObject *newContact;
        newContact = [NSEntityDescription insertNewObjectForEntityForName:@"ReceiptData" inManagedObjectContext:context];
        if([self validateDictionaryValueForKey:row1.text])
        [newContact setValue:row1.text forKey:@"row1"];
        else
        [newContact setValue:@"" forKey:@"row1"];

        
        if([self validateDictionaryValueForKey:row2.text])
        [newContact setValue:row2.text forKey:@"row2"];
        else
        [newContact setValue:@"" forKey:@"row2"];

        
        if([self validateDictionaryValueForKey:row3.text])
        [newContact setValue:row3.text forKey:@"row3"];
        else
        [newContact setValue:@"" forKey:@"row3"];

        
        if([self validateDictionaryValueForKey:row4.text])
        [newContact setValue:row4.text forKey:@"row4"];
        else
        [newContact setValue:@"" forKey:@"row4"];

        
        if([self validateDictionaryValueForKey:row5.text])
        [newContact setValue:row5.text forKey:@"row5"];
        else
        [newContact setValue:@"" forKey:@"row5"];

        
        if([self validateDictionaryValueForKey:row6.text])
        [newContact setValue:row6.text forKey:@"row6"];
        else
            [newContact setValue:@"" forKey:@"row6"];

        if([self validateDictionaryValueForKey:row7.text])
        [newContact setValue:row7.text forKey:@"row7"];
        else
        [newContact setValue:@"" forKey:@"row7"];

        
        if([self validateDictionaryValueForKey:row8.text])
        [newContact setValue:row8.text forKey:@"row8"];
        else
            [newContact setValue:@"" forKey:@"row8"];

        
        if([self validateDictionaryValueForKey:row9.text])
        [newContact setValue:row9.text forKey:@"row9"];
        else
            [newContact setValue:@"" forKey:@"row9"];

        
        if([self validateDictionaryValueForKey:row10.text])
        [newContact setValue:row10.text forKey:@"row10"];
        else
            [newContact setValue:@"" forKey:@"row10"];

        
        [newContact setValue:[NSNumber numberWithInt:1] forKey:@"id"];
        
        if([self validateDictionaryValueForKey:organization_name.text])
        [newContact setValue:organization_name.text forKey:@"organization_name"];
        else
        [newContact setValue:@"" forKey:@"organization_name"];

        
        if([self validateDictionaryValueForKey:organization_name.text])
        [newContact setValue:company_name.text forKey:@"company_name"];
        else
            [newContact setValue:@"" forKey:@"company_name"];
 
            if([self validateDictionaryValueForKey:address1.text])
        [newContact setValue:address1.text forKey:@"address1"];
        else
            [newContact setValue:@"" forKey:@"address1"];
  
            if([self validateDictionaryValueForKey:address2.text])
        [newContact setValue:address2.text forKey:@"address2"];
        else
            [newContact setValue:@"" forKey:@"address2"];
 
            if([self validateDictionaryValueForKey:zipcode.text])
        [newContact setValue:zipcode.text forKey:@"zipcode"];
        else
            [newContact setValue:@"" forKey:@"zipcode"];

            if([self validateDictionaryValueForKey:city.text])
        [newContact setValue:city.text forKey:@"city"];
        else
            [newContact setValue:@"" forKey:@"city"];
 
            if([self validateDictionaryValueForKey:phone.text])
        [newContact setValue:phone.text forKey:@"phone"];
        else
            [newContact setValue:@"" forKey:@"phone"];

            if([self validateDictionaryValueForKey:fax.text])
        [newContact setValue:fax.text forKey:@"fax"];
        else
            [newContact setValue:@"" forKey:@"fax"];
 
            if([self validateDictionaryValueForKey:homepage.text])
        [newContact setValue:homepage.text forKey:@"homepage"];
        else
            [newContact setValue:@"" forKey:@"homepage"];

        [context save:&error];
    }
    else
    {
        NSManagedObject *person = (NSManagedObject *)[objects objectAtIndex:0];
        
        
        if([self validateDictionaryValueForKey:row1.text])
            [person setValue:row1.text forKey:@"row1"];
        else
            [person setValue:@"" forKey:@"row1"];
        
        
        if([self validateDictionaryValueForKey:row2.text])
            [person setValue:row2.text forKey:@"row2"];
        else
            [person setValue:@"" forKey:@"row2"];
        
        
        if([self validateDictionaryValueForKey:row3.text])
            [person setValue:row3.text forKey:@"row3"];
        else
            [person setValue:@"" forKey:@"row3"];
        
        
        if([self validateDictionaryValueForKey:row4.text])
            [person setValue:row4.text forKey:@"row4"];
        else
            [person setValue:@"" forKey:@"row4"];
        
        
        if([self validateDictionaryValueForKey:row5.text])
            [person setValue:row5.text forKey:@"row5"];
        else
            [person setValue:@"" forKey:@"row5"];
        
        
        if([self validateDictionaryValueForKey:row6.text])
            [person setValue:row6.text forKey:@"row6"];
        else
            [person setValue:@"" forKey:@"row6"];
        
        if([self validateDictionaryValueForKey:row7.text])
            [person setValue:row7.text forKey:@"row7"];
        else
            [person setValue:@"" forKey:@"row7"];
        
        
        if([self validateDictionaryValueForKey:row8.text])
            [person setValue:row8.text forKey:@"row8"];
        else
            [person setValue:@"" forKey:@"row8"];
        
        
        if([self validateDictionaryValueForKey:row9.text])
            [person setValue:row9.text forKey:@"row9"];
        else
            [person setValue:@"" forKey:@"row9"];
        
        
        if([self validateDictionaryValueForKey:row10.text])
            [person setValue:row10.text forKey:@"row10"];
        else
            [person setValue:@"" forKey:@"row10"];
        
        
        if([self validateDictionaryValueForKey:organization_name.text])
            [person setValue:organization_name.text forKey:@"organization_name"];
        else
            [person setValue:@"" forKey:@"organization_name"];
        
        
        if([self validateDictionaryValueForKey:organization_name.text])
            [person setValue:company_name.text forKey:@"company_name"];
        else
            [person setValue:@"" forKey:@"company_name"];
        
        if([self validateDictionaryValueForKey:address1.text])
            [person setValue:address1.text forKey:@"address1"];
        else
            [person setValue:@"" forKey:@"address1"];
        
        if([self validateDictionaryValueForKey:address2.text])
            [person setValue:address2.text forKey:@"address2"];
        else
            [person setValue:@"" forKey:@"address2"];
        
        if([self validateDictionaryValueForKey:zipcode.text])
            [person setValue:zipcode.text forKey:@"zipcode"];
        else
            [person setValue:@"" forKey:@"zipcode"];
        
        if([self validateDictionaryValueForKey:city.text])
            [person setValue:city.text forKey:@"city"];
        else
            [person setValue:@"" forKey:@"city"];
        
        if([self validateDictionaryValueForKey:phone.text])
            [person setValue:phone.text forKey:@"phone"];
        else
            [person setValue:@"" forKey:@"phone"];
        
        if([self validateDictionaryValueForKey:fax.text])
            [person setValue:fax.text forKey:@"fax"];
        else
            [person setValue:@"" forKey:@"fax"];
        
        if([self validateDictionaryValueForKey:homepage.text])
            [person setValue:homepage.text forKey:@"homepage"];
        else
            [person setValue:@"" forKey:@"homepage"];
        
        [context save:&error];
        
        [[NSUserDefaults standardUserDefaults] setObject:organization_name.text  forKey:@"Org_Name"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
    }
    organization_name.textColor = [UIColor lightGrayColor];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ISUPOS" message:[NSString stringWithFormat:@"%@", [Language get:@"Data saved." alter:@"!Data saved."]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}
-(void)getdata
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context =[appDelegate managedObjectContext];
    NSEntityDescription *entityDesc =[NSEntityDescription entityForName:@"ReceiptData" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    
    for(int i=0;i<objects.count;i++)
    {
        NSManagedObject *person = (NSManagedObject *)[objects objectAtIndex:0];
        row1.text=[person valueForKey:@"row1"];
        row2.text=[person valueForKey:@"row2"];
        row3.text=[person valueForKey:@"row3"];
        row4.text=[person valueForKey:@"row4"];
        row5.text=[person valueForKey:@"row5"];
        row6.text=[person valueForKey:@"row6"];
        row7.text=[person valueForKey:@"row7"];
        row8.text=[person valueForKey:@"row8"];
        row9.text=[person valueForKey:@"row9"];
        row10.text=[person valueForKey:@"row10"];
        
        organization_name.text=[person valueForKey:@"organization_name"];
        if (organization_name.text.length>0) {
            organization_name.userInteractionEnabled=FALSE;
            organization_name.textColor = [UIColor lightGrayColor];
            
        }
        company_name.text=[person valueForKey:@"company_name"];
        address1.text=[person valueForKey:@"address1"];
        address2.text=[person valueForKey:@"address2"];
        zipcode.text=[person valueForKey:@"zipcode"];
        city.text=[person valueForKey:@"city"];
        phone.text=[person valueForKey:@"phone"];
        fax.text=[person valueForKey:@"fax"];
        homepage.text=[person valueForKey:@"homepage"];
    }
}
#pragma mark - UITextField Delegates

- (void)textFieldDidEndEditing:(UITextField *)textField
{
//    if(textField.tag>=10)
//    {
////        [UIView beginAnimations:@"animate" context:nil];
////        [UIView setAnimationDuration:0.35f];
////        [UIView setAnimationBeginsFromCurrentState: NO];
////        self.view.frame = CGRectMake(self.view.frame.origin.x,-250 , self.view.frame.size.width, self.view.frame.size.height);
////        [UIView commitAnimations];
//        [scrv setContentOffset:CGPointMake(0, textField.frame.origin.y) animated:YES];
//    }
//    else
//    {
////        [UIView beginAnimations:@"animate" context:nil];
////        [UIView setAnimationDuration:0.35f];
////        [UIView setAnimationBeginsFromCurrentState: NO];
////        self.view.frame = CGRectMake(self.view.frame.origin.x, 0 , self.view.frame.size.width, self.view.frame.size.height);
////        [UIView commitAnimations];
//        
//    }
//
     [scrv setContentOffset:CGPointMake(0, -60) animated:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField

{
     [scrv setContentOffset:CGPointMake(0, textField.frame.origin.y - 145) animated:YES];
//    if(textField.tag>9)
//    {
////        [UIView beginAnimations:@"animate" context:nil];
////        [UIView setAnimationDuration:0.35f];
////        [UIView setAnimationBeginsFromCurrentState: NO];
////        self.view.frame = CGRectMake(self.view.frame.origin.x,-190 , self.view.frame.size.width, self.view.frame.size.height);
////        [UIView commitAnimations];
//        
//    }
//    if(textField.tag<10)
//    {
//        //        [UIView beginAnimations:@"animate" context:nil];
//        //        [UIView setAnimationDuration:0.35f];
//        //        [UIView setAnimationBeginsFromCurrentState: NO];
//        //        self.view.frame = CGRectMake(self.view.frame.origin.x,-250 , self.view.frame.size.width, self.view.frame.size.height);
//        //        [UIView commitAnimations];
//        [scrv setContentOffset:CGPointMake(0, textField.frame.origin.y) animated:YES];
//    }

}
- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController
{
    return NO;
}
@end
