//
//  tabbarViewControler.m
//  ISUPOS
//
//  Created by Rohit Mahajan on 4/14/15.
//  Copyright (c) 2015 Impinge Solutions. All rights reserved.
//

#import "tabbarViewControler.h"
#import "language.h"
@interface tabbarViewControler ()

@end

@implementation tabbarViewControler

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
    [[Mint sharedInstance] leaveBreadcrumb:@"TabBarViewController_ViewController"];
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localeChanged:) name:@"Language" object:nil];
    //Set tabbar items images////////////////
    UITabBarItem *tabBarItem0 = [self.tabBar.items objectAtIndex:0];
    UIImage* selectedImage = [[UIImage imageNamed:@"quick1.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem0.selectedImage = selectedImage;
    tabBarItem0.title=[Language get:@"Quick Blocks" alter:@"!Quick Blocks"];
    UIImage* selectedImag = [[UIImage imageNamed:@"quick1.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem0.image = selectedImag;
    
    
    UITabBarItem *tabBarItem1 = [self.tabBar.items objectAtIndex:1];
    UIImage* selectedImage1 = [[UIImage imageNamed:@"artical1.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem1.selectedImage = selectedImage1;
    tabBarItem1.title=[Language get:@"Articles" alter:@"!Articles"];
    UIImage* selectedImag1 = [[UIImage imageNamed:@"artical1.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem1.image = selectedImag1;
    
    
    UITabBarItem *tabBarItem2 = [self.tabBar.items objectAtIndex:2];
    UIImage* selectedImage2 = [[UIImage imageNamed:@"ReceiptsIcon1.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem2.selectedImage = selectedImage2;
    tabBarItem2.title=[Language get:@"Receipt" alter:@"!Receipt"];
    UIImage* selectedImag2 = [[UIImage imageNamed:@"ReceiptsIcon1.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem2.image = selectedImag2;
    
    
    UITabBarItem *tabBarItem3 = [self.tabBar.items objectAtIndex:3];
    UIImage* selectedImage3 = [[UIImage imageNamed:@"ParkReceiptIcon1.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem3.selectedImage = selectedImage3;
    tabBarItem3.title=[Language get:@"Park Receipts" alter:@"!Park Receipts"];;
    UIImage* selectedImag3 = [[UIImage imageNamed:@"ParkReceiptIcon1.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    tabBarItem3.image = selectedImag3;
    
    
    UITabBarItem *tabBarItem4 = [self.tabBar.items objectAtIndex:4];
    //UIImage* selectedImage4 = [[UIImage imageNamed:@"MoreIcon1.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
   // tabBarItem4.selectedImage = selectedImage4;
    tabBarItem4.title=[Language get:@"More" alter:@"!More"];
    //UIImage* selectedImag4 = [[UIImage imageNamed:@"MoreIcon1.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //tabBarItem4.image = selectedImag4;

    
   //////////////////////add seprator on tabbar/////////////////////
    
    UIImageView *sepratorimg=[[UIImageView alloc]initWithFrame:CGRectMake(204, 0, 2, 59)];
    sepratorimg.backgroundColor=[UIColor whiteColor];
    [self.tabBar addSubview:sepratorimg];
    
    
    UIImageView *sepratorimg1=[[UIImageView alloc]initWithFrame:CGRectMake(408, 0, 2, 59)];
    sepratorimg1.backgroundColor=[UIColor whiteColor];
    [self.tabBar addSubview:sepratorimg1];

    UIImageView *sepratorimg2=[[UIImageView alloc]initWithFrame:CGRectMake(612, 0, 2, 59)];
    sepratorimg2.backgroundColor=[UIColor whiteColor];
    [self.tabBar addSubview:sepratorimg2];
    
    UIImageView *sepratorimg3=[[UIImageView alloc]initWithFrame:CGRectMake(816, 0, 2, 59)];
    sepratorimg3.backgroundColor=[UIColor whiteColor];
    [self.tabBar addSubview:sepratorimg3];


    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    
    
 
    
   
//    [[self.viewControllers objectAtIndex:0] setTitle:NSLocalizedString(@"home", nil)];
//    
//    [[self.viewControllers objectAtIndex:1] setTitle:NSLocalizedString(@"statistics", nil)];
//    
//    [[self.viewControllers objectAtIndex:2] setTitle:NSLocalizedString(@"settings", nil)];
//    
//    [[self.viewControllers objectAtIndex:3] setTitle:NSLocalizedString(@"info", nil)];

    
}

- (void)localeChanged:(NSNotification *)notif
{
    UITabBarItem *tabBarItem0 = [self.tabBar.items objectAtIndex:0];
    tabBarItem0.title=[Language get:@"Quick Blocks" alter:@"!Quick Blocks"];
    
    
    
    UITabBarItem *tabBarItem1 = [self.tabBar.items objectAtIndex:1];
    tabBarItem1.title=[Language get:@"Articles" alter:@"!Articles"];
    
    
    UITabBarItem *tabBarItem2 = [self.tabBar.items objectAtIndex:2];
    tabBarItem2.title=[Language get:@"Receipt" alter:@"!Receipt"];
    
    
    UITabBarItem *tabBarItem3 = [self.tabBar.items objectAtIndex:3];
    tabBarItem3.title=[Language get:@"Park Receipts" alter:@"!Park Receipts"];;
    
    
    UITabBarItem *tabBarItem4 = [self.tabBar.items objectAtIndex:4];
    //tabBarItem4.title=[Language get:@"More" alter:@"!More"];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
