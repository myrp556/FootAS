//
//  InterfaceController.h
//  FootAS WatchKit Extension
//
//  Created by Yuntao Wang on 15/8/30.
//  Copyright (c) 2015年 Yuntao Wang. All rights reserved.
//

#import <WatchKit/WatchKit.h>
#import <Foundation/Foundation.h>
#import "UARTPeripheral.h"
#import "MMWormhole.h"

@interface InterfaceController : WKInterfaceController<UITextFieldDelegate, CBCentralManagerDelegate, UARTPeripheralDelegate>
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *valueLabel1;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *valueLabel2;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *valueLabel3;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *valueLabel4;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *valueLabel5;
@property (weak, nonatomic) IBOutlet WKInterfaceLabel *valueLabel6;
@property (weak, nonatomic) IBOutlet WKInterfaceImage *dot1;
@property (weak, nonatomic) IBOutlet WKInterfaceImage *dot2;
@property (weak, nonatomic) IBOutlet WKInterfaceImage *dot3;
@property (weak, nonatomic) IBOutlet WKInterfaceImage *dot4;
@property (weak, nonatomic) IBOutlet WKInterfaceImage *dot5;
@property (weak, nonatomic) IBOutlet WKInterfaceImage *dot6;
@property (weak, nonatomic) IBOutlet WKInterfaceButton *button;
@property (strong, nonatomic) MMWormhole *wormhole;

- (IBAction)onButtonPress:(id)sender;

@end
