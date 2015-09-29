//
//  TheLineChart.h
//  FootAS
//
//  Created by Yuntao Wang on 15/9/17.
//  Copyright (c) 2015年 Yuntao Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UUChart.h"

@interface TheLineChart : NSObject
@property (strong, nonatomic) UIView *theView;
@property (strong, nonatomic) NSMutableArray *xArray;
@property (strong, nonatomic) NSMutableArray *yArray;
@property (strong, nonatomic) NSMutableArray *colors;
@property BOOL hasRange;

- (id)initWidthView:(UIView *)view withStyle:(int)style;
- (void)showInTheViewWirthAnimation:(BOOL)withAnimation;
- (void)setRangeBeginWith:(int)beg endWith:(int)end;
@end
