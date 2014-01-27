//
//  TableCell.m
//  Cykelreseplanerare
//
//  Created by Martin Almström on 2013-03-26.
//  Copyright (c) 2013 Fun House. All rights reserved.
//

#import "TableCell.h"

@implementation TableCell
@synthesize Title;
@synthesize CanMove;

- (id)init {
    self = [super init];
    if (self) {
        self.CanMove = false;
    }
    return self;
}

- (id)initWithName:(NSString *)title {
    self = [super init];
    if (self) {
        self.Title = title;
    }
    return self;
}

- (id)initWithNameAndCanMove:(NSString *)title :(NSInteger)canMove {
    self = [super init];
    if (self) {
        self.Title = title;
        self.CanMove = canMove;
    }
    return self;
}

- (UITableViewCell *)getCell:(UITableView *)tableView :(NSString *)cellIdentifier {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = self.Title;
    cell.showsReorderControl = self.CanMove;
    return cell;
}
@end
