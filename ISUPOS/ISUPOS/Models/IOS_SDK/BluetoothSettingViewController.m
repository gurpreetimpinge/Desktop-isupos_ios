//
//  BluetoothSettingViewController.m
//  IOS_SDK
//
//  Created by u3237 on 2013/10/24.
//
//

#import <StarIO/SMBluetoothManager.h>
#import "BluetoothSettingViewController.h"
#import "Language.h"

typedef enum _AlertViewType {
    AlertViewTypeAlphabetPINCode = 100
} AlertViewType;

@implementation BluetoothSettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil bluetoothManager:(SMBluetoothManager *)manager
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.bluetoothManager = manager;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Splunk Mint Breadcrumb added
    [[Mint sharedInstance] leaveBreadcrumb:@"BluetoothSettings_ViewController"];
    // Do any additional setup after loading the view from its nib.
    functions = [[NSArray alloc] initWithObjects:@"Device Name", @"iOS Port Name", @"Auto Connect", @"Security", @"Change PIN Code", @"New PIN Code", nil];
    
    self.mainTable.delegate = self;
    self.mainTable.dataSource = self;
    self.mainTable.scrollEnabled = NO;

    changePINcode = NO;
    
    //Gesture Recognizer
    singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSingleTap:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.delegate = self;
    [self.view addGestureRecognizer:singleTap];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [singleTap release];
    
    [functions release];
    [_bluetoothManager release];
    [_mainTable release];
    
    [super dealloc];
}

- (void)viewDidUnload
{
    [singleTap release];
    singleTap = nil;
    
    [functions release];
    functions = nil;
    [_bluetoothManager release];
    _bluetoothManager = nil;
    [_mainTable release];
    _mainTable = nil;

    [super viewDidUnload];
}

#pragma mark Gesture Recognizer

- (void)onSingleTap:(UITapGestureRecognizer *)recognizer
{
    [self.view endEditing:YES];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (gestureRecognizer == singleTap) {
        if ((deviceNameField.isFirstResponder)  ||
            (iOSPortNameField.isFirstResponder) ||
            (pinCodeField.isFirstResponder)) {
            return YES;
        } else {
            return NO;
        }
    }
    return YES;
}

#pragma mark UIButton

- (IBAction)back:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)applySettings:(id)sender {
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:[Language get:@"Error" alter:@"!Error"] message:@"" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] autorelease];
    
    if ((self.bluetoothManager.autoConnect == YES) && (self.bluetoothManager.security == SMBluetoothSecurityPINcode)) {
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:[Language get:@"Error" alter:@"!Error"]
                                                         message:[Language get:@"Auto Connection function is available only when the security setting is \"SSP\"." alter:@"!Auto Connection function is available only when the security setting is \"SSP\"."]
                                                        delegate:self
                                               cancelButtonTitle:nil
                                               otherButtonTitles:@"OK", nil] autorelease];
        [alert show];
        return;
    }
    
    //Check PIN Code
    if (changePINcode == YES) {
        if ([self validatePinCodeChar:self.bluetoothManager.pinCode] == NO) {
//            alert.message = [NSString stringWithFormat:@"%@ is invalid PIN Code", self.bluetoothManager.pinCode];
            
            alert.message = [NSString stringWithFormat:@"%@ %@", self.bluetoothManager.pinCode, [Language get:@"is invalid PIN Code" alter:@"is invalid PIN Code"]];

            [alert show];
            return;
        }

        if ((self.bluetoothManager.pinCode.length < 4) ||
            (self.bluetoothManager.pinCode.length > 16)) {
            alert.message = [NSString stringWithFormat:@"%@", [Language get:@"The PIN Code is 4 to 16 digits." alter:@"!The PIN Code is 4 to 16 digits."]];
            [alert show];
            return;
        }
        
        if ([self isDigit:self.bluetoothManager.pinCode] == NO) {
            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:[Language get:@"Warning" alter:@"!Warning"]
                                                             message:[Language get:@"iPhone and iPod touch cannot use Alphabet PIN code, iPad only can use." alter:@"!iPhone and iPod touch cannot use Alphabet PIN code, iPad only can use."]
                                                            delegate:self
                                                   cancelButtonTitle:[Language get:@"Cancel" alter:@"!Cancel"]
                                                   otherButtonTitles:@"OK", nil] autorelease];
            alert.tag = 100;
            [alert show];
            return;
        }
    } else {
        self.bluetoothManager.pinCode = nil;
    }
    
    //Apply settings
    if ([self.bluetoothManager open] == NO) {
        alert.message = @"Failed to open port.";
        [alert show];
        return;
    }

    if ([self.bluetoothManager apply] == NO) {
        alert.message = @"Failed to apply.";
        [alert show];
        [self.bluetoothManager close];
        return;
    }

    [self.bluetoothManager close];
    [self dismissModalViewControllerAnimated:YES];
    
    alert.title = @"Complete";
    alert.message = @"To apply settings, please turn the device power OFF and ON, and established pairing again.";
    [alert show];
}

