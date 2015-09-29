//
//  ViewController.h
//  FootS
//
//  Created by Yuntao Wang on 15/8/29.
//  Copyright (c) 2015年 Yuntao Wang. All rights reserved.
//s

#import <UIKit/UIKit.h>
#import "UARTPeripheral.h"
#import "MMWormhole.h"
#import "HealthKitC.h"
#import "TheLineChart.h"
#import "TheBing.h"

@interface ViewController : UIViewController <UITextFieldDelegate, CBCentralManagerDelegate, UARTPeripheralDelegate>

@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel1;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel3;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel4;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel5;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel6;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel2;
@property (weak, nonatomic) IBOutlet UIImageView *dot1;
@property (weak, nonatomic) IBOutlet UIImageView *dot2;
@property (weak, nonatomic) IBOutlet UIImageView *dot3;
@property (weak, nonatomic) IBOutlet UIImageView *dot4;
@property (weak, nonatomic) IBOutlet UIImageView *dot5;
@property (weak, nonatomic) IBOutlet UIImageView *dot6;
@property (weak, nonatomic) IBOutlet UIView *footView;
@property (weak, nonatomic) IBOutlet UIView *twoView;
@property NSMutableArray *valueLabels;
@property NSMutableArray *dots;
@property (strong, nonatomic) MMWormhole *wormhole;

@property (weak, nonatomic) IBOutlet UIButton *testButton;
@property (weak, nonatomic) IBOutlet UIButton *healthButton;
@property (strong, nonatomic) TheLineChart *chart1;
@property (strong, nonatomic) TheLineChart *realtimeChart;
@property (strong, nonatomic) TheLineChart *disChart;
@property (strong, nonatomic) UIView *detailCharts;
@property (strong, nonatomic) UIView *detailChartView0;
@property (strong, nonatomic) UIView *detailChartView1;
@property (strong, nonatomic) UIView *detailChartView2;
@property (strong, nonatomic) UIView *detailChartView3;
@property (strong, nonatomic) TheBing *bing;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (weak, nonatomic) IBOutlet UILabel *idifLabel;

- (IBAction)onTestButtonPress:(id)sender;
- (IBAction)onHealthButtonPress:(id)sender;

@end

