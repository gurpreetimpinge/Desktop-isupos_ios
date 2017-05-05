//
//  PDF417.m
//  IOS_SDK
//
//  Created by Tzvi on 8/15/11.
//  Copyright 2011 - 2013 STAR MICRONICS CO., LTD. All rights reserved.
//

#import "AppDelegate.h"

#import "PDF417.h"
#import <QuartzCore/QuartzCore.h>
#import "StandardHelp.h"

#import "PrinterFunctions.h"

#import "AbstractActionSheetPicker.h"
#import "ActionSheetStringPicker.h"

@implementation PDF417

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        array_limit = [[NSArray alloc] initWithObjects:@"Use Limits", @"Use Fixed", nil];
        array_ratio = [[NSArray alloc] initWithObjects:@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", nil];
        array_direction = [[NSArray alloc] initWithObjects:@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", nil];
        array_security = [[NSArray alloc] initWithObjects:@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", nil];
    }
    return self;
}

- (void)dealloc
{
    [uiview_block release];
    [uiimageview_barcode release];
    [uitextfield_height release];
    [uitextfield_width release];
    [uitextfield_data release];
    [uilabel_height release];
    [uilabel_width release];
    [array_limit release];
    [array_ratio release];
    [array_direction release];
    [array_security release];
    [buttonLimit release];
    [buttonRatio release];
    [buttonDirection release];
    [buttonSecurity release];
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

    uiimageview_barcode.image = [UIImage imageNamed:@"pdf417.gif"];

    uitextfield_height.delegate = self;
    uitextfield_width.delegate = self;
    uitextfield_data.delegate = self;

    selectedLimit     = 0;
    selectedRatio     = 0;
    selectedDirection = 3;
    selectedSecurity  = 0;

    [buttonLimit     setTitle:array_limit    [selectedLimit]     forState:UIControlStateNormal];
    [buttonRatio     setTitle:array_ratio    [selectedRatio]     forState:UIControlStateNormal];
    [buttonDirection setTitle:array_direction[selectedDirection] forState:UIControlStateNormal];
    [buttonSecurity  setTitle:array_security [selectedSecurity]  forState:UIControlStateNormal];
    
    [AppDelegate setButtonArrayAsOldStyle:@[buttonBack, buttonDirection, buttonHelp, buttonLimit, buttonPrint, buttonRatio, buttonSecurity]];
}

- (void)viewDidUnload
{
    [uiview_block release];
    uiview_block = nil;
    [uiimageview_barcode release];
    uiimageview_barcode = nil;
    [uitextfield_height release];
    uitextfield_height = nil;
    [uitextfield_width release];
    uitextfield_width = nil;
    [uitextfield_data release];
    uitextfield_data = nil;
    [uilabel_height release];
    uilabel_height = nil;
    [uilabel_width release];
    uilabel_width = nil;
    [array_limit release];
    array_limit = nil;
    [array_ratio release];
    array_ratio = nil;
    [array_direction release];
    array_direction = nil;
    [array_security release];
    array_security = nil;
    [buttonLimit release];
    buttonLimit = nil;
    [buttonRatio release];
    buttonRatio = nil;
    [buttonDirection release];
    buttonDirection = nil;
    [buttonSecurity release];
    buttonSecurity = nil;
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

- (IBAction)backPDF417
{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)selectLimit:(id)sender
{
    ActionStringDoneBlock done = ^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue)
    {
        selectedLimit = selectedIndex;

        [buttonLimit setTitle:selectedValue forState:UIControlStateNormal];

        if (selectedLimit == 0) {
            uilabel_height.text = @"height=1\u2264h\u226499";
            uilabel_width.text = @"width=1\u2264w\u226499";
        } else {
            uilabel_height.text = @"height=0,3\u2264h\u226490";
            uilabel_width.text = @"width=0,1\u2264w\u226430";
        }
    };

    ActionStringCancelBlock cancel = ^(ActionSheetStringPicker *picker)
    {
    };

    [ActionSheetStringPicker showPickerWithTitle:@"Select Limit" rows:array_limit initialSelection:selectedLimit doneBlock:done cancelBlock:cancel origin:sender];
}

- (IBAction)selectRatio:(id)sender
{
    ActionStringDoneBlock done = ^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue)
    {
        selectedRatio = selectedIndex;

        [buttonRatio setTitle:selectedValue forState:UIControlStateNormal];
    };

    ActionStringCancelBlock cancel = ^(ActionSheetStringPicker *picker)
    {
    };

    [ActionSheetStringPicker showPickerWithTitle:@"Select Ratio" rows:array_ratio initialSelection:selectedRatio doneBlock:done cancelBlock:cancel origin:sender];
}

- (IBAction)selectDirection:(id)sender
{
    ActionStringDoneBlock done = ^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue)
    {
        selectedDirection = selectedIndex;

        [buttonDirection setTitle:selectedValue forState:UIControlStateNormal];
    };

    ActionStringCancelBlock cancel = ^(ActionSheetStringPicker *picker)
    {
    };

    [ActionSheetStringPicker showPickerWithTitle:@"Select Direction" rows:array_direction initialSelection:selectedDirection doneBlock:done cancelBlock:cancel origin:sender];
}

