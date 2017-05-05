//
//  LogViewCustomTableViewCell.h
//  ISUPOS
//
//  Created by Mandeep Sharma on 26/10/15.
//  Copyright (c) 2015 Impinge Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LogViewCustomTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lbl_SerialNumber;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Description;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Date;
@end
