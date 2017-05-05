//
//  CustomTableViewCell.h
//  ISUPOS
//
//  Created by Gurpreet on 10/04/15.
//  Copyright (c) 2015 Impinge Solutions. All rights reserved.
//


#import <UIKit/UIKit.h>


@interface CustomTableViewCell : UITableViewCell


@property (strong, nonatomic) IBOutlet UIImageView *imageViewProduct;

@property (strong, nonatomic) IBOutlet UILabel *labelProductName, *labelProductQuantity, *labelProductPrice,*labelComment,*labelBarcode;

@property (strong, nonatomic) IBOutlet UIButton *buttonDecrease, *buttonIncrease;


@end