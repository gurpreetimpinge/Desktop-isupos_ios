//
//  EditProductVC.m
//  ISUPOS
//
//  Created by Rohit Mahajan on 4/21/15.
//  Copyright (c) 2015 Impinge Solutions. All rights reserved.
//

#import "EditProductVC.h"
#import "UITextField+Validations.h"
@interface EditProductVC ()

@end

@implementation EditProductVC
@synthesize callBack;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
        // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    self.view.superview.layer.cornerRadius = 0;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)toDeleteAndCancelAndOkBtn:(UIButton*)sender
{
    int btnTag = (int)sender.tag;
    
    if(btnTag == 1)
    {
       
        
    }
    else if (btnTag==2)
    {
        if(callBack!= nil && [callBack respondsToSelector:@selector(toDismissThePopover)] )
        {
            [callBack performSelector:@selector(toDismissThePopover)];
        }

    }
    else
    {
        
    }
    
    
}
-(void)toDismissThePopover
{
    //[popover dismissPopoverAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
