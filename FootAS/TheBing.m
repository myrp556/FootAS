//
//  TheBing.m
//  FootAS
//
//  Created by Yuntao Wang on 15/9/18.
//  Copyright (c) 2015年 Yuntao Wang. All rights reserved.
//

#import "TheBing.h"

@implementation TheBing

- (id)initWithView:(UIView *)v {
    self = [super init];
    if (self) {
        _theView = v;
        //_theView.backgroundColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1];
        //_theView.backgroundColor = [UIColor clearColor];
        _values = [[NSMutableArray alloc] initWithCapacity:10];
        _chart = [[VBPieChart alloc] init];
        [_chart setFrame:CGRectMake(0, 0, v.frame.size.height-20, v.frame.size.height-20)];
        [_chart setCenter:CGPointMake(v.frame.size.width/2, v.frame.size.height/2)];
        [_chart setEnableStrokeColor:YES];
        [_chart setHoleRadiusPrecent:0.3];
        
        [_chart.layer setShadowOffset:CGSizeMake(2, 2)];
        [_chart.layer setShadowRadius:3];
        [_chart.layer setShadowColor:[UIColor blackColor].CGColor];
        [_chart.layer setShadowOpacity:0.7];
        [_chart setHoleRadiusPrecent:0.3];
        
        [_chart setLabelsPosition:VBLabelsPositionOnChart];
        //_chart.backgroundColor = [UIColor colorWithIntegerRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1];
        [_theView addSubview:_chart];
    }
    return self;
}

- (void)showInView {
    if (!_values || [_values count]==0) return;
    //NSLog(@"...");
    [_chart setChartValues:_values animation:YES duration:0.3 options:VBPieChartAnimationFan];
}
@end
