//
//  GuideScreenVC.m
//  ISUPOS
//
//  Created by Mac User on 4/10/15.
//  Copyright (c) 2015 Impinge Solutions. All rights reserved.
//


#import "GuideScreenVC.h"
#import "Language.h"

// Helper Classes
#import "KIImagePager.h"


@interface GuideScreenVC () //<KIImagePagerDelegate, KIImagePagerDataSource>
{
    IBOutlet KIImagePager *_imagePager;
    IBOutlet UIScrollView *scrolv;
    IBOutlet UIPageControl *scrolpagecontrol;
    
    __weak IBOutlet UIButton *btnSkip;
    int x;
}

@end


@implementation GuideScreenVC



#pragma mark - View LifeCycle

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self defaultSettings];
    
    
    //[self.view bringSubviewToFront:btnSkip];
    
    //[self.view sendSubviewToBack:_imagePager];
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // Update the page when more than 50% of the previous/next page is visible
    CGFloat pageWidth = scrolv.frame.size.width;
    int page = floor((scrolv.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    scrolpagecontrol.currentPage = page;
}
- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    x=0;
    UIImageView *img;
    UIImageView *img1;
    UIImageView *img2;
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"language"] isEqualToString:@"SE"]) {
        
        [Language setLanguage:@"sv"];
        
        img=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, scrolv.frame.size.width, scrolv.frame.size.height)];
        img.image=[UIImage imageNamed:@"Swedish Guide 1.png"];
        [scrolv addSubview:img];
        
        img1=[[UIImageView alloc]initWithFrame:CGRectMake(scrolv.frame.size.width, 0, scrolv.frame.size.width, scrolv.frame.size.height)];
        img1.image=[UIImage imageNamed:@"Swedish Guide 2.png"];
        [scrolv addSubview:img1];
        
        img2=[[UIImageView alloc]initWithFrame:CGRectMake(scrolv.frame.size.width*2, 0, scrolv.frame.size.width, scrolv.frame.size.height)];
        img2.image=[UIImage imageNamed:@"Swedish Guide 3.png"];
        [scrolv addSubview:img2];
        
        
    }
    else
    {
        [Language setLanguage:@"en"];
        
        img=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, scrolv.frame.size.width, scrolv.frame.size.height)];
        img.image=[UIImage imageNamed:@"Guide1.png"];
        [scrolv addSubview:img];
        
        img1=[[UIImageView alloc]initWithFrame:CGRectMake(scrolv.frame.size.width, 0, scrolv.frame.size.width, scrolv.frame.size.height)];
        img1.image=[UIImage imageNamed:@"Guide2.png"];
        [scrolv addSubview:img1];
        
        img2=[[UIImageView alloc]initWithFrame:CGRectMake(scrolv.frame.size.width*2, 0, scrolv.frame.size.width, scrolv.frame.size.height)];
        img2.image=[UIImage imageNamed:@"Guide3.png"];
        
        [scrolv addSubview:img2];
    }
    
    
    
    
//    UIImageView *img3=[[UIImageView alloc]initWithFrame:CGRectMake(scrolv.frame.size.width*3, 0, scrolv.frame.size.width, scrolv.frame.size.height)];
//    img3.image=[UIImage imageNamed:@"Reports-diagram.png"];
//    [scrolv addSubview:img3];

    img=nil;
    img1=nil;
    img2=nil;
    scrolv.pagingEnabled=YES;
    scrolv.contentSize=CGSizeMake(self.view.frame.size.width*3, self.view.frame.size.height);
    
    //[NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(targetMethod:)userInfo:nil repeats:YES];
    
//    _imagePager.pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
//    
//    _imagePager.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
//    
//    _imagePager.slideshowTimeInterval = 5.5f;
//    
//    _imagePager.slideshowShouldCallScrollToDelegate = YES;
//    
//    _imagePager.scrollView.alwaysBounceVertical = NO;
//    
//    _imagePager.scrollView.frame = CGRectMake(0, 0, 1024, 748);
//    
//    _imagePager.scrollView.bounces = NO;
}

-(void)targetMethod:(NSTimer *)timer {
    x=x+1024;
    if(x>self.view.frame.size.width*2)
    {
        x=0;
    }
    [scrolv setContentOffset:CGPointMake(x, 0) animated:YES];
    
}

- (IBAction)changePage {
    // update the scroll view to the appropriate page
    CGRect frame;
    frame.origin.x = scrolv.frame.size.width * scrolpagecontrol.currentPage;
    frame.origin.y = 0;
    frame.size = scrolv.frame.size;
    [scrolv scrollRectToVisible:frame animated:YES];
}
#pragma mark - KIImagePager DataSource

-(void)defaultSettings
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context =[appDelegate managedObjectContext];
    NSEntityDescription *entityDesc =[NSEntityDescription entityForName:@"Setting" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    NSPredicate *pred =[NSPredicate predicateWithFormat:@"(id = %@)",@"1"];
    [request setPredicate:pred];
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    if(objects.count==0)
    {
        NSManagedObject *newContact;
        newContact = [NSEntityDescription insertNewObjectForEntityForName:@"Setting" inManagedObjectContext:context];
     
            [newContact setValue:[NSNumber numberWithBool:YES] forKey:@"autoFillAmount"];
       
        
        [newContact setValue:[NSNumber numberWithInt:1] forKey:@"id"];
        [newContact setValue:@"24" forKey:@"appTimeFormat"];
        [[NSUserDefaults standardUserDefaults] setObject:@"24" forKey:@"time_format"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    
        [context save:&error];
    }
    
    NSEntityDescription *entityDescc =[NSEntityDescription entityForName:@"VatandCurrency" inManagedObjectContext:context];
    NSFetchRequest *requestt = [[NSFetchRequest alloc] init];
    [requestt setEntity:entityDescc];
    NSArray *objectss = [context executeFetchRequest:requestt error:&error];
    NSManagedObject *obj=(NSManagedObject *)[objectss objectAtIndex:0];
    [obj setValue:@"SEK" forKey:@"currency"];
    [obj setValue:@"SE" forKey:@"language"];
    [Language setLanguage:@"sv"];
    [[NSUserDefaults standardUserDefaults] setObject:@"SE" forKey:@"language"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [context save:&error];
   
    
}

- (IBAction)move_ToLoginView:(UIButton *)sender {
    //Navigate to login controller
    
}
@end

