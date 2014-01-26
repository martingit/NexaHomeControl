//
//  ObjectParser.h
//  NexaHomeControl
//
//  Created by Martin Almström on 2014-01-26.
//  Copyright (c) 2014 onkel. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Models.h"
#import "TBXML.h"

@interface ObjectParser : NSObject
+ (Status*)xmlToStatus: (NSString*) xml;
+ (Device*)createDevice: (TBXMLElement*) element;
@end