- (BOOL)isDigit:(NSString *)text
{
    NSCharacterSet *digitCharSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    
    NSScanner *aScanner = [NSScanner localizedScannerWithString:text];
    [aScanner setCharactersToBeSkipped:nil];
    
    [aScanner scanCharactersFromSet:digitCharSet intoString:NULL];
    return [aScanner isAtEnd];
}

#pragma mark UIAlertView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == AlertViewTypeAlphabetPINCode) {
        if (buttonIndex == 0) {
            return;
        }
        
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:[Language get:@"Error" alter:@"!Error"] message:@"" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil] autorelease];
        
        //Apply settings
        if ([self.bluetoothManager open] == NO) {
            alert.message =[Language get:@"Failed to open port." alter:@"!Failed to open port."] ;
            [alert show];
            return;
        }
        
        if ([self.bluetoothManager apply] == NO) {
            alert.message =[Language get:@"Failed to apply." alter:@"!Failed to apply."];
            [alert show];
            [self.bluetoothManager close];
            return;
        }
        
        [self.bluetoothManager close];
        [self dismissModalViewControllerAnimated:YES];
        
        alert.title = [Language get:@"Complete" alter:@"Complete"];
        alert.message = [Language get:@"To apply settings, please turn the device power OFF and ON, and established pairing again." alter:@"!To apply settings, please turn the device power OFF and ON, and established pairing again."];
        [alert show];
        return;
    }
}

