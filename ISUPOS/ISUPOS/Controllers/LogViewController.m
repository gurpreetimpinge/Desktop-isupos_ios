//
//  LogViewController.m
//  ISUPOS
//
//  Created by Mandeep Sharma on 26/10/15.
//  Copyright (c) 2015 Impinge Solutions. All rights reserved.
//

#import "LogViewController.h"
#import "LogViewCustomTableViewCell.h"
#import "AppDelegate.h"
#import "Language.h"
#import "TrasectionsViewController.h"
#import "reportViewController.h"
#import "ManageArticalViewController.h"
#import "quickBlocksButtonsView.h"
#import "helo&supportViewController.h"
#import "generalSettingViewController.h"
#import "receiptDataViewController.h"
#import "linkToViewController.h"
#import "Reachability.h"
#import "UITextField+Validations.h"

@interface LogViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *logData;
    AppDelegate *appDelegate;
    UIView *moreButtonView;
    NSMutableArray *morebuttons;
    UIPopoverController *popover;
    UIButton *morebutton;
//    UIView *printerview;
    int printCount;
    NSString *text_string;

    UIAlertView *alertViewChangeName;


}
@end

@implementation LogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.printerCopies setText:[NSString stringWithFormat:@"1 %@",[Language get:@"Copy" alter:@"!Copy"]]];
    // Do any additional setup after loading the view.
    for (UIView *view in self.navigationController.navigationBar.subviews )
    {
        if (view.tag == -1)
        {
            [view removeFromSuperview];
        }
        
    }
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UINavigationBar appearance] setFrame:CGRectMake(0, 0, 1024, 64)];
    [self getLogData];
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

    [self add_button_on_tabbar];
    
    text_string = @"BT:PRNT Star";
    
    [self setPortInfo];
    NSString *portName = [AppDelegate getPortName];
    NSString *portSettings = [AppDelegate getPortSettings];
    [MiniPrinterFunctions CheckStatusWithPortname:portName portSettings:portSettings sensorSetting:SensorActiveHigh];
    
     self.label_PrinterName.text=[[NSUserDefaults standardUserDefaults] valueForKey:@"PrinterStatus"];
    
    self.printerView.hidden = YES;
    printCount = 1;
    
    [self settitles];
    
}



