//
//  LogViewController.h
//  ISUPOS
//
//  Created by Mandeep Sharma on 26/10/15.
//  Copyright (c) 2015 Impinge Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LogViewController : UIViewController<UIPopoverControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *headerView;
- (IBAction)backButton_Action:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;

@property (weak, nonatomic) IBOutlet UIButton *btnPrinter;

- (IBAction)btnPrinterAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnMail;
- (IBAction)btnMailAction:(UIButton *)sender;
- (IBAction)btnPrint_Log:(UIButton *)sender;
- (IBAction)stepper_Action:(UIStepper *)sender;
@property (weak, nonatomic) IBOutlet UILabel *printerCopies;
@property (weak, nonatomic) IBOutlet UIView *printerView;

@property (weak, nonatomic) IBOutlet UILabel *label_PrinterName;

@property (weak, nonatomic) IBOutlet UILabel *label_Desc;
@property (weak, nonatomic) IBOutlet UILabel *label_Date;
@property (weak, nonatomic) IBOutlet UILabel *lbl_PrinterOptions;

@property (weak, nonatomic) IBOutlet UILabel *lbl_Printer;

@property (weak, nonatomic) IBOutlet UIButton *btn_Print;

@property (weak, nonatomic) IBOutlet UINavigationItem *logView;

@end
