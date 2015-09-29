//
//  InterfaceController.m
//  FootAS WatchKit Extension
//
//  Created by Yuntao Wang on 15/8/30.
//  Copyright (c) 2015年 Yuntao Wang. All rights reserved.
//

#import "InterfaceController.h"

typedef enum
{
    IDLE = 0,
    SCANNING,
    CONNECTED,
} ConnectionState;

@interface InterfaceController()
@property CBCentralManager *cm;
@property ConnectionState state;
@property UARTPeripheral *currentPeripheral;
@property (strong, nonatomic)NSMutableArray *labels;
@property (strong, nonatomic)NSMutableArray *dots;

@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    _state = IDLE;
    _cm = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    [_button setTitle:@"connect"];
    // Configure interface objects here.
    _wormhole = [[MMWormhole alloc] initWithApplicationGroupIdentifier:@"group.footas.test" optionalDirectory:nil];
    _labels = [[NSMutableArray alloc] initWithCapacity:10];
    _dots = [[NSMutableArray alloc] initWithCapacity:10];
    
    [_labels addObject:_valueLabel1];
    [_labels addObject:_valueLabel2];
    [_labels addObject:_valueLabel3];
    [_labels addObject:_valueLabel4];
    [_labels addObject:_valueLabel5];
    [_labels addObject:_valueLabel6];

    [_dots addObject:_dot1];
    [_dots addObject:_dot2];
    [_dots addObject:_dot3];
    [_dots addObject:_dot4];
    [_dots addObject:_dot5];
    [_dots addObject:_dot6];

}

- (IBAction)onButtonPress:(id)sender {
    switch (_state) {
        case IDLE:
            _state = SCANNING;
            NSLog(@"start scanning");
            [_button setTitle:@"scanning"];
            
            //[self.cm scanForPeripheralsWithServices:nil options:nil];
            break;
            
        case SCANNING:
            _state = IDLE;
            NSLog(@"stop scaning");
            [_button setTitle:@"connect"];
            [_cm stopScan];
            break;
            
        case CONNECTED:
            NSLog(@"disconnect");
            [_button setTitle:@"connect"];
            [_cm cancelPeripheralConnection:_currentPeripheral.peripheral];
            
        default:
            break;
    }}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    
    [_wormhole listenForMessageWithIdentifier:@"chara" listener:^(id messageObject){
        NSNumber *ch = [messageObject valueForKey:@"ch"];
        NSNumber *val = [messageObject valueForKey:@"val"];
        int t = [ch intValue];
        int value = [val intValue];
        [((WKInterfaceLabel *)_labels[t-1]) setText:[NSString stringWithFormat:@"%d", value]];
        [((WKInterfaceImage *)_dots[t-1]) setAlpha:(value/1100.0)];
        NSLog(@"receive: %d %d", t, value);
    }];
    
    [_wormhole listenForMessageWithIdentifier:@"test" listener:^(id messageObject) {
        NSLog(@"test: %@", messageObject);
    }];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}



- (void)didReceiveData:(NSString *)string {
    
}

- (void) centralManagerDidUpdateState:(CBCentralManager *)central
{
    if (central.state == CBCentralManagerStatePoweredOn)
    {
        [_button setEnabled:YES];
    }
    
}

- (void) centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSLog(@"Did discover peripheral %@", peripheral.name);
    [self.cm stopScan];
    
    self.currentPeripheral = [[UARTPeripheral alloc] initWithPeripheral:peripheral delegate:self];
    
    /*_currentPeripheral.changeValue = ^(int ind, int val){
     ((UILabel *)_valueLabels[ind]).text = [NSString stringWithFormat:@"%d", val];
     };*/
    /*[_currentPeripheral setChangeValueVoid:^(int ind, int val){
     NSLog(@"%d %d", ind, val);
     //((UILabel *)(_valueLabels[ind])).text = [NSString stringWithFormat:@"%d", val];
     }];*/
    [_currentPeripheral addValueLabel:_valueLabel1];
    [_currentPeripheral addValueLabel:_valueLabel2];
    [_currentPeripheral addValueLabel:_valueLabel3];
    [_currentPeripheral addValueLabel:_valueLabel4];
    [_currentPeripheral addValueLabel:_valueLabel5];
    [_currentPeripheral addValueLabel:_valueLabel6];
    
    
    [_currentPeripheral addDot:_dot1];
    [_currentPeripheral addDot:_dot2];
    [_currentPeripheral addDot:_dot3];
    [_currentPeripheral addDot:_dot4];
    [_currentPeripheral addDot:_dot5];
    [_currentPeripheral addDot:_dot6];
    
    [self.cm connectPeripheral:peripheral options:@{CBConnectPeripheralOptionNotifyOnDisconnectionKey: [NSNumber numberWithBool:YES]}];
    //[self.cm connectPeripheral:peripheral options:[NSDictionary dictionaryWithObjects:[NSNumber numberWithBool:YES] forKeys:CBConnectPeripheralOptionNotifyOnConnectionKey]];
}

- (void) centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"Did connect peripheral %@", peripheral.name);
    
    //[self addTextToConsole:[NSString stringWithFormat:@"Did connect to %@", peripheral.name] dataType:LOGGING];
    
    self.state = CONNECTED;
    [_button setTitle:@"disconnect"];
    //[_button setTitle:@"disconnect" forState:UIControlStateNormal];
    //[self.sendButton setUserInteractionEnabled:YES];
    //[self.sendTextField setUserInteractionEnabled:YES];
    
    if ([self.currentPeripheral.peripheral isEqual:peripheral])
    {
        [self.currentPeripheral didConnect];
    }
}

- (void) centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"Did disconnect peripheral %@", peripheral.name);
    
    //[self addTextToConsole:[NSString stringWithFormat:@"Did disconnect from %@, error code %d", peripheral.name, error.code] dataType:LOGGING];
    
    self.state = IDLE;
    [_button setTitle:@"connect"];
    //[_button setTitle:@"connect" forState:UIControlStateNormal];
    //[self.sendButton setUserInteractionEnabled:NO];
    //[self.sendTextField setUserInteractionEnabled:NO];
    
    if ([self.currentPeripheral.peripheral isEqual:peripheral])
    {
        [self.currentPeripheral didDisconnect];
    }
}

@end



