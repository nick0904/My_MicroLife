//
//  LocalData.m
//  Microlife
//
//  Created by Rex on 2016/9/9.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import "LocalData.h"
#import "AlertConfigClass.h"

@implementation LocalData

@synthesize UserAge,UserHeight,UserWeight,metric,PULUnit,targetSYS,targetDIA,targetWeight,targetFat,measureSpec,userArea,UserGender,standerBMI,standerFat,showTargetDIA,showTargetSYS,showTargetFat,showTargetWeight,targetBMI,showTargetBMI,threshold,cuff_size,bp_measurement_arm,date_format,conditions,name,BPUnit,birthday;

///Risk Factors
@synthesize isHypertension,isAtrialFibrillation,isDiabetes,isCardiovascular,isChronicKindey,isTransientIschemicAttact,isDyslipidemia,isSnoringOrSleepAponea,isUseOralContraception,isUseAntiHypertensive,isPregenancy_normoal,isPregenancy_preEclampsia,isSmoking,isAlcoholIntake;

+(LocalData*) sharedInstance{
    
    static LocalData *sharedInstance;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [LocalData new];
    });
    
    return sharedInstance;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        [self setUp];
    }
    return self;
}

-(void)setUp{
    
    if (reminderDataArray == nil) {
        reminderDataArray = [[NSMutableArray alloc] init];
    }
    
    if (reminderDataArray == nil) {
        reminderDataArray = [[NSMutableArray alloc] init];
    }
    
    if (memberDataArray == nil) {
        memberDataArray = [NSMutableArray new];
    }
    
    if (latestValueDict == nil) {
        latestValueDict = [[NSDictionary alloc] init];
    }
    
    listDataArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    editListDict = [[NSDictionary alloc] init];
    
}


