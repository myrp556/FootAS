//
//  HealthKitC.h
//  FootAS
//
//  Created by Yuntao Wang on 15/9/3.
//  Copyright (c) 2015年 Yuntao Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HealthKit/HealthKit.h>

@interface HealthKitC : NSObject
@property (strong, nonatomic)HKHealthStore *hs;

- (id) init;
- (void) saveStepcount:(int)count date:(NSDate *)date;
@end
