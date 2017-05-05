//
//  EditProductVC.h
//  ISUPOS
//
//  Created by Rohit Mahajan on 4/21/15.
//  Copyright (c) 2015 Impinge Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditProductVC : UIViewController
{
    __weak IBOutlet UITextField *txtName;
    __weak IBOutlet UITextField *txtArticleNumber;
}

@property(nonatomic,retain)id callBack;
@end
