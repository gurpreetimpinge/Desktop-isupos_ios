//
//  CustomCellQuickButtons.m
//  ISUPOS
//
//  Created by Gurpreet on 10/04/15.
//  Copyright (c) 2015 Impinge Solutions. All rights reserved.
//


#import "CustomCellQuickButtons.h"
#import "language.h"


@implementation CustomCellQuickButtons


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
//        [self.addItembutton setTitle:[Language get:@"Add Item" alter:@"!Add Item"] forState:UIControlStateNormal];
        self.labelProductVariantCount.text = [Language get:@"More" alter:@"!More"];

        
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
