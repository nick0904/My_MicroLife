//
//  MyHealthStore.h
//  HealthKitSync
//
//  Created by 曾偉亮 on 2017/2/9.
//  Copyright © 2017年 Nick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol MyHealthStoreDelegate <NSObject>

@optional

-(void)birthdayData:(NSString *)birthDayStrFormHealthKit;
-(void)genderData:(NSString *)genderStrFormHealthKit;
-(void)heightData:(NSString *)heightStrFormHealthKit;
-(void)weightData:(NSString *)weightStrFormHealthKit;

@end


typedef enum{
    
    healthKit_heartRate = 0,
    healthKit_bodyTemp,
    healthKit_BMI,
    healthKit_bodyFat,
    healthKit_height,
    healthKit_weight
    
}saveHealthType;


@interface MyHealthStore : NSObject

@property (strong, nonatomic) NSString *birthdayStr;
@property (strong, nonatomic) NSString *genderStr;
@property (strong, nonatomic) NSString *heightStr;
@property (strong, nonatomic) NSString *weightStr;
@property (strong, nonatomic) UIViewController *superVC;
@property (strong) id<MyHealthStoreDelegate> delegate;

-(id)initHealthStore;

-(void)readDataFromHealthStore;///從 HealthStore 取得資料

-(void)saveMeasureDataToHealthStore:(saveHealthType)type dataValue:(double)dataValue;///將資料存到 HealthStore

-(void)saveBloodPressureDataToHealthStore:(double)sysValue diaValue:(double)diaValue;///將資料存到 HealthStore (血壓專用)


@end
