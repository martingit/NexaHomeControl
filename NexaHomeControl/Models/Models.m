//
//  Status.m
//  NexaHomeControl
//
//  Created by Martin Almström on 2014-01-26.
//  Copyright (c) 2014 onkel. All rights reserved.
//

#import "Models.h"
/*
 status=yes
 
 <?xml version='1.0' encoding='UTF-8'?>
 <NexaHome>
 <status>
 <mode options="Home, Away">Home</mode>
 <devices>
 <device name="Sovrum" id="2" timestamp="2014-01-26 20:03 *" dimmable="no" level="">ON</device>
 <device name="Gustav" id="5" timestamp="2014-01-26 20:03 *" dimmable="no" level="">OFF</device>
 <device name="Ute" id="6" timestamp="2014-01-26 20:03 *" dimmable="no" level="">ON</device>
 <device name="Vardagsrum" id="7" timestamp="2014-01-26 20:03 *" dimmable="yes" level="">OFF</device>
 <device name="Arbetsrum" id="8" timestamp="2014-01-26 20:03 *" dimmable="yes" level="">OFF</device>
 <device name="Alla" id="9" timestamp="2014-01-26 20:03 *" dimmable="no" level="">OFF</device>
 </devices>
 </status>
 </NexaHome>
 
 */

@implementation Device

@end

@implementation Status
- (id)initWithDevices: (NSMutableArray*) devices{
    self = [super init];
    if (self){
        self.devices = devices;
    }
    return self;
}
- (Device*) deviceAtIndex:(int)index{
    return (Device*)[self.devices objectAtIndex:index];
}
@end
