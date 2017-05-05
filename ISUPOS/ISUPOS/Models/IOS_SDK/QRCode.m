//
//  QRCode.m
//  IOS_SDK
//
//  Created by Tzvi on 8/9/11.
//  Copyright 2011 - 2013 STAR MICRONICS CO., LTD. All rights reserved.
//

#import "AppDelegate.h"

#import "QRCode.h"
#import <QuartzCore/QuartzCore.h>
#import "StandardHelp.h"

#import "PrinterFunctions.h"

#import "AbstractActionSheetPicker.h"
#import "ActionSheetStringPicker.h"

@implementation QRCode

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        array_correction = [[NSArray alloc] initWithObjects:@"L 7%", @"M 15%", @"Q 25%", @"H 30%", nil];
        array_model = [[NSArray alloc] initWithObjects:@"Model 1", @"Model 2", nil];
        array_cell = [[NSArray alloc] initWithObjects:@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", nil];
    }
    
    return self;
}

- (void)dealloc
{
    [uiview_block release];
    [uiimageview_barcode release];
    [uilabel_cellsize release];
    
    [buttonCorrection release];
    [buttonModel release];
    [buttonCell release];
    
    [array_correction release];
    [array_model release];
    [array_cell release];

    [buttonBack release];
    [buttonHelp release];
    [buttonPrint release];
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

    uiimageview_barcode.image = [UIImage imageNamed:@"qrcode.gif"];

    uitextfield_data.delegate = self;

    selectedCorrection = 0;
    selectedModel      = 1;
    selectedCell       = 5;

    [buttonCorrection setTitle:array_correction[selectedCorrection] forState:UIControlStateNormal];
    [buttonModel      setTitle:array_model     [selectedModel]      forState:UIControlStateNormal];
    [buttonCell       setTitle:array_cell      [selectedCell]       forState:UIControlStateNormal];
    
    [AppDelegate setButtonArrayAsOldStyle:@[buttonBack, buttonCell, buttonCorrection, buttonHelp, buttonModel, buttonPrint]];
}

- (void)viewDidUnload
{
    [uiview_block release];
    uiview_block = nil;
    [uiimageview_barcode release];
    uiimageview_barcode = nil;
    [uilabel_cellsize release];
    uilabel_cellsize = nil;
    
    [buttonCorrection release];
    buttonCorrection = nil;
    [buttonModel release];
    buttonModel = nil;
    [buttonCell release];
    buttonCell = nil;
    
    [array_correction release];
    array_correction = nil;
    [array_model release];
    array_model = nil;
    [array_cell release];
    array_cell = nil;
    
    [buttonBack release];
    buttonBack = nil;
    [buttonHelp release];
    buttonHelp = nil;
    [buttonPrint release];
    buttonPrint = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)backQrcode
{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)selectCorrection:(id)sender
{
    ActionStringDoneBlock done = ^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue)
    {
        selectedCorrection = selectedIndex;

        [buttonCorrection setTitle:selectedValue forState:UIControlStateNormal];
    };

    ActionStringCancelBlock cancel = ^(ActionSheetStringPicker *picker)
    {
    };

    [ActionSheetStringPicker showPickerWithTitle:@"Select Correction" rows:array_correction initialSelection:selectedCorrection doneBlock:done cancelBlock:cancel origin:sender];
}

- (IBAction)selectModel:(id)sender
{
    ActionStringDoneBlock done = ^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue)
    {
        selectedModel = selectedIndex;

        [buttonModel setTitle:selectedValue forState:UIControlStateNormal];
    };

    ActionStringCancelBlock cancel = ^(ActionSheetStringPicker *picker)
    {
    };

    [ActionSheetStringPicker showPickerWithTitle:@"Select Model" rows:array_model initialSelection:selectedModel doneBlock:done cancelBlock:cancel origin:sender];
}

