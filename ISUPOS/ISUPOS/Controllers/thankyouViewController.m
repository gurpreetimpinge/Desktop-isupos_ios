//
//  thankyouViewController.m
//  ISUPOS
//
//  Created by Rohit Mahajan on 6/19/15.
//  Copyright (c) 2015 Impinge Solutions. All rights reserved.
//

#import "thankyouViewController.h"
#import "Language.h"
@interface thankyouViewController ()
{
    NSString *currencySign;
}
@end

@implementation thankyouViewController
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
    
    // Splunk Mint Breadcrumb added
    [[Mint sharedInstance] leaveBreadcrumb:@"ThankyouViewController_ViewController"];
    
    
     thankyou_lbl.text=[Language get:@"Thank You" alter:@"!Thank You"];
 completed_lbl.text=[Language get:@"Purchase Completed" alter:@"!Purchase Completed"];
    
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

    
    amount_lbl.text=[NSString stringWithFormat:@"%@ %.02f",currencySign,totalamount];
    

   
    
    NSEntityDescription *entityDesc =[NSEntityDescription entityForName:@"Setting" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    NSPredicate *pred =[NSPredicate predicateWithFormat:@"(id = %@)",@"1"];
    [request setPredicate:pred];

    NSArray *objects = [context executeFetchRequest:request error:&error];
    if(objects.count==0)
    {
       
    }
    else
    {
        NSManagedObject *person = (NSManagedObject *)[objects objectAtIndex:0];
        
        if([[person valueForKey:@"autoDismissThankyou"]boolValue])
        {
            
            [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(targetMethod:) userInfo:nil repeats:NO];
        }
        else
        {
            
        }
        
    }
    // Do any additional setup after loading the view.
}


-(void)viewWillAppear:(BOOL)animated
{
    completed_lbl.text = [Language get:@"Purchase Completed" alter:@"!Purchase Completed"];
    thankyou_lbl.text = [Language get:@"Thank You" alter:@"!Thank You"];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)targetMethod:(NSTimer *)timer {
    
   [callBack performSelector:@selector(toDismissThePopover)];
}


- (IBAction)toCancelBtn:(UIButton*)sender
{
    if(callBack!= nil && [callBack respondsToSelector:@selector(toDismissThePopover)] )
    {
        [callBack performSelector:@selector(toDismissThePopover)];
    }

}
-(void)toDismissThePopover
{
//    [popover dismissPopoverAnimated:YES];
}

@end
