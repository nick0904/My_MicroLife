//
//  MyHealthStore.m
//  HealthKitSync
//
//  Created by 曾偉亮 on 2017/2/9.
//  Copyright © 2017年 Nick. All rights reserved.
//

#import "MyHealthStore.h"
#import <HealthKit/HealthKit.h>

/**
 很重要:
 HealthKit(2017/02/07)目前尚未支援 ipad,如 app 要在 ipad 運作,必須 remove healthkit from "Required device capabilities" in info.plist
 */

#define default_birthday  @"1946/01/01"
#define default_gender    @"男性"
#define default_height    @"175"
#define default_weight    @"75"

@implementation MyHealthStore {
    
    HKHealthStore *myHealthStore;
    UIActivityIndicatorView *indicatorView;
}


#pragma mark - initilization  *****************************
-(id)initHealthStore {
    
    self = [super init];

    if (!self) return nil;
    
    myHealthStore = [[HKHealthStore alloc] init];
    
    self.birthdayStr = default_birthday;
    self.genderStr = default_gender;
    self.heightStr = default_height;
    self.weightStr = default_weight;
    
    return self;
}


#pragma mark - 從 Health Store 抓取資料  ***************************
-(void)readDataFromHealthStore {
    
    //1st.確認裝置是否支援 HealthKit
    if ([HKHealthStore isHealthDataAvailable]) {
        
        //2nd.從HealthKit讀取資料
        NSSet *readData = [self getDataFromHelathStore];
        
        //3rd.向HealthKit請求存取資料的權限
        [myHealthStore requestAuthorizationToShareTypes:nil readTypes:readData completion:^(BOOL success, NSError * _Nullable error) {
            
            if (error) {
                
                self.birthdayStr = default_birthday;
                self.genderStr = default_gender;
                self.heightStr = default_height;
                self.weightStr = default_weight;
                
                [self showAlert:@"注意" message:@"存取HealthKit失敗"];
            }
            else {
                
                if (indicatorView == nil) {
                    
                    //[self showIndicatorView];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self readDataOfMe];
                    
                });
            
            }
            
        }];

    }
    else {
        
        self.birthdayStr = default_birthday;
        self.genderStr = default_gender;
        self.heightStr = default_height;
        self.weightStr = default_weight;
        [self showAlert:@"注意" message: @"您的裝置不支援 HealthKit"];
    }
    
}

-(NSSet *)getDataFromHelathStore {
    
    ///抓取 生日 - 性別 - 身高 - 體重,如想抓取更多資料請自行增加
    return [NSSet setWithObjects:
            [HKCharacteristicType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierDateOfBirth],
            [HKCharacteristicType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierBiologicalSex],
            [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight],
            [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass],nil];
    
}


-(void)readDataOfMe {
    
    //Birthday
    [self getBirthDayFromHealthStore];
    
    //Gender
    [self getGenderFromHealthStore];
    
    //Height
    [self getHeightDataFromHealthStore];
    
    //Weight
    [self getWeightDataFromHealthStore];
    
    
    if (indicatorView != nil) {
        
        [self closeIndicatorView];
    }

}

//getBirthDayFromHealthStore
-(void)getBirthDayFromHealthStore {
    
    NSError *error;
    
    NSDate *birthdayDate = [myHealthStore dateOfBirthWithError:&error];
    if (!birthdayDate) {
        
        self.birthdayStr = default_birthday;
        [self showAlert:@"注意" message:@"讀取生日資料失敗或生日尚未設定"];
    }
    else {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"YYYY/MM/dd"];
        self.birthdayStr = [formatter stringFromDate:birthdayDate];
        
        [self.delegate birthdayData:self.birthdayStr];
    }
    
}



//getGenderFromHealthStore
-(void)getGenderFromHealthStore {
    
    NSError *error;
    
    HKBiologicalSexObject *sex = [myHealthStore biologicalSexWithError:&error];
    if (!sex) {
        
        self.genderStr = default_gender;
        [self showAlert:@"注意" message:@"讀取性別資料失敗"];
       
    }
    else {
        
        switch (sex.biologicalSex) {
            case HKBiologicalSexMale:
                self.genderStr = @"0";//enum:2 / 男性
                break;
            case HKBiologicalSexFemale:
                self.genderStr = @"1";//enum:1 / 女性
                break;
            case HKBiologicalSexNotSet:
                self.genderStr = @"2";//enum:0 / 尚未設定性別
                break;
            case HKBiologicalSexOther:
                self.genderStr = @"2";//enum:3 / 中性(其它)
                break;
            default:
                break;
            
        }
        
        [self.delegate genderData:self.genderStr];
        
    }

}



