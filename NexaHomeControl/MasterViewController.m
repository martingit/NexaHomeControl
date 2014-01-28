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
    NSMutableArray *_sections;
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

- (void)reloadStatusTable
{
    NexaHomeHandler* nexaHomeHandler = [self createNexaHomeHandler];
    _status = [nexaHomeHandler getStatus];
    
    TableSection *modeSection = [[TableSection alloc] init];
    modeSection.name = @"Current mode";
    modeSection.items = [[NSMutableArray alloc]init];
    
    [modeSection.items addObject:[[TableCell alloc] initWithName:_status.mode]];
    
    TableSection *deviceSection = [[TableSection alloc] init];
    deviceSection.name = @"Devices";
    deviceSection.items = [[NSMutableArray alloc]init];
    
    _sections = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < _status.devices.count; i++) {
        Device *currentDevice = [_status.devices objectAtIndex:i];
        if (currentDevice.dimable){
            [deviceSection.items addObject:[[DimableDeviceTableCell alloc] initWithDevice:currentDevice andViewController:self]];
        
        }
        else{
            [deviceSection.items addObject:[[DeviceTableCell alloc] initWithDevice:currentDevice andViewController:self]];
        }
    }
    [_sections addObject:modeSection];
    [_sections addObject:deviceSection];
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    
    [refresh addTarget:self action:@selector(refreshStatus:) forControlEvents:UIControlEventValueChanged];
    
    self.refreshControl = refresh;
    
    UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithTitle:@"\u2699" style:UIBarButtonItemStylePlain target:self action:@selector(openSettings:)];
    self.navigationItem.rightBarButtonItem = settingsButton;
    UIFont *f1 = [UIFont fontWithName:@"Helvetica" size:24.0];
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:f1, NSFontAttributeName, nil];
    [settingsButton setTitleTextAttributes:dict forState:UIControlStateNormal];
    
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    [self reloadStatusTable];
    
}
-(NexaHomeHandler*) createNexaHomeHandler{
    return [[NexaHomeHandler alloc] initWithAddress:@"192.168.1.101" andPort:8080 andPassword:@"" andUseSSL:false];
}
- (void)stopRefresh:(id)sender{
    [self.refreshControl endRefreshing];
}
-(void)refreshStatus:(id)sender{
    [self reloadStatusTable];
    [self performSelector:@selector(stopRefresh:) withObject:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)openSettings:(id)sender {
}
- (void)callDevice:(id)sender {
    
    UISwitch *uiSwitch = (UISwitch *)sender;
    int deviceId = (int)uiSwitch.tag;
    bool command = uiSwitch.on;
    uiSwitch.enabled = false;
    
    NSLog(@"Call to %d with value %@", deviceId, command ? @"on" : @"off");
    
    NexaHomeHandler* nexaHomeHandler = [self createNexaHomeHandler];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, (unsigned long)NULL), ^(void) {
        bool sendOk = [nexaHomeHandler sendCommand:command withDeviceId:deviceId];
        NSLog(@"Send ok: %@", sendOk ? @"yes" : @"no");
        dispatch_async(dispatch_get_main_queue(), ^{
            uiSwitch.enabled = true;
        });
    });
}
- (void)dimDevice:(UISlider*)sender {
    int deviceId = (int)sender.tag;
    int level = (int)sender.value;
    sender.enabled = false;
    
    NSLog(@"Dimm device %d with level %d", deviceId, level);
    
    NexaHomeHandler* nexaHomeHandler = [self createNexaHomeHandler];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, (unsigned long)NULL), ^(void) {
        bool sendOk = [nexaHomeHandler dimDevice:deviceId withLevel:level];
        NSLog(@"Send ok: %@", sendOk ? @"yes" : @"no");
        dispatch_async(dispatch_get_main_queue(), ^{
            sender.enabled = true;
        });
    });
}
#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    TableSection* currentSection = (TableSection*)[_sections objectAtIndex:section];
    return currentSection.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableSection* tableSection = [_sections objectAtIndex:indexPath.section];
    TableCell* tableCell = [tableSection.items objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableCell getCell:tableView :MyIdentifier];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    TableSection *currentSection = [_sections objectAtIndex:section];
    return currentSection.name;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TableSection* tableSection = [_sections objectAtIndex:indexPath.section];
    TableCell* tableCell = [tableSection.items objectAtIndex:indexPath.row];
    if ([tableCell class] == [DimableDeviceTableCell class]){
        return 66;
    }
    else{
        return 44;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        TableSection* tableSection = [_sections objectAtIndex:indexPath.section];
        TableCell* tableCell = [tableSection.items objectAtIndex:indexPath.row];

        if ([tableCell class] == [DeviceTableCell class]){
            self.detailViewController.detailItem = ((DeviceTableCell*)tableCell).device;
        }
        
    }
    else{
        [self performSegueWithIdentifier:@"showDetail" sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        TableSection* tableSection = [_sections objectAtIndex:indexPath.section];
        TableCell* tableCell = [tableSection.items objectAtIndex:indexPath.row];
        if ([tableCell class] == [DeviceTableCell class]){
            [[segue destinationViewController] setDetailItem:((DeviceTableCell*)tableCell).device];
        }
        
    }
}

@end
