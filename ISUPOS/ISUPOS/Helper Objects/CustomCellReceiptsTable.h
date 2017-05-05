//
//  CustomCellReceiptsTable.h
//  ISUPOS
//
//  Created by Rohit Mahajan on 4/15/15.
//  Copyright (c) 2015 Impinge Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCellReceiptsTable : UITableViewCell




@property (strong, nonatomic) IBOutlet UILabel *labelArticleNumber;
@property (strong, nonatomic) IBOutlet UILabel *labelProductName;
@property (strong, nonatomic) IBOutlet UILabel *labelProductCount;
@property (strong, nonatomic) IBOutlet UILabel *labelProductPrice;

@property (strong, nonatomic) IBOutlet UILabel *labelProductVat;
@property (strong, nonatomic) IBOutlet UILabel *labelProductDiscount;
@property (strong, nonatomic) IBOutlet UILabel *labelProductTotal;

@end
