//
//  IOS_SDKViewControllerRasterMode.m
//  IOS_SDK
//
//  Created by Tzvi on 8/2/11.
//  Copyright 2011 - 2013 STAR MICRONICS CO., LTD. All rights reserved.
//

#import "AppDelegate.h"

#import "IOS_SDKViewControllerRasterMode.h"
#import "StarIO/SMPort.h"
#import "PrinterFunctions.h"
#import "Cut.h"
#import "rasterPrinting.h"
#import "StandardHelp.h"
#import "CommonTableView.h"

#import <QuartzCore/QuartzCore.h>

#import "AbstractActionSheetPicker.h"
#import "ActionSheetStringPicker.h"
#import "BluetoothSettingViewController.h"
#import "Language.h"

@implementation IOS_SDKViewControllerRasterMode

- (id)init
{
    self = [super init];
    if (self)
    {
        
    }
    
    return self;
}

- (IBAction)pushButtonBack:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        array_port = [[NSArray alloc] initWithObjects:@"Standard", @"9100", @"9101", @"9102", @"9103", @"9104", @"9105", @"9106", @"9107", @"9108", @"9109", nil];
        arrayFunction = [[NSArray alloc] initWithObjects:@"Get Firmware Information", @"Get Status", @"Sample Receipt", @"JP Sample Receipt", @"Open Cash Drawer 1", @"Open Cash Drawer 2", @"Raster Graphics Text Printing",
                                                         @"Bluetooth Pairing + Connect", @"Bluetooth Disconnect", @"Bluetooth Setting", nil];
        array_sensorActive = [[NSArray alloc] initWithObjects:@"High", @"Low", nil];
        array_sensorActivePickerContents = [[NSArray alloc] initWithObjects:@"High When Drawer Open", @"Low When Drawer Open", nil];
    }
    
    return self;
}

- (void)dealloc
{
    [arrayFunction release];

    [uiview_block release];

    [uitextfield_portname release];
    [tableviewFunction release];
    [buttonBack release];
    
    [buttonPort release];
    [buttonSensorActive release];
    
    [array_port release];
    [array_sensorActive release];
    [array_sensorActivePickerContents release];

    [buttonHelp release];
    [buttonSearch release];
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
    [IOS_SDKViewControllerRasterMode setPortName:localPortName];

    [IOS_SDKViewControllerRasterMode setPortSettings:array_port[selectedPort]];
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
    [[Mint sharedInstance] leaveBreadcrumb:@"IOS_SDK_RasterMode_ViewController"];
    
    uitextfield_portname.delegate = self;

    tableviewFunction.dataSource = self;
    tableviewFunction.delegate   = self;

    selectedPort = 0;
    selectedSensorActive = 0;

    [buttonPort setTitle:array_port[selectedPort] forState:UIControlStateNormal];
    [buttonSensorActive setTitle:array_sensorActive[selectedSensorActive] forState:UIControlStateNormal];
    
    uitextfield_portname.text = @"BT:Star Micronics";
    
    [AppDelegate setButtonArrayAsOldStyle:@[buttonBack, buttonHelp, buttonPort, buttonSearch, buttonSensorActive]];
}

- (void)viewDidUnload
{
    [uiview_block release];
    uiview_block = nil;
    
    [uitextfield_portname release];
    uitextfield_portname = nil;
    [tableviewFunction release];
    tableviewFunction = nil;
    [buttonBack release];
    buttonBack = nil;
    
    [searchView release];
    searchView = nil;
    
    [buttonPort release];
    buttonPort = nil;
    [buttonSensorActive release];
    buttonSensorActive = nil;
    
    [buttonHelp release];
    buttonHelp = nil;
    [buttonSearch release];
    buttonSearch = nil;
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
    return arrayFunction.count;
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
    
    [uitextfield_portname resignFirstResponder];
    
    [self setPortInfo];

    NSString *portName = [AppDelegate getPortName];
    NSString *portSettings = [AppDelegate getPortSettings];

    selectIndex = indexPath.row;

    switch (selectIndex)
    {
        case 0:
        {
            [PrinterFunctions showFirmwareVersion:portName portSettings:portSettings];
            break;
        }
        case 1:
        {
            SensorActive sensorSetting = (selectedSensorActive == 0) ? SensorActiveHigh : SensorActiveLow;
        
            [PrinterFunctions CheckStatusWithPortname:portName portSettings:portSettings sensorSetting:sensorSetting];
            break;
        }
            
        case 2:
        case 3:
            {
                UIActionSheet *actionsheetSampleReceipt = [[UIActionSheet alloc] initWithTitle:@"Paper Width" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"3 inch", @"4 inch", nil];
                [actionsheetSampleReceipt showInView:self.view];
                [actionsheetSampleReceipt release];
            }
            
            break;
            
        case 4:
            [PrinterFunctions OpenCashDrawerWithPortname:portName portSettings:portSettings drawerNumber:1];
            break;
            
        case 5:
            [PrinterFunctions OpenCashDrawerWithPortname:portName portSettings:portSettings drawerNumber:2];
            break;
            
        case 6:
        {
            rasterPrinting *rasterPrintingVar = [[rasterPrinting alloc] initWithNibName:@"rasterPrinting" bundle:[NSBundle mainBundle]];
            [self presentModalViewController:rasterPrintingVar animated:YES];
            [rasterPrintingVar setOptionSwitch:NO];
            [rasterPrintingVar release];
            break;
        }
            
        case 7: //Bluetooth Pairing + Connect
            if (UIDevice.currentDevice.systemVersion.floatValue < 6.0) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[Language get:@"Error" alter:@"!Error"]
                                                                message:[Language get:@"This function requires iOS6 or later." alter:@"!This function requires iOS6 or later."]
                                                               delegate:nil
                                                      cancelButtonTitle:nil
                                                      otherButtonTitles:@"OK", nil];
                [alert show];
                break;
            }
            
            [EAAccessoryManager.sharedAccessoryManager showBluetoothAccessoryPickerWithNameFilter:nil completion:nil];
            break;
            
        case 8: //Bluetooth Disconnect
        {
            NSArray *devices = [[SMPort searchPrinter:@"BT:"] retain];
            
            NSMutableArray *supportedDevices = [NSMutableArray new];
            for (PortInfo *port in devices) {
                if ([port.modelName isEqualToString:@"SAC10"] ||        //DK-AirCash
                    [port.modelName isEqualToString:@"Star Micronics"]) { //POS Printer
                    [supportedDevices addObject:port];
                }
            }
            
            commonTableView = [[CommonTableView alloc] initWithNibName:@"CommonTableView"
                                                                bundle:[NSBundle mainBundle]
                                                               devices:supportedDevices
                                                              delegate:self
                                                                action:@selector(disconnect:)];
            [self presentModalViewController:commonTableView animated:YES];
            
            [supportedDevices release];
            [devices release];
            [commonTableView release];
        }
            break;
            
        case 9: //Bluetooth Setting
        {
            SMBluetoothManager *manager = [[PrinterFunctions loadBluetoothSetting:portName portSettings:portSettings] retain];
            if (manager == nil) {
                break;
            }
            
            BluetoothSettingViewController *btSetting = [[BluetoothSettingViewController alloc] initWithNibName:@"BluetoothSettingViewController"
                                                                                                         bundle:[NSBundle mainBundle]
                                                                                               bluetoothManager:manager];
            [manager release];
            
            [self presentModalViewController:btSetting animated:YES];
            
            [btSetting release];
            break;
        }
    }
    
    [self.view sendSubviewToBack:uiview_block];
}

