//
//  articlepopupViewController.h
//  ISUPOS
//
//  Created by Rohit Mahajan on 4/23/15.
//  Copyright (c) 2015 Impinge Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface articlepopupViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    IBOutlet UIView *PopBackView;
    IBOutlet UIView *PopDiscountView;
    IBOutlet UIView *PopvariantView;
    __weak IBOutlet UIButton *cameraButton;

    int valueType;
    
    __weak IBOutlet UILabel *vatLabel;
    __weak IBOutlet UITextField *nameLabel;
    __weak IBOutlet UILabel *priceLabel;
    
    __weak IBOutlet UITextField *priceLabel1;
    
    IBOutlet UIView *CameraPopView;
    IBOutlet UIView *VatPopView;
    IBOutlet UIView *PricePopView;
    
    __weak IBOutlet UITextField *variant_title_field;
    __weak IBOutlet UITextField *variant_price_field;
    
    __weak IBOutlet UITableView *addVariantTable;
    
     __weak IBOutlet UITableView *vattable;

    
      IBOutlet UILabel *lbltitle;
    
    __weak IBOutlet UILabel *lblEditProduct;
    
    __weak IBOutlet UILabel *lblVat;
    
    __weak IBOutlet UIButton *btnDelete;
    
    __weak IBOutlet UIButton *btnCustomUnit;
    
    __weak IBOutlet UIButton *lblTakePhoto;
    
    __weak IBOutlet UIButton *lblChooseFrmLib;
    
    __weak IBOutlet UIButton *btnPricePerUnit;
    
    __weak IBOutlet UIButton *btnSubmitVariant;
    
    __weak IBOutlet UIButton *btnCancelVariant;
    
    __weak IBOutlet UITextField *customUnit_Field;
    
    
    __weak IBOutlet UIButton *cancel_Button;
    
    __weak IBOutlet UITextField *DescriptionField;
    
    __weak IBOutlet UITextField *barcode_Field;
    

}

@property(nonatomic, retain) id callBack;



@end
