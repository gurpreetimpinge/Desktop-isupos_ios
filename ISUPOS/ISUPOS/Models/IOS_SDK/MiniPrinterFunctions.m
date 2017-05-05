//
//  MiniPrinterFunctions.m
//  IOS_SDK
//
//  Created by Tzvi on 8/2/11.
//  Copyright 2011 - 2013 STAR MICRONICS CO., LTD. All rights reserved.
//

#import "MiniPrinterFunctions.h"
#import "StarBitmap.h"
#import <sys/time.h>
#import "AppDelegate.h"
#import "Language.h"
#import <StarIO_Extension/StarIoExt.h>

@implementation MiniPrinterFunctions
/*!
 *  This function shows the printer firmware information
 *
 *  @param  portName        Port name to use for communication
 *  @param  portSettings    The port settings to use
 */
+ (void)showFirmwareInformation:(NSString *)portName portSettings:(NSString *)portSettings {
    SMPort *starPort = nil;
    NSDictionary *dict = nil;
    
    @try {
        starPort = [SMPort getPort:portName :portSettings :10000];
        if (starPort == nil) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[Language get:@"Fail to Open Port" alter:@"!Fail to Open Port"]
                                                            message:@""
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
           // [alert show];
            [alert release];
            return;
        }
        
        NSMutableString *message = [NSMutableString string];
        dict = [[starPort getFirmwareInformation] retain];
        for (id key in dict.keyEnumerator) {
            [message appendFormat:@"%@: %@\n", key, dict[key]];
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[Language get:@"Firmware" alter:@"!Firmware"] message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        [alert release];
    }
    @catch (PortException *exception) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[Language get:@"Printer Error" alter:@"!Printer Error"]
                                                        message:[Language get:@"Get firmware information failed" alter:@"!Get firmware information failed"]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    @finally {
        [SMPort releasePort:starPort];
        [dict release];
    }
}


/**
 * This function is not usable, the cash drawer is not supported by portable printers
 * portName - Port name to use for communication
 * portSettings - The port settings to use
 */
+ (void)OpenCashDrawerWithPortname:(NSString *)portName portSettings:(NSString *)portSettings
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[Language get:@"Unsupported" alter:@"!Unsupported"]
                                                    message:[Language get:@"Cash Drawer is unsupported by portable printers" alter:@"!Cash Drawer is unsupported by portable printers"]
                                                   delegate:nil 
                                          cancelButtonTitle:@"OK" 
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

/**
 * This function checks the status of the printer.
 * The check status function can be used for both portable and non portable printers.
 * portName - Port name to use for communication. This should be (TCP:<IPAddress>)
 * portSettings - Should be blank
 */

+ (void)CheckStatusWithPortname:(NSString *)portName portSettings:(NSString *)portSettings sensorSetting:(SensorActive)sensorActiveSetting
{
    
    [[NSUserDefaults standardUserDefaults] setObject:@"Offline" forKey:@"PrinterStatus"];
    
    SMPort *starPort = nil;
    @try
    {
        starPort = [SMPort getPort:portName :portSettings :10000];
        if (starPort == nil)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[Language get:@"Fail to Open Port" alter:@"!Fail to Open Port"]
                                                            message:@""
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            // [alert show];
            [alert release];
            return;
        }
        usleep(1000 * 1000);
        
        StarPrinterStatus_2 status;
        [starPort getParsedStatus:&status :2];
        
        NSString *message = @"";
        if (status.offline == SM_TRUE)
        {
            [[NSUserDefaults standardUserDefaults] setObject:@"Offline" forKey:@"PrinterStatus"];
            
            message = @"The printer is offline";
            if (status.coverOpen == SM_TRUE)
            {
                message = [message stringByAppendingString:@"\nCover is Open"];
            }
            else if (status.receiptPaperEmpty == SM_TRUE)
            {
                message = [message stringByAppendingString:@"\nOut of Paper"];
            }
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] setObject:@"Online" forKey:@"PrinterStatus"];
            message = @"The Printer is online";
            
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[Language get:@"Printer Status" alter:@"!Printer Status"]
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        //        [alert show];
        [alert release];
        return;
    }
    @catch (PortException *exception)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[Language get:@"Printer Error" alter:@"!Printer Error"]
                                                        message:[Language get:@"Get status failed" alter:@"!Get status failed"]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        
        [[NSUserDefaults standardUserDefaults] setObject:@"Offline" forKey:@"PrinterStatus"];
        
        
        //        [alert show];
        [alert release];
    }
    @finally
    {
        [SMPort releasePort:starPort];
    }
}

/**
 * This function is used to print any of the bar codes supported by the portable printer
 * This example supports 4 bar code types code39, code93, ITF, code128.  For a complete list of supported bar codes see manual (pg 35).
 * portName - Port name to use for communication. This should be (TCP:<IPAdd ress>) or "BT:PRNT Star".

 * portSettings - Should be mini, the port settings mini is used for portable printers
 * height - The height of the bar code, max is 255
 * width - Sets the width of the bar code, value of this should be 1 to 8. See pg 34 of the manual for the definitions of the values.
 * type - The type of bar code to print.  This program supports code39, code93, ITF, code128.
 * barcodeData - The data to print.  The type of characters supported varies.  See pg 35 for a complete list of all support characters
 * barcodeDataSize - The size of the barcodeData array.  This is the size of the preceding parameter 
 */
+ (void)PrintBarcodeWithPortname:(NSString*)portName portSettings:(NSString*)portSettings height:(unsigned char)height width:(BarcodeWidth)width barcodeType:(BarcodeType)type barcodeData:(unsigned char*)barcodeData barcodeDataSize:(unsigned int)barcodeDataSize
{
    NSMutableData *commands = [[NSMutableData alloc] init];
    
    unsigned char hri_Commands[] = {0x1d, 0x48, 0x01};
    
    [commands appendBytes:hri_Commands length:3];
    
    unsigned char height_Commands[] = {0x1d, 0x68, 0x00};
    height_Commands[2] = height;
    
    [commands appendBytes:height_Commands length:3];
    
    unsigned char width_Commands[] = {0x1d, 0x77, 0x00};
    switch (width)
    {
        case BarcodeWidth_125:
            width_Commands[2] = 1;
            break;
        case BarcodeWidth_250:
            width_Commands[2] = 2;
            break;
        case BarcodeWidth_375:
            width_Commands[2] = 3;
            break;
        case BarcodeWidth_500:
            width_Commands[2] = 4;
            break;
        case BarcodeWidth_625:
            width_Commands[2] = 5;
            break;
        case BarcodeWidth_750:
            width_Commands[2] = 6;
            break;
        case BarcodeWidth_875:
            width_Commands[2] = 7;
            break;
        case BarcodeWidth_1_0:
            width_Commands[2] = 8;
            break;
    }
    [commands appendBytes:width_Commands length:3];
    
    unsigned char *print_Barcode = (unsigned char*)malloc(4 + barcodeDataSize);
    print_Barcode[0] = 0x1d;
    print_Barcode[1] = 0x6b;
    switch (type)
    {
        case BarcodeType_code39:
            print_Barcode[2] = 69;
            break;
        case BarcodeType_ITF:
            print_Barcode[2] = 70;
            break;
        case BarcodeType_code93:
            print_Barcode[2] = 72;
            break;
        case BarcodeType_code128:
            print_Barcode[2] = 73;
            break;
    }
    print_Barcode[3] = barcodeDataSize;
    memcpy(print_Barcode + 4, barcodeData, barcodeDataSize);
    [commands appendBytes:print_Barcode length:4 + barcodeDataSize];
    free(print_Barcode);
    
    unsigned char fiveLineFeeds[] = {0x0a, 0x0a, 0x0a, 0x0a, 0x0a};
    [commands appendBytes:fiveLineFeeds length:5];
    
    [self sendCommand:commands portName:portName portSettings:portSettings timeoutMillis:10000];
    
    [commands release];
}

/**
 * The function is used to print a qrcode for the portable printer
 * portName - Port name to use for communication. This should be "TCP:<IP Address>" or "BT:PRNT Star"
 * portSettings - Should be mini, the port settings mini is used for portable printers
 * correctionLevel - The correction level for the qrcode.  This value should be 0x4C, 0x4D, 0x51, or 0x48.  See pg 41 for for definition of values 
 * sizeByECLevel - This specifies the symbol version.  This value should be 1 to 40.  See pg 41 for the definition of the level
 * moduleSize - The module size of the qrcode.  This value should be 1 to 8.
 * barcodeData - The characters to print in the qrcode
 * barcodeDataSize - The number of character to print in the qrcode.  This is the size of the preceding parameter.
 */
+ (void)PrintQrcodePortname:(NSString*)portName
               portSettings:(NSString*)portSettings
      correctionLevelOption:(CorrectionLevelOption)correctionLevel
                    ECLevel:(unsigned char)sizeByECLevel
                 moduleSize:(unsigned char)moduleSize
                barcodeData:(unsigned char *)barcodeData
            barcodeDataSize:(unsigned int)barCodeDataSize
{
    NSMutableData *commands = [[NSMutableData alloc] init];
    
    unsigned char initial[] = {0x1b, 0x40};
    [commands appendBytes:initial length:2];
    
    unsigned char selectedBarcodeType[] = {0x1d, 0x5a, 0x02};
    [commands appendBytes:selectedBarcodeType length:3];
    
    unsigned char *print2dbarcode = (unsigned char*)malloc(7 + barCodeDataSize);
    print2dbarcode[0] = 0x1b;
    print2dbarcode[1] = 0x5a;
    print2dbarcode[2] = sizeByECLevel;
    switch (correctionLevel)
    {
        case Low:
            print2dbarcode[3] = 'L';
            break;
        case Middle:
            print2dbarcode[3] = 'M';
            break;
        case Q:
            print2dbarcode[3] = 'Q';
            break;
        case High:
            print2dbarcode[3] = 'H';
            break;
    }
    print2dbarcode[4] = moduleSize;
    print2dbarcode[5] = barCodeDataSize % 256;
    print2dbarcode[6] = barCodeDataSize / 256;
    memcpy(print2dbarcode + 7, barcodeData, barCodeDataSize);
    [commands appendBytes:print2dbarcode length:7 + barCodeDataSize];
    free(print2dbarcode);
    
    unsigned char LF4[] = {0x0a, 0x0a, 0x0a, 0x0a};
    [commands appendBytes:LF4 length:4];
    
    [self sendCommand:commands portName:portName portSettings:portSettings timeoutMillis:10000];

    [commands release];
}

/**
 * This function prints pdf417 bar codes for portable printers
 * portName - Port name to use for communication. This should be "TCP:<IPAddress>" or "BT:PRNT Star".
 * portSettings - Should be mini, the port settings mini is used for portable printers
 * width - This is the width of the pdf417 to print.  This is the same width used by the 1d bar codes.  See pg 34 of the command manual.
 * columnNumber - This is the column number of the pdf417.  The value of this should be between 1 and 30.
 * securityLevel - The represents how well the bar code can be restored of damaged.  The value should be between 0 and 8.
 * ratio - The value representing the horizontal and vertical ratio of the bar code.  This value should between 2 and 5.
 * barcodeData - The characters that will be in the bar code
 * barcodeDataSize - This is the number of characters that will be in the pdf417 code.  This is the size of the preceding parameter
 */
+ (void)PrintPDF417WithPortname:(NSString*)portName portSettings:(NSString*)portSettings width: (BarcodeWidth)width columnNumber:(unsigned char)columnNumber securityLevel:(unsigned char)securityLevel ratio:(unsigned char)ratio barcodeData:(unsigned char *)barcodeData barcodeDataSize: (unsigned char)barcodeDataSize
{
    NSMutableData *commands = [[NSMutableData alloc] init];
    
    unsigned char initial[] = {0x1b, 0x40};
    [commands appendBytes:initial length:2];
    
    unsigned char barcodeWidthCommand[] = {0x1d, 'w', 0x00};
    switch (width)
    {
        case BarcodeWidth_125:
            barcodeWidthCommand[2] = 1;
            break;
        case BarcodeWidth_250:
            barcodeWidthCommand[2] = 2;
            break;
        case BarcodeWidth_375:
            barcodeWidthCommand[2] = 3;
            break;
        case BarcodeWidth_500:
            barcodeWidthCommand[2] = 4;
            break;
        case BarcodeWidth_625:
            barcodeWidthCommand[2] = 5;
            break;
        case BarcodeWidth_750:
            barcodeWidthCommand[2] = 6;
            break;
        case BarcodeWidth_875:
            barcodeWidthCommand[2] = 7;
            break;
        case BarcodeWidth_1_0:
            barcodeWidthCommand[2] = 8;
            break;
    }
    [commands appendBytes:barcodeWidthCommand length:3];
    
    unsigned char setBarcodePDF[] = {0x1d, 0x5a, 0x00};
    [commands appendBytes:setBarcodePDF length:3];
    
    unsigned char *barcodeCommand = (unsigned char*)malloc(7 + barcodeDataSize);
    barcodeCommand[0] = 0x1b;
    barcodeCommand[1] = 0x5a;
    barcodeCommand[2] = columnNumber;
    barcodeCommand[3] = securityLevel;
    barcodeCommand[4] = ratio;
    barcodeCommand[5] = barcodeDataSize % 256;
    barcodeCommand[6] = barcodeDataSize / 256;
    memcpy(barcodeCommand + 7, barcodeData, barcodeDataSize);
    
    [commands appendBytes:barcodeCommand length:7 + barcodeDataSize];
    free(barcodeCommand);
    
    unsigned char LF4[] = {10, 10, 10, 10};
    [commands appendBytes:LF4 length:4];
    
    [self sendCommand:commands portName:portName portSettings:portSettings timeoutMillis:10000];
    
    [commands release];
}

/**
 * This function is used to print a uiimage directly to a portable printer.
 * portName - Port name to use for communication. This should be "TCP:<IP Address>" or "BT:PRNT Star".
 * portSettings - Should be mini, the port settings mini is used for portable printers
 * source - the uiimage to convert to star printer data for portable printers
 * maxWidth - the maximum with the image to print.  This is usually the page with of the printer.  If the image exceeds the maximum width then the image is scaled down.  The ratio is maintained. 
 */
+ (void)PrintBitmapWithPortName:(NSString*)portName portSettings:(NSString*)portSettings imageSource:(UIImage*)source printerWidth:(int)maxWidth compressionEnable:(BOOL)compressionEnable pageModeEnable:(BOOL)pageModeEnable
{
    StarBitmap *starbitmap = [[StarBitmap alloc] initWithUIImage:source :maxWidth :false];
    NSData *commands = [[starbitmap getImageMiniDataForPrinting:compressionEnable pageModeEnable:pageModeEnable] retain];
    
    [self sendCommand:commands portName:portName portSettings:portSettings timeoutMillis:30000];

    [commands release];
    [starbitmap release];
}

+ (void)sendCommand:(NSData *)commands portName:(NSString *)portName portSettings:(NSString *)portSettings timeoutMillis:(u_int32_t)timeoutMillis
{
    unsigned char *commandsToSendToPrinter = (unsigned char*)malloc(commands.length);
    [commands getBytes:commandsToSendToPrinter];
    int commandSize = (int)[commands length];
    
    SMPort *starPort = nil;
    @try
    {
        starPort = [SMPort getPort:portName :portSettings :timeoutMillis];
        if (starPort == nil)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[Language get:@"Fail to Open Port" alter:@"!Fail to Open Port"]
                                                            message:@""
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
           // [alert show];
            [alert release];
            return;
        }

        struct timeval endTime;
        gettimeofday(&endTime, NULL);
        endTime.tv_sec += 60;
        
        StarPrinterStatus_2 status;
        [starPort beginCheckedBlock:&status :2];
            
        if (status.offline == SM_TRUE)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[Language get:@"Error" alter:@"!Error"]
                                                            message:[Language get:@"Printer is offline" alter:@"!Printer is offline"]
                                                           delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alert show];
            [alert release];
            return;
        }
        
        int totalAmountWritten = 0;
        while (totalAmountWritten < commandSize)
        {
            int remaining = commandSize - totalAmountWritten;
            
            int amountWritten = [starPort writePort:commandsToSendToPrinter :totalAmountWritten :remaining];
            totalAmountWritten += amountWritten;
            
            struct timeval now;
            gettimeofday(&now, NULL);
            if (now.tv_sec > endTime.tv_sec)
            {
                break;
            }
        }
        
        //SM-T300(Wi-Fi): To use endCheckedBlock method, require F/W 2.4 or later.
        starPort.endCheckedBlockTimeoutMillis = 40000;
        [starPort endCheckedBlock:&status :2];
        if (status.offline == SM_TRUE)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[Language get:@"Error" alter:@"!Error"]
                                                            message:[Language get:@"An error has occurred during printing." alter:@"!An error has occurred during printing."]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
            return;
        }
        
        if (totalAmountWritten < commandSize)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[Language get:@"Printer Error" alter:@"!Printer Error"]
                                                            message:[Language get:@"Write port timed out" alter:@"!Write port timed out"]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
    }
    @catch (PortException *exception)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[Language get:@"Printer Error" alter:@"!Printer Error"]
                                                        message:[Language get:@"Write port timed out" alter:@"!Write port timed out"]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    @finally
    {
        [SMPort releasePort:starPort];
        free(commandsToSendToPrinter);
    }
}

/**
 * This function prints raw text to the portable printer.  It show how the text can be formated.  For example changing its size.
 * portName - Port name to use for communication. This should be "TCP:<IP Address>" or "BT:PRNT Star".
 * portSettings - Should be mini, the port settings mini is used for portable printers
 * underline - boolean variable that Tells the printer if should underline the text
 * emphasized - boolean variable that tells the printer if it should emphasize the printed text.  This is sort of like bold but not as dark, but darker then regular characters.
 * upsideDown - boolean variable that tells the printer if the text should be printed upside-down
 * invertColor - boolean variable that tells the printer if it should invert the text its printing.  All White space will become black and the characters will be left white
 * heightExpansion - This integer tells the printer what multiple the character height should be, this should be from 0 to 7 representing multiples from 1 to 8
 * widthExpansion - This integer tell the printer what multiple the character width should be, this should be from 0 to 7 representing multiples from 1 to 8
 * eftMargin - The left margin for text on the portable printer.  This number should be be from 0 to 65536 but it should never get that high or the text can be pushed off the page.
 * alignment - The alignment of the text. The printers support left, right, and center justification
 * textToPrint - The text to send to the printer
 * textToPrintSize - The amount of text to send to the printer.  This should be the size of the preceding parameter
 */
+ (void)PrintText:(NSString*)portName PortSettings:(NSString*)portSettings Underline:(bool)underline Emphasized:(bool)emphasized Upsideddown:(bool)upsideddown InvertColor:(bool)invertColor HeightExpansion:(unsigned char)heightExpansion WidthExpansion:(unsigned char)widthExpansion LeftMargin:(int)leftMargin Alignment:(Alignment)alignment TextToPrint:(unsigned char*)textToPrint TextToPrintSize:(unsigned int)textToPrintSize;
{
    NSMutableData *commands = [[NSMutableData alloc] init];

	unsigned char initial[] = {0x1b, 0x40};
	[commands appendBytes:initial length:2];
		
    unsigned char underlineCommand[] = {0x1b, 0x2d, 0x00};
    if (underline)
    {
        underlineCommand[2] = 49;
    }
    else
    {
        underlineCommand[2] = 48;
    }
    [commands appendBytes:underlineCommand length:3];
    
    unsigned char emphasizedCommand[] = {0x1b, 0x45, 0x00};
    if (emphasized)
    {
        emphasizedCommand[2] = 1;
    }
    else
    {
        emphasizedCommand[2] = 0;
    }
    [commands appendBytes:emphasizedCommand length:3];
    
    unsigned char upsidedownCommand[] = {0x1b, 0x7b, 0x00};
    if (upsideddown)
    {
        upsidedownCommand[2] = 1;
    }
    else
    {
        upsidedownCommand[2] = 0;
    }
    [commands appendBytes:upsidedownCommand length:3];
    
    unsigned char invertColorCommand[] = {0x1d, 0x42, 0x00};
    if (invertColor)
    {
        invertColorCommand[2] = 1;
    }
    else
    {
        invertColorCommand[2] = 0;
    }
    [commands appendBytes:invertColorCommand length:3];
    
    unsigned char characterSizeCommand[] = {0x1d, 0x21, 0x00};
    characterSizeCommand[2] = heightExpansion | (widthExpansion << 4);
    [commands appendBytes:characterSizeCommand length:3];
    
    unsigned char leftMarginCommand[] = {0x1d, 0x4c, 0x00, 0x00};
    leftMarginCommand[2] = leftMargin % 256;
    leftMarginCommand[3] = leftMargin / 256;
    [commands appendBytes:leftMarginCommand length:4];
    
    unsigned char justificationCommand[] = {0x1b, 0x61, 0x00};
    switch (alignment)
    {
        case Left:
            justificationCommand[2] = 48;
            break;
        case Center:
            justificationCommand[2] = 49;
            break;
        case Right:
            justificationCommand[2] = 50;
            break;
    }
    [commands appendBytes:justificationCommand length:3];
    
    [commands appendBytes:textToPrint length:textToPrintSize];
    
    unsigned char LF = 10;
    [commands appendBytes:&LF length:1];
    [commands appendBytes:&LF length:1];
    
    [self sendCommand:commands portName:portName portSettings:portSettings timeoutMillis:10000];

    [commands release];
}

