//
//  ManageArticleTableViewCell.h
//  ISUPOS
//
//  Created by Rohit Mahajan on 4/20/15.
//  Copyright (c) 2015 Impinge Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ManageArticleTableViewCell : UITableViewCell
{
    
}
@property (strong, nonatomic) IBOutlet UIImageView *productimage;
@property (strong, nonatomic) IBOutlet UIImageView *barcodeImage;
@property (strong, nonatomic) IBOutlet UILabel *labelProductNumber;
@property (strong, nonatomic) IBOutlet UILabel *labelProductName;
@property (strong, nonatomic) IBOutlet UILabel *labelVat;
@property (strong, nonatomic) IBOutlet UILabel *labelPrice;

@property (weak, nonatomic) IBOutlet UILabel *labelBarCode;

@end
