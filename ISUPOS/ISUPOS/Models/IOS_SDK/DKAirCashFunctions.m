//
//  DKAirCashFunctions.m
//  IOS_SDK
//
//  Created by u3237 on 13/06/25.
//
//

#import "DKAirCashFunctions.h"
#import <sys/time.h>
#import <StarIO/SMPort.h>
#import "Language.h"

@implementation DKAirCashFunctions

/*!
 *  This function shows the DK-AirCash firmware information
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
            [alert show];
            [alert release];
            return;
        }
        
        NSMutableString *message = [NSMutableString string];
        dict = [[starPort getFirmwareInformation] retain];
        for (id key in dict.keyEnumerator) {
            [message appendFormat:@"%@: %@\n", key, dict[key]];
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[Language get:@"Firmware"  alter:@"!Firmware" ]message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
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
 * This function opens the DK-AirCash.
 * This function just send the byte 0x07 to the DK-AirCash which is the open Cash Drawer command
 * portName - Port name to use for communication. This should be (TCP:<IPAddress>)
 * portSettings - Should be blank
 */
+ (void)OpenCashDrawerWithPortname:(NSString *)portName portSettings:(NSString *)portSettings drawerNumber:(NSUInteger)drawerNumber
{
    unsigned char opencashdrawer_command = 0x00;
    
    if (drawerNumber == 1) {
        opencashdrawer_command = 0x07; //BEL
    }
    else if (drawerNumber == 2) {
        opencashdrawer_command = 0x1a; //SUB
    }
    
    NSData *commands = [NSData dataWithBytes:&opencashdrawer_command length:1];
    [self sendCommand:commands portName:portName portSettings:portSettings timeoutMillis:10000];
}

/**
 * This function checks the status of the printer.
 * The check status function can be used for both portable and non portable printers.
 * portName - Port name to use for communication. This should be (TCP:<IPAddress>)
 * portSettings - Should be blank
 */
+ (void)CheckStatusWithPortname:(NSString *)portName portSettings:(NSString *)portSettings
{
    SMPort *starPort = nil;
    @try
    {
        starPort = [SMPort getPort:portName :portSettings :10000];
        if (starPort == nil) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[Language get:@"Fail to Open Port" alter:@"!Fail to Open Port"]
                                                            message:@""
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
            return;
        }
        
        StarPrinterStatus_2 status;
        [starPort getParsedStatus:&status :2];
        
        NSString *onlineStatus;
        if (status.offline == SM_TRUE) {
            onlineStatus = @"The drawer is offline";
        } else {
            onlineStatus = @"The drawer is online";
        }
        
        NSString *compulsionSwStatus;
        if (status.compulsionSwitch == SM_FALSE) {
            compulsionSwStatus = @"Cash Drawer: Close";
        } else {
            compulsionSwStatus = @"Cash Drawer: Open";
        }
        
        NSString *message = [NSString stringWithFormat:@"%@\n%@", onlineStatus, compulsionSwStatus];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[Language get:@"Drawer Status" alter:@"!Drawer Status"]
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    @catch (PortException *exception)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[Language get:@"Printer Error" alter:@"!Printer Error"]
                                                        message:[Language get:@"Get status failed." alter:@"!Get status failed."]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    @finally
    {
        [SMPort releasePort:starPort];
    }
}

#pragma mark Common

+ (void)sendCommand:(NSData *)commandsToPrint portName:(NSString *)portName portSettings:(NSString *)portSettings timeoutMillis:(u_int32_t)timeoutMillis
{
    int commandSize = (int)[commandsToPrint length];
    unsigned char *dataToSentToPrinter = (unsigned char *)malloc(commandSize);
    [commandsToPrint getBytes:dataToSentToPrinter];
    
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
            [alert show];
            [alert release];
            return;
        }
        
        StarPrinterStatus_2 status;
        [starPort beginCheckedBlock:&status :2];
        if (status.offline == SM_TRUE) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[Language get:@"Error" alter:@"!Error"]
                                                            message:[Language get:@"Printer is offline" alter:@"!Printer is offline"]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
            return;
        }
        
        struct timeval endTime;
        gettimeofday(&endTime, NULL);
        endTime.tv_sec += 30;
        
        int totalAmountWritten = 0;
        while (totalAmountWritten < commandSize)
        {
            int remaining = commandSize - totalAmountWritten;
            int amountWritten = [starPort writePort:dataToSentToPrinter :totalAmountWritten :remaining];
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
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[Language get:@"Error" alter:@"!Error"]
                                                            message:[Language get:@"Write port timed out" alter:@"!Write port timed out"]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
        
        [starPort endCheckedBlock:&status :2];
        if (status.offline == SM_TRUE) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[Language get:@"Error" alter:@"!Error"]
                                                            message:[Language get:@"Printer is offline" alter:@"!Printer is offline"]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
            return;
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
        free(dataToSentToPrinter);
        [SMPort releasePort:starPort];
    }
}

/*!
 *  Open drawer / wait drawer open / wait drawer close
 */
