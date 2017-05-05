//
//  articlepopupViewController.m
//  ISUPOS
//
//  Created by Rohit Mahajan on 4/23/15.
//  Copyright (c) 2015 Impinge Solutions. All rights reserved.
//

#import "articlepopupViewController.h"
#import "Language.h"
#import "AppDelegate.h"
@interface articlepopupViewController ()
{
     NSMutableArray *variantName,*variantId,*variantPrice,*vatArray;;
     NSString *currencySign;
     UILabel *variantlbl;
    
    int choseImg;
    AppDelegate *appDelegate;
    
    CGFloat	animatedDistance;
    IBOutlet UISegmentedControl *segmentDiscountAndProduct;
  
}
@property (nonatomic, strong) UIPopoverController *popOver;
@end


static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 140;//216
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 160;


@implementation articlepopupViewController
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
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    PopvariantView.hidden = YES;
    
    
    btnDelete.hidden = YES;
    
    choseImg=0;
    
    
    // Splunk Mint Breadcrumb added
    [[Mint sharedInstance] leaveBreadcrumb:@"ArticlePopupViewController_ViewController"];
    
    [self getVatarray];
    
     
    lbltitle.text=[Language get:@"Edit Product" alter:@"!Edit Product"];
    
    variantName=[[NSMutableArray alloc]initWithObjects:[Language get:@"Add Variant" alter:@"!Add Variant"], nil];
    variantPrice=[[NSMutableArray alloc]initWithObjects:@"", nil];
    PopBackView.hidden=YES;
    //pressedArticleindex
   
    
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

    // Do any additional setup after loading the view.
    
    priceLabel1.inputView  = [[[NSBundle mainBundle] loadNibNamed:@"LNNumberpad" owner:self options:nil] objectAtIndex:0];
    
    variant_price_field.inputView = [[[NSBundle mainBundle] loadNibNamed:@"LNNumberpad" owner:self options:nil] objectAtIndex:0];
    
    
}

-(void)Settitles
{
    lblEditProduct.text = [Language get:@"Edit Product" alter:@"!Edit Product"];
    lblVat.text=[Language get:@"VAT" alter:@"!VAT"];
    [lblChooseFrmLib setTitle:[Language get:@"Choose From Library" alter:@"!Choose From Library"] forState:UIControlStateNormal];
    [lblTakePhoto setTitle:[Language get:@"Take Photo" alter:@"!Take Photo"] forState:UIControlStateNormal];
    [btnCustomUnit setTitle:[Language get:@"Custom Unit" alter:@"!Custom Unit"] forState:UIControlStateNormal];
    [btnDelete setTitle:[Language get:@"Delete" alter:@"!Delete"] forState:UIControlStateNormal];
    [btnPricePerUnit setTitle:[Language get:@"Price per unit" alter:@"!Price per unit"] forState:UIControlStateNormal];
    [cancel_Button setTitle:[Language get:@"Price per unit" alter:@"!Price per unit"] forState:UIControlStateNormal];
    
//    priceLabel.text = [Language get:@"Price per unit" alter:@"Price per unit"];
    if(valueType==0)
    {
        priceLabel.text = [Language get:@"Price per unit" alter:@"Price per unit"];
        
    }
    else
    {
        priceLabel.text = [Language get:@"Custom Unit" alter:@"Custom Unit"];
        
    }
    variant_title_field.placeholder = [Language get:@"Variant Title" alter:@"!Variant Title"];
    variant_price_field.placeholder = [Language get:@"Price" alter:@"Price"];
    DescriptionField.placeholder = [Language get:@"Description" alter:@"!Description"];
    barcode_Field.placeholder = [Language get:@"Barcode" alter:@"!Barcode"];
    variantlbl.text = [Language get:@"Add Variant" alter:@"!Add Variant"];
    [btnSubmitVariant setTitle:[Language get:@"Submit" alter:@"!Submit"] forState:UIControlStateNormal];
    [btnCancelVariant setTitle:[Language get:@"Cancel" alter:@"!Cancel"] forState:UIControlStateNormal];
    [cancel_Button setTitle:[Language get:@"Cancel" alter:@"!Cancel"] forState:UIControlStateNormal];


}

