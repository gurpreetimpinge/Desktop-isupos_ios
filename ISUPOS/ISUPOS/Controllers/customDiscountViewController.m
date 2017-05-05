//
//  customDiscountViewController.m
//  ISUPOS
//
//  Created by Rohit Mahajan on 6/24/15.
//  Copyright (c) 2015 Impinge Solutions. All rights reserved.
//

#import "customDiscountViewController.h"
#import "Language.h"
#import "AppDelegate.h"
@interface customDiscountViewController ()
{
    NSString *discounttype;
    NSString *currencySign;
    AppDelegate *appDelegate;
}
@property (nonatomic, strong) UIPopoverController *popOver;
@end

@implementation customDiscountViewController
@synthesize callBack;
@synthesize str_ID,str_TotalAmount;

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
    
    
    lbltitle.text=[Language get:@"Custom Discount" alter:@"!Custom Discount"];
    discount.placeholder=[Language get:@"Discount" alter:@"!Discount"];
    discription.placeholder=[Language get:@"Description" alter:@"!Description"];
    [cancel_Button setTitle:[Language get:@"Cancel" alter:@"!Cancel"] forState:UIControlStateNormal];
    
    appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context =[appDelegate managedObjectContext];
    NSError *error;
    
//    NSManagedObject *newContact;
//    newContact = [NSEntityDescription insertNewObjectForEntityForName:@"Log" inManagedObjectContext:context];
//    
//    [newContact setValue:[NSDate date] forKey:@"date"];
//    [newContact setValue:[Language get:@"Custom Discount" alter:@"!Custom Discount"] forKey:@"discription"];
//    [newContact setValue:@"" forKey:@"sno"];
//    
//    [context save:&error];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Splunk Mint Breadcrumb added
    [[Mint sharedInstance] leaveBreadcrumb:@"CustomDiscount_ViewController"];
    
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

    
    
    discounttype=@"%";
    [percetageButton setBackgroundColor:[UIColor colorWithRed:91.0f/255.0f green:41.0f/255.0f blue:117.0f/255.0f alpha:1.0f]];
    [percetageButton setImage:[UIImage imageNamed:@"PercentIcon.png"] forState:UIControlStateNormal];
    [uroButton setBackgroundColor:[UIColor clearColor]];
    [uroButton setTitle:currencySign forState:UIControlStateNormal];
    

    
    
    NSEntityDescription *entityDesc2 =[NSEntityDescription entityForName:@"CustomDiscount" inManagedObjectContext:context];
    NSFetchRequest *request11 = [[NSFetchRequest alloc] init];
    [request11 setEntity:entityDesc2];
    NSPredicate *predicate;
    predicate = [NSPredicate predicateWithFormat:@"(id = %@)",@"1S"];