+ (BOOL)waitDrawerOpenAndCloseWithPortName:(NSString *)portName drawerNumber:(NSUInteger)drawerNumber
{
    //
    // Create Drawer Open Command
    //
    unsigned char opencashdrawer_command = 0x00;
    switch (drawerNumber) {
        case 1:
            opencashdrawer_command = 0x07; //BEL
            break;
        case 2:
            opencashdrawer_command = 0x1a; //SUB
            break;
        default:
            return NO;
    }
    

    SMPort *starPort = nil;

    @try {
        //
        // Send Drawer Open Command
        //
        
        starPort = [SMPort getPort:portName :@"" :10000];
        if (starPort == nil) {
            [self showCommonErrorDialogWithTitle:@"Error" message:@"DK-AirCash is turned off or other host is using the DK-AirCash"];
            return NO;
        }
        
        // Check current status
        StarPrinterStatus_2 status;
        [starPort getParsedStatus:&status :2];
        if (status.compulsionSwitch == SM_TRUE) {
            [self showCommonErrorDialogWithTitle:@"" message:@"Drawer was already opened."];
            return NO;
        }
        
        [starPort beginCheckedBlock:&status :2];
        if (status.offline == SM_TRUE) {
            [self showCommonErrorDialogWithTitle:@"Error" message:@"Printer is offline"];
            return NO;
        }
        
        struct timeval endTime;
        gettimeofday(&endTime, NULL);
        endTime.tv_sec += 30;
        
        NSData *commands = [NSData dataWithBytes:&opencashdrawer_command length:1];
        unsigned char *dataToSentToPrinter = (unsigned char *)malloc(commands.length);
        [commands getBytes:dataToSentToPrinter];
        
        int totalAmountWritten = 0;
        while (totalAmountWritten < commands.length)
        {
            int remaining = (int)(commands.length - totalAmountWritten);
            int amountWritten = [starPort writePort:dataToSentToPrinter :totalAmountWritten :remaining];
            totalAmountWritten += amountWritten;
            
            struct timeval now;
            gettimeofday(&now, NULL);
            if (now.tv_sec > endTime.tv_sec) {
                break;
            }
        }
        free(dataToSentToPrinter);
        
        if (totalAmountWritten < commands.length)
        {
            [self showCommonErrorDialogWithTitle:@"Error" message:@"Printer is offline"];
            return NO;
        }
        
        [self showCommonProgressDialogWithTitle:@"" message:@"Waiting for drawer to open."];
        
        [starPort endCheckedBlock:&status :2];
        if (status.offline == SM_TRUE) {
            [self showCommonErrorDialogWithTitle:@"Error" message:@"Printer is offline"];
            return NO;
        }
        
        //Interval
        usleep(150 * 1000);
        
        [self dismissCommonProgressDialog];
        
        // Check drawer open
        [starPort getParsedStatus:&status :2];
        if (status.compulsionSwitch == SM_FALSE) {
            [self showCommonErrorDialogWithTitle:@"Error" message:@"Drawer didn\'t open."];
            return NO;
        }
        
        //
        // Wait Drawer Close
        //
        [self showCommonProgressDialogWithTitle:@"" message:@"Waiting for drawer to close."];
        
        gettimeofday(&endTime, NULL);
        endTime.tv_sec += 30;
        while (YES) {
            [starPort getParsedStatus:&status :2];
            if (status.compulsionSwitch == SM_FALSE) {
                break;
            }
            
            //Check timeout
            struct timeval now;
            gettimeofday(&now, NULL);
            if (now.tv_sec > endTime.tv_sec) {
                [self showCommonErrorDialogWithTitle:@"Error" message:@"Drawer didn\'t close within 30 seconds."];
                return NO;
            }
            
            //Interval
            usleep(500 * 1000);
        }

        [self dismissCommonProgressDialog];
        
        [self showCommonProgressDialogWithTitle:@"" message:@"Completed successfully."];
        
        usleep(3000 * 1000);
        
        [self dismissCommonProgressDialog];
    }
    @catch (PortException *ex) {
        [self showCommonErrorDialogWithTitle:@"Printer Error" message:@"Write port timed out"];
    }
    @finally {
        [SMPort releasePort:starPort];
        [self dismissCommonProgressDialog];
    }
    
    return YES;
}


static UIAlertView* alert = nil;

+ (void)showCommonProgressDialogWithTitle:(NSString *)title message:(NSString *)message
{
    dispatch_async(dispatch_get_main_queue(), ^() {
        if (alert != nil) {
            [self dismissCommonProgressDialog];
        }
        
        alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
        [alert show];
    });
}

+ (void)dismissCommonProgressDialog
{
    dispatch_async(dispatch_get_main_queue(), ^() {
        [alert dismissWithClickedButtonIndex:0 animated:NO];
        [alert release];
        alert = nil;
    });
}

+ (void)showCommonErrorDialogWithTitle:(NSString *)title message:(NSString *)message
{
    dispatch_async(dispatch_get_main_queue(), ^() {
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:title
                                                         message:message
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil] autorelease];
        [alert show];
    });
}

@end