/**
 quantityType 專用
 抓取quantity資料時,記得要設定時間
 */
-(void)fetchDataOfQuantityType:(HKQuantityType *)quantityType withCompletion:(void (^) (NSArray *result, NSError *error)) completion {
    
    //設定時間排序
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:HKSampleSortIdentifierEndDate ascending:YES];
    
    //從HealthKit讀取資料
    HKSampleQuery *query = [[HKSampleQuery alloc] initWithSampleType:quantityType predicate:nil limit:HKObjectQueryNoLimit sortDescriptors:@[sortDescriptor] resultsHandler:^(HKSampleQuery * _Nonnull query, NSArray<__kindof HKSample *> * _Nullable results, NSError * _Nullable error) {
        
        if (!results) {
            
            if (completion) {
                
                completion(nil, error);
                [self showAlert:@"注意" message:@"讀取Quantity資料錯誤"];
            }
            
        }
        else {
            
            completion(results, error);
        }
        
    }];
    
    [myHealthStore executeQuery:query];
    
}


//getHeightDataFromHealthStore
-(void)getHeightDataFromHealthStore {
    
    [self fetchDataOfQuantityType:[HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight] withCompletion:^(NSArray *result, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (error) {
                
                self.heightStr = default_height;
                [self showAlert:@"注意" message:@"讀取身高資料失敗"];
            }
        
            if (result.count == 0) {
                
                self.heightStr = default_height;
                [self showAlert:@"注意" message:@"沒有身高資料可取"];
                
            }
            else {
                
                //可能會有多筆資料,取最後一筆
                NSString *h = [NSString stringWithFormat:@"%@",result[result.count-1]];
                NSArray *h_array = [h componentsSeparatedByString:@" m"];
                h = h_array[0];
                float height_m = [h floatValue];
                float height_cm = height_m * 100;
                NSString *final_height = [NSString stringWithFormat:@"%.0f",height_cm];
                self.heightStr = final_height;
                
                [self.delegate heightData:self.heightStr];
                
            }
            
            
        });
        
    }];

}



//getWeightDataFromHealthStore
-(void)getWeightDataFromHealthStore {
    
    [self fetchDataOfQuantityType:[HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass] withCompletion:^(NSArray *result, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (error) {
                
                self.weightStr = default_weight;
                [self showAlert:@"注意" message:@"讀取體重資料失敗"];
            }
            
            
            if (result.count == 0) {
                
                self.weightStr = default_weight;
                [self showAlert:@"注意" message:@"沒有身高資料可取"];
            }
            else {
                
                NSString *weight = [NSString stringWithFormat:@"%@",result[result.count-1]];
                NSArray *ary_weight = [weight componentsSeparatedByString:@" kg"];
                weight = ary_weight[0];
                float weight_Float = [weight floatValue];
                NSString *final_weight = [NSString stringWithFormat:@"%.1f",weight_Float];
                self.weightStr = final_weight;
                
                [self.delegate weightData:self.weightStr];
                
            }
            
            
        });
        
        
    }];

}



#pragma mark - 將資料存入 Health Store  ***************************
/**
 寫入資料時要注意設定 "單位"
 =================================
 1.心跳:次/分鐘
 ＝===============================
 2.血壓:mmHg
 ＝===============================
 3.體溫:度C
 ＝===============================
 4.體重:g
 ＝===============================
 5.體脂:百分比
 ＝===============================
 6.身體質量指數(BMI):次
 */

-(NSSet *)writeDataToHealthStore {
    
    ///將 心跳 - 血壓高/低 - 體溫 - 體脂 - BMI - 身高 - 體重,寫入到Health Store,如想寫入更多資料,請自行增加
    return [NSSet setWithObjects:
            [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeartRate],
            [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodPressureSystolic],
            [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodPressureDiastolic],
            [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyTemperature],
            [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyFatPercentage],
            [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMassIndex],
            [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight],
            [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass],nil];
}

