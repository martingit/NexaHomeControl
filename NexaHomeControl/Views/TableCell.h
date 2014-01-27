//
//  TableCell.h
//  Cykelreseplanerare
//
//  Created by Martin Almström on 2013-03-26.
//  Copyright (c) 2013 Fun House. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TableCell : NSObject
@property(nonatomic, retain) NSString *Title;
@property BOOL CanMove;

- (id)initWithName:(NSString *)title;

- (UITableViewCell *)getCell:(UITableView *)tableView :(NSString *)cellIdentifier;
@end
