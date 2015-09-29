//
//  UARTPeripheral.m
//  nRF UART
//
//  Created by Ole Morten on 1/12/13.
//  Copyright (c) 2013 Nordic Semiconductor. All rights reserved.
//

#import "UARTPeripheral.h"

@interface UARTPeripheral ()
@property CBService *uartService;
//@property CBCharacteristic *rxCharacteristic;
//@property CBCharacteristic *txCharacteristic;

@end

@implementation UARTPeripheral
@synthesize peripheral = _peripheral;
@synthesize delegate = _delegate;

@synthesize uartService = _uartService;
//@synthesize rxCharacteristic = _rxCharacteristic;
//@synthesize txCharacteristic = _txCharacteristic;

+ (CBUUID *) uartServiceUUID
{
    return [CBUUID UUIDWithString:@"BD75D8C2-D2DD-78F4-3DD7-AFC1BA288FFF"];
    //return [CBUUID UUIDWithString:@"Heart Rate"];
    //return [CBUUID UUIDWithString:@"2A37"];
    //return [CBUUID UUIDWithString:@"180D"];
    //return [CBUUID UUIDWithString:@"6e400001-b5a3-f393-e0a9-e50e24dcca9e"];
}

+ (CBUUID *) txCharacteristicUUID
{
    return [CBUUID UUIDWithString:@"BD75D8C2-D2DD-78F4-3DD7-AFC1BA288FFF"];
    //return [CBUUID UUIDWithString:@"6e400002-b5a3-f393-e0a9-e50e24dcca9e"];
}

+ (CBUUID *) rxCharacteristicUUID
{
    return [CBUUID UUIDWithString:@"BD75D8C2-D2DD-78F4-3DD7-AFC1BA288FFF"];
    //return [CBUUID UUIDWithString:@"6e400003-b5a3-f393-e0a9-e50e24dcca9e"];
}

+ (CBUUID *) deviceInformationServiceUUID
{
    return [CBUUID UUIDWithString:@"180D"];
}

+ (CBUUID *) hardwareRevisionStringUUID
{
    return [CBUUID UUIDWithString:@"2A27"];
}

- (UARTPeripheral *) initWithPeripheral:(CBPeripheral*)peripheral delegate:(id<UARTPeripheralDelegate>) delegate
{
    NSLog(@"peripheral init");
    if (self = [super init])
    {
        _peripheral = peripheral;
        _peripheral.delegate = self;
        _delegate = delegate;
        _valueLabels = [[NSMutableArray alloc] initWithCapacity:10];
        _dots = [[NSMutableArray alloc] initWithCapacity:10];
        for (int i=0; i<10; i++) values[i] = 0;
        
    }
    return self;
}

- (void) didConnect
{
    NSLog(@"peripheral did connect");
    //[_peripheral discoverServices:@[self.class.uartServiceUUID, self.class.deviceInformationServiceUUID]];
    [_peripheral discoverServices:nil];
    NSLog(@"Did start service discovery.");
}

- (void) didDisconnect
{
    
}

- (void) writeString:(NSString *) string
{
    
    /*NSData *data = [NSData dataWithBytes:string.UTF8String length:string.length];
     if ((self.txCharacteristic.properties & CBCharacteristicPropertyWriteWithoutResponse) != 0)
     {
     [self.peripheral writeValue:data forCharacteristic:self.txCharacteristic type:CBCharacteristicWriteWithoutResponse];
     }
     else if ((self.txCharacteristic.properties & CBCharacteristicPropertyWrite) != 0)
     {
     [self.peripheral writeValue:data forCharacteristic:self.txCharacteristic type:CBCharacteristicWriteWithResponse];
     }
     else
     {
     NSLog(@"No write property on TX characteristic, %d.", self.txCharacteristic.properties);
     }*/
}

- (void) writeRawData:(NSData *) data
{
    
}

