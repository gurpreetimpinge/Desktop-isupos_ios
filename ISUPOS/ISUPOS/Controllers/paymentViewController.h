//
//  paymentViewController.h
//  ISUPOS
//
//  Created by Rohit Mahajan on 6/23/15.
//  Copyright (c) 2015 Impinge Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MiniPrinterFunctions.h"

@interface paymentViewController : UIViewController<UIAlertViewDelegate, UITextFieldDelegate>
{
    MiniPrinterFunctions *miniPrinterFunctions;
    
    IBOutlet UILabel *lbltitle;
    IBOutlet UIButton *btn_Card,*btn_Cash,*btn_Swish,*btn_Other;
    IBOutlet UIView *view_PaymentDivider;
    
    IBOutlet UIView *tenderdview;
    IBOutlet UITextField *amountFeild;
    IBOutlet UILabel *tenderdLbl;
    IBOutlet UILabel *amountLbl;
    IBOutlet UIButton *okBtn;
    IBOutlet UIButton *btnEmail;
    IBOutlet UIButton *btnNone;
    
    
    
}
@property(nonatomic,retain)id callBack;
@property(nonatomic,retain)NSMutableArray *vat_Amount;
@property(nonatomic,retain)NSMutableArray *vat_Variant;
@property(nonatomic,retain)NSString *str_PurchaseAmount;
@property (weak, nonatomic) IBOutlet UILabel *LabelNoReaderConnected;
@property (weak, nonatomic) IBOutlet UILabel *labelConnectCReader;
@property (strong, nonatomic) NSString *str_PaymentMethod;
@property (strong, nonatomic) NSString *str_QuickBlockName;

@property (weak, nonatomic) IBOutlet UIButton *btnBuyCardReader;
@property (weak, nonatomic) IBOutlet UIButton *btnGetHelp;

@property (weak, nonatomic) IBOutlet UIButton *Cancel_Button_Payment;

@property (weak, nonatomic) IBOutlet UIButton *Cancel_Button;
- (IBAction)actionEmailBtn:(UIButton *)sender;
- (IBAction)actionNonebtn:(UIButton *)sender;

- (IBAction)actionCardPayment:(UIButton *)sender;


@end
