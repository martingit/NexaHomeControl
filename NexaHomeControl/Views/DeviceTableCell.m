//
//  DeviceTableCell.m
//  NexaHomeControl
//
//  Created by Martin Almström on 2014-01-27.
//  Copyright (c) 2014 onkel. All rights reserved.
//

#import "DeviceTableCell.h"

@implementation DeviceTableCell

- (id)initWithDevice:(Device *)device andViewController: (id)controller{
    self = [super init];
    if (self) {
        self.device = device;
        self.Title = device.name;
        self.CanMove = false;
        self.uiSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(240.0, 7, 80.0, 30.0)];
        self.uiSwitch.tag = self.device.index;
        self.uiSwitch.on = self.device.status;
        [self.uiSwitch addTarget:controller action:@selector(callDevice:) forControlEvents:UIControlEventValueChanged];
    }
    return self;
}

- (UITableViewCell *)getCell:(UITableView *)tableView :(NSString *)cellIdentifier {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = self.Title;
    cell.showsReorderControl = self.CanMove;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [cell addSubview:self.uiSwitch];
    
    return cell;
}
@end