-(void)viewWillAppear:(BOOL)animated
{

    if (choseImg==0) {
    
    [self getArticle];
    [self Settitles];
        
    }
        
    self.view.superview.layer.cornerRadius = 0;
    
    if([priceLabel.text isEqualToString:[Language get:@"Price per unit" alter:@"!Price per unit"]])
    {
        customUnit_Field.hidden = YES;
        priceLabel1.hidden = NO;
    }
    else
    {
        customUnit_Field.hidden = NO;
        priceLabel1.hidden = YES;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)toDeleteAndCancelAndOkBtn:(UIButton*)sender
{
    if(sender.tag==5)
    {
        [self dismissViewControllerAnimated:YES completion:nil];

        if(callBack!= nil && [callBack respondsToSelector:@selector(toDismissThePopover)] )
        {
            [callBack performSelector:@selector(toDismissThePopover)];
        }
    }
    else if (sender.tag==6)
    {
   
        
        [self dismissViewControllerAnimated:YES completion:nil];
        

        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context =[appDelegate managedObjectContext];
        NSEntityDescription *entityDesc =[NSEntityDescription entityForName:@"Article" inManagedObjectContext:context];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entityDesc];
        NSPredicate *pred =[NSPredicate predicateWithFormat:@"(article_no = %@)",pressedArticleindex];
        [request setPredicate:pred];
        
        NSError *error;
        NSArray *objects = [context executeFetchRequest:request error:&error];
        NSManagedObject *person = (NSManagedObject *)[objects objectAtIndex:0];
        [person setValue:[NSNumber numberWithFloat:[vatLabel.text floatValue]] forKey:@"vat"];
        if([priceLabel.text isEqualToString:[Language get:@"Price per unit" alter:@"!Price per unit"]])
            [person setValue:[NSNumber numberWithInt:0] forKey:@"unit_type"];
        else
            [person setValue:[NSNumber numberWithInt:1] forKey:@"unit_type"];
        
        [person setValue:[NSNumber numberWithFloat:[priceLabel1.text floatValue]] forKey:@"price"];
        [person setValue:nameLabel.text forKey:@"name"];
        [person setValue:DescriptionField.text forKey:@"article_description"];
        [person setValue:barcode_Field.text forKey:@"barcode"];
        [person setValue:customUnit_Field.text forKey:@"unitName"];

        [person setValue:UIImagePNGRepresentation(cameraButton.imageView.image) forKey:@"article_img_url"];
        [context save:&error];

        
        NSEntityDescription *entityDesc2 =[NSEntityDescription entityForName:@"Variant" inManagedObjectContext:context];
        NSFetchRequest *request2 = [[NSFetchRequest alloc] init];
        [request2 setEntity:entityDesc2];
        NSPredicate *pred1 =[NSPredicate predicateWithFormat:@"(article_id = %@)",pressedArticleindex];
        [request2 setPredicate:pred1];
        NSArray *objects2 = [context executeFetchRequest:request2 error:&error];
        for(int j=0;j<objects2.count;j++)
        {
            NSManagedObject *person = (NSManagedObject *)[objects2 objectAtIndex:j];
            [context deleteObject:person];
        }
        [context save:&error];

        
        choseImg=0;
        
        if(variantName.count>1)
        {
            
            NSEntityDescription *entityDesc1 =[NSEntityDescription entityForName:@"Variant" inManagedObjectContext:context];
            NSFetchRequest *request = [[NSFetchRequest alloc] init];
            [request setEntity:entityDesc1];
            NSError *error;
            NSArray *objects1 = [context executeFetchRequest:request error:&error];
            
            NSManagedObject *newContact;
            
            for(int i=1;i<variantName.count;i++)
            {
                newContact = [NSEntityDescription insertNewObjectForEntityForName:@"Variant" inManagedObjectContext:context];
                [newContact setValue:pressedArticleindex forKey:@"article_id"];
                [newContact setValue:variantName[i] forKey:@"name"];
                [newContact setValue:[NSNumber numberWithFloat:[variantPrice[i] floatValue]] forKey:@"price"];
                [newContact setValue:[NSNumber numberWithInt:(int)objects1.count+i+1] forKey:@"variant_id"];
                [context save:&error];
            }
            
            
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ISUPOS" message:[NSString stringWithFormat:@"%@", [Language get:@"Product Updated." alter:@"!Product Updated."]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];

        
        
        
        if(callBack!= nil && [callBack respondsToSelector:@selector(toDismissThePopover)] )
        {
            [callBack performSelector:@selector(toDismissThePopover)];
        }

    }
    else
    {
        NSLog(@"Delete");
        
        UIAlertView* alert1 = [[UIAlertView alloc] init];
        [alert1 setDelegate:self];
        [alert1 setTitle:@"ISUPOS"];
        [alert1 setMessage:[Language get:@"Do you want to Remove Article?" alter:@"!Do you want to Remove Article?"]];
        [alert1 addButtonWithTitle:[Language get:@"Yes" alter:@"!Yes"]];
        [alert1 addButtonWithTitle:[Language get:@"No" alter:@"!No"]];
        alert1.tag=6;
        alert1.alertViewStyle = UIAlertViewStyleDefault;
        
        [alert1 show];

 
    }

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    if (alertView.tag==6)
    {
        if(buttonIndex==0)
        {
            [self removeArticle];
            [self dismissViewControllerAnimated:YES completion:nil];

            
        }
        
    }
}


- (IBAction)toCameraAndVatAndOPriceBtn:(UIButton*)sender
{
    if(sender.tag==8)
    {
        PopBackView.hidden=NO;
        CameraPopView.hidden=NO;
        VatPopView.hidden=YES;
        PricePopView.hidden=YES;
        
    }
    else if (sender.tag==9)
    {
       PopBackView.hidden=NO;
        CameraPopView.hidden=YES;
        VatPopView.hidden=NO;
        PricePopView.hidden=YES;
    }
    else
    {
        PopBackView.hidden=NO;
        CameraPopView.hidden=YES;
        VatPopView.hidden=YES;
        PricePopView.hidden=YES;
    }
}

- (IBAction)vatChooseBtn:(UIButton*)sender
{
    vatLabel.text=[[sender titleForState:UIControlStateNormal] substringToIndex:[[sender titleForState:UIControlStateNormal] length] - 1];;
    PopBackView.hidden=YES;
}

- (IBAction)priceChooseBtn:(UIButton*)sender
{
    
    priceLabel.text=[sender titleForState:UIControlStateNormal];
    PopBackView.hidden=YES;
    
    if([priceLabel.text isEqualToString:[Language get:@"Price per unit" alter:@"!Price per unit"]])
    {
        [priceLabel1 resignFirstResponder];

        priceLabel1.inputView  = [[[NSBundle mainBundle] loadNibNamed:@"LNNumberpad" owner:self options:nil] objectAtIndex:0];
        
        customUnit_Field.hidden = YES;
        priceLabel1.hidden = NO;
    }
    else
    {
        customUnit_Field.hidden = NO;
        priceLabel1.hidden = YES;
        [priceLabel1.inputView removeFromSuperview];
        [priceLabel1 setInputView:nil];
        [priceLabel1 becomeFirstResponder];

//        [priceLabel1 setKeyboardType:UIKeyboardTypeDefault];
    }
    
}

- (IBAction)cameraChooseBtn:(UIButton*)sender
{
  PopBackView.hidden=YES;
    if(sender.tag==22)
    {

    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.allowsEditing = YES;
        
//        [self presentViewController:imagePicker animated:YES completion:nil];
        CGRect frame= segmentDiscountAndProduct.frame;
        [segmentDiscountAndProduct setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 50)];
        
//        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
//        imagePicker.delegate = self;
//        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
//        imagePicker.allowsEditing = YES;
        _popOver = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
        
        [_popOver presentPopoverFromRect:segmentDiscountAndProduct.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        //[self presentModalViewController:imagePicker animated:YES];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"ISUPOS"
                                                       message:[Language get:@"Unable to find a camera on your device." alter:@"!Unable to find a camera on your device."]
                                                      delegate:nil
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil, nil];
        [alert show];
        alert = nil;
    }
    }
    
    else
    {
        //UIImagePickerController *picker;
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            UIButton *button = (UIButton *)sender;
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            
            _popOver = [[UIPopoverController alloc] initWithContentViewController:picker];
            [_popOver presentPopoverFromRect:button.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
    }
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    choseImg=1;
    
    
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    if (chosenImage.imageOrientation == UIImageOrientationRight ||chosenImage.imageOrientation == UIImageOrientationLeft||chosenImage.imageOrientation == UIImageOrientationDown) {
        UIImage *rotateImage = [UIImage imageWithCGImage:chosenImage.CGImage scale:chosenImage.scale orientation:UIImageOrientationUp];
        chosenImage = rotateImage;
    }
    
    CGSize newSize = CGSizeMake(120, 120);
    UIGraphicsBeginImageContext(newSize);
    [chosenImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    
//    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
   // self.imageView.image = chosenImage;
    [cameraButton setBackgroundImage:newImage forState:UIControlStateNormal];
    [cameraButton setImage:newImage forState:UIControlStateNormal];
    [_popOver dismissPopoverAnimated:YES];
    [picker dismissViewControllerAnimated:YES completion:nil];
//    [picker.view removeFromSuperview];
//    [picker removeFromParentViewController];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [_popOver dismissPopoverAnimated:YES];
    [picker dismissViewControllerAnimated:YES completion:nil];
//    [picker.view removeFromSuperview];
//    [picker removeFromParentViewController];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    PopBackView.hidden=YES;
}
-(void)toDismissThePopover
{
    NSLog(@"article");
    
    //[popover dismissPopoverAnimated:YES];
}

-(void)getArticle
{
   
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context =[appDelegate managedObjectContext];
    NSEntityDescription *entityDesc =[NSEntityDescription entityForName:@"Article" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    NSPredicate *pred =[NSPredicate predicateWithFormat:@"(article_no = %@)",pressedArticleindex];
    [request setPredicate:pred];

    NSError *error;
    NSArray *objects = [context executeFetchRequest:request error:&error];
        NSManagedObject *person = (NSManagedObject *)[objects objectAtIndex:0];
    
    NSData *da=[person valueForKey:@"article_img_url"];
    UIImage *img=[[UIImage alloc] initWithData:da];

   [cameraButton setBackgroundImage:img forState:UIControlStateNormal];
   [cameraButton setImage:img forState:UIControlStateNormal];
   vatLabel.text=[NSString stringWithFormat:@"%d%@",[[person valueForKey:@"vat"]intValue],@""];
    //priceLabel1.text=[NSString stringWithFormat:@"%.02f",[[person valueForKey:@"price"]floatValue] ];
    
    if([[person valueForKey:@"unit_type"]intValue]==0 || [person valueForKey:@"unit_type"]==nil)
    {
        valueType=0;
        
        priceLabel.text=[Language get:@"Price per unit" alter:@"!Price per unit"];
        priceLabel1.text=[NSString stringWithFormat:@"%.02f",[[person valueForKey:@"price"]floatValue]];
         priceLabel1.placeholder=@"0.00";
    }
    else
    {
         valueType=1;
        
    priceLabel.text=[Language get:@"Custom Unit" alter:@"!Custom Unit"];
        customUnit_Field.text=[NSString stringWithFormat:@"%@",[person valueForKey:@"unitName"]];
        customUnit_Field.placeholder=@"Enter Unit";
    }
    
    
    
    
    nameLabel.text=[person valueForKey:@"name"];
    DescriptionField.text=[person valueForKey:@"article_description"];
    barcode_Field.text=[person valueForKey:@"barcode"];
    [self getVariant];
    
}
-(void)getVariant
{
    
    variantId=[[NSMutableArray alloc]init];
   
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context =[appDelegate managedObjectContext];
    NSEntityDescription *entityDesc2 =[NSEntityDescription entityForName:@"Variant" inManagedObjectContext:context];
    NSFetchRequest *request2 = [[NSFetchRequest alloc] init];
    [request2 setEntity:entityDesc2];
    NSPredicate *pred1 =[NSPredicate predicateWithFormat:@"(article_id = %@)",pressedArticleindex];
    [request2 setPredicate:pred1];
    NSError *error;
    NSArray *objects2 = [context executeFetchRequest:request2 error:&error];
    if(objects2.count>0)
    {
        for(int j=0;j<objects2.count;j++)
        {
            NSManagedObject *person = (NSManagedObject *)[objects2 objectAtIndex:j];
            [variantName addObject:[person valueForKey:@"name"]];
            [variantId addObject:[person valueForKey:@"variant_id"]];
            [variantPrice addObject:[person valueForKey:@"price"]];
            
            
        }
    }
    [addVariantTable reloadData];
    
    
}
#pragma mark - UITableView Datasource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView.tag==123)
        return vatArray.count;
    else
    return variantName.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(tableView.tag==123)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            
        }
        
        
        UILabel *variantlbl=[[UILabel alloc]initWithFrame:CGRectMake(0,0, 130,39)];
        variantlbl.text=[NSString stringWithFormat:@"%@",vatArray[vatArray.count-indexPath.row-1]];
        variantlbl.font=[UIFont fontWithName:@"Helvetica" size:14];
        variantlbl.textColor=[UIColor blackColor];
        variantlbl.textAlignment=NSTextAlignmentCenter;
        [cell addSubview:variantlbl];
        
        
        
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.backgroundColor=[UIColor lightGrayColor];
        imgView.frame = CGRectMake(0,39, 130, 1);
        [cell.contentView addSubview:imgView];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }

    else
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
    button.tag=indexPath.row;
    button.frame =CGRectMake (10, 17, 30, 30);

    variantlbl=[[UILabel alloc]initWithFrame:CGRectMake(65, 17, 260, 33)];
