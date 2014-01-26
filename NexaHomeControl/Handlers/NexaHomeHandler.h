//
//  NexaHomeHandler.h
//  NexaHomeControl
//
//  Created by Martin Almström on 2014-01-26.
//  Copyright (c) 2014 onkel. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HttpRequestHandler.h"
#import "Models.h"
#import "ObjectParser.h"

@interface NexaHomeHandler : NSObject
//@property(nonatomic, retain) Status *status;
@property(nonatomic)NSString *address;
@property(nonatomic)int port;
@property(nonatomic)NSString *password;
-(id)initWithAddress: (NSString*) address andPort: (int) port andPassword: (NSString*) password;
-(Status*) getStatus;
-(bool) sendCommand: (bool) command withDeviceId: (int) deviceId;
-(bool) dimDevice: (int) deviceId withLevel: (int) level;
@end
