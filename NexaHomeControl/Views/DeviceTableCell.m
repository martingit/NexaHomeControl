//
//  DeviceTableCell.m
//  NexaHomeControl
//
//  Created by Martin Almström on 2014-01-27.
//  Copyright (c) 2014 onkel. All rights reserved.
//

#import "DeviceTableCell.h"

@implementation DeviceTableCell
-(void)sendCommand:(id)sender{
    [self.controller performSelector:@selector(callDevice:) withObject:sender];
}
- (id)initWithDevice:(Device *)device andViewController: (id)controller{
    self = [super init];
    if (self) {
        self.controller = controller;
        self.device = device;
        self.Title = device.name;
        self.CanMove = false;
        self.uiSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(240.0, 7, 80.0, 30.0)];
        self.uiSwitch.tag = device.index;
        self.uiSwitch.on = device.status;
        [self.uiSwitch addTarget:self action:@selector(sendCommand:) forControlEvents:UIControlEventValueChanged];

    }
    return self;
}

- (void) removeSubview: (UIView*)view{
    
    for(UIView *v in [view subviews])
    {
        if([v isKindOfClass:[UISwitch class]] || [v isKindOfClass:[UISlider class]]){
            [v removeFromSuperview];
        }
        [self removeSubview:v];
    }
}

- (UITableViewCell *)getCell:(UITableView *)tableView :(NSString *)cellIdentifier {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    [self removeSubview:cell];

    cell.textLabel.text = self.Title;
    cell.showsReorderControl = self.CanMove;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [cell addSubview:self.uiSwitch];
    return cell;
}
@end
