//
//  ProfileViewController.h
//  Setting
//
//  Created by Ideabus on 2016/8/12.
//  Copyright © 2016年 Allen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RiskFactorsViewController.h"

@interface ProfileViewController: UIViewController <UIScrollViewDelegate,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    
#pragma mark - **********  共用  **********
//========================================================
    //UI
    UIScrollView *profileScrollview; ///整個頁面的底層 ScrollView
    UIView *allPickerView_BG ; ///所有 pickerView 的 底層 View
    UIButton *coverView; ///呼叫 pickerView 時會出現遮擋
    UIView *topView; ///所有 PickerView 的 inputAccessoryView
    NSDateFormatter *dateformatter; ///日期
    UILabel *selectdateFormatLabel; ///顯示所指定的日期格式
    
    //數值
    NSString *currentDateString; ///日期字串
    BOOL dateformatBool;
    BOOL thresholdActive;
    
    
    
#pragma mark - **********  ProFile Data  **********
//========================================================
    //UI
    UITextField *nameTextField; ///name TextField
    NSDate *birthday_date;
    UILabel *birthdayLabel; ///birthday Label
    UILabel *heightLabel_cm_value; ///身高 Label
    UILabel *heightLabel_ft_value; ///height Label (ft) 顯示數值
    UILabel *heightLabel_inch_value; ///height Label (inch) 顯示數值
    UILabel *cmLabel; ///cm Label
    UILabel *ftLabel; ///ft Label
    UILabel *inchLabel; ///inch Label
    UILabel *weightLabel; ///體重 Label
    UILabel *kgLabel; ///kg Label
    UILabel *cuffSizeLabel; ///cuffSize Label
    UILabel *measureArmLabel; ///measure Arm Label
    UISegmentedControl *sexSegmentControl; ///性別選擇器
    UISegmentedControl *unitSegmentControl; ///unit 選擇器
    UISegmentedControl *pressureSegmentControl; /// pressure 選擇器
    UITapGestureRecognizer *birtapGestureRecognizer; ///birthDay 點擊手勢

    
    
    //pickerViews
    UIDatePicker *birDatepicker ; ///日期 PickerView
    UIPickerView *heightPickerView_cm; ///身高 PickerView (cm)
    UIPickerView *heightPickerView_ft; ///身高 PickerView (ft)
    UIPickerView *heightPickerView_inch; ///身高 PickerView (inch)
    UIPickerView *weightPickerView; ///體重 PickerView
    UIPickerView  *cuffSizwPickerView; /// 手臂size PickerView
    UIPickerView  *measureArmPickerView; /// 左右手臂
    
    //pickerView data
    NSMutableArray *h_cm_unit;
    NSMutableArray *h_ft_unit;
    NSMutableArray *h_inch_unit;
    NSMutableArray *ary_heightData;
    NSMutableArray *ary_heigh_inchData;
    NSMutableArray *ary_heigh_ftData;
    NSMutableArray *ary_weightData;
    NSMutableArray *w_unit;
    NSMutableArray *ary_cuffSizeData;
    NSMutableArray *ary_measureArmData;
    
    //數值
    int genderBooL;
    BOOL unitBooL;
    BOOL pressureBooL;
    NSInteger cuffsize_row;
    NSInteger measureArm_row;
    int height_value;
    float weight_value;
    NSString *birthdayDate;
    NSString *birthDateString;
    NSString *heightStr_cm;
    NSString *heightStr_ft;
    NSString *heightStr_inch;
    NSString *weightStr;
    NSString *cuffSizeStr;
    NSString *measureArmStr;
    NSString *inch_Str;
    NSString *ft_Str;
    NSString *userName;
    
    
    
#pragma mark - ********** MyGoal Data **********
//========================================================
    //UI
    UILabel *myGoal_systolicPressureLabel; ///systolic Pressure Label
    UILabel *myGoal_diastolicPressurepLabel; ///diastolic Pressurep Label
    UILabel *myGoal_weightLabel; ///weight Label
    UILabel *myGoal_bmiLabel; ///bmi Label
    UILabel *myGoal_bodyfatLabel; ///bodyfat Label
    UILabel *myGoal_systolicPressureUnitLabel; ///mmHg <-> kpa (systolic Pressure Unit Label)
    UILabel *myGoal_diastolicPressureUnitLabel; ///mmHg <-> kpa Label02 (diastolic Pressure Unit Label)
    UILabel *myGoal_kgLabel; ///kg <-> lb Label
    
    //pickerViews
    UIPickerView  *myGoal_weightPickerView; ///體重 PickerView
    UIPickerView  *myGoal_sysPickerView; ///sys PickerView
    UIPickerView  *myGoal_diaPickerView; ///dia PickerView
    UIPickerView  *myGoal_bmiPickerView; ///bmi PickerView
    UIPickerView  *myGoal_bodyfatPickerView; ///body fat PickerView
    
    //pickerView data
    NSMutableArray *ary_myGoal_sysData;
    NSMutableArray *ary_myGoal_diaData;
    NSMutableArray *ary_myGoal_weightData;
    NSMutableArray *ary_myGoal_bmiData;
    NSMutableArray *ary_myGoal_bodyfatData;
    
    //數值
    float sys_pressure_value;
    float dia_pressure_value;
    float goalweight_value;
    float BMI_value;
    float BF_value;
    BOOL sysActive;
    BOOL diaActive;
    BOOL goalWeightActive;
    BOOL BMIActive;
    BOOL bodyFatActive;
    int thresholdCount; //記錄是否是第一次開啟 thres hold
    NSString *myGoal_systolicPressureStr;
    NSString *myGoal_diastolicPressureStr;
    NSString *myGoal_bodyFatStr;
    NSString *myGoal_BMIStr;
    NSString *mtGoal_weightStr;
    
    //-------------    unUsed   ---------------
    NSString *spStr;
    NSString *dpStr;

}

//********** Risk Factors **************
//-=======================================
@property (strong,nonatomic)  UIButton *riskSubTitleBtn;
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



@end
