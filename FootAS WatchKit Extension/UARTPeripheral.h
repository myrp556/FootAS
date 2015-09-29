//
//  UARTPeripheral.h
//  nRF UART
//
//  Created by Ole Morten on 1/12/13.
//  Copyright (c) 2013 Nordic Semiconductor. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <WatchKit/WatchKit.h>

typedef void (^iiVoid)(int, int);

@protocol UARTPeripheralDelegate
- (void) didReceiveData:(NSString *) string;
@optional
- (void) didReadHardwareRevisionString:(NSString *) string;
@end


@interface UARTPeripheral : NSObject <CBPeripheralDelegate> {
    void (^changeValue)(int, int);
    int values[10];
}
@property CBPeripheral *peripheral;
@property id<UARTPeripheralDelegate> delegate;
@property NSMutableArray *valueLabels;
@property NSMutableArray *dots;

//@property void (^changeValue)(int, int);

+ (CBUUID *) uartServiceUUID;

- (UARTPeripheral *) initWithPeripheral:(CBPeripheral*)peripheral delegate:(id<UARTPeripheralDelegate>) delegate;

- (void) writeString:(NSString *) string;

- (void) didConnect;
- (void) didDisconnect;

- (void)addValueLabel:(WKInterfaceLabel *)label;
- (void)addDot:(WKInterfaceImage *)dot;
- (void)setChangeValueVoid:(iiVoid) changeVoid;
@end