/**
 * This function prints raw text of Japamese Kanji to the portable printer.  It show how the text can be formated.  For example changing its size.
 * portName - Port name to use for communication. This should be "TCP:<IP Address>" or "BT:PRNT Star".
 * portSettings - Should be mini, the port settings mini is used for portable printers
 * underline - boolean variable that Tells the printer if should underline the text
 * emphasized - boolean variable that tells the printer if it should emphasize the printed text.  This is sort of like bold but not as dark, but darker then regular characters.
 * upsideDown - boolean variable that tells the printer if the text should be printed upside-down
 * invertColor - boolean variable that tells the printer if it should invert the text its printing.  All White space will become black and the characters will be left white
 * heightExpansion - This integer tells the printer what multiple the character height should be, this should be from 0 to 7 representing multiples from 1 to 8
 * widthExpansion - This integer tell the printer what multiple the character width should be, this should be from 0 to 7 representing multiples from 1 to 8
 * eftMargin - The left margin for text on the portable printer.  This number should be be from 0 to 65536 but it should never get that high or the text can be pushed off the page.
 * alignment - The alignment of the text. The printers support left, right, and center justification
 * textToPrint - The text to send to the printer
 * textToPrintSize - The amount of text to send to the printer.  This should be the size of the preceding parameter
 */
+ (void)PrintJpKanji:(NSString*)portName PortSettings:(NSString*)portSettings Underline:(bool)underline Emphasized:(bool)emphasized Upsideddown:(bool)upsideddown InvertColor:(bool)invertColor HeightExpansion:(unsigned char)heightExpansion WidthExpansion:(unsigned char)widthExpansion LeftMargin:(int)leftMargin Alignment:(Alignment)alignment TextToPrint:(unsigned char*)textToPrint TextToPrintSize:(unsigned int)textToPrintSize;
{
    NSMutableData *commands = [[NSMutableData alloc] init];
	
	unsigned char initial[] = {0x1b, 0x40};
	[commands appendBytes:initial length:2];
	
	unsigned char kanjiCommand[] = {0x1c, 0x43, 0x01};
	[commands appendBytes:kanjiCommand length:3];
	
    unsigned char underlineCommand[] = {0x1b, 0x2d, 0x00};
    if (underline)
    {
        underlineCommand[2] = 49;
    }
    else
    {
        underlineCommand[2] = 48;
    }
    [commands appendBytes:underlineCommand length:3];
    
    unsigned char emphasizedCommand[] = {0x1b, 0x45, 0x00};
    if (emphasized)
    {
        emphasizedCommand[2] = 1;
    }
    else
    {
        emphasizedCommand[2] = 0;
    }
    [commands appendBytes:emphasizedCommand length:3];
    
    unsigned char upsidedownCommand[] = {0x1b, 0x7b, 0x00};
    if (upsideddown)
    {
        upsidedownCommand[2] = 1;
    }
    else
    {
        upsidedownCommand[2] = 0;
    }
    [commands appendBytes:upsidedownCommand length:3];
    
    unsigned char invertColorCommand[] = {0x1d, 0x42, 0x00};
    if (invertColor)
    {
        invertColorCommand[2] = 1;
    }
    else
    {
        invertColorCommand[2] = 0;
    }
    [commands appendBytes:invertColorCommand length:3];
    
    unsigned char characterSizeCommand[] = {0x1d, 0x21, 0x00};
    characterSizeCommand[2] = heightExpansion | (widthExpansion << 4);
    [commands appendBytes:characterSizeCommand length:3];
    
    unsigned char leftMarginCommand[] = {0x1d, 0x4c, 0x00, 0x00};
    leftMarginCommand[2] = leftMargin % 256;
    leftMarginCommand[3] = leftMargin / 256;
    [commands appendBytes:leftMarginCommand length:4];
    
    unsigned char justificationCommand[] = {0x1b, 0x61, 0x00};
    switch (alignment)
    {
        case Left:
            justificationCommand[2] = 48;
            break;
        case Center:
            justificationCommand[2] = 49;
            break;
        case Right:
            justificationCommand[2] = 50;
            break;
    }
    [commands appendBytes:justificationCommand length:3];
    
    [commands appendBytes:textToPrint length:textToPrintSize];
    
    unsigned char LF = 10;
    [commands appendBytes:&LF length:1];
    [commands appendBytes:&LF length:1];
    
    [self sendCommand:commands portName:portName portSettings:portSettings timeoutMillis:10000];

    [commands release];
}

/**
 * This function shows how to read the MCR data(credit card) of a portable printer.
 * The function first puts the printer into MCR read mode, then asks the user to swipe a credit card
 * This object then acts as a delegate for the uialertview.  See alert veiw responce for seeing how to read the mcr data one a card has been swiped.
 * The user can cancel the MCR mode or the read the printer
 * portName - Port name to use for communication. This should be "TCP:<IP Address>" or "BT:PRNT Star".
 * portSettings - Should be mini, the port settings mini is used for portable printers
 */
- (void)MCRStartWithPortName:(NSString*)portName portSettings:(NSString*)portSettings
{
    starPort = nil;
    @try
    {
        starPort = [SMPort getPort:portName :portSettings :10000];
        if (starPort == nil)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[Language get:@"Fail to Open Port" alter:@"!Fail to Open Port"]
                                                            message:@""
                                                           delegate:nil 
                                                  cancelButtonTitle:@"OK" 
                                                  otherButtonTitles:nil];
          //  [alert show];
            [alert release];
            return;
        }
        
        struct timeval endTime;
        gettimeofday(&endTime, NULL);
        endTime.tv_sec += 30;
        
        unsigned char startMCRCommand[] = {0x1b, 0x4d, 0x45};
        int commandSize = 3;
        
        int totalAmountWritten = 0;
        while (totalAmountWritten < 3)
        {
            int remaining = commandSize - totalAmountWritten;
            
            int blockSize = (remaining > 1024) ? 1024 : remaining;
            
            int amountWritten = [starPort writePort:startMCRCommand :totalAmountWritten :blockSize];
            totalAmountWritten += amountWritten;
            
            struct timeval now;
            gettimeofday(&now, NULL);
            if (now.tv_sec > endTime.tv_sec)
            {
                break;
            }
        }
        
        if (totalAmountWritten < commandSize)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[Language get:@"Printer Error" alter:@"!Printer Error"]
                                                            message:[Language get:@"Write port timed out" alter:@"!Write port timed out"]
                                                           delegate:nil 
                                                  cancelButtonTitle:@"OK" 
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
            [SMPort releasePort:starPort];
            return;
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"MCR" 
                                                            message:[Language get:@"Swipe a credit card" alter:@"!Swipe a credit card"]
                                                           delegate:self 
                                                  cancelButtonTitle:[Language get:@"Cancel" alter:@"!Cancel"]
                                                  otherButtonTitles:@"OK", nil];
            [alert show];
            [alert release];
        }
    }
    @catch (PortException *exception)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[Language get:@"Printer Error" alter:@"!Printer Error"]
                                                        message:[Language get:@"Write port timed out" alter:@"!Write port timed out"]
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK" 
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

/**
 This is the reponce function for reading micr data.
 This will eather cancel the mcr function or read the data
 */
- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        unsigned char endMcrComman = 4;
        int dataWritten = [starPort writePort:&endMcrComman :0 :1];
        if (dataWritten == 0)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[Language get:@"Printer Error" alter:@"!Printer Error"]
                                                            message:[Language get:@"Write port timed out" alter:@"!Write port timed out"]
                                                           delegate:nil 
                                                  cancelButtonTitle:@"OK" 
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
    }
    else
    {
        @try
        {
            unsigned char dataToRead[100];
            
            int readSize = [starPort readPort:dataToRead :0 :100];
            
            NSString *MCRData = nil;
            if (readSize > 0) {
                MCRData = [NSString stringWithFormat:@"%s",dataToRead];
            }
            else {
                MCRData = @"NO DATA";
            }
//          NSMutableString *MCRData = [NSMutableString string];
//
//          int index;
//
//          for (index = 0; index < 16; index++)
//          {
//              if (index < readSize)
//              {
//                  [MCRData appendFormat:@"%02x ", dataToRead[index]];
//              }
//          }
//
//          if (index < readSize)
//          {
//              [MCRData appendFormat:@"..."];
//          }
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[Language get:@"Card Data" alter:@"!Card Data"]
                                                            message:MCRData
                                                           delegate:nil 
                                                  cancelButtonTitle:@"OK" 
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
        @catch (PortException *exception)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[Language get:@"Card Data" alter:@"!Card Data"]
                                                            message:[Language get:@"Failed to read port" alter:@"!Failed to read port"]
                                                           delegate:nil 
                                                  cancelButtonTitle:@"OK" 
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
    }
    
    [SMPort releasePort:starPort];
}

/**
 * This function print the sample receipt
 * portName - Port name to use for communication
 * portSettings - The port settings to use
 * widthInch - printable width (2/3/4 [inch])
 */
+ (void)PrintSampleReceiptWithPortname:(NSString *)portName portSettings:(NSString *)portSettings widthInch:(int)printableWidth
{
    NSData *commands = nil;
    
    switch (printableWidth) {
        case 2:
            if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"ReportRecipt"]isEqualToString:@"Yes"]) {
                
                [[NSUserDefaults standardUserDefaults] setObject:@"No" forKey:@"ReportRecipt"];
                
                
                commands = [[self create2InchXZReceipt] retain];
                
            }
            else if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LogRecipt"]isEqualToString:@"Yes"]) {
                
                [[NSUserDefaults standardUserDefaults] setObject:@"No" forKey:@"LogRecipt"];
                
                
                commands = [[self create_LogPrint_Format] retain];
                
            }
        
            else
            {
                 NSMutableData *combined_receipt_data = [NSMutableData new];
                if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"payment_mode"] isEqualToString:@"Card"]) {
                    
                    // for card payment when customer and merchant receipts are printed
                    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"print_combined_receipt"] isEqualToString:@"YES"]) {
                        [combined_receipt_data appendData:[self create2InchReceipt]];
                        [combined_receipt_data appendData:[self printMerchantReceipt]];
                    
                    }
                    // for card payment when customer receipt sent by mail
                    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"print_merchant_receipt"] isEqualToString:@"YES"] ) {
                        [combined_receipt_data appendData:[self printMerchantReceipt]];
                        
                    }
                    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"print_customer_receipt"] isEqualToString:@"YES"]) {
                        [combined_receipt_data appendData:[self create2InchReceipt]];
                        
                    }

                }
                else if([[[NSUserDefaults standardUserDefaults] valueForKey:@"payment_mode"] isEqualToString:@"Cash"]){
                    // for cash payment
                    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"print_customer_receipt"] isEqualToString:@"YES"]) {
                        [combined_receipt_data appendData:[self create2InchReceipt]];
                        
                    }
                }

                commands = combined_receipt_data;
              
            }
            break;
            
        case 3:
            commands = [[self create3InchReceipt] retain];
            break;
            
        case 4:
            commands = [[self create4InchReceipt] retain];
            break;
            
        default:
            return;
    }
    
    [self sendCommand:commands portName:portName portSettings:portSettings timeoutMillis:10000];
    
    [commands release];
}

/**
 * This function create the sample receipt data (2inch)
 */

#pragma mark Receipt format

+ (NSData *)create2InchReceipt
{
  
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    NSString *currencySign=@"";


    if ([[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:0] valueForKey:@"currency"]) {
        
    currencySign=[[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:0] valueForKey:@"currency"];
    
    }
    
    
    NSString *str_cur;
    
    if ([currencySign isEqualToString:@"$"]) {
        
        str_cur=@"$";
        
    }else if ([currencySign isEqualToString:@"€"]) {
        
        char utf8[]  = "\xE2\x82\xac";

//        str_cur=[[NSString alloc] initWithBytes:utf8 length:3 encoding:NSUTF8StringEncoding];
        
//        str_cur=@"\xE2\x82\xac";
        str_cur=@"\u20ac";
        
        
        
    } else if ([currencySign isEqualToString:@"SEK"]) {
        
        str_cur=@"SEK";
    }
    else
    {
        str_cur=@"$";
    }

    
    char utf8[]  = "\xE2\x82\xac";
    char utf16[] = "\x20\xAC";
    NSLog(@"utf8:  %@", [[NSString alloc] initWithBytes:utf8 length:3 encoding:NSUTF8StringEncoding]);
    NSLog(@"utf16: %@", [[NSString alloc] initWithBytes:utf16 length:2 encoding:NSUTF16BigEndianStringEncoding]);
    
    NSString *cost = @"156.95 \xE2\x82\xac\r\n"; // dataUsingEncoding:NSUTF8StringEncoding]];

    
    NSMutableData *commandsw = [NSMutableData new];
    [commandsw appendData:[@"156.95 \xE2\x82\xac\r\n" dataUsingEncoding:NSUTF8StringEncoding]];

    NSManagedObjectContext *context =[appDelegate managedObjectContext];
    NSEntityDescription *entityDesc =[NSEntityDescription entityForName:@"ReceiptData" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    NSPredicate *pred =[NSPredicate predicateWithFormat:@"(id = %@)",@"1"];
    [request setPredicate:pred];
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request error:&error];
    //    NSManagedObject *person = (NSManagedObject *)[objects objectAtIndex:0];
    
    //get card payment receipts data from database //receipt_id
    
    
//    NSManagedObject *refundAmound;
//    refundAmound = [NSEntityDescription insertNewObjectForEntityForName:@"RefundAmount" inManagedObjectContext:context];
//    [request setEntity:entityDesc];
//    pred =[NSPredicate predicateWithFormat:@"id =%@",[[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:0] valueForKey:@"id"]];
//    [request setPredicate:pred];
//    NSArray *ary_RefundAmount = [context executeFetchRequest:request error:&error];
    
    
    entityDesc =[NSEntityDescription entityForName:@"Recepit_CardPayment" inManagedObjectContext:context];
    [request setEntity:entityDesc];
    pred =[NSPredicate predicateWithFormat:@"receipt_id =%@",[[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:0] valueForKey:@"id"]];
    [request setPredicate:pred];
    NSArray *card_payment_receipts = [context executeFetchRequest:request error:&error];
    
    NSMutableDictionary *dictHeaderFooter = [NSMutableDictionary new];
    
    
    if (objects.count == 0)
    {
        [dictHeaderFooter setValue:@"" forKey:@"organization_name"];
        [dictHeaderFooter setValue:@"" forKey:@"company_name"];
        [dictHeaderFooter setValue:@"" forKey:@"address1"];
        [dictHeaderFooter setValue:@"" forKey:@"address2"];
        [dictHeaderFooter setValue:@"" forKey:@"zipcode"];
        [dictHeaderFooter setValue:@"" forKey:@"city"];
        [dictHeaderFooter setValue:@"" forKey:@"phone"];
        [dictHeaderFooter setValue:@"" forKey:@"fax"];
        [dictHeaderFooter setValue:@"" forKey:@"homepage"];
        
        [dictHeaderFooter setValue:@"" forKey:@"row1"];
        [dictHeaderFooter setValue:@"" forKey:@"row2"];
        [dictHeaderFooter setValue:@"" forKey:@"row3"];
        [dictHeaderFooter setValue:@"" forKey:@"row4"];
        [dictHeaderFooter setValue:@"" forKey:@"row5"];
        [dictHeaderFooter setValue:@"" forKey:@"row6"];
        [dictHeaderFooter setValue:@"" forKey:@"row7"];
        [dictHeaderFooter setValue:@"" forKey:@"row8"];
        [dictHeaderFooter setValue:@"" forKey:@"row9"];
        [dictHeaderFooter setValue:@"" forKey:@"row10"];
    }
    else
    {
        for(int i=0;i<objects.count;i++)
        {
            NSManagedObject *person = (NSManagedObject *)[objects objectAtIndex:i];
            
            [dictHeaderFooter setValue:[person valueForKey:@"organization_name"] forKey:@"organization_name"];
            [dictHeaderFooter setValue:[person valueForKey:@"company_name"] forKey:@"company_name"];
            [dictHeaderFooter setValue:[person valueForKey:@"address1"] forKey:@"address1"];
            [dictHeaderFooter setValue:[person valueForKey:@"address2"] forKey:@"address2"];
            [dictHeaderFooter setValue:[person valueForKey:@"zipcode"] forKey:@"zipcode"];
            [dictHeaderFooter setValue:[person valueForKey:@"city"] forKey:@"city"];
            [dictHeaderFooter setValue:[person valueForKey:@"phone"] forKey:@"phone"];
            [dictHeaderFooter setValue:[person valueForKey:@"fax"] forKey:@"fax"];
            [dictHeaderFooter setValue:[person valueForKey:@"homepage"] forKey:@"homepage"];
            
            
            if ([self validateDictionaryValueForKey:[person valueForKey:@"row1"]]) {
                [dictHeaderFooter setValue:[person valueForKey:@"row1"] forKey:@"row1"];
                
            }
            if ([self validateDictionaryValueForKey:[person valueForKey:@"row2"]]) {
                [dictHeaderFooter setValue:[person valueForKey:@"row2"] forKey:@"row2"];
            }
            if ([self validateDictionaryValueForKey:[person valueForKey:@"row3"]]) {
                [dictHeaderFooter setValue:[person valueForKey:@"row3"] forKey:@"row3"];
            }
            if ([self validateDictionaryValueForKey:[person valueForKey:@"row4"]]) {
                [dictHeaderFooter setValue:[person valueForKey:@"row4"] forKey:@"row4"];
            }
            if ([self validateDictionaryValueForKey:[person valueForKey:@"row5"]]) {
                [dictHeaderFooter setValue:[person valueForKey:@"row5"] forKey:@"row5"];
            }
            if ([self validateDictionaryValueForKey:[person valueForKey:@"row6"]]) {
                [dictHeaderFooter setValue:[person valueForKey:@"row6"] forKey:@"row6"];
            }
            
            if ([self validateDictionaryValueForKey:[person valueForKey:@"row7"]]) {
                [dictHeaderFooter setValue:[person valueForKey:@"row7"] forKey:@"row7"];
            }
            if ([self validateDictionaryValueForKey:[person valueForKey:@"row8"]]) {
                [dictHeaderFooter setValue:[person valueForKey:@"row8"] forKey:@"row8"];
            }
            if ([self validateDictionaryValueForKey:[person valueForKey:@"row9"]]) {
                [dictHeaderFooter setValue:[person valueForKey:@"row9"] forKey:@"row9"];
            }
            if ([self validateDictionaryValueForKey:[person valueForKey:@"row10"]]) {
                [dictHeaderFooter setValue:[person valueForKey:@"row10"] forKey:@"row10"];
            }
            
        }
       
    }
    
    BOOL card_details_available = NO;
    if([[[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:0] valueForKey:@"paymentMethod"] isEqualToString:@"2"] ){
        for (int i=0; i<card_payment_receipts.count; i++) {
            NSManagedObject *receiptDetails = (NSManagedObject*)[card_payment_receipts objectAtIndex:i];
            if (receiptDetails !=nil) {
                card_details_available = YES;
            [dictHeaderFooter setValue:[receiptDetails  valueForKey:@"merchant_name"] forKey:@"merchant_name"];
            [dictHeaderFooter setValue:[receiptDetails valueForKey:@"merchant_address"] forKey:@"merchant_address"];
            [dictHeaderFooter setValue:[receiptDetails valueForKey:@"merchant_zipcode"] forKey:@"merchant_zipcode"];
            [dictHeaderFooter setValue:[receiptDetails  valueForKey:@"merchant_city"] forKey:@"merchant_city"];
            [dictHeaderFooter setValue:[receiptDetails  valueForKey:@"merchant_country"] forKey:@"merchant_country"];
            [dictHeaderFooter setValue:[receiptDetails  valueForKey:@"merchant_contact"] forKey:@"merchant_contact"];
            [dictHeaderFooter setValue:[receiptDetails  valueForKey:@"receipt_amount"] forKey:@"receipt_amount"];
            [dictHeaderFooter setValue:[receiptDetails  valueForKey:@"receipt_date"] forKey:@"receipt_date"];
            [dictHeaderFooter setValue:[receiptDetails  valueForKey:@"receipt_time"] forKey:@"receipt_time"];
            [dictHeaderFooter setValue:[receiptDetails  valueForKey:@"receipt_card"] forKey:@"receipt_card"];
            [dictHeaderFooter setValue:[receiptDetails  valueForKey:@"receipt_account"] forKey:@"receipt_account"];
            [dictHeaderFooter setValue:[receiptDetails  valueForKey:@"receipt_aid"] forKey:@"receipt_aid"];
            
            [dictHeaderFooter setValue:[receiptDetails  valueForKey:@"receipt_entry_mode"] forKey:@"receipt_entry_mode"];
            [dictHeaderFooter setValue:[receiptDetails valueForKey:@"receipt_transaction_id"] forKey:@"receipt_transaction_id"];
            [dictHeaderFooter setValue:[receiptDetails valueForKey:@"receipt_authorization_id"] forKey:@"receipt_authorization_id"];
            [dictHeaderFooter setValue:[receiptDetails  valueForKey:@"merchant_id"] forKey:@"merchant_id"];
            [dictHeaderFooter setValue:[receiptDetails  valueForKey:@"receipt_terminal_id"] forKey:@"receipt_terminal_id"];
            [dictHeaderFooter setValue:[receiptDetails  valueForKey:@"receipt_pwid"] forKey:@"receipt_pwid"];
            [dictHeaderFooter setValue:[receiptDetails valueForKey:@"receipt_transaction_reference_number"] forKey:@"receipt_transaction_reference_number"];
            }
            else{
                card_details_available = NO;
            }
        }
    }
    
    NSMutableData *commands = [[NSMutableData new] autorelease];
    
    [commands appendBytes:"\x1d\x57\x80\x31"
                   length:sizeof("\x1d\x57\x80\x31") - 1];    // Page Area Setting     <GS> <W> nL nH  (nL = 128, nH = 1)
    
    [commands appendBytes:"\x1b\x61\x01"
                   length:sizeof("\x1b\x61\x01") - 1];    // Center Justification  <ESC> a n       (0 Left, 1 Center, 2 Right)
    
    NSString *str_emailFormat;
    
    if ([@"Original" isEqualToString:[[NSUserDefaults standardUserDefaults]valueForKey:@"ReciptType"]]) {
        
        
        str_emailFormat  =[NSString stringWithFormat:@"%@\n", [Language get:@"Original" alter:@"!Original"]];
        
    }
    else
    {
        str_emailFormat  =[NSString stringWithFormat:@"%@\n", [Language get:@"Copy" alter:@"!Copy"]];
    }
    
    NSString *str_emailReceiptNo;
    
    str_emailReceiptNo =  [NSString stringWithFormat:@"%@: #%@\n",[Language get:@"Receipt No" alter:@"!Receipt No"],[[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:0] valueForKey:@"id"]];
    
    
    NSData *datastr_emailFormat = [str_emailFormat dataUsingEncoding:NSWindowsCP1252StringEncoding];
    [commands appendBytes:"\x1b\x74\x11" length:sizeof("\x1b\x74\x11") - 1];
    [commands appendData:datastr_emailFormat];
    
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"ReciptType"] isEqualToString:@"Refund"])
    {
        NSString *str_Refund =  [[NSString stringWithFormat:@"%@\n",[Language get:@"Refund" alter:@"!Refund"]] uppercaseString];
        
        
        NSData *data_Refund = [str_Refund dataUsingEncoding:NSWindowsCP1252StringEncoding];
        [commands appendBytes:"\x1b\x74\x11" length:sizeof("\x1b\x74\x11") - 1];
        [commands appendData:data_Refund];
    }
    
    NSData *datastr_emailReceiptNo = [str_emailReceiptNo dataUsingEncoding:NSWindowsCP1252StringEncoding];
    [commands appendBytes:"\x1b\x74\x11" length:sizeof("\x1b\x74\x11") - 1];
    [commands appendData:datastr_emailReceiptNo];
 
    NSMutableString *str_header = [[NSMutableString alloc] init];
    
    

    if ([self validateDictionaryValueForKey:[dictHeaderFooter valueForKey:@"company_name"]]) {
        [str_header appendFormat:@"%@\n",[dictHeaderFooter valueForKey:@"company_name"]];
    }
    if ([self validateDictionaryValueForKey:[dictHeaderFooter valueForKey:@"organization_name"]]) {
        [str_header appendFormat:@"Org.nr: %@\n",[dictHeaderFooter valueForKey:@"organization_name"]];
    }

    if ([self validateDictionaryValueForKey:[dictHeaderFooter valueForKey:@"address1"]]) {
        [str_header appendFormat:@"%@\n",[dictHeaderFooter valueForKey:@"address1"]];
    }
    if ([self validateDictionaryValueForKey:[dictHeaderFooter valueForKey:@"address2"]]) {
        [str_header appendFormat:@"%@\n",[dictHeaderFooter valueForKey:@"address2"]];
    }
    if ([self validateDictionaryValueForKey:[dictHeaderFooter valueForKey:@"city"]]) {
        [str_header appendFormat:@"%@\n",[dictHeaderFooter valueForKey:@"city"]];
    }
    if ([self validateDictionaryValueForKey:[dictHeaderFooter valueForKey:@"homepage"]]) {
        [str_header appendFormat:@"%@\n",[dictHeaderFooter valueForKey:@"homepage"]];
    }
    
        if ([self validateDictionaryValueForKey:[dictHeaderFooter valueForKey:@"zipcode"]]) {
        [str_header appendFormat:@"%@\n",[dictHeaderFooter valueForKey:@"zipcode"]];
    }
    if ([self validateDictionaryValueForKey:[dictHeaderFooter valueForKey:@"phone"]]) {
        [str_header appendFormat:@"%@\n",[dictHeaderFooter valueForKey:@"phone"]];
    }
    if ([self validateDictionaryValueForKey:[dictHeaderFooter valueForKey:@"fax"]]) {
        [str_header appendFormat:@"%@\n",[dictHeaderFooter valueForKey:@"fax"]];
    }

    
    if ([self validateDictionaryValueForKey:[dictHeaderFooter valueForKey:@"row1"]]) {
        [str_header appendFormat:@"%@\n",[dictHeaderFooter valueForKey:@"row1"]];
    }
    
    if ([self validateDictionaryValueForKey:[dictHeaderFooter valueForKey:@"row2"]]) {
        [str_header appendFormat:@"%@\n",[dictHeaderFooter valueForKey:@"row2"]];
    }
    if ([self validateDictionaryValueForKey:[dictHeaderFooter valueForKey:@"row3"]]) {
        [str_header appendFormat:@"%@\n",[dictHeaderFooter valueForKey:@"row3"]];
    }
    if ([self validateDictionaryValueForKey:[dictHeaderFooter valueForKey:@"row4"]]) {
        [str_header appendFormat:@"%@\n",[dictHeaderFooter valueForKey:@"row4"]];
    }
    if ([self validateDictionaryValueForKey:[dictHeaderFooter valueForKey:@"row5"]]) {
        [str_header appendFormat:@"%@\n",[dictHeaderFooter valueForKey:@"row5"]];
    }
    
    NSData *datarowHeader = [str_header dataUsingEncoding:NSWindowsCP1252StringEncoding];
    [commands appendBytes:"\x1b\x74\x11" length:sizeof("\x1b\x74\x11") - 1];
    [commands appendData:datarowHeader];
    
