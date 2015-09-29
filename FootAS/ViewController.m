//
//  ViewController.m
//  FootS
//
//  Created by Yuntao Wang on 15/8/29.
//  Copyright (c) 2015年 Yuntao Wang. All rights reserved.
//

#import "ViewController.h"

typedef enum
{
    IDLE = 0,
    SCANNING,
    CONNECTED,
} ConnectionState;


@interface ViewController ()
@property CBCentralManager *cm;
@property ConnectionState state;
@property UARTPeripheral *currentPeripheral;
@property NSTimer *flushTimer;
@property NSTimer *stepcountTimer;

@property (strong, nonatomic)HealthKitC *health;
@property int stepcountIn;
@property NSMutableArray *chart1x;
@property NSMutableArray *chart1ys;
@property int detailTag;
@property NSTimer *buttonBlinkTimer;
@property int buttonBlinkState;
@end

@implementation ViewController
@synthesize cm = _cm;
@synthesize currentPeripheral = _currentPeripheral;

/*- (BOOL)prefersStatusBarHidden
{
    // iOS7后,[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    // 已经不起作用了
    return YES;
}*/

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _state = IDLE;
    _scroll.contentSize = CGSizeMake(415, 755);
    _scroll.showsVerticalScrollIndicator = NO;
    _scroll.showsHorizontalScrollIndicator = NO;
    
    _cm = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    //[_button setTitle:@"connect" forState:UIControlStateNormal];
    [_button addTarget:self action:@selector(onButtonPressUp:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    _valueLabel1.textAlignment = NSTextAlignmentCenter;
    _valueLabel2.textAlignment = NSTextAlignmentCenter;
    _valueLabel3.textAlignment = NSTextAlignmentCenter;
    _valueLabel4.textAlignment = NSTextAlignmentCenter;
    _valueLabel5.textAlignment = NSTextAlignmentCenter;
    _valueLabel6.textAlignment = NSTextAlignmentCenter;
    
    _valueLabels = [[NSMutableArray alloc] initWithCapacity:10];
    [_valueLabels addObject:_valueLabel1];
    [_valueLabels addObject:_valueLabel2];
    [_valueLabels addObject:_valueLabel3];
    [_valueLabels addObject:_valueLabel4];
    [_valueLabels addObject:_valueLabel5];
    [_valueLabels addObject:_valueLabel6];
    
    
    //_valueLabel1 add
    
    _dots = [[NSMutableArray alloc] initWithCapacity:10];
    [_dots addObject:_dot1];
    [_dots addObject:_dot2];
    [_dots addObject:_dot3];
    [_dots addObject:_dot4];
    [_dots addObject:_dot5];
    [_dots addObject:_dot6];
    
    //[_button setImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
    //[_button setImage:[UIImage imageNamed:@"button_selected"] forState:UIControlStateHighlighted];
    _button.layer.contents = (id)[UIImage imageNamed:@"button"].CGImage;
    [_button addTarget:self action:@selector(onButtonPressDown:) forControlEvents:UIControlEventTouchDown];
    //_valueLabel1.text
    
    _wormhole = [[MMWormhole alloc] initWithApplicationGroupIdentifier:@"group.footas.test" optionalDirectory:nil];
    
    _health = [[HealthKitC alloc] init];
    _stepcountIn = 10;
    
    
    _twoView.clipsToBounds = YES;
    int width = _twoView.frame.size.width;
    int height = _twoView.frame.size.height;
    
    _detailTag = 0;
    
    _detailCharts = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width*4+2*3, height)];
    [_twoView addSubview:_detailCharts];
    
    _detailChartView0 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    [_detailCharts addSubview:_detailChartView0];
    
    //_oneView.frame = CGRectMake(0, 0, width, height);
    //[_detailCharts addSubview:_oneView];
    
    _chart1 = [[TheLineChart alloc] initWidthView:_detailChartView0 withStyle:0];
    _chart1.xArray = @[@"1", @"2", @"3", @"4"];
    _chart1.yArray = @[@[@"10", @"23", @"8", @"25"]];
    [_chart1 showInTheViewWirthAnimation:NO];
    
    _chart1x = [[NSMutableArray alloc] initWithCapacity:20];
    [_chart1x addObject:@"6:00"];
    [_chart1x addObject:@"8:00"];
    [_chart1x addObject:@"10:00"];
    [_chart1x addObject:@"12:00"];
    [_chart1x addObject:@"14:00"];
    [_chart1x addObject:@"16:00"];
    [_chart1x addObject:@"18:00"];
    
    _chart1ys = [[NSMutableArray alloc] initWithCapacity:10];
    [_chart1ys addObject:@[@"0", @"121", @"160", @"93", @"140"]];
    [_chart1ys addObject:@[@"0", @"80", @"110", @"89", @"110"]];
    [_chart1ys addObject:@[@"0", @"99", @"211", @"120", @"145"]];
    [_chart1ys addObject:@[@"0", @"134", @"175", @"89", @"116"]];
    [_chart1ys addObject:@[@"0", @"91", @"144", @"104", @"99"]];
    [_chart1ys addObject:@[@"0", @"30", @"140", @"99", @"98"]];
    
    for (int i=0; i<6; i++) {
        UITapGestureRecognizer *tapOnDot = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onDotTap:)];
        [_dots[i] addGestureRecognizer:tapOnDot];
    }
    //[_dot1 addGestureRecognizer:tapOnDot];
    //[_dot2 addGestureRecognizer:tapOnDot];
    //[_dot3 addGestureRecognizer:tapOnDot];
    //[_dot4 addGestureRecognizer:tapOnDot];
    //[_dot5 addGestureRecognizer:tapOnDot];
    //[_dot6 addGestureRecognizer:tapOnDot];
    
    _chart1.xArray = _chart1x;
    _chart1.yArray = @[_chart1ys[0]];
    [_chart1 showInTheViewWirthAnimation:NO];
    
    _detailChartView1 = [[UIView alloc] initWithFrame:CGRectMake((width+20), 0, width, height)];
    //_detailChartView1.backgroundColor = [UIColor redColor];
    [_detailCharts addSubview:_detailChartView1];
    
    _detailChartView2 = [[UIView alloc] initWithFrame:CGRectMake((width+20)*2, 0, width, height)];
    //_detailChartView2.backgroundColor = [UIColor greenColor];
    [_detailCharts addSubview:_detailChartView2];
    
    _detailChartView3 = [[UIView alloc] initWithFrame:CGRectMake((width+20)*3, 0, width, height)];
    //_detailChartView3.backgroundColor = [UIColor clearColor];
    [_detailCharts addSubview:_detailChartView3];
    
    
    UITapGestureRecognizer *dlbTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onChart1Dlbtap:)];
    dlbTap.numberOfTapsRequired = 2;
    [_detailChartView0 addGestureRecognizer:dlbTap];
    
    UISwipeGestureRecognizer *swipeOnDetailLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipeOnDetail:)];
    swipeOnDetailLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    UISwipeGestureRecognizer *swipeOnDetailRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipeOnDetail:)];
    swipeOnDetailRight.direction = UISwipeGestureRecognizerDirectionRight;
    [_twoView addGestureRecognizer:swipeOnDetailLeft];
    [_twoView addGestureRecognizer:swipeOnDetailRight];
    //NSLog(@"%@", _dots);
    
    _realtimeChart = [[TheLineChart alloc] initWidthView:_detailChartView1 withStyle:1];
    [_realtimeChart setRangeBeginWith:0 endWith:300];
    _realtimeChart.xArray = @[@"穴位1", @"穴位2", @"穴位3", @"穴位4", @"穴位5", @"穴位6"];
    //_realtimeChart.yArray = @[@"1", @"2", @"3", @"4", @"5", @"6"];
    NSMutableArray *array0 = [[NSMutableArray alloc] initWithCapacity:3];
    NSMutableArray *array1 = [[NSMutableArray alloc] initWithCapacity:10];
    for (int i=0; i<6; i++) [array1 addObject:[NSNumber numberWithInt:0]];
    [array0 addObject:array1];
    _realtimeChart.yArray = array0;
    
    //_realtimeChart.yArray = @[@[@"40", @"35", @"56", @"32", @"48", @"33"]];
    //_realtimeChart.colors = @[UUBlue];
    _realtimeChart.colors = @[[UIColor colorWithRed:59/255.0 green:186/255.0 blue:188/255.0 alpha:1]];
    
    [_realtimeChart showInTheViewWirthAnimation:NO];
    
    _disChart = [[TheLineChart alloc] initWidthView:_detailChartView2 withStyle:1];
    _disChart.xArray = @[@"穴位1", @"穴位2", @"穴位3", @"穴位4", @"穴位5", @"穴位6"];
    _disChart.yArray = @[@[@"40", @"35", @"56", @"32", @"48", @"33"]];
    //_disChart.colors = @[UURed];
    _disChart.colors = @[[UIColor colorWithRed:237/255.0 green:111/255.0 blue:61/255.0 alpha:1]];
    
    [_disChart showInTheViewWirthAnimation:NO];
    
    _bing = [[TheBing alloc] initWithView:_detailChartView3];
    _bing.values = @[
                     @{@"name":@"前脚掌压力", @"value":@58, @"color":[UIColor colorWithHex:0x31438c]},
                     @{@"name":@"后脚掌压力", @"value":@42, @"color":[UIColor colorWithHex:0x3bbabc]}
                     ];
    [_bing showInView];
    
    _buttonBlinkTimer = nil;
    _buttonBlinkState = 0;
    
    [_idifLabel setFont:[UIFont boldSystemFontOfSize:23]];
    _idifLabel.text = @"脚底压力值监控";
}

