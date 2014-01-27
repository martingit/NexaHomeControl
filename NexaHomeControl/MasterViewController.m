//
//  MasterViewController.m
//  NexaHomeControl
//
//  Created by Martin Almström on 2014-01-26.
//  Copyright (c) 2014 onkel. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"

@interface MasterViewController () {
    NSMutableArray *_objects;
    Status *_status;
}
-(NexaHomeHandler*) createNexaHomeHandler;
@end

@implementation MasterViewController
static NSString *MyIdentifier = @"MyReuseIdentifier";

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //self.navigationItem.leftBarButtonItem = self.editButtonItem;

    //UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    //self.navigationItem.rightBarButtonItem = addButton;
    
    UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithTitle:@"\u2699" style:UIBarButtonItemStylePlain target:self action:@selector(openSettings:)];
    self.navigationItem.rightBarButtonItem = settingsButton;
    UIFont *f1 = [UIFont fontWithName:@"Helvetica" size:24.0];
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:f1, NSFontAttributeName, nil];
    [settingsButton setTitleTextAttributes:dict forState:UIControlStateNormal];
    
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    NexaHomeHandler* nexaHomeHandler = [self createNexaHomeHandler];
    _status = [nexaHomeHandler getStatus];
    
    _objects = [[NSMutableArray alloc]init];
    for (int i = 0; i < _status.devices.count; i++) {
        Device *currentDevice = [_status.devices objectAtIndex:i];
        [_objects addObject:[[DeviceTableCell alloc] initWithDevice:currentDevice andViewController:self]];
    }
    
}
-(NexaHomeHandler*) createNexaHomeHandler{
    return [[NexaHomeHandler alloc] initWithAddress:@"192.168.1.101" andPort:8080 andPassword:@"" andUseSSL:false];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)openSettings:(id)sender
{
    //if (!_objects) {
    //    _objects = [[NSMutableArray alloc] init];
    //}
    //[_objects insertObject:[NSDate date] atIndex:0];
    //NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    //[self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}
- (void)callDevice:(id)sender{
    
    UISwitch *uiSwitch = (UISwitch *)sender;
    int deviceId = (int)uiSwitch.tag;
    bool command = uiSwitch.on;
    uiSwitch.enabled = false;
    
    NSLog(@"Call from %d with value %@", deviceId, command ? @"on" : @"off");
    
    NexaHomeHandler* nexaHomeHandler = [self createNexaHomeHandler];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, (unsigned long)NULL), ^(void) {
        bool sendOk = [nexaHomeHandler sendCommand:command withDeviceId:deviceId];
        NSLog(@"Send ok: %@", sendOk ? @"yes" : @"no");
        dispatch_async(dispatch_get_main_queue(), ^{
            uiSwitch.enabled = true;
        });
    });
}
#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableCell *row = [_objects objectAtIndex:indexPath.row];
    UITableViewCell *cell = [row getCell:tableView :MyIdentifier];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_status.devices removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        DeviceTableCell *object = _objects[indexPath.row];
        self.detailViewController.detailItem = object.device;
    }
    else{
        [self performSegueWithIdentifier:@"showDetail" sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        DeviceTableCell *object = _objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:object.device];
    }
}

@end
