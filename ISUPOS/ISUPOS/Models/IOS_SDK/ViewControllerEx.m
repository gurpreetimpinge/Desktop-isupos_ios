//
//  ViewControllerEx.m
//  IOS_SDK
//
//  Created by satsuki on 12/07/13.
//  Copyright 2012 - 2013 STAR MICRONICS CO., LTD. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewControllerEx.h"z
#import "IOS_SDKViewControllerLineMode.h"
#import "IOS_SDKViewControllerRasterMode.h"
#import "ViewControllerAboutLineMode.h"
#import "ViewControllerAboutRasterMode.h"

@implementation ViewControllerEx

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // Splunk Mint Breadcrumb added
    [[Mint sharedInstance] leaveBreadcrumb:@"Ex_ViewController"]; 
    [AppDelegate setButtonArrayAsOldStyle:@[button1, button2, button3, button4, buttonBack]];
}

- (void)viewDidUnload
{
    [button1 release];
    button1 = nil;
    [button2 release];
    button2 = nil;
    [button3 release];
    button3 = nil;
    [button4 release];
    button4 = nil;
    [buttonBack release];
    buttonBack = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [button1 release];
    [button2 release];
    [button3 release];
    [button4 release];
    [buttonBack release];
    [super dealloc];
}

- (IBAction)pushButton1:(id)sender {
    IOS_SDKViewControllerLineMode *viewController = [[[IOS_SDKViewControllerLineMode alloc] initWithNibName:@"IOS_SDKViewControllerLineMode" bundle:nil] autorelease];
    [self presentModalViewController:viewController animated:YES];
}

- (IBAction)pushButton2:(id)sender {
    IOS_SDKViewControllerRasterMode *viewController = [[[IOS_SDKViewControllerRasterMode alloc] initWithNibName:@"IOS_SDKViewControllerRasterMode" bundle:nil] autorelease];
    [self presentModalViewController:viewController animated:YES];
}

- (IBAction)pushButton3:(id)sender {
    ViewControllerAboutLineMode *viewController = [[[ViewControllerAboutLineMode alloc] initWithNibName:@"ViewControllerAboutLineMode" bundle:nil] autorelease];
    [self presentModalViewController:viewController animated:YES];
}

- (IBAction)pushButton4:(id)sender {
    ViewControllerAboutRasterMode *viewController = [[[ViewControllerAboutRasterMode alloc] initWithNibName:@"ViewControllerAboutRasterMode" bundle:nil] autorelease];
    [self presentModalViewController:viewController animated:YES];
}

- (IBAction)pushButtonBack:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}



@end
