//
//  Status.h
//  NexaHomeControl
//
//  Created by Martin Almström on 2014-01-26.
//  Copyright (c) 2014 onkel. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Device : NSObject
@property(nonatomic)NSString *name;
@property(nonatomic)int index;
@property(nonatomic)bool dimable;
@property(nonatomic)NSInteger level;
@property(nonatomic)bool status;
@end

@interface Status : NSObject
@property(nonatomic)NSString *mode;
@property(nonatomic)NSString *options;
@property(nonatomic, retain) NSMutableArray *devices;
- (id)initWithDevices: (NSMutableArray*) devices;
- (Device*) deviceAtIndex: (int) index;
@end
