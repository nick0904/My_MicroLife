//
//  WeightClass.h
//  Microlife
//
//  Created by Rex on 2016/10/6.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import "DataBaseClass.h"

@interface WeightClass : DataBaseClass

@property (nonatomic) int weightID;                     //體脂ID
@property (nonatomic) int accountID;                    //會員ID
@property (nonatomic) float weight;                       //體重

@property (nonatomic) float BMI;                          //身體質量指數
@property (nonatomic) float bodyFat;                      //體脂肪
@property (nonatomic) int water;                        //體水分
@property (nonatomic) int skeleton;                     //骨質量
@property (nonatomic) int muscle;                       //肌肉
@property (nonatomic) int BMR;                          //基礎代謝率
@property (nonatomic) int organFat;                     //內臟脂肪
@property (nonatomic) NSString *date;                   //日期
@property (nonatomic) NSString * weight_PhotoPath;      //筆記照片路徑
@property (nonatomic) NSString * weight_Note;           //筆記內容
@property (nonatomic) NSString * weight_RecordingPath;  //筆記錄音路徑


+(WeightClass*) sharedInstance;

//抓取全部資料
-(NSMutableArray *)selectAllData;

-(NSMutableArray *)selectAllDataAtRange:(int)dataRange count:(int)dataCount;

-(NSMutableArray *)selectData:(NSString *)column range:(int)dataRange count:(int)dataCount;

-(NSMutableArray *)selectSingleDay:(NSString *)column range:(int)dataRange;
-(NSMutableArray *)selectDataForList:(int)dataRange count:(int)dataCount;

-(NSDictionary *)selectWeightAvgValueWithRange:(int)dataRange count:(int)dataCount;

-(void)insertData;
- (void)updateData;
-(void)deleteData;
- (NSString *)getLastDate;
@end
