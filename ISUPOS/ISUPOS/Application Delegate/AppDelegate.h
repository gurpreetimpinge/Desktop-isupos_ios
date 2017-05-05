//
//  AppDelegate.h
//  ISUPOS
//
//  Created by Mac User on 4/2/15.
//  Copyright (c) 2015 Impinge Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

// Frameworks
#import <CoreData/CoreData.h>
//SendGrid
#import "SendGrid.h"
#import "SendGridEmail.h"
//#import <mpos-ui/mpos-ui.h>
#import <mpos.core/mpos-extended.h>

#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    NSArray *reciptArray;
    NSArray *reciptArrayReceipt;
    NSMutableArray *arrayPrintLog;
    NSArray *arrayZDayReport;
   
}

@property (strong, nonatomic) UIWindow *window;


// CoreData Properties
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


@property (strong, nonatomic) UITabBarController *tabBarQuickButtons;

@property (strong, nonatomic) UINavigationController *navigation;

@property (nonatomic,retain) NSArray *reciptArray;
@property (nonatomic,retain) NSArray *reciptArrayReceipt;

@property (strong, nonatomic) NSMutableArray *arrayPrintingHeader;

@property (strong, nonatomic) NSMutableArray *arrayPrintLog;

@property (nonatomic,retain) NSArray *arrayZDayReport;
@property (strong, nonatomic) NSMutableArray *arrayGlobalData;
@property (nonatomic,strong) MPReceipt *customerReceipt;
@property (nonatomic, strong) NSMutableDictionary *receipt_paymentDetails;
@property (nonatomic,strong) NSMutableDictionary *receipt_paymentDetails_copy;
@property (strong, nonatomic) NSMutableArray *ary_RegisterSale;
@property (nonatomic) BOOL bool_RegisterSale;

- (void)saveContext;

- (NSURL *)applicationDocumentsDirectory;

+ (instancetype)delegate;


+ (NSString *)getPortName;
+ (void)setPortName:(NSString *)m_portName;
+ (NSString*)getPortSettings;
+ (void)setPortSettings:(NSString *)m_portSettings;

+ (NSString *)getDrawerPortName;
+ (void)setDrawerPortName:(NSString *)portName;

+ (void)setButtonArrayAsOldStyle:(NSArray *)buttons;

+ (NSString *)HTMLCSS;
- (void)sendMailWithSubject:(NSString *)subject sendFrom:(NSString *)senderEmailID ToReciepents:(NSString *)reciepents messageHtmlBodyContent:(NSString *)messageHtmlBody;
- (void)sendForgetMailWithSubject:(NSString *)subject sendFrom:(NSString *)senderEmailID ToReciepents:(NSString *)reciepents messageHtmlBodyContent:(NSString *)messageHtmlBody;
- (void)sendReceiptMailWithSubject:(NSString *)subject sendFrom:(NSString *)senderEmailID ToReciepents:(NSString *)reciepents messageHtmlBodyContent:(NSString *)messageHtmlBody;
- (void)sendXZdayReportMailWithSubject:(NSString *)subject sendFrom:(NSString *)senderEmailID ToReciepents:(NSString *)reciepents messageHtmlBodyContent:(NSString *)messageHtmlBody;
- (void)sendLogDetailMailWithSubject:(NSString *)subject sendFrom:(NSString *)senderEmailID ToReciepents:(NSString *)reciepents messageHtmlBodyContent:(NSString *)messageHtmlBody;

-(void)PrintAndMailCountUpdate:(int)value amount:(float)totalAmount;
-(void)refundCountUpdate:(int)value :(int)index;
-(void)fetch_globalData;
-(void)resetZdayGlobalValue;
-(void)clearCart;
- (void)addReceiptData;
- (void)sendEmailListAttachmentMail:(NSData *)txtFileData;

@end