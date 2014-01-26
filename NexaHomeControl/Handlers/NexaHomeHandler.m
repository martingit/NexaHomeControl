//
//  NexaHomeHandler.m
//  NexaHomeControl
//
//  Created by Martin Almström on 2014-01-26.
//  Copyright (c) 2014 onkel. All rights reserved.
//

#import "NexaHomeHandler.h"

@implementation NexaHomeHandler
-(id)initWithAddress: (NSString*) address andPort: (int) port andPassword: (NSString*) password{
    self = [super init];
    if (self){
        //self.status = [[Status alloc] init];
        self.address = address;
        self.port = port;
        self.password = password;
    }
    return self;
}
-(Status*) getStatus{
    NSURL* url = [[NSURL alloc] initWithString:[[NSString alloc] initWithFormat:@"http://%@:%d/nexahome?psw=%@&status=yes", self.address, self.port, self.password]];
    NSString* xml = [HttpRequestHandler stringWithUrl:url];
    
    return [ObjectParser xmlToStatus:xml];

}
-(bool) sendCommand: (bool) command withDeviceId: (int) deviceId {
    NSString* cmd = command ? @"on" : @"off";
    NSURL* url = [[NSURL alloc] initWithString:[[NSString alloc] initWithFormat:@"http://%@:%d/nexahome?psw=%@&device=%d&cmd=%@", self.address, self.port, self.password, deviceId, cmd]];
    NSString* xml = [HttpRequestHandler stringWithUrl:url];
    return xml != nil;
}
-(bool) dimDevice: (int) deviceId withLevel: (int) level{
    NSURL* url = [[NSURL alloc] initWithString:[[NSString alloc] initWithFormat:@"http://%@:%d/nexahome?psw=%@&device=%d&level=%d", self.address, self.port, self.password, deviceId, level]];
    NSString* xml = [HttpRequestHandler stringWithUrl:url];
    return xml != nil;
    
}
@end