//    variantlbl.text = [Language get:@"Add Variant" alter:@"!Add Variant"];
    variantlbl.text=variantName[indexPath.row];
    variantlbl.font=[UIFont fontWithName:@"Helvetica" size:22];
    
   
    if(indexPath.row==0)
    {
        variantlbl.textColor=[UIColor lightGrayColor];
        [button setImage:[UIImage imageNamed:@"AddVariantIcon.png"] forState:UIControlStateNormal];
    }
    else
    {
        variantlbl.textColor=[UIColor grayColor];
        [button setImage:[UIImage imageNamed:@"RemoveVariantIcon.png"] forState:UIControlStateNormal];
        
    }
    
    [cell addSubview:button];
    [cell addSubview:variantlbl];
    
    UILabel *variantPricelbl=[[UILabel alloc]initWithFrame:CGRectMake(380, 17, 90, 33)];
    if(indexPath.row!=0)
        variantPricelbl.text=[NSString stringWithFormat:@"%@ %@",currencySign,variantPrice[indexPath.row]];
    
    variantPricelbl.font=[UIFont fontWithName:@"Helvetica" size:20];
    variantPricelbl.textColor=[UIColor grayColor];
    [cell addSubview:variantPricelbl];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.tag==123)
    {
        vatLabel.text=[vatArray[vatArray.count-indexPath.row-1] substringToIndex:[vatArray[vatArray.count-indexPath.row-1] length] - 1];
        
        VatPopView.hidden=YES;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.tag==123)
        return 40;
    else
    return 66;
}
- (void)aMethod:(UIButton*)button
{
    if([[button imageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"AddVariantIcon.png"]])
    {
        [UIView beginAnimations:@"animate" context:nil];
        [UIView setAnimationDuration:0.35f];
        [UIView setAnimationBeginsFromCurrentState: NO];
        CGRect frame = PopvariantView.frame;
        frame.origin.x = 0;
        [PopvariantView setFrame:frame];
        [UIView commitAnimations];
        
        PopvariantView.hidden = NO;
    }
    else
    {
        [variantName removeObjectAtIndex:button.tag];
        [variantPrice removeObjectAtIndex:button.tag];
        [addVariantTable reloadData];
        
        PopvariantView.hidden = YES;
    }
}
- (IBAction)SubmitBtn:(UIButton*)sender
{
    if(sender.tag==98)
    {
        [UIView beginAnimations:@"animate" context:nil];
        [UIView setAnimationDuration:0.50f];
        [UIView setAnimationBeginsFromCurrentState: NO];
        CGRect frame = PopvariantView.frame;
        frame.origin.x = 850;
        [PopvariantView setFrame:frame];
        [UIView commitAnimations];
        
        if([variant_title_field.text isEqualToString:@""] || [variant_price_field.text isEqualToString:@""])
        {
            [UIView beginAnimations:@"animate" context:nil];
            [UIView setAnimationDuration:0.50f];
            [UIView setAnimationBeginsFromCurrentState: NO];
            CGRect frame = PopvariantView.frame;
            frame.origin.x = 850;
            [PopvariantView setFrame:frame];
            [UIView commitAnimations];
            
             PopvariantView.hidden = YES;
        }
        else
        {
            [variantName addObject:variant_title_field.text];
            [variantPrice addObject:variant_price_field.text];
            [addVariantTable reloadData];
            
            variant_title_field.text=@"";
            variant_price_field.text=@"";
        }
        
    }
    else
    {
        [UIView beginAnimations:@"animate" context:nil];
        [UIView setAnimationDuration:0.35f];
        [UIView setAnimationBeginsFromCurrentState: NO];
        CGRect frame = PopvariantView.frame;
        frame.origin.x = 590;
        [PopvariantView setFrame:frame];
        [UIView commitAnimations];
        
        
        PopvariantView.hidden = YES;
        
    }
    
    
}
-(void)removeArticle
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context =[appDelegate managedObjectContext];
    NSEntityDescription *entityDesc =[NSEntityDescription entityForName:@"Article" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    NSPredicate *pred =[NSPredicate predicateWithFormat:@"(article_no = %@)",pressedArticleindex];
    [request setPredicate:pred];
    
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    NSManagedObject *person = (NSManagedObject *)[objects objectAtIndex:0];
    [context deleteObject:person];
    [context save:&error];
  
    
    NSEntityDescription *entityDesc2 =[NSEntityDescription entityForName:@"Variant" inManagedObjectContext:context];
    NSFetchRequest *request2 = [[NSFetchRequest alloc] init];
    [request2 setEntity:entityDesc2];
    NSPredicate *pred1 =[NSPredicate predicateWithFormat:@"(article_id = %@)",pressedArticleindex];
    [request2 setPredicate:pred1];
    NSArray *objects2 = [context executeFetchRequest:request2 error:&error];
    for(int j=0;j<objects2.count;j++)
    {
        NSManagedObject *person = (NSManagedObject *)[objects2 objectAtIndex:j];
        [context deleteObject:person];
    }
    [context save:&error];
    
    
    NSEntityDescription *entityDesc3 =[NSEntityDescription entityForName:@"Cart" inManagedObjectContext:context];
    NSFetchRequest *request3 = [[NSFetchRequest alloc] init];
    [request3 setEntity:entityDesc3];
    NSPredicate *pred2 =[NSPredicate predicateWithFormat:@"(article_id = %@)",pressedArticleindex];
    [request3 setPredicate:pred2];
    NSArray *objects3 = [context executeFetchRequest:request3 error:&error];
    for(int j=0;j<objects3.count;j++)
    {
        NSManagedObject *person = (NSManagedObject *)[objects3 objectAtIndex:j];
        [context deleteObject:person];
    }
    [context save:&error];
    
    
    
    NSEntityDescription *entityDesc4 =[NSEntityDescription entityForName:@"QuickBlocks" inManagedObjectContext:context];
    NSFetchRequest *request4 = [[NSFetchRequest alloc] init];
    [request4 setEntity:entityDesc4];
    NSPredicate *pred3 =[NSPredicate predicateWithFormat:@"(quick_article_nos CONTAINS %@)",pressedArticleindex];
    [request4 setPredicate:pred3];
    NSArray *objects4 = [context executeFetchRequest:request4 error:&error];
        if (objects4 == nil) {
            // handle error
        } else {
            for (NSManagedObject *object in objects4) {
                
                /////////////////////////////---------------new-------------------------------////////////////////////////
                
                NSString *dumyno=[object valueForKey:@"quick_article_nos"];
                NSArray* foo = [dumyno componentsSeparatedByString: @","];
                NSMutableArray *ary_Temp = [NSMutableArray arrayWithArray:foo];
                
                for (int i=0; i<[foo count]; i++)
                {
                    if ([[foo objectAtIndex:i] isEqualToString:pressedArticleindex])
                    {
                        [ary_Temp removeObjectAtIndex:i];
                        
                        break;
                    }
                }
                
                
                NSString *str_TempQuickNo = @"";
                
                for(int i=0;i<ary_Temp.count;i++)
                {
                    str_TempQuickNo=[NSString stringWithFormat:@"%@,%@",str_TempQuickNo,[ary_Temp objectAtIndex:i]];
                }
                
                if ([str_TempQuickNo hasPrefix:@","])
                {
                    str_TempQuickNo = [str_TempQuickNo substringFromIndex:1];
                }
                
                
//                NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
//                
//                dict = [object copy];
//                [dict setValue:str_TempQuickNo forKey:@"quick_article_nos"];
                
                [context deleteObject:object];
                
                NSManagedObject *newContact;
                newContact = [NSEntityDescription insertNewObjectForEntityForName:@"QuickBlocks" inManagedObjectContext:context];
                [newContact setValue:[object valueForKey:@"id"] forKey:@"id"];
                [newContact setValue:str_TempQuickNo forKey:@"quick_article_nos"];
                [newContact setValue:[object valueForKey:@"name"] forKey:@"name"];
                [context save:&error];
                
                
            }
            [context save:&error];

        }
    
 
    [callBack performSelector:@selector(toDismissThePopover)];
    
}
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

#pragma mark TextField Delegate methods

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    UITextInputAssistantItem* item = [textField inputAssistantItem];
    item.leadingBarButtonGroups = @[];
    item.trailingBarButtonGroups = @[];
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    CGRect textFieldRect = [self.view.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator = midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    if (heightFraction < 0.0)
    {
        heightFraction = 0.0;
    }
    else if (heightFraction > 1.0)
    {
        heightFraction = 1.0;
    }
    UIInterfaceOrientation orientation =
    [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    }
    else
    {
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
}


-(void)textFieldDidEndEditing:(UITextField *)textField
{
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([string isEqualToString:@"\n"])
    {
        [textField resignFirstResponder];
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

-(void)keyboardWillHide:(UIKeyboardAppearance *)keyboard
{
    [self.view endEditing:YES];
}


#pragma mark TextField Delegate



@end