-(void)saveMeasureDataToHealthStore:(saveHealthType)type dataValue:(double)dataValue {
    
    //1st.確認裝置是否支援 HealthKit
    if ([HKHealthStore isHealthDataAvailable]) {
        
        //2nd.將資料寫入HealthKit
        NSSet *writeData = [self writeDataToHealthStore];
        
        //3rd.向HealthKit請求存取資料的權限
        [myHealthStore requestAuthorizationToShareTypes:writeData readTypes:nil completion:^(BOOL success, NSError * _Nullable error) {
            
            if (error) {
                
                [self showAlert:@"注意" message:@"存取HealthKit失敗"];
            }
            else {
                
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                    
                    switch (type) {
                        case healthKit_heartRate:
                            [self addHeartRateToHealthStore:dataValue];
                            break;
                        case healthKit_bodyTemp:
                            [self addTempDataToHealthStore:dataValue];
                            break;
                        case healthKit_BMI:
                            NSLog(@"BMI start");
                            [self addBMIDataToHeakthStore:dataValue];
                            break;
                        case healthKit_bodyFat:
                            NSLog(@"BodyFAT start");
                            [self addBodyFatToHealthStore:dataValue];
                            break;
                        case healthKit_height:
                            [self addHeightDataToHealthStore:dataValue];
                            break;
                        case healthKit_weight:
                            [self addWeightDataToHealthStore:dataValue];
                            break;
                        default:
                            break;
                    }
                    
                    
                });
                
                /**
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (indicatorView == nil) {
                        
                        //[self showIndicatorView];
                    }
                    
                    switch (type) {
                        case healthKit_heartRate:
                            [self addHeartRateToHealthStore:dataValue];
                            break;
                        case healthKit_bodyTemp:
                            [self addTempDataToHealthStore:dataValue];
                            break;
                        case healthKit_BMI:
                            NSLog(@"BMI start");
                            [self addBMIDataToHeakthStore:dataValue];
                            break;
                        case healthKit_bodyFat:
                            NSLog(@"BodyFAT start");
                            [self addBodyFatToHealthStore:dataValue];
                            break;
                        case healthKit_height:
                            [self addHeightDataToHealthStore:dataValue];
                            break;
                        case healthKit_weight:
                            [self addWeightDataToHealthStore:dataValue];
                            break;
                        default:
                            break;
                    }

                    
                });
                */
            }

            
        }];
        
    }
    else {
        
        [self showAlert:@"注意" message: @"您的裝置不支援 HealthKit"];
    }
    
}

//儲存血壓專用
-(void)saveBloodPressureDataToHealthStore:(double)sysValue diaValue:(double)diaValue {
    
    if ([HKHealthStore isHealthDataAvailable]) {
        
        NSSet *writeData = [self writeDataToHealthStore];
        
        [myHealthStore requestAuthorizationToShareTypes:writeData readTypes:nil completion:^(BOOL success, NSError * _Nullable error) {
            
            if (error) {
                
                [self showAlert:@"注意" message:@"存取HealthKit失敗"];
            }
            else {
            
                if (indicatorView == nil) {
                    
                    //[self showIndicatorView];
                }
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                    
                    [self addBloodPressureDataToHealthStore:sysValue Dia:diaValue];
                });
                
                
                /*
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                     [self addBloodPressureDataToHealthStore:sysValue Dia:diaValue];
                });
                */
            }
            
        }];
        
    }
    else {
        
        [self showAlert:@"注意" message: @"您的裝置不支援 HealthKit"];
    }
    
}


//血壓
-(void)addBloodPressureDataToHealthStore:(double)Sys Dia:(double)Dia {
    
    ///設定單位:mmHg
    HKUnit *unit = [HKUnit millimeterOfMercuryUnit];
    
    
    ///將量測數據與單位綁在一起
    HKQuantity *sysData = [HKQuantity quantityWithUnit:unit doubleValue:Sys];
    HKQuantity *diaData = [HKQuantity quantityWithUnit:unit doubleValue:Dia];
    
    
    ///設定 Health Store 要處理的型態
    HKQuantityType *quantityTypeSys = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodPressureSystolic];
    HKQuantityType *quantityTypeDia = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodPressureDiastolic];
    
    
    ///取得量測時間 (測試時以目前時間為主)
    NSDate *measureDate = [NSDate date];
    
    ///設定量測資料及記錄時間
    HKQuantitySample *measureSampleSys = [HKQuantitySample quantitySampleWithType:quantityTypeSys quantity:sysData startDate:measureDate endDate:measureDate];
    HKQuantitySample *measureSampleDia = [HKQuantitySample quantitySampleWithType:quantityTypeDia quantity:diaData startDate:measureDate endDate:measureDate];
    
    NSSet *objects = [NSSet setWithObjects:measureSampleSys,measureSampleDia, nil];
    
    HKCorrelationType *bloodPressureType = [HKObjectType correlationTypeForIdentifier:HKCorrelationTypeIdentifierBloodPressure];
    
    HKCorrelation *bloodPressure = [HKCorrelation correlationWithType:bloodPressureType startDate:measureDate endDate:measureDate objects:objects];
    
    ///儲存資料
    [myHealthStore saveObject:bloodPressure withCompletion:^(BOOL success, NSError * _Nullable error) {
        
        if (indicatorView != nil) {
            
            [self closeIndicatorView];
        }
        
        
        if (success) {
            
            //[self showAlert:@"儲存血壓成功" message:@""];
        }
        else {
            
            [self showAlert:@"Alert" message:@"儲存血壓失敗"];
        }
        
    }];
    
}


