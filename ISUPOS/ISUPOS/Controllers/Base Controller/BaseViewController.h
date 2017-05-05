//
//  BaseViewController.h
//  ISUPOS
//
//  Created by Mac User on 4/7/15.
//  Copyright (c) 2015 Impinge Solutions. All rights reserved.
//


#import <UIKit/UIKit.h>


@interface BaseViewController : UIViewController


@property BOOL adjustViewForKeyboard;

@property BOOL adjustScrollViewForKeyboard;

@property BOOL keyboardVisible;

- (void) makeNavigationBarSolidWhite;


@end
