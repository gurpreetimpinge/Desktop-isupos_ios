//
//  helo&supportViewController.m
//  ISUPOS
//
//  Created by Rohit Mahajan on 4/24/15.
//  Copyright (c) 2015 Impinge Solutions. All rights reserved.
//

#import "helo&supportViewController.h"
#import "language.h"
@interface helo_supportViewController ()
{
    AppDelegate *appDelegate;
}
- (IBAction) buttonOK:(id)sender;

@end

@implementation helo_supportViewController
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
    [[Mint sharedInstance] leaveBreadcrumb:@"Hello&SupportViewController_ViewController"];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    self.view.superview.layer.cornerRadius = 0;
    
    lblhelp.text=[Language get:@"About ISUPOS" alter:@"!About ISUPOS"];
    howto.text=[Language get:@"How to get started with ISUPOS" alter:@"!How to get started with ISUPOS"];
    contact.text=[Language get:@"Contact Support" alter:@"!Contact Support"];
    [self.Close_Button setTitle:[Language get:@"Close" alter:@"!Close" ]forState:UIControlStateNormal];
    self.Support_pages.text = [Language get:@"Support Pages" alter:@"!Support Pages"];

    appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context =[appDelegate managedObjectContext];
    NSError *error;
    
//    NSManagedObject *newContact;
//    newContact = [NSEntityDescription insertNewObjectForEntityForName:@"Log" inManagedObjectContext:context];
//    
//    [newContact setValue:[NSDate date] forKey:@"date"];
//    [newContact setValue:[Language get:@"Help & Support" alter:@"!Help & Support"] forKey:@"discription"];
//    [newContact setValue:@"" forKey:@"sno"];
//    
//    [context save:&error];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) buttonOK:(id)sender
{
    if(callBack!= nil && [callBack respondsToSelector:@selector(toDismissThePopover)] )
    {
        [callBack performSelector:@selector(toDismissThePopover)];
    }
}
-(void)toDismissThePopover
{
    //[popover dismissPopoverAnimated:YES];
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

- (IBAction)actionSupportPages:(UIButton *)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.isupos.se/app/help.html"]];
}
@end
