//
//  ViewController.m
//  ISUPOS
//
//  Created by Mac User on 4/2/15.
//  Copyright (c) 2015 Impinge Solutions. All rights reserved.
//


#import "ViewController.h"

// Helper Classes
#import "UITextField+Validations.h"
#import "UIView+TKGeometry.h"

// Other Classes
#import "ForgetPasswordVC.h"
#import "language.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"

@interface ViewController ()<UIWebViewDelegate>
{
    IBOutlet UITextField *textFieldEmail, *textFieldPassword, *textFieldForgotEmail;
    
    IBOutlet UIButton *buttonForgot;
    
    IBOutlet UIView *viewForgotPassword;
    
    IBOutlet UILabel *labelResetPassword;
    
    UIPopoverController *popover;
    
    AppDelegate *appDelegate;
}

@end


@implementation ViewController



#pragma mark - View Lifecycle


-(void)awakeFromNib
{
    textFieldEmail.placeholder=[Language get:@"Enter Email" alter:@"!Enter Email"];
    textFieldPassword.placeholder=[Language get:@"Password" alter:@"!Password"];
    [buttonForgot setTitle:[Language get:@"Forgot Password ?" alter:@"!Forgot Password ?"] forState:UIControlStateNormal];
    [login setTitle:[Language get:@"Login" alter:@"!Login"] forState:UIControlStateNormal];
    [cancel setTitle:[Language get:@"Cancel" alter:@"!Cancel"] forState:UIControlStateNormal];
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"language"] isEqualToString:@"SE"]) {
        
        [Language setLanguage:@"sv"];
        
    }
    else
    {
        [Language setLanguage:@"en"];
    }
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//#if (TARGET_IPHONE_SIMULATOR)
//    textFieldEmail.text = @"admin@isupos.com";
//    textFieldPassword.text = @"admin";
//#endif
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.isupos.se/register"]]];

    if([[[NSUserDefaults standardUserDefaults]valueForKey:@"firstTime"] isEqualToString:@"yes"])
    {
//        [webView setHidden:NO];
//        [skipButton setHidden:NO];
    }
 
    // Splunk Mint Breadcrumb added
    [[Mint sharedInstance] leaveBreadcrumb:@"LoginViewController_ViewController"];

    textFieldEmail.placeholder=[Language get:@"Enter Email" alter:@"!Enter Email"];
    textFieldPassword.placeholder=[Language get:@"Password" alter:@"!Password"];
    [buttonForgot setTitle:[Language get:@"Forgot Password ?" alter:@"!Forgot Password ?"] forState:UIControlStateNormal];
    [login setTitle:[Language get:@"Login" alter:@"!Login"] forState:UIControlStateNormal];
    [cancel setTitle:[Language get:@"Cancel" alter:@"!Cancel"] forState:UIControlStateNormal];
    
    [doneButton setTitle:[Language get:@"Done" alter:@"!Done"] forState:UIControlStateNormal];

    [skipButton setTitle:[Language get:@"Skip registration" alter:@"!Skip registration"] forState:UIControlStateNormal];
    [registerButton setTitle:[Language get:@"Register here" alter:@"!Register here"] forState:UIControlStateNormal];
    [registerButton setTitleColor:[UIColor colorWithRed:111.0f/255.0f green:60.0f/255.0f blue:135.0f/255.0f alpha:1.0] forState:UIControlStateNormal];

    
    // Do any additional setup after loading the view from its nib.
    
    //    self.adjustViewForKeyboard = YES;
    [buttonForgot setTitleColor:[UIColor colorWithRed:111.0f/255.0f green:60.0f/255.0f blue:135.0f/255.0f alpha:1.0] forState:UIControlStateNormal];
    
    labelResetPassword.textColor = [UIColor colorWithRed:111.0f/255.0f green:60.0f/255.0f blue:135.0f/255.0f alpha:1.0];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"Copy" forKey:@"ReciptType"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
