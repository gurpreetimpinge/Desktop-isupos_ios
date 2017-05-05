//
//  CustomCellQuickButtons.h
//  ISUPOS
//
//  Created by Gurpreet on 10/04/15.
//  Copyright (c) 2015 Impinge Solutions. All rights reserved.
//


#import <UIKit/UIKit.h>


@interface CustomCellQuickButtons : UICollectionViewCell


@property (strong, nonatomic) IBOutlet UIImageView *imageViewProduct;

@property (strong, nonatomic) IBOutlet UILabel *labelProductName;

@property (strong, nonatomic) IBOutlet UIButton *addItembutton;

@property (strong, nonatomic) IBOutlet UILabel *labelProductVariantCount;

@property (strong, nonatomic) IBOutlet UIImageView *imageProductVariantCount;
@end
