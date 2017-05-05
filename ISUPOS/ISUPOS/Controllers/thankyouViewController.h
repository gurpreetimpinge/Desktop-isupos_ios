//
//  thankyouViewController.h
//  ISUPOS
//
//  Created by Rohit Mahajan on 6/19/15.
//  Copyright (c) 2015 Impinge Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface thankyouViewController : UIViewController
{
    IBOutlet UILabel *amount_lbl;
    
    IBOutlet UILabel *thankyou_lbl;
    IBOutlet UILabel *completed_lbl;
}


@property(nonatomic,retain)id callBack;
@end