//    textFieldEmail.text = @"admin@isupos.com";
//    textFieldPassword.text = @"admin";
//    [self clearLog];
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView1
{
        if([[webView1.request.URL description] containsString:@"https://formogr.am/completedEmbedded"])
        {
            [doneButton setHidden:NO];
        }
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    
//    appDelegate = [[UIApplication sharedApplication] delegate];
//    NSManagedObjectContext *context =[appDelegate managedObjectContext];
//    NSError *error;
//    
//    NSManagedObject *newContact;
//    newContact = [NSEntityDescription insertNewObjectForEntityForName:@"Log" inManagedObjectContext:context];
//    
//    [newContact setValue:[NSDate date] forKey:@"date"];
//    [newContact setValue:@"Login" forKey:@"discription"];
//    [newContact setValue:@"" forKey:@"sno"];
//    
//    [context save:&error];
    
}


#pragma mark - IBActions*893

- (IBAction)buttonLoginCancelForgotPass:(UIButton *)sender
{
    if (sender.tag == 1)
    {
//        if(![textFieldEmail validEmailAddress])
//            return;
//        
//        else if(![textFieldPassword validPassword])
//            return;
        
        
        if([textFieldEmail validEmailAddress])
        {
        
            appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            NSManagedObjectContext *context =[appDelegate managedObjectContext];
            
            NSEntityDescription *entityDesc =[NSEntityDescription entityForName:@"User" inManagedObjectContext:context];
            NSFetchRequest *request = [[NSFetchRequest alloc] init];
            [request setEntity:entityDesc];
            NSPredicate *pred =[NSPredicate predicateWithFormat:@"(email = %@)",textFieldEmail.text];
            [request setPredicate:pred];
        
            
//        AppDelegate *appDelegate =[[UIApplication sharedApplication] delegate];
//        NSManagedObjectContext *context =[appDelegate managedObjectContext];
//        NSEntityDescription *entityDesc =[NSEntityDescription entityForName:@"User" inManagedObjectContext:context];
//        NSFetchRequest *request = [[NSFetchRequest alloc] init];
//        
//        
//        
//        [request setEntity:entityDesc];
//        NSPredicate *pred =[NSPredicate predicateWithFormat:@"(email = %@)",textFieldEmail.text];
//        [request setPredicate:pred];
        NSManagedObject *matches = nil;
        NSError *error;
        NSArray *objects = [context executeFetchRequest:request error:&error];
        if ([objects count] == 0) {
            
            UIAlertView *al=[[UIAlertView alloc]initWithTitle:@"ISUPOS" message:[Language get:@"The email or password you entered is incorrect." alter:@"!The email or password you entered is incorrect."] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [al show];
            
        } else {
            matches = [objects objectAtIndex:0];
            
         if([[matches valueForKey:@"password"]isEqualToString:textFieldPassword.text])
         {
             AppDelegate *appDelegateTemp = [[UIApplication sharedApplication]delegate];
             UIViewController* rootController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"tabbarViewController"];
             //UINavigationController* navigation = [[UINavigationController alloc] initWithRootViewController:rootController];
             appDelegateTemp.window.rootViewController = rootController;
         }
         else if([textFieldEmail.text isEqualToString:@""] || ([textFieldPassword.text isEqualToString:@""]))
         {
             UIAlertView *al=[[UIAlertView alloc]initWithTitle:@"ISUPOS" message:[Language get:@"Please enter email and password for login." alter:@"!Please enter email and password for login."] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
             [al show];
         }
         else
         {
             UIAlertView *al=[[UIAlertView alloc]initWithTitle:@"ISUPOS" message:[Language get:@"The email or password you entered is incorrect." alter:@"!The email or password you entered is incorrect."] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
             [al show];
         }

        }
        }

//            if([textFieldEmail.text isEqualToString:@"1"] ||[textFieldPassword.text isEqualToString:@"1"])
//            {
//                AppDelegate *appDelegateTemp = [[UIApplication sharedApplication]delegate];
//                UIViewController* rootController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"tabbarViewController"];
//                //UINavigationController* navigation = [[UINavigationController alloc] initWithRootViewController:rootController];
//                appDelegateTemp.window.rootViewController = rootController;
//                
//            }
        
        
    }
       else if (sender.tag == 2)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            ForgetPasswordVC *viewControllerForPopover = [self.storyboard instantiateViewControllerWithIdentifier:@"ForgetPasswordVC"];
            
            popover = [[UIPopoverController alloc] initWithContentViewController:viewControllerForPopover];
            
            [popover setPopoverContentSize:CGSizeMake(587, 464)];
            
            CGRect rect = CGRectMake(self.view.width/2, self.view.height/2, 1, 1);
            
            [popover presentPopoverFromRect:rect inView:self.view permittedArrowDirections:0 animated:YES];
            
            viewControllerForPopover.callBack = self;
            
            popover.delegate=self;
        }
}

-(void)toDismissThePopover
{
    [popover dismissPopoverAnimated:NO];
}
- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController
{
    return NO;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self.view.layer removeAnimationForKey:nil];
}
#pragma mark - UIViewAnimation

