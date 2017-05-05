//
//  addNewProductView.h
//  ISUPOS
//
//  Created by Rohit Mahajan on 5/4/15.
//  Copyright (c) 2015 Impinge Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface addNewProductView : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    IBOutlet UIView *PopBackView;
    IBOutlet UIView *PopDiscountView;
    IBOutlet UIView *PopvariantView;
    
    __weak IBOutlet UIButton *cameraButton;
    
    
      __weak IBOutlet UIButton *vatButton1;
      __weak IBOutlet UIButton *vatButton2;
      __weak IBOutlet UIButton *vatButton3;
      __weak IBOutlet UIButton *vatButton4;
    
    __weak IBOutlet UILabel *vatLabel;
    __weak IBOutlet UILabel *priceLabel;
    
    IBOutlet UIView *CameraPopView;
    IBOutlet UIView *VatPopView;
    IBOutlet UIView *PricePopView;
    
    IBOutlet UISegmentedControl *segmentDiscountAndProduct;

    __weak IBOutlet UIButton *percetageButton;
    __weak IBOutlet UIButton *uroButton;
    
    __weak IBOutlet UITextField *title_product;
    
    __weak IBOutlet UITextField *discount;
    __weak IBOutlet UITextField *discription;
    
    __weak IBOutlet UITableView *addVariantTable;
    __weak IBOutlet UITableView *vattable;
    
    __weak IBOutlet UITextField *variant_title_field;
    __weak IBOutlet UITextField *variant_price_field;
    __weak IBOutlet UITextField *product_price_field;
    
    
     __weak IBOutlet UILabel *newProductlbl;
    
    __weak IBOutlet UILabel *lblVat;
    
    
    __weak IBOutlet UIButton *btnCustomUnit;
    
    __weak IBOutlet UIButton *lblTakePhoto;
    
    __weak IBOutlet UIButton *lblChooseFrmLib;
    
    __weak IBOutlet UIButton *btnPricePerUnit;
    
    __weak IBOutlet UITextField *customUnit_Field;
    
    __weak IBOutlet UIButton *submit_Button;
    
    __weak IBOutlet UIButton *cancel_Button;
    
    __weak IBOutlet UIButton *add_Cancel_Button;
    
    
    __weak IBOutlet UIButton *Save_Button;
    
    __weak IBOutlet UITextField *textFieldBarcode;
    
}


@property(nonatomic,retain)id callBack;
@end
