//
//  ManageArticalViewController.h
//  ISUPOS
//
//  Created by Rohit Mahajan on 4/20/15.
//  Copyright (c) 2015 Impinge Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ManageArticalViewController : UIViewController<UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate,UIPopoverControllerDelegate>
{
    IBOutlet UIButton *refreshbtn,*addnew;
     IBOutlet UILabel *Numberlbl,*Namelbl,*Vatlbl,*Barcodelbl,*Pricelbl;
}

@end
