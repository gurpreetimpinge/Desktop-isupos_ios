//
//  quickButtonCartlongPrssView.h
//  ISUPOS
//
//  Created by Rohit Mahajan on 4/22/15.
//  Copyright (c) 2015 Impinge Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface quickButtonCartlongPrssView : UIViewController
{
    __weak IBOutlet UITextField *txtcomment;
    __weak IBOutlet UITextField *commenttxt;
     __weak IBOutlet UITextField *txtamount;
    __weak IBOutlet UILabel *txtamount_label;
    
    __weak IBOutlet UILabel *txtname_label;
    
    __weak IBOutlet UIButton *percetageButton;
    __weak IBOutlet UIButton *uroButton;
    
    __weak IBOutlet UIButton *quick_Cart_Cancel_Btn;
    
    __weak IBOutlet UIButton *remove_Cart_Btn;
    
    
    
}


@property(nonatomic,retain)id callBack;
@end
