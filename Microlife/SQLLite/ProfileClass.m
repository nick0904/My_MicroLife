//
//  ProfileClass.m
//  Microlife
//
//  Created by Rex on 2016/10/28.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import "ProfileClass.h"

@implementation ProfileClass

@synthesize name,userGender,birthday,userHeight,userWeight,cuff_size,bp_measurement_arm,unit_type,sys_unit,sys,sys_activity,dia,dia_activity,goal_weight,weight_activity,bmi,bmi_activity,body_fat,body_fat_activity,threshold,conditions,date_format;

///Risk Factors
@synthesize isHypertension,isAtrialFibrillation,isDiabetes,isCardiovascular,isChronicKindey,isTransientIschemicAttact,isDyslipidemia,isSnoringOrSleepAponea,isUseOralContraception,isUseAntiHypertensive,isPregenancy_normoal,isPregenancy_preEclampsia,isSmoking,isAlcoholIntake;



+(ProfileClass*)sharedInstance {
    
    static ProfileClass *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        sharedInstance = [[ProfileClass alloc] initWithOpenDataBase];
    });
    
    return sharedInstance;
}


-(id)initWithOpenDataBase{
    
    self = [super initWithOpenDataBase];
    
    if (self) {
        
        [self setUp];
    }
    
    return self;
}


-(void)setUp{
    
    //?
}