-(void)checkDefaultProfileData{
    
    NSDictionary *personalDict = [[ProfileClass sharedInstance] selectPersonalData];
    
    if (personalDict == nil) {
        
        [ProfileClass sharedInstance].name = @"Name";
        [ProfileClass sharedInstance].birthday = @"1946/01/01";
        [ProfileClass sharedInstance].userGender = 0;
        [ProfileClass sharedInstance].userHeight = 175; //cm
        [ProfileClass sharedInstance].userWeight = 75;  //kg
        [ProfileClass sharedInstance].unit_type = 0;
        [ProfileClass sharedInstance].sys_unit = 0;
        [ProfileClass sharedInstance].sys = 135; //mmHg
        [ProfileClass sharedInstance].sys_activity = 0;
        [ProfileClass sharedInstance].dia = 85; //mmHg
        [ProfileClass sharedInstance].dia_activity = 0;
        [ProfileClass sharedInstance].goal_weight = 75; //kg
        [ProfileClass sharedInstance].weight_activity = 0;
        [ProfileClass sharedInstance].bmi = 23;
        [ProfileClass sharedInstance].bmi_activity = 0;
        [ProfileClass sharedInstance].body_fat = 20;
        [ProfileClass sharedInstance].body_fat_activity = 0;
        [ProfileClass sharedInstance].conditions = @"";
        [ProfileClass sharedInstance].threshold = 1;
        [ProfileClass sharedInstance].cuff_size = 0;
        [ProfileClass sharedInstance].bp_measurement_arm = 0;
        [ProfileClass sharedInstance].date_format = 0;
        
        //Risk Factors
        [ProfileClass sharedInstance].isHypertension = 0;
        [ProfileClass sharedInstance].isAtrialFibrillation = 0;
        [ProfileClass sharedInstance].isDiabetes = 0;
        [ProfileClass sharedInstance].isCardiovascular = 0;
        [ProfileClass sharedInstance].isChronicKindey = 0;
        [ProfileClass sharedInstance].isTransientIschemicAttact = 0;
        [ProfileClass sharedInstance].isDyslipidemia = 0;
        [ProfileClass sharedInstance].isSnoringOrSleepAponea = 0;
        [ProfileClass sharedInstance].isUseOralContraception = 0;
        [ProfileClass sharedInstance].isUseAntiHypertensive = 0;
        [ProfileClass sharedInstance].isPregenancy_normoal = 0;
        [ProfileClass sharedInstance].isPregenancy_preEclampsia = 0;
        [ProfileClass sharedInstance].isSmoking = 0;
        [ProfileClass sharedInstance].isAlcoholIntake = 0;
        
        
        //資料庫新增資料
        [[ProfileClass sharedInstance] insertData];
    }

    //資料庫新增資料後再撈一次資料
    personalDict = [[ProfileClass sharedInstance] selectPersonalData];
    
    //基本資料
    PULUnit = 0;//0=bpm   1=beats;
    measureSpec = 2;
    UserAge = -1;
    name = [personalDict objectForKey:@"name"];
    UserGender = [[personalDict objectForKey:@"userGender"] intValue];
    birthday = [personalDict objectForKey:@"birthday"];
    UserHeight = [[personalDict objectForKey:@"userHeight"] floatValue];
    UserWeight = [[personalDict objectForKey:@"userWeight"] floatValue];
    metric = [[personalDict objectForKey:@"unit_type"] intValue];
    BPUnit = [[personalDict objectForKey:@"sys_unit"] intValue];
    
    
    targetSYS = [[personalDict objectForKey:@"sys"] intValue];
    targetDIA = [[personalDict objectForKey:@"dia"] intValue];
    targetWeight = [[personalDict objectForKey:@"goal_weight"] floatValue];
    targetBMI =  [[personalDict objectForKey:@"bmi"] floatValue];
    targetFat = [[personalDict objectForKey:@"body_fat"] floatValue];
    userArea = 0;
    showTargetSYS = [[personalDict objectForKey:@"sys_activity"] floatValue];
    showTargetDIA = [[personalDict objectForKey:@"dia_activity"] floatValue];
    showTargetWeight = [[personalDict objectForKey:@"weight_activity"] floatValue];
    showTargetBMI = [[personalDict objectForKey:@"bmi_activity"] floatValue];
    showTargetFat = [[personalDict objectForKey:@"body_fat_activity"] floatValue];
    
    
    conditions = [personalDict objectForKey:@"conditions"];
    threshold = [[personalDict objectForKey:@"threshold"] intValue];
    cuff_size = [[personalDict objectForKey:@"cuff_size"] intValue];
    bp_measurement_arm = [[personalDict objectForKey:@"bp_measurement_arm"] intValue];
    date_format = [[personalDict objectForKey:@"date_format"] intValue];

    
    
    //Risk Factors
    isHypertension = [[personalDict objectForKey:@"isHypertension"] intValue];
    isAtrialFibrillation = [[personalDict objectForKey:@"isAtrialFibrillation"] intValue];
    isDiabetes = [[personalDict objectForKey:@"isDiabetes"] intValue];
    isCardiovascular = [[personalDict objectForKey:@"isCardiovascular"] intValue];
    isChronicKindey = [[personalDict objectForKey:@"isChronicKindey"] intValue];
    isTransientIschemicAttact = [[personalDict objectForKey:@"isTransientIschemicAttact"] intValue];
    isDyslipidemia = [[personalDict objectForKey:@"isDyslipidemia"] intValue];
    isSnoringOrSleepAponea = [[personalDict objectForKey:@"isSnoringOrSleepAponea"] intValue];
    isUseOralContraception = [[personalDict objectForKey:@"isUseOralContraception"] intValue];
    isUseAntiHypertensive = [[personalDict objectForKey:@"isUseAntiHypertensive"] intValue];
    isPregenancy_normoal = [[personalDict objectForKey:@"isPregenancy_normoal"] intValue];
    isPregenancy_preEclampsia = [[personalDict objectForKey:@"isPregenancy_preEclampsia"] intValue];
    isSmoking = [[personalDict objectForKey:@"isSmoking"] intValue];
    isAlcoholIntake = [[personalDict objectForKey:@"isAlcoholIntake"] intValue];
    
    
    
    
    if (userArea == 0) {
        
        standerBMI = 23;
    }
    else{
        
        standerBMI = 25;
    }
    
    
    
    if (UserGender == 0) {
        
        standerFat = 25;
    }
    else{
        
        standerBMI = 31;
    }
    
    //目前選擇的溫度計事件 -1為無新增使用者
    self.currentEventId = -1;
    
}

