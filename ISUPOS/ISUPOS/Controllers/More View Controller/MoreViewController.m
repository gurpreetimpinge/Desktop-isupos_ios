//
//  MoreViewController.m
//  ISUPOS
//
//  Created by Gurpreet on 09/04/15.
//  Copyright (c) 2015 Impinge Solutions. All rights reserved.
//


#import "MoreViewController.h"
#import "ManageArticalViewController.h"
#import "reportViewController.h"
#import "TrasectionsViewController.h"
#import "receiptDataViewController.h"
#import "linkToViewController.h"
@interface MoreViewController ()


@end


@implementation MoreViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        // Custom initialization
    }
    return self;
}


#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    // Splunk Mint Breadcrumb added
    [[Mint sharedInstance] leaveBreadcrumb:@"MoreViewController_ViewController"];
    
    UIButton *calculator = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *calculatorBtnImage = [UIImage imageNamed:@"CalculatorIcon.png"];
    [calculator setBackgroundImage:calculatorBtnImage forState:UIControlStateNormal];
    calculator.frame = CGRectMake(0, 0, 25, 33);
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:calculator] ;
   // self.navigationItem.rightBarButtonItem = backButton;

    // Do any additional setup after loading the view from its nib.
}

- (void) viewWillAppear:(BOOL)animated
{
    self.navigationItem.hidesBackButton = YES;
    [super viewWillAppear:animated];
    if(klm==1)
    {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"SelectedTab"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        UIStoryboard* storyboard   = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ManageArticalViewController *manage_artical = [storyboard instantiateViewControllerWithIdentifier:@"ManageArticalView"];
        [self.navigationController pushViewController:manage_artical animated:NO];
    }
    else if(klm==2)
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:@"SelectedTab"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
//        UIStoryboard* storyboard   = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        ManageArticalViewController *manage_artical = [storyboard instantiateViewControllerWithIdentifier:@"ManageArticalView"];
//        [self.navigationController pushViewController:manage_artical animated:NO];
    }
    else if(klm==3)
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"3" forKey:@"SelectedTab"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        UIStoryboard* storyboard   = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        receiptDataViewController *manage_artical = [storyboard instantiateViewControllerWithIdentifier:@"receiptDataViewController"];
        [self.navigationController pushViewController:manage_artical animated:NO];
    }
    else if(klm==4)
    {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"4" forKey:@"SelectedTab"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        UIStoryboard* storyboard   = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        TrasectionsViewController *manage_artical = [storyboard instantiateViewControllerWithIdentifier:@"TrasectionsView"];
        [self.navigationController pushViewController:manage_artical animated:NO];
    }
    else if(klm==5)
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"5" forKey:@"SelectedTab"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        UIStoryboard* storyboard   = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        reportViewController *manage_artical = [storyboard instantiateViewControllerWithIdentifier:@"reportView"];
        [self.navigationController pushViewController:manage_artical animated:NO];
    }
    else if(klm==6)
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"6" forKey:@"SelectedTab"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        UIStoryboard* storyboard   = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        linkToViewController *manage_artical = [storyboard instantiateViewControllerWithIdentifier:@"linkToViewController"];
        [self.navigationController pushViewController:manage_artical animated:NO];
    }

    self.navigationController.navigationBarHidden = NO;
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void) viewDidDisappear:(BOOL)animated
{
    self.title=@"";
    [super viewDidDisappear:animated];
}


#pragma mark - IBActions


#pragma mark - Memory Handling

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
