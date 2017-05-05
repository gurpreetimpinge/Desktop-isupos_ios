//
//  customDiscountViewController.h
//  ISUPOS
//
//  Created by Rohit Mahajan on 6/24/15.
//  Copyright (c) 2015 Impinge Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface customDiscountViewController : UIViewController
{
    __weak IBOutlet UIButton *percetageButton;
    __weak IBOutlet UIButton *uroButton;
    
    __weak IBOutlet UITextField *discount;
    __weak IBOutlet UITextField *discription;
    
   __weak IBOutlet UIButton *delButton;
     IBOutlet UILabel *lbltitle;
    
    __weak IBOutlet UIButton *cancel_Button;
    
   
}
@property(nonatomic,retain)id callBack;
@property(nonatomic,strong)NSString *str_ID;
@property(nonatomic,strong)NSString *str_TotalAmount;

@end
