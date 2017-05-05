//
//  CustomCellArticlestable.h
//  ISUPOS
//
//  Created by Rohit Mahajan on 4/15/15.
//  Copyright (c) 2015 Impinge Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCellArticlestable : UITableViewCell



@property (strong, nonatomic) IBOutlet UIButton *checkboxImage;
@property (strong, nonatomic) IBOutlet UIImageView *barcodeImage;
@property (strong, nonatomic) IBOutlet UILabel *labelProductNumber;
@property (strong, nonatomic) IBOutlet UILabel *labelProductName;
@property (strong, nonatomic) IBOutlet UILabel *labelVat;
@property (strong, nonatomic) IBOutlet UILabel *labelPrice;
@property (strong, nonatomic) IBOutlet UILabel *labelvariant;

@property (weak, nonatomic) IBOutlet UILabel *label_Barcode;

@end
