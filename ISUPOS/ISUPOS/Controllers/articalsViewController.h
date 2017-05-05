//
//  articalsViewController.h
//  ISUPOS
//
//  Created by Rohit Mahajan on 4/15/15.
//  Copyright (c) 2015 Impinge Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MiniPrinterFunctions.h"


@interface articalsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,UITextFieldDelegate,UIPopoverControllerDelegate>
{
    IBOutlet UITextField *searchfield;
    IBOutlet UIView *variantView;
    IBOutlet UITextField *variantFeild;
    
    IBOutlet UILabel *customName,*CustomAmount,*customTotal,*customUnitName,*variantlbl;
    IBOutlet UITextField *customUnit;
    IBOutlet UIView *customUnitView;
    IBOutlet UISearchBar *scrv;
    
    IBOutlet UILabel *Numberlbl,*Namelbl,*Vatlbl,*Barcodelbl,*Pricelbl;
    IBOutlet UIButton *Addbtn;
    MiniPrinterFunctions *miniPrinterFunctions;
    
    __weak IBOutlet UIButton *art_custom_cancelBtn;
    __weak IBOutlet UIButton *add_custom__addBtn;
    
    __weak IBOutlet UIButton *button_Barcode;
    
 
}

@property (weak, nonatomic) IBOutlet UIButton *customBtn;



-(IBAction)variantAdditemandCancelbtn:(id)sender;
- (IBAction)Barcode_filter_action:(id)sender;


@end
