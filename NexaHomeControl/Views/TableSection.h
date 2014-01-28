//
//  TableSection.h
//  NexaHomeControl
//
//  Created by Martin Almström on 2014-01-28.
//  Copyright (c) 2014 onkel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TableSection : NSObject
@property(nonatomic, retain) NSString *name;
@property(nonatomic, retain) NSMutableArray *items;
@end
