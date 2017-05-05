//
//  TrasectionsViewController.h
//  ISUPOS
//
//  Created by Rohit Mahajan on 4/21/15.
//  Copyright (c) 2015 Impinge Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MiniPrinterFunctions.h"
#import "SearchPrinterViewController.h"


@interface TrasectionsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIPopoverControllerDelegate, UISearchBarDelegate, UIAlertViewDelegate>
{
    
    MiniPrinterFunctions *miniPrinterFunctions;
    
    IBOutlet UILabel *printerCopies;
    IBOutlet UIView *printerview;
    IBOutlet UITableView *tablev, *tableViewItems;
    
    IBOutlet UILabel *labelReceipt;
    
    //    IBOutlet UILabel *labelFirstProduct, *labelSecondProduct;
    //
    //    IBOutlet UILabel *labelFirstProductValue, *labelSecondProductValue;
    
    IBOutlet UILabel *labelTotalAmount, *labelVat, *labelFooterDate;
    
    IBOutlet UILabel *labelFirstProductQntity, *labelSecondProductQntity,*Label_PrinterName, *labelRefundedAmount;
    
    IBOutlet UIButton *buttonRefundAmount, *buttonViewOriginal;
    
    IBOutlet UISearchBar *searchBarTest;
    
    __weak IBOutlet UILabel *labelReceiptId;
    IBOutlet UILabel *labelSearchTop;
    
    __weak IBOutlet UIButton *mailSendButton;
    
    __weak IBOutlet UIButton *btnCash;
    
    __weak IBOutlet UIButton *labelViewMap;
    
}

- (IBAction)mailSendAction:(UIButton *)sender;

- (IBAction)cashButton:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *print_Options_lbl;
@property (weak, nonatomic) IBOutlet UILabel *printer_label;
@property (weak, nonatomic) IBOutlet UIButton *print_status;


@end