//-(BOOL)prefersStatusBarHidden
//{
//    return YES;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) settitles
{
    self.label_Date.text = [Language get:@"Date" alter:@"!Date"];
    self.label_Desc.text = [Language get:@"Description" alter:@"!Description"];
    [self.btnBack setTitle:[Language get:@"Back" alter:@"!Back"] forState:UIControlStateNormal];
    self.lbl_Printer.text = [Language get:@"Printer" alter:@"!Printer"];
    self.lbl_PrinterOptions.text = [Language get:@"Printer Options" alter:@"!Printer Options"];
    [self.btn_Print setTitle:[Language get:@"Print" alter:@"!Print"] forState:UIControlStateNormal];
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
        
        else if (button.tag==9){
            [moreButtonView removeFromSuperview];
            klm=10;
            [self.tabBarController setSelectedIndex:4];
            
            
            LogViewController *logViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LogViewController"];
            [self.navigationController presentViewController:logViewController animated:NO completion:nil];
        }
        
    }
    else
    {
        if(moreButtonView==nil||button.tag==999)
        {
            //,[Language get:@"Printers" alter:@"!Printers"]
            
            morebuttons=[[NSMutableArray alloc]initWithObjects:[Language get:@"Manage Articles" alter:@"!Manage Articles"],[Language get:@"Quick Button/Blocks" alter:@"!Quick Button/Blocks"],[Language get:@"Receipt Data" alter:@"!Receipt Data"], [Language get:@"Transactions" alter:@"!Transactions"],[Language get:@"Reports" alter:@"!Reports"], [Language get:@"About ISUPOS" alter:@"!About ISUPOS"],[Language get:@"General Settings" alter:@"!General Settings"], [Language get:@"Sign Out" alter:@"!Sign Out"],[Language get:@"Audit Log" alter:@"!Audit Log"] ,nil];
            
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
        
        else if (button.tag==9){
            [moreButtonView removeFromSuperview];
            klm=10;
            [self.tabBarController setSelectedIndex:4];
            
            
            LogViewController *logViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LogViewController"];
            [self.navigationController presentViewController:logViewController animated:NO completion:nil];
        }
        
    }
    [self.view setNeedsDisplay];
    
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
    self.printerView.hidden = YES;
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [logData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    
    static NSString *CellIdentifier = @"LogViewCustomCell";
    
    LogViewCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[LogViewCustomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    cell.lbl_SerialNumber.text = [NSString stringWithFormat:@"%d.",indexPath.row+1];
    cell.lbl_Description.text = [NSString stringWithFormat:@"%@",[[logData valueForKey:@"discription"] objectAtIndex:indexPath.row]];
     cell.lbl_Date.text =[NSString stringWithFormat:@"%@",[[logData valueForKey:@"date"] objectAtIndex:indexPath.row]];
    return cell;
}


#pragma mark Get Log Data

-(void)getLogData
{
    
    logData=[[NSMutableArray alloc]init];

    appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context =[appDelegate managedObjectContext];
    NSEntityDescription *entityDesc =[NSEntityDescription entityForName:@"Log" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    
    
    for(int i=0;i<objects.count;i++)
    {
        NSManagedObject *person = (NSManagedObject *)[objects objectAtIndex:i];
       
        NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
        
        
        if (![[person valueForKey:@"date"] isEqual:NULL] && ![[person valueForKey:@"date"] isEqual:[NSNull null]]&&![[person valueForKey:@"date"] isEqual:nil]&&[person valueForKey:@"date"]!=nil)
        {
            NSDate *date_get=[person valueForKey:@"date"];
            
//            
            
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];

            [dateFormatter setDateFormat:@"MMMM"];
            
            NSString *str_month = [dateFormatter stringFromDate:date_get];
            
            
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
            
            NSString *str_day = [dateFormatter stringFromDate:date_get];
            
            [dateFormatter setDateFormat:@"yyyy"];
            
            NSString *str_year = [dateFormatter stringFromDate:date_get];
            
            [dateFormatter setDateFormat:@"hh:mm:ss a"];
            
            NSString *str_time = [dateFormatter stringFromDate:date_get];
            
//            
            
//            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
            [dateFormatter setDateFormat:@"dd MMMM yyyy, hh:mm:ss"];
            
            NSString *string = [NSString stringWithFormat:@"%@ %@ %@ %@", str_day,str_month,str_year,str_time];
//            NSDate *dateFinal = [dateFormatter dateFromString:string];
            
//            NSString *str_date=[dateFormatter stringFromDate:dateFinal];
            
            [dict setValue:string forKey:@"date"];
            
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",[person valueForKey:@"date"]] forKey:@"date"];
        }
        else
        {
            [dict setValue:@"" forKey:@"date"];
        }
        if (![[person valueForKey:@"discription"] isEqual:NULL] && ![[person valueForKey:@"discription"] isEqual:[NSNull null]] &&![[person valueForKey:@"discription"] isEqual:nil]&&[person valueForKey:@"discription"]!=nil)
        {
            [dict setValue:[person valueForKey:@"discription"] forKey:@"discription"];
            
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",[person valueForKey:@"discription"]] forKey:@"description"];
        }
        else
        {
            [dict setValue:@"" forKey:@"discription"];
        }
        if (![[person valueForKey:@"sno"] isEqual:NULL] && ![[person valueForKey:@"sno"] isEqual:[NSNull null]] &&![[person valueForKey:@"sno"] isEqual:nil]&&[person valueForKey:@"sno"]!=nil)
        {
            [dict setValue:[person valueForKey:@"sno"] forKey:@"sno"];
            
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",[person valueForKey:@"sno"]] forKey:@"sno"];
        }
        else
        {
            [dict setValue:@"" forKey:@"sno"];
        }
        
        [logData addObject:dict];
    }
    
    appDelegate.arrayPrintLog=logData;
    
    
    [self.tableView reloadData];
}



- (IBAction)backButton_Action:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
   // [self.navigationController popViewControllerAnimated:YES];
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
    [LogViewController setPortName:localPortName];
    
    NSString *localPortSettings = @"mini";
    
    [LogViewController setPortSettings:localPortSettings];
}




- (IBAction)btnPrinterAction:(UIButton *)sender {
    
    self.label_PrinterName.text=[[NSUserDefaults standardUserDefaults] valueForKey:@"PrinterStatus"];
    
     self.printerView.hidden=NO;
    
    
}
- (IBAction)btnMailAction:(UIButton *)sender {
 
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    if (internetStatus != NotReachable) {
        
        
        self.printerView.hidden=YES;
        alertViewChangeName=[[UIAlertView alloc]initWithTitle:@"ISUPOS" message:[Language get:@"Please enter your email" alter:@"!Please enter your email"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        alertViewChangeName.alertViewStyle=UIAlertViewStylePlainTextInput;
        alertViewChangeName.tag=104;
        [alertViewChangeName show];
    }
    else {
        [[[UIAlertView alloc] initWithTitle:@"ISUPOS" message:[Language get:@"Please check your internet connection." alter:@"!Please check your internet connection."] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

    if (alertView.tag == 104) {
        if (buttonIndex == 0) {
            if ([[alertView textFieldAtIndex:0] validEmailAddress]) {
                
                
                [[NSUserDefaults standardUserDefaults] setObject:@"Repo" forKey:@"MailType"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                NSString *email = [alertViewChangeName textFieldAtIndex:0].text;
                [[NSUserDefaults standardUserDefaults] setObject:email forKey:@"EMAIL"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [[AppDelegate delegate] sendLogDetailMailWithSubject:@"Receipt" sendFrom:@"" ToReciepents:@"" messageHtmlBodyContent:@""];
                
            }
            
        }
    }
}

- (IBAction)btnPrint_Log:(UIButton *)sender {
    
        [self setPortInfo];
        NSString *portName = [AppDelegate getPortName];
        NSString *portSettings = [AppDelegate getPortSettings];
        

        [[NSUserDefaults standardUserDefaults] setObject:@"Yes" forKey:@"LogRecipt"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        [[NSUserDefaults standardUserDefaults] setObject:@"Copy" forKey:@"ReciptType"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        for (int i =1; i<=printCount; i++) {
            
            [MiniPrinterFunctions PrintSampleReceiptWithPortname:portName
                                                    portSettings:portSettings
                                                       widthInch:2];
            
        }
        
        self.printerView.hidden=YES;
        
    
}

- (IBAction)stepper_Action:(UIStepper *)sender {
    
    {
        double value = [sender value];
        
        printCount=[sender value];
        
        sender.minimumValue = 1;
        
        
        [self.printerCopies setText:[NSString stringWithFormat:@"%d %@", (int)value,[Language get:@"Copy" alter:@"!Copy"]]];
        if((int)value>1)
            [self.printerCopies setText:[NSString stringWithFormat:@"%d %@", (int)value,[Language get:@"Copies" alter:@"!Copies"]]];
    }
    
}

- (IBAction)btnPrint:(UIButton *)sender {
    
   

}
@end
