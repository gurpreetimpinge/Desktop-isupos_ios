//
//  generalSettingViewController.h
//  ISUPOS
//
//  Created by Rohit Mahajan on 4/24/15.
//  Copyright (c) 2015 Impinge Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface generalSettingViewController : UIViewController<UITextFieldDelegate>
{
    IBOutlet UISwitch *thankyou;
    IBOutlet UISwitch *skip;
    IBOutlet UISwitch *autofill;
    IBOutlet UISwitch *soundinapp;
    
     __weak IBOutlet UITextField *currency_feild;
    __weak IBOutlet UITextField *email_feild;
    __weak IBOutlet UITextField *password_feild;
    __weak IBOutlet UITextField *confirmPassword_feild;

    __weak IBOutlet UITextField *language_feild;
    IBOutlet UIScrollView *scrv;
    
    __weak IBOutlet UIView *currency_view;
    __weak IBOutlet UIView *lang_view;
    
    __weak IBOutlet UITextField *vat_feild;
    
    __weak IBOutlet UILabel *lblPayworksCredentials;
  
    __weak IBOutlet UILabel *lblgeneralsetting;
     __weak IBOutlet UILabel *lblcashpayment;
     __weak IBOutlet UILabel *lblautofill;
     __weak IBOutlet UILabel *lblautofill1;
     __weak IBOutlet UILabel *lblskip;
     __weak IBOutlet UILabel *lblskip1;
     __weak IBOutlet UILabel *lblthank;
     __weak IBOutlet UILabel *lblautodismiss;
    __weak IBOutlet UILabel *lblautodismiss1;
    __weak IBOutlet UILabel *lblsoundeffect;
    __weak IBOutlet UILabel *lblplaysound;
    __weak IBOutlet UILabel *lblvat;
    __weak IBOutlet UILabel *lblvatvariantion;
    __weak IBOutlet UILabel *lbllanguage;
    __weak IBOutlet UILabel *lblemail;
    __weak IBOutlet UILabel *lblCurrency;
    __weak IBOutlet UILabel *lblVat;
   
    __weak IBOutlet UILabel *lblTimeDo;
    
    __weak IBOutlet UILabel *lblInfrasecStatus;
    __weak IBOutlet UISwitch *switch_InfrasecStatus;
    
    __weak IBOutlet UITextField *centralUsername;
    __weak IBOutlet UITextField *centralPassword;
    
    __weak IBOutlet UILabel *lblSoundInApp;
    __weak IBOutlet UILabel *lblCentralKey;
    __weak IBOutlet UILabel *lblInfrasecKey;
    
    __weak IBOutlet UITextField *infrasecUsername;
    __weak IBOutlet UITextField *infrasecPassword;
    
    
    __weak IBOutlet UIView *Time_View;
    __weak IBOutlet UITextField *time_Field;
    __weak IBOutlet UILabel *Time_Formatlbl;
    
    __weak IBOutlet UILabel *Journal_lbl;
    
    __weak IBOutlet UIView *view_Infrasec;
    __weak IBOutlet UIView *view_InfrasecDetail;
    __weak IBOutlet UIView *view_PayTimeJournal;
    
    IBOutlet UILabel *lbl_Email;
    IBOutlet UIButton *btn_Email;
    
    IBOutlet UILabel *lbl_PaymentSwish,*lbl_Other;
    IBOutlet UISwitch *switch_Swish,*switch_Other;
    
    
    }

- (IBAction)toCurrencyBtn:(UIButton*)sender;
- (IBAction)tolanguageBtn:(UIButton*)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtFeild_organizationNumber;
@property (weak, nonatomic) IBOutlet UITextField *txtFeild_posId;

@property (weak, nonatomic) IBOutlet UITextField *timeDoTextField;
- (IBAction)time_Format_button:(UIButton *)sender;


@property (weak, nonatomic) IBOutlet UIButton *Hours_12_Button;
@property (weak, nonatomic) IBOutlet UIButton *Hours_24_Button;

@property(nonatomic,retain)id callBack;

- (IBAction)btn_LogDetail:(UIButton*)sender;
@property (weak, nonatomic) IBOutlet UIButton *label_LogDetails;


- (IBAction)buttonEmailList:(UIButton*)sender;



@end
