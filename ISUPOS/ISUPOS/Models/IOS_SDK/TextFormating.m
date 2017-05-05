//
//  TextFormating.m
//  IOS_SDK
//
//  Created by Tzvi on 8/16/11.
//  Copyright 2011 - 2013 STAR MICRONICS CO., LTD. All rights reserved.
//

#import "AppDelegate.h"

#import "TextFormating.h"
#import <QuartzCore/QuartzCore.h>
#import "StandardHelp.h"

#import "PrinterFunctions.h"

#import "AbstractActionSheetPicker.h"
#import "ActionSheetStringPicker.h"

@implementation TextFormating

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        array_height = [[NSArray alloc] initWithObjects:@"1", @"2", @"3", @"4", @"5", @"6", nil];
        array_width = [[NSArray alloc] initWithObjects:@"1", @"2", @"3", @"4", @"5", @"6", nil];
        array_alignment = [[NSArray alloc] initWithObjects:@"Left", @"Center", @"Right", nil];
        blocking = NO;
    }
    
    return self;
}

- (void)dealloc
{
    [array_height release];
    [array_width release];
    [array_alignment release];
    [buttonHeight release];
    [buttonWidth release];
    [buttonAlignment release];
    [uiview_block release];
    [buttonBack release];
    [buttonHelp release];
    [buttonPrint release];
    [singleTap release];
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

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [uiview_main addSubview:uiscrollview_main];
        uiscrollview_main.contentSize = uiscrollview_main.frame.size;
        uiscrollview_main.scrollEnabled = YES;
        uiscrollview_main.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }

    uitextview_texttoprint.layer.borderWidth = 1;

    uitextview_texttoprint.delegate = self;
    uitextfield_leftMargin.delegate = self;

    selectedHeight    = 0;
    selectedWidth     = 0;
    selectedAlignment = 0;

    [buttonHeight    setTitle:array_height   [selectedHeight]    forState:UIControlStateNormal];
    [buttonWidth     setTitle:array_width    [selectedWidth]     forState:UIControlStateNormal];
    [buttonAlignment setTitle:array_alignment[selectedAlignment] forState:UIControlStateNormal];
    
    [AppDelegate setButtonArrayAsOldStyle:@[buttonAlignment, buttonBack, buttonHeight, buttonHelp, buttonPrint, buttonWidth]];
    
    //Gesture Recognizer
    singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSingleTap:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.delegate = self;
    [self.view addGestureRecognizer:singleTap];
}

- (void)viewDidUnload
{
    [uiview_block release];
    uiview_block = nil;
    [buttonBack release];
    buttonBack = nil;
    [buttonHelp release];
    buttonHelp = nil;
    [buttonPrint release];
    buttonPrint = nil;
    [singleTap release];
    singleTap = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark TextField

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        uiscrollview_main.contentOffset = CGPointMake(0.0, 200.0);
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    uiscrollview_main.contentOffset = CGPointZero;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"] == YES)
    {
        [uitextfield_leftMargin resignFirstResponder];
        return NO;
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

#pragma mark TextView

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        uiscrollview_main.contentOffset = CGPointMake(0.0, 300.0);
        uiscrollview_main.scrollEnabled = NO;
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    uiscrollview_main.contentOffset = CGPointZero;
    uiscrollview_main.scrollEnabled = YES;
}

- (IBAction)backTextFormating
{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)selectHeight:(id)sender
{
    ActionStringDoneBlock done = ^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue)
    {
        selectedHeight = selectedIndex;

        [buttonHeight setTitle:selectedValue forState:UIControlStateNormal];
    };

    ActionStringCancelBlock cancel = ^(ActionSheetStringPicker *picker)
    {
    };

    [ActionSheetStringPicker showPickerWithTitle:@"Select Height" rows:array_height initialSelection:selectedHeight doneBlock:done cancelBlock:cancel origin:sender];
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

- (IBAction)selectAlignment:(id)sender
{
    ActionStringDoneBlock done = ^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue)
    {
        selectedAlignment = selectedIndex;

        [buttonAlignment setTitle:selectedValue forState:UIControlStateNormal];
    };

    ActionStringCancelBlock cancel = ^(ActionSheetStringPicker *picker)
    {
    };

    [ActionSheetStringPicker showPickerWithTitle:@"Select Alignment" rows:array_alignment initialSelection:selectedAlignment doneBlock:done cancelBlock:cancel origin:sender];
}

