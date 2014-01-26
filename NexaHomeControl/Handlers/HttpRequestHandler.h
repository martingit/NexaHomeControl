//
//  HttpRequestHandler.h
//  NexaHomeControl
//
//  Created by Martin Almström on 2014-01-26.
//  Copyright (c) 2014 onkel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpRequestHandler : NSObject
+ (NSString *)stringWithUrl:(NSURL *)url;
@end
