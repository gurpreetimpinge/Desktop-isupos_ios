//
//  UITextField+Validations.h
//  ISUPOS
//
//  Created by Mac User on 4/10/15.
//  Copyright (c) 2015 Impinge Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (Validations)


- (BOOL)requiredText;
- (BOOL)validZipCode;
- (BOOL)validPhoneNumber;
- (BOOL)validEmailAddress;
- (BOOL)validUsername;
- (BOOL)validPassword;

@end
