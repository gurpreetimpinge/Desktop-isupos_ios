//
//  parkrecieptTableViewCell.h
//  ISUPOS
//
//  Created by Rohit Mahajan on 4/15/15.
//  Copyright (c) 2015 Impinge Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface parkrecieptTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *labelTotalPrice;
@property (strong, nonatomic) IBOutlet UILabel *labelCustomerName;
@property (strong, nonatomic) IBOutlet UILabel *labelProductdate;
@property (strong, nonatomic) IBOutlet UIButton *activate_button;

@end
