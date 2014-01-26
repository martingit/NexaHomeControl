//
//  NexaHomeControlTests.m
//  NexaHomeControlTests
//
//  Created by Martin Almström on 2014-01-26.
//  Copyright (c) 2014 onkel. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "NexaHomeHandler.h"
#import "Models.h"
#import "ObjectParser.h"

@interface NexaHomeControlTests : XCTestCase

@end

@implementation NexaHomeControlTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

#pragma text Unit Tests

- (void) testParseXmlToStatusObjectWithDevices{
    NSString* xml = @"<?xml version='1.0' encoding='UTF-8'?> \
    <NexaHome>\
      <status>\
        <mode options=\"Home, Away\">Home</mode>\
        <devices>\
          <device name=\"Sovrum\" id=\"2\" timestamp=\"2014-01-26 20:03 *\" dimmable=\"no\" level=\"\">ON</device>\
          <device name=\"Gustav\" id=\"5\" timestamp=\"2014-01-26 20:03 *\" dimmable=\"no\" level=\"\">OFF</device>\
          <device name=\"Ute\" id=\"6\" timestamp=\"2014-01-26 20:03 *\" dimmable=\"no\" level=\"\">ON</device>\
          <device name=\"Vardagsrum\" id=\"7\" timestamp=\"2014-01-26 20:03 *\" dimmable=\"yes\" level=\"70\">OFF</device>\
          <device name=\"Arbetsrum\" id=\"8\" timestamp=\"2014-01-26 20:03 *\" dimmable=\"yes\" level=\"\">OFF</device>\
          <device name=\"Alla\" id=\"9\" timestamp=\"2014-01-26 20:03 *\" dimmable=\"no\" level=\"\">OFF</device>\
        </devices>\
      </status>\
    </NexaHome>";
    Status* status = [ObjectParser xmlToStatus: xml];
    
    XCTAssertEqualObjects(@"Home", status.mode, @"Wrong status mode");
    XCTAssertTrue(status.devices.count == 6, @"Wrong device count");
    XCTAssertTrue([status deviceAtIndex:3].level == 70 , @"Wrong level in Vardagsrum");
}

#pragma text Integration Tests

- (void) testIntegrationWithNexaHomeGetStatus{
    NexaHomeHandler* handler = [[NexaHomeHandler alloc] initWithAddress:@"192.168.1.101" andPort:8080 andPassword:@""];
    Status* status = [handler getStatus];
    XCTAssertTrue(status.devices.count > 0, @"No devices found");
}
- (void) testIntegrationWithNexaHomeSendCommandOnToDevice8{
    NexaHomeHandler* handler = [[NexaHomeHandler alloc] initWithAddress:@"192.168.1.101" andPort:8080 andPassword:@""];
    bool sentOk = [handler sendCommand:true withDeviceId:8];
    XCTAssertTrue(sentOk, @"Could not send Command ON to device=8");
}
- (void) testIntegrationWithNexaHomeSendCommandOffToDevice8{
    NexaHomeHandler* handler = [[NexaHomeHandler alloc] initWithAddress:@"192.168.1.101" andPort:8080 andPassword:@""];
    bool sentOk = [handler sendCommand:false withDeviceId:8];
    XCTAssertTrue(sentOk, @"Could not send Command OFF to device=8");
}
- (void) testIntegrationWithNexaHomeDimDevice8ToLevel50{
    NexaHomeHandler* handler = [[NexaHomeHandler alloc] initWithAddress:@"192.168.1.101" andPort:8080 andPassword:@""];
    bool sentOk = [handler dimDevice:8 withLevel:50];
    XCTAssertTrue(sentOk, @"Could not dim device=8 to level=50");
}
@end
