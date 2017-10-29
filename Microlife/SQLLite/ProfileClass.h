//
//  ProfileClass.h
//  Microlife
//
//  Created by Rex on 2016/10/28.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import "DataBaseClass.h"

@interface ProfileClass : DataBaseClass

//User Profile ****************************
@property (nonatomic, strong) NSString *name;
@property (nonatomic) int userGender;
@property (nonatomic, strong) NSString *birthday;
@property (nonatomic) float userHeight;
@property (nonatomic) float userWeight;
@property (nonatomic) int cuff_size;
@property (nonatomic) int bp_measurement_arm;
@property (nonatomic) int unit_type;
@property (nonatomic) int sys_unit;

//MyGoal ****************************
@property (nonatomic) int sys;
@property (nonatomic) int sys_activity;
@property (nonatomic) int dia;
@property (nonatomic) int dia_activity;
@property (nonatomic) float goal_weight;
@property (nonatomic) int weight_activity;
@property (nonatomic) float bmi;
@property (nonatomic) int bmi_activity;
@property (nonatomic) float body_fat;
@property (nonatomic) int body_fat_activity;
@property (nonatomic) int threshold;
@property (nonatomic, strong) NSString *conditions;
@property (nonatomic) int date_format;

//Risk Factors ************************
@property (nonatomic) int isHypertension;
@property (nonatomic) int isAtrialFibrillation;
@property (nonatomic) int isDiabetes;
@property (nonatomic) int isCardiovascular; ///CVD
@property (nonatomic) int isChronicKindey; ///CKD
@property (nonatomic) int isTransientIschemicAttact;
@property (nonatomic) int isDyslipidemia;
@property (nonatomic) int isSnoringOrSleepAponea;
@property (nonatomic) int isUseOralContraception;///口服避孕藥
@property (nonatomic) int isUseAntiHypertensive;///抗高血壓
@property (nonatomic) int isPregenancy_normoal;
@property (nonatomic) int isPregenancy_preEclampsia;
@property (nonatomic) int isSmoking;
@property (nonatomic) int isAlcoholIntake;

/**
 ------------------------------------
 用戶ID: accountID;
 ------------------------------------
 姓名: name
 ------------------------------------
 性別: userGender; //0 = man 1=women
 ------------------------------------
 生日: birthday;  //預設 今日
 ------------------------------------
 身高: userHeight; //預設 175 cm
 ------------------------------------
 體重: userWeight; //預設 75 kg
 ------------------------------------
 臂圍大小: cuff_size 0(預設值)
 ------------------------------------
 左右手: bp_measurement_arm 0(預設值)
 ------------------------------------
 公英制: unit_type;//0 = KG CM   1=lb
 ------------------------------------
 目標收縮壓單位: sys_unit 0(預設值) 0=mmHg   1=kpa;
 ------------------------------------
 目標收縮壓: sys 135(預設值)
 ------------------------------------
 是否開啟目標收縮壓: sys_activity ; 0(預設值), 0=OFF, 1=ON
 ------------------------------------
 目標舒張壓: dia 85(預設值)
 ------------------------------------
 是否開啟目標舒張壓: dia_activity; 0(預設值), 0=OFF, 1=ON
 ------------------------------------
 目標體重: goal_weight 75(預設值)
 ------------------------------------
 是否開啟目標體重: weight_activity; 0(預設值), 0=OFF, 1=ON
 ------------------------------------
 目標BMI: bmi 23(預設值)
 ------------------------------------
 是否開啟目標: BMI bmi_activity 0(預設值), 0=OFF, 1=ON
 ------------------------------------
 目標體脂: body_fat 20(預設值)
 ------------------------------------
 是否開啟目標體脂: body_fat_activity; 0(預設值), 0=OFF, 1=ON
 ------------------------------------
 正常值: threshold 1(預設值), 0=OFF, 1=ON
 ------------------------------------
 疾病: conditions
 ------------------------------------
 日期格式: date_format  0(預設值) 0 = yyyy/mm/dd  1 = mm/dd/yyyy
 ------------------------------------
 病歷資料: 預設值皆為 0 (0:無, 1:使用者有該症狀)
 
 高血壓:isHypertension
 
 心房顫動:isAtrialFibrillation
 
 糖尿病:isDiabetes
 
 心血管疾病:isCardiovascular
 
 慢性腎臟病:isChronicKindey
 
 貧血:isTransientIschemicAttact
 
 血脂異常:isDyslipidemia
 
 打鼾 或 睡眠呼吸暫停:isSnoringOrSleepAponea
 
 使用口服避孕藥:isUseOralContraception
 
 使用抗高血壓:isUseAntiHypertensive
 
 懷孕(正常):isPregenancy_normoal
 
 懷孕(子癇前症 或 妊娠毒血症):isPregenancy_preEclampsia
 
 抽菸習慣:isSmoking
 
 飲用酒精:isAlcoholIntake
 ------------------------------------
 */



+(ProfileClass*)sharedInstance;
-(NSDictionary *)selectPersonalData;
-(void)updateData;
-(void)insertData;
-(void)deleteData;

@end
