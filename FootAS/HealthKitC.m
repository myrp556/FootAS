//
//  HealthKitC.m
//  FootAS
//
//  Created by Yuntao Wang on 15/9/3.
//  Copyright (c) 2015年 Yuntao Wang. All rights reserved.
//

#import "HealthKitC.h"

@implementation HealthKitC

-(id) init {
    self = [super init];
    if (self){
        NSLog(@"is healthkit: %d", [HKHealthStore isHealthDataAvailable]);
        if ([HKHealthStore isHealthDataAvailable] != YES) {
            NSLog(@"HealthKit not avaliable!");
            self.hs = nil;
            return nil;
        }
    
        self.hs = [[HKHealthStore alloc] init];
        HKObjectType *stepcount = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
        //HKObjectType *stepcount = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryEnergyConsumed];
        NSSet *read = [NSSet setWithObjects:stepcount, nil];
        NSSet *wirte = [NSSet setWithObjects:stepcount, nil];
        //return nil;
        [_hs requestAuthorizationToShareTypes:wirte readTypes:read completion:^(BOOL success, NSError *error) {
            if (success == YES)
                NSLog(@"request success");
            else {
                NSLog(@"request faild");
                NSLog(@"%@", error);
            }
        }];
        //_healthstore authorizationStatusf
        if ([_hs authorizationStatusForType:stepcount] != HKAuthorizationStatusSharingAuthorized) {
            NSLog(@"not authorization");
            return nil;
        };
    }
    return self;
}

- (void) saveStepcount:(int)c date:(NSDate *)d{
    if (!_hs) {
        NSLog(@"no hs!");
        return;
    }
    HKQuantityType *type = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    HKQuantity *cou = [HKQuantity quantityWithUnit:[HKUnit countUnit] doubleValue:c];
    
    HKQuantitySample *sample = [HKQuantitySample quantitySampleWithType:type quantity:cou startDate:d endDate:d];
    NSLog(@"sample %@", sample);
    
    [_hs saveObject:sample withCompletion:^(BOOL success, NSError *error) {
        if (success == YES) {
            NSLog(@"save success");
            //flag = YES;
        } else {
            NSLog(@"save failed");
        }
    }];
    //return flag;
}
@end
