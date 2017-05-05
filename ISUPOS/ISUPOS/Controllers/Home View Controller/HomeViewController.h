//
//  HomeViewController.h
//  ISUPOS
//
//  Created by Gurpreet on 07/04/15.
//  Copyright (c) 2015 Impinge Solutions. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "MiniPrinterFunctions.h"


@interface HomeViewController : UIViewController<UICollectionViewDelegate,UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate,UIPopoverControllerDelegate>
{
    IBOutlet UIView *variantView;
    IBOutlet UITextField *variantFeild;
    IBOutlet UILabel *nextlabel;
    
    
    IBOutlet UILabel *customName,*CustomAmount,*customTotal,*customUnitName,*quickbutton12;
    IBOutlet UITextField *customUnit;
    IBOutlet UIView *customUnitView;
    
    IBOutlet UISearchBar *scrv;

    IBOutlet UITableView *tableview_varient;
    MiniPrinterFunctions *miniPrinterFunctions;
    IBOutlet UIView *view1;
    
}
@property (strong, nonatomic) IBOutlet UILabel *labelNew;
@property (strong, nonatomic) IBOutlet UILabel *labelNew1;
-(IBAction)variantAdditemandCancelbtn:(id)sender;

-(IBAction)customUnitCancelandDoneBtn:(UIButton*)sender;

@property (weak, nonatomic) IBOutlet UIButton *add_Button;

@property (weak, nonatomic) IBOutlet UILabel *select_Variant;
@property (weak, nonatomic) IBOutlet UIButton *add_Item;

@property (weak, nonatomic) IBOutlet UIButton *CancelButtonAddItem;

@property (weak, nonatomic) IBOutlet UIButton *buttonCancelCustom;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *back_BarButton;
@property (weak, nonatomic) IBOutlet UISearchBar *searhBarHome;
@property (weak, nonatomic) IBOutlet UIImageView *searchIcon;
@property (weak, nonatomic) IBOutlet UIImageView *SearchImage;
@property (weak, nonatomic) IBOutlet UIButton *customBtnQuick;
//@property (weak, nonatomic) IBOutlet UIButton *buttonClear;
- (IBAction)action_ClearButton:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIImageView *ImageViewCircle;

@end
