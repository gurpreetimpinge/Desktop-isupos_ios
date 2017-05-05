//
//  receiptDataViewController.h
//  ISUPOS
//
//  Created by Rohit Mahajan on 6/22/15.
//  Copyright (c) 2015 Impinge Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface receiptDataViewController : UIViewController<UIPopoverControllerDelegate>
{
     IBOutlet UITextField *organization_name;
     IBOutlet UITextField *company_name;
     IBOutlet UITextField *address1;
     IBOutlet UITextField *address2;
     IBOutlet UITextField *zipcode;
     IBOutlet UITextField *city;
     IBOutlet UITextField *phone;
     IBOutlet UITextField *fax;
     IBOutlet UITextField *homepage;
    
     IBOutlet UITextField *row1;
     IBOutlet UITextField *row2;
     IBOutlet UITextField *row3;
     IBOutlet UITextField *row4;
     IBOutlet UITextField *row5;
     IBOutlet UITextField *row6;
     IBOutlet UITextField *row7;
     IBOutlet UITextField *row8;
     IBOutlet UITextField *row9;
     IBOutlet UITextField *row10;
    
    
    IBOutlet UILabel *organization_name1;
    IBOutlet UILabel *company_name1;
    IBOutlet UILabel *address11;
    IBOutlet UILabel *address21;
    IBOutlet UILabel *zipcode1;
    IBOutlet UILabel *city1;
    IBOutlet UILabel *phone1;
    IBOutlet UILabel *fax1;
    IBOutlet UILabel *homepage1;
    
    IBOutlet UILabel *row11;
    IBOutlet UILabel *row21;
    IBOutlet UILabel *row31;
    IBOutlet UILabel *row41;
    IBOutlet UILabel *row51;
    IBOutlet UILabel *row61;
    IBOutlet UILabel *row71;
    IBOutlet UILabel *row81;
    IBOutlet UILabel *row91;
    IBOutlet UILabel *row101;
    
    
    IBOutlet UILabel *l1;
    IBOutlet UILabel *l2;
    IBOutlet UILabel *l3;

    __weak IBOutlet UILabel *zip_Code_lbl;
    
    __weak IBOutlet UIButton *Save_Button;
    IBOutlet UIScrollView *scrv;
}


@end
