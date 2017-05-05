//
//  BarcodeSelector.m
//  IOS_SDK
//
//  Created by satsuki on 12/07/20.
//  Copyright 2012 - 2013 STAR MICRONICS CO., LTD. All rights reserved.
//
#import "AppDelegate.h"
#import "BarcodeSelector.h"
#import "code39.h"
#import "code93.h"
#import "ITF.h"
#import "code128.h"

@implementation BarcodeSelector

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

        options = [[NSArray alloc] initWithObjects:@"Code 39", @"Code 93", @"ITF", @"Code 128", nil];
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0)
    {
        code39 *code39var = [[code39 alloc] initWithNibName:@"code39" bundle:[NSBundle mainBundle]];
        [self presentModalViewController:code39var animated:YES];
        [code39var release];
    }
    else if (indexPath.row == 1)
    {
        code93 *code93var = [[code93 alloc] initWithNibName:@"code93" bundle:[NSBundle mainBundle]];
        [self presentModalViewController:code93var animated:YES];
        [code93var release];
    }
    else if (indexPath.row == 2)
    {
        ITF *itfvar = [[ITF alloc] initWithNibName:@"ITF" bundle:[NSBundle mainBundle]];
        [self presentModalViewController:itfvar animated:YES];
        [itfvar release];
    }
    else if (indexPath.row == 3)
    {
        code128 *code128var = [[code128 alloc] initWithNibName:@"code128" bundle:[NSBundle mainBundle]];
        [self presentModalViewController:code128var animated:YES];
        [code128var release];
    }
}

- (IBAction)pushButtonBack:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

@end