-(NSMutableArray*)saveReminderData:(NSMutableArray *)dataArray{
    
   // NSMutableArray *tempArray = dataArray;
    
    for (int i=0; i<dataArray.count; i++) {
        
        for (NSUInteger j = dataArray.count-1; j>0; j--) {
            
            NSMutableDictionary *tempDictA = dataArray[j];
            NSMutableDictionary *tempDictB = dataArray[j-1];
            
            int biggerHour = [[dataArray[j] objectForKey:@"hour"] intValue];
            int smallerHour = [[dataArray[j-1]objectForKey:@"hour"] intValue];
            if (biggerHour < smallerHour) {
                
                [dataArray removeObjectAtIndex:j-1];
                [dataArray insertObject:tempDictA atIndex:j-1];
                
                [dataArray removeObjectAtIndex:j];
                [dataArray insertObject:tempDictB atIndex:j];
                
            }else if (biggerHour == smallerHour) {
                
                int biggerMin = [[dataArray[j] objectForKey:@"min"] intValue];
                int smallerMin = [[dataArray[j-1]objectForKey:@"min"] intValue];
                
                if (biggerMin < smallerMin) {
                    
                    [dataArray removeObjectAtIndex:j-1];
                    [dataArray insertObject:tempDictA atIndex:j-1];
                    
                    [dataArray removeObjectAtIndex:j];
                    [dataArray insertObject:tempDictB atIndex:j];
                }
                
            }
        }
    }
        
    reminderDataArray = dataArray;
    
    return reminderDataArray;
    
}

-(NSMutableArray *)getReminderData{
    
    NSMutableArray *reminderArr=[[NSMutableArray alloc]init];
    
    AlertConfigClass *alertConfigClass=[[AlertConfigClass alloc]init];
    
    [alertConfigClass getUserAlertConfig:[LocalData sharedInstance].accountID];
    
    [alertConfigClass closeDatabase];
    
    
    
    NSLog(@"ALERT_ID:%d",alertConfigClass.ALERT_ID);
    NSLog(@"accountID:%d",alertConfigClass.accountID);
    NSLog(@"alertConfig:%@",alertConfigClass.alertConfig);
    
    if(alertConfigClass.alertConfig) {
        
        reminderArr=[ShareCommon JsonToDictionary:alertConfigClass.alertConfig];
        
        if(!reminderArr){
            
            reminderArr=[[NSMutableArray alloc]init];
        }
        else{
            
//            [alertConfigClass PushLoacaleMessage:reminderArr];
        }
    }
    
    return reminderArr;
    
}

-(void)saveMemberProfile:(NSDictionary *)memberDict{
    
    [memberDataArray addObject:memberDict];
    NSLog(@"local memberDataArray = %@",memberDataArray);
}

-(void)editMemberProfile:(NSDictionary *)memberDict atIndexPath:(int)index{
    [memberDataArray replaceObjectAtIndex:index withObject:memberDict];
}

-(NSMutableArray *)returnMemberProfile{
    
    return memberDataArray;
}

-(void)saveLatestMeasureValue:(NSDictionary *)latestValue{
    latestValueDict = latestValue;
}

-(NSDictionary *)getLatestMeasureValue{
    
    return latestValueDict;
}

-(void)setListDataArray:(NSMutableArray *)listArray{
    listDataArray = listArray;
}

-(NSMutableArray *)getListData{
    return listDataArray;
}

-(void)setEditListDict:(NSDictionary *)dataDict{
    editListDict = dataDict;
}

-(NSDictionary *)getEditListDict{
    return editListDict;
}



@end