- (IBAction)showHelp
{
    NSString *title = @"TEXT FORMATTING";
    NSString *helpText = [AppDelegate HTMLCSS];
    helpText = [helpText stringByAppendingString: @"<UnderlineTitle>Specify / Cancel Slash Zero</UnderlineTitle><br/><br/>\n\
                <Code>ASCII:</Code> <CodeDef>ESC / <StandardItalic>n</StandardItalic></CodeDef><br/>\n\
                <Code>Hex:</Code> <CodeDef>1B 2F <StandardItalic>n</StandardItalic></CodeDef><br/><br/>\n\
                <rightMov>n = 1 or 0 (on or off)</rightMov><br/><br/>\n\
                More info in section 3.8 of the Line Mode Manual<br/><br/>\n\
                <UnderlineTitle>Character Expansion Settings</UnderlineTitle><br/><br/>\n\
                Width Expansion<br/>\n\
                <Code>ASCII:</Code> <CodeDef>ESC W <StandardItalic>n</StandardItalic></CodeDef><br/>\n\
                <Code>Hex:</Code> <CodeDef>1B 57 <StandardItalic>n</StandardItalic></CodeDef><br/><br/>\n\
                Height Expansion<br/>\n\
                <Code>ASCII:</Code> <CodeDef>ESC h <StandardItalic>n</StandardItalic></CodeDef><br/>\n\
                <Code>Hex:</Code> <CodeDef>1B 68 <StandardItalic>n</StandardItalic></CodeDef><br/><br/>\n\
                <rightMov>n = 0 through 5 (Multiplier)</rightMov><br/><br/>\n\
                More info in section 3.3.2. of the Line Mode Manual.<br/><br/>\n\
                <UnderlineTitle>Emphasized Printing (Bold)</UnderlineTitle><br/><br/>\n\
                Start Bold Text<br/>\n\
                <Code>ASCII:</Code> <CodeDef>ESC E\n</CodeDef><br/>\n\
                <Code>Hex:</Code> <CodeDef>1B 45\n</CodeDef><br/><br/>\n\
                Stop Bold Text<br/>\n\
                <Code>ASCII:</Code> <CodeDef>ESC F</CodeDef><br/>\n\
                <Code>Hex:</Code> <CodeDef>1B 46</CodeDef><br/><br/>\n\
                More info in section 3.3.3 of the Line Mode Manual<br/><br/>\n\
                <UnderlineTitle>Underline Mode</UnderlineTitle><br/><br/>\n\
                <Code>ASCII:</Code> <CodeDef>ESC - <StandardItalic>n</StandardItalic></CodeDef><br/>\n\
                <Code>Hex:</Code> <CodeDef>1B 2D <StandardItalic>n</StandardItalic></CodeDef><br/><br/>\n\
                <rightMov>n = 1 or 0 (on or off)</rightMov><br/><br/>\n\
                <UnderlineTitle>Upperline Mode</UnderlineTitle><br/><br/>\n\
                <Code>ASCII:</Code> <CodeDef>ESC _ <StandardItalic>n</StandardItalic></CodeDef><br/>\n\
                <Code>Hex:</Code> <CodeDef>1B 5F <StandardItalic>n</StandardItalic></CodeDef><br/><br/>\n\
                <rightMov>n = 1 or 0 (on or off)</rightMov><br/><br/>\n\
                <UnderlineTitle>White/Black Inverted Color Mode</UnderlineTitle><br/><br/>\n\
                Start B/W Invert<br/>\
                <Code>ASCII:</Code> <CodeDef>ESC 4</CodeDef><br/>\n\
                <Code>Hex:</Code> <CodeDef>1B 34</CodeDef><br/><br/>\n\
                Stop B/W Invert<br/>\n\
                <Code>ASCII:</Code> <CodeDef>ESC 5</CodeDef><br/>\n\
                <Code>Hex:</Code> <CodeDef>1b 35</CodeDef><br/><br/>\n\
                <UnderlineTitle>Upside-Down Printing</UnderlineTitle><br/><br/>\n\
                Start B/W Invert<br/>\n\
                <Code>ASCII:</Code> <CodeDef>SI</CodeDef><br/>\n\
                <Code>Hex:</Code> <CodeDef>0F</CodeDef><br/><br/>\n\
                Stop B/W Invert<br/>\n\
                <Code>ASCII:</Code> <CodeDef>DC2</CodeDef><br/>\n\
                <Code>Hex:</Code> <CodeDef>12</CodeDef><br/><br/>\n\
                Note: When using the command, only use it at the start of a new line. Rightside-up and Upside-Down text cannot be on the same line.<br/><br/>\
                <UnderlineTitle>Set Left Margin</UnderlineTitle><br/><br/>\n\
                <Code>ASCII:</Code> <CodeDef>ESC l <StandardItalic>n</StandardItalic></CodeDef><br/>\n\
                <Code>Hex:</Code> <CodeDef>1B 6C <StandardItalic>n</StandardItalic></CodeDef><br/><br/>\n\
                <rightMov>n = 0 through 255</rightMov><br/><br/>\n\
                More info in section 3.3.6 of the Line Model Manual.<br/><br/>\n\
                <UnderlineTitle>Set Text Alignment</UnderlineTitle><br/><br/>\n\
                <Code>ASCII:</Code> <CodeDef>ESC GS a <StandardItalic>n</StandardItalic></CodeDef><br/>\
                <Code>Hex:</Code> <CodeDef>1B 1D 61 <StandardItalic>n</StandardItalic></CodeDef><br/><br/>\
                <rightMov>n = 0 (left) or 1 (center) or 2 (right)</rightMov>\
                </body></html>\
                "];
    
    StandardHelp *helpVar = [[StandardHelp alloc]initWithNibName:@"StandardHelp" bundle:[NSBundle mainBundle]];
    [self presentModalViewController:helpVar animated:YES];
    [helpVar setHelpTitle:title];
    [helpVar setHelpText:helpText];

    [helpVar release];
}

