#import "AbstractActionSheetPicker.h"

@implementation AbstractActionSheetPicker

@synthesize title             = _title;
@synthesize pickerView        = _pickerView;
@synthesize containerView     = _containerView;
@synthesize actionSheet       = _actionSheet;
@synthesize popOverController = _popOverController;
@synthesize selfReference     = _selfReference;

- (id)initWithTarget:(id)origin  {
    self = [super init];

    if (self) {
        self.containerView = origin;
        self.selfReference = self;
    }

    return self;
}

- (void)dealloc {
    if ([self.pickerView respondsToSelector:@selector(setDelegate:)])   [self.pickerView performSelector:@selector(setDelegate:)   withObject:nil];
    if ([self.pickerView respondsToSelector:@selector(setDataSource:)]) [self.pickerView performSelector:@selector(setDataSource:) withObject:nil];

    self.pickerView        = nil;
    self.containerView     = nil;
    self.actionSheet       = nil;
    self.popOverController = nil;

    [super dealloc];
}

- (void)showActionSheetPicker {
    UIView *masterView = [[UIView alloc] init];

    UIToolbar *pickerToolbar = [self createPickerToolbarWithTitle:self.title];

    pickerToolbar.barStyle = UIBarStyleBlackTranslucent;

    [masterView addSubview:pickerToolbar];

    _pickerView = [self configuredPickerView];

    [masterView addSubview:_pickerView];

    masterView.frame = CGRectMake(0, 0, pickerToolbar.frame.size.width, pickerToolbar.frame.size.height + _pickerView.frame.size.height);

    [self presentPickerForView:masterView];

    [masterView release];
}

- (UIView *)configuredPickerView {
    return nil;
}

- (void)notifyDoneTarget {
}

- (void)notifyCancelTarget {
}

- (UIToolbar *)createPickerToolbarWithTitle:(NSString *)title  {
    UIToolbar *pickerToolbar = [[[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 40)] autorelease];     // fixed width and height

    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    [barItems addObject:[self createButtonWithType:UIBarButtonSystemItemCancel target:self action:@selector(actionPickerCancel:)]];
    [barItems addObject:[self createToolbarLabelWithTitle:title]];
    [barItems addObject:[self createButtonWithType:UIBarButtonSystemItemDone target:self action:@selector(actionPickerDone:)]];

    [pickerToolbar setItems:barItems animated:YES];

    [barItems release];

    return pickerToolbar;
}

- (UIBarButtonItem *)createToolbarLabelWithTitle:(NSString *)title {
    UILabel *toolBarItemlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 185, 40)];     // fixed width and height

    toolBarItemlabel.textAlignment = NSTextAlignmentCenter;
    toolBarItemlabel.font = [UIFont boldSystemFontOfSize:16];
    toolBarItemlabel.text = title;
    toolBarItemlabel.textColor = [UIColor whiteColor];
    toolBarItemlabel.backgroundColor = [UIColor clearColor];

    UIBarButtonItem *buttonLabel = [[[UIBarButtonItem alloc]initWithCustomView:toolBarItemlabel] autorelease];

    [toolBarItemlabel release];

    return buttonLabel;
}

- (UIBarButtonItem *)createButtonWithType:(UIBarButtonSystemItem)type target:(id)target action:(SEL)buttonAction {
    return [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:type target:target action:buttonAction] autorelease];
}

- (void)presentPickerForView:(UIView *)view {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self configureAndPresentActionSheetForView:view];
    } else {
        [self configureAndPresentPopoverForView:view];
    }
}

- (void)configureAndPresentActionSheetForView:(UIView *)view {
    _actionSheet = [[UIActionSheet alloc] init];

    [_actionSheet addSubview:view];

    [_actionSheet showInView:_containerView];

    _actionSheet.bounds = [[UIScreen mainScreen] bounds];
}

- (void)configureAndPresentPopoverForView:(UIView *)view {
    UIViewController *viewController = [[UIViewController alloc] init];

    viewController.view                        = view;
    viewController.contentSizeForViewInPopover = view.frame.size;

    _popOverController = [[UIPopoverController alloc] initWithContentViewController:viewController];

    [_popOverController presentPopoverFromRect:_containerView.superview.frame inView:_containerView.superview permittedArrowDirections:0 animated:YES];

    [viewController release];
}

- (IBAction)actionPickerDone:(id)sender {
    [self notifyDoneTarget];
    [self dismissPicker];
}

- (IBAction)actionPickerCancel:(id)sender {
    [self notifyCancelTarget];
    [self dismissPicker];
}

- (void)dismissPicker {
    if (self.actionSheet) {
        if (self.actionSheet.isVisible) {
            [_actionSheet dismissWithClickedButtonIndex:0 animated:YES];
        }
    }
    
    if (self.popOverController) {
        if (self.popOverController.isPopoverVisible) {
            [_popOverController dismissPopoverAnimated:YES];
        }
    }
    
    self.actionSheet       = nil;
    self.popOverController = nil;
    self.selfReference     = nil;
}

@end
