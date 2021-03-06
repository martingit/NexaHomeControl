//
//  NexaHomeHandler.m
//  NexaHomeControl
//
//  Created by Martin Almström on 2014-01-26.
//  Copyright (c) 2014 onkel. All rights reserved.
//

#import "NexaHomeHandler.h"

@interface NexaHomeHandler()
-(NSString*) getProtocol;
-(double) getRandomNumber;
@end

@implementation NexaHomeHandler

-(id)initWithAddress: (NSString*) address andPort: (int) port andPassword: (NSString*) password andUseSSL: (bool) useSSL {
    self = [super init];
    if (self){
        self.address = address;
        self.port = port;
        self.password = password;
        self.useSSL = useSSL;
    }
    return self;
}
-(NSString*) getProtocol{
    return self.useSSL ? @"https" : @"http";
}
-(double) getRandomNumber{
    return [[NSDate date] timeIntervalSince1970];
}
-(Status*) getStatus{
    NSURL* url = [[NSURL alloc] initWithString:[[NSString alloc] initWithFormat:@"%@://%@:%d/nexahome?psw=%@&status=yes&rnd=%f", self.getProtocol, self.address, self.port, self.password, [self getRandomNumber]]];
    NSString* xml = [HttpRequestHandler stringWithUrl:url];
    
    return [ObjectParser xmlToStatus:xml];

}
-(bool) sendCommand: (bool) command withDeviceId: (int) deviceId {
    NSString* cmd = command ? @"on" : @"off";
    NSURL* url = [[NSURL alloc] initWithString:[[NSString alloc] initWithFormat:@"%@://%@:%d/nexahome?psw=%@&device=%d&cmd=%@&rnd=%f", self.getProtocol, self.address, self.port, self.password, deviceId, cmd, [self getRandomNumber]]];
    NSString* xml = [HttpRequestHandler stringWithUrl:url];
    return xml != nil;
}
-(bool) dimDevice: (int) deviceId withLevel: (int) level{
    NSURL* url = [[NSURL alloc] initWithString:[[NSString alloc] initWithFormat:@"%@://%@:%d/nexahome?psw=%@&device=%d&level=%d&rnd=%f", self.getProtocol, self.address, self.port, self.password, deviceId, level, [self getRandomNumber]]];
    NSString* xml = [HttpRequestHandler stringWithUrl:url];
    return xml != nil;
    
}
@end
