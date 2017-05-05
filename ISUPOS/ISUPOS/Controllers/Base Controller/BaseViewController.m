//
//  BaseViewController.m
//  ISUPOS
//
//  Created by Mac User on 4/7/15.
//  Copyright (c) 2015 Impinge Solutions. All rights reserved.
//


#import "BaseViewController.h"

// Helper Classes
#import "BRYParseKeyboardNotification.h"
#import "UIView+TKGeometry.h"


@interface BaseViewController ()


@end


@implementation BaseViewController



#pragma mark - View LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Splunk Mint Breadcrumb added
    [[Mint sharedInstance] leaveBreadcrumb:@"BaseViewController_ViewController"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
  
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - Keyboard Handling

- (void)keyboardWillShow:(NSNotification *)n
{
    self.keyboardVisible = YES;
    
    BRYParseKeyboardNotification(n, ^(NSTimeInterval keyboardAnimationDuration, CGFloat keyboardHeight, UIViewAnimationOptions keyboardAnimationOptions)
    {
        [self keyboardWillShowWithHeight:keyboardHeight animationDuration:keyboardAnimationDuration];
    });
}

- (void)keyboardWillHide:(NSNotification *)n
{
    self.keyboardVisible = NO;
    
    BRYParseKeyboardNotification(n, ^(NSTimeInterval keyboardAnimationDuration, CGFloat keyboardHeight, UIViewAnimationOptions keyboardAnimationOptions)
    {
        [self keybiardWillHideWithAnimationDuration:keyboardAnimationDuration];
    });
}

- (void) keyboardWillShowWithHeight: (float) keyboardHeight animationDuration:(float) keyboardAnimationDuration
{
    if (self.adjustViewForKeyboard)
    {
        UITextField *tf = [self findFirstResponder];
        
        CGRect tfBounds = [self.view.window convertRect:tf.bounds fromView:tf];
        
        float lengthToKbd = (self.view.window.height - keyboardHeight) - (tfBounds.origin.y + tfBounds.size.height);
        
        float offsetToKbd = 100;
        
        if (lengthToKbd < offsetToKbd)
        {
            [UIView animateWithDuration:keyboardAnimationDuration animations:^{
                self.view.yOrigin -= offsetToKbd - lengthToKbd;
            }];
        }
    }
    
    if (self.adjustScrollViewForKeyboard)
    {
        UIScrollView *scrollView = [self performSelector:@selector(scrollView)];
       
        float newScrollViewHeight = scrollView.height - keyboardHeight;
        
        [UIView animateWithDuration:keyboardAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            scrollView.contentInsetBottom = keyboardHeight;
        
            scrollView.contentOffsetY = scrollView.contentSize.height - newScrollViewHeight;
        }
                         completion:nil];
    }
}

- (void) keybiardWillHideWithAnimationDuration:(float) keyboardAnimationDuration
{
    if (self.adjustViewForKeyboard)
    {
        [UIView animateWithDuration:keyboardAnimationDuration animations:^{
            self.view.yOrigin = 0;
        }];
    }
    
    if (self.adjustScrollViewForKeyboard)
    {
        UIScrollView *scrollView = [self performSelector:@selector(scrollView)];
        [UIView animateWithDuration:keyboardAnimationDuration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            scrollView.contentInsetBottom = 0;
        } completion:nil];
    }
}

- (id) findFirstResponder
{
    return [self findFirstResponderWithView:self.view];
}

- (UIView *)findFirstResponderWithView:(UIView *) view
{
    if (view.isFirstResponder)
    {
        return view;
    }
    
    __block UIView *res;
    
    [view.subviews enumerateObjectsUsingBlock:^(UIView *subview, NSUInteger idx, BOOL *stop)
     {
         UIView *subviewRes = [self findFirstResponderWithView:subview];
         if (subviewRes)
         {
             *stop = YES;
             res = subviewRes;
         }
     }];
    
    return res;
}


#pragma mark - Some Helpers

- (void) makeNavigationBarSolidWhite
{
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
   
    [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    
    [self removeLineUnderNavbar];
}


- (void) removeLineUnderNavbar
{
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0)
    {
        // this is a hacky solution but it works
        for (UIView *view in [[self.navigationController.navigationBar.subviews objectAtIndex:0] subviews])
        {
            if ([view isKindOfClass:[UIImageView class]]) view.hidden = YES;
        }
    }
}


@end
