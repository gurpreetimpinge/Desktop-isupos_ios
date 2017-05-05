//
//  BarcodePrintingMini.m
//  IOS_SDK
//
//  Created by Tzvi on 8/23/11.
//  Copyright 2011 - 2013 STAR MICRONICS CO., LTD. All rights reserved.
//

#import "AppDelegate.h"

#import "BarcodePrintingMini.h"
#import <QuartzCore/QuartzCore.h>
#import "StandardHelp.h"

#import "MiniPrinterFunctions.h"

#import "AbstractActionSheetPicker.h"
#import "ActionSheetStringPicker.h"

@implementation BarcodePrintingMini

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        array_width = [[NSArray alloc] initWithObjects:@"0.125", @"0.25", @"0.375", @"0.5", @"0.625", @"0.75", @"0.875", @"1.0", nil];
        array_type = [[NSArray alloc] initWithObjects:@"code39", @"code93", @"ITF", @"code128", nil];
    }
    
    return self;
}

- (void)dealloc
{
    [uiview_block release];
    
    [uitextfield_height release];
    [uitextfield_data release];
    
    [buttonWidth release];
    [buttonType release];
    
    [array_width release];
    [array_type release];
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

    uitextfield_data.delegate = self;
    uitextfield_height.delegate = self;

    selectedWidth = 0;
    selectedType  = 0;

    [buttonWidth setTitle:array_width[selectedWidth] forState:UIControlStateNormal];
    [buttonType  setTitle:array_type[selectedType] forState:UIControlStateNormal];
    
    [AppDelegate setButtonArrayAsOldStyle:@[buttonBack, buttonHelp, buttonPrint, buttonType, buttonWidth]];
}

- (void)viewDidUnload
{
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

- (IBAction)backBarcodeMini
{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)selectWidth:(id)sender
{
    ActionStringDoneBlock done = ^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue)
    {
        selectedWidth = selectedIndex;

        [buttonWidth setTitle:selectedValue forState:UIControlStateNormal];
    };

    ActionStringCancelBlock cancel = ^(ActionSheetStringPicker *picker)
    {
    };

    [ActionSheetStringPicker showPickerWithTitle:@"Select Width" rows:array_width initialSelection:selectedWidth doneBlock:done cancelBlock:cancel origin:sender];
}