- (IBAction)PrintText
{
    if (blocking == YES) {
        return;
    }
    blocking = YES;

    NSString *portName = [AppDelegate getPortName];
    NSString *portSettings = [AppDelegate getPortSettings];

    bool slashedZero = [uiswitch_slashedZero isOn];
    bool underline   = [uiswitch_underline   isOn];
    bool invertColor = [uiswitch_invertcolor isOn];
    bool emphasized  = [uiswitch_emphasized  isOn];
    bool upperline   = [uiswitch_upperline   isOn];
    bool upsideDown  = [uiswitch_upsizeDown  isOn];

    int height = (int)selectedHeight;
    int width  = (int)selectedWidth;

    Alignment alignment = (Alignment)selectedAlignment;

    int leftMargin = [uitextfield_leftMargin.text intValue];

    NSData *textNSData = [uitextview_texttoprint.text dataUsingEncoding:NSWindowsCP1252StringEncoding];

    unsigned char *textData = (unsigned char *)malloc([textNSData length]);
    [textNSData getBytes:textData];

    [PrinterFunctions PrintTextWithPortname:portName portSettings:portSettings slashedZero:slashedZero underline:underline invertColor:invertColor emphasized:emphasized upperline:upperline upsideDown:upsideDown heightExpansion:height widthExpansion:width leftMargin:leftMargin alignment:alignment textData:textData textDataSize:(unsigned int)[textNSData length]];

    free(textData);
    
    blocking = NO;
}

#pragma mark Gesture Recognizer

- (void)onSingleTap:(UITapGestureRecognizer *)recognizer
{
    [self.view endEditing:YES];
}

-(BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (gestureRecognizer == singleTap) {
        if ((uitextview_texttoprint.isFirstResponder) ||
            (uitextfield_leftMargin.isFirstResponder)) {
            return YES;
        } else {
            return NO;
        }
    }
    return YES;
}
@end