- (void) animateView
{
    CATransition *transition = [CATransition animation];
    
    transition.duration = 0.5;
    
    transition.type = kCATransitionMoveIn;
    
    transition.subtype = kCATransitionFromTop;
    
    [transition setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
    [self.view.layer addAnimation:transition forKey:nil];
}


#pragma mark - UITextField Delegates

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0){
        UITextInputAssistantItem* item = [textField inputAssistantItem];
        item.leadingBarButtonGroups = @[];
        item.trailingBarButtonGroups = @[];
        textField.autocorrectionType = UITextAutocorrectionTypeNo;
    }
    
//    [UIView beginAnimations:@"animate" context:nil];
//    [UIView setAnimationDuration:0.35f];
//    [UIView setAnimationBeginsFromCurrentState: NO];
//    self.view.frame = CGRectMake(self.view.frame.origin.x, -60 , self.view.frame.size.width, self.view.frame.size.height);
//    
//    
//    [UIView commitAnimations];
    return YES;

    
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
//    [UIView beginAnimations:@"animate" context:nil];
//    [UIView setAnimationDuration:0.35f];
//    [UIView setAnimationBeginsFromCurrentState: NO];
//    self.view.frame = CGRectMake(self.view.frame.origin.x, 0 , self.view.frame.size.width, self.view.frame.size.height);
//    [UIView commitAnimations];

   
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
//    [UIView beginAnimations:@"animate" context:nil];
//    [UIView setAnimationDuration:0.35f];
//    [UIView setAnimationBeginsFromCurrentState: NO];
//    self.view.frame = CGRectMake(self.view.frame.origin.x, 0 , self.view.frame.size.width, self.view.frame.size.height);
//    [UIView commitAnimations];
    
    if (textField == textFieldEmail) {
        [textFieldPassword becomeFirstResponder];
    }
    else
    {
    [textFieldPassword resignFirstResponder];
    }
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [textFieldEmail resignFirstResponder];
    
    [textFieldPassword resignFirstResponder];
    
    [textFieldForgotEmail resignFirstResponder];
}

#pragma mark delete log data

-(void)clearLog
{
    appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context =[appDelegate managedObjectContext];
    NSEntityDescription *entityDesc =[NSEntityDescription entityForName:@"Log" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    
    for (NSManagedObject *object in objects) {
        [context deleteObject:object];
    }
}

#pragma mark - Memory Handling

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doneButtonAction:(id)sender {
    
    [[NSUserDefaults standardUserDefaults]setValue:@"no" forKey:@"firstTime"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [webView setHidden:YES];
    [doneButton setHidden:YES];
}

- (IBAction)skipButtonAction:(id)sender {
    
    [webView setHidden:YES];
    [skipButton setHidden:YES];
}

- (IBAction)registerButtonAction:(id)sender {
    [webView setHidden:NO];
    [skipButton setHidden:NO];

}
@end
