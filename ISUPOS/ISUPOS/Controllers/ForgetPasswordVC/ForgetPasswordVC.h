//
//  ForgetPasswordVC.h
//  ISUPOS
//
//  Created by Mac User on 4/9/15.
//  Copyright (c) 2015 Impinge Solutions. All rights reserved.
//

#import "ViewController.h"

@interface ForgetPasswordVC : BaseViewController

{

    __weak IBOutlet UITextField *txtEmail;

}

@property(nonatomic,retain)id callBack;

@end