-(NSDictionary *)selectPersonalData{
    
    
    NSString *Command = [NSString stringWithFormat:@"SELECT * FROM ProfileList WHERE accountID = %d",[LocalData sharedInstance].accountID];
    
    NSMutableArray* DataArray = [self SELECT:Command Num:37];//SELECT:指令：幾筆欄位
    
    NSDictionary *dataDict;
    
    if ([[DataArray firstObject] count] != 1) {
        
        NSString *accountIDStr = [[DataArray objectAtIndex:0] objectAtIndex:0];
        
        //User ProFile **************************************************
        NSString *nameStr = [[DataArray objectAtIndex:0] objectAtIndex:1];
        
        NSString *userGenderStr = [[DataArray objectAtIndex:0] objectAtIndex:2];
        
        NSString *birthdayStr = [[DataArray objectAtIndex:0] objectAtIndex:3];
        
        NSString * userHeightStr = [[DataArray objectAtIndex:0] objectAtIndex:4];
        
        NSString * userWeightStr = [[DataArray objectAtIndex:0] objectAtIndex:5];
        
        NSString * cuff_sizeStr = [[DataArray objectAtIndex:0] objectAtIndex:6];
        
        NSString * bp_measurement_armStr = [[DataArray objectAtIndex:0] objectAtIndex:7];
        
        NSString * unit_typeStr = [[DataArray objectAtIndex:0] objectAtIndex:8];
        
        NSString * sys_unitStr = [[DataArray objectAtIndex:0] objectAtIndex:9];
        
        
        //MyGoal  **************************************************
        NSString * sysStr = [[DataArray objectAtIndex:0] objectAtIndex:10];
        
        NSString * sys_activityStr = [[DataArray objectAtIndex:0] objectAtIndex:11];
        
        NSString * diaStr = [[DataArray objectAtIndex:0] objectAtIndex:12];
        
        NSString * dia_activityStr = [[DataArray objectAtIndex:0] objectAtIndex:13];
        
        NSString * goal_weightStr = [[DataArray objectAtIndex:0] objectAtIndex:14];
        
        NSString * weight_activityStr = [[DataArray objectAtIndex:0] objectAtIndex:15];
        
        NSString * bmiStr = [[DataArray objectAtIndex:0] objectAtIndex:16];
        
        NSString * bmi_activityStr = [[DataArray objectAtIndex:0] objectAtIndex:17];
        
        NSString * body_fatStr = [[DataArray objectAtIndex:0] objectAtIndex:18];
        
        NSString * body_fat_activityStr = [[DataArray objectAtIndex:0] objectAtIndex:19];
        
        NSString * thresholdStr = [[DataArray objectAtIndex:0] objectAtIndex:20];
        
        NSString *conditionsStr = [[DataArray objectAtIndex:0] objectAtIndex:21];
        
        NSString * date_formatStr = [[DataArray objectAtIndex:0] objectAtIndex:22];
        
        
        //Risk Factors **************************************************
        
        NSString *hypertension = [[DataArray objectAtIndex:0] objectAtIndex:23];
        
        NSString *atrialFibrillation = [[DataArray objectAtIndex:0] objectAtIndex:24];
        
        NSString *diabetes = [[DataArray objectAtIndex:0] objectAtIndex:25];
        
        NSString *cardiovascular = [[DataArray objectAtIndex:0] objectAtIndex:26];
        
        NSString *chronicKindey = [[DataArray objectAtIndex:0] objectAtIndex:27];
        
        NSString *transientIschemicAttact = [[DataArray objectAtIndex:0] objectAtIndex:28];
        
        NSString *dyslipidemia = [[DataArray objectAtIndex:0] objectAtIndex:29];
        
        NSString *snoringOrSleepAponea = [[DataArray objectAtIndex:0] objectAtIndex:30];
        
        NSString *useOralContraception = [[DataArray objectAtIndex:0] objectAtIndex:31];
        
        NSString *useAntiHypertensive = [[DataArray objectAtIndex:0] objectAtIndex:32];
        
        NSString *pregenancy_normoal = [[DataArray objectAtIndex:0] objectAtIndex:33];
        
        NSString *pregenancy_preEclampsia = [[DataArray objectAtIndex:0] objectAtIndex:34];
        
        NSString *smoking = [[DataArray objectAtIndex:0] objectAtIndex:35];
        
        NSString *alcoholIntake = [[DataArray objectAtIndex:0] objectAtIndex:36];
    
        
        dataDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                    accountIDStr,@"accountID",
                    nameStr,@"name",
                    userGenderStr,@"userGender",
                    birthdayStr,@"birthday",
                    userHeightStr,@"userHeight",
                    userWeightStr,@"userWeight",
                    cuff_sizeStr,@"cuff_size",
                    bp_measurement_armStr,@"bp_measurement_arm",
                    unit_typeStr,@"unit_type",
                    sys_unitStr,@"sys_unit",
                    sysStr,@"sys",
                    sys_activityStr,@"sys_activity",
                    diaStr,@"dia",
                    dia_activityStr,@"dia_activity",
                    goal_weightStr,@"goal_weight",
                    weight_activityStr,@"weight_activity",
                    bmiStr,@"bmi",
                    bmi_activityStr,@"bmi_activity",
                    body_fatStr,@"body_fat",
                    body_fat_activityStr,@"body_fat_activity",
                    thresholdStr,@"threshold",
                    conditionsStr,@"conditions",
                    date_formatStr,@"date_format",
                    hypertension,@"isHypertension",
                    atrialFibrillation,@"isAtrialFibrillation",
                    diabetes,@"isDiabetes",
                    cardiovascular,@"isCardiovascular",
                    chronicKindey,@"isChronicKindey",
                    transientIschemicAttact,@"isTransientIschemicAttact",
                    dyslipidemia,@"isDyslipidemia",
                    snoringOrSleepAponea,@"isSnoringOrSleepAponea",
                    useOralContraception,@"isUseOralContraception",
                    useAntiHypertensive,@"isUseAntiHypertensive",
                    pregenancy_normoal,@"isPregenancy_normoal",
                    pregenancy_preEclampsia,@"isPregenancy_preEclampsia",
                    smoking,@"isSmoking",
                    alcoholIntake,@"isAlcoholIntake",
                    nil];

        NSLog(@"dataDict ======>  :%@",dataDict);
        NSLog(@"%@",DataArray);
        
    }
    
    return dataDict;
}

