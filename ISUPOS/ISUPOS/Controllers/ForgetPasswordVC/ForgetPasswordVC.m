//
//  ForgetPasswordVC.m
//  ISUPOS
//
//  Created by Mac User on 4/9/15.
//  Copyright (c) 2015 Impinge Solutions. All rights reserved.
//

#import "ForgetPasswordVC.h"
#import "UITextField+Validations.h"
#import "AppDelegate.h"
#import "UITextField+Validations.h"
#import "Language.h"

@implementation ForgetPasswordVC
{
    AppDelegate *appDelegate;
}

@synthesize callBack;

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.adjustViewForKeyboard = YES;
}
-(void)viewWillAppear:(BOOL)animated
{
    self.view.superview.layer.cornerRadius = 0;
    
    appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context =[appDelegate managedObjectContext];
    NSError *error;
    
//    NSManagedObject *newContact;
//    newContact = [NSEntityDescription insertNewObjectForEntityForName:@"Log" inManagedObjectContext:context];
//    
//    [newContact setValue:[NSDate date] forKey:@"date"];
//    [newContact setValue:@"Reset Password" forKey:@"discription"];
//    [newContact setValue:@"" forKey:@"sno"];
//    
//    [context save:&error];
    
}
- (IBAction)toResetAndCancelBtn:(UIButton*)sender
{
    int btnTag = (int)sender.tag;
    
    if(btnTag == 1)
    {
        if([txtEmail validEmailAddress])
        {
            
            AppDelegate *appDelegate =[[UIApplication sharedApplication] delegate];
            NSManagedObjectContext *context =[appDelegate managedObjectContext];
            NSEntityDescription *entityDesc =[NSEntityDescription entityForName:@"User" inManagedObjectContext:context];
            NSFetchRequest *request = [[NSFetchRequest alloc] init];
            
            
            
            [request setEntity:entityDesc];
            NSPredicate *pred =[NSPredicate predicateWithFormat:@"(email = %@)",txtEmail.text];
            [request setPredicate:pred];
            NSManagedObject *matches = nil;
            NSError *error;
            NSArray *objects = [context executeFetchRequest:request error:&error];
            if ([objects count] == 0) {
                
                UIAlertView *al=[[UIAlertView alloc]initWithTitle:@"ISUPOS" message:[Language get:@"The email you entered is incorrect." alter:@"!The email you entered is incorrect."] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [al show];
                
            } else {
                
                
                [[NSUserDefaults standardUserDefaults] setObject:txtEmail.text forKey:@"EMAIL"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                
                [[AppDelegate delegate] sendForgetMailWithSubject:[Language get:@"Reset Password" alter:@"!Reset Password"] sendFrom:ISUPOSmailId ToReciepents:txtEmail.text messageHtmlBodyContent:@"forget password link"];
                
                
                if(callBack!= nil && [callBack respondsToSelector:@selector(toDismissThePopover)] )
                    [callBack performSelector:@selector(toDismissThePopover)];
                
                return;
                
            }
            
        }
        
    }
    
    else
    {
        if(callBack!= nil && [callBack respondsToSelector:@selector(toDismissThePopover)] )
            [callBack performSelector:@selector(toDismissThePopover)];
    }
}
#pragma mark - UITextField Delegates
    
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
    {
        
        [UIView beginAnimations:@"animate" context:nil];
        [UIView setAnimationDuration:0.35f];
        [UIView setAnimationBeginsFromCurrentState: NO];
        self.view.frame = CGRectMake(self.view.frame.origin.x, -60 , self.view.frame.size.width, self.view.frame.size.height);
        
        
        [UIView commitAnimations];
        return YES;
        
        
    }
    

-(void)toDismissThePopover
{
    //[popover dismissPopoverAnimated:YES];
}




@end
