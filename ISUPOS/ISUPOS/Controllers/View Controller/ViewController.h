//
//  ViewController.h
//  ISUPOS
//
//  Created by Mac User on 4/2/15.
//  Copyright (c) 2015 Impinge Solutions. All rights reserved.
//


#import "BaseViewController.h"


@interface ViewController : UIViewController<UITextFieldDelegate>
{
    IBOutlet UIButton *login,*cancel;
    
    __weak IBOutlet UIButton *registerButton;
    __weak IBOutlet UIButton *skipButton;
    __weak IBOutlet UIButton *doneButton;
    __weak IBOutlet UIWebView *webView;
}
- (IBAction)doneButtonAction:(id)sender;
- (IBAction)skipButtonAction:(id)sender;
- (IBAction)registerButtonAction:(id)sender;

@end