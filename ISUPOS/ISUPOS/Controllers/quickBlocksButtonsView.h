//
//  quickBlocksButtonsView.h
//  ISUPOS
//
//  Created by Rohit Mahajan on 5/6/15.
//  Copyright (c) 2015 Impinge Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface quickBlocksButtonsView : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate, UISearchBarDelegate>
{
    
    __weak IBOutlet UITextField *blockName;
    __weak IBOutlet UITextField *blockArticle;
     __weak IBOutlet UILabel *title1;
    
    
    __weak IBOutlet UIButton *CAncel_Button;
    
    
    __weak IBOutlet UIButton *Save_Button;
    
     BOOL isEdit;
     NSString *str_id;
}


@property(nonatomic,retain)id callBack;
@property(assign,nonatomic) BOOL isEdit;
@property(nonatomic,retain)NSString *str_id;
@end
