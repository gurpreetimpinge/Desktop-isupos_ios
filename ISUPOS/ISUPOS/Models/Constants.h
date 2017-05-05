//
//  Constants.h
//  ISUPOS
//
//  Created by Mac User on 4/6/15.
//  Copyright (c) 2015 Impinge Solutions. All rights reserved.
//

#ifndef ISUPOS_Constants_h

#import "AppDelegate.h"


#define kAppName @"ISUPOS"


// Core Data Macros

#define kInsertWithNameAndWithContext(name,context) [NSEntityDescription insertNewObjectForEntityForName:name inManagedObjectContext:context]

#define kEntityForNameWithContext(name,context) [NSEntityDescription entityForName:name inManagedObjectContext:context]

// Alert Macros

#define UIMsg(fmt, ...)  { UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kAppName message:[NSString stringWithFormat:fmt, ##__VA_ARGS__]  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]; [alert show]; }

// Validation Macros

#define kFillStringIfEmpty(string) if(!string || [string isKindOfClass:[NSNull class]]){string = @"";}

#define kFillDateIfEmpty(dated) if(!dated || [dated isKindOfClass:[NSNull class]]){dated = [NSDate date];}

#define kFillNumberIfEmpty(number) if(!number || [number isKindOfClass:[NSNull class]]){number = [NSNumber numberWithInt:0];}

#define ISUPOS_Constants_h

#define kBlank_String       @""


#define IS_OS_7_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)


#define IMAGE_FROM_BUNDLE(arg)  [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:arg ofType:@"png"]]

#define ISUPOSmailId @"rajeevlochan@impingeonline.com"

// PAYWORKS Identifier and Secret
#define KPAYWORKS_MERCHANT_IDENTIFIER             @"merchant_identifier"
#define KPAYWORKS_MERCHANT_SECRET                 @"merchant_secret"
#define KPAYWORKS_MERCHANT_MODE                   @"merchant_mode"

#endif
