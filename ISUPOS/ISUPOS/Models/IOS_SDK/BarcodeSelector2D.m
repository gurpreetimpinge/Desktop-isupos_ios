//
//  BarcodeSelector2D.m
//  IOS_SDK
//
//  Created by satsuki on 12/07/20.
//  Copyright 2012 - 2013 STAR MICRONICS CO., LTD. All rights reserved.
//

#import "AppDelegate.h"

#import "BarcodeSelector2D.h"
#import "QRCode.h"
#import "PDF417.h"
#import "QRCodeMini.h"
#import "PDF417mini.h"

@implementation BarcodeSelector2D

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        options = [[NSArray alloc] initWithObjects:@"QR Code", @"PDF417", nil];
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
    
    tableviewBarcode.dataSource = self;
    tableviewBarcode.delegate   = self;
    
    [AppDelegate setButtonArrayAsOldStyle:@[buttonBack]];
}

- (void)viewDidUnload
{
    [tableviewBarcode release];
    tableviewBarcode = nil;
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
    [options release];
    
    [tableviewBarcode release];
    [buttonBack release];
    [super dealloc];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [options count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        int index = (int)indexPath.row;
        cell.textLabel.text = options[index];
    }
    
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *portSettings = [AppDelegate getPortSettings];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0)
    {
        if ([portSettings compare:@"mini" options:NSCaseInsensitiveSearch] == NSOrderedSame)
        {
            QRCodeMini *QRcodevar = [[QRCodeMini alloc]initWithNibName:@"QRCodeMini" bundle:[NSBundle mainBundle]];
            [self presentModalViewController:QRcodevar animated:YES];
            [QRcodevar release];
        }
        else
        {
            QRCode *QRCodevar = [[QRCode alloc] initWithNibName:@"QRCode" bundle:[NSBundle mainBundle]];
            [self presentModalViewController:QRCodevar animated:YES];
            [QRCodevar release];
        }
    }
    else if (indexPath.row == 1)
    {
        if ([portSettings compare:@"mini" options:NSCaseInsensitiveSearch] == NSOrderedSame)
        {
            PDF417mini *PDF417var = [[PDF417mini alloc] initWithNibName:@"PDF417mini" bundle:[NSBundle mainBundle]];
            [self presentModalViewController:PDF417var animated:YES];
            [PDF417var release];
        }
        else
        {
            PDF417 *PDF417var = [[PDF417 alloc] initWithNibName:@"PDF417" bundle:[NSBundle mainBundle]];
            [self presentModalViewController:PDF417var animated:YES];
            [PDF417var release];
        }
    }
}

- (IBAction)pushButtonBack:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

@end


