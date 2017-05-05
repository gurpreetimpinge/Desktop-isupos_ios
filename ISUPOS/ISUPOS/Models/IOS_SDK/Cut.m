//
//  Cut.m
//  IOS_SDK
//
//  Created by Tzvi on 8/15/11.
//  Copyright 2011 - 2013 STAR MICRONICS CO., LTD. All rights reserved.
//

#import "AppDelegate.h"

#import "Cut.h"
#import "PrinterFunctions.h"
#import "StandardHelp.h"

@implementation Cut

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        options = [[NSArray alloc] initWithObjects:@"Full Cut", @"Partial Cut", @"Full Cut With Feed", @"Partial Cut With Feed", nil];
    }
    
    return self;
}

- (void)dealloc
{
    [options release];
    
    [uiview_block release];
    [tableviewCut release];
    
    [buttonHelp release];
    [buttonBack release];
    [super dealloc];
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

    tableviewCut.dataSource = self;
    tableviewCut.delegate   = self;
    
    [AppDelegate setButtonArrayAsOldStyle:@[buttonBack, buttonHelp]];
}

- (void)viewDidUnload
{
    [options release];
    options = nil;
    
    [uiview_block release];
    uiview_block = nil;
    [tableviewCut release];
    tableviewCut = nil;
    [buttonHelp release];
    buttonHelp = nil;
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
    [self.view bringSubviewToFront:uiview_block];
    
    NSString *portName = [AppDelegate getPortName];
    NSString *portSettings = [AppDelegate getPortSettings];
   
    CutType cutType;
    if (indexPath.row == 0) {
        cutType = FULL_CUT;
    } else if (indexPath.row == 1) {
        cutType = PARTIAL_CUT;
    } else if (indexPath.row == 2) {
        cutType = FULL_CUT_FEED;
    } else { //if (indexPath.row == 3) {
        cutType = PARTIAL_CUT_FEED;
    }
    
    [PrinterFunctions PerformCutWithPortname:portName portSettings:portSettings cutType:cutType];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view sendSubviewToBack:uiview_block];
}

- (IBAction)backCut
{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)showHelp
{
    NSString *title = @"Auto Cutter";
    NSString *helpText = [AppDelegate HTMLCSS];
    helpText = [helpText stringByAppendingString: @"<body><UnderlineTitle>CUT</UnderlineTitle><br/><br/>\
                <Code>ASCII:</code> <CodeDef>ESC d <StandardItalic>n</StandardItalic></CodeDef><br/>\
                <Code>Hex:</Code> <CodeDef>1B 54 <StandardItalic>n</StandardItalic></CodeDef><br/><br/>\
                <div class=\"div-tableCut\">\
                    <div class=\"div-table-rowCut\">\
                        <div class=\"div-table-colFirstCut\"></div>\
                        <div class=\"div-table-colCut\"><It1>n =</It1></div>\
                        <div class=\"div-table-colCut\"><It1>0,1,2, or 3</It1></div>\
                    </div>\
                    <div class=\"div-table-rowCut\">\
                        <div class=\"div-table-colFirstCut\"></div>\
                        <div class=\"div-table-colCut\"><It1>0 =</It1></div>\
                        <div class=\"div-table-colCut\"><It1>Full cut at current position</It1></div>\
                    </div>\
                    <div class=\"div-table-rowCut\">\
                        <div class=\"div-table-colFirstCut\"></div>\
                        <div class=\"div-table-colCut\"><It1>1 =</It1></div>\
                        <div class=\"div-table-colCut\"><It1>Partial cut at current position</It1></div>\
                    </div>\
                    <div class=\"div-table-rowCut\">\
                        <div class=\"div-table-colFirstCut\"></div>\
                        <div class=\"div-table-colCut\"><It1>2 =</It1></div>\
                        <div class=\"div-table-colCut\"><It1>Paper is fed to cutting position, then full cut</It1></div>\
                    </div>\
                    <div class=\"div-table-rowCut\">\
                        <div class=\"div-table-colFirstCut\"></div>\
                        <div class=\"div-table-colCut\"><It1>3 =</It1></div>\
                        <div class=\"div-table-colCut\"><It1>Paper is fed to cutting position, then partial cut</It1></div>\
                        </div>\
                </div>"];
                
    
    StandardHelp *helpVar = [[StandardHelp alloc]initWithNibName:@"StandardHelp" bundle:[NSBundle mainBundle]];
    [self presentModalViewController:helpVar animated:YES];
    [helpVar release];
    
    [helpVar setHelpTitle:title];
    [helpVar setHelpText:helpText];
}

@end