//心跳
-(void)addHeartRateToHealthStore:(double)heartRate {
    
    //[self showIndicatorView];
    
    ///設定單位:次/分鐘
    HKUnit *unit = [[HKUnit countUnit] unitDividedByUnit:[HKUnit minuteUnit]];
    
    ///將量測數據與單位綁在一起
    HKQuantity *dataQuantity = [HKQuantity quantityWithUnit:unit doubleValue:heartRate];
    
    ///設定 Health Store 要處理的型態
    HKQuantityType *quantityType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeartRate];
    
    ///取得量測時間 (測試時以目前時間為主)
    NSDate *mesureDate = [NSDate date];
    
    ///設定量測資料及記錄時間
    HKQuantitySample *measureSample = [HKQuantitySample quantitySampleWithType:quantityType quantity:dataQuantity startDate:mesureDate endDate:mesureDate];
    
    ///儲存資料
    [myHealthStore saveObject:measureSample withCompletion:^(BOOL success, NSError * _Nullable error) {
        
        if (indicatorView != nil) {
            
            [self closeIndicatorView];
        }
        
        if (success) {
            
            //[self showAlert:@"存入心跳到 HealthKit 成功" message:@""];
        }
        else {
            
            [self showAlert:@"警告" message:@"存入心跳資料失敗..."];
        }
        
    }];
    
}




//體溫
-(void)addTempDataToHealthStore:(double)tempValue {
    
    //[self showIndicatorView];
    
    ///設定單位:mmHg
    HKUnit *unit = [HKUnit degreeCelsiusUnit];
    
    ///將量測數據與單位綁在一起
    HKQuantity *tempData = [HKQuantity quantityWithUnit:unit doubleValue:tempValue];
    
    ///設定 Health Store 要處理的型態
    HKQuantityType *quantityTypeTemp = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyTemperature];
    
    ///取得量測時間 (測試時以目前時間為主)
    NSDate *mesureDate = [NSDate date];
    
    ///設定量測資料及記錄時間
    HKQuantitySample *measureSampleTemp = [HKQuantitySample quantitySampleWithType:quantityTypeTemp quantity:tempData startDate:mesureDate endDate:mesureDate];
    
    ///儲存資料
    [myHealthStore saveObject:measureSampleTemp withCompletion:^(BOOL success, NSError * _Nullable error) {
        
        if (indicatorView != nil) {
            
            [self closeIndicatorView];
        }
        
        if (success) {
            
            //[self showAlert:@"儲存體溫成功" message:@""];
        }
        else {
            
            [self showAlert:@"Alert" message:@"儲存體溫失敗"];
        }
    
    }];
    
}


//體脂
-(void)addBodyFatToHealthStore:(double)bodyFat {
    
    
    ///設定單位:mmHg
    HKUnit *unit = [HKUnit percentUnit]; //(0.0 - 1.0)
    
    ///將量測數據與單位綁在一起
    HKQuantity *bodyFatData = [HKQuantity quantityWithUnit:unit doubleValue:bodyFat];
    
    ///設定 Health Store 要處理的型態
    HKQuantityType *quantityTypeBodyFat = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyFatPercentage];
    
    ///取得量測時間 (測試時以目前時間為主)
    NSDate *mesureDate = [NSDate date];
    
    ///設定量測資料及記錄時間
    HKQuantitySample *measureSampleBodyFat = [HKQuantitySample quantitySampleWithType:quantityTypeBodyFat quantity:bodyFatData startDate:mesureDate endDate:mesureDate];
    
    ///儲存資料
    [myHealthStore saveObject:measureSampleBodyFat withCompletion:^(BOOL success, NSError * _Nullable error) {
        
        if (indicatorView != nil) {
            
            NSLog(@"BodyFAT action");
        }
        
        if (success) {
            
            //[self showAlert:@"儲存體脂成功" message:@""];
        }
        else {
            
            [self showAlert:@"Alert" message:@"儲存體脂失敗"];
        }
        
    }];
    
}