#pragma mark UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return functions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UIColor *detailTextColor = [UIColor colorWithRed:59.0/255.0 green:85.0/255.0 blue:133.0/255.0 alpha:1.0];
    
    //create tableViewCell
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    cell.textLabel.text = functions[indexPath.row];

    cell.detailTextLabel.textColor = detailTextColor;
    
    //create textfield
    UITextField *field = [[[UITextField alloc] initWithFrame:CGRectMake(0, 0, 150, cell.frame.size.height * 0.6)] autorelease];
    field.textColor = detailTextColor;
    field.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    field.textAlignment = UITextAlignmentLeft;
    field.tag = indexPath.row;
    field.delegate = self;
    field.keyboardType = UIKeyboardTypeAlphabet;
    
    //create switch
    UISwitch *switch1 = [[UISwitch new] autorelease];
    
    switch (indexPath.row) {
        case 0: //Device Name
            field.text = _bluetoothManager.deviceName;
            deviceNameField = field;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryView = field;
            break;

        case 1: //iOS Port Name
            field.text = _bluetoothManager.iOSPortName;
            iOSPortNameField = field;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryView = field;
            break;
            
        case 2: //Auto Connect
            switch1.on = (self.bluetoothManager.autoConnect) ? YES : NO;
            [switch1 addTarget:self action:@selector(autoConnectSwitchValueChanged:) forControlEvents:UIControlEventValueChanged];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryView = switch1;
            break;
            
        case 3: //Security
            cell.detailTextLabel.text = (self.bluetoothManager.security == SMBluetoothSecuritySSP) ? @"SSP" : @"PIN Code";
            break;
            
        case 4: //Change PIN code
            cell.detailTextLabel.text = changePINcode ? @"Change" : @"No Change";
            break;
            
        case 5: //New PIN Code
            cell.accessoryView = field;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            field.secureTextEntry = YES;
            field.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            pinCodeField = field;
            break;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 3: //Security
            if (self.bluetoothManager.security == SMBluetoothSecuritySSP) {
                self.bluetoothManager.security = SMBluetoothSecurityPINcode;
            } else {
                self.bluetoothManager.security = SMBluetoothSecuritySSP;
            }

            break;
            
        case 4: //PIN code
            changePINcode = !changePINcode;
            break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark UISwitch

- (void)autoConnectSwitchValueChanged:(UISwitch *)sender {
    self.bluetoothManager.autoConnect = sender.on;
}

#pragma mark UITextField

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    const char *str = string.UTF8String;

    if (textField.text.length + string.length > 16) {
        if ((*str != 0x00) && (*str != 0x0a)) {
            return NO;
        }
    }
    
    switch (textField.tag) {
        case 0: //Device Name
            if ([self validateName:string] == NO) {
                return NO;
            }
            
            break;
            
        case 1: //iOS Port Name
            if ([self validateName:string] == NO) {
                return NO;
            }

            break;
            
        case 5: //PIN code
            if ([self validatePinCodeChar:string] == NO) {
                return NO;
            }
            
            break;
    }

    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    switch (textField.tag) {
        case 0: //Device Name
            if (textField.text.length == 0) {
                return NO;
            }
            self.bluetoothManager.deviceName = textField.text;
            break;
            
        case 1: //iOS Port Name
            if (textField.text.length == 0) {
                return NO;
            }
            self.bluetoothManager.iOSPortName = textField.text;
            break;

        case 5: //PIN code
            self.bluetoothManager.pinCode = textField.text;
            break;
    }
    
    return YES;
}

- (BOOL)validateName:(NSString *)string {
    const char *str = string.UTF8String;
    
    for (int i = 0; i < string.length; i++) {
        const char c = *(str + i);
        
        if ((('a' <= c) && (c <= 'z')) ||
            (('A' <= c) && (c <= 'Z')) ||
            (('0' <= c) && (c <= '9')) ||
            (c == ';') ||
            (c == ':') ||
            (c == '!') ||
            (c == '?') ||
            (c == '#') ||
            (c == '$') ||
            (c == '%') ||
            (c == '&') ||
            (c == ',') ||
            (c == '.') ||
            (c == '@') ||
            (c == '_') ||
            (c == '-') ||
            (c == '=') ||
            (c == ' ') ||
            (c == '/') ||
            (c == '*') ||
            (c == '+') ||
            (c == '~') ||
            (c == '^') ||
            (c == '[') ||
            (c == '{') ||
            (c == '(') ||
            (c == ']') ||
            (c == '}') ||
            (c == ')') ||
            (c == '|') ||
            (c == '\\') ||
            (c == 0x0a) ||       //LF
            (c == 0x00))         //NUL
        {
            continue;
        }
        
        return NO;
    }
    
    return YES;
}

- (BOOL)validatePinCodeChar:(NSString *)pinCode {
    if (pinCode == nil) {
        return NO;
    }
    
    const char *str = [pinCode UTF8String];
    
    for (int i = 0; i < pinCode.length; i++) {
        const char c = *(str + i);

        if ((('0' <= c) && (c <= '9')) ||
            (c == 0x0a) ||
            (c == 0x00)) {
            continue;
        }

        if ((('a' <= c) && (c <= 'z')) ||
            (('A' <= c) && (c <= 'Z'))) {
            continue;
        }

        return NO;
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
@end