- (IBAction)selectType:(id)sender
{
    ActionStringDoneBlock done = ^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue)
    {
        selectedType = selectedIndex;

        [buttonType setTitle:selectedValue forState:UIControlStateNormal];
    };

    ActionStringCancelBlock cancel = ^(ActionSheetStringPicker *picker)
    {
    };

    [ActionSheetStringPicker showPickerWithTitle:@"Select Type" rows:array_type initialSelection:selectedType doneBlock:done cancelBlock:cancel origin:sender];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"] == YES)
    {
        [uitextfield_data resignFirstResponder];
        [uitextfield_height resignFirstResponder];
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
    NSString *title = @"BARCODE PRINTING PORTABLE";
    NSString *helpText = [AppDelegate HTMLCSS];
    helpText = [helpText stringByAppendingString:@"<UnderlineTitle>Set Barcode Height</UnderlineTitle><br/><br/>\n\
                <Code>ASCII:</Code> <CodeDef>GS h <StandardItalic>n</StandardItalic></CodeDef><br/>\
                <Code>Hex:</Code> <CodeDef>1D 68 <StandardItalic>n</StandardItalic></CodeDef><br/><br/>\
                * Note: <StandardItalic>n</StandardItalic> must be between 0 and 255<br/><br/>\
                <UnderlineTitle>Set barcode width</UnderlineTitle><br/><br/>\
                <Code>ASCII:</Code> <CodeDef>GS w <StandardItalic>n</StandardItalic></CodeDef><br/>\
                <Code>Hex:</Code> <CodeDef>1D 77 <StandardItalic>n</StandardItalic></CodeDef><br/><br/>\
                <rightMov> 1&#60;n&#60;8</rightMov><br/><br/>\
                <table border=\"1\" BORDERCOLOR=\"black\" cellspacing=0 bgcolor=\"#FFFFCC\">\
                    <tr>\
                        <td rowspan=\"2\" width=\"30\" bgcolor=\"#800000\"><font color=\"white\"><center>n</center></font></td>\
                        <td rowspan=\"2\" width=\"125\" bgcolor=\"#800000\"><font color=\"white\"><center>Multi-Level Barcode Module width(mm)</center></font></td>\
                        <td rowspan=\"1\" colspan=\"2\" bgcolor=\"#800000\"><font color=\"white\"><center>Binary Level Barcode</center></font></td>\
                </tr>\
                <tr>\
                    <td bgcolor=\"#800000\"><font color=\"white\"><center>Thin Element width(mm)</center></font></td>\
                    <td bgcolor=\"#800000\"><font color=\"white\"><center>Thick Element width(mm)</center></font></td>\
                </tr>\
                <tr>\
                    <td><center>1</center></td>\
                    <td><center>0.125</center></td>\
                    <td><center>0.125</center></td>\
                    <td><center>0.375 (= 0.125 * 3 )</center></td>\
                </tr>\
                <tr>\
                    <td><center>2</center></td>\
                    <td><center>0.25</center></td>\
                    <td><center>0.25</center></td>\
                    <td><center>0.625 ( = 0.25 * 2.5 )</center></td>\
                </tr>\
                <tr>\
                    <td><center>3</center></td>\
                    <td><center>0.375</center></td>\
                    <td><center>0.375</center></td>\
                    <td><center>1.125 ( = 0.375 * 3 )</center></td>\
                </tr>\
                <tr>\
                    <td><center>4</center></td>\
                    <td><center>0.5</center></td>\
                    <td><center>0.5</center></td>\
                    <td><center>1.25 ( = 0.5 * 2.5 )</center></td>\
                </tr>\
                <tr>\
                    <td><center>5</center></td>\
                    <td><center>0.625</center></td>\
                    <td><center>0.625</center></td>\
                    <td><center>1.875 ( = 0.625 * 3 )</center></td>\
                </tr>\
                <tr>\
                    <td><center>6</center></td>\
                    <td><center>0.75</center></td>\
                    <td><center>0.75</center></td>\
                    <td><center>1.875 ( = 0.75 * 2.5 )</center></td>\
                </tr>\
                <tr>\
                    <td><center>7</center></td>\
                    <td><center>0.875</center></td>\
                    <td><center>0.875</center></td>\
                    <td><center>2.625 ( = 0.875 * 3 )</center></td>\
                </tr>\
                <tr>\
                    <td><center>8</center></td>\
                        <td><center>1.0</center></td>\
                    <td><center>1.0</center></td>\
                    <td><center>2.5 ( = 1.0 * 2.5 )</center></td>\
                </tr>\
            </table><br/>\
                <UnderlineTitle>Print barcode</UnderlineTitle><br/><br/>\
                <Code>ASCII:</Code> <CodeDef>GS k <StandardItalic>m d1 ... dk</StandardItalic> NUL</CodeDef><br/>\
                <Code>Hex:</Code> <CodeDef>1D 6B <StandardItalic>m d1 ... dk</StandardItalic> 00</CodeDef><br/><br/>\
                <rightMov>m = Barcode Type See manual (pg 35)</rightMov><br/>\
                <rightMov>d1 ... dk = Barcode data. see manual (pg 35) for supported characters</rightMov></body></html>"];
    
    StandardHelp *helpVar = [[StandardHelp alloc] initWithNibName:@"StandardHelp" bundle:[NSBundle mainBundle]];
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

    unsigned char *barcodeBytes = (unsigned char*)malloc([barcodeData length]);
    [barcodeData getBytes:barcodeBytes];

    NSString *heightString = uitextfield_height.text;
    int height = [heightString intValue];

    BarcodeWidth width = (BarcodeWidth)selectedWidth;
    BarcodeType  type  = (BarcodeType)selectedType;

    [MiniPrinterFunctions PrintBarcodeWithPortname:portName portSettings:portSettings height:height width:width barcodeType:type barcodeData:barcodeBytes barcodeDataSize:(unsigned int)[barcodeData length]];

    free(barcodeBytes);
    
    [self.view sendSubviewToBack:uiview_block];
}

@end
