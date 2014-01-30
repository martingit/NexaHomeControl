//
//  DeviceTableCell.h
//  NexaHomeControl
//
//  Created by Martin Almström on 2014-01-27.
//  Copyright (c) 2014 onkel. All rights reserved.
//

#import "TableCell.h"
#import "Models.h"

@interface DeviceTableCell : TableCell
@property (nonatomic, retain) Device *device;
@property(nonatomic, retain) UISwitch *uiSwitch;
@property (strong, nonatomic) id controller;
- (id)initWithDevice:(Device *)device andViewController: (id)controller;
- (void) removeSubview: (UIView*)view;
@end
