//
//  ParkRecieptViewController.m
//  ISUPOS
//
//  Created by Rohit Mahajan on 4/15/15.
//  Copyright (c) 2015 Impinge Solutions. All rights reserved.
//

#import "ParkRecieptViewController.h"
#import "parkrecieptTableViewCell.h"
#import "quickBlocksButtonsView.h"
#import "helo&supportViewController.h"
#import "generalSettingViewController.h"
#import "language.h"
#import "UITextField+Validations.h"
#import "Reachability.h"
#import "AppDelegate.h"
#import "LogViewController.h"

@interface ParkRecieptViewController ()
{
    UIView *moreButtonView;
    NSMutableArray *morebuttons;
    UIButton *morebutton;
    UIPopoverController *popover;
    IBOutlet UIView *filterview;
    IBOutlet UIButton *namebutton,*discriptionButton,*numberButton;
    NSMutableArray *arrayParkDate,*arrayCustomerid,*arrayTotalPrice;
    NSString *currencySign;
    NSMutableArray *arrayProductImage, *arrayProductName, *arrayProductQuantity, *arrayProductPrice ,*arrayProductVat,*arrayProductdiscount,*arrayProductdiscription,*arrayProductid,*arrayProductdiscountType,*arrayFinalReceipt;
    float total,totalvat;
    int indexNo;
    
    IBOutlet UILabel *totalcartValue,*totalCartVat;
    UIAlertView *alertViewChangeName;
    
    IBOutlet UITableView *tablecartview,*tableparkedcartview;
    
    AppDelegate *appDelegate;
    
    IBOutlet UIView *view_EmailPopUpBg,*view_EmailBg;
    IBOutlet UITextField *txt_Email;
    IBOutlet UIButton *btn_DropDown,*btn_EmailOk,*btn_EmailCancel;
    IBOutlet UITableView *tbl_EmailList;
    
    NSMutableArray *ary_EmailList;
}
@end

@implementation ParkRecieptViewController

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
    self.title=[Language get:@"Park Receipts" alter:@"!Park Receipts"];


    actionlbl.text=[Language get:@"Action" alter:@"!Action"];
    parktimelbl.text=[Language get:@"Park Time" alter:@"!Park Time"];
    notice_lbl.text=[Language get:@"Notice" alter:@"!Notice"];
   
    total_lbl.text=[Language get:@"Total" alter:@"!Total"];
    amount_lbl1.text=[Language get:@"Amount" alter:@"!Amount"];
    totallbl1.text=[Language get:@"Price" alter:@"!Price"];
    article_lbl1.text=[Language get:@"Article Name" alter:@"!Article Name"];
    
    
    [b1 setTitle:[Language get:@"Park on going receipt" alter:@"!Park on going receipt"] forState:UIControlStateNormal];
    [b2 setTitle:[Language get:@"Print ongoing receipt as tab" alter:@"!Print ongoing receipt as tab"] forState:UIControlStateNormal];
    
    
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // Splunk Mint Breadcrumb added
    [[Mint sharedInstance] leaveBreadcrumb:@"ParkReceiptViewController_ViewController"];
    
    filterview.hidden=YES;
  
    view_EmailBg.layer.borderWidth = 1;
    view_EmailBg.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    
    tbl_EmailList.layer.borderWidth = 1;
    tbl_EmailList.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    
    ary_EmailList = [NSMutableArray new];
    
    UIButton *calculator = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIImage *calculatorBtnImage = [UIImage imageNamed:@"CalculatorIcon.png"];
    
    [calculator setBackgroundImage:calculatorBtnImage forState:UIControlStateNormal];
    
    calculator.frame = CGRectMake(0, 0, 25, 33);
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:calculator] ;
    
    
    
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
  //  lbl_manReg_ID.text = [defaults objectForKey:@"INFRASEC_PASSWORD"];
     lbl_manReg_ID.text = [defaults objectForKey:@"POS_ID"];
    lbl_manReg_ID.textColor = [UIColor whiteColor];
    lbl_manReg_ID.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:11];
    
