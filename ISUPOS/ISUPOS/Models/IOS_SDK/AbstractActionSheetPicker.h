#import <Foundation/Foundation.h>

@interface AbstractActionSheetPicker : NSObject

- (id)initWithTarget:(id)origin;

- (void)showActionSheetPicker;

- (UIPickerView *)configuredPickerView;

- (void)notifyDoneTarget;
- (void)notifyCancelTarget;

- (UIBarButtonItem *)createToolbarLabelWithTitle :(NSString *)title;
- (UIToolbar       *)createPickerToolbarWithTitle:(NSString *)title;

- (UIBarButtonItem *)createButtonWithType:(UIBarButtonSystemItem)type target:(id)target action:(SEL)buttonAction;

- (void)presentPickerForView:(UIView *)view;

- (void)configureAndPresentActionSheetForView:(UIView *)view;
- (void)configureAndPresentPopoverForView    :(UIView *)view;

- (IBAction)actionPickerDone  :(id)sender;
- (IBAction)actionPickerCancel:(id)sender;

- (void)dismissPicker;

@property (nonatomic, copy)   NSString            *title;
@property (nonatomic, retain) UIView              *pickerView;
@property (nonatomic, retain) UIView              *containerView;
@property (nonatomic, retain) UIActionSheet       *actionSheet;
@property (nonatomic, retain) UIPopoverController *popOverController;
@property (nonatomic, retain) NSObject            *selfReference;

@end
