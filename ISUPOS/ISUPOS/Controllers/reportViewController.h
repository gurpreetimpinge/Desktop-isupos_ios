//
//  reportViewController.h
//  ISUPOS
//
//  Created by Rohit Mahajan on 4/21/15.
//  Copyright (c) 2015 Impinge Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface reportViewController : UIViewController<UIPopoverControllerDelegate>
{
    IBOutlet UILabel *printerCopies;
    IBOutlet UIView *printerview;
    IBOutlet UITableView *maintablev, *tableViewItems;
    
    IBOutlet UILabel *labelTotal, *labelQuantity;
    
    IBOutlet UILabel *labelCashPayment, *labelCashPaymentValue, *labelFooterDate, *labelHeaderDate, *labelDiscount,*labelRefund,*labelRefundTotal, *labelDis;
    
    
    IBOutlet UILabel *labelCardPayment, *labelCardPaymentValue, *labelFee, *labelFeeValue, *labelTopSelling, *labelTotalSale, *labelPayments;
    //    IBOutlet UILabel *labelTopSeFirstProduct, *labelTopSeSecondProduct, *labelTopSeFirstProductQunt, *labelTopSeSecondProductQunt, *labelTopSeFirstProductValue, *labelTopSeSecondProductValue;
}
@property (weak, nonatomic) IBOutlet UISegmentedControl *dayMonthSegmentBtn;

- (IBAction)btn_Printer_Action:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UIView *report_PrinterView;

@property (weak, nonatomic) IBOutlet UILabel *reportPrinterCopies;
@property (weak, nonatomic) IBOutlet UIButton *btnGenerateZDay;

@property (weak, nonatomic) IBOutlet UIView *viewBaseTopSelling;

- (IBAction)actionBtnZDayReport:(UIButton *)sender;

- (IBAction)select_printReceipt:(id)sender;
- (IBAction)stepper_Action:(UIStepper *)sender;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Emailed;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Printed;
@property (weak, nonatomic) IBOutlet UILabel *lbl_GrandTotSales;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Grandrefund;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Products;
@property (weak, nonatomic) IBOutlet UILabel *lbl_grandSaleRef;
@property (weak, nonatomic) IBOutlet UILabel *grandRefundValue;
@property (weak, nonatomic) IBOutlet UILabel *grandSaleRefundValue;
//@property (weak, nonatomic) IBOutlet UILabel *emailed_Value;
//@property (weak, nonatomic) IBOutlet UILabel *printed_Value;
@property (weak, nonatomic) IBOutlet UILabel *grandTotSaleValue;
@property (weak, nonatomic) IBOutlet UILabel *products_Value;
@property (weak, nonatomic) IBOutlet UILabel *label_PrinterName;

@property (weak, nonatomic) IBOutlet UIButton *btn_Print;
@property (weak, nonatomic) IBOutlet UILabel *lbl_PrinterReport;

@property (weak, nonatomic) IBOutlet UILabel *lbl_PrinterOptionsReport;

@property (weak, nonatomic) IBOutlet UIButton *btnMailReceipt;  

@property (weak, nonatomic) IBOutlet UIButton *btnPrintReceipt;

@property (weak, nonatomic) IBOutlet UILabel *labelReportNumber;

@property (weak, nonatomic) IBOutlet UILabel *labelCopiesEmail;
@property (weak, nonatomic) IBOutlet UILabel *labelCopiesPrint;
@property (weak, nonatomic) IBOutlet NSString *str_paymentMethod;



@end