//    NSString *str_sign=[NSString stringWithFormat:@"%@ %@ %@ %@ %@",[dictHeaderFooter valueForKey:@"row1"], [dictHeaderFooter valueForKey:@"row2"], [dictHeaderFooter valueForKey:@"row3"], [dictHeaderFooter valueForKey:@"row4"], [dictHeaderFooter valueForKey:@"row5"]];
    
   
    
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"ReportRecipt"]isEqualToString:@"Yes"]) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"No" forKey:@"ReportRecipt"];
        
        
    }
    else
    {
    
//    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"INFRASEC_PASSWORD"]) {
//        
//        
//        NSString *stringHeaderManRegisterId =[NSString stringWithFormat:@"%@:  %@",[Language get:@"ManRegisterId" alter:@"!ManRegisterId"],[[NSUserDefaults standardUserDefaults]valueForKey:@"INFRASEC_PASSWORD"]];
//        
//        NSData *dataHeaderMan = [stringHeaderManRegisterId dataUsingEncoding:NSWindowsCP1252StringEncoding];
//        [commands appendBytes:"\x1b\x74\x11" length:sizeof("\x1b\x74\x11") - 1];
//        [commands appendData:dataHeaderMan];
//    }
    
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"POS_ID"]) {
            
            NSString *stringHeaderManRegisterId =[NSString stringWithFormat:@"\n%@:  %@",[Language get:@"ManRegisterId" alter:@"!ManRegisterId"],[[NSUserDefaults standardUserDefaults]valueForKey:@"POS_ID"]];
            
            NSData *dataHeaderMan = [stringHeaderManRegisterId dataUsingEncoding:NSWindowsCP1252StringEncoding];
            [commands appendBytes:"\x1b\x74\x11" length:sizeof("\x1b\x74\x11") - 1];
            [commands appendData:dataHeaderMan];
        }

    [commands appendBytes:"\x1b\x61\x00"
                   length:sizeof("\x1b\x61\x00") - 1];    // Left Alignment
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    // Convert date object into desired format
    [dateFormatter setDateFormat:@"HH:MM PM"];
        
     //Richa
        
        
        
        NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc]init];
        
        //            [dateFormatter1 setDateFormat:@"MMM"];
        [dateFormatter1 setDateFormat:@"dd MMMM yyyy"];
        
            NSDate *dayDate=[dateFormatter1 dateFromString:[[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:0] valueForKey:@"date"]];
            NSString *dateString;
            
        
            
            NSDate *currDate = dayDate;
            
            
//            NSString *str_timeZone=nil;
        
//            if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"language"]isEqualToString:@"EN"]) {
//                
//                str_timeZone=@"GMT";
//            }
//            else
//            {
//                str_timeZone=@"CET";
//            }
           [dateFormatter1 setDateFormat:@"MMM"];
        
           NSString *str_month = nil;
           str_month = [dateFormatter1 stringFromDate:dayDate];
            
            
            if([str_month isEqualToString:@"Jan"])
            {
                str_month=[Language get:@"Jan" alter:@"!Jan"];
            }
            else if([str_month isEqualToString:@"Feb"])
            {
                str_month=[Language get:@"Feb" alter:@"!Feb"];
            }
            else if([str_month isEqualToString:@"Mar"])
            {
                str_month=[Language get:@"Mar" alter:@"!Mar"];
            }
            else if([str_month isEqualToString:@"Apr"])
            {
                str_month=[Language get:@"Apr" alter:@"!Apr"];
            }
            else if([str_month isEqualToString:@"May"])
            {
                str_month=[Language get:@"May" alter:@"!May"];
            }
            else if([str_month isEqualToString:@"Jun"])
            {
                str_month=[Language get:@"Jun" alter:@"!Jun"];
            }
            else if([str_month isEqualToString:@"Jul"])
            {
                str_month=[Language get:@"Jul" alter:@"!Jul"];
            }
            else if([str_month isEqualToString:@"Aug"])
            {
                str_month=[Language get:@"Aug" alter:@"!Aug"];
            }
            else if([str_month isEqualToString:@"Sep"])
            {
                str_month=[Language get:@"Sep" alter:@"!Sep"];
            }
            else if([str_month isEqualToString:@"Oct"])
            {
                str_month=[Language get:@"Oct" alter:@"!Oct"];
            }
            else if([str_month isEqualToString:@"Nov"])
            {
                str_month=[Language get:@"Nov" alter:@"!Nov"];
            }
            else if([str_month isEqualToString:@"Dec"])
            {
                str_month=[Language get:@"Dec" alter:@"!Dec"];
            }
            
            [dateFormatter1 setDateFormat:@"dd"];
            
            NSString *str_day = [dateFormatter1 stringFromDate:currDate];
            
            [dateFormatter1 setDateFormat:@"yyyy"];
            
            NSString *str_year = [dateFormatter1 stringFromDate:currDate];
        
            dateString=[NSString stringWithFormat:@"%@ %@ %@",str_day,str_month,str_year];
            
        
        if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"time_format"] isEqualToString:@"12"])
        {
            [dateFormatter setDateFormat:@"hh:mm a"];
        }
        else
        {
            [dateFormatter setDateFormat:@"HH:mm"];
        }
        
     
        
//    NSDateFormatter *dateFormatterDate=[[NSDateFormatter alloc] init];
//        // Convert date object into desired format
//    [dateFormatterDate setDateFormat:@"dd MMM yyy"];
//        
//    NSDate *date1 = [dateFormatterDate dateFromString:[[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:0] valueForKey:@"date"]];
//        
//    NSString *stringDate = [dateFormatterDate stringFromDate:date1];

    NSString *date=[NSString stringWithFormat:@"\n%@: %@ %@:%@\n"
                        "--------------------------------\n",[Language get:@"Date" alter:@"!Date"], dateString,[Language get:@"Time" alter:@"!Time"],[dateFormatter stringFromDate:[NSDate date]]];
    
    NSData* dataDate = [date dataUsingEncoding:NSWindowsCP1252StringEncoding];
    
        [commands appendBytes:"\x1b\x74\x11" length:sizeof("\x1b\x74\x11") - 1];
    [commands appendData:dataDate];
    
//    [commands appendBytes:"\x1b\x45\x01"
//                   length:sizeof("\x1b\x45\x01") - 1];    // Set Emphasized Printing ON
        
    NSString *string = [NSString stringWithFormat:@"%@\n", [Language get:@"SALE" alter:@"!SALE"]];

    
    [commands appendData:[string dataUsingEncoding:NSWindowsCP1252StringEncoding]];

        [commands appendBytes:"\x1b\x74\x11" length:sizeof("\x1b\x74\x11") - 1];
    
//    [commands appendBytes:"\x1b\x45\x00"
//                   length:sizeof("\x1b\x45\x00") - 1];    // Set Emphasized Printing OFF (same command as on)
    
    
    
    NSMutableString *str_product;
    str_product=[[NSMutableString alloc] init];
    
    for (int i=0; i <[[appDelegate.reciptArray valueForKey:@"sub"] count]; i++) {
        
        
        NSString *str_name=[NSString stringWithFormat:@"%@",[[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:i] valueForKey:@"name"]];
        NSString *string_space = @"";
        int str_legnth=[NSString stringWithFormat:@"%@",[[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:i] valueForKey:@"name"]].length;
        if (str_legnth<20) {
            
            for (int i =0 ; i<(20-str_legnth); i++) {
                
                string_space=[string_space stringByAppendingString:@" "];
            }
        }
        else
        {
            
            NSString *myString = [NSString stringWithFormat:@"%@",[[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:i] valueForKey:@"name"]];
            str_name = (myString.length > 20) ? [myString substringToIndex:20] : myString;
        }
        
        NSString *concatenateString = [str_name stringByAppendingString:string_space];
        
        float str = [[[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:i] valueForKey:@"peritemprice"] floatValue]*[[[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:i] valueForKey:@"count"] floatValue];
        
        [str_product appendFormat:@"%@x %@  %@\n",[[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:i] valueForKey:@"count"],concatenateString,[NSString stringWithFormat:@"%.02f", str]];
    }
        
        NSDictionary *receiptArray_details = [[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:0];
        
        
    //    int vatPercentage = roundf(([[appDelegate.reciptArray valueForKey:@"totalvat"] floatValue]*100)/[[appDelegate.reciptArray valueForKey:@"tprice"] floatValue]);
        [str_product appendString:[NSString stringWithFormat:@"%@                  %@ %.02f\n",[Language get:@"Vat" alter:@"!Vat"],str_cur, [[appDelegate.reciptArray valueForKey:@"totalvat"] floatValue]]];
//    [str_product appendString:[NSString stringWithFormat:@"%@ %d%%               %@ %.02f\n",[Language get:@"Vat" alter:@"!Vat"],[[receiptArray_details valueForKey:@"vat"] integerValue],str_cur, [[appDelegate.reciptArray valueForKey:@"totalvat"] floatValue]]];
        
        NSLog(@"arrryyy:%@",appDelegate.reciptArray);
        
        
        if ([[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:0] valueForKey:@"discount"] != nil && [[[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:0] valueForKey:@"discount"]floatValue]>0)
        {
            
            [str_product appendString:[NSString stringWithFormat:@"%@             -%@ %.02f\n",[Language get:@"Discount" alter:@"!Discount"],str_cur,[[[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:0] valueForKey:@"discount"] floatValue]]];
           // [str_product appendFormat:@"--------------------------------\n"];
        }

        
        
        if ([appDelegate.reciptArray valueForKey:@"exchange"] != nil && [[appDelegate.reciptArray valueForKey:@"exchange"]floatValue]>0)
        {
            
            [str_product appendString:[NSString stringWithFormat:@"%@             %@ %.02f\n",[Language get:@"Exchange" alter:@"!Exchange"],str_cur,[[appDelegate.reciptArray valueForKey:@"exchange"] floatValue]]];
          //  [str_product appendFormat:@"--------------------------------\n"];
        }
        
//        if ([[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:0] valueForKey:@"discount"] != nil) {
//            
//            [str_product appendString:[NSString stringWithFormat:@"%@             -%@ %.02f\n",[Language get:@"Discount" alter:@"!Discount"],str_cur,[[[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:0] valueForKey:@"discount"] floatValue]]];
//            [str_product appendFormat:@"--------------------------------\n"];
//        }
    
    
    [str_product appendString:[Language get:@"Total" alter:@"!Total"]];
    

    
    NSData* dataProduct = [str_product dataUsingEncoding:NSWindowsCP1252StringEncoding];
        [commands appendBytes:"\x1b\x74\x11" length:sizeof("\x1b\x74\x11") - 1];
    [commands appendData:dataProduct];
    
   // [commands appendBytes:"\x1d\x21\x10" length:sizeof("\x1d\x21\x11") - 1];    // Width and Height Character Expansion  <GS>  !  n
    
//    NSString *str_total=[NSString stringWithFormat:@"      %@%.02f\n",str_cur,[[appDelegate.reciptArray valueForKey:@"tprice"] floatValue]-[[[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:0] valueForKey:@"discount"] floatValue]];

    NSString *str_total;
    if ([currencySign isEqualToString:@"SEK"]) {
        
        if ([[NSString stringWithFormat:@"   %@%.02f\n",str_cur,[[appDelegate.reciptArray valueForKey:@"tprice"] floatValue]] containsString:@"-"]) {
            
            str_total=[NSString stringWithFormat:@"  %@ %.02f\n",str_cur,[[appDelegate.reciptArray valueForKey:@"tprice"] floatValue]];
        }
        else
        {
            str_total=[NSString stringWithFormat:@"  %@ %.02f\n",str_cur,[[appDelegate.reciptArray valueForKey:@"tprice"] floatValue]];
        }
        
    }
    else
    {
         str_total=[NSString stringWithFormat:@"    %@ %.02f\n",str_cur,[[appDelegate.reciptArray valueForKey:@"tprice"] floatValue]];
    }
    
    NSData* datatotal = [str_total dataUsingEncoding:NSWindowsCP1252StringEncoding];
    [commands appendBytes:"\x1b\x74\x11" length:sizeof("\x1b\x74\x11") - 1];
    [commands appendData:datatotal];
    
   // [commands appendBytes:"\x1d\x21\x00" length:sizeof("\x1d\x21\x00") - 1];    // Cancel Expansion - Reference Star Portable Printer Programming Manual
    
    
    NSString *str_charges=[NSString stringWithFormat:@"--------------------------------\n"
                           "%@\n"
                           "%@%.02f\n",[Language get:@"Charge" alter:@"!Charge"],str_cur,[[appDelegate.reciptArray valueForKey:@"tprice"] floatValue]];
//        NSString *str_charges=[NSString stringWithFormat:@"--------------------------------\n"
//                               "Charge\n"
//                               "%@%.02f\n",str_cur,[[appDelegate.reciptArray valueForKey:@"tprice"] floatValue]-[[[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:0] valueForKey:@"discount"] floatValue]];
    
    NSData* datacharges = [str_charges dataUsingEncoding:NSWindowsCP1252StringEncoding];
    
    [commands appendBytes:"\x1b\x74\x11" length:sizeof("\x1b\x74\x11") - 1];
    [commands appendData:datacharges];
    
    //    [commands appendBytes:"\x1d\x77\x02"
    //                   length:sizeof("\x1d\x77\x02") - 1];    // for 1D Code39 Barcode
    //
    //    [commands appendBytes:"\x1d\x68\x64"
    //                   length:sizeof("\x1d\x68\x64") - 1];    // for 1D Code39 Barcode
    //
    //    [commands appendBytes:"\x1d\x48\x01"
    //                   length:sizeof("\x1d\x48\x01") - 1];    // for 1D Code39 Barcode
    //
    //    [commands appendBytes:"\x1d\x6b\x41\x0b\x30\x31\x32\x33\x34\x35\x36\x37\x38\x39\x30"
    //                   length:sizeof("\x1d\x6b\x41\x0b\x30\x31\x32\x33\x34\x35\x36\x37\x38\x39\x30") - 1];    // for 1D Code39 Barcode
    //
    //    [commands appendData:[@"\n" dataUsingEncoding:NSASCIIStringEncoding]];
    //
    //    [commands appendBytes:"\x1d\x42\x01"
    //                   length:sizeof("\x1d\x42\x01") - 1];    // Specify White-Black Invert
    //
    //    [commands appendData:[@"Refunds and Exchanges\n" dataUsingEncoding:NSASCIIStringEncoding]];
    //
    //    [commands appendBytes:"\x1d\x42\x00"
    //                   length:sizeof("\x1d\x42\x00") - 1];    // Cancel White-Black Invert
    //
    //    [commands appendData:[@"Within " dataUsingEncoding:NSASCIIStringEncoding]];
    //
    //    [commands appendBytes:"\x1b\x2d\x01"
    //                   length:sizeof("\x1b\x2d\x01") - 1];    // Specify Underline Printing
    //
    //    [commands appendData:[@"30 days" dataUsingEncoding:NSASCIIStringEncoding]];
    //
    //    [commands appendBytes:"\x1b\x2d\x00"
    //                   length:sizeof("\x1b\x2d\x00") - 1];    // Cancel Underline Printing
    
//    NSString *str_sign=[NSString stringWithFormat:@"-----------Sign Here------------\n\n\n\n%@ %@ %@ %@ %@ %@ %@ %@ %@ %@\n"
//                        "--------------------------------\n"
//                        "Thank you for buying!", [dictHeaderFooter valueForKey:@"row1"], [dictHeaderFooter valueForKey:@"row2"], [dictHeaderFooter valueForKey:@"row3"], [dictHeaderFooter valueForKey:@"row4"], [dictHeaderFooter valueForKey:@"row5"], [dictHeaderFooter valueForKey:@"row6"], [dictHeaderFooter valueForKey:@"row7"], [dictHeaderFooter valueForKey:@"row8"], [dictHeaderFooter valueForKey:@"row9"], [dictHeaderFooter valueForKey:@"row10"]];
    
   
        
        //Add receipt details
        if([[[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:0] valueForKey:@"paymentMethod"] isEqualToString:@"2"]){
            if (card_details_available) {
                
            
            NSMutableString *cardReceiptDetails = [[NSMutableString alloc] init];
            [cardReceiptDetails appendString:@"--------------------------------\n"];
            [cardReceiptDetails appendFormat:@"        %@ \n %@\n",[Language get:@"Card Transaction" alter:@"!Card Transaction"],[Language get:@"Payment" alter:@"!Payment"]];
            [cardReceiptDetails appendFormat:@" %@          %@\n",currencySign,[dictHeaderFooter valueForKey:@"receipt_amount"]];
            [cardReceiptDetails appendFormat:@" %@:     %@\n %@        %@\n             %@\n             %@\n",[Language get:@"Shop No." alter:@"!Shop No."],[dictHeaderFooter valueForKey:@"merchant_id"],[Language get:@"TerminalId:" alter:@"!TerminalId:"],[dictHeaderFooter valueForKey:@"receipt_terminal_id"],[dictHeaderFooter valueForKey:@"receipt_account"],[dictHeaderFooter valueForKey:@"receipt_card"]];
            
            [cardReceiptDetails appendFormat:@" Auth:        %@\n",[dictHeaderFooter valueForKey:@"receipt_authorization_id"]];
            
            [cardReceiptDetails appendFormat:@" Ref nr:        %@\n",[dictHeaderFooter valueForKey:@"receipt_transaction_reference_number"]];
            
            [cardReceiptDetails appendFormat:@" AID:         %@\n           %@ %@\n",[dictHeaderFooter valueForKey:@"receipt_aid"],[Language get:@"Entry Mode" alter:@"!Entry Mode"],[dictHeaderFooter valueForKey:@"receipt_entry_mode"]];
            
            NSString *pwid = [NSString stringWithFormat:@"%@",[dictHeaderFooter valueForKey:@"receipt_pwid"]];
            NSString *pwid_part1 = [pwid substringWithRange:NSMakeRange(0,pwid.length/2)];
            NSString *pwid_part2 = [pwid substringWithRange:NSMakeRange(pwid.length/2 -1, pwid.length/2)];

            [cardReceiptDetails appendFormat:@" PWID:     %@\n           %@\n",pwid_part1,pwid_part2];

            NSData* datacharges = [cardReceiptDetails dataUsingEncoding:NSWindowsCP1252StringEncoding];
            
            [commands appendBytes:"\x1b\x74\x11" length:sizeof("\x1b\x74\x11") - 1];
            [commands appendData:datacharges];
            }
        }
        NSMutableString *str_sign1 = [[NSMutableString alloc] init];
       // [str_sign1 appendFormat:@"-----------%@------------\n\n\n\n",[Language get:@"Sign Here" alter:@"!Sign Here"]];
        
        if ([self validateDictionaryValueForKey:[[NSUserDefaults standardUserDefaults] valueForKey:@"Code"]]) {
            [commands appendBytes:"\x1b\x61\x01"
                           length:sizeof("\x1b\x61\x01") - 1];
            [str_sign1 appendFormat:@"\n%@\n",[[NSUserDefaults standardUserDefaults] valueForKey:@"Code"]];
        }
        
        if ([self validateDictionaryValueForKey:[[NSUserDefaults standardUserDefaults] valueForKey:@"UnitId"]]) {
            [commands appendBytes:"\x1b\x61\x01"
                           length:sizeof("\x1b\x61\x01") - 1];
            [str_sign1 appendFormat:@"%@\n",[[NSUserDefaults standardUserDefaults] valueForKey:@"UnitId"]];
        }

        
        if ([self validateDictionaryValueForKey:[dictHeaderFooter valueForKey:@"row6"]]) {
            [str_sign1 appendFormat:@"%@\n",[dictHeaderFooter valueForKey:@"row6"]];
        }
        
        if ([self validateDictionaryValueForKey:[dictHeaderFooter valueForKey:@"row7"]]) {
            [str_sign1 appendFormat:@"%@\n",[dictHeaderFooter valueForKey:@"row7"]];
        }
        if ([self validateDictionaryValueForKey:[dictHeaderFooter valueForKey:@"row8"]]) {
            [str_sign1 appendFormat:@"%@\n",[dictHeaderFooter valueForKey:@"row8"]];
        }
        if ([self validateDictionaryValueForKey:[dictHeaderFooter valueForKey:@"row9"]]) {
            [str_sign1 appendFormat:@"%@\n",[dictHeaderFooter valueForKey:@"row9"]];
        }
        if ([self validateDictionaryValueForKey:[dictHeaderFooter valueForKey:@"row10"]]) {
            [str_sign1 appendFormat:@"%@\n",[dictHeaderFooter valueForKey:@"row10"]];
        }
        [commands appendBytes:"\x1b\x61\x01"
                       length:sizeof("\x1b\x61\x01") - 1];
        [str_sign1 appendFormat:@"\n%@",[Language get:@"Thank you for buying!" alter:@"!Thank you for buying!"]];
        [str_sign1 appendFormat:@"\n\n\n-----------%@-------------\n",[Language get:@"Cut here" alter:@"!Cut here"]];

        
//        str_sign1=[NSString stringWithFormat:@"-----------%@------------\n\n\n\n%@\n%@\n%@\n%@\n%@\n"
//                             "--------------------------------\n"
//                             "%@",[Language get:@"Sign Here" alter:@"!Sign Here"],[dictHeaderFooter valueForKey:@"row6"], [dictHeaderFooter valueForKey:@"row7"], [dictHeaderFooter valueForKey:@"row8"], [dictHeaderFooter valueForKey:@"row9"], [dictHeaderFooter valueForKey:@"row10"],[Language get:@"Thank you for buying!" alter:@"!Thank you for buying!"]];
        
       NSLog(@"Printer value--: %@",str_sign1);
//        unsigned char bytes[] = {0x23, 0x24, 0x40, 0x58, 0x5a, 0x5b, 0x5c, 0x5d, 0x5e, 0x60, 0x7b, 0x7c, 0x7d, 0x7e, 0x0a};
//        NSUInteger length = sizeof(bytes);
//        
        
        //NSData* dataSign = [str_sign1 dataUsingEncoding:[NSString defaultCStringEncoding]];
       
//       ISCBBuilder *builder = [StarIoExt createCommandBuilder:dataSign];
//        [builder appendData:[@"*Sweden*\n" dataUsingEncoding:NSASCIIStringEncoding]];
//        [builder appendInternational:SCBInternationalTypeSweden];
//        [builder appendBytes:bytes length:length];
        
        
        
//const char *cString = [str_sign1 cStringUsingEncoding:NSUTF8StringEncoding];
//    //[NSString defaultCStringEncoding]
//   NSData* dataSign = [[NSString stringWithUTF8Strinstringng] dataUsingEncoding:[NSString defaultCStringEncoding]];
    //NSData* dataSign = [str_sign1 dataUsingEncoding:NSASCIIStringEncoding];
       
    NSData* dataSign = [str_sign1 dataUsingEncoding:NSWindowsCP1252StringEncoding];

   // [commands appendBytes:"\x1b\x61\x01"
                      // length:sizeof("\x1b\x61\x01") - 1];
        //Anu:7July2016 New code page given by Devinder Sir
         [commands appendBytes:"\x1b\x74\x11" length:sizeof("\x1b\x74\x11") - 1];
        
     //dataSign = [dataSign subdataWithRange:NSMakeRange(0, [dataSign length] - 1)];
    [commands appendData:dataSign];
        
       
    [commands appendData:[@"\n\n\n\n\n" dataUsingEncoding:NSASCIIStringEncoding]];
        

        NSString * convertedStr=[[NSString alloc] initWithData:commands encoding:NSASCIIStringEncoding];;
    }
    
    return commands;
    
    
}

