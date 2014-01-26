//
//  ObjectParser.m
//  NexaHomeControl
//
//  Created by Martin Almström on 2014-01-26.
//  Copyright (c) 2014 onkel. All rights reserved.
//

#import "ObjectParser.h"

@implementation ObjectParser
+(Status*)xmlToStatus:(NSString *)xml{
    NSError* error;
    NSMutableArray* devices = [[NSMutableArray alloc] init];
    Status* status = [[Status alloc] initWithDevices:devices];
    
    TBXML* xmlDoc = [[TBXML alloc] initWithXMLString:xml error:&error];
    
    TBXMLElement* rootElement = xmlDoc.rootXMLElement;
    TBXMLElement* statusElement = [TBXML childElementNamed:@"status" parentElement:rootElement];
    TBXMLElement* modeElement = [TBXML childElementNamed:@"mode" parentElement:statusElement];
    
    status.options = [TBXML valueOfAttributeNamed:@"options" forElement:modeElement];
    status.mode = [TBXML textForElement:modeElement];
    
    TBXMLElement* devicesElement = [TBXML childElementNamed:@"devices" parentElement:statusElement];
    
    TBXMLElement* deviceElement = [TBXML childElementNamed:@"device" parentElement:devicesElement];
    do {
        [status.devices addObject: [self createDevice: deviceElement]];
    } while ((deviceElement = deviceElement->nextSibling));
    
    return status;
}
+ (Device*)createDevice: (TBXMLElement*) element{
    Device* device = [[Device alloc] init];
    device.name = [TBXML valueOfAttributeNamed:@"name" forElement:element];
    device.index = [[TBXML valueOfAttributeNamed:@"id" forElement:element] intValue];
    device.dimmable = [[TBXML valueOfAttributeNamed:@"dimmable" forElement:element] isEqualToString:@"yes"];
    NSString* level =[TBXML valueOfAttributeNamed:@"level" forElement:element];
    if (level.length > 0){
        device.level = [level intValue];
    }
    device.status = [[TBXML textForElement:element] isEqualToString:@"ON"];
    return device;
}

@end


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