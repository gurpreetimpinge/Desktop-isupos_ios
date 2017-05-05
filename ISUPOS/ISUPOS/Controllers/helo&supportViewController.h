//
//  helo&supportViewController.h
//  ISUPOS
//
//  Created by Rohit Mahajan on 4/24/15.
//  Copyright (c) 2015 Impinge Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface helo_supportViewController : UIViewController
{
    IBOutlet UILabel *lblhelp,*howto,*contact;
}

@property (weak, nonatomic) IBOutlet UIButton *Close_Button;

- (IBAction)actionSupportPages:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UILabel *Support_pages;

@property(nonatomic,retain)id callBack;
@end
