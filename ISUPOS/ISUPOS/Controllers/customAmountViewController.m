//
//  customAmountViewController.m
//  ISUPOS
//
//  Created by Rohit Mahajan on 6/24/15.
//  Copyright (c) 2015 Impinge Solutions. All rights reserved.
//

#import "customAmountViewController.h"
#import "Language.h"
#import "AppDelegate.h"
@interface customAmountViewController ()
{
    NSString *discounttype;
    NSMutableArray *vatArray;
    NSString *currencySign;
    AppDelegate *appDelegate;
}

@property (nonatomic, strong) UIPopoverController *popOver;
@end

@implementation customAmountViewController
@synthesize callBack;
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
    self.view.superview.layer.cornerRadius = 0;
    
    
    lbltitle.text=[Language get:@"Custom Amount" alter:@"!Custom Amount"];
    discount.placeholder=[Language get:@"Discount" alter:@"!Discount"];
    description_feild.placeholder=[Language get:@"Description" alter:@"!Description"];
    lblDiscount.text=[Language get:@"Discount" alter:@"!Discount"];
    [cus_Amt_Cancel_Button setTitle:[Language get:@"Cancel" alter:@"!Cancel"] forState:UIControlStateNormal];
    cus_Amt_Vat.text=[Language get:@"VAT" alter:@"!VAT"];


    
    
    [self getVatarray];
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
    [uroButton setTitle:currencySign forState:UIControlStateNormal];
    discounttype=@"%";
  
    //discount.placeholder=[NSString stringWithFormat:@"%@0.00",currencySign];
    
    customAmount.placeholder=[NSString stringWithFormat:@"%@ 0.00",currencySign];
    
    discount.inputView  = [[[NSBundle mainBundle] loadNibNamed:@"LNNumberpad" owner:self options:nil] objectAtIndex:0];
    
    customAmount.inputView  = [[[NSBundle mainBundle] loadNibNamed:@"LNNumberpad" owner:self options:nil] objectAtIndex:0];
    
    discounttype=@"%";
    [percetageButton setBackgroundColor:[UIColor colorWithRed:91.0f/255.0f green:41.0f/255.0f blue:117.0f/255.0f alpha:1.0f]];
    [percetageButton setImage:[UIImage imageNamed:@"PercentIcon.png"] forState:UIControlStateNormal];
    [uroButton setBackgroundColor:[UIColor clearColor]];
    [uroButton setTitleColor:[UIColor colorWithRed:91.0f/255.0f green:41.0f/255.0f blue:117.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    discount.placeholder=@"0.00%";
    
    vatLabel.text = @"0";
    
    
   
    NSEntityDescription *entityDesc2 =[NSEntityDescription entityForName:@"Cart" inManagedObjectContext:context];
    NSFetchRequest *request11 = [[NSFetchRequest alloc] init];
    [request11 setEntity:entityDesc2];
    NSPredicate *predicate;
    predicate = [NSPredicate predicateWithFormat:@"(article_id = %@)",pressedindex];
    [request11 setPredicate:predicate];
    NSArray *objects2 = [context executeFetchRequest:request11 error:&error];
    if(objects2.count==0)
    {
        delButton.hidden=YES;
    }
    else
    {
        NSManagedObject *obj=(NSManagedObject *)[objects2 objectAtIndex:0];
        description_feild.text=[obj valueForKey:@"name"];
        discount.text=[NSString stringWithFormat:@"%0.2f",[[obj valueForKey:@"discount"]floatValue]];
        discounttype=currencySign;
        customAmount.text=[NSString stringWithFormat:@"%0.2f",[[obj valueForKey:@"price"]floatValue] ];
        vatLabel.text=[NSString stringWithFormat:@"%.2f",[[obj valueForKey:@"vat"]floatValue] ];
        
        
        
        [percetageButton setBackgroundColor:[UIColor clearColor]];
        [percetageButton setImage:[UIImage imageNamed:@"PercentIconSelected.png"] forState:UIControlStateNormal];
        [uroButton setBackgroundColor:[UIColor colorWithRed:91.0f/255.0f green:41.0f/255.0f blue:117.0f/255.0f alpha:1.0f]];
        //            [uroButton setImage:[UIImage imageNamed:@"EuroIcon.png"] forState:UIControlStateNormal];
        [uroButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        
        
        if([[obj valueForKey:@"discountType"] isEqualToString:@"%"])
        {
            discounttype=@"%";
            [percetageButton setBackgroundColor:[UIColor colorWithRed:91.0f/255.0f green:41.0f/255.0f blue:117.0f/255.0f alpha:1.0f]];
            [percetageButton setImage:[UIImage imageNamed:@"PercentIcon.png"] forState:UIControlStateNormal];
            [uroButton setBackgroundColor:[UIColor clearColor]];
            [uroButton setTitleColor:[UIColor colorWithRed:91.0f/255.0f green:41.0f/255.0f blue:117.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            discount.placeholder=@"0.00%";
        }
        else
        {
            discounttype=currencySign;
            [percetageButton setBackgroundColor:[UIColor clearColor]];
            [percetageButton setImage:[UIImage imageNamed:@"PercentIconSelected.png"] forState:UIControlStateNormal];
            [uroButton setBackgroundColor:[UIColor colorWithRed:91.0f/255.0f green:41.0f/255.0f blue:117.0f/255.0f alpha:1.0f]];
            //[uroButton setImage:[UIImage imageNamed:@"EuroIcon.png"] forState:UIControlStateNormal];
            [uroButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [uroButton setTitle:currencySign forState:UIControlStateNormal];
            discount.placeholder=[NSString stringWithFormat:@"%@ 0.00",currencySign];
            
        }
        
    }
    
    
    
//    NSManagedObject *newContact;
//    newContact = [NSEntityDescription insertNewObjectForEntityForName:@"Log" inManagedObjectContext:context];
//    
//    [newContact setValue:[NSDate date] forKey:@"date"];
//    [newContact setValue:[Language get:@"Custom Amount" alter:@"!Custom Amount"] forKey:@"discription"];
//    [newContact setValue:@"" forKey:@"sno"];
//    
//    [context save:&error];
    

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    PopDiscountView.hidden=YES;
    
    
    // Splunk Mint Breadcrumb added
    [[Mint sharedInstance] leaveBreadcrumb:@"CustomAmount_ViewController"];
    
       // Do any additional setup after loading the view.
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //limit the size :
    int limit = 2;
    if([discounttype isEqualToString:@"%"])
    {
        return !([textField.text length]>limit && [string length] > range.length);
    }
    else
        return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)vatChooseBtn:(UIButton*)sender
{
     vatLabel.text=[[sender titleForState:UIControlStateNormal] substringToIndex:[[sender titleForState:UIControlStateNormal] length] - 1];;
    PopDiscountView.hidden=YES;
}

- (IBAction)toPercetAndUroBtn:(UIButton*)sender
{
    if(sender.tag==67)
    {
        discounttype=@"%";
        [percetageButton setBackgroundColor:[UIColor colorWithRed:91.0f/255.0f green:41.0f/255.0f blue:117.0f/255.0f alpha:1.0f]];
        [percetageButton setImage:[UIImage imageNamed:@"PercentIcon.png"] forState:UIControlStateNormal];
        [uroButton setBackgroundColor:[UIColor clearColor]];
         [uroButton setTitleColor:[UIColor colorWithRed:91.0f/255.0f green:41.0f/255.0f blue:117.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
        discount.placeholder=@"0.00%";
        
    }
    else
    {
        discounttype=currencySign;
        [percetageButton setBackgroundColor:[UIColor clearColor]];
        [percetageButton setImage:[UIImage imageNamed:@"PercentIconSelected.png"] forState:UIControlStateNormal];
        [uroButton setBackgroundColor:[UIColor colorWithRed:91.0f/255.0f green:41.0f/255.0f blue:117.0f/255.0f alpha:1.0f]];
        //[uroButton setImage:[UIImage imageNamed:@"EuroIcon.png"] forState:UIControlStateNormal];
        [uroButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [uroButton setTitle:currencySign forState:UIControlStateNormal];
        discount.placeholder=[NSString stringWithFormat:@"%@ 0.00",currencySign];
    }
}
- (IBAction)CancleBtn:(UIButton*)sender
{
    
        if(callBack!= nil && [callBack respondsToSelector:@selector(toDismissThePopover)] )
        {
            [callBack performSelector:@selector(toDismissThePopover)];
        }
    
}
-(void)toDismissThePopover
{
    
}
#pragma mark - UITextField Delegates
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView beginAnimations:@"animate" context:nil];
    [UIView setAnimationDuration:0.35f];
    [UIView setAnimationBeginsFromCurrentState: NO];
    self.view.frame = CGRectMake(self.view.frame.origin.x, 0 , self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [UIView beginAnimations:@"animate" context:nil];
    [UIView setAnimationDuration:0.35f];
    [UIView setAnimationBeginsFromCurrentState: NO];
    self.view.frame = CGRectMake(self.view.frame.origin.x, 0 , self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField

{
    if(textField.tag==11)
    {
    PopDiscountView.hidden=false;
        return false;
    }
    return YES;
}
- (IBAction)okButton:(UIButton*)sender
{
    if([vatLabel.text isEqualToString:@""]||[customAmount.text isEqualToString:@""]||[description_feild.text isEqualToString:@""]||[discount.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ISUPOS" message:[Language get:@"Please enter all fields." alter:@"!Please enter all fields."] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];

    }
    else
    {
    [self saveAmount];
    }
}
-(void)saveAmount
{

    if([discounttype isEqualToString:@"%"]&&[discount.text intValue]>100)
    {
        
        UIAlertView *al=[[UIAlertView alloc]initWithTitle:@"ISUPOS" message:[Language get:@"Discount is not more than 100%." alter:@"!Discount is not more than 100%."] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [al show];
        
    }
    else if([discounttype isEqualToString:currencySign]&&[customAmount.text intValue]<[discount.text intValue])
    {
        
        UIAlertView *al=[[UIAlertView alloc]initWithTitle:@"ISUPOS" message:[Language get:@"Discount is not more than actual amount." alter:@"!Discount is not more than actual amount."] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [al show];
        
        
    }
    else
    {
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context =[appDelegate managedObjectContext];
    NSEntityDescription *entityDesc2 =[NSEntityDescription entityForName:@"Cart" inManagedObjectContext:context];
    NSFetchRequest *request1 = [[NSFetchRequest alloc] init];
    [request1 setEntity:entityDesc2];
    NSPredicate *predicate;
    predicate = [NSPredicate predicateWithFormat:@"(article_id = %@)",pressedindex];
    [request1 setPredicate:predicate];
    
    NSError *error;
    NSArray *objects2 = [context executeFetchRequest:request1 error:&error];
    
    if(objects2.count==0)
    {
//        NSEntityDescription *entityDesc1 =[NSEntityDescription entityForName:@"Cart" inManagedObjectContext:context];
//        NSFetchRequest *request11 = [[NSFetchRequest alloc] init];
//        [request11 setEntity:entityDesc1];
        
        NSManagedObject *newContact;
        newContact = [NSEntityDescription insertNewObjectForEntityForName:@"Cart" inManagedObjectContext:context];
        [newContact setValue:[NSNumber numberWithFloat:[vatLabel.text floatValue]] forKey:@"vat"];
        [newContact setValue:[NSNumber numberWithFloat:[customAmount.text floatValue]] forKey:@"price"];
        [newContact setValue: description_feild.text forKey:@"name"];
        [newContact setValue:UIImagePNGRepresentation([UIImage imageNamed:@"ca.png"]) forKey:@"image"];
        [newContact setValue:[NSNumber numberWithInt:1] forKey:@"count"];
        [newContact setValue:[NSString stringWithFormat:@"%@",description_feild.text] forKey:@"article_id"];
        
        if([discounttype isEqualToString:@"%"])
        {
            [newContact setValue:discounttype forKey:@"discountType"];
            [newContact setValue:[NSNumber numberWithFloat:[discount.text floatValue]] forKey:@"discount"];
        }
        else
        {
            [newContact setValue:discounttype forKey:@"discountType"];
            [newContact setValue:[NSNumber numberWithFloat:[discount.text floatValue]] forKey:@"discount"];
        }

        
        
//        if([discounttype isEqualToString:@"%"])
//        {
//            
//            [newContact setValue:[NSNumber numberWithFloat:([customAmount.text floatValue]*[discount.text intValue])/100] forKey:@"discount"];
//        }
//        else
//        {
//            [newContact setValue:[NSNumber numberWithFloat:[discount.text floatValue]] forKey:@"discount"];
//        }
        
        
        [context save:&error];
    }
    else
    {
        NSManagedObject *obj=(NSManagedObject *)[objects2 objectAtIndex:0];

        [obj setValue:[NSNumber numberWithFloat:[vatLabel.text floatValue]] forKey:@"vat"];
        [obj setValue:[NSNumber numberWithFloat:[customAmount.text floatValue]] forKey:@"price"];
        [obj setValue: description_feild.text forKey:@"name"];
        [obj setValue:UIImagePNGRepresentation([UIImage imageNamed:@"ca.png"]) forKey:@"image"];
        [obj setValue:[NSNumber numberWithInt:1] forKey:@"count"];
        [obj setValue:[NSString stringWithFormat:@"%@",description_feild.text] forKey:@"article_id"];
        
        if([discounttype isEqualToString:@"%"])
        {
            [obj setValue:discounttype forKey:@"discountType"];
            [obj setValue:[NSNumber numberWithFloat:[discount.text floatValue]] forKey:@"discount"];
        }
        else
        {
            [obj setValue:discounttype forKey:@"discountType"];
            [obj setValue:[NSNumber numberWithFloat:[discount.text floatValue]] forKey:@"discount"];
        }

         [context save:&error];
    }


    
        
        [callBack performSelector:@selector(toDismissThePopover)];
    }
}
- (IBAction)DelButton:(UIButton*)sender
{
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context =[appDelegate managedObjectContext];
    NSEntityDescription *entityDesc2 =[NSEntityDescription entityForName:@"Cart" inManagedObjectContext:context];
    NSFetchRequest *request11 = [[NSFetchRequest alloc] init];
    [request11 setEntity:entityDesc2];
    NSPredicate *predicate;
    predicate = [NSPredicate predicateWithFormat:@"(article_id = %@)",pressedindex];
    [request11 setPredicate:predicate];
    NSError *error;
    NSArray *objects2 = [context executeFetchRequest:request11 error:&error];
    if(objects2.count==0)
    {
       
    }
     else {
        for (NSManagedObject *object in objects2) {
            [context deleteObject:object];
        }
        [context save:&error];
    }
    [callBack performSelector:@selector(toDismissThePopover)];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    pressedindex=@"";
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
-(void)getVatarray
{
    
    vatArray=[NSMutableArray new];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
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
            [vatArray addObject:[matches valueForKey:@"vat"]];
            
        }
        [vattable reloadData];
    }
    
}
#pragma mark - UITableView Datasource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   
        return vatArray.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            
        }
    
    
        UILabel *variantlbl=[[UILabel alloc]initWithFrame:CGRectMake(0,0,130,39)];
        variantlbl.text=[NSString stringWithFormat:@"%@",vatArray[vatArray.count-indexPath.row-1]];
        variantlbl.font=[UIFont fontWithName:@"Helvetica" size:14];
        variantlbl.textColor=[UIColor blackColor];
        variantlbl.textAlignment=NSTextAlignmentCenter;
        [cell addSubview:variantlbl];
    
    
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.backgroundColor=[UIColor lightGrayColor];
        imgView.frame = CGRectMake(0,39,130, 1);
        [cell.contentView addSubview:imgView];
    
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
  
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    
        vatLabel.text=[vatArray[vatArray.count-indexPath.row-1] substringToIndex:[vatArray[vatArray.count-indexPath.row-1] length] - 1];
        PopDiscountView.hidden=YES;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        return 40;
   
}

@end
