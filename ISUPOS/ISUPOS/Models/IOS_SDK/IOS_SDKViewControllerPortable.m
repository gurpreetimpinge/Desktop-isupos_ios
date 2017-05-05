//
//  IOS_SDKViewControllerPortable.m
//  IOS_SDK
//
//  Created by Tzvi on 8/2/11.
//  Copyright 2011 - 2013 STAR MICRONICS CO., LTD. All rights reserved.
//

#import "AppDelegate.h"

#import "IOS_SDKViewControllerPortable.h"
#import "StarIO/SMPort.h"
#import "PrinterFunctions.h"
#import "CheckConnectionViewController.h"
#import "BarcodeSelector.h"
#import "BarcodeSelector2D.h"
#import "Cut.h"
#import "TextFormating.h"
#import "rasterPrinting.h"
#import "StandardHelp.h"
#import "BarcodePrintingMini.h"
#import "TextFormatingMini.h"
#import "JpKnjFormating.h"
#import "JpKnjFormatingMini.h"
#import "CommonEnum.h"

@implementation IOS_SDKViewControllerPortable

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    
    return self;
}

- (IBAction)pushButtonSearch:(id)sender {
    NSArray *array = [[SMPort searchPrinter:@"BT:"] retain];

    searchView = [[SearchPrinterViewController alloc] initWithNibName:@"SearchPrinterViewController" bundle:nil];
    searchView.foundPrinters = array;
    searchView.delegate = self;
    [array release];
    [self presentModalViewController:searchView animated:YES];
    [searchView release];
}

- (IBAction)pushButtonBack:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
                
        arrayFunction = [[NSArray alloc] initWithObjects:@"Get Firmware Version", @"Get Status", @"Check Connection", @"Sample Receipt",
                         @"JP Sample Receipt", @"1D Barcodes", @"2D Barcodes", @"Text Formatting", @"JP Kanji Text Formatting",
                         @"Raster Graphics Text Printing", @"MSR", nil];
    }
    return self;
}

- (void)dealloc
{
    [arrayFunction release];
    
    [miniPrinterFunctions release];
    
    [uiview_block release];
    
    [uitextfield_portname release];
    [tableviewFunction release];
    [buttonSearch release];
    [buttonBack release];
    [buttonHelp release];

    [super dealloc];
}

+ (void)setPortName:(NSString *)m_portName
{
    [AppDelegate setPortName:m_portName];
}

+ (void)setPortSettings:(NSString *)m_portSettings
{
    [AppDelegate setPortSettings:m_portSettings];
}

- (void)setPortInfo
{
    NSString *localPortName = [NSString stringWithString: uitextfield_portname.text];
    [IOS_SDKViewControllerPortable setPortName:localPortName];
    
    NSString *localPortSettings = @"mini";

    [IOS_SDKViewControllerPortable setPortSettings:localPortSettings];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Splunk Mint Breadcrumb added
    [[Mint sharedInstance] leaveBreadcrumb:@"IOS_SDK_PortableView_ViewController"];
    uitextfield_portname.delegate = self;
    
    miniPrinterFunctions = [[MiniPrinterFunctions alloc] init];
    
    tableviewFunction.dataSource = self;
    tableviewFunction.delegate = self;
    
    uitextfield_portname.text = @"BT:PRNT Star";
    
    [AppDelegate setButtonArrayAsOldStyle:@[buttonBack, buttonHelp, buttonSearch]];
}