/**
 * This function create the sample receipt data (3inch)
 */

+ (BOOL)validateDictionaryValueForKey:(id)value{
    BOOL result = NO;
    if(!value)
    return NO;
    NSString *str_value = [NSString stringWithFormat:@"%@",value];
    if (str_value.length >0) {
        result = YES;
    }
    else {
        result = NO;
    }
    return result;
}
#pragma mark Z Day Report
+ (NSData *)create2InchXZReceipt
{
  
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

        NSString *currencySign=nil;
    
        NSManagedObjectContext *context1 =[appDelegate managedObjectContext];
        NSError *error1;
        NSEntityDescription *entityDescc =[NSEntityDescription entityForName:@"VatandCurrency" inManagedObjectContext:context1];
        NSFetchRequest *requestt = [[NSFetchRequest alloc] init];
        [requestt setEntity:entityDescc];
        NSManagedObject *matches = nil;
        NSArray *objectss = [context1 executeFetchRequest:requestt error:&error1];
        if ([objectss count] == 0) {
            NSManagedObject *newContact;
            newContact = [NSEntityDescription insertNewObjectForEntityForName:@"VatandCurrency" inManagedObjectContext:context1];
            [newContact setValue:@"$" forKey:@"currency"];
            currencySign=@"$";
            [context1 save:&error1];
            
        } else {
            
            matches=(NSManagedObject*)[objectss objectAtIndex:0];
            currencySign=[matches valueForKey:@"currency"];
        }
  
        NSString *str_cur;
        
        if ([currencySign isEqualToString:@"$"]) {
            
            str_cur=@"$";
            
        }else if ([currencySign isEqualToString:@"€"]) {
            
            char utf8[]  = "\xE2\x82\xac";
            
            //        str_cur=[[NSString alloc] initWithBytes:utf8 length:3 encoding:NSUTF8StringEncoding];
            
            //        str_cur=@"\xE2\x82\xac";
            str_cur=@"\u20ac";
            
            
            
        } else if ([currencySign isEqualToString:@"SEK"]) {
            
            str_cur=@"SEK";
        }
        else
        {
            str_cur=@"$";
        }
        
        
        char utf8[]  = "\xE2\x82\xac";
        char utf16[] = "\x20\xAC";
        NSLog(@"utf8:  %@", [[NSString alloc] initWithBytes:utf8 length:3 encoding:NSUTF8StringEncoding]);
        NSLog(@"utf16: %@", [[NSString alloc] initWithBytes:utf16 length:2 encoding:NSUTF16BigEndianStringEncoding]);
        
        NSString *cost = @"156.95 \xE2\x82\xac\r\n"; // dataUsingEncoding:NSUTF8StringEncoding]];
   
        
        NSMutableData *commandsw = [NSMutableData new];
        [commandsw appendData:[@"156.95 \xE2\x82\xac\r\n" dataUsingEncoding:NSUTF8StringEncoding]];

        
        NSManagedObjectContext *context =[appDelegate managedObjectContext];
        NSEntityDescription *entityDesc =[NSEntityDescription entityForName:@"ReceiptData" inManagedObjectContext:context];
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entityDesc];
        NSPredicate *pred =[NSPredicate predicateWithFormat:@"(id = %@)",@"1"];
        [request setPredicate:pred];
        NSError *error;
        NSArray *objects = [context executeFetchRequest:request error:&error];
        //    NSManagedObject *person = (NSManagedObject *)[objects objectAtIndex:0];
    
        entityDesc =[NSEntityDescription entityForName:@"Recepit_CardPayment" inManagedObjectContext:context];
        [request setEntity:entityDesc];
        NSArray *recieptItemNameArray = [appDelegate.reciptArray valueForKey:@"sub"];
        NSArray *itemsName = [[appDelegate.reciptArray valueForKey:@"sub"] allKeys];
        NSDictionary *recieptDict = [recieptItemNameArray valueForKey:[itemsName firstObject]];
        NSArray *receipt_details =[recieptItemNameArray valueForKey:[itemsName firstObject]];
        NSString *receiptId = [recieptDict valueForKey:@"id"];
     //   NSString *reciept_id = [recieptDict valueForKey:@"id"];// [NSString stringWithFormat:@"%@",[[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:0] valueForKey:@"id"]];
       // pred =[NSPredicate predicateWithFormat:@"receipt_id =%@",[[[appDelegate.reciptArray valueForKey:@"sub"] objectAtIndex:0] valueForKey:@"id"]];
    if ([[recieptDict valueForKey:@"paymentMethod"] isEqualToString:@"2"]) {
         pred =[NSPredicate predicateWithFormat:@"(receipt_id = %@)",receiptId]; //@"1"
    }
    else{
         pred =[NSPredicate predicateWithFormat:@"(id = %@)",receiptId]; //@"1"
    }
    
        [request setPredicate:pred];
    
    
    NSArray *card_payment_receipts;
    if ([[recieptDict valueForKey:@"paymentMethod"] isEqualToString:@"2"]) {
        card_payment_receipts = [context executeFetchRequest:request error:&error];
    }
    else{
         entityDesc =[NSEntityDescription entityForName:@"Trasections" inManagedObjectContext:context];
         [request setEntity:entityDesc];
        card_payment_receipts = [context executeFetchRequest:request error:&error];
    }
    
        NSMutableDictionary *dictHeaderFooter = [NSMutableDictionary new];
        
        if (objects.count == 0)
        {
            [dictHeaderFooter setValue:@"" forKey:@"organization_name"];
            [dictHeaderFooter setValue:@"" forKey:@"company_name"];
            [dictHeaderFooter setValue:@"" forKey:@"address1"];
            [dictHeaderFooter setValue:@"" forKey:@"address2"];
            [dictHeaderFooter setValue:@"" forKey:@"zipcode"];
            [dictHeaderFooter setValue:@"" forKey:@"city"];
            [dictHeaderFooter setValue:@"" forKey:@"phone"];
            [dictHeaderFooter setValue:@"" forKey:@"fax"];
            [dictHeaderFooter setValue:@"" forKey:@"homepage"];
            
            [dictHeaderFooter setValue:@"" forKey:@"row1"];
            [dictHeaderFooter setValue:@"" forKey:@"row2"];
            [dictHeaderFooter setValue:@"" forKey:@"row3"];
            [dictHeaderFooter setValue:@"" forKey:@"row4"];
            [dictHeaderFooter setValue:@"" forKey:@"row5"];
            [dictHeaderFooter setValue:@"" forKey:@"row6"];
            [dictHeaderFooter setValue:@"" forKey:@"row7"];
            [dictHeaderFooter setValue:@"" forKey:@"row8"];
            [dictHeaderFooter setValue:@"" forKey:@"row9"];
            [dictHeaderFooter setValue:@"" forKey:@"row10"];
        }
        else
        {
            for(int i=0;i<objects.count;i++)
            {
                NSManagedObject *person = (NSManagedObject *)[objects objectAtIndex:i];
                
                [dictHeaderFooter setValue:[person valueForKey:@"organization_name"] forKey:@"organization_name"];
                [dictHeaderFooter setValue:[person valueForKey:@"company_name"] forKey:@"company_name"];
                [dictHeaderFooter setValue:[person valueForKey:@"address1"] forKey:@"address1"];
                [dictHeaderFooter setValue:[person valueForKey:@"address2"] forKey:@"address2"];
                [dictHeaderFooter setValue:[person valueForKey:@"zipcode"] forKey:@"zipcode"];
                [dictHeaderFooter setValue:[person valueForKey:@"city"] forKey:@"city"];
                [dictHeaderFooter setValue:[person valueForKey:@"phone"] forKey:@"phone"];
                [dictHeaderFooter setValue:[person valueForKey:@"fax"] forKey:@"fax"];
                [dictHeaderFooter setValue:[person valueForKey:@"homepage"] forKey:@"homepage"];
                
                if ([self validateDictionaryValueForKey:[person valueForKey:@"row1"]]) {
                    [dictHeaderFooter setValue:[person valueForKey:@"row1"] forKey:@"row1"];
                    
                }
                if ([self validateDictionaryValueForKey:[person valueForKey:@"row2"]]) {
                    [dictHeaderFooter setValue:[person valueForKey:@"row2"] forKey:@"row2"];
                }
                if ([self validateDictionaryValueForKey:[person valueForKey:@"row3"]]) {
                    [dictHeaderFooter setValue:[person valueForKey:@"row3"] forKey:@"row3"];
                }
                if ([self validateDictionaryValueForKey:[person valueForKey:@"row4"]]) {
                    [dictHeaderFooter setValue:[person valueForKey:@"row4"] forKey:@"row4"];
                }
                if ([self validateDictionaryValueForKey:[person valueForKey:@"row5"]]) {
                    [dictHeaderFooter setValue:[person valueForKey:@"row5"] forKey:@"row5"];
                }
                if ([self validateDictionaryValueForKey:[person valueForKey:@"row6"]]) {
                    [dictHeaderFooter setValue:[person valueForKey:@"row6"] forKey:@"row6"];
                }
                
                if ([self validateDictionaryValueForKey:[person valueForKey:@"row7"]]) {
                    [dictHeaderFooter setValue:[person valueForKey:@"row7"] forKey:@"row7"];
                }
                if ([self validateDictionaryValueForKey:[person valueForKey:@"row8"]]) {
                    [dictHeaderFooter setValue:[person valueForKey:@"row8"] forKey:@"row8"];
                }
                if ([self validateDictionaryValueForKey:[person valueForKey:@"row9"]]) {
                    [dictHeaderFooter setValue:[person valueForKey:@"row9"] forKey:@"row9"];
                }
                if ([self validateDictionaryValueForKey:[person valueForKey:@"row10"]]) {
                    [dictHeaderFooter setValue:[person valueForKey:@"row10"] forKey:@"row10"];
                }
                
            }
        }
        
        NSMutableData *commands = [[NSMutableData new] autorelease];
        
        [commands appendBytes:"\x1d\x57\x80\x31"
                       length:sizeof("\x1d\x57\x80\x31") - 1];    // Page Area Setting     <GS> <W> nL nH  (nL = 128, nH = 1)
        
        [commands appendBytes:"\x1b\x61\x01"
                       length:sizeof("\x1b\x61\x01") - 1];    // Center Justification  <ESC> a n       (0 Left, 1 Center, 2 Right)
        
        NSString *str_emailFormat;
        
        //        if ([@"Original" isEqualToString:[[NSUserDefaults standardUserDefaults]valueForKey:@"ReciptType"]]) {
        //
        //
        //            str_emailFormat  =[NSString stringWithFormat:@"%@\n", [Language get:@"Original" alter:@"!Original"]];
        //
        //        }
        //        else
        //        {
//        str_emailFormat  =[NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] valueForKey:@"dayReport"]];
    
    str_emailFormat = [[NSUserDefaults standardUserDefaults] valueForKey:@"repType"];
        //        }
    
    
        
        NSData *datastr_emailFormat = [str_emailFormat dataUsingEncoding:NSWindowsCP1252StringEncoding];
        [commands appendBytes:"\x1b\x74\x11" length:sizeof("\x1b\x74\x11") - 1];
        [commands appendData:datastr_emailFormat];

    
    if ([self validateDictionaryValueForKey:[dictHeaderFooter valueForKey:@"organization_name"]]) {
        [commands appendData:[[NSString stringWithFormat:@"\n%@: %@\n",[Language get:@"Organization Number" alter:@"!Organization Number"],[dictHeaderFooter valueForKey:@"organization_name"]] dataUsingEncoding:NSWindowsCP1252StringEncoding]];
    }
    
//    if([[NSUserDefaults standardUserDefaults]valueForKey:@"ORGANIZATION_NUMBER"])
//        [commands appendData:[[NSString stringWithFormat:@"\n%@: %@\n",[Language get:@"Organization Number" alter:@"!Organization Number"],[[NSUserDefaults standardUserDefaults]valueForKey:@"ORGANIZATION_NUMBER"]] dataUsingEncoding:NSWindowsCP1252StringEncoding]];
    
    
    if (![[appDelegate.arrayZDayReport valueForKey:@"id"] isEqual:NULL] && ![[appDelegate.arrayZDayReport valueForKey:@"id"] isEqual:[NSNull null]]&&[appDelegate.arrayZDayReport valueForKey:@"id"] !=nil)
    {
        
    [commands appendData:[[NSString stringWithFormat:@"%@: %@ \n",[Language get:@"Report Number" alter:@"!Report Number"],[appDelegate.arrayZDayReport valueForKey:@"id"]] dataUsingEncoding:NSWindowsCP1252StringEncoding]];
        
        [commands appendBytes:"\x1b\x74\x11" length:sizeof("\x1b\x74\x11") - 1];
    }
    