- (void)disconnect:(PortInfo *)portInfo {
    if (portInfo != nil)
        [PrinterFunctions disconnectPort:portInfo.portName portSettings:@"" timeout:10000];
    
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark UIAlertView

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100) //Search Printer
    {
        if (buttonIndex == 0) //Cancel
            return;
        
        NSArray *array = nil;
        switch (buttonIndex) {
            case 1: //LAN
                array = [[SMPort searchPrinter:@"TCP:"] retain];
                break;
            case 2: //Bluetooth
                array = [[SMPort searchPrinter:@"BT:"] retain];
                break;
            case 3: //All
                array = [[SMPort searchPrinter] retain];
                break;
        }
        
        searchView = [[SearchPrinterViewController alloc] initWithNibName:@"SearchPrinterViewController" bundle:nil];
        searchView.foundPrinters = array;
        searchView.delegate = self;
        [self presentModalViewController:searchView animated:YES];
        [searchView release];
        [array release];
    }
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
        case 0: // 3inch
            switch (selectIndex)
            {
                case 2:
                    [PrinterFunctions PrintRasterSampleReceipt3InchWithPortname:portName portSettings:portSettings];
                    break;
                    
                case 3:
                    [PrinterFunctions PrintRasterKanjiSampleReceipt3InchWithPortname:portName portSettings:portSettings];
                    break;
            }
            break;
            
        case 1: // 4inch
            switch (selectIndex)
            {
                case 2:
                    [PrinterFunctions PrintRasterSampleReceipt4InchWithPortname:portName portSettings:portSettings];
                    break;
                    
                case 3:
                    [PrinterFunctions PrintRasterKanjiSampleReceipt4InchWithPortname:portName portSettings:portSettings];
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

#pragma mark Other methods

- (IBAction)pushButtonSearch:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[Language get:@"Select Interface" alter:@"!Select Interface"]
                                                    message:@""
                                                   delegate:self
                                          cancelButtonTitle:[Language get:@"Cancel" alter:@"!Cancel"]
                                          otherButtonTitles:@"LAN", @"Bluetooth", @"All", nil];
    alert.tag = 100;
    
    [alert show];
    [alert release];
}

- (IBAction)selectPort:(id)sender
{
    ActionStringDoneBlock done = ^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue)
    {
        selectedPort = selectedIndex;
        
        [buttonPort setTitle:selectedValue forState:UIControlStateNormal];
    };
    
    ActionStringCancelBlock cancel = ^(ActionSheetStringPicker *picker)
    {
    };
    
    [ActionSheetStringPicker showPickerWithTitle:@"Select Port" rows:array_port initialSelection:selectedPort doneBlock:done cancelBlock:cancel origin:sender];
}

- (IBAction)selectSensorActive:(id)sender
{
    ActionStringDoneBlock done = ^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue)
    {
        selectedSensorActive = selectedIndex;
        
        [buttonSensorActive setTitle:array_sensorActive[selectedIndex] forState:UIControlStateNormal];
    };
    
    ActionStringCancelBlock cancel = ^(ActionSheetStringPicker *picker)
    {
    };
    
    [ActionSheetStringPicker showPickerWithTitle:@"Drawer Open Status" rows:array_sensorActivePickerContents initialSelection:selectedSensorActive doneBlock:done cancelBlock:cancel origin:sender];
}

- (IBAction)showHelp
{
    NSString *title = @"PORT PARAMETERS";
    
    NSString *helpText = [AppDelegate HTMLCSS];
    helpText = [helpText stringByAppendingString:@"<body>\
                 This program on supports ethernet and bluetooth interface.<br/>\
                 <Code>TCP:192.168.222.244</Code><br/>\
                 <It1>Enter IP address of Star Printer</It1><br/><br/>\
                 <Code>BT:Star Micronics</Code><br/>\
                 <It1>Enter iOS Port Name of Star Printer</It1><br/><br/>\
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