//BMI
-(void)addBMIDataToHeakthStore:(double)bmiValue {
    
    //[self showIndicatorView];
    
    ///設定單位:mmHg
    HKUnit *unit = [HKUnit countUnit];
    
    ///將量測數據與單位綁在一起
    HKQuantity *BMIData = [HKQuantity quantityWithUnit:unit doubleValue:bmiValue];
    
    ///設定 Health Store 要處理的型態
    HKQuantityType *quantityTypeBMI = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMassIndex];
    
    ///取得量測時間 (測試時以目前時間為主)
    NSDate *mesureDate = [NSDate date];
    
    ///設定量測資料及記錄時間
    HKQuantitySample *measureSampleBMI = [HKQuantitySample quantitySampleWithType:quantityTypeBMI quantity:BMIData startDate:mesureDate endDate:mesureDate];
    
    ///儲存資料
    [myHealthStore saveObject:measureSampleBMI withCompletion:^(BOOL success, NSError * _Nullable error) {
        
        if (indicatorView != nil) {
            
            [self closeIndicatorView];
            NSLog(@"BMI action");
        }
        
        if (success) {
            
            //[self showAlert:@"儲存BMI成功" message:@""];
        }
        else {
            
            [self showAlert:@"Alert" message:@"儲存BMI失敗"];
        }
        
    }];
    
    
}


//身高
-(void)addHeightDataToHealthStore:(double)heightValue {
    
    //[self showIndicatorView];
    
    heightValue = heightValue/100; ///(cm -> m)
    
    ///設定單位:m
    HKUnit *unit = [HKUnit meterUnit];
    
    ///將量測數據與單位綁在一起
    HKQuantity *heightData = [HKQuantity quantityWithUnit:unit doubleValue:heightValue];
    
    ///設定 Health Store 要處理的型態
    HKQuantityType *quantityTypeHeight = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight];
    
    ///取得量測時間 (測試時以目前時間為主)
    NSDate *mesureDate = [NSDate date];
    
    ///設定量測資料及記錄時間
    HKQuantitySample *measureSampleHeight = [HKQuantitySample quantitySampleWithType:quantityTypeHeight quantity:heightData startDate:mesureDate endDate:mesureDate];
    
    ///儲存資料
    [myHealthStore saveObject:measureSampleHeight withCompletion:^(BOOL success, NSError * _Nullable error) {
        
        if (indicatorView != nil) {
            
            [self closeIndicatorView];
        }
        
        if (success) {
            
           // [self showAlert:@"儲存身高成功" message:@""];
        }
        else {
            
            [self showAlert:@"Alert" message:@"儲存身高資料失敗"];
        }
        
    }];

}



//體重
-(void)addWeightDataToHealthStore:(double)weightValue {
    
    weightValue = weightValue*1000; ///(kg -> g)
    
    ///設定單位:g
    HKUnit *unit = [HKUnit gramUnit];
    
    ///將量測數據與單位綁在一起
    HKQuantity *weightData = [HKQuantity quantityWithUnit:unit doubleValue:weightValue];
    
    ///設定 Health Store 要處理的型態
    HKQuantityType *quantityTypeWeight = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
    
    ///取得量測時間 (測試時以目前時間為主)
    NSDate *mesureDate = [NSDate date];
    
    ///設定量測資料及記錄時間
    HKQuantitySample *measureSampleWeight = [HKQuantitySample quantitySampleWithType:quantityTypeWeight quantity:weightData startDate:mesureDate endDate:mesureDate];
    
    ///儲存資料
    [myHealthStore saveObject:measureSampleWeight withCompletion:^(BOOL success, NSError * _Nullable error) {
        
        if (indicatorView != nil) {
            
            [self closeIndicatorView];
        }
        
        if (success) {
            
            //[self showAlert:@"儲存體重成功" message:@""];
        }
        else {
            
            [self showAlert:@"Alert" message:@"儲存體重資料失敗"];
        }
        
    }];
    
}



#pragma mark - show Alert ***************************
-(void)showAlert:(NSString *)title message:(NSString *)message {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"確定" otherButtonTitles: nil];
    [alert show];
    alert = nil;
}


-(void)showIndicatorView {
    
    indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:self.superVC.view.frame];
    [indicatorView setHidesWhenStopped:YES];
    [indicatorView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicatorView.backgroundColor = [UIColor grayColor];
    indicatorView.alpha = 0.8;
    //[self.superVC.tabBarController.view addSubview:indicatorView];
    [self.superVC.view addSubview:indicatorView];
    //[self.superVC.view bringSubviewToFront:indicatorView];
    [indicatorView startAnimating];
}

-(void)closeIndicatorView {
    
    [indicatorView stopAnimating];
    [indicatorView removeFromSuperview];
    indicatorView = nil;
}



@end