- (void)showOneDetailChart {
    if (_detailTag==0) {
        [_chart1 showInTheViewWirthAnimation:YES];
        _idifLabel.text = @"脚底压力值监控";
    }
    if (_detailTag==1) {
        [_realtimeChart showInTheViewWirthAnimation:YES];
        _idifLabel.text = @"脚底压力值实时变化";
    }
    if (_detailTag==2) {
        [_disChart showInTheViewWirthAnimation:YES];
        _idifLabel.text = @"脚底压力值数据";
    }
    if (_detailTag==3) {
        [_bing showInView];
        _idifLabel.text = @"脚底前后压力";
    }
}

- (void)buttonBlinkStart {
    _buttonBlinkTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(onButtonBlinkTimer:) userInfo:nil repeats:YES];
}

- (void)buttonBlinkStop {
    if (_buttonBlinkTimer) [_buttonBlinkTimer invalidate];
    _button.layer.contents = (id)[UIImage imageNamed:@"button"].CGImage;
    _buttonBlinkState = 0;
}

- (IBAction)onButtonBlinkTimer:(id)sender {
    _buttonBlinkState ^= 1;
    if (_buttonBlinkState==0) {
        _button.layer.contents = (id)[UIImage imageNamed:@"button"].CGImage;
    } else {
        _button.layer.contents = (id)[UIImage imageNamed:@"button_light"].CGImage;
    }
}

