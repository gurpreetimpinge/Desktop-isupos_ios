//
//  main.m
//  ISUPOS
//
//  Created by Mac User on 4/2/15.
//  Copyright (c) 2015 Impinge Solutions. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[])
{
//    @autoreleasepool
//    {
//        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
//    }
    
    @autoreleasepool
    {
        int returnValue;
        @try
        {
            returnValue = UIApplicationMain(argc, argv, nil,
                                            NSStringFromClass([AppDelegate class]));
        }
        @catch (NSException* exception)
        {
            NSLog(@"Uncaught exception: %@, %@", [exception description],
                     [exception callStackSymbols]);
            @throw exception;
        }
        return returnValue;
    }
}
