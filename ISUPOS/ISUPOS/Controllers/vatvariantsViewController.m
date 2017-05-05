//
//  vatvariantsViewController.m
//  ISUPOS
//
//  Created by Rohit Mahajan on 7/7/15.
//  Copyright (c) 2015 Impinge Solutions. All rights reserved.
//

#import "vatvariantsViewController.h"
#import "Language.h"
#import "AppDelegate.h"
@interface vatvariantsViewController ()
{
    NSMutableArray *addVariantArray;
    NSString *currencySign;
  
}
@end

@implementation vatvariantsViewController

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

//    addVariantArray=[[NSMutableArray alloc]initWithObjects:[Language get:@"Add Vat Variant" alter:@"!Add Vat Variant"], nil];
    
    // Splunk Mint Breadcrumb added
    [[Mint sharedInstance] leaveBreadcrumb:@"Variants_ViewController"];
    
    addVariantArray= [NSMutableArray new];
    
    self.navigationController.navigationBarHidden=YES;
    varinats.text=[Language get:@"Vat Variants" alter:@"!Vat Variants"];
   
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    self.view.superview.layer.cornerRadius = 0;
    CGSize size = CGSizeMake(567, 568); // size of view in popover
    self.contentSizeForViewInPopover = size;
    
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
        [addVariantArray addObject:[[matches valueForKey:@"vat"] substringToIndex:[[matches valueForKey:@"vat"] length] - 1]];
            
        }
    }

    NSArray *sorted = [addVariantArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        if ([obj1 intValue] < [obj2 intValue]) return NSOrderedAscending;
        else return NSOrderedDescending;
    }];
    
     
    [addVariantArray removeAllObjects];
    
    addVariantArray = [NSMutableArray arrayWithArray:sorted];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)aMethod:(UIButton*)button
{
        if([[button imageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"AddVariantIcon.png"]])
    {
        [UIView beginAnimations:@"animate" context:nil];
        [UIView setAnimationDuration:0.35f];
        [UIView setAnimationBeginsFromCurrentState: NO];
        CGRect frame = addVatView.frame;
        frame.origin.y = 0;
        [addVatView setFrame:frame];
        [UIView commitAnimations];
    }
    else
    {
        if(addVariantArray.count >1)
        [addVariantArray removeObjectAtIndex:button.tag];
        
        [addVatVariantTable reloadData];
    }

}
#pragma mark - UITableView Datasource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return addVariantArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.backgroundColor=[UIColor lightGrayColor];
        imgView.frame = CGRectMake(0, 66, 483, 1);
        [cell.contentView addSubview:imgView];
    }
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self action:@selector(aMethod:)forControlEvents:UIControlEventTouchUpInside];
    button.tag=addVariantArray.count-indexPath.row-1;
    button.frame =CGRectMake (10, 17, 30, 30);
   
    UILabel *variantlbl=[[UILabel alloc]initWithFrame:CGRectMake(65, 17, 260, 33)];
    variantlbl.text=addVariantArray[addVariantArray.count-indexPath.row-1];
    variantlbl.font=[UIFont fontWithName:@"Helvetica" size:22];
    
   
    if(indexPath.row==addVariantArray.count-1)
    {
        variantlbl.textColor=[UIColor lightGrayColor];
        [button setImage:[UIImage imageNamed:@"AddVariantIcon.png"] forState:UIControlStateNormal];
    }
    else
    {
        variantlbl.textColor=[UIColor grayColor];
        [button setImage:[UIImage imageNamed:@"RemoveVariantIcon.png"] forState:UIControlStateNormal];
        
    }
   
//    if([addVariantArray [addVariantArray.count-indexPath.row-1] isEqualToString:@"0"])
//         [button setUserInteractionEnabled:false];
    
    [cell addSubview:button];
    [cell addSubview:variantlbl];
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==addVariantArray.count-1)
    {
        
        
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 66;
}
- (IBAction)oKBtn:(UIButton*)sender
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context =[appDelegate managedObjectContext];
    NSError *error;
    
    NSFetchRequest *request2 = [NSFetchRequest fetchRequestWithEntityName:@"VatVariation"];
    NSArray *objects2 = [context executeFetchRequest:request2 error:&error];
    if (objects2 == nil) {
        // handle error
    } else {
        for (NSManagedObject *object in objects2) {
            [context deleteObject:object];
        }
        [context save:&error];
    }

    
    
    
    
    NSEntityDescription *entityDesccd =[NSEntityDescription entityForName:@"VatVariation" inManagedObjectContext:context];
    NSFetchRequest *requesttt = [[NSFetchRequest alloc] init];
    [requesttt setEntity:entityDesccd];
    
    NSArray *objectss3 = [context executeFetchRequest:requesttt error:&error];
    if ([objectss3 count] == 0) {
        
        NSManagedObject *newContact;
        for(int i=0;i<addVariantArray.count;i++)
        {
            
//            if(i!=0)
//            {
                newContact = [NSEntityDescription insertNewObjectForEntityForName:@"VatVariation" inManagedObjectContext:context];
                [newContact setValue:[NSString stringWithFormat:@"%@%@",addVariantArray[i],@"%"] forKey:@"vat"];
            [context save:&error];
//            }
        }
        
        
    }

    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)cancelBtn:(UIButton*)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)cancelViewBtn:(UIButton*)sender
{
    [UIView beginAnimations:@"animate" context:nil];
    [UIView setAnimationDuration:0.35f];
    [UIView setAnimationBeginsFromCurrentState: NO];
    CGRect frame = addVatView.frame;
    frame.origin.y = 590;
    [addVatView setFrame:frame];
    [UIView commitAnimations];

    
}
- (IBAction)addViewBtn:(UIButton*)sender
{
    if(![addVat_feild.text isEqualToString:@""])
    {
    [addVariantArray addObject:addVat_feild.text];
    
    [UIView beginAnimations:@"animate" context:nil];
    [UIView setAnimationDuration:0.35f];
    [UIView setAnimationBeginsFromCurrentState: NO];
    CGRect frame = addVatView.frame;
    frame.origin.y = 590;
    [addVatView setFrame:frame];
    [UIView commitAnimations];
    }
    
    NSArray *sorted = [addVariantArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        if ([obj1 intValue] < [obj2 intValue]) return NSOrderedAscending;
        else return NSOrderedDescending;
    }];
    
    
    [addVariantArray removeAllObjects];
    
    addVariantArray = [NSMutableArray arrayWithArray:sorted];
    
    [addVatVariantTable reloadData];
    
    addVat_feild.text=@"";
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
