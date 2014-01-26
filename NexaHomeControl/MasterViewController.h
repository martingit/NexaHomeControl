//
//  MasterViewController.h
//  NexaHomeControl
//
//  Created by Martin Almström on 2014-01-26.
//  Copyright (c) 2014 onkel. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Models.h"
#import "NexaHomeHandler.h"

@class DetailViewController;

@interface MasterViewController : UITableViewController

@property (strong, nonatomic) DetailViewController *detailViewController;
@property (strong, nonatomic) NexaHomeHandler *nexaHomeHandler;

@end
