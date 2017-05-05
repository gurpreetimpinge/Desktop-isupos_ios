//
//  CustomTableViewCell.m
//  ISUPOS
//
//  Created by Gurpreet on 10/04/15.
//  Copyright (c) 2015 Impinge Solutions. All rights reserved.
//


#import "CustomTableViewCell.h"


@implementation CustomTableViewCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self)
    {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
