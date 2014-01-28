//
//  DimableDeviceTableCell.h
//  NexaHomeControl
//
//  Created by Martin Almström on 2014-01-28.
//  Copyright (c) 2014 onkel. All rights reserved.
//

#import "DeviceTableCell.h"
#import "DimableDeviceTableViewCell.h"

@interface DimableDeviceTableCell : DeviceTableCell
@property(nonatomic, retain) UISlider *uiSlider;
@property (nonatomic) int stepValue;
@property (nonatomic) int lastStep;
@end