//       NSString *stringHeaderData = [NSString stringWithFormat:@"\n%@\n%@\n%@\n%@\n%@ %@\n%@ %@\n %@\n %@\n %@\n %@\n %@\n",[dictHeaderFooter valueForKey:@"organization_name"],[dictHeaderFooter valueForKey:@"company_name"], [dictHeaderFooter valueForKey:@"address1"], [dictHeaderFooter valueForKey:@"address2"], [dictHeaderFooter valueForKey:@"city"], [dictHeaderFooter valueForKey:@"zipcode"], [dictHeaderFooter valueForKey:@"phone"], [dictHeaderFooter valueForKey:@"fax"], [dictHeaderFooter valueForKey:@"row1"], [dictHeaderFooter valueForKey:@"row2"], [dictHeaderFooter valueForKey:@"row3"], [dictHeaderFooter valueForKey:@"row4"], [dictHeaderFooter valueForKey:@"row5"]];
    
    NSMutableString *str_header = [[NSMutableString alloc] init];
    
    if ([self validateDictionaryValueForKey:[dictHeaderFooter valueForKey:@"company_name"]]) {
        [str_header appendFormat:@"%@\n",[dictHeaderFooter valueForKey:@"company_name"]];
    }
    if ([self validateDictionaryValueForKey:[dictHeaderFooter valueForKey:@"address1"]]) {
        [str_header appendFormat:@"%@\n",[dictHeaderFooter valueForKey:@"address1"]];
    }
    if ([self validateDictionaryValueForKey:[dictHeaderFooter valueForKey:@"address2"]]) {
        [str_header appendFormat:@"%@\n",[dictHeaderFooter valueForKey:@"address2"]];
    }
    if ([self validateDictionaryValueForKey:[dictHeaderFooter valueForKey:@"city"]]) {
        [str_header appendFormat:@"%@\n",[dictHeaderFooter valueForKey:@"city"]];
    }
    if ([self validateDictionaryValueForKey:[dictHeaderFooter valueForKey:@"homepage"]]) {
        [str_header appendFormat:@"%@\n",[dictHeaderFooter valueForKey:@"homepage"]];
    }
    
    if ([self validateDictionaryValueForKey:[dictHeaderFooter valueForKey:@"zipcode"]]) {
        [str_header appendFormat:@"%@\n",[dictHeaderFooter valueForKey:@"zipcode"]];
    }
    if ([self validateDictionaryValueForKey:[dictHeaderFooter valueForKey:@"phone"]]) {
        [str_header appendFormat:@"%@\n",[dictHeaderFooter valueForKey:@"phone"]];
    }
    if ([self validateDictionaryValueForKey:[dictHeaderFooter valueForKey:@"fax"]]) {
        [str_header appendFormat:@"%@\n",[dictHeaderFooter valueForKey:@"fax"]];
    }
    
    
    if ([self validateDictionaryValueForKey:[dictHeaderFooter valueForKey:@"row1"]]) {
        [str_header appendFormat:@"%@\n",[dictHeaderFooter valueForKey:@"row1"]];
    }
    
    if ([self validateDictionaryValueForKey:[dictHeaderFooter valueForKey:@"row2"]]) {
        [str_header appendFormat:@"%@\n",[dictHeaderFooter valueForKey:@"row2"]];
    }
    if ([self validateDictionaryValueForKey:[dictHeaderFooter valueForKey:@"row3"]]) {
        [str_header appendFormat:@"%@\n",[dictHeaderFooter valueForKey:@"row3"]];
    }
    if ([self validateDictionaryValueForKey:[dictHeaderFooter valueForKey:@"row4"]]) {
        [str_header appendFormat:@"%@\n",[dictHeaderFooter valueForKey:@"row4"]];
    }
    if ([self validateDictionaryValueForKey:[dictHeaderFooter valueForKey:@"row5"]]) {
        [str_header appendFormat:@"%@\n",[dictHeaderFooter valueForKey:@"row5"]];
    }
    
    NSData *datarowHeader = [str_header dataUsingEncoding:NSWindowsCP1252StringEncoding];
    [commands appendBytes:"\x1b\x74\x11" length:sizeof("\x1b\x74\x11") - 1];
    [commands appendData:datarowHeader];
    
//        NSData *dataHeader = [stringHeaderData dataUsingEncoding:NSWindowsCP1252StringEncoding];
//        [commands appendBytes:"\x1b\x74\x11" length:sizeof("\x1b\x74\x11") - 1];
//        [commands appendData:dataHeader];
    
//        if ([[NSUserDefaults standardUserDefaults]valueForKey:@"INFRASEC_PASSWORD"]) {
//            
//            
//            NSString *stringHeaderManRegisterId =[NSString stringWithFormat:@"%@:  %@",[Language get:@"ManRegisterId" alter:@"!ManRegisterId"],[[NSUserDefaults standardUserDefaults]valueForKey:@"INFRASEC_PASSWORD"]];
//            
//            NSData *dataHeaderMan = [stringHeaderManRegisterId dataUsingEncoding:NSWindowsCP1252StringEncoding];
//            [commands appendBytes:"\x1b\x74\x11" length:sizeof("\x1b\x74\x11") - 1];
//            [commands appendData:dataHeaderMan];
//        }
    
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"POS_ID"]) {
        
        
        NSString *stringHeaderManRegisterId =[NSString stringWithFormat:@"\n%@:  %@\n",[Language get:@"ManRegisterId" alter:@"!ManRegisterId"],[[NSUserDefaults standardUserDefaults]valueForKey:@"POS_ID"]];
        
        NSData *dataHeaderMan = [stringHeaderManRegisterId dataUsingEncoding:NSWindowsCP1252StringEncoding];
        [commands appendBytes:"\x1b\x74\x11" length:sizeof("\x1b\x74\x11") - 1];
        [commands appendData:dataHeaderMan];
    }
    
        [commands appendBytes:"\x1b\x61\x00"
                       length:sizeof("\x1b\x61\x00") - 1];    // Left Alignment
        
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        // Convert date object into desired format
        [dateFormatter setDateFormat:@"HH:MM PM"];
    
    [appDelegate fetch_globalData];
    
    
    
    if(appDelegate.arrayZDayReport.count>0)
    {
        
        NSDate *zdayDate=[appDelegate.arrayZDayReport valueForKey:@"date"];
        NSString *dateString;
        NSString *str_time;
        
        if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"time_format"] isEqualToString:@"12"])
        {
            
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
            
            
            //        NSDate *currDate = [NSDate date];
            
            NSDate *currDate = zdayDate;
            
            NSString *str_timeZone=nil;
            
            if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"language"]isEqualToString:@"EN"]) {
                
                str_timeZone=@"GMT";
            }
            else
            {
                str_timeZone=@"CET";
            }
            
            //        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:str_timeZone]];
            
            [dateFormatter setDateFormat:@"MMM"];
            
            NSString *str_month = [dateFormatter stringFromDate:currDate];
            
            
            if([str_month isEqualToString:@"Jan"])
            {
                str_month=[Language get:@"Jan" alter:@"!Jan"];
            }
            else if([str_month isEqualToString:@"Feb"])
            {
                str_month=[Language get:@"Feb" alter:@"!Feb"];
            }
            else if([str_month isEqualToString:@"Mar"])
            {
                str_month=[Language get:@"Mar" alter:@"!Mar"];
            }
            else if([str_month isEqualToString:@"Apr"])
            {
                str_month=[Language get:@"Apr" alter:@"!Apr"];
            }
            else if([str_month isEqualToString:@"May"])
            {
                str_month=[Language get:@"May" alter:@"!May"];
            }
            else if([str_month isEqualToString:@"Jun"])
            {
                str_month=[Language get:@"Jun" alter:@"!Jun"];
            }
            else if([str_month isEqualToString:@"Jul"])
            {
                str_month=[Language get:@"Jul" alter:@"!Jul"];
            }
            else if([str_month isEqualToString:@"Aug"])
            {
                str_month=[Language get:@"Aug" alter:@"!Aug"];
            }
            else if([str_month isEqualToString:@"Sep"])
            {
                str_month=[Language get:@"Sep" alter:@"!Sep"];
            }
            else if([str_month isEqualToString:@"Oct"])
            {
                str_month=[Language get:@"Oct" alter:@"!Oct"];
            }
            else if([str_month isEqualToString:@"Nov"])
            {
                str_month=[Language get:@"Nov" alter:@"!Nov"];
            }
            else if([str_month isEqualToString:@"Dec"])
            {
                str_month=[Language get:@"Dec" alter:@"!Dec"];
            }
            
            [dateFormatter setDateFormat:@"dd"];
            
            NSString *str_day = [dateFormatter stringFromDate:currDate];
            
            [dateFormatter setDateFormat:@"yyyy"];
            
            NSString *str_year = [dateFormatter stringFromDate:currDate];
            
            [dateFormatter setDateFormat:@"hh:mm a"];
            
            str_time = [dateFormatter stringFromDate:currDate];
            
            dateString=[NSString stringWithFormat:@"%@ %@ %@",str_day,str_month,str_year];
            
        
            
        }
        else{
            
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
            
            NSDate *currDate = zdayDate;
            
            
            NSString *str_timeZone=nil;
            
            if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"language"]isEqualToString:@"EN"]) {
                
                str_timeZone=@"GMT";
            }
            else
            {
                str_timeZone=@"CET";
            }
            
            
            [dateFormatter setDateFormat:@"MMM"];
            
            NSString *str_month = [dateFormatter stringFromDate:currDate];
            
            
            if([str_month isEqualToString:@"Jan"])
            {
                str_month=[Language get:@"Jan" alter:@"!Jan"];
            }
            else if([str_month isEqualToString:@"Feb"])
            {
                str_month=[Language get:@"Feb" alter:@"!Feb"];
            }
            else if([str_month isEqualToString:@"Mar"])
            {
                str_month=[Language get:@"Mar" alter:@"!Mar"];
            }
            else if([str_month isEqualToString:@"Apr"])
            {
                str_month=[Language get:@"Apr" alter:@"!Apr"];
            }
            else if([str_month isEqualToString:@"May"])
            {
                str_month=[Language get:@"May" alter:@"!May"];
            }
            else if([str_month isEqualToString:@"Jun"])
            {
                str_month=[Language get:@"Jun" alter:@"!Jun"];
            }
            else if([str_month isEqualToString:@"Jul"])
            {
                str_month=[Language get:@"Jul" alter:@"!Jul"];
            }
            else if([str_month isEqualToString:@"Aug"])
            {
                str_month=[Language get:@"Aug" alter:@"!Aug"];
            }
            else if([str_month isEqualToString:@"Sep"])
            {
                str_month=[Language get:@"Sep" alter:@"!Sep"];
            }
            else if([str_month isEqualToString:@"Oct"])
            {
                str_month=[Language get:@"Oct" alter:@"!Oct"];
            }
            else if([str_month isEqualToString:@"Nov"])
            {
                str_month=[Language get:@"Nov" alter:@"!Nov"];
            }
            else if([str_month isEqualToString:@"Dec"])
            {
                str_month=[Language get:@"Dec" alter:@"!Dec"];
            }

            
            [dateFormatter setDateFormat:@"dd"];
            
            NSString *str_day = [dateFormatter stringFromDate:currDate];
            
            [dateFormatter setDateFormat:@"yyyy"];
            
            NSString *str_year = [dateFormatter stringFromDate:currDate];
            
            [dateFormatter setDateFormat:@"HH:mm"];
            
            str_time = [dateFormatter stringFromDate:currDate];
            
            dateString=[NSString stringWithFormat:@"%@ %@ %@",str_day,str_month,str_year];
       
        }

        NSString *date=[NSString stringWithFormat:@"\n%@: %@ %@\n"
                        "--------------------------------\n",[Language get:@"Date and Time" alter:@"!Date and Time"],dateString,str_time];
        
        NSData* dataDate = [date dataUsingEncoding:NSWindowsCP1252StringEncoding];
        [commands appendBytes:"\x1b\x74\x11" length:sizeof("\x1b\x74\x11") - 1];
        [commands appendData:dataDate];
        