//    predicate = [NSPredicate predicateWithFormat:@"(id = %@)",str_ID];
    [request11 setPredicate:predicate];
    

    NSArray *objects2 = [context executeFetchRequest:request11 error:&error];
    
    if(objects2.count>0)
    {
        NSManagedObject *obj=(NSManagedObject *)[objects2 objectAtIndex:0];
        discription.text=[obj valueForKey:@"discription"];
        discount.text=[NSString stringWithFormat:@"%0.2f",[[obj valueForKey:@"discount"]floatValue]];
        discounttype=[obj valueForKey:@"type"];
        if([discounttype isEqualToString:@"%"])
        {
            [percetageButton setBackgroundColor:[UIColor colorWithRed:91.0f/255.0f green:41.0f/255.0f blue:117.0f/255.0f alpha:1.0f]];
            [percetageButton setImage:[UIImage imageNamed:@"PercentIcon.png"] forState:UIControlStateNormal];
            [uroButton setBackgroundColor:[UIColor clearColor]];
           [uroButton setTitleColor:[UIColor colorWithRed:91.0f/255.0f green:41.0f/255.0f blue:117.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
        }
        else
        {
            [percetageButton setBackgroundColor:[UIColor clearColor]];
            [percetageButton setImage:[UIImage imageNamed:@"PercentIconSelected.png"] forState:UIControlStateNormal];
            [uroButton setBackgroundColor:[UIColor colorWithRed:91.0f/255.0f green:41.0f/255.0f blue:117.0f/255.0f alpha:1.0f]];
            [uroButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [uroButton setTitle:currencySign forState:UIControlStateNormal];
            
            
        }
        
    }
    else
    {
        delButton.hidden=YES;
    }

    // Do any additional setup after loading the view.
    
    discount.inputView  = [[[NSBundle mainBundle] loadNibNamed:@"LNNumberpad" owner:self options:nil] objectAtIndex:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        discount.placeholder=@"0.00 %";
        
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
- (IBAction)okButton:(UIButton*)sender
{
    if([discount.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ISUPOS" message:[Language get:@"Please enter discount." alter:@"!Please enter discount."] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
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
    
    else
    {
        
        popupDiscount = [discount.text floatValue];
        
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context =[appDelegate managedObjectContext];
    
    
    NSEntityDescription *entityDesc2 =[NSEntityDescription entityForName:@"CustomDiscount" inManagedObjectContext:context];
    NSFetchRequest *request11 = [[NSFetchRequest alloc] init];
    [request11 setEntity:entityDesc2];
    NSPredicate *predicate;
    predicate = [NSPredicate predicateWithFormat:@"(id = %@)",@"1S"];
//        predicate = [NSPredicate predicateWithFormat:@"(id = %@)",str_ID];
    [request11 setPredicate:predicate];

    NSError *error;
    NSArray *objects2 = [context executeFetchRequest:request11 error:&error];

    if(objects2.count==0)
    {
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context =[appDelegate managedObjectContext];
    NSError *error;
    NSManagedObject *newContact;
    newContact = [NSEntityDescription insertNewObjectForEntityForName:@"CustomDiscount" inManagedObjectContext:context];
    [newContact setValue:[NSNumber numberWithFloat:[discount.text floatValue]] forKey:@"discount"];
    [newContact setValue:[NSString stringWithFormat:@"1S"] forKey:@"id"];
    [newContact setValue:str_TotalAmount forKey:@"totalAmount"];
//        [newContact setValue:str_ID forKey:@"id"];
    [newContact setValue: discription.text forKey:@"discription"];
    [newContact setValue: discounttype forKey:@"type"];
    [context save:&error];
    }
    else
    {
        NSManagedObject *obj=(NSManagedObject *)[objects2 objectAtIndex:0];
        [obj setValue:[NSNumber numberWithFloat:[discount.text floatValue]] forKey:@"discount"];
        [obj setValue: discription.text forKey:@"discription"];
        [obj setValue: discounttype forKey:@"type"];

    }
    }
    [callBack performSelector:@selector(toDismissThePopover)];
    
}
- (IBAction)DelButton:(UIButton*)sender
{
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context =[appDelegate managedObjectContext];
    NSError *error;
    NSEntityDescription *entityDescz =[NSEntityDescription entityForName:@"CustomDiscount" inManagedObjectContext:context];
    NSFetchRequest *request0 = [[NSFetchRequest alloc] init];
    [request0 setEntity:entityDescz];
    
    NSPredicate *pred2 =[NSPredicate predicateWithFormat:@"(id = %@)",@"1S"];
//     NSPredicate *pred2 =[NSPredicate predicateWithFormat:@"(id = %@)",str_ID];
    [request0 setPredicate:pred2];
    
    NSArray *objects2 = [context executeFetchRequest:request0 error:&error];
    if (objects2 == nil) {
        // handle error
    } else {
        for (NSManagedObject *object in objects2) {
            [context deleteObject:object];
        }
        [context save:&error];
    }
    
 [callBack performSelector:@selector(toDismissThePopover)];
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
@end