- (IBAction)onLabelValueChanged1:(id)sender {
    [_chart1.yArray replaceObjectAtIndex:0 withObject: _valueLabel1.text];
    if (_detailTag==0) {
        [_chart1 showInTheViewWirthAnimation:NO];
    }
}
- (IBAction)onLabelValueChanged2:(id)sender {
    [_chart1.yArray replaceObjectAtIndex:1 withObject: _valueLabel2.text];
    if (_detailTag==0) {
        [_chart1 showInTheViewWirthAnimation:NO];
    }
}
- (IBAction)onLabelValueChanged3:(id)sender {
    [_chart1.yArray replaceObjectAtIndex:2 withObject: _valueLabel3.text];
    if (_detailTag==0) {
        [_chart1 showInTheViewWirthAnimation:NO];
    }
}
- (IBAction)onLabelValueChanged4:(id)sender {
    [_chart1.yArray replaceObjectAtIndex:3 withObject: _valueLabel4.text];
    if (_detailTag==0) {
        [_chart1 showInTheViewWirthAnimation:NO];
    }
}
- (IBAction)onLabelValueChanged5:(id)sender {
    [_chart1.yArray replaceObjectAtIndex:4 withObject: _valueLabel5.text];
    if (_detailTag==0) {
        [_chart1 showInTheViewWirthAnimation:NO];
    }
}
- (IBAction)onLabelValueChanged6:(id)sender {
    NSLog(@"on 6 change");
    [_chart1.yArray replaceObjectAtIndex:5 withObject: _valueLabel6.text];
    if (_detailTag==0) {
        [_chart1 showInTheViewWirthAnimation:NO];
    }
}


- (IBAction)onSwipeOnDetail:(UISwipeGestureRecognizer *)sender {
    //NSLog(@"%lu", (unsigned long)sender.direction);
    CGPoint center = _detailCharts.center;
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        //NSLog(@"left");
        if (_detailTag >= 3) return;
        _detailTag++;
        [self showOneDetailChart];
        [UIView animateWithDuration:0.3 animations:^{
            _detailCharts.center = CGPointMake(center.x-_twoView.frame.size.width-20, center.y);
        }completion:^(BOOL finish){}];
    } else {
        //NSLog(@"right");
        if (_detailTag <=0 ) return;
        _detailTag--;
        [self showOneDetailChart];
        [UIView animateWithDuration:0.3 animations:^{
            _detailCharts.center = CGPointMake(center.x+_twoView.frame.size.width+20, center.y);
        }completion:^(BOOL finish){}];
        
    }
}

- (IBAction)onChart1Dlbtap:(id)sender {
    NSLog(@"dlb tap");
    _chart1.yArray = _chart1ys;
    [_chart1 showInTheViewWirthAnimation:YES];
}