- (IBAction)selectCell:(id)sender
{
    ActionStringDoneBlock done = ^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue)
    {
        selectedCell = selectedIndex;

        [buttonCell setTitle:selectedValue forState:UIControlStateNormal];
    };

    ActionStringCancelBlock cancel = ^(ActionSheetStringPicker *picker)
    {
    };

    [ActionSheetStringPicker showPickerWithTitle:@"Select Cell" rows:array_cell initialSelection:selectedCell doneBlock:done cancelBlock:cancel origin:sender];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{   
    if ([string isEqualToString:@"\n"] == YES)
    {
        [uitextfield_data resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (IBAction)showHelp
{
    NSString *title = @"QR CODES";
    NSString *helpText = [AppDelegate HTMLCSS];
    helpText = [helpText stringByAppendingString: @"<body><p>StarMicronics supports all the latest high data density\
                for QR codes.  QR Codes  are handy for distributing URLs, Music, Images, E-Mails, \
                Contacts and much more.  Is is public domain and great for storing Japanese Kanji \
                and Kana characters.  They can be scanned with almost all smart phones which is great \
                if you want to for example, put a QR Code to hyperlink you company's Facebook profile on \
                the bottom of every receipt. <br/><br/>\
                <SectionHeader>(1) Set barcode model</SectionHeader><br/>\
                <Code>ASCII:</Code> <CodeDef>ESC GS y S 0 <StandardItalic>n</StandardItalic></CodeDef><br/>\
                <Code>Hex:</Code> <CodeDef>1B 1D 79 53 30 <StandardItalic>n</StandardItalic></CodeDef><br/><br/>\
                <SectionHeader>(2)Set error correction level</SectionHeader><br/>\
                <Code>ASCII:</Code> <CodeDef>ESC GS y S 1 <StandardItalic>n</StandardItalic></CodeDef><br/>\
                <Code>Hex:</Code> <CodeDeF>1B 1D 79 53 31 <StandardItalic>n</StandardItalic></CodeDef><br/><br/>\
                <SectionHeader>(3)Specify size of cell</SectionHeader><br/>\
                <Code>ASCII:</Code> <CodeDef>ESC GS y S 2 <StandardItalic>n</StandardItalic></CodeDef><br/>\
                <Code>Hex:</Code> <CodeDef>1B 1D 79 53 32 <StandardItalic>n</StandardItalic></CodeDef><br/><br/>\
                <SectionHeader>(4)Set barcode data</SectionHeader><br/>\
                <Code>ASCII:</Code> <CodeDef>ESC GS y D 1 NUL <StandardItalic>nL nH d1d2 ... dk</StandardItalic></CodeDef><br/>\
                <Code>Hex:</Code> <CodeDef>1B 1D 79 44 31 00 <StandardItalic>nL nH d1d2 ... dk</StandardItalic></CodeDef><br/><br/>\
                <SectionHeader>(5)Print barcode</SectionHeader><br/>\
                <Code>ASCII:</Code> <CodeDef>ESC GS y P</CodeDef><br/>\
                <Code>Hex:</Code> <CodeDef>1B 1D 79 50</CodeDef><br/></br>\
                * Note the QR code is a registered trademark of DENSO WEB\
                </body><html>"];
    
    StandardHelp *helpVar = [[StandardHelp alloc]initWithNibName:@"StandardHelp" bundle:[NSBundle mainBundle]];
    [self presentModalViewController:helpVar animated:YES];
    [helpVar release];
    
    [helpVar setHelpTitle:title];
    [helpVar setHelpText:helpText];
}

- (IBAction)printQrcode
{
    [self.view bringSubviewToFront:uiview_block];
    
    NSString *portName = [AppDelegate getPortName];
    NSString *portSettings = [AppDelegate getPortSettings];

    NSData *barcodeData = [uitextfield_data.text dataUsingEncoding:NSWindowsCP1252StringEncoding];

    unsigned char *barcodeBytes = (unsigned char*)malloc([barcodeData length]);
    [barcodeData getBytes:barcodeBytes];

    CorrectionLevelOption correction = (CorrectionLevelOption)selectedCorrection;
    Model                 model      = (Model)selectedModel;
//  unsigned char         cell       = selectedCell;
    unsigned char         cell       = (unsigned char)selectedCell + 1;

    [PrinterFunctions PrintQrcodeWithPortname:portName portSettings:portSettings correctionLevel:correction model:model cellSize:cell barcodeData:barcodeBytes barcodeDataSize:(unsigned int)[barcodeData length]];

    free(barcodeBytes);
    
    [self.view sendSubviewToBack:uiview_block];
}

@end