- (void)viewDidUnload
{
    [arrayFunction release];
    arrayFunction = nil;
    
    [miniPrinterFunctions release];
    miniPrinterFunctions = nil;
    
    [uitextfield_portname release];
    uitextfield_portname = nil;
    [tableviewFunction release];
    tableviewFunction = nil;
    [buttonBack release];
    buttonBack = nil;
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [arrayFunction count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    int index = (int)indexPath.row;
    cell.textLabel.text = arrayFunction[index];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view bringSubviewToFront:uiview_block];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    selectIndex = indexPath.row;
    
    UIActionSheet *actionsheetSampleReceipt = nil;
    
    [uitextfield_portname resignFirstResponder];
    
    [self setPortInfo];
    NSString *portName = [AppDelegate getPortName];
    NSString *portSettings = [AppDelegate getPortSettings];
    
    switch (selectIndex)
    {
        case 0:
            [MiniPrinterFunctions showFirmwareInformation:portName portSettings:portSettings];
            break;
            
        case 1:
        {
            [MiniPrinterFunctions CheckStatusWithPortname:portName portSettings:portSettings sensorSetting:SensorActiveHigh];
            break;
        }
        case 2:
        {
            CheckConnectionViewController *viewController = [[CheckConnectionViewController alloc] initWithNibName:@"CheckConnectionViewController" bundle:[NSBundle mainBundle]];
            [self presentModalViewController:viewController animated:YES];
            [viewController release];
            
            break;
        }
        
        case 3:
            actionsheetSampleReceipt = [[UIActionSheet alloc] initWithTitle:@"Printer Width" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"2 inch", @"3 inch", @"4 inch", nil];
            
            [actionsheetSampleReceipt showInView:self.view];
            [actionsheetSampleReceipt release];
            
            break;
            
        case 4:
            actionsheetSampleReceipt = [[UIActionSheet alloc] initWithTitle:@"Printer Width" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"2 inch", @"3 inch", @"4 inch", nil];
            
            [actionsheetSampleReceipt showInView:self.view];
            [actionsheetSampleReceipt release];

            break;
            
        case 5:
        {
            BarcodePrintingMini *barcodeMini = [[BarcodePrintingMini alloc] initWithNibName:@"BarcodePrintingMini" bundle:[NSBundle mainBundle]];
            [self presentModalViewController:barcodeMini animated:YES];
            [barcodeMini release];
            
            break;
        }
            
        case 6:
        {
            BarcodeSelector2D *barcodeSelector2d = [[BarcodeSelector2D alloc] initWithNibName:@"BarcodeSelector" bundle:[NSBundle mainBundle]];
            [self presentModalViewController:barcodeSelector2d animated:YES];
            [barcodeSelector2d release];
            
            break;
        }
            
        case 7:
        {
            TextFormatingMini *textformatingvar = [[TextFormatingMini alloc] initWithNibName:@"TextFormatingMini" bundle:[NSBundle mainBundle]];
            [self presentModalViewController:textformatingvar animated:YES];
            [textformatingvar release];
            
            break;
        }
            
        case 8:
        {
            JpKnjFormatingMini *jpKnjformatingvar = [[JpKnjFormatingMini alloc] initWithNibName:@"JpKnjFormatingMini" bundle:[NSBundle mainBundle]];
            [self presentModalViewController:jpKnjformatingvar animated:YES];
            [jpKnjformatingvar release];
            
            break;
        }
            
        case 9:
        {
            rasterPrinting *rasterPrintingVar = [[rasterPrinting alloc] initWithNibName:@"rasterPrinting" bundle:[NSBundle mainBundle]];
            [self presentModalViewController:rasterPrintingVar animated:YES];
            [rasterPrintingVar setOptionSwitch:YES];
            [rasterPrintingVar release];
            break;
        }
            
        case 10:
            [miniPrinterFunctions MCRStartWithPortName:portName portSettings:portSettings];
            break;
    }
    
    [self.view sendSubviewToBack:uiview_block];
}

#pragma mark UIActionSheet

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [uitextfield_portname resignFirstResponder];
    
    [self setPortInfo];
    
    NSString *portName = [AppDelegate getPortName];
    NSString *portSettings = [AppDelegate getPortSettings];
    
    switch (buttonIndex)
    {
        case 0: //2inch
            switch (selectIndex)
            {
                case 3: // EN
                    [MiniPrinterFunctions PrintSampleReceiptWithPortname:portName
                                                            portSettings:portSettings
                                                               widthInch:2];
                    break;
                    
                case 4: // JP
                    [MiniPrinterFunctions PrintKanjiSampleReceiptWithPortName:portName
                                                                 portSettings:portSettings
                                                                    widthInch:2];
                    break;
            }
            
            break;
            
        case 1: //3inch
            switch (selectIndex)
            {
                case 3: //EN
                    [MiniPrinterFunctions PrintSampleReceiptWithPortname:portName
                                                            portSettings:portSettings
                                                               widthInch:3];
                    break;
                    
                case 4: //JP
                    [MiniPrinterFunctions PrintKanjiSampleReceiptWithPortName:portName
                                                                 portSettings:portSettings
                                                                    widthInch:3];
                    break;
            }
            
            break;

        case 2: //4inch
            switch (selectIndex)
            {
                case 3: //EN
                    [MiniPrinterFunctions PrintSampleReceiptWithPortname:portName
                                                            portSettings:portSettings
                                                               widthInch:4];
                    break;
                    
                case 4: //JP
                    [MiniPrinterFunctions PrintKanjiSampleReceiptWithPortName:portName
                                                                 portSettings:portSettings
                                                                    widthInch:4];
                    break;
            }
            
            break;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)DismissActionSheet:(id)unusedID
{
    [tableviewFunction reloadData];
}

#pragma mark UITextField

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"] == YES)
    {
        [uitextfield_portname resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (IBAction)showHelp
{
    NSString *title = @"PORT PARAMETERS";
    
    NSString *helpText = [AppDelegate HTMLCSS];
    helpText = [helpText stringByAppendingString:@"<body>\
                 This program on supports ethernet and bluetooth interface.<br/>\
                 <Code>TCP:192.168.222.244</Code><br/>\
                 <It1>Enter IP address of Star Printer</It1><br/>\
                 <Code>BT:PRNT Star</Code><br/>\
                 <It1>Enter iOS Port Name of Star Portable Printer</It1><br/><br/>\
                 <LargeTitle><center>Port Settings</center></LargeTitle>\
                 <p>You should leave this blank for POS Printers. You should use 'mini' when connecting to a Portable Printers.</p>\
                 </body><html>"];
    
    StandardHelp *helpVar = [[StandardHelp alloc]initWithNibName:@"StandardHelp" bundle:[NSBundle mainBundle]];
    [self presentModalViewController:helpVar animated:YES];
    [helpVar release];

    [helpVar setHelpTitle:title];
    [helpVar setHelpText:helpText];
}

- (void)returnSelectedCellText
{
    NSString *selectedPortName = [searchView lastSelectedPortName];
    
    if ((selectedPortName != nil) && ([selectedPortName isEqualToString:@""] == NO))
    {
        uitextfield_portname.text = selectedPortName;
    }
    
    [self dismissModalViewControllerAnimated:YES];
}
@end
