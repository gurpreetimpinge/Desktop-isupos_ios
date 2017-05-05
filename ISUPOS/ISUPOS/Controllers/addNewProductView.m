//
//  addNewProductView.m
//  ISUPOS
//
//  Created by Rohit Mahajan on 5/4/15.
//  Copyright (c) 2015 Impinge Solutions. All rights reserved.
//

#import "addNewProductView.h"
#import "Language.h"
@interface addNewProductView ()
{
    NSMutableArray *addVariantArray,*addVariantPriceArray,*vatArray;
    NSString *discounttype;
    NSString *currencySign;
    UITextField *TfForCompare;
    
    CGFloat	animatedDistance;
    
}
@property (nonatomic, strong) UIPopoverController *popOver;
@end

@implementation addNewProductView
@synthesize callBack;



static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 160;


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
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    vatLabel.text=@"0";
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    
    
    if([priceLabel.text isEqualToString:[Language get:@"Price per unit" alter:@"!Price per unit"]])
    {
        customUnit_Field.hidden = YES;
    }
    else
    {
        customUnit_Field.hidden = NO;
    }
    
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
    
    
    [super viewDidLoad];
    PopBackView.hidden=YES;
    PopDiscountView.hidden=YES;
    [self getVatarray];
    
    
    
    discounttype=@"%";
    [uroButton setTitle:currencySign forState:UIControlStateNormal];
    
    addVariantArray=[[NSMutableArray alloc]initWithObjects:[Language get:@"Add Variant" alter:@"!Add Variant"], nil];
    addVariantPriceArray=[[NSMutableArray alloc]initWithObjects:@"", nil];
    
    
    CGRect frame= segmentDiscountAndProduct.frame;
    [segmentDiscountAndProduct setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 50)];
    
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:18.0f];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    [segmentDiscountAndProduct setTitleTextAttributes:attributes forState:UIControlStateNormal];
    // Do any additional setup after loading the view.
    
    variant_price_field.inputView = [[[NSBundle mainBundle] loadNibNamed:@"LNNumberpad" owner:self options:nil] objectAtIndex:0];
    
    product_price_field.inputView = [[[NSBundle mainBundle] loadNibNamed:@"LNNumberpad" owner:self options:nil] objectAtIndex:0];
    
    
    PopvariantView.hidden = YES;
    
}
-(void)viewWillAppear:(BOOL)animated
{
    self.view.superview.layer.cornerRadius = 0;
    
    newProductlbl.text=[Language get:@"New Product" alter:@"!New Product"];
    discription.placeholder=[Language get:@"Description" alter:@"!Description"];
    title_product.placeholder=[Language get:@"Title" alter:@"!Title"];
    textFieldBarcode.placeholder=[Language get:@"Barcode" alter:@"!Barcode"];
    lblVat.text=[Language get:@"VAT" alter:@"!VAT"];
    [lblChooseFrmLib setTitle:[Language get:@"Choose From Library" alter:@"!Choose From Library"] forState:UIControlStateNormal];
    [lblTakePhoto setTitle:[Language get:@"Take Photo" alter:@"!Take Photo"] forState:UIControlStateNormal];
    [btnCustomUnit setTitle:[Language get:@"Custom Unit" alter:@"!Custom Unit"] forState:UIControlStateNormal];
    [btnPricePerUnit setTitle:[Language get:@"Price per unit" alter:@"!Price per unit"] forState:UIControlStateNormal];
    priceLabel.text = [Language get:@"Price per unit" alter:@"!Price per unit"];
    [cancel_Button setTitle:[Language get:@"Cancel" alter:@"!Cancel"] forState:UIControlStateNormal];
    [Save_Button setTitle:[Language get:@"Save" alter:@"!Save"] forState:UIControlStateNormal];
    variant_price_field.placeholder = [Language get:@"Price" alter:@"!Price"];
    variant_title_field.placeholder = [Language get:@"Variant Title" alter:@"!Variant Title"];

    [submit_Button setTitle:[Language get:@"Submit" alter:@"!Submit"] forState:UIControlStateNormal];
    [add_Cancel_Button setTitle:[Language get:@"Cancel" alter:@"!Cancel"] forState:UIControlStateNormal];

    
    if([priceLabel.text isEqualToString:[Language get:@"Price per unit" alter:@"!Price per unit"]])
    {
        customUnit_Field.hidden=YES;
    }
    else
    {
        customUnit_Field.hidden=NO;
    }
    
    
    //    [NSUserDefaults standardUserDefaults]
    //    @"language"
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)segmentSwitch:(UISegmentedControl *)sender {
    NSInteger selectedSegment = sender.selectedSegmentIndex;
    
    if (selectedSegment == 0) {
        PopDiscountView.hidden=YES;
    }
    else{
        PopDiscountView.hidden=NO;
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

- (IBAction)toDeleteAndCancelAndOkBtn:(UIButton*)sender
{
    if(sender.tag==2)
    {
        if(callBack!= nil && [callBack respondsToSelector:@selector(toDismissThePopover)] )
        {
            [callBack performSelector:@selector(toDismissThePopover)];
        }
    }
    else if (sender.tag==3)
    {
        
        if ([title_product.text isEqualToString:@""])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ISUPOS" message:[Language get:@"Please enter product title." alter:@"!Please enter product title."] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        
        
//        else if ([discription.text isEqualToString:@""])
//        {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ISUPOS" message:[Language get:@"Please enter product description." alter:@"!Please enter product description."] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            [alert show];
//        }
        
//        else if ([textFieldBarcode.text isEqualToString:@""])
//        {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ISUPOS" message:[Language get:@"Please enter Barcode" alter:@"!Please enter Barcode."] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            [alert show];
//        }
        
        else if ([priceLabel.text isEqualToString:[Language get:@"Price per unit" alter:@"!Price per unit"]] && [product_price_field.text isEqualToString:@""])
        {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"ISUPOS" message:[Language get:@"Please enter price" alter:@"!Please enter price"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            
        }
        
        else if([priceLabel.text isEqualToString:[Language get:@"Custom Unit" alter:@"!Custom Unit"]] && addVariantArray.count==1)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ISUPOS" message:[Language get:@"Please add atleast one variant." alter:@"!Please add atleast one variant."] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        else if (textFieldBarcode.text.length>0)
        {
           
            if (![self barcodeFromDB:textFieldBarcode.text])
            {
                NSLog(@"incorrect");
            }
            
        }
        else{
            
            
            [self savedata];
        }
        //        else if([addVariantArray count] < 2)
        //        {
        //               UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"ISUPOS" message:@"Please add variant" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        //               [alertView show];
        //
        //        }
        
    }
    
}


-(void)toDismissThePopover
{
    
}
-(void)savedata   ////To save data in database//////
{
   
    NSString *articleid=@"";
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
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
    [newContact setValue:[NSNumber numberWithFloat:[vatLabel.text floatValue]] forKey:@"vat"];
    
    if([priceLabel.text isEqualToString:[Language get:@"Price per unit" alter:@"!Price per unit"]])
        [newContact setValue:[NSNumber numberWithInt:0] forKey:@"unit_type"];
    else
        [newContact setValue:[NSNumber numberWithInt:1] forKey:@"unit_type"];
    [newContact setValue:[NSNumber numberWithInt:1] forKey:@"unit"];
    
    
    
    
    //    if([priceLabel.text isEqualToString:[Language get:@"Custom Unit" alter:@"!Custom Unit"]])
    //    [newContact setValue:product_price_field.text forKey:@"unitName"];
    //    else
    [newContact setValue:customUnit_Field.text forKey:@"unitName"];
    
    if([priceLabel.text isEqualToString:[Language get:@"Price per unit" alter:@"!Price per unit"]])
    {
    
    [newContact setValue:[NSNumber numberWithFloat:[product_price_field.text floatValue]] forKey:@"price"];
    
    }
    else
    {
    [newContact setValue:[NSNumber numberWithFloat:[product_price_field.text floatValue]] forKey:@"price"];
    }
        
    if([discounttype isEqualToString:@"%"])
    {
        
        [newContact setValue:[NSNumber numberWithFloat:0.00] forKey:@"discount"];
    }
    else
    {
        [newContact setValue:[NSNumber numberWithFloat:0.00] forKey:@"discount"];
    }
    
    [newContact setValue:discription.text forKey:@"article_description"];
    [newContact setValue:title_product.text forKey:@"name"];
    [newContact setValue:[NSDate date] forKey:@"modified_date"];
    [newContact setValue:[NSDate date] forKey:@"created_date"];
    [newContact setValue:textFieldBarcode.text forKey:@"barcode"];

    //[newContact setValue:@"" forKey:@"created_by"];
    //[newContact setValue:@"" forKey:@"barc_img_url"];
    [newContact setValue:articleid forKey:@"article_no"];
    if(UIImagePNGRepresentation([cameraButton backgroundImageForState:UIControlStateNormal]) ==nil)
    {
        //    if([[cameraButton imageForState:UIControlStateNormal] isEqual:[UIImage imageNamed:@"CameraIcon1.png"]])
        //    {
        [newContact setValue:UIImagePNGRepresentation([UIImage imageNamed:@"block_Image.png"]) forKey:@"article_img_url"];
    }
    else
    {
        [newContact setValue:UIImagePNGRepresentation([cameraButton backgroundImageForState:UIControlStateNormal]) forKey:@"article_img_url"];
    }
    [newContact setValue:discription.text forKey:@"article_description"];
    [newContact setValue:[NSNumber numberWithInt:(int)[objects count]+1] forKey:@"article_id"];
    [context save:&error];
    
    if(addVariantArray.count>1)
    {
        
        NSEntityDescription *entityDesc1 =[NSEntityDescription entityForName:@"Variant" inManagedObjectContext:context];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entityDesc1];
        NSError *error;
        NSArray *objects1 = [context executeFetchRequest:request error:&error];
        
        NSManagedObject *newContact;
        
        for(int i=1;i<addVariantArray.count;i++)
        {
            newContact = [NSEntityDescription insertNewObjectForEntityForName:@"Variant" inManagedObjectContext:context];
            [newContact setValue:articleid forKey:@"article_id"];
            [newContact setValue:addVariantArray[i] forKey:@"name"];
            [newContact setValue:[NSNumber numberWithFloat:[addVariantPriceArray[i] floatValue]] forKey:@"price"];
            [newContact setValue:[NSNumber numberWithInt:(int)objects1.count+i+1] forKey:@"variant_id"];
            [context save:&error];
        }
        
        
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ISUPOS" message:[NSString stringWithFormat:@"%@", [Language get:@"Product saved." alter:@"!Product saved."] ] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    
    
    [callBack performSelector:@selector(toDismissThePopover)];
    //    }
    
}




- (IBAction)toPercetAndUroBtn:(UIButton*)sender
{
    if(sender.tag==67)
    {
        discounttype=@"%";
        [percetageButton setBackgroundColor:[UIColor colorWithRed:91.0f/255.0f green:41.0f/255.0f blue:117.0f/255.0f alpha:1.0f]];
        [percetageButton setImage:[UIImage imageNamed:@"PercentIcon.png"] forState:UIControlStateNormal];
        [uroButton setBackgroundColor:[UIColor clearColor]];
        [uroButton setImage:[UIImage imageNamed:@"EuroIconSelected.png"] forState:UIControlStateNormal];
        discount.placeholder=@"0.00 %";
        
    }
    else
    {
        discounttype=currencySign;
        [percetageButton setBackgroundColor:[UIColor clearColor]];
        [percetageButton setImage:[UIImage imageNamed:@"PercentIconSelected.png"] forState:UIControlStateNormal];
        [uroButton setBackgroundColor:[UIColor colorWithRed:91.0f/255.0f green:41.0f/255.0f blue:117.0f/255.0f alpha:1.0f]];
        //[uroButton setImage:[UIImage imageNamed:@"EuroIcon.png"] forState:UIControlStateNormal];
        [uroButton setTitle:currencySign forState:UIControlStateNormal];
        discount.placeholder=[NSString stringWithFormat:@"%@ 0.00",currencySign];
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
            [addVariantArray addObject:variant_title_field.text];
            [addVariantPriceArray addObject:variant_price_field.text];
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
        PricePopView.hidden=NO;
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
    
    if([priceLabel.text isEqualToString:[Language get:@"Price per unit" alter:@"!Price per unit"]])
    {
        customUnit_Field.hidden=YES;
        product_price_field.hidden=NO;
        product_price_field.placeholder=[NSString stringWithFormat:@"%@ 0.00",currencySign];
        product_price_field.text=@"";
        [product_price_field setKeyboardType:UIKeyboardTypeNumberPad];
    }
    else
    {
        customUnit_Field.hidden=NO;
        product_price_field.hidden=YES;
        product_price_field.placeholder=@"Unit";
        product_price_field.text=@"";
        [product_price_field setKeyboardType:UIKeyboardTypeDefault];
    }
    
    
    
    //    priceLabel.text=[sender titleForState:UIControlStateNormal];
    //    if([priceLabel.text isEqualToString:[Language get:@"Custom Unit" alter:@"!Custom Unit"]])
    //    {
    //
    //    }
    //    else
    //    {
    //
    //    }
    
    PopBackView.hidden=YES;
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
            _popOver = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
            [_popOver presentPopoverFromRect:segmentDiscountAndProduct.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            //[self presentViewController:imagePicker animated:YES completion:nil];
            //[self presentModalViewController:imagePicker animated:YES];
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"ISUPOS"
                                                           message:[NSString stringWithFormat:@"%@",[Language get:@"Unable to find a camera on your device." alter:@"Unable to find a camera on your device."]]
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
            picker.modalPresentationStyle = UIModalPresentationCurrentContext;
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            PopBackView.hidden=YES;
            _popOver = [[UIPopoverController alloc] initWithContentViewController:picker];
            [_popOver presentPopoverFromRect:button.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    if (chosenImage.imageOrientation == UIImageOrientationRight ||chosenImage.imageOrientation == UIImageOrientationLeft||chosenImage.imageOrientation == UIImageOrientationDown) {
        UIImage *rotateImage = [UIImage imageWithCGImage:chosenImage.CGImage scale:chosenImage.scale orientation:UIImageOrientationUp];
        chosenImage = rotateImage;
    }
//    self.imageView.image = chosenImage;
    CGSize newSize = CGSizeMake(120, 120);
    UIGraphicsBeginImageContext(newSize);
    [chosenImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [cameraButton setBackgroundImage:newImage forState:UIControlStateNormal];
    [cameraButton setImage:nil forState:UIControlStateNormal];
    [_popOver dismissPopoverAnimated:YES];
    [picker.view removeFromSuperview];
    [picker removeFromParentViewController];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [_popOver dismissPopoverAnimated:YES];
    [picker.view removeFromSuperview];
    [picker removeFromParentViewController];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    PopBackView.hidden=YES;
}

#pragma mark - UITableView Datasource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView.tag==123)
    {
        [tableView setNeedsDisplay];
        return vatArray.count;
    }
    else
        return addVariantArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.tag==123)
    {
        //        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
        //
        //        if (cell == nil) {
        //            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        //
        //        }
        
        static NSString *CellIdentifier = @"Cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        
        for (UIView *view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
        
        UILabel *variantlbl=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 130, 40)];
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
        button.tag=addVariantArray.count-indexPath.row-1;
        button.frame =CGRectMake (10, 17, 30, 30);
        
        if(addVariantArray.count>1 && ![priceLabel.text isEqualToString:[Language get:@"Custom Unit" alter:@"!Custom Unit"]])
        {
            product_price_field.hidden=YES;
        }
        else
        {
            product_price_field.hidden=NO;
            
        }
        
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
        
        [cell addSubview:button];
        [cell addSubview:variantlbl];
        
        UILabel *variantPricelbl=[[UILabel alloc]initWithFrame:CGRectMake(380, 17, 90, 33)];
        if(![addVariantPriceArray[addVariantArray.count-indexPath.row-1] isEqualToString:@""])
            variantPricelbl.text=[NSString stringWithFormat:@"%@ %@",currencySign,addVariantPriceArray[addVariantArray.count-indexPath.row-1]];
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
        [addVariantArray removeObjectAtIndex:button.tag];
        [addVariantPriceArray removeObjectAtIndex:button.tag];
        [addVariantTable reloadData];
        
        PopvariantView.hidden = YES;
    }
}
#pragma mark - UITextField Delegates


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
//    UITextInputAssistantItem* item = [textField inputAssistantItem];
//    item.leadingBarButtonGroups = @[];
//    item.trailingBarButtonGroups = @[];
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
    
    
//    
//    [UIView beginAnimations:@"animate" context:nil];
//    [UIView setAnimationDuration:0.35f];
//    [UIView setAnimationBeginsFromCurrentState: NO];
//    self.view.frame = CGRectMake(self.view.frame.origin.x, 0 , self.view.frame.size.width, self.view.frame.size.height);
//    [UIView commitAnimations];
//    
    
}



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if ([string isEqualToString:@"\n"])
    {
         [textField resignFirstResponder];
    }
   

    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField

{
    
    //    [UIView beginAnimations:@"animate" context:nil];
    //    [UIView setAnimationDuration:0.35f];
    //    [UIView setAnimationBeginsFromCurrentState: NO];
    //    self.view.frame = CGRectMake(self.view.frame.origin.x,-150 , self.view.frame.size.width, self.view.frame.size.height);
    //    [UIView commitAnimations];
    return YES;
}

-(void)keyboardWillHide:(UIKeyboardAppearance *)keyboard
{
    [self.view endEditing:YES];
}

-(BOOL)barcodeFromDB:(NSString *)barcodeNo
{

     AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context =[appDelegate managedObjectContext];
    
    NSEntityDescription *path = [NSEntityDescription entityForName:@"Article" inManagedObjectContext:context];
    
    NSFetchRequest *fetchAllData = [[NSFetchRequest alloc] init];
    [fetchAllData setEntity:path];
    
    NSPredicate *deletePredicate = [NSPredicate predicateWithFormat:@"(barcode = %@)",barcodeNo];
    [fetchAllData setPredicate:deletePredicate];
    
    NSError *error;
    
    NSArray *getAlldata = [context executeFetchRequest:fetchAllData error:&error];
    
    
    if([getAlldata count] == 0)
    {
        NSLog(@"no found data");
         [self savedata];
        
    }
    else
    {
        
        textFieldBarcode.text=@"";
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"ISUPOS" message:@"Barcode already exist" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        //        [SVProgressHUD showErrorWithStatus:@"Serial number alreday exist"];
        
        return NO;
    }
    
    return YES;
    
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
@end