//        [commands appendBytes:"\x1b\x45\x01"
//                       length:sizeof("\x1b\x45\x01") - 1];    // Set Emphasized Printing ON
        
        float totalPayment=0.0;
        
        totalPayment=([[appDelegate.arrayZDayReport valueForKey:@"cashPayment"] floatValue]+[[appDelegate.arrayZDayReport valueForKey:@"cardPayment"] floatValue]+[[appDelegate.arrayZDayReport valueForKey:@"swishPayment"] floatValue]+[[appDelegate.arrayZDayReport valueForKey:@"othePayment"] floatValue]);
        
        [commands appendData:[[NSString stringWithFormat:@"%@ %@ %0.2f\n",[Language get:@"Total sale amount:" alter:@"!Total sale amount:"],str_cur,totalPayment] dataUsingEncoding:NSWindowsCP1252StringEncoding]];
        
        [commands appendBytes:"\x1b\x74\x11" length:sizeof("\x1b\x74\x11") - 1];
        
        
        [commands appendData:[[NSString stringWithFormat:@"%@ %@ %@\n",[Language get:@"Cash sale amount:" alter:@"!Cash sale amount:"],str_cur,[appDelegate.arrayZDayReport valueForKey:@"cashPayment"]] dataUsingEncoding:NSWindowsCP1252StringEncoding]];
        
        [commands appendBytes:"\x1b\x74\x11" length:sizeof("\x1b\x74\x11") - 1];
        
        
        [commands appendData:[[NSString stringWithFormat:@"%@ %@ %@\n",[Language get:@"Card sale amount:" alter:@"!Card sale amount:"],str_cur,[appDelegate.arrayZDayReport valueForKey:@"cardPayment"]] dataUsingEncoding:NSWindowsCP1252StringEncoding]];
        
        [commands appendBytes:"\x1b\x74\x11" length:sizeof("\x1b\x74\x11") - 1];
        
        
        [commands appendData:[[NSString stringWithFormat:@"%@ %@ %@\n",[Language get:@"Swish sale amount:" alter:@"!Swish sale amount:"],str_cur,[appDelegate.arrayZDayReport valueForKey:@"swishPayment"]] dataUsingEncoding:NSWindowsCP1252StringEncoding]];
        
        [commands appendBytes:"\x1b\x74\x11" length:sizeof("\x1b\x74\x11") - 1];
        
        
        [commands appendData:[[NSString stringWithFormat:@"%@ %@ %@\n",[Language get:@"Other sale amount:" alter:@"!Other sale amount:"],str_cur,[appDelegate.arrayZDayReport valueForKey:@"otherPayment"]] dataUsingEncoding:NSWindowsCP1252StringEncoding]];
        
        [commands appendBytes:"\x1b\x74\x11" length:sizeof("\x1b\x74\x11") - 1];
        
        
        [commands appendData:[[NSString stringWithFormat:@"%@ %@\n",[Language get:@"Number of cash payments:" alter:@"!Number of cash payments:"],[appDelegate.arrayZDayReport valueForKey:@"totalCashPayments"]] dataUsingEncoding:NSWindowsCP1252StringEncoding]];
        
        [commands appendBytes:"\x1b\x74\x11" length:sizeof("\x1b\x74\x11") - 1];
        

        [commands appendData:[[NSString stringWithFormat:@"%@ %@\n",[Language get:@"Number of card payments:" alter:@"!Number of card payments:"],[appDelegate.arrayZDayReport valueForKey:@"totalCardPayments"]] dataUsingEncoding:NSWindowsCP1252StringEncoding]];
        
        [commands appendBytes:"\x1b\x74\x11" length:sizeof("\x1b\x74\x11") - 1];
        
        
        [commands appendData:[[NSString stringWithFormat:@"%@ %@\n",[Language get:@"Number of swish payments:" alter:@"!Number of swish payments:"],[appDelegate.arrayZDayReport valueForKey:@"totalSwishPayments"]] dataUsingEncoding:NSWindowsCP1252StringEncoding]];
        
        [commands appendBytes:"\x1b\x74\x11" length:sizeof("\x1b\x74\x11") - 1];
        
        
        [commands appendData:[[NSString stringWithFormat:@"%@ %@\n",[Language get:@"Number of other payments:" alter:@"!Number of other payments:"],[appDelegate.arrayZDayReport valueForKey:@"totalOtherPayments"]] dataUsingEncoding:NSWindowsCP1252StringEncoding]];
        
        [commands appendBytes:"\x1b\x74\x11" length:sizeof("\x1b\x74\x11") - 1];
        
        
        [commands appendData:[[NSString stringWithFormat:@"%@ %@\n", [Language get:@"Total products:" alter:@"!Total products:"],[appDelegate.arrayZDayReport valueForKey:@"totalProduct"]] dataUsingEncoding:NSWindowsCP1252StringEncoding]];
        
        [commands appendBytes:"\x1b\x74\x11" length:sizeof("\x1b\x74\x11") - 1];
        
        
        [commands appendData:[[NSString stringWithFormat:@"%@ %@\n", [Language get:@"Starting cash value:" alter:@"!Starting cash value:"],[[NSUserDefaults standardUserDefaults] valueForKey:@"ExchangePrice"]?[[NSUserDefaults standardUserDefaults] valueForKey:@"ExchangePrice"]:@"0"] dataUsingEncoding:NSWindowsCP1252StringEncoding]];
        
        [commands appendBytes:"\x1b\x74\x11" length:sizeof("\x1b\x74\x11") - 1];
        
        
        [commands appendData:[[NSString stringWithFormat:@"%@ %@\n", [Language get:@"Number of receipts mailed:" alter:@"!Number of receipts mailed:"],[appDelegate.arrayZDayReport  valueForKey:@"totalEmail"]]dataUsingEncoding:NSWindowsCP1252StringEncoding]];
        
        [commands appendBytes:"\x1b\x74\x11" length:sizeof("\x1b\x74\x11") - 1];
        
        
        [commands appendData:[[NSString stringWithFormat:@"%@ %@\n", [Language get:@"Number of copies mailed:" alter:@"!Number of copies mailed:"],[appDelegate.arrayZDayReport  valueForKey:@"totalEmailCopies"]]dataUsingEncoding:NSWindowsCP1252StringEncoding]];
    
        [commands appendBytes:"\x1b\x74\x11" length:sizeof("\x1b\x74\x11") - 1];
        
        //megha
        [commands appendData:[[NSString stringWithFormat:@"%@ %@\n", [Language get:@"Total amount in copies mailed:" alter:@"!Total amount in copies mailed:"],[appDelegate.arrayZDayReport  valueForKey:@"totalCopyMailAmount"]]dataUsingEncoding:NSWindowsCP1252StringEncoding]];
        
        [commands appendBytes:"\x1b\x74\x11" length:sizeof("\x1b\x74\x11") - 1];

        
        [commands appendData:[[NSString stringWithFormat:@"%@ %@\n", [Language get:@"Number of receipts printed:" alter:@"!Number of receipts printed:"],[appDelegate.arrayZDayReport  valueForKey:@"totalPrint"]] dataUsingEncoding:NSWindowsCP1252StringEncoding]];
        
        [commands appendBytes:"\x1b\x74\x11" length:sizeof("\x1b\x74\x11") - 1];
        
        
       [commands appendData:[[NSString stringWithFormat:@"%@ %@\n", [Language get:@"Number of copies printed:" alter:@"!Number of copies printed:"],[appDelegate.arrayZDayReport  valueForKey:@"totalPrintCopies"]]dataUsingEncoding:NSWindowsCP1252StringEncoding]];
        
        [commands appendBytes:"\x1b\x74\x11" length:sizeof("\x1b\x74\x11") - 1];
        
        //megha
       
        [commands appendData:[[NSString stringWithFormat:@"%@ %@\n", [Language get:@"Total amount in copies printed:" alter:@"!Total amount in copies printed:"],[appDelegate.arrayZDayReport  valueForKey:@"totalCopyPrintAmount"]]dataUsingEncoding:NSWindowsCP1252StringEncoding]];
        
        [commands appendBytes:"\x1b\x74\x11" length:sizeof("\x1b\x74\x11") - 1];
        
        [commands appendData:[[NSString stringWithFormat:@"%@ %@\n", [Language get:@"Number of total refunds:" alter:@"!Number of total refunds:"],[appDelegate.arrayZDayReport valueForKey:@"refundcount"]] dataUsingEncoding:NSWindowsCP1252StringEncoding]];
        
        [commands appendBytes:"\x1b\x74\x11" length:sizeof("\x1b\x74\x11") - 1];
        
        
        [commands appendData:[[NSString stringWithFormat:@"%@ -%@%@\n", [Language get:@"Total refunds:" alter:@"!Total refunds:"],str_cur,[appDelegate.arrayZDayReport valueForKey:@"refund"]] dataUsingEncoding:NSWindowsCP1252StringEncoding]];
        
        [commands appendBytes:"\x1b\x74\x11" length:sizeof("\x1b\x74\x11") - 1];
        
        
        NSDictionary *receiptArray_details = [[appDelegate.arrayZDayReport valueForKey:@"sub"] objectAtIndex:0];
        
        [commands appendData:[[NSString stringWithFormat:@"%@      %@ %@\n", [Language get:@"VAT:" alter:@"!VAT:"],str_cur,[appDelegate.arrayZDayReport valueForKey:@"vat"]] dataUsingEncoding:NSWindowsCP1252StringEncoding]];
        
        [commands appendBytes:"\x1b\x74\x11" length:sizeof("\x1b\x74\x11") - 1];
        
        
        [commands appendData:[[NSString stringWithFormat:@"%@ -%@ %@\n", [Language get:@"Discounts:" alter:@"!Discounts:"],str_cur,[appDelegate.arrayZDayReport valueForKey:@"discunts"]] dataUsingEncoding:NSWindowsCP1252StringEncoding]];
        
        [commands appendBytes:"\x1b\x74\x11" length:sizeof("\x1b\x74\x11") - 1];
        
        
        [commands appendData:[[NSString stringWithFormat:@"%@: %@ %@ \n",[Language get:@"Grand total sales" alter:@"!Grand total sales"],str_cur,[appDelegate.arrayZDayReport valueForKey:@"grandTotalSale"]] dataUsingEncoding:NSWindowsCP1252StringEncoding]];
        
        [commands appendBytes:"\x1b\x74\x11" length:sizeof("\x1b\x74\x11") - 1];
        
        
        [commands appendData:[[NSString stringWithFormat:@"%@: -%@ %@\n", [Language get:@"Grand total refund" alter:@"!Grand total refund"],str_cur,[appDelegate.arrayZDayReport valueForKey:@"grandTotalRefund"]] dataUsingEncoding:NSWindowsCP1252StringEncoding]];
        
        [commands appendBytes:"\x1b\x74\x11" length:sizeof("\x1b\x74\x11") - 1];
        
        
        [commands appendData:[[NSString stringWithFormat:@"%@: %@ %@\n", [Language get:@"Grand total sales-refund" alter:@"!Grand total sales-refund"],str_cur,[appDelegate.arrayZDayReport  valueForKey:@"grandtotalSale_Refund"]] dataUsingEncoding:NSWindowsCP1252StringEncoding]];
        
        [commands appendBytes:"\x1b\x74\x11" length:sizeof("\x1b\x74\x11") - 1];
   
    }
    else
    {
      
        NSString *date=[NSString stringWithFormat:@"\n%@: %@ \n"
                        "----------------------------\n",[Language get:@"Date" alter:@"!Date"],[[NSUserDefaults standardUserDefaults] valueForKey:@"totalTime"]];
        
        NSData* dataDate = [date dataUsingEncoding:NSWindowsCP1252StringEncoding];
        
        [commands appendBytes:"\x1b\x74\x11" length:sizeof("\x1b\x74\x11") - 1];
        
        [commands appendData:dataDate];
        
        [commands appendData:[[NSString stringWithFormat:@"%@ %@\n", [Language get:@"Total sale amount:" alter:@"!Total sale amount:"],[[NSUserDefaults standardUserDefaults] valueForKey:@"cashPayment"]] dataUsingEncoding:NSWindowsCP1252StringEncoding]];
        [commands appendBytes:"\x1b\x74\x11" length:sizeof("\x1b\x74\x11") - 1];
        
        
        [commands appendData:[[NSString stringWithFormat:@"%@ %@ %@\n", [Language get:@"Cash sale amount:" alter:@"!Cash sale amount:"],str_cur,[[NSUserDefaults standardUserDefaults] valueForKey:@"totalSumCash"]] dataUsingEncoding:NSWindowsCP1252StringEncoding]];
        
        [commands appendBytes:"\x1b\x74\x11" length:sizeof("\x1b\x74\x11") - 1];
        
        
        [commands appendData:[[NSString stringWithFormat:@"%@ %@ %@\n", [Language get:@"Card sale amount:" alter:@"!Card sale amount:"],str_cur,[[NSUserDefaults standardUserDefaults] valueForKey:@"totalSumCard"]] dataUsingEncoding:NSWindowsCP1252StringEncoding]];
        
        [commands appendBytes:"\x1b\x74\x11" length:sizeof("\x1b\x74\x11") - 1];
        
        
        [commands appendData:[[NSString stringWithFormat:@"%@ %@ %@\n", [Language get:@"Swish sale amount:" alter:@"!Swish sale amount:"],str_cur,[[NSUserDefaults standardUserDefaults] valueForKey:@"totalSumSwish"]] dataUsingEncoding:NSWindowsCP1252StringEncoding]];
        
        [commands appendBytes:"\x1b\x74\x11" length:sizeof("\x1b\x74\x11") - 1];
        
        
        [commands appendData:[[NSString stringWithFormat:@"%@ %@ %@\n", [Language get:@"Other sale amount:" alter:@"!Other sale amount:"],str_cur,[[NSUserDefaults standardUserDefaults] valueForKey:@"totalSumOther"]] dataUsingEncoding:NSWindowsCP1252StringEncoding]];
        
        [commands appendBytes:"\x1b\x74\x11" length:sizeof("\x1b\x74\x11") - 1];
        
        
        [commands appendData:[[NSString stringWithFormat:@"%@ %@\n", [Language get:@"Number of cash payments:" alter:@"!Number of cash payments:"],[[NSUserDefaults standardUserDefaults] valueForKey:@"cashPayments"]] dataUsingEncoding:NSWindowsCP1252StringEncoding]];
        
        [commands appendBytes:"\x1b\x74\x11" length:sizeof("\x1b\x74\x11") - 1];
        
        
        [commands appendData:[[NSString stringWithFormat:@"%@ %@\n", [Language get:@"Number of card payments:" alter:@"!Number of card payments:"],[[NSUserDefaults standardUserDefaults] valueForKey:@"cardPayments"]] dataUsingEncoding:NSWindowsCP1252StringEncoding]];
        
        [commands appendBytes:"\x1b\x74\x11" length:sizeof("\x1b\x74\x11") - 1];
        
        
        [commands appendData:[[NSString stringWithFormat:@"%@ %@\n", [Language get:@"Number of swish payments:" alter:@"!Number of swish payments:"],[[NSUserDefaults standardUserDefaults] valueForKey:@"swishPayment"]] dataUsingEncoding:NSWindowsCP1252StringEncoding]];
        
        [commands appendBytes:"\x1b\x74\x11" length:sizeof("\x1b\x74\x11") - 1];
        
        
        [commands appendData:[[NSString stringWithFormat:@"%@ %@\n", [Language get:@"Number of other payments:" alter:@"!Number of other payments:"],[[NSUserDefaults standardUserDefaults] valueForKey:@"otherPayment"]] dataUsingEncoding:NSWindowsCP1252StringEncoding]];
        
        [commands appendBytes:"\x1b\x74\x11" length:sizeof("\x1b\x74\x11") - 1];
        
        
        [commands appendData:[[NSString stringWithFormat:@"%@ %@\n", [Language get:@"Total products:" alter:@"!Total products:"],[[NSUserDefaults standardUserDefaults] valueForKey:@"productCount"]] dataUsingEncoding:NSWindowsCP1252StringEncoding]];
        
        [commands appendBytes:"\x1b\x74\x11" length:sizeof("\x1b\x74\x11") - 1];
        
        
        [commands appendData:[[NSString stringWithFormat:@"%@ %@\n", [Language get:@"Starting cash value:" alter:@"!Starting cash value:"],[[NSUserDefaults standardUserDefaults] valueForKey:@"ExchangePrice"]?[[NSUserDefaults standardUserDefaults] valueForKey:@"ExchangePrice"]:@"0"] dataUsingEncoding:NSWindowsCP1252StringEncoding]];
        
        [commands appendBytes:"\x1b\x74\x11" length:sizeof("\x1b\x74\x11") - 1];

        
        [commands appendData:[[NSString stringWithFormat:@"%@ %@\n", [Language get:@"Number of receipts mailed:" alter:@"!Number of receipts mailed:"],[[appDelegate.arrayGlobalData objectAtIndex:0] valueForKey:@"originalMail"]]dataUsingEncoding:NSWindowsCP1252StringEncoding]];
        
        [commands appendBytes:"\x1b\x74\x11" length:sizeof("\x1b\x74\x11") - 1];
        
        
        [commands appendData:[[NSString stringWithFormat:@"%@ %@\n", [Language get:@"Number of copies mailed:" alter:@"!Number of copies mailed:"],[[appDelegate.arrayGlobalData objectAtIndex:0] valueForKey:@"copyMail"]]dataUsingEncoding:NSWindowsCP1252StringEncoding]];
        
        [commands appendBytes:"\x1b\x74\x11" length:sizeof("\x1b\x74\x11") - 1];
        
        
        //megha
        [commands appendData:[[NSString stringWithFormat:@"%@ %@\n", [Language get:@"Total amount in copies mailed:" alter:@"!Total amount in copies mailed:"],[[appDelegate.arrayGlobalData objectAtIndex:0] valueForKey:@"totalCopyMailAmount"]]dataUsingEncoding:NSWindowsCP1252StringEncoding]];
    
        
        [commands appendData:[[NSString stringWithFormat:@"%@ %@\n", [Language get:@"Number of receipts printed:" alter:@"!Number of receipts printed:"],[[appDelegate.arrayGlobalData objectAtIndex:0] valueForKey:@"originalPrint"]] dataUsingEncoding:NSWindowsCP1252StringEncoding]];
        
        [commands appendBytes:"\x1b\x74\x11" length:sizeof("\x1b\x74\x11") - 1];
        
        
        [commands appendData:[[NSString stringWithFormat:@"%@ %@\n", [Language get:@"Number of copies printed:" alter:@"!Number of copies printed:"],[[appDelegate.arrayGlobalData objectAtIndex:0] valueForKey:@"copyPrint"]] dataUsingEncoding:NSWindowsCP1252StringEncoding]];
        
        [commands appendBytes:"\x1b\x74\x11" length:sizeof("\x1b\x74\x11") - 1];

        //megha
        [commands appendData:[[NSString stringWithFormat:@"%@ %@\n", [Language get:@"Total amount in copies printed:" alter:@"!Total amount in copies printed:"],[[appDelegate.arrayGlobalData objectAtIndex:0]  valueForKey:@"totalCopyPrintAmount"]]dataUsingEncoding:NSWindowsCP1252StringEncoding]];
        
        
        [commands appendData:[[NSString stringWithFormat:@"%@ %@\n", [Language get:@"Number of total refunds:" alter:@"!Number of total refunds:"],[[NSUserDefaults standardUserDefaults] valueForKey:@"totalRefundCount"]] dataUsingEncoding:NSWindowsCP1252StringEncoding]];
        
        [commands appendBytes:"\x1b\x74\x11" length:sizeof("\x1b\x74\x11") - 1];
        
        
        [commands appendData:[[NSString stringWithFormat:@"%@ %@\n", [Language get:@"Total refunds:" alter:@"!Total refunds:"],[[NSUserDefaults standardUserDefaults] valueForKey:@"totalRefund"]] dataUsingEncoding:NSWindowsCP1252StringEncoding]];
        [commands appendBytes:"\x1b\x74\x11" length:sizeof("\x1b\x74\x11") - 1];
        

        NSDictionary *receiptArray_details = [[appDelegate.arrayZDayReport valueForKey:@"sub"] objectAtIndex:0];
        
        [commands appendData:[[NSString stringWithFormat:@"%@      %@ %@\n", [Language get:@"VAT:" alter:@"!VAT:"],str_cur,[[NSUserDefaults standardUserDefaults] valueForKey:@"totalVat"]] dataUsingEncoding:NSWindowsCP1252StringEncoding]];
        
        [commands appendBytes:"\x1b\x74\x11" length:sizeof("\x1b\x74\x11") - 1];
        
        
        [commands appendData:[[NSString stringWithFormat:@"%@ %@\n", [Language get:@"Discounts:" alter:@"!Discounts:"],[[NSUserDefaults standardUserDefaults] valueForKey:@"totaldiscount"]] dataUsingEncoding:NSWindowsCP1252StringEncoding]];
        
        [commands appendBytes:"\x1b\x74\x11" length:sizeof("\x1b\x74\x11") - 1];
        
        
        [commands appendData:[[NSString stringWithFormat:@"%@: %@ %@ \n",[Language get:@"Grand total sales" alter:@"!Grand total sales"],str_cur,[[NSUserDefaults standardUserDefaults] valueForKey:@"grandTotalSale"]] dataUsingEncoding:NSWindowsCP1252StringEncoding]];
        
        [commands appendBytes:"\x1b\x74\x11" length:sizeof("\x1b\x74\x11") - 1];
        
        
        [commands appendData:[[NSString stringWithFormat:@"%@: -%@ %@\n", [Language get:@"Grand total refund" alter:@"!Grand total refund"],str_cur,[[NSUserDefaults standardUserDefaults] valueForKey:@"grandTotalRefund"]] dataUsingEncoding:NSWindowsCP1252StringEncoding]];
        
        [commands appendBytes:"\x1b\x74\x11" length:sizeof("\x1b\x74\x11") - 1];

        
        [commands appendData:[[NSString stringWithFormat:@"%@: %@ %@\n", [Language get:@"Grand total sales-refund" alter:@"!Grand total sales-refund"],str_cur,[[NSUserDefaults standardUserDefaults] valueForKey:@"grandTotalSale_Refund"]] dataUsingEncoding:NSWindowsCP1252StringEncoding]];
        
        
        
    }
    [commands appendBytes:"\x1b\x74\x11" length:sizeof("\x1b\x74\x11") - 1];
    

    NSMutableString *str_sign1 = [[NSMutableString alloc] init];
    if ([self validateDictionaryValueForKey:[dictHeaderFooter valueForKey:@"row6"]]) {
        [str_sign1 appendFormat:@"%@\n",[dictHeaderFooter valueForKey:@"row6"]];
    }
    
    if ([self validateDictionaryValueForKey:[dictHeaderFooter valueForKey:@"row7"]]) {
        [str_sign1 appendFormat:@"%@\n",[dictHeaderFooter valueForKey:@"row7"]];
    }
    if ([self validateDictionaryValueForKey:[dictHeaderFooter valueForKey:@"row8"]]) {
        [str_sign1 appendFormat:@"%@\n",[dictHeaderFooter valueForKey:@"row8"]];
    }
    if ([self validateDictionaryValueForKey:[dictHeaderFooter valueForKey:@"row9"]]) {
        [str_sign1 appendFormat:@"%@\n",[dictHeaderFooter valueForKey:@"row9"]];
    }
    if ([self validateDictionaryValueForKey:[dictHeaderFooter valueForKey:@"row10"]]) {
        [str_sign1 appendFormat:@"%@\n",[dictHeaderFooter valueForKey:@"row10"]];
    }
    
    
    NSLog(@"Printer value--: %@",str_sign1);
    NSData* dataSign = [str_sign1 dataUsingEncoding:NSWindowsCP1252StringEncoding];

    
    [commands appendBytes:"\x1b\x74\x11" length:sizeof("\x1b\x74\x11") - 1];
    
        [commands appendData:dataSign];
    
        
        [commands appendData:[@"\n\n\n\n\n" dataUsingEncoding:NSWindowsCP1252StringEncoding]];
        
        return commands;
        
    
}


+ (NSData *)printMerchantReceipt{
    NSMutableData *commands = [[NSMutableData new] autorelease];
    
    NSMutableString *str_emailFormat=[[NSMutableString alloc] init];
   AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [commands appendBytes:"\x1b\x61\x00"
                   length:sizeof("\x1b\x61\x00") - 1];
    //Butikens kvitto Betalning = The store's receipt of payment
    [str_emailFormat appendFormat:@" %@ \n %@ \n %@ %@ \n %@ \n %@ \n\n ",[appDelegate.receipt_paymentDetails_copy  valueForKey:@"Name"],[appDelegate.receipt_paymentDetails_copy valueForKey:@"Address"],[appDelegate.receipt_paymentDetails_copy valueForKey:@"Zip"],[appDelegate.receipt_paymentDetails_copy valueForKey:@"City"],[appDelegate.receipt_paymentDetails_copy valueForKey:@"Country"],[appDelegate.receipt_paymentDetails_copy valueForKey:@"Contact"]];
    
    [str_emailFormat appendFormat:@"%@ \n %@ \n %@ %@ \n",[Language get:@"The store's receipt of payment" alter:@"!The store's receipt of payment"],[appDelegate.receipt_paymentDetails_copy valueForKey:@"Amount"],[appDelegate.receipt_paymentDetails_copy valueForKey:@"Date"],[appDelegate.receipt_paymentDetails_copy valueForKey:@"Time"]];
    
    [str_emailFormat appendFormat:@" %@ \n %@ \n AID %@ \n %@ %@ \n\n",[appDelegate.receipt_paymentDetails_copy valueForKey:@"Card"],[appDelegate.receipt_paymentDetails_copy valueForKey:@"Account"],[appDelegate.receipt_paymentDetails_copy valueForKey:@"AID"],[Language get:@"Entry Mode" alter:@"!Entry Mode"],[appDelegate.receipt_paymentDetails_copy valueForKey:@"Entry Mode"]];
    
    [str_emailFormat appendFormat:@" %@ : %@ \n",[Language get:@"Transactions" alter:@"!Transactions"],[appDelegate.receipt_paymentDetails_copy valueForKey:@"Transaction"]];
    [str_emailFormat appendFormat:@" %@ : %@ \n",[Language get:@"Authorization" alter:@"!Authorization"],[appDelegate.receipt_paymentDetails_copy valueForKey:@"Authorization"]];
    
    [str_emailFormat appendFormat:@" %@ : %@ \n",[Language get:@"Checkout ID" alter:@"!Checkout ID"],[appDelegate.receipt_paymentDetails_copy valueForKey:@"Merchant ID"]];

    [str_emailFormat appendFormat:@" Terminal ID : %@ \n",[appDelegate.receipt_paymentDetails_copy valueForKey:@"Terminal ID"]];

    [str_emailFormat appendFormat:@" PWID : %@ \n      : %@\n\n",[appDelegate.receipt_paymentDetails_copy valueForKey:@"pwid_part1"],[appDelegate.receipt_paymentDetails_copy valueForKey:@"pwid_part2"]];
    [str_emailFormat appendFormat:@" %@ \n\n",[Language get:@"Keep the receipt" alter:@"!Keep the receipt"]];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"ShowSignature"])
    {
        [str_emailFormat appendFormat:@"-----------%@------------\n\n\n\n\n",[Language get:@"Sign Here" alter:@"!Sign Here"]];
        [str_emailFormat appendFormat:@"--------------------------------\n\n\n\n"];
        NSData *datastr_emailFormat = [str_emailFormat dataUsingEncoding:NSWindowsCP1252StringEncoding];
        [commands appendBytes:"\x1b\x74\x11" length:sizeof("\x1b\x74\x11") - 1];
        [commands appendData:datastr_emailFormat];
    }
    
    
    return commands;
    
}



#pragma mark Log Print format

