//
//  SidePanelViewController.m
//  ISUPOS
//
//  Created by Gurpreet on 09/04/15.
//  Copyright (c) 2015 Impinge Solutions. All rights reserved.
//


#import "SidePanelViewController.h"

// Custom Cell
#import "CustomTableViewCell.h"


@interface SidePanelViewController ()
{
    IBOutlet UIView *viewBackground;
    
    IBOutlet UIButton *buttonClear, *buttonCharge;
    
    IBOutlet UITableView *tableViewSidePanel;
    
    NSMutableArray *arrayProductImage, *arrayProductName, *arrayProductQuantity, *arrayProductPrice;
}
@property (strong, nonatomic)IBOutlet UITableView *tableViewSidePanel;
@end


@implementation SidePanelViewController
@synthesize tableViewSidePanel;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
        // Custom initialization
    }
    return self;
}


#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    // Splunk Mint Breadcrumb added
    [[Mint sharedInstance] leaveBreadcrumb:@"SidePanelViewController_ViewController"];
    
    self.view.backgroundColor = [UIColor colorWithRed:235.0f/255.0f green:235.0f/255.0f blue:235.0f/255.0f alpha:1.0f];
    
    viewBackground.backgroundColor = [UIColor colorWithRed:235.0f/255.0f green:235.0f/255.0f blue:235.0f/255.0f alpha:1.0f];
    
    [buttonClear setTitleColor:[UIColor colorWithRed:112.0f/255.0f green:60.0f/255.0f blue:136.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    
    buttonCharge.backgroundColor = [UIColor colorWithRed:171.0f/255.0f green:171.0f/255.0f blue:171.0f/255.0f alpha:1.0f];
    
    tableViewSidePanel.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    arrayProductImage = [[NSMutableArray alloc] initWithObjects:@"2.jpg", @"1.jpg", nil];
    
    arrayProductName = [[NSMutableArray alloc] initWithObjects:@"Chocolate Truffle", @"Dairy Milk", nil];
    
    arrayProductQuantity = [[NSMutableArray alloc] initWithObjects:@"2", @"2", nil];
    
    arrayProductPrice = [[NSMutableArray alloc] initWithObjects:@"€42.40", @"€42.40", nil];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void) viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}


#pragma mark - IBActions


#pragma mark - UITableView Datasource Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[CustomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.backgroundColor = [UIColor clearColor];
    
    cell.imageViewProduct.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", [arrayProductImage objectAtIndex:0]]];
    
    cell.labelProductName.text = [arrayProductName objectAtIndex:0];
    
    cell.labelProductQuantity.text = [arrayProductQuantity objectAtIndex:0];
    
    cell.labelProductPrice.text = [arrayProductPrice objectAtIndex:0];
    
    return cell;
}


#pragma mark - Memory Handling

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