- (void)updateData{
    
    NSString *SQLStr = [NSString stringWithFormat:@"UPDATE ProfileList SET name = \"%@\", userGender = \"%d\",birthday = \"%@\",userHeight = \"%f\",userWeight = \"%f\",cuff_size = \"%d\",bp_measurement_arm = \"%d\", unit_type = \"%d\" ,sys_unit = \"%d\" , sys = \"%d\", sys_activity = \"%d\", dia = \"%d\", dia_activity = \"%d\", goal_weight = \"%f\", weight_activity = \"%d\", bmi = \"%f\", bmi_activity = \"%d\", body_fat = \"%f\", body_fat_activity = \"%d\", threshold = \"%d\", conditions = \"%@\", date_format = \"%d\", isHypertension = \"%d\", isAtrialFibrillation = \"%d\", isDiabetes = \"%d\", isCardiovascular = \"%d\", isChronicKindey = \"%d\", isTransientIschemicAttact = \"%d\", isDyslipidemia = \"%d\", isSnoringOrSleepAponea = \"%d\", isUseOralContraception = \"%d\", isUseAntiHypertensive = \"%d\", isPregenancy_normoal = \"%d\", isPregenancy_preEclampsia = \"%d\", isSmoking = \"%d\", isAlcoholIntake = \"%d\" WHERE accountID = %d", name,userGender,birthday,userHeight,userWeight,cuff_size ,bp_measurement_arm, unit_type, sys_unit,sys,sys_activity,dia,dia_activity,goal_weight,weight_activity,bmi,bmi_activity,body_fat,body_fat_activity,threshold,conditions,date_format,isHypertension,isAtrialFibrillation,isDiabetes,isCardiovascular,isChronicKindey,isTransientIschemicAttact,isDyslipidemia,isSnoringOrSleepAponea,isUseOralContraception,isUseAntiHypertensive,isPregenancy_normoal,isPregenancy_preEclampsia,isSmoking,isAlcoholIntake,
        [LocalData sharedInstance].accountID];
    
    NSLog(@"%@",SQLStr);
    
    [self COLUMN_UPDATE:SQLStr];
    
}

-(void)insertData{
    
    NSString *SQLStr = [NSString stringWithFormat:@"INSERT INTO ProfileList( accountID, name,userGender, birthday, userHeight, userWeight, cuff_size, bp_measurement_arm, unit_type, sys_unit, sys, sys_activity, dia, dia_activity, goal_weight, weight_activity, bmi, bmi_activity, body_fat, body_fat_activity, threshold, conditions, date_format, isHypertension, isAtrialFibrillation, isDiabetes, isCardiovascular, isChronicKindey, isTransientIschemicAttact, isDyslipidemia, isSnoringOrSleepAponea, isUseOralContraception, isUseAntiHypertensive, isPregenancy_normoal, isPregenancy_preEclampsia, isSmoking, isAlcoholIntake) VALUES(  \"%d\",\"%@\",\"%d\", \"%@\", \"%f\", \"%f\", \"%d\", \"%d\", \"%d\", \"%d\", \"%d\", \"%d\", \"%d\", \"%d\", \"%f\", \"%d\", \"%f\", \"%d\", \"%f\", \"%d\", \"%d\", \"%@\", \"%d\", \"%d\", \"%d\", \"%d\", \"%d\", \"%d\", \"%d\", \"%d\", \"%d\", \"%d\", \"%d\", \"%d\", \"%d\", \"%d\", \"%d\");",[LocalData sharedInstance].accountID, name,userGender,birthday,userHeight,userWeight,cuff_size ,bp_measurement_arm, unit_type, sys_unit,sys, sys_activity, dia,dia_activity,goal_weight,weight_activity,bmi, bmi_activity, body_fat,body_fat_activity,threshold,conditions,date_format,isHypertension,isAtrialFibrillation,isDiabetes,isCardiovascular,isChronicKindey,isTransientIschemicAttact,isDyslipidemia,isSnoringOrSleepAponea,isUseOralContraception,isUseAntiHypertensive,isPregenancy_normoal,isPregenancy_preEclampsia,isSmoking,isAlcoholIntake];
    
    [self COLUMN_INSERT:SQLStr];
}


-(void)deleteData {
    
    NSString *sqStr = [NSString stringWithFormat:@"DELETE FROM ProfileList WHERE accountID ='%d';",[LocalData sharedInstance].accountID];
    
    [self COLUMN_DELETE:sqStr];
}

@end