+ (NSData *)create_LogPrint_Format
{
    {
        {

            
            AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];

            NSString *currencySign=nil;
            
         
            
            NSString *str_cur;
            
            if ([currencySign isEqualToString:@"$"]) {
                
                str_cur=@"$";
                
            }else if ([currencySign isEqualToString:@"€"]) {
                
                char utf8[]  = "\xE2\x82\xac";
               
                str_cur=@"\u20ac";
                
            } else if ([currencySign isEqualToString:@"SEK"]) {
                
                str_cur=@"SEK";
            }
            else
            {
                str_cur=@"$";
            }
            
            
            char utf8[]  = "\xE2\x82\xac";
            char utf16[] = "\x20\xAC";
            NSLog(@"utf8:  %@", [[NSString alloc] initWithBytes:utf8 length:3 encoding:NSUTF8StringEncoding]);
            NSLog(@"utf16: %@", [[NSString alloc] initWithBytes:utf16 length:2 encoding:NSUTF16BigEndianStringEncoding]);
            
            NSString *cost = @"156.95 \xE2\x82\xac\r\n"; // dataUsingEncoding:NSUTF8StringEncoding]];
        
            
            NSMutableData *commandsw = [NSMutableData new];
            [commandsw appendData:[@"156.95 \xE2\x82\xac\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
   
            
            NSManagedObjectContext *context =[appDelegate managedObjectContext];
            NSEntityDescription *entityDesc =[NSEntityDescription entityForName:@"ReceiptData" inManagedObjectContext:context];
            NSFetchRequest *request = [[NSFetchRequest alloc] init];
            [request setEntity:entityDesc];
            NSPredicate *pred =[NSPredicate predicateWithFormat:@"(id = %@)",@"1"];
            [request setPredicate:pred];
            NSError *error;
            NSArray *objects = [context executeFetchRequest:request error:&error];
            //    NSManagedObject *person = (NSManagedObject *)[objects objectAtIndex:0];
            
            NSMutableDictionary *dictHeaderFooter = [NSMutableDictionary new];
            
            if (objects.count == 0)
            {
                [dictHeaderFooter setValue:@"" forKey:@"organization_name"];
                [dictHeaderFooter setValue:@"" forKey:@"company_name"];
                [dictHeaderFooter setValue:@"" forKey:@"address1"];
                [dictHeaderFooter setValue:@"" forKey:@"address2"];
                [dictHeaderFooter setValue:@"" forKey:@"zipcode"];
                [dictHeaderFooter setValue:@"" forKey:@"city"];
                [dictHeaderFooter setValue:@"" forKey:@"phone"];
                [dictHeaderFooter setValue:@"" forKey:@"fax"];
                [dictHeaderFooter setValue:@"" forKey:@"homepage"];
                
                [dictHeaderFooter setValue:@"" forKey:@"row1"];
                [dictHeaderFooter setValue:@"" forKey:@"row2"];
                [dictHeaderFooter setValue:@"" forKey:@"row3"];
                [dictHeaderFooter setValue:@"" forKey:@"row4"];
                [dictHeaderFooter setValue:@"" forKey:@"row5"];
                [dictHeaderFooter setValue:@"" forKey:@"row6"];
                [dictHeaderFooter setValue:@"" forKey:@"row7"];
                [dictHeaderFooter setValue:@"" forKey:@"row8"];
                [dictHeaderFooter setValue:@"" forKey:@"row9"];
                [dictHeaderFooter setValue:@"" forKey:@"row10"];
            }
            else
            {
                for(int i=0;i<objects.count;i++)
                {
                    NSManagedObject *person = (NSManagedObject *)[objects objectAtIndex:i];
                    
                    [dictHeaderFooter setValue:[person valueForKey:@"organization_name"] forKey:@"organization_name"];
                    [dictHeaderFooter setValue:[person valueForKey:@"company_name"] forKey:@"company_name"];
                    [dictHeaderFooter setValue:[person valueForKey:@"address1"] forKey:@"address1"];
                    [dictHeaderFooter setValue:[person valueForKey:@"address2"] forKey:@"address2"];
                    [dictHeaderFooter setValue:[person valueForKey:@"zipcode"] forKey:@"zipcode"];
                    [dictHeaderFooter setValue:[person valueForKey:@"city"] forKey:@"city"];
                    [dictHeaderFooter setValue:[person valueForKey:@"phone"] forKey:@"phone"];
                    [dictHeaderFooter setValue:[person valueForKey:@"fax"] forKey:@"fax"];
                    [dictHeaderFooter setValue:[person valueForKey:@"homepage"] forKey:@"homepage"];
                    
                    [dictHeaderFooter setValue:[person valueForKey:@"row1"] forKey:@"row1"];
                    [dictHeaderFooter setValue:[person valueForKey:@"row2"] forKey:@"row2"];
                    [dictHeaderFooter setValue:[person valueForKey:@"row3"] forKey:@"row3"];
                    [dictHeaderFooter setValue:[person valueForKey:@"row4"] forKey:@"row4"];
                    [dictHeaderFooter setValue:[person valueForKey:@"row5"] forKey:@"row5"];
                    [dictHeaderFooter setValue:[person valueForKey:@"row6"] forKey:@"row6"];
                    [dictHeaderFooter setValue:[person valueForKey:@"row7"] forKey:@"row7"];
                    [dictHeaderFooter setValue:[person valueForKey:@"row8"] forKey:@"row8"];
                    [dictHeaderFooter setValue:[person valueForKey:@"row9"] forKey:@"row9"];
                    [dictHeaderFooter setValue:[person valueForKey:@"row10"] forKey:@"row10"];
                }
            }
            
            NSMutableData *commands = [[NSMutableData new] autorelease];
            
            [commands appendBytes:"\x1d\x57\x80\x31"
                           length:sizeof("\x1d\x57\x80\x31") - 1];    // Page Area Setting     <GS> <W> nL nH  (nL = 128, nH = 1)
            
            [commands appendBytes:"\x1b\x61\x01"
                           length:sizeof("\x1b\x61\x01") - 1];    // Center Justification  <ESC> a n       (0 Left, 1 Center, 2 Right)
            
            NSString *str_emailFormat;
            
           
            str_emailFormat  =[NSString stringWithFormat:@"%@\n",[Language get:@"Journal" alter:@"!Journal"]];
            //        }
            
            
            NSData *datastr_emailFormat = [str_emailFormat dataUsingEncoding:NSWindowsCP1252StringEncoding];
            
            [commands appendBytes:"\x1b\x74\x11" length:sizeof("\x1b\x74\x11") - 1];
            
            [commands appendData:datastr_emailFormat];
            
            
            
            NSString *stringHeaderData = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@ %@\n%@ %@\n%@\n%@\n%@\n%@\n%@\n",[dictHeaderFooter valueForKey:@"organization_name"],[dictHeaderFooter valueForKey:@"company_name"], [dictHeaderFooter valueForKey:@"address1"], [dictHeaderFooter valueForKey:@"address2"], [dictHeaderFooter valueForKey:@"city"], [dictHeaderFooter valueForKey:@"zipcode"], [dictHeaderFooter valueForKey:@"phone"], [dictHeaderFooter valueForKey:@"fax"], [dictHeaderFooter valueForKey:@"row1"], [dictHeaderFooter valueForKey:@"row2"], [dictHeaderFooter valueForKey:@"row3"], [dictHeaderFooter valueForKey:@"row4"],[dictHeaderFooter valueForKey:@"row5"]];
            
            
            
            NSData *dataHeader = [stringHeaderData dataUsingEncoding:NSWindowsCP1252StringEncoding];
            [commands appendBytes:"\x1b\x74\x11" length:sizeof("\x1b\x74\x11") - 1];
            [commands appendData:dataHeader];
            
//            if ([[NSUserDefaults standardUserDefaults]valueForKey:@"INFRASEC_PASSWORD"]) {
//                
//                
//                NSString *stringHeaderManRegisterId =[NSString stringWithFormat:@"%@:  %@",[Language get:@"ManRegisterId" alter:@"!ManRegisterId"],[[NSUserDefaults standardUserDefaults]valueForKey:@"INFRASEC_PASSWORD"]];
//                
//                NSData *dataHeaderMan = [stringHeaderManRegisterId dataUsingEncoding:NSWindowsCP1252StringEncoding];
//                [commands appendBytes:"\x1b\x74\x11" length:sizeof("\x1b\x74\x11") - 1];
//                [commands appendData:dataHeaderMan];
//            }
            
            
            if ([[NSUserDefaults standardUserDefaults]valueForKey:@"POS_ID"]) {
                
                
                NSString *stringHeaderManRegisterId =[NSString stringWithFormat:@"%@:  %@",[Language get:@"ManRegisterId" alter:@"!ManRegisterId"],[[NSUserDefaults standardUserDefaults]valueForKey:@"POS_ID"]];
                
                NSData *dataHeaderMan = [stringHeaderManRegisterId dataUsingEncoding:NSWindowsCP1252StringEncoding];
                [commands appendBytes:"\x1b\x74\x11" length:sizeof("\x1b\x74\x11") - 1];
                [commands appendData:dataHeaderMan];
            }

            
            [commands appendBytes:"\x1b\x61\x00"
                           length:sizeof("\x1b\x61\x00") - 1];    // Left Alignment
            
            
            
            
            
            
            
            
            
            NSDateFormatter *dateFormatterd=[[NSDateFormatter alloc] init];
            NSString *dateString;
            
            [dateFormatterd setDateFormat:@"MMM"];
            NSDate *currDate = [NSDate date];
            
            NSString *str_month = nil;
            str_month = [dateFormatterd stringFromDate:currDate];
            
            
            if([str_month isEqualToString:@"Jan"])
            {
                str_month=[Language get:@"Jan" alter:@"!Jan"];
            }
            else if([str_month isEqualToString:@"Feb"])
            {
                str_month=[Language get:@"Feb" alter:@"!Feb"];
            }
            else if([str_month isEqualToString:@"Mar"])
            {
                str_month=[Language get:@"Mar" alter:@"!Mar"];
            }
            else if([str_month isEqualToString:@"Apr"])
            {
                str_month=[Language get:@"Apr" alter:@"!Apr"];
            }
            else if([str_month isEqualToString:@"May"])
            {
                str_month=[Language get:@"May" alter:@"!May"];
            }
            else if([str_month isEqualToString:@"Jun"])
            {
                str_month=[Language get:@"Jun" alter:@"!Jun"];
            }
            else if([str_month isEqualToString:@"Jul"])
            {
                str_month=[Language get:@"Jul" alter:@"!Jul"];
            }
            else if([str_month isEqualToString:@"Aug"])
            {
                str_month=[Language get:@"Aug" alter:@"!Aug"];
            }
            else if([str_month isEqualToString:@"Sep"])
            {
                str_month=[Language get:@"Sep" alter:@"!Sep"];
            }
            else if([str_month isEqualToString:@"Oct"])
            {
                str_month=[Language get:@"Oct" alter:@"!Oct"];
            }
            else if([str_month isEqualToString:@"Nov"])
            {
                str_month=[Language get:@"Nov" alter:@"!Nov"];
            }
            else if([str_month isEqualToString:@"Dec"])
            {
                str_month=[Language get:@"Dec" alter:@"!Dec"];
            }
            
            [dateFormatterd setDateFormat:@"dd"];
            
            NSString *str_day = [dateFormatterd stringFromDate:currDate];
            
            [dateFormatterd setDateFormat:@"yyyy"];
            
            NSString *str_year = [dateFormatterd stringFromDate:currDate];
            
            dateString=[NSString stringWithFormat:@"%@ %@ %@",str_day,str_month,str_year];
            
            NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
            // Convert date object into desired format
           
            
            
            if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"time_format"] isEqualToString:@"12"])
            {
                [dateFormatter setDateFormat:@"hh:mm a"];
            }
            else
            {
                 [dateFormatter setDateFormat:@"HH:mm"];
            }
            
            
            NSString *date=[NSString stringWithFormat:@"\n%@: %@ %@:%@\n"
                            "--------------------------------------\n",[Language get:@"Date" alter:@"!Date"], dateString,[Language get:@"Time" alter:@"!Time"], [dateFormatter stringFromDate:[NSDate date]]];
            
            
            
            NSData* dataDate = [date dataUsingEncoding:NSWindowsCP1252StringEncoding];
            [commands appendBytes:"\x1b\x74\x11" length:sizeof("\x1b\x74\x11") - 1];
            [commands appendData:dataDate];
            
//            [commands appendBytes:"\x1b\x45\x01"
//                           length:sizeof("\x1b\x45\x01") - 1];    // Set Emphasized Printing ON
            
            [commands appendData:[[NSString stringWithFormat:@"%@    ",[Language get:@"S No" alter:@"!S No"]] dataUsingEncoding:NSWindowsCP1252StringEncoding]];
            
            [commands appendBytes:"\x1b\x74\x11" length:sizeof("\x1b\x74\x11") - 1];
//            [commands appendBytes:"\x1b\x45\x01"
//                           length:sizeof("\x1b\x45\x00") - 1];
            
            [commands appendData:[[NSString stringWithFormat:@"%@    ", [Language get:@"Date" alter:@"!Date"]] dataUsingEncoding:NSWindowsCP1252StringEncoding]];
            
            [commands appendBytes:"\x1b\x74\x11" length:sizeof("\x1b\x74\x11") - 1];
            
//            [commands appendBytes:"\x1b\x45\x01"
//                           length:sizeof("\x1b\x45\x00") - 1];    // Set Emphasized Printing OFF (same command as on)
            
            
            [commands appendData:[[NSString stringWithFormat:@"   %@ \n\n", [Language get:@"Description" alter:@"!Description"]] dataUsingEncoding:NSWindowsCP1252StringEncoding]];
            
            [commands appendBytes:"\x1b\x74\x11" length:sizeof("\x1b\x74\x11") - 1];
            
//            [commands appendBytes:"\x1b\x45\x00"
//                           length:sizeof("\x1b\x45\x00") - 1];
            
            for (int i=0; i<[appDelegate.arrayPrintLog count]; i++) {
                
               
                NSString *stringDateTime;
                stringDateTime = [NSString stringWithFormat:@"%@",[[appDelegate.arrayPrintLog valueForKey:@"date"] objectAtIndex:i]];
                
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
                [dateFormatter setDateFormat:@"dd MMMM yyyy, hh:mm:ss"];
                
                NSDate *date=[dateFormatter dateFromString:stringDateTime];
                
                
                [dateFormatter setDateFormat:@"dd-MMM-yyyy"];
                
//                NSString *printDate=[dateFormatter stringFromDate:date];
                
                
                [commands appendBytes:"\x1b\x45\x01"
                               length:sizeof("\x1b\x45\x01") - 1];    // Set Emphasized Printing ON
                
                [commands appendData:[[NSString stringWithFormat:@" %@ ",[NSString stringWithFormat:@"%@",[[appDelegate.arrayPrintLog valueForKey:@"sno"] objectAtIndex:i]]] dataUsingEncoding:NSWindowsCP1252StringEncoding]];
                
                  [commands appendBytes:"\x1b\x74\x11" length:sizeof("\x1b\x74\x11") - 1];
                
//                [commands appendBytes:"\x1b\x45\x00"
//                               length:sizeof("\x1b\x45\x00") - 1];
                
//                [commands appendData:[[NSString stringWithFormat:@"  %@ ",printDate] dataUsingEncoding:NSASCIIStringEncoding]];
                [commands appendData:[[NSString stringWithFormat:@"  %@ ",stringDateTime] dataUsingEncoding:NSWindowsCP1252StringEncoding]];

                [commands appendBytes:"\x1b\x74\x11" length:sizeof("\x1b\x74\x11") - 1];
                
//                [commands appendBytes:"\x1b\x45\x00"
//                               length:sizeof("\x1b\x45\x00") - 1];    // Set Emphasized Printing OFF (same command as on)
                
                
                [commands appendData:[[NSString stringWithFormat:@"  %@ \n\n",[NSString stringWithFormat:@"%@",[[appDelegate.arrayPrintLog valueForKey:@"discription"] objectAtIndex:i]]] dataUsingEncoding:NSWindowsCP1252StringEncoding]];
                
                [commands appendBytes:"\x1b\x74\x11" length:sizeof("\x1b\x74\x11") - 1];
                
//                [commands appendBytes:"\x1b\x45\x00"
//                               length:sizeof("\x1b\x45\x00") - 1];
                
                
            }
            
        
    
            NSString *str_sign1=[NSString stringWithFormat:@"--------------------------------\n\n\n\n%@\n%@\n%@\n%@\n%@\n"
                                 "\n",[dictHeaderFooter valueForKey:@"row6"], [dictHeaderFooter valueForKey:@"row7"], [dictHeaderFooter valueForKey:@"row8"], [dictHeaderFooter valueForKey:@"row9"], [dictHeaderFooter valueForKey:@"row10"]];
            
            
            
            NSData* dataSign = [str_sign1 dataUsingEncoding:NSWindowsCP1252StringEncoding];
            
            [commands appendBytes:"\x1b\x74\x11" length:sizeof("\x1b\x74\x11") - 1];
            
//            [commands appendBytes:"\x1b\x61\x01"
//                           length:sizeof("\x1b\x61\x01") - 1];
            
            [commands appendData:dataSign];
            
            [commands appendData:[@"\n\n\n\n\n" dataUsingEncoding:NSWindowsCP1252StringEncoding]];
            
            return commands;
            
        }
    }
}

#pragma mark Other formats

+ (NSData *)create3InchReceipt {
    NSMutableData *commands = [[NSMutableData new] autorelease];
    
    [commands appendBytes:"\x1d\x57\x40\x32"
                   length:sizeof("\x1d\x57\x40\x32") - 1];    // Page Area Setting     <GS> <W> nL nH  (nL = 64, nH = 2)
    
    [commands appendBytes:"\x1b\x61\x01"
                   length:sizeof("\x1b\x61\x01") - 1];    // Center Justification  <ESC> a n       (0 Left, 1 Center, 2 Right)
    
    [commands appendData:[@"Star Clothing Boutique\n"
                           "123 Star Road\n"
                          "City, State 12345\n\n" dataUsingEncoding:NSASCIIStringEncoding]];
    
    [commands appendBytes:"\x1b\x61\x00"
                   length:sizeof("\x1b\x61\x00") - 1];    // Left Alignment
    
    [commands appendBytes:"\x1b\x44\x02\x10\x22\x00"
                   length:sizeof("\x1b\x44\x02\x10\x22\x00") - 1];    // Setting Horizontal Tab
    
    [commands appendData:[@"Date: MM/DD/YYYY " dataUsingEncoding:NSASCIIStringEncoding]];
    
    [commands appendBytes:"\x09"
                   length:sizeof("\x09") - 1];    // Left Alignment"
    
    [commands appendData:[@"Time: HH:MM PM\n"
                           "------------------------------------------------------------------------------\n"
                           dataUsingEncoding:NSASCIIStringEncoding]];
    
    [commands appendBytes:"\x1b\x45\x01"
                   length:sizeof("\x1b\x45\x01") - 1];    // Set Emphasized Printing ON
    
    [commands appendData:[@"SALE\n" dataUsingEncoding:NSASCIIStringEncoding]];
    
    [commands appendBytes:"\x1b\x45\x00"
                   length:sizeof("\x1b\x45\x00") - 1];    // Set Emphasized Printing OFF (same command as on)
    
    [commands appendData:[@"300678566    PLAIN T-SHIRT                 10.99\n"
                           "300692003    BLACK DENIM                   29.99\n"
                           "300651148    BLUE DENIM                    29.99\n"
                           "300642980    STRIPED DRESS                 49.99\n"
                           "300638471    BLACK BOOTS                   35.99\n\n"
                           "Subtotal                                  156.95\n"
                           "Tax                                         0.00\n"
                           "------------------------------------------------\n"
                           "Total   " dataUsingEncoding:NSASCIIStringEncoding]];
    
    [commands appendBytes:"\x1d\x21\x11"
                   length:sizeof("\x1d\x21\x11") - 1];    // Width and Height Character Expansion  <GS>  !  n
    
    [commands appendData:[@"             $156.95\n" dataUsingEncoding:NSASCIIStringEncoding]];
    
    [commands appendBytes:"\x1d\x21\x00"
                   length:sizeof("\x1d\x21\x00") - 1];    // Cancel Expansion - Reference Star Portable Printer Programming Manual
    
    [commands appendData:[@"------------------------------------------------\n"
                           "Charge\n"
                           "$156.95\n"
                           "Visa XXXX-XXXX-XXXX-0123\n" dataUsingEncoding:NSASCIIStringEncoding]];

    [commands appendBytes:"\x1d\x77\x02"
                   length:sizeof("\x1d\x77\x02") - 1];    // for 1D Code39 Barcode
    
    [commands appendBytes:"\x1d\x68\x64"
                   length:sizeof("\x1d\x68\x64") - 1];    // for 1D Code39 Barcode
    
    [commands appendBytes:"\x1d\x48\x01"
                   length:sizeof("\x1d\x48\x01") - 1];    // for 1D Code39 Barcode
    
    [commands appendBytes:"\x1d\x6b\x41\x0b\x30\x31\x32\x33\x34\x35\x36\x37\x38\x39\x30"
                   length:sizeof("\x1d\x6b\x41\x0b\x30\x31\x32\x33\x34\x35\x36\x37\x38\x39\x30") - 1];    // for 1D Code39 Barcode
    
    [commands appendData:[@"\n" dataUsingEncoding:NSASCIIStringEncoding]];
    
    [commands appendBytes:"\x1d\x42\x01"
                   length:sizeof("\x1d\x42\x01") - 1];    // Specify White-Black Invert
    
    [commands appendData:[@"Refunds and Exchanges\n" dataUsingEncoding:NSASCIIStringEncoding]];
    
    [commands appendBytes:"\x1d\x42\x00"
                   length:sizeof("\x1d\x42\x00") - 1];    // Cancel White-Black Invert
    
    [commands appendData:[@"Within " dataUsingEncoding:NSASCIIStringEncoding]];
    
    [commands appendBytes:"\x1b\x2d\x01"
                   length:sizeof("\x1b\x2d\x01") - 1];    // Specify Underline Printing
    
    [commands appendData:[@"30 days" dataUsingEncoding:NSASCIIStringEncoding]];
    
    [commands appendBytes:"\x1b\x2d\x00"
                   length:sizeof("\x1b\x2d\x00") - 1];    // Cancel Underline Printing
    
    [commands appendData:[@" with receipt\n"
                           "And tags attached\n"
                           "------------- Card Holder's Signature ----------\n\n\n"
                           "------------------------------------------------\n"
                           "Thank you for buying Star!\n"
                           "Scan QR code to visit our site!\n"
                          dataUsingEncoding:NSASCIIStringEncoding]];

    [commands appendBytes:"\x1d\x5a\x02"
                   length:sizeof("\x1d\x5a\x02") - 1];    // Cancel Underline Printing
    
    [commands appendBytes:"\x1d\x5a\x02\x1b\x5a\x00\x51\x04"
                          "\x1C\x00\x68\x74\x74\x70\x3a\x2f"
                          "\x2f\x77\x77\x77\x2e\x53\x74\x61"
                          "\x72\x4d\x69\x63\x72\x6f\x6e\x69"
                          "\x63\x73\x2e\x63\x6f\x6d"
                   length:sizeof("\x1d\x5a\x02\x1b\x5a\x00\x51\x04"
                                 "\x1C\x00\x68\x74\x74\x70\x3a\x2f"
                                 "\x2f\x77\x77\x77\x2e\x53\x74\x61"
                                 "\x72\x4d\x69\x63\x72\x6f\x6e\x69"
                                 "\x63\x73\x2e\x63\x6f\x6d") - 1];    // PrintBarcode
    
    [commands appendData:[@"\n\n\n\n\n" dataUsingEncoding:NSASCIIStringEncoding]];

    return commands;
}

/**
 * This function create the sample receipt data (4inch)
 */
