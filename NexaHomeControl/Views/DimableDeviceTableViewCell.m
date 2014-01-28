//
//  DimmableDeviceTableViewCell.m
//  NexaHomeControl
//
//  Created by Martin Almström on 2014-01-28.
//  Copyright (c) 2014 onkel. All rights reserved.
//

#import "DimableDeviceTableViewCell.h"

@implementation DimableDeviceTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void) layoutSubviews {
    [super layoutSubviews];
    self.textLabel.frame = CGRectMake(15, 10, 320, 20);
}
@end
