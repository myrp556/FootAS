//
//  TheBing.h
//  FootAS
//
//  Created by Yuntao Wang on 15/9/18.
//  Copyright (c) 2015年 Yuntao Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIColor+HexColor.h"
#import "VBPieChart.h"

@interface TheBing : NSObject
@property (nonatomic, strong)UIView *theView;
@property (nonatomic, strong)VBPieChart *chart;
@property NSArray *values;

- (id)initWithView:(UIView *)view;
- (void)showInView;

@end