- (void) peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    if (error)
    {
        NSLog(@"Error discovering services: %@", error);
        return;
    }
    NSLog(@"::peripheral diddiscover");
    for (CBService *s in [peripheral services])
    {
        //NSLog(@"servire uuid:%@(%d)", s.UUID, [[s characteristics] count]);
        
        
        if ([s.UUID isEqual:[CBUUID UUIDWithString:@"180D"]])
        {
            NSLog(@"Found correct service");
            NSLog(@":%@:", s.UUID);
            self.uartService = s;
            
            //[self.peripheral discoverCharacteristics:@[self.class.txCharacteristicUUID, self.class.rxCharacteristicUUID] forService:self.uartService];
            [self.peripheral discoverCharacteristics:nil forService:s];
            break;
        }
        /*else if ([s.UUID isEqual:self.class.deviceInformationServiceUUID])
         {
         [self.peripheral discoverCharacteristics:@[self.class.hardwareRevisionStringUUID] forService:s];
         }*/
    }
}

- (void) peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    NSLog(@"peripheral diddiscovercharactors");
    if (error)
    {
        NSLog(@"Error discovering characteristics: %@", error);
        return;
    }
    //NSLog(@"discover service: %@(%d)", service.UUID, [[service characteristics] count]);
    
    for (CBCharacteristic *c in [service characteristics])
    {
        //NSLog(@"UUID: %@", c.UUID);
        //NSLog(@"value: %@", c.value);
        if ([c.UUID isEqual:[CBUUID UUIDWithString:@"2A37"]]) {
            NSLog(@":peripheral chara: %@", c.UUID);
            [self.peripheral setNotifyValue:YES forCharacteristic:c];
        }
        /*if ([c.UUID isEqual:self.class.rxCharacteristicUUID])
         {
         NSLog(@"Found RX characteristic");
         self.rxCharacteristic = c;
         
         [self.peripheral setNotifyValue:YES forCharacteristic:self.rxCharacteristic];
         }f
         else if ([c.UUID isEqual:self.class.txCharacteristicUUID])
         {
         NSLog(@"Found TX characteristic");
         self.txCharacteristic = c;
         }
         else if ([c.UUID isEqual:self.class.hardwareRevisionStringUUID])
         {
         NSLog(@"Found Hardware Revision String characteristic");
         [self.peripheral readValueForCharacteristic:c];
         }*/
    }
}

- (void) peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error)
    {
        NSLog(@"Error receiving notification for characteristic %@: %@", characteristic, error);
        return;
    }
    
    //NSLog(@"Received data on a characteristic.");
    
    int val = 0;
    //val = [[NSString alloc]]
    [characteristic.value getBytes:&val length:6];
    int t = (val>>(4*4+4))&(0xf);
    int value = (val>>(4*2))&(0xfff);
    float rate = value/(1100.0)+0.1;
    values[t-1] = value;
    ((WKInterfaceLabel *)(_valueLabels[t-1])).text = [NSString stringWithFormat:@"%d", value];
    //((UIImageView *)(_dots[t-1])).alpha = rate+0.1;
    WKInterfaceImage * v = (WKInterfaceImage *)[_dots objectAtIndex:t-1];
    v.alpha = rate;
    //((WKInterfaceLabel *)(_valueLabels[t-1])).text = [NSString stringWithFormat:@"%@", characteristic.value];
    
    //if (values>1) NSLog(@"%d!!", t-1);
    //NSLog(@"values: %d %d %d %d %d %d", values[0], values[1], values[2], values[3], values[4], values[5]);
    //changeValue(t, value);
    //_valueTexts[t] = [NSString stringWithFormat:@"%d", value];
    /*if (characteristic == self.rxCharacteristic)
     {
     
     NSString *string = [NSString stringWithUTF8String:[[characteristic value] bytes]];
     [self.delegate didReceiveData:string];
     }
     else if ([characteristic.UUID isEqual:self.class.hardwareRevisionStringUUID])
     {
     NSString *hwRevision = @"";
     const uint8_t *bytes = characteristic.value.bytes;
     for (int i = 0; i < characteristic.value.length; i++)
     {
     NSLog(@"%x", bytes[i]);
     hwRevision = [hwRevision stringByAppendingFormat:@"0x%02x, ", bytes[i]];
     }
     
     [self.delegate didReadHardwareRevisionString:[hwRevision substringToIndex:hwRevision.length-2]];
     }*/
}

- (void)addValueLabel:(WKInterfaceLabel *)l {
    [_valueLabels addObject:l];
}

- (void)addDot:(WKInterfaceImage *)d {
    d.alpha = 0.1;
    //NSLog(@"%f", d.alpha);
    [_dots addObject:d];
}

-(void)setChangeValueVoid:(iiVoid)c {
    changeValue = c;
}

@end