- (IBAction)selectSecurity:(id)sender
{
    ActionStringDoneBlock done = ^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue)
    {
        selectedSecurity = selectedIndex;

        [buttonSecurity setTitle:selectedValue forState:UIControlStateNormal];
    };

    ActionStringCancelBlock cancel = ^(ActionSheetStringPicker *picker)
    {
    };

    [ActionSheetStringPicker showPickerWithTitle:@"Select Security" rows:array_security initialSelection:selectedSecurity doneBlock:done cancelBlock:cancel origin:sender];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{   
    if ([string isEqualToString:@"\n"] == YES)
    {
        [uitextfield_data resignFirstResponder];
        [uitextfield_height resignFirstResponder];
        [uitextfield_width resignFirstResponder];
        return NO;
    }
    
    if (uitextfield_data == textField)
    {
        return YES;
    }
    
    if ([string length] == 0)
    {
        return YES;
    }
    
    if (([string characterAtIndex:0] >= '0') && ([string characterAtIndex:0] <= '9'))
    {
        return YES;
    }
    
    return NO;
}

- (IBAction)showHelp
{
    NSString *title = @"PDF417 BARCODES";
    NSString *helpText = [AppDelegate HTMLCSS];
    helpText = [helpText stringByAppendingString: @"<body>\
                <p>PDF417 Barcodes are public domain.  They can contain a much \
                larger amount of data because it can link one barcode to another \
                to create one portable data file from many PDF417 barcodes.</p>\
                <SectionHeader>(1)Size setting<SectionHeader><br/>\
                <Code>ASCII:</Code> <CodeDef>ESC GS x S 0 <StandardItalic>n p1 p2</StandardItalic></CodeDef><br/>\
                <Code>Hex:</Code> <CodeDef>1B 1D 78 53 30 <StandardItalic>n p1 p2</StandardItalic></CodeDef><br/><br/>\
                <SectionHeader>(2)ECC (Security Level)</SectionHeader><br/>\
                <Code>ASCII:</Code> <CodeDef>ESC GS x S 1 <StandardItalic>n</StandardItalic></CodeDef><br/>\
                <Code>Hex:</Code> <CodeDef>1B 1D 78 53 31 <StandardItalic>n</StandardItalic></CodeDef><br/><br/>\
                <SectionHeader>(3)Module x direction size</SectionHeader><br/>\
                <Code>ASCII:</Code> <CodeDef>ESC GS x S 2 <StandardItalic>n</StandardItalic></CodeDef><br/>\
                <Code>Hex:</Code> <CodeDef>1B 1D 78 53 32 <StandardItalic>n</StandardItalic></CodeDef><br/><br/>\
                <SectionHeader>(4)Module aspect ratio</SectionHeader><br>\
                <Code>ASCII:</Code> <CodeDef>ESC GS x S 3 <StandardItalic>n</StandardItalic></CodeDef><br>\
                <Code>Hex:</Code> <CodeDef>1B 1D 78 53 33 <StandardItalic>n</StandardItalic></CodeDef><br/><br/>\
                <SectionHeader>(5)Data setting</SectionHeader><br/>\
                <Code>ASCII:</Code> <CodeDef>ESC GS x D <StandardItalic>nL nH d1d2 ... dk</StandardItalic></CodeDef><br/>\
                <Code>Hex:</Code> <CodeDef>1B 1D 78 44 <StandardItalic>nL nH d1d2 ... dk</StandardItalic></CodeDef><br/><br/>\
                <SectionHeader>(6)Printing</SectionHeader><br/>\
                <Code>ASCII:</Code> <CodeDef>ESC GS x P</CodeDef><br/>\
                <Code>Hex:</Code> <CodeDef>1B 1D 78 50</CodeDef><br/><br/>\
                <SectionHeader>(7)Expansion Info</SectionHeader><br/>\
                <Code>ASCII:</Code> <CodeDef>ESC GS x 1</CodeDef><br/>\
                <Code>Hex:</Code> <CodeDef>1B 1D 78 49</CodeDef><br/<br/>\
                For more information on PDF417 commands, please read 2d Barcode \
                PDF417 section in the Thermal Line Mode Command Specification Manual."];
    
    StandardHelp *helpVar = [[StandardHelp alloc]initWithNibName:@"StandardHelp" bundle:[NSBundle mainBundle]];
    [self presentModalViewController:helpVar animated:YES];
    [helpVar release];
    
    [helpVar setHelpTitle:title];
    [helpVar setHelpText:helpText];
}

- (IBAction)printBarcode
{
    [self.view bringSubviewToFront:uiview_block];
    
    NSString *portName = [AppDelegate getPortName];
    NSString *portSettings = [AppDelegate getPortSettings];

    NSData *barcodeData = [uitextfield_data.text dataUsingEncoding:NSWindowsCP1252StringEncoding];

    unsigned char *barcodeBytes = (unsigned char *)malloc([barcodeData length]);
    [barcodeData getBytes:barcodeBytes];

    NSString *heightString = uitextfield_height.text;
    int height = [heightString intValue];

    NSString *widthString = uitextfield_width.text;
    int width = [widthString intValue];

    Limit         limit     = (Limit)selectedLimit;
    unsigned char ratio     = selectedRatio + 1;
    unsigned char direction = selectedDirection + 1;
    unsigned char security  = selectedSecurity;

    [PrinterFunctions PrintPDF417CodeWithPortname:portName portSettings:portSettings limit:limit p1:height p2:width securityLevel:security xDirection:direction aspectRatio:ratio barcodeData:barcodeBytes barcodeDataSize:(unsigned int)[barcodeData length]];

    free(barcodeBytes);
    
    [self.view sendSubviewToBack:uiview_block];
}

@end
