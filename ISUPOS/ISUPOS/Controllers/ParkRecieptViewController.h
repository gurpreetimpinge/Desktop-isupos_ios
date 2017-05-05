//
//  ParkRecieptViewController.h
//  ISUPOS
//
//  Created by Rohit Mahajan on 4/15/15.
//  Copyright (c) 2015 Impinge Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface ParkRecieptViewController : UIViewController<MFMailComposeViewControllerDelegate>

{
    IBOutlet UILabel *amount_lbl1,*totallbl1,*article_lbl1;
    IBOutlet UILabel *actionlbl,*parktimelbl,*notice_lbl,*total_lbl;
    
    IBOutlet UIButton *b1,*b2;
}

-(IBAction)park_current_cart_btn:(id)sender;
- (IBAction)mailSendButton:(UIButton *)sender;


@end
