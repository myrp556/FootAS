//
//  TheLineChart.m
//  FootAS
//
//  Created by Yuntao Wang on 15/9/17.
//  Copyright (c) 2015年 Yuntao Wang. All rights reserved.
//

#import "TheLineChart.h"

@interface TheLineChart ()<UUChartDataSource> {
    UUChart *chart;
    UUChartStyle chartStyle;
    int beg;
    int end;
}

@end

@implementation TheLineChart

- (id)initWidthView:(UIView *)v withStyle:(int)s{
    self = [super init];
    if (self) {
        chart = nil;
        chartStyle = (s==0?UUChartLineStyle:UUChartBarStyle);
        _theView = v;
        _xArray = [[NSMutableArray alloc] initWithCapacity:10];
        _yArray = [[NSMutableArray alloc] initWithCapacity:10];
        _colors = [[NSMutableArray alloc] initWithCapacity:10];
        _hasRange = NO;
        beg = 0;
        end = 0;
    }
    return self;
}

- (void)setRangeBeginWith:(int)b endWith:(int)e {
    _hasRange = YES;
    beg = b;
    end = e;
}

- (CGRange)UUChartChooseRangeInLineChart:(UUChart *)chart
{
    if (_hasRange==YES) return CGRangeMake(end, beg);
    return CGRangeZero;
}

- (NSArray *)UUChart_xLableArray:(UUChart *)chart {
    return self.xArray;

}

- (NSArray *)UUChart_yValueArray:(UUChart *)chart {
    //return @[@[@"10", @"22", @"14", @"35"]];
    return self.yArray;
}

- (NSArray *)UUChart_ColorArray:(UUChart *)chart {
    if ([_colors count]>0) return _colors;
    return nil;
}

- (void)showInTheViewWirthAnimation:(BOOL)w {
    if (!_xArray || !_yArray) return;
    if (chart) {
        [chart removeFromSuperview];
        chart = nil;
    }
    
    if (!_theView) {
        NSLog(@"no view!");
        return;
    }
    chart = [[UUChart alloc] initwithUUChartDataFrame:CGRectMake(0, 0, _theView.frame.size.width, _theView.frame.size.height) withSource:self withStyle:chartStyle];
    chart.backgroundColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1];
    [chart showInView:_theView withAnimation:w];//NSLog(@"%@", _theView);
    
};
@end