+ (NSData *)create4InchReceipt {
    NSMutableData *commands = [[NSMutableData new] autorelease];
    
    [commands appendBytes:"\x1d\x57\x40\x32"
                   length:sizeof("\x1d\x57\x40\x32") - 1];    // Page Area Setting     <GS> <W> nL nH  (nL = 64, nH = 2)
    
    [commands appendBytes:"\x1b\x61\x01"
                   length:sizeof("\x1b\x61\x01") - 1];    // Center Justification  <ESC> a n       (0 Left, 1 Center, 2 Right)
    
    [commands appendData:[@"Star Clothing Boutique\n"
                            "123 Star Road\n"
                            "City, State 12345\n\n" dataUsingEncoding:NSASCIIStringEncoding]];
    
    [commands appendBytes:"\x1b\x61\x00"
                   length:sizeof("\x1b\x61\x00") - 1];    // Left Alignment
    
    [commands appendBytes:"\x1b\x44\x02\x10\x22\x00"
                   length:sizeof("\x1b\x44\x02\x10\x22\x00") - 1];    // Setting Horizontal Tab
    
    [commands appendData:[@"Date: MM/DD/YYYY " dataUsingEncoding:NSASCIIStringEncoding]];
    
    [commands appendBytes:"\x09"
                   length:sizeof("\x09") - 1];    // Left Alignment"
    
    [commands appendData:[@"Time: HH:MM PM\n"
                           "---------------------------------------------------------------------\n"
                          dataUsingEncoding:NSASCIIStringEncoding]];
    
    [commands appendBytes:"\x1b\x45\x01"
                   length:sizeof("\x1b\x45\x01") - 1];    // Set Emphasized Printing ON
    
    [commands appendData:[@"SALE\n" dataUsingEncoding:NSASCIIStringEncoding]];
    
    [commands appendBytes:"\x1b\x45\x00"
                   length:sizeof("\x1b\x45\x00") - 1];    // Set Emphasized Printing OFF (same command as on)
    
    [commands appendData:[@"300678566              PLAIN T-SHIRT                            10.99\n"
                           "300692003              BLACK DENIM                              29.99\n"
                           "300651148              BLUE DENIM                               29.99\n"
                           "300642980              STRIPED DRESS                            49.99\n"
                           "300638471              BLACK BOOTS                              35.99\n\n"
                           "Subtotal                                                       156.95\n"
                           "Tax                                                              0.00\n"
                           "---------------------------------------------------------------------\n"
                           "Total   " dataUsingEncoding:NSASCIIStringEncoding]];
    
    [commands appendBytes:"\x1d\x21\x11"
                   length:sizeof("\x1d\x21\x11") - 1];    // Width and Height Character Expansion  <GS>  !  n
    
    [commands appendData:[@"             $156.95\n" dataUsingEncoding:NSASCIIStringEncoding]];
    
    [commands appendBytes:"\x1d\x21\x00"
                   length:sizeof("\x1d\x21\x00") - 1];    // Cancel Expansion - Reference Star Portable Printer Programming Manual
    
    [commands appendData:[@"---------------------------------------------------------------------\n"
                           "Charge\n"
                           "$156.95\n"
                           "Visa XXXX-XXXX-XXXX-0123\n"
                          dataUsingEncoding:NSASCIIStringEncoding]];
    
    [commands appendBytes:"\x1d\x77\x02"
                   length:sizeof("\x1d\x77\x02") - 1];    // for 1D Code39 Barcode
    
    [commands appendBytes:"\x1d\x68\x64"
                   length:sizeof("\x1d\x68\x64") - 1];    // for 1D Code39 Barcode
    
    [commands appendBytes:"\x1d\x48\x01"
                   length:sizeof("\x1d\x48\x01") - 1];    // for 1D Code39 Barcode
    
    [commands appendBytes:"\x1d\x6b\x41\x0b\x30\x31\x32\x33\x34\x35\x36\x37\x38\x39\x30"
                   length:sizeof("\x1d\x6b\x41\x0b\x30\x31\x32\x33\x34\x35\x36\x37\x38\x39\x30") - 1];    // for 1D Code39 Barcode
    
    [commands appendData:[@"\n" dataUsingEncoding:NSASCIIStringEncoding]];
    
    [commands appendBytes:"\x1d\x42\x01"
                   length:sizeof("\x1d\x42\x01") - 1];    // Specify White-Black Invert
    
    [commands appendData:[@"Refunds and Exchanges\n" dataUsingEncoding:NSASCIIStringEncoding]];
    
    [commands appendBytes:"\x1d\x42\x00"
                   length:sizeof("\x1d\x42\x00") - 1];    // Cancel White-Black Invert
    
    [commands appendData:[@"Within " dataUsingEncoding:NSASCIIStringEncoding]];
    
    [commands appendBytes:"\x1b\x2d\x01"
                   length:sizeof("\x1b\x2d\x01") - 1];    // Specify Underline Printing
    
    [commands appendData:[@"30 days" dataUsingEncoding:NSASCIIStringEncoding]];
    
    [commands appendBytes:"\x1b\x2d\x00"
                   length:sizeof("\x1b\x2d\x00") - 1];    // Cancel Underline Printing
    
    [commands appendData:[@" with receipt\n"
                           "And tags attached\n"
                           "----------------------- Card Holder's Signature ---------------------\n\n\n"
                           "---------------------------------------------------------------------\n"
                           "Thank you for buying Star!\n"
                           "Scan QR code to visit our site!\n"
                          dataUsingEncoding:NSASCIIStringEncoding]];
    
    [commands appendBytes:"\x1d\x5a\x02"
                   length:sizeof("\x1d\x5a\x02") - 1];    // Cancel Underline Printing
    
    [commands appendBytes:"\x1d\x5a\x02\x1b\x5a\x00\x51\x04"
                          "\x1C\x00\x68\x74\x74\x70\x3a\x2f"
                          "\x2f\x77\x77\x77\x2e\x53\x74\x61"
                          "\x72\x4d\x69\x63\x72\x6f\x6e\x69"
                          "\x63\x73\x2e\x63\x6f\x6d"
                   length:sizeof("\x1d\x5a\x02\x1b\x5a\x00\x51\x04"
                                 "\x1C\x00\x68\x74\x74\x70\x3a\x2f"
                                 "\x2f\x77\x77\x77\x2e\x53\x74\x61"
                                 "\x72\x4d\x69\x63\x72\x6f\x6e\x69"
                                 "\x63\x73\x2e\x63\x6f\x6d") - 1];    // PrintBarcode
    
    [commands appendData:[@"\n\n\n\n\n" dataUsingEncoding:NSASCIIStringEncoding]];
    
    return commands;
}

/**
 * This function print the Kanji sample receipt
 * portName - Port name to use for communication
 * portSettings - The port settings to use
 * widthInch - printable width (2/3/4 [inch])
 */
+ (void)PrintKanjiSampleReceiptWithPortName:(NSString *)portName portSettings:(NSString *)portSettings widthInch:(int)printableWidth
{
    NSData *commands = nil;
    
    switch (printableWidth) {
        case 2:
            commands = [[self createKanji2InchReceipt] retain];
            break;
            
        case 3:
            commands = [[self createKanji3InchReceipt] retain];
            break;
            
        case 4:
            commands = [[self createKanji4InchReceipt] retain];
            break;
            
        default:
            return;
    }
    
    [self sendCommand:commands portName:portName portSettings:portSettings timeoutMillis:10000];
    
    [commands release];
}

/**
 * This function create the Kanji sample receipt data (2inch)
 */
+ (NSData *)createKanji2InchReceipt {
    
    NSMutableData *commands = [[NSMutableData new] autorelease];
    
    [commands appendBytes:"\x1b\x40"
                   length:sizeof("\x1b\x40") - 1];    // Initialization
    
    [commands appendBytes:"\x1d\x57\x80\x01"
                   length:sizeof("\x1d\x57\x80\x01") - 1];    // 印字領域設定（58mm用紙）
    
    [commands appendBytes:"\x1c\x43\x01"
                   length:sizeof("\x1c\x43\x01") - 1];    // 漢字モード設定
    
    [commands appendBytes:"\x1b\x61\x31"
                   length:sizeof("\x1b\x61\x31") - 1];    // 中央揃え設定
    
    [commands appendBytes:"\x1b\x21\x22"
                   length:sizeof("\x1b\x21\x22") - 1];    // 文字縦拡大設定
    
    [commands appendBytes:"\x1b\x45\x31"
                   length:sizeof("\x1b\x45\x31") - 1];    // 強調印字設定
    
    [commands appendData:[@"スター電機\n" dataUsingEncoding:NSShiftJISStringEncoding]];
    
    [commands appendBytes:"\x1b\x21\x11"
                   length:sizeof("\x1b\x21\x11") - 1];    // 文字縦拡大設定
    
    [commands appendData:[@"修理報告書　兼領収書\n" dataUsingEncoding:NSShiftJISStringEncoding]];
    
    [commands appendBytes:"\x1b\x21\x00"
                   length:sizeof("\x1b\x21\x00") - 1];    // 文字縦拡大解除
    
    [commands appendBytes:"\x1b\x45\x00"
                   length:sizeof("\x1b\x45\x00") - 1];    // 強調印字解除
    
    [commands appendData:[@"--------------------------------\n" dataUsingEncoding:NSShiftJISStringEncoding]];
    
    [commands appendBytes:"\x1b\x61\x30"
                   length:sizeof("\x1b\x61\x30") - 1];    // 左揃え設定
    
    [commands appendData:[@"発行日時：YYYY年MM月DD日HH時MM分" "\n" dataUsingEncoding:NSShiftJISStringEncoding]];
    
    [commands appendData:[@"TEL：054-347-XXXX\n\n" dataUsingEncoding:NSShiftJISStringEncoding]];
    
    [commands appendBytes:"\x1b\x74\x01"
                   length:sizeof("\x1b\x74\x01") - 1];    // 文字コード設定（ｶﾀｶﾅ）
    
    [commands appendData:[@"          ｲｹﾆｼ  ｼｽﾞｺ  ｻﾏ\n" dataUsingEncoding:NSShiftJISStringEncoding]];
    
    [commands appendBytes:"\x1c\x43\x01"
                   length:sizeof("\x1c\x43\x01") - 1];    // 漢字モード設定
    
    [commands appendBytes:"\x1b\x52\x08"
                   length:sizeof("\x1b\x52\x08") - 1];    // 国際文字
    
    [commands appendData:[@"　お名前：池西　静子　様\n"
                           "　御住所：静岡市清水区七ツ新屋\n"
                           "　　　　　５３６番地\n"
                           "　伝票番号：No.12345-67890\n\n"
                           "　この度は修理をご用命頂き有難うございます。今後も故障など発生した場合はお気軽にご連絡ください。\n\n"
                           "品名／型名　数量　　金額　 備考\n"
                           "--------------------------------\n" dataUsingEncoding:NSShiftJISStringEncoding]];
    
    [commands appendData:[@"制御基板　　  1　　10,000　配達\n"
                           "操作スイッチ  1　   3,800　配達\n"
                           "パネル　　　  1     2,000　配達\n"
                           "技術料　　　　1　　15,000\n"
                           "出張費用　　  1　   5,000\n"
                           "--------------------------------\n" dataUsingEncoding:NSShiftJISStringEncoding]];
    
    [commands appendData:[@"\n"
                           "                小計   \\ 35,800\n"
                           "                内税   \\  1,790\n"
                           "                合計   \\ 37,590\n\n"
                           "　お問合わせ番号　　12345-67890\n\n\n\n" dataUsingEncoding:NSShiftJISStringEncoding]];

    return commands;
}

/**
 * This function create the Kanji sample receipt data (3inch)
 */
+ (NSData *)createKanji3InchReceipt
{
    NSMutableData *commands = [[NSMutableData new] autorelease];
    
    [commands appendBytes:"\x1b\x40"
            length:sizeof("\x1b\x40") - 1];    // Initialization50
    
    [commands appendBytes:"\x1c\x43\x01"
            length:sizeof("\x1c\x43\x01") - 1];    // 漢字モード設定
    
    [commands appendBytes:"\x1b\x61\x31"
            length:sizeof("\x1b\x61\x31") - 1];    // 中央揃え設定
    
    [commands appendBytes:"\x1b\x21\x22"
            length:sizeof("\x1b\x21\x22") - 1];    // 文字縦拡大設定
    
    [commands appendBytes:"\x1b\x45\x31"
            length:sizeof("\x1b\x45\x31") - 1];    // 強調印字設定
    
    [commands appendData:[@"スター電機\n" dataUsingEncoding:NSShiftJISStringEncoding]];
    
    [commands appendBytes:"\x1b\x21\x11"
            length:sizeof("\x1b\x21\x11") - 1];    // 文字縦拡大設定
    
    [commands appendData:[@"修理報告書　兼領収書\n" dataUsingEncoding:NSShiftJISStringEncoding]];
    
    [commands appendBytes:"\x1b\x21\x00"
            length:sizeof("\x1b\x21\x00") - 1];    // 文字縦拡大解除
    
    [commands appendBytes:"\x1b\x45\x00"
            length:sizeof("\x1b\x45\x00") - 1];    // 強調印字解除
    
    [commands appendData:[@"------------------------------------------------\n"
                          dataUsingEncoding:NSShiftJISStringEncoding]];
    
    [commands appendBytes:"\x1b\x61\x30"
            length:sizeof("\x1b\x61\x30") - 1];    // 左揃え設定
    
    [commands appendData:[@"発行日時：YYYY年MM月DD日HH時MM分" "\n" dataUsingEncoding:NSShiftJISStringEncoding]];
    
    [commands appendData:[@"TEL：054-347-XXXX\n\n" dataUsingEncoding:NSShiftJISStringEncoding]];
    
    [commands appendBytes:"\x1b\x74\x01"
            length:sizeof("\x1b\x74\x01") - 1];    // 文字コード設定（ｶﾀｶﾅ）
    
    [commands appendData:[@"          ｲｹﾆｼ  ｼｽﾞｺ  ｻﾏ\n" dataUsingEncoding:NSShiftJISStringEncoding]];
    
    [commands appendBytes:"\x1c\x43\x01"
            length:sizeof("\x1c\x43\x01") - 1];    // 漢字モード設定
    
    [commands appendBytes:"\x1b\x52\x08"
                   length:sizeof("\x1b\x52\x08") - 1];    // 国際文字
    
    [commands appendData:[@"　お名前：池西　静子　様\n"
                           "　御住所：静岡市清水区七ツ新屋\n"
                           "　　　　　５３６番地\n"
                           "　伝票番号：No.12345-67890\n\n"
                           "　この度は修理をご用命頂き有難うございます。今後も故障など発生した場合はお気軽にご連絡ください。\n\n"
                          dataUsingEncoding:NSShiftJISStringEncoding]];
    
    [commands appendData:[@"品名／型名　          数量      金額　   備考\n"
                           "------------------------------------------------\n"
                           "制御基板　          　  1　　  10,000    配達\n"
                           "操作スイッチ            1　     3,800　  配達\n"
                           "パネル　　          　  1       2,000　  配達\n"
                           "技術料　          　　　1      15,000\n"
                           "出張費用　　            1　     5,000\n"
                          "------------------------------------------------\n"
                          dataUsingEncoding:NSShiftJISStringEncoding]];
    
    [commands appendData:[@"\n"
                           "　　　　　　　       　  　     小計 \\ 35,800\n"
                           "　　　　　　 　　  　      　   内税 \\  1,790\n"
                           "　　　　　　 　　   　　        合計 \\ 37,590\n\n"
                           "　お問合わせ番号　　12345-67890\n\n\n\n"
                          dataUsingEncoding:NSShiftJISStringEncoding]];

    return commands;
}

/**
 * This function create the Kanji sample receipt data (4inch)
 */
+ (NSData *)createKanji4InchReceipt
{
    NSMutableData *commands = [[NSMutableData new] autorelease];
    
    [commands appendBytes:"\x1b\x40"
            length:sizeof("\x1b\x40") - 1];    // Initialization
    
    [commands appendBytes:"\x1c\x43\x01"
            length:sizeof("\x1c\x43\x01") - 1];    // 漢字モード設定
    
    [commands appendBytes:"\x1b\x61\x31"
            length:sizeof("\x1b\x61\x31") - 1];    // 中央揃え設定
    
    [commands appendBytes:"\x1b\x21\x22"
            length:sizeof("\x1b\x21\x22") - 1];    // 文字縦拡大設定
    
    [commands appendBytes:"\x1b\x45\x31"
            length:sizeof("\x1b\x45\x31") - 1];    // 強調印字設定
    
    [commands appendData:[@"スター電機\n" dataUsingEncoding:NSShiftJISStringEncoding]];
    
    [commands appendBytes:"\x1b\x21\x11"
            length:sizeof("\x1b\x21\x11") - 1];    // 文字縦拡大設定
    
    [commands appendData:[@"修理報告書　兼領収書\n" dataUsingEncoding:NSShiftJISStringEncoding]];
    
    [commands appendBytes:"\x1b\x21\x00"
            length:sizeof("\x1b\x21\x00") - 1];    // 文字縦拡大解除
    
    [commands appendBytes:"\x1b\x45\x00"
            length:sizeof("\x1b\x45\x00") - 1];    // 強調印字解除
    
    [commands appendData:[@"---------------------------------------------------------------------\n"
                          dataUsingEncoding:NSShiftJISStringEncoding]];
    
    [commands appendBytes:"\x1b\x61\x30"
            length:sizeof("\x1b\x61\x30") - 1];    // 左揃え設定
    
    [commands appendData:[@"発行日時：YYYY年MM月DD日HH時MM分" "\n" dataUsingEncoding:NSShiftJISStringEncoding]];
    
    [commands appendData:[@"TEL：054-347-XXXX\n\n" dataUsingEncoding:NSShiftJISStringEncoding]];
    
    [commands appendBytes:"\x1b\x74\x01"
            length:sizeof("\x1b\x74\x01") - 1];    // 文字コード設定（ｶﾀｶﾅ）
    
    [commands appendData:[@"          ｲｹﾆｼ  ｼｽﾞｺ  ｻﾏ\n" dataUsingEncoding:NSShiftJISStringEncoding]];
    
    [commands appendBytes:"\x1c\x43\x01"
            length:sizeof("\x1c\x43\x01") - 1];    // 漢字モード設定
    
    [commands appendBytes:"\x1b\x52\x08"
                   length:sizeof("\x1b\x52\x08") - 1];    // 国際文字
    
    [commands appendData:[@"　お名前：池西　静子　様\n"
                           "　御住所：静岡市清水区七ツ新屋\n"
                           "　　　　　５３６番地\n"
                           "　伝票番号：No.12345-67890\n\n"
                           "　この度は修理をご用命頂き有難うございます。今後も故障など発生した場合はお気軽にご連絡ください。\n\n"
                          dataUsingEncoding:NSShiftJISStringEncoding]];
    
    [commands appendData:[@"品名／型名　                 数量             金額　          備考\n"
                           "---------------------------------------------------------------------\n"
                           "制御基板　                 　  1       　　  10,000           配達\n"
                           "操作スイッチ                   1　            3,800       　  配達\n"
                           "パネル       　　          　  1              2,000       　 配達\n"
                           "技術料　                 　　　1             15,000\n"
                           "出張費用       　　            1　            5,000\n"
                           "---------------------------------------------------------------------\n"
                          dataUsingEncoding:NSShiftJISStringEncoding]];
    
    [commands appendData:[@"\n"
                           "                     　　　　　　　       　  　     小計 \\ 35,800\n"
                           "                     　　　　　　 　　  　      　   内税 \\  1,790\n"
                           "                     　　　　　　 　　   　　        合計 \\ 37,590\n\n"
                          "　お問合わせ番号　　12345-67890\n\n\n\n"
                          dataUsingEncoding:NSShiftJISStringEncoding]];
    
    return commands;
}

#pragma mark Sample Receipt + Open Cash Drawer

+ (void)PrintSampleReceiptWithPortname:(NSString *)portName portSettings:(NSString *)portSettings widthInch:(int)printableWidth errorMessage:(NSMutableString *)message
{
    NSData *commands = nil;
    
    switch (printableWidth) {
        case 2:
            if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"ReportRecipt"]isEqualToString:@"Yes"]) {
                
                [[NSUserDefaults standardUserDefaults] setObject:@"No" forKey:@"ReportRecipt"];
                
                
                commands = [[self create2InchXZReceipt] retain];
                
            }
            else if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"LogRecipt"]isEqualToString:@"Yes"]) {
                
                [[NSUserDefaults standardUserDefaults] setObject:@"No" forKey:@"LogRecipt"];
                
                
                commands = [[self create_LogPrint_Format] retain];
                
            }
            
            else
            {
//            commands = [[self create2InchReceipt] retain];
            commands = [[self create_LogPrint_Format] retain];

            }
            break;
            
        case 3:
            commands = [[self create3InchReceipt] retain];
            break;
            
        case 4:
            commands = [[self create4InchReceipt] retain];
            break;
            
        default:
            return;
    }
    
    [self sendCommand:commands portName:portName portSettings:portSettings timeoutMillis:10000 errorMessage:message];
    
    [commands release];
}

+ (void)sendCommand:(NSData *)commands portName:(NSString *)portName portSettings:(NSString *)portSettings timeoutMillis:(u_int32_t)timeoutMillis
       errorMessage:(NSMutableString *)message
{
    unsigned char *commandsToSendToPrinter = (unsigned char*)malloc(commands.length);
    [commands getBytes:commandsToSendToPrinter];
    int commandSize = (int)[commands length];
    
    SMPort *starPort = nil;
    @try
    {
        starPort = [SMPort getPort:portName :portSettings :timeoutMillis];
        if (starPort == nil) {
            [message appendString:@"Fail to Open Port"];
            return;
        }
        
        struct timeval endTime;
        gettimeofday(&endTime, NULL);
        endTime.tv_sec += 60;
        
        StarPrinterStatus_2 status;
        [starPort beginCheckedBlock:&status :2];
        
        if (status.offline == SM_TRUE) {
            [message appendString:@"Printer is offline"];
            return;
        }
        
        int totalAmountWritten = 0;
        while (totalAmountWritten < commandSize) {
            int remaining = commandSize - totalAmountWritten;
            
            int amountWritten = [starPort writePort:commandsToSendToPrinter :totalAmountWritten :remaining];
            totalAmountWritten += amountWritten;
            
            struct timeval now;
            gettimeofday(&now, NULL);
            if (now.tv_sec > endTime.tv_sec) {
                break;
            }
        }
        
        //SM-T300(Wi-Fi): To use endCheckedBlock method, require F/W 2.4 or later.
        starPort.endCheckedBlockTimeoutMillis = 40000;
        [starPort endCheckedBlock:&status :2];
        if (status.offline == SM_TRUE) {
            [message appendString:@"An error has occurred during printing."];
            return;
        }
        
        if (totalAmountWritten < commandSize) {
            [message appendString:@"Write port timed out"];
            return;
        }
    }
    @catch (PortException *exception)
    {
        [message appendString:@"Write port timed out"];
        return;
    }
    @finally
    {
        [SMPort releasePort:starPort];
        free(commandsToSendToPrinter);
    }
}
@end