- (IBAction)onDotTap:(UITapGestureRecognizer *)sender {
    //NSLog(@"tap on dot%@", sender);
    for (int i=0; i<6; i++) {
        if (_dots[i]==sender.view) {
            //NSLog(@"tap dot %d", i);
            _chart1.xArray = _chart1x;
            _chart1.yArray = @[_chart1ys[i]];
            [_chart1 showInTheViewWirthAnimation:YES];
        }
    }
}

- (IBAction)onButtonPressDown:(id)sender {
    //_button.layer.contents = (id)[UIImage imageNamed:@"button_selected"].CGImage;
}

- (IBAction)onButtonPressUp:(id)sender {
    //_button.layer.contents = (id)[UIImage imageNamed:@"button"].CGImage;
    switch (_state) {
        case IDLE:
            _state = SCANNING;
            NSLog(@"start scanning");
            //[_button setTitle:@"scanning" forState:UIControlStateNormal];
            [self buttonBlinkStart];
            [self.cm scanForPeripheralsWithServices:nil options:nil];
            break;
            
        case SCANNING:
            _state = IDLE;
            NSLog(@"stop scaning");
            [self buttonBlinkStop];
            _button.layer.contents = (id)[UIImage imageNamed:@"button"].CGImage;
            //[_button setTitle:@"connect" forState:UIControlStateNormal];
            [_cm stopScan];
            break;
            
        case CONNECTED:
            NSLog(@"disconnect");
            [self buttonBlinkStop];
            _button.layer.contents = (id)[UIImage imageNamed:@"button"].CGImage;
            //[_button setTitle:@"connect" forState:UIControlStateNormal];
            [_cm cancelPeripheralConnection:_currentPeripheral.peripheral];
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    _currentPeripheral.chart = _realtimeChart;
    
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
    [self buttonBlinkStop];
    _button.layer.contents = (id)[UIImage imageNamed:@"button_light"].CGImage;
    //[_button setTitle:@"disconnect" forState:UIControlStateNormal];
    //[self.sendButton setUserInteractionEnabled:YES];
    //[self.sendTextField setUserInteractionEnabled:YES];
    
    if ([self.currentPeripheral.peripheral isEqual:peripheral])
    {
        [self.currentPeripheral didConnect];
        _flushTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(onFlushTimer:) userInfo:nil repeats:YES];
        _stepcountTimer = [NSTimer scheduledTimerWithTimeInterval:_stepcountIn target:self selector:@selector(onStepcountTimer:) userInfo:nil repeats:NO];
    }
}

- (void) centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"Did disconnect peripheral %@", peripheral.name);
    
    [_flushTimer invalidate];
    [_stepcountTimer invalidate];
    //[self addTextToConsole:[NSString stringWithFormat:@"Did disconnect from %@, error code %d", peripheral.name, error.code] dataType:LOGGING];
    
    self.state = IDLE;
    [self buttonBlinkStop];
    _button.layer.contents = (id)[UIImage imageNamed:@"button"].CGImage;
    //[_button setTitle:@"connect" forState:UIControlStateNormal];
    //[self.sendButton setUserInteractionEnabled:NO];
    //[self.sendTextField setUserInteractionEnabled:NO];
    
    if ([self.currentPeripheral.peripheral isEqual:peripheral])
    {
        [self.currentPeripheral didDisconnect];
    }
}

- (IBAction)onFlushTimer:(id)sender {
    //NSLog(@"on flush timer");
    for (int i=0; i<6; i++) {
        [_wormhole passMessageObject:@{@"ch":[NSNumber numberWithInteger:i+1], @"val":_currentPeripheral.values[i]} identifier:@"chara"];
    }
}

- (IBAction)onStepcountTimer:(id)sender {
    NSLog(@"on stepcount timer");
    if (_stepcountTimer) [_stepcountTimer invalidate];
    if (_currentPeripheral) {
        [_health saveStepcount:[_currentPeripheral stepcount] date:[NSDate date]];
        _currentPeripheral.stepcount = 0;
        
    }else [_health saveStepcount:1 date:[NSDate date]];
    
    _stepcountTimer = [NSTimer scheduledTimerWithTimeInterval:_stepcountIn target:self selector:@selector(onStepcountTimer:) userInfo:nil repeats:NO];
}

- (IBAction)onTestButtonPress:(id)sender {
    [_wormhole passMessageObject:@{@"test":[NSNumber numberWithInteger:1]} identifier:@"test"];
}

- (IBAction)onHealthButtonPress:(id)sender {
    //[_health saveStepcount:10 date:[NSDate date]];
    [self onStepcountTimer:self];
}

@end
