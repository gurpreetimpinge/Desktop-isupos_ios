//
//  quickBlocknextcell.h
//  ISUPOS
//
//  Created by Rohit Mahajan on 4/17/15.
//  Copyright (c) 2015 Impinge Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface quickBlocknextcell : UICollectionViewCell


@property (strong, nonatomic) IBOutlet UIImageView *imageViewProduct;

@property (strong, nonatomic) IBOutlet UILabel *labelProductName;

@property (strong, nonatomic) IBOutlet UILabel *labelAddItem;

@property (strong, nonatomic) IBOutlet UILabel *labelProductVariantCount;

@property (strong, nonatomic) IBOutlet UIImageView *imageProductVariantCount;

@property (strong, nonatomic) IBOutlet UIButton *plus_btn;

@end
