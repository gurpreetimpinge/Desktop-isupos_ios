//
//  quickButtonCartlongPrssView.m
//  ISUPOS
//
//  Created by Rohit Mahajan on 4/22/15.
//  Copyright (c) 2015 Impinge Solutions. All rights reserved.
//

#import "quickButtonCartlongPrssView.h"
#import "Language.h"

@interface quickButtonCartlongPrssView ()
{
    NSString *discounttype;
    int ammm;
    NSString *currencySign;
    float price;
}
@end

@implementation quickButtonCartlongPrssView
@synthesize callBack;
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
    
    
    
    [self getCartPressedData];
  
  
    
    
    NSEntityDescription *entityDesc1 =[NSEntityDescription entityForName:@"Cart" inManagedObjectContext:context];
    NSFetchRequest *request11 = [[NSFetchRequest alloc] init];
    [request11 setEntity:entityDesc1];
    
    NSMutableArray *predicatesArray=[[NSMutableArray alloc]init];
    
    
    NSPredicate *predicate;
    predicate = [NSPredicate predicateWithFormat:@"(article_id = %@)",pressedindex];
    [predicatesArray addObject:predicate];
    
    predicate = [NSPredicate predicateWithFormat:@"(name = %@)",pressedname];
    [predicatesArray addObject:predicate];
    
    if([predicatesArray count]){
        NSPredicate * finalPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicatesArray];
        [request11 setPredicate:finalPredicate];
    }
    
    

    NSArray *objects11 = [context executeFetchRequest:request11 error:&error];
    
    NSManagedObject *obj=objects11[0];
    ammm=[[obj valueForKey:@"price"] intValue];
    // Do any additional setup after loading the view.
    txtamount.inputView  = [[[NSBundle mainBundle] loadNibNamed:@"LNNumberpad" owner:self options:nil] objectAtIndex:0];

}
-(void)viewWillAppear:(BOOL)animated
{
    commenttxt.placeholder = [Language get:@"Comments" alter:@"!Comments"];
    [quick_Cart_Cancel_Btn setTitle:[Language get:@"Cancel" alter:@"!Cancel"] forState:UIControlStateNormal];
    [remove_Cart_Btn setTitle:[Language get:@"Remove" alter:@"!Remove"] forState:UIControlStateNormal];

    self.view.superview.layer.cornerRadius = 0;
    
   
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)toRemoveAndCancelAndOkBtn:(UIButton*)sender
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context =[appDelegate managedObjectContext];
    
    NSEntityDescription *entityDesc1 =[NSEntityDescription entityForName:@"Cart" inManagedObjectContext:context];
    NSFetchRequest *request11 = [[NSFetchRequest alloc] init];
    [request11 setEntity:entityDesc1];
    
    NSMutableArray *predicatesArray=[[NSMutableArray alloc]init];
    
    
    NSPredicate *predicate;
    predicate = [NSPredicate predicateWithFormat:@"(article_id = %@)",pressedindex];
    [predicatesArray addObject:predicate];
    
    predicate = [NSPredicate predicateWithFormat:@"(name = %@)",pressedname];
    [predicatesArray addObject:predicate];
    
    if([predicatesArray count]){
        NSPredicate * finalPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicatesArray];
        [request11 setPredicate:finalPredicate];
    }
    
    
    NSError *error;
    NSArray *objects11 = [context executeFetchRequest:request11 error:&error];
    
    NSManagedObject *obj=objects11[0];

    if(sender.tag==5)
    {
        if(callBack!= nil && [callBack respondsToSelector:@selector(toDismissThePopover)] )
        {
            [callBack performSelector:@selector(toDismissThePopover)];
        }
    }
    
    else if (sender.tag==6)
    {
        if([discounttype isEqualToString:@"%"]&&[txtamount.text intValue]>100)
        {
           
                UIAlertView *al=[[UIAlertView alloc]initWithTitle:@"ISUPOS" message:[Language get:@"Discount is not more than 100%." alter:@"!Discount is not more than 100%."] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
               [al show];
            
        }
        else if([discounttype isEqualToString:currencySign]&&([txtamount.text intValue]>ammm*[txtamount_label.text intValue]))
        {
            
                UIAlertView *al=[[UIAlertView alloc]initWithTitle:@"ISUPOS" message:[Language get:@"Discount is not more than actual amount." alter:@"!Discount is not more than actual amount."] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [al show];
            

        }
        else
        {
              [obj setValue:[NSNumber numberWithInt:[txtamount_label.text intValue]] forKey:@"count"];
        
        if([discounttype isEqualToString:@"%"])
        {
            [obj setValue:discounttype forKey:@"discountType"];
            [obj setValue:[NSNumber numberWithFloat:[txtamount.text floatValue]] forKey:@"discount"];
        }
        else
        {
            [obj setValue:discounttype forKey:@"discountType"];
            [obj setValue:[NSNumber numberWithFloat:[txtamount.text floatValue]] forKey:@"discount"];
        }
        [obj setValue:commenttxt.text forKey:@"comment"];
            
        [context save:&error];

        
        [callBack performSelector:@selector(toDismissThePopover)];
        }
        
            }
    else
    {
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context =[appDelegate managedObjectContext];
        
        NSEntityDescription *entityDesc1 =[NSEntityDescription entityForName:@"Cart" inManagedObjectContext:context];
        NSFetchRequest *request11 = [[NSFetchRequest alloc] init];
        [request11 setEntity:entityDesc1];
        
        NSMutableArray *predicatesArray=[[NSMutableArray alloc]init];
        
        
        NSPredicate *predicate;
        predicate = [NSPredicate predicateWithFormat:@"(article_id = %@)",pressedindex];
        [predicatesArray addObject:predicate];
        
        predicate = [NSPredicate predicateWithFormat:@"(name = %@)",pressedname];
        [predicatesArray addObject:predicate];
        
        if([predicatesArray count]){
            NSPredicate * finalPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicatesArray];
            [request11 setPredicate:finalPredicate];
        }
        
        
        NSError *error;
        NSArray *objects11 = [context executeFetchRequest:request11 error:&error];
        for (NSManagedObject *obj in objects11) {
            
            
            [context deleteObject:obj];
        }
       [context save:&error];
        
        
       [callBack performSelector:@selector(toDismissThePopover)];
    }
}
-(void)toDismissThePopover
{
    //[popover dismissPopoverAnimated:YES];
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

- (IBAction)toAddAndSubtractBtn:(UIButton*)sender
{
    if(sender.tag==1)
    {
        if([txtamount_label.text integerValue]>1)
            txtamount_label.text=[NSString stringWithFormat:@"%d",(int)[txtamount_label.text integerValue]-1];
    }
    else
    {
        txtamount_label.text=[NSString stringWithFormat:@"%d",(int)[txtamount_label.text integerValue]+1];
    }
}
- (IBAction)toPercetAndUroBtn:(UIButton*)sender
{
    if(sender.tag==3)
    {
        discounttype=@"%";
        [percetageButton setBackgroundColor:[UIColor colorWithRed:91.0f/255.0f green:41.0f/255.0f blue:117.0f/255.0f alpha:1.0f]];
        [percetageButton setImage:[UIImage imageNamed:@"PercentIcon.png"] forState:UIControlStateNormal];
        [uroButton setBackgroundColor:[UIColor clearColor]];
        [uroButton setTitleColor:[UIColor colorWithRed:91.0f/255.0f green:41.0f/255.0f blue:117.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
        txtamount.placeholder=@"0.00 %";
        
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
        txtamount.placeholder=[NSString stringWithFormat:@"%@ 0.00",currencySign];
    }
}

-(void)getCartPressedData
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context =[appDelegate managedObjectContext];
    
    NSEntityDescription *entityDesc1 =[NSEntityDescription entityForName:@"Cart" inManagedObjectContext:context];
    NSFetchRequest *request11 = [[NSFetchRequest alloc] init];
    [request11 setEntity:entityDesc1];
    
    NSMutableArray *predicatesArray=[[NSMutableArray alloc]init];
    
    
    NSPredicate *predicate;
    predicate = [NSPredicate predicateWithFormat:@"(article_id = %@)",pressedindex];
    [predicatesArray addObject:predicate];
    
    predicate = [NSPredicate predicateWithFormat:@"(name = %@)",pressedname];
    [predicatesArray addObject:predicate];
    
    if([predicatesArray count]){
        NSPredicate * finalPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicatesArray];
        [request11 setPredicate:finalPredicate];
    }
    
    
    NSError *error;
    NSArray *objects11 = [context executeFetchRequest:request11 error:&error];
    for (NSManagedObject *obj in objects11) {
        
        
        txtamount_label.text=[NSString stringWithFormat:@"%d",[[obj valueForKey:@"count"]intValue]];
        txtname_label.text=[NSString stringWithFormat:@"%@",[obj valueForKey:@"name"]];
        txtamount.text=[NSString stringWithFormat:@"%@",[obj valueForKey:@"discount"]];
        if([obj valueForKey:@"comment"] == nil)
            commenttxt.text=[NSString stringWithFormat:@"%@",@""];
        else
            commenttxt.text=[NSString stringWithFormat:@"%@",[obj valueForKey:@"comment"]];;
        
        if([[obj valueForKey:@"discountType"] isEqualToString:@"%"])
        {
            discounttype=@"%";
            [percetageButton setBackgroundColor:[UIColor colorWithRed:91.0f/255.0f green:41.0f/255.0f blue:117.0f/255.0f alpha:1.0f]];
            [percetageButton setImage:[UIImage imageNamed:@"PercentIcon.png"] forState:UIControlStateNormal];
            [uroButton setBackgroundColor:[UIColor clearColor]];
            [uroButton setTitleColor:[UIColor colorWithRed:91.0f/255.0f green:41.0f/255.0f blue:117.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
            txtamount.placeholder=@"0.00 %";
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
            txtamount.placeholder=[NSString stringWithFormat:@"%@ 0.00",currencySign];
 
        }
    }
    
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
