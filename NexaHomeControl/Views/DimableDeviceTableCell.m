//
//  DimableDeviceTableCell.m
//  NexaHomeControl
//
//  Created by Martin Almström on 2014-01-28.
//  Copyright (c) 2014 onkel. All rights reserved.
//

#import "DimableDeviceTableCell.h"

@implementation DimableDeviceTableCell

-(void)valueChanged:(id)sender{
    float newStep = roundf((self.uiSlider.value) / self.stepValue);
    
    // Convert "steps" back to the context of the sliders values.
    self.uiSlider.value = newStep * self.stepValue;
    //NSLog(@"UISlider value: %f", self.uiSlider.value);
}
-(void)dimCommand:(id)sender{
    int currentValue = (int)self.uiSlider.value;
    int deviceId = (int)self.device.index;
    if (currentValue != self.lastStep){
        NSLog(@"UISlider %d value: %d", deviceId, currentValue);
        self.lastStep = currentValue;
        [self.controller performSelector:@selector(dimDevice:) withObject:self.uiSlider];
    }
}
- (id)initWithDevice:(Device *)device andViewController: (id)controller{
    self = [super initWithDevice:device andViewController:controller];
    if (self) {
        self.stepValue = 10;
        self.device = device;
        self.Title = device.name;
        self.CanMove = false;
        self.uiSlider = [[UISlider alloc] initWithFrame:CGRectMake(15.0, 35.0, 270.0, 30.0)];
        self.uiSlider.maximumValue = 100;
        self.uiSlider.minimumValue = 0;

        //self.lastStep = self.uiSlider.value / self.stepValue;
        
        self.uiSlider.tag = self.device.index;
        self.uiSlider.value = self.device.level;
        [self.uiSlider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
        [self.uiSlider addTarget:self action:@selector(dimCommand:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (UITableViewCell *)getCell:(UITableView *)tableView :(NSString *)cellIdentifier {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[DimableDeviceTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
   
    }
    [self removeSubview:cell];
    
    cell.textLabel.text = self.Title;
    cell.showsReorderControl = self.CanMove;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [cell addSubview:self.uiSwitch];
    [cell addSubview:self.uiSlider];
    return cell;
}

@end
