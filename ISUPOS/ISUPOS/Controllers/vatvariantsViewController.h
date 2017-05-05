//
//  vatvariantsViewController.h
//  ISUPOS
//
//  Created by Rohit Mahajan on 7/7/15.
//  Copyright (c) 2015 Impinge Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface vatvariantsViewController : UIViewController

{
     __weak IBOutlet UITextField *addVat_feild;
     __weak IBOutlet UIView *addVatView;
    
    __weak IBOutlet UILabel *varinats;
    
      __weak IBOutlet UITableView *addVatVariantTable;
}
@end
