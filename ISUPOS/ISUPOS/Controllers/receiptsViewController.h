//
//  receiptsViewController.h
//  ISUPOS
//
//  Created by Rohit Mahajan on 4/15/15.
//  Copyright (c) 2015 Impinge Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface receiptsViewController : UIViewController<UISearchBarDelegate,UIPopoverControllerDelegate, MFMailComposeViewControllerDelegate>
{
    IBOutlet UILabel *article_Number,*receipt_Text,*amount_lbl,*price_lbl,*Vat_lbl,*discount_lbl,*totallbl,*article_lbl;
    IBOutlet UILabel *amount_lbl1,*totallbl1,*article_lbl1;
    IBOutlet UISearchBar *scrv;
}

- (IBAction)mailSendButton:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *Btn_barcode_filter;

- (IBAction)barcode_filter_action:(id)sender;


@end