//    [self.navigationController.navigationBar addSubview:lbl_manReg_ID];
    
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

    
//    self.pro_code_BarButton.title = [NSString stringWithFormat:@"Product: %@ %@ %@", string1, string2, [dictRoot valueForKey:@"Version"]];
    
    //self.navigationItem.rightBarButtonItem = backButton;
    
    // Do any additional setup after loading the view.
}
- (void) viewWillAppear:(BOOL)animated
{
    
    view_EmailPopUpBg.hidden = YES;
    
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
    total=0.0;
    totalvat=0.0;
    totalcartValue.text=[NSString stringWithFormat:@"%@ %.02f",currencySign,total];
    
    totalCartVat.text=[NSString stringWithFormat:@"Including %@ %.02f VAT",currencySign,totalvat];
    [self add_button_on_tabbar];
    [self getAllParkedList];
    [self getCartData];
    
    
    
    self.navigationController.navigationBarHidden = NO;
    

    
//    NSManagedObject *newContact;
//    newContact = [NSEntityDescription insertNewObjectForEntityForName:@"Log" inManagedObjectContext:context];
//    
//    [newContact setValue:[NSDate date] forKey:@"date"];
//    [newContact setValue:[Language get:@"Park Receipts" alter:@"!Park Receipts"] forKey:@"discription"];
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




# pragma mark table view datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView.tag==10)
        return arrayCustomerid.count;
    else if (tableView == tbl_EmailList)
    {
        return [ary_EmailList count];
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
    //
    if(tableView.tag==10)
    {
        static NSString *simpleTableIdentifier = @"parkrecieptCell";
        
        parkrecieptTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if (cell == nil) {
            cell = [[parkrecieptTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        
        [cell.activate_button setTitle:[NSString stringWithFormat:@"%@", [Language get:@"Activate" alter:@"!Activate"]] forState:UIControlStateNormal];
        cell.activate_button.tag=indexPath.row;
        [cell.activate_button addTarget:self action:@selector(activateParkedCart:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.labelCustomerName.text=[NSString stringWithFormat:@"%@ %d",[Language get:@"Customer" alter:@"!Customer"], [arrayCustomerid[indexPath.row] intValue]];
        cell.labelProductdate.text=arrayParkDate[indexPath.row];
        cell.labelTotalPrice.text=[NSString stringWithFormat:@"%@ %@",currencySign,arrayTotalPrice[indexPath.row]];
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
        
        UIFont * myFont = [UIFont fontWithName:@"Arial" size:16];
        CGRect labelFrame = CGRectMake (30, 15, 250, 25);
        UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
        [label setFont:myFont];
        label.lineBreakMode=NSLineBreakByWordWrapping;
        label.numberOfLines=5;
        label.textColor=[UIColor darkGrayColor];
        label.backgroundColor=[UIColor clearColor];
        [cell addSubview:label];
        
        
        UIFont * myFont1 = [UIFont fontWithName:@"Arial" size:16];
        CGRect labelFrame1 = CGRectMake (190, 15, 30, 25);
        UILabel *label1 = [[UILabel alloc] initWithFrame:labelFrame1];
        [label1 setFont:myFont1];
        label1.lineBreakMode=NSLineBreakByWordWrapping;
        label1.numberOfLines=5;
        label1.textColor=[UIColor darkGrayColor];
        label1.backgroundColor=[UIColor clearColor];
        [cell addSubview:label1];
        
        
        
        CGRect labelFrame2 = CGRectMake (250, 15, 100, 30);
        UILabel *label2 = [[UILabel alloc] initWithFrame:labelFrame2];
        [label2 setFont:myFont1];
        label2.textAlignment=NSTextAlignmentRight;
        label2.lineBreakMode=NSLineBreakByWordWrapping;
        label2.numberOfLines=5;
        label2.textColor=[UIColor darkGrayColor];
        label2.backgroundColor=[UIColor clearColor];
        [cell addSubview:label2];
        
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
            
            
            [label setText:[NSString stringWithFormat:@"%@",[person valueForKey:@"discription"]]];
            //[label1 setText:[NSString stringWithFormat:@"%d",[arrayProductQuantity[indexPath.row] intValue] ]];
            
            
            
//            if([[person valueForKey:@"type"] isEqualToString:currencySign])
//            {
//                [label2 setText:[NSString stringWithFormat:@"%.02f",total-(total-[[person valueForKey:@"discount"] floatValue])]];
//                
//            }
//            else
//            {
//                
//                [label2 setText:[NSString stringWithFormat:@"%.02f",(total*[[person valueForKey:@"discount"] floatValue])/100]];
//                
//            }
//            if(total-[label2.text floatValue])
//                totalcartValue.text=[NSString stringWithFormat:@"-%@%0.2f",currencySign,fabsf(total-[label2.text floatValue])];
//            else
//                totalcartValue.text=[NSString stringWithFormat:@"%@%0.2f",currencySign,total-[label2.text floatValue]];
            
            
            
            float cc;
            
            if([[person valueForKey:@"type"] isEqualToString:currencySign])
            {
                [label2 setText:[NSString stringWithFormat:@"-%@ %.02f",currencySign,[[person valueForKey:@"discount"] floatValue]]];
                cc=[[person valueForKey:@"discount"] floatValue];
                
                
                [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%.02f",[[person valueForKey:@"discount"] floatValue]] forKey:@"reciptDis"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
            }
            else
            {
                
                [label2 setText:[NSString stringWithFormat:@"%@ -%.02f",currencySign,(total*[[person valueForKey:@"discount"] floatValue])/100]];
                cc=(total*[[person valueForKey:@"discount"] floatValue])/100;
                 totalCartVat.text=[NSString stringWithFormat:@"%@ %@ %.02f %@",[Language get:@"Including" alter:@"!Including"],currencySign,totalvat-((totalvat*[[person valueForKey:@"discount"] floatValue])/100), [Language get:@"VAT" alter:@"!VAT"]];
                
                if (totalvat-((totalvat*[[person valueForKey:@"discount"] floatValue])/100)==0.00) {
                    totalCartVat.text=[NSString stringWithFormat:@"%@",[Language get:@"Including VAT" alter:@"!Including VAT"]];
                }
                
                [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%.02f",(total*[[person valueForKey:@"discount"] floatValue])/100] forKey:@"reciptDis"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
            }
            
            if(total-cc<0)
                totalcartValue.text=[NSString stringWithFormat:@"-%@ %0.2f",currencySign,fabsf(total-cc)];
            else
                totalcartValue.text=[NSString stringWithFormat:@"%@ %0.2f",currencySign,total-cc];
            
            
            if(total-cc<0)
                [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",fabsf(total-cc)] forKey:@"reciptTotal"];
            else
                [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",total-cc] forKey:@"reciptTotal"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            

            //totalcartValue.text=[NSString stringWithFormat:@"%@%0.2f",currencySign,total-[label2.text floatValue]];
        }
        else
        {
            [label setText:[NSString stringWithFormat:@"%@",arrayProductName[indexPath.row]]];
            [label1 setText:[NSString stringWithFormat:@"%d",[arrayProductQuantity[indexPath.row] intValue] ]];
            
            float discountperproduct;
            
            
            if([[arrayProductdiscountType objectAtIndex:indexPath.row] isEqualToString:@"%"])
            {
                discountperproduct=([[arrayProductPrice objectAtIndex:indexPath.row] floatValue]*[[arrayProductQuantity objectAtIndex:indexPath.row] intValue]*[[arrayProductdiscount objectAtIndex:indexPath.row]floatValue])/100;
            }
            else
            {
                discountperproduct=[[arrayProductdiscount objectAtIndex:indexPath.row]floatValue];
            }
            
         
            [label2 setText:[NSString stringWithFormat:@"%@ %.2f",currencySign,[[arrayProductPrice objectAtIndex:indexPath.row] floatValue]*[[arrayProductQuantity objectAtIndex:indexPath.row] intValue]- discountperproduct]];
            //[label2 setText:[NSString stringWithFormat:@"%@ %.02f",currencySign,([arrayProductPrice[indexPath.row] floatValue]-[arrayProductdiscount[indexPath.row] floatValue])*[arrayProductQuantity[indexPath.row] intValue]]];
            
        }

        cell.backgroundColor=[UIColor clearColor];
        
        
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(tableView.tag==10)
    {
        return 48;
    }
    if (tableView == tbl_EmailList)
    {
        return 60;
    }
    else
    {
        return 50;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == tbl_EmailList)
    {
        txt_Email.text = [ary_EmailList objectAtIndex:indexPath.row];
        tbl_EmailList.hidden = YES;
    }
    
}

#pragma mark - IBActions
-(IBAction)park_current_cart_btn:(id)sender
{
    [self parkCurrentCart];
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
                
                
                NSString *email = txt_Email.text;
                [[NSUserDefaults standardUserDefaults] setObject:email forKey:@"EMAIL"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [[AppDelegate delegate] sendReceiptMailWithSubject:@"Receipt" sendFrom:@"" ToReciepents:@"" messageHtmlBodyContent:@""];
                
                
                view_EmailPopUpBg.hidden = YES;
            }
            
        }
        
    }
    else if (sender == btn_EmailCancel)
    {
        view_EmailPopUpBg.hidden = YES;
    }
}

#pragma mark - MailSend Methods

- (IBAction)mailSendButton:(UIButton *)sender {
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    if (internetStatus != NotReachable) {
    
//        if([appDelegate.reciptArrayReceipt count]>0)
//        {
        
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
//    alertViewChangeName.tag=105;
//    alertViewChangeName.alertViewStyle=UIAlertViewStylePlainTextInput;
//    [alertViewChangeName show];
//        }
    
    }
    else {
        [[[UIAlertView alloc] initWithTitle:@"ISUPOS" message:[Language get:@"Please check your internet connection." alter:@"!Please check your internet connection."] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
        
//    // Email Subject
//    NSString *emailTitle = @"ISUPOS";
//    // Email Content
//    NSString *messageBody = @"<h1>ISUPOS!</h1>";
//    // To address
//    NSArray *toRecipents = [NSArray arrayWithObject:@"richag@impingeonline.com"];
//    
//    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
//    mc.mailComposeDelegate = self;
//    if([MFMailComposeViewController canSendMail])
//    {
//        [mc.navigationBar setTintColor:[UIColor whiteColor]];
//        
//        if ([[UINavigationBar class] respondsToSelector:@selector(appearance)])
//            // set the navigation bar font to "courier-new bold 14"
//            [[UINavigationBar appearance] setTitleTextAttributes:
//             [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,[NSValue valueWithUIOffset:UIOffsetMake(1, 0)], UITextAttributeTextShadowOffset,
//              [UIFont systemFontOfSize:20], UITextAttributeFont,
//              nil]];
//        
//        [mc setSubject:emailTitle];
//        [mc setMessageBody:messageBody isHTML:YES];
//        [mc setToRecipients:toRecipents];
//        
//        // Present mail view controller on screen
//
//        [self presentViewController:mc animated:YES completion:NULL];
//    }
//    else
//    {
//        [self launchMailAppOnDevice];
////       @"Device not configured to send mail."
//        
//    }
    
    
}

// Launches the Mail application on the device.
//-(void)launchMailAppOnDevice
//{
//    NSString *str_Email = @"richag@impingeonline.com";
//    
//    NSString *recipients = [NSString stringWithFormat:@"mailto:%@?&subject=%@",str_Email,@"ISUPOS"];
//    NSString *body = @"&body=ISUPOS";
//    
//    NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
//    email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
//}
//
//
//
//
//
//- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
//{
//    switch (result)
//    {
//        case MFMailComposeResultCancelled:
//            NSLog(@"Mail cancelled");
//            break;
//        case MFMailComposeResultSaved:
//            NSLog(@"Mail saved");
//            break;
//        case MFMailComposeResultSent:
//            NSLog(@"Mail sent");
//            break;
//        case MFMailComposeResultFailed:
//            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
//            break;
//        default:
//            break;
//    }
//    
//    // Close the Mail Interface
//    [self dismissViewControllerAnimated:YES completion:NULL];
//}



-(IBAction)print_current_reciept_with_comment_btn:(id)sender
{
    
    
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
////            LogViewController *logViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LogViewController"];
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [moreButtonView removeFromSuperview];
    [self add_button_on_tabbar];
    moreButtonView=nil;
    filterview.hidden=YES;
    //[search_b resignFirstResponder];
    
    view_EmailPopUpBg.hidden = YES;
    
}
-(IBAction)name_filter_btn:(id)sender
{
    [namebutton setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    [discriptionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [numberButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    filterview.hidden=YES;
}
-(IBAction)discription_filter_btn:(id)sender
{
    [namebutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [discriptionButton setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    [numberButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    filterview.hidden=YES;
}
-(IBAction)number_filter_btn:(id)sender
{
    [namebutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [discriptionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [numberButton setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    filterview.hidden=YES;
}
-(IBAction)filter_btn_click:(id)sender
{
    filterview.hidden=NO;
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
     [self Settitles];
}
- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController
{
    return NO;
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
-(void)getCartData
{
    total=0.0;
    totalvat=0.0;
    arrayProductImage=[[NSMutableArray alloc]init];
    arrayProductName=[[NSMutableArray alloc]init];
    arrayProductQuantity=[[NSMutableArray alloc]init];
    arrayProductPrice=[[NSMutableArray alloc]init];
    arrayProductVat=[[NSMutableArray alloc]init];
    arrayProductdiscount=[[NSMutableArray alloc]init];
    arrayProductdiscription=[[NSMutableArray alloc]init];
    arrayProductid=[[NSMutableArray alloc]init];
    arrayProductdiscountType=[[NSMutableArray alloc]init];
    arrayFinalReceipt=[[NSMutableArray alloc]init];
    float zzzz;
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context =[appDelegate managedObjectContext];
    NSEntityDescription *entityDesc =[NSEntityDescription entityForName:@"Cart" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    for(int i=0;i<objects.count;i++)
    {
        NSManagedObject *person = (NSManagedObject *)[objects objectAtIndex:i];
        
        NSMutableDictionary *dict=[[NSMutableDictionary alloc] init];
        
        [dict setValue:[person valueForKey:@"name"] forKey:@"name"];
        [dict setValue:[person valueForKey:@"count"] forKey:@"count"];
        [dict setValue:[person valueForKey:@"price"] forKey:@"price"];
        [dict setValue:[person valueForKey:@"vat"] forKey:@"vat"];
        [dict setValue:[person valueForKey:@"discount"] forKey:@"discount"];
        [dict setValue:[person valueForKey:@"article_id"] forKey:@"article_id"];
        [dict setValue:[person valueForKey:@"barcode"] forKey:@"barcode"];
        
        
        
        NSData *da=[person valueForKey:@"image"];
        UIImage *img=[[UIImage alloc] initWithData:da];
        [arrayProductImage addObject:img];
        [arrayProductName addObject:[person valueForKey:@"name"]];
        [arrayProductQuantity addObject:[person valueForKey:@"count"]];
        [arrayProductPrice addObject:[person valueForKey:@"price"]];
        [arrayProductVat addObject:[person valueForKey:@"vat"]];
        [arrayProductdiscount addObject:[person valueForKey:@"discount"]];
        //[arrayProductdiscription addObject:[person valueForKey:@"vat"]];
        [arrayProductid addObject:[person valueForKey:@"article_id"]];
        
        
        NSEntityDescription *entityDesc1111 =[NSEntityDescription entityForName:@"Article" inManagedObjectContext:context];
        NSFetchRequest *request11111 = [[NSFetchRequest alloc] init];
        [request11111 setEntity:entityDesc1111];
        NSPredicate *pred =[NSPredicate predicateWithFormat:@"(article_no = %@)",[person valueForKey:@"article_id"]];
        [request11111 setPredicate:pred];
        
        NSArray *objects = [context executeFetchRequest:request11111 error:&error];
        
        NSManagedObject *matches = nil;
        if ([objects count] == 0) {
            [arrayProductdiscription addObject:@" "];
            [dict setValue:@"" forKey:@"article_description"];
        }
        else
        {
            matches = [objects objectAtIndex:0];
            [arrayProductdiscription addObject:[CommonMethods validateDictionaryValueForKey:[matches valueForKey:@"article_description"]]?[matches valueForKey:@"article_description"]:@""];
            [dict setValue:[CommonMethods validateDictionaryValueForKey:[matches valueForKey:@"article_description"]]?[matches valueForKey:@"article_description"]:@"" forKey:@"article_description"];
//            [arrayProductdiscription addObject:[matches valueForKey:@"article_description"]];
//            [dict setValue:[matches valueForKey:@"article_description"] forKey:@"article_description"];
            
        }
        
        
        if([person valueForKey:@"discountType"] == nil)
        {
            [arrayProductdiscountType addObject:@"%"];
            [dict setValue:@"%" forKey:@"discountType"];
        }
        else
        {
            [arrayProductdiscountType addObject:[person valueForKey:@"discountType"]];
            [dict setValue:[person valueForKey:@"discountType"] forKey:@"discountType"];
        }
        float discountperproduct;
        
        
        if([[person valueForKey:@"discountType"] isEqualToString:@"%"]|| [person valueForKey:@"discountType"] == nil)
        {
            discountperproduct=([[person valueForKey:@"price"]floatValue]*[[person valueForKey:@"count"]intValue]*[[person valueForKey:@"discount"]floatValue])/100;
            [dict setValue:[NSString stringWithFormat:@"%f",discountperproduct] forKey:@"discount"];
        }
        else
        {
            discountperproduct=[[person valueForKey:@"discount"]floatValue];
            
            [dict setValue:[person valueForKey:@"discount"] forKey:@"discount"];
        }
        
        total=(([[person valueForKey:@"price"] floatValue] *[[person valueForKey:@"count"] integerValue])-discountperproduct) + total;
        
        zzzz = (([[person valueForKey:@"price"] floatValue]*[[person valueForKey:@"count"] integerValue])-discountperproduct) / (1 + [[person valueForKey:@"vat"] floatValue]/100);
        
        zzzz=(([[person valueForKey:@"price"] floatValue] *[[person valueForKey:@"count"] integerValue])-discountperproduct)-zzzz;
        
        totalvat= zzzz  + totalvat;
        
        [dict setValue:[NSString stringWithFormat:@"%f",totalvat] forKey:@"totalvat"];
        
        [arrayFinalReceipt addObject:dict];
        
    }

    //Check-box.png
    totalcartValue.text=[NSString stringWithFormat:@"%@ %.02f",currencySign,total];
    totalCartVat.text=[NSString stringWithFormat:@"%@ %@ %.02f %@",[Language get:@"Including" alter:@"!Including"],currencySign,totalvat, [Language get:@"VAT" alter:@"!VAT"]];
    if (totalvat==0.00) {
        totalCartVat.text=[NSString stringWithFormat:@"%@",[Language get:@"Including VAT" alter:@"!Including VAT"]];
    }
    
    
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",totalvat] forKey:@"reciptVat"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    
    appDelegate.reciptArrayReceipt=[NSMutableArray new];
    
    appDelegate.reciptArrayReceipt=arrayFinalReceipt;
    
    [tablecartview reloadData];
}

-(void)parkCurrentCart
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context =[appDelegate managedObjectContext];
    NSEntityDescription *entityDesc =[NSEntityDescription entityForName:@"Cart" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    
    
    NSManagedObjectContext *context1 =[appDelegate managedObjectContext];
    NSEntityDescription *entityDesc1111 =[NSEntityDescription entityForName:@"ParkedCart" inManagedObjectContext:context1];
    NSFetchRequest *request11111 = [[NSFetchRequest alloc] init];
    [request11111 setEntity:entityDesc1111];
    NSArray *objectsde = [context1 executeFetchRequest:request11111 error:&error];
    NSManagedObject *ppp = (NSManagedObject *)[objectsde lastObject];
    
    for(int i=0;i<objects.count;i++)
    {
        NSManagedObject *person = (NSManagedObject *)[objects objectAtIndex:i];
        
        
        NSManagedObject *newContact;
        newContact = [NSEntityDescription insertNewObjectForEntityForName:@"ParkedCart" inManagedObjectContext:context];
        
        [newContact setValue:[NSNumber numberWithFloat:[[person valueForKey:@"vat"] floatValue]] forKey:@"vat"];
        [newContact setValue:[NSNumber numberWithFloat:[[person valueForKey:@"price" ] floatValue]] forKey:@"price"];
        [newContact setValue:[person valueForKey:@"name" ] forKey:@"name"];
        [newContact setValue:[NSDate date] forKey:@"on_date"];
        [newContact setValue:[person valueForKey:@"image"] forKey:@"image"];
        [newContact setValue:[NSString stringWithFormat:@"%d",[[ppp valueForKey:@"custId"] intValue]+1] forKey:@"custId"];
        [newContact setValue:[person valueForKey:@"count"] forKey:@"count"];
        [newContact setValue:[person valueForKey:@"discount"] forKey:@"discount"];
        [newContact setValue:[person valueForKey:@"article_id"] forKey:@"article_id"];
        [newContact setValue:[person valueForKey:@"barcode"] forKey:@"barcode"];
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
    
    [self getAllParkedList];
    [self getCartData];
    
}
-(void)getAllParkedList
{
    arrayParkDate=[[NSMutableArray alloc]init];
    arrayCustomerid=[[NSMutableArray alloc]init];
    arrayTotalPrice=[[NSMutableArray alloc]init];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context =[appDelegate managedObjectContext];
    NSEntityDescription *entityDesc =[NSEntityDescription entityForName:@"ParkedCart" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    
    NSMutableArray *temparr=[[NSMutableArray alloc]init];
    NSMutableArray *temparr1=[[NSMutableArray alloc]init];
    NSManagedObject *matches = nil;
    for(int i=0;i<objects.count;i++)
    {
        matches = [objects objectAtIndex:i];
        [temparr addObject:[matches valueForKey:@"custId"]];
        
        
        NSDate *date  = [matches valueForKey:@"on_date"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        // Convert date object into desired format
        [dateFormatter setDateFormat:@"yyyy/MM/dd hh:mm:ss"];
        NSString *newDateString = [dateFormatter stringFromDate:date];
        [temparr1 addObject:newDateString];
        
    }
    for (NSString *obj in temparr) {
        if ([arrayCustomerid containsObject:obj] == NO) {
            [arrayCustomerid addObject:obj];
        }
        
    }
    for (NSDate *obj11 in temparr1) {
        if ([arrayParkDate  containsObject:obj11] == NO) {
            [arrayParkDate addObject:obj11];
        }
        
    }
    for(int j=0;j<arrayCustomerid.count;j++)
    {
        float total1=0.0;
        NSEntityDescription *entityDesc1111 =[NSEntityDescription entityForName:@"ParkedCart" inManagedObjectContext:context];
        NSFetchRequest *request11111 = [[NSFetchRequest alloc] init];
        [request11111 setEntity:entityDesc1111];
        NSPredicate *pred =[NSPredicate predicateWithFormat:@"(custId = %@)",arrayCustomerid[j]];
        [request11111 setPredicate:pred];
        NSArray *objects = [context executeFetchRequest:request11111 error:&error];
        
        NSManagedObject *matches = nil;
        if ([objects count] == 0) {
        }
        else
        {
            
            for(int k=0;k<[objects count];k++)
            {
                matches = [objects objectAtIndex:k];
                total1=total1+(([[matches valueForKey:@"price"] floatValue]-[[matches valueForKey:@"discount"] floatValue])*([[matches valueForKey:@"count"] floatValue]) );
            }
            
            [arrayTotalPrice addObject:[NSString stringWithFormat:@"%.02f",total1]];
            total1=0;
        }
        
    }
    
    
    [tableparkedcartview reloadData];
}
-(void)activateParkedCart:(UIButton*)but
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context =[appDelegate managedObjectContext];
    NSEntityDescription *entityDesc =[NSEntityDescription entityForName:@"Cart" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    
    if(objects.count>0)
    {
        indexNo=(int)but.tag;
        UIAlertView* alert1 = [[UIAlertView alloc] init];
        [alert1 setDelegate:self];
        [alert1 setTitle:@"ISUPOS"];
        [alert1 setMessage:[Language get:@"Already have products in cart. Do you want to exchange the cart." alter:@"!Already have products in cart. Do you want to exchange the cart."]];
        [alert1 addButtonWithTitle:[Language get:@"Yes" alter:@"!Yes"]];
        [alert1 addButtonWithTitle:[Language get:@"No" alter:@"!No"]];
        alert1.tag=6;
        alert1.alertViewStyle = UIAlertViewStyleDefault;
        
        [alert1 show];
       
    }
    else
    {
        NSEntityDescription *entityDesc1111 =[NSEntityDescription entityForName:@"ParkedCart" inManagedObjectContext:context];
        NSFetchRequest *request11111 = [[NSFetchRequest alloc] init];
        [request11111 setEntity:entityDesc1111];
        NSPredicate *pred =[NSPredicate predicateWithFormat:@"(custId = %@)",arrayCustomerid[but.tag]];
        [request11111 setPredicate:pred];
        NSArray *objects = [context executeFetchRequest:request11111 error:&error];
        NSManagedObject *matches = nil;
        if ([objects count] == 0) {
        }
        else
        {
            
            for(int k=0;k<[objects count];k++)
            {
                matches = [objects objectAtIndex:k];
                NSManagedObject *newContact;
                newContact = [NSEntityDescription insertNewObjectForEntityForName:@"Cart" inManagedObjectContext:context];
                [newContact setValue:[NSNumber numberWithFloat:[[matches valueForKey:@"vat" ] floatValue]] forKey:@"vat"];
                [newContact setValue:[NSNumber numberWithFloat:[[matches valueForKey:@"price" ] floatValue]] forKey:@"price"];
                [newContact setValue:[matches valueForKey:@"name"] forKey:@"name"];
                [newContact setValue:[matches valueForKey:@"image"] forKey:@"image"];
                [newContact setValue:[matches valueForKey:@"discount"] forKey:@"discount"];
                [newContact setValue:[matches valueForKey:@"count"] forKey:@"count"];
                [newContact setValue:[matches valueForKey:@"article_id"] forKey:@"article_id"];
                [newContact setValue:[matches valueForKey:@"barcode"] forKey:@"barcode"];
                [context save:&error];
               
                
            }
            NSFetchRequest *request1 = [NSFetchRequest fetchRequestWithEntityName:@"ParkedCart"];
            NSPredicate *pred =[NSPredicate predicateWithFormat:@"(custId = %@)",arrayCustomerid[but.tag]];
            [request1 setPredicate:pred];
            NSArray *objects1 = [context executeFetchRequest:request1 error:&error];
            if (objects1 == nil) {
                // handle error
            } else {
                for (NSManagedObject *object in objects1) {
                    [context deleteObject:object];
                }
                [context save:&error];
            }
            
        }
    }
    [self getAllParkedList];
    [self getCartData];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    if (alertView.tag==6)
    {
        if(buttonIndex==0)
        {
            [self splitCartWithReceipt:indexNo];
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
    else if (alertView.tag==10)
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
    
    if (alertView.tag == 105) {
        if (buttonIndex == 0) {
            if ([[alertView textFieldAtIndex:0] validEmailAddress]) {
                
                
                NSString *email = [alertViewChangeName textFieldAtIndex:0].text;
                [[NSUserDefaults standardUserDefaults] setObject:email forKey:@"EMAIL"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
//                [[AppDelegate delegate] sendMailWithSubject:@"Receipt " sendFrom:@"" ToReciepents:@"" messageHtmlBodyContent:@""];
                
                [[AppDelegate delegate] sendReceiptMailWithSubject:@"Receipt" sendFrom:@"" ToReciepents:@"" messageHtmlBodyContent:@""];
            }
            
        }
    }
}

-(void)splitCartWithReceipt: (int) k
{
    [tablecartview reloadData];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context =[appDelegate managedObjectContext];
    NSEntityDescription *entityDesc =[NSEntityDescription entityForName:@"Cart" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    
    NSManagedObjectContext *context1 =[appDelegate managedObjectContext];
    NSEntityDescription *entityDesc1111 =[NSEntityDescription entityForName:@"ParkedCart" inManagedObjectContext:context1];
    NSFetchRequest *request11111 = [[NSFetchRequest alloc] init];
    [request11111 setEntity:entityDesc1111];
    NSArray *objectsde = [context1 executeFetchRequest:request11111 error:&error];
    NSManagedObject *ppp = (NSManagedObject *)[objectsde lastObject];
    
    for(int i=0;i<objects.count;i++)
    {
        
        NSManagedObject *person = (NSManagedObject *)[objects objectAtIndex:i];
        
        NSManagedObject *newContact;
        newContact = [NSEntityDescription insertNewObjectForEntityForName:@"ParkedCart" inManagedObjectContext:context];
        
        [newContact setValue:[NSNumber numberWithFloat:[[person valueForKey:@"vat"] floatValue]] forKey:@"vat"];
        [newContact setValue:[NSNumber numberWithFloat:[[person valueForKey:@"price" ] floatValue]] forKey:@"price"];
        [newContact setValue:[person valueForKey:@"name" ] forKey:@"name"];
        [newContact setValue:[NSDate date] forKey:@"on_date"];
        [newContact setValue:[person valueForKey:@"image"] forKey:@"image"];
        [newContact setValue:[NSString stringWithFormat:@"%d",[[ppp valueForKey:@"custId"] intValue]+1] forKey:@"custId"];
        [newContact setValue:[person valueForKey:@"count"] forKey:@"count"];
        [newContact setValue:[person valueForKey:@"article_id"] forKey:@"article_id"];
        [newContact setValue:[person valueForKey:@"barcode"] forKey:@"barcode"];
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
    
    
    NSEntityDescription *entityDes =[NSEntityDescription entityForName:@"ParkedCart" inManagedObjectContext:context];
    NSFetchRequest *reques = [[NSFetchRequest alloc] init];
    [reques setEntity:entityDes];
    NSPredicate *pred =[NSPredicate predicateWithFormat:@"(custId = %@)",arrayCustomerid[k]];
    [reques setPredicate:pred];
    NSArray *object = [context executeFetchRequest:reques error:&error];
    NSManagedObject *matches = nil;
    if ([object count] == 0) {
    }
    else
    {
        for(int k=0;k<[object count];k++)
        {
            matches = [object objectAtIndex:k];
            NSManagedObject *newContact;
            newContact = [NSEntityDescription insertNewObjectForEntityForName:@"Cart" inManagedObjectContext:context];
            [newContact setValue:[NSNumber numberWithFloat:[[matches valueForKey:@"vat" ] floatValue]] forKey:@"vat"];
            [newContact setValue:[NSNumber numberWithFloat:[[matches valueForKey:@"price" ] floatValue]] forKey:@"price"];
            [newContact setValue:[matches valueForKey:@"name"] forKey:@"name"];
            [newContact setValue:[matches valueForKey:@"image"] forKey:@"image"];
            [newContact setValue:[matches valueForKey:@"discount"] forKey:@"discount"];
            [newContact setValue:[matches valueForKey:@"count"] forKey:@"count"];
            [newContact setValue:[matches valueForKey:@"article_id"] forKey:@"article_id"];
            [context save:&error];

        }
        NSFetchRequest *request1 = [NSFetchRequest fetchRequestWithEntityName:@"ParkedCart"];
        NSPredicate *pred =[NSPredicate predicateWithFormat:@"(custId = %@)",arrayCustomerid[k]];
        [request1 setPredicate:pred];
        NSArray *objects1 = [context executeFetchRequest:request1 error:&error];
        if (objects1 == nil) {
            // handle error
        } else {
            for (NSManagedObject *object in objects1) {
                [context deleteObject:object];
            }
            [context save:&error];
        }
        
    }
    [self getAllParkedList];
    [self getCartData];
    
}
@end