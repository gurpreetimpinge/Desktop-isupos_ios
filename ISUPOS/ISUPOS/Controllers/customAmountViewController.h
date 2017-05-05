//
//  customAmountViewController.h
//  ISUPOS
//
//  Created by Rohit Mahajan on 6/24/15.
//  Copyright (c) 2015 Impinge Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface customAmountViewController : UIViewController
{
    
   
    
    __weak IBOutlet UIButton *percetageButton;
    __weak IBOutlet UIButton *uroButton;
    
    __weak IBOutlet UITextField *discount;
    
    __weak IBOutlet UITextField *customAmount;
    __weak IBOutlet UITextField *description_feild;
    __weak IBOutlet UILabel *vatLabel;
    
    
    __weak IBOutlet UIButton *cus_Amt_Cancel_Button;
    
      __weak IBOutlet UITableView *vattable;
    
    
    
    __weak IBOutlet UIButton *delButton;
    
    IBOutlet UIView *PopDiscountView;
    
    IBOutlet UILabel *lbltitle;
    
    IBOutlet UILabel *lblDiscount;
    
    
    __weak IBOutlet UITextField *cus_Amt_Vat;
    
}
@property(nonatomic,retain)id callBack;
@end
