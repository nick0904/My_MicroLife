//
//  ChartView.m
//  Microlife
//
//  Created by 曾偉亮 on 2017/1/23.
//  Copyright © 2017年 Rex. All rights reserved.
//

#import "ChartView.h"
#define SCREEN_BOUNDS [UIScreen mainScreen].bounds
@interface ChartView() {
    
    UIView  *indicatorLine;
    UILabel *indicatorDate;
    UILabel *indicatorUnit;
    UILabel *valueLabel;
    
    
    float chartTopWidth;
    float chartLeftWidth;
    float chartBottomWidth;
    float chartRightWidth;
    
    
    float chartMaxValue;
    float chartMinValue;
    
    
    int targetValCount;
    
    
    //主線條提示圖片大小
    float lineIntroImg_w;
    float lineIntroImg_h;
    
    //目標值提示圖片大小
    float targetIntroImg_w;
    float targetIntroImg_h;
    NSString *unitStr;
    NSString *lineIntroStr;
    NSString *indicatorUnitStr;
    NSString *targetIntroStr;
    UIImage *targetImg;
    UIImage *mainlineIntroImg;
    NSString *normalIntroStr;
    UIImage *normalImg;

    NSMutableArray *secGraphYData;
    NSMutableArray *dateArray;
    
    BOOL showSingleDay;
    
    BOOL firstPoint;
    BOOL secFirstPoint;
    

    
}

@end





@implementation ChartView

#pragma mark - initalization  *************************
-(id)initWithFrame:(CGRect)frame withChartType:(int)type withDataCount:(int)count withDataRange:(NSInteger)range {
    
    self = [super initWithFrame:frame];
    
    if (!self) return nil;
    
    self.chartType = type;
    dataCount = count;
    dataRange = range;
    firstPoint = YES;
    secFirstPoint = YES;
    [self initParameter];
    [self initInterface];
    
    return self;
}

-(void)initParameter {
    
    if (IS_IPHONE_5) {
        
        imgScale = 2.0;
    }
    else if (IS_IPHONE_6) {
        
        imgScale = 2.0;
    }
    else if (IS_IPHONE_6P) {
        
        imgScale = 1.75;
    }
    else {
        
        imgScale = 2.5;
    }
    
    self.chartDataArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    self.indicatorMode = NO;
    showSingleDay = NO;
    targetValCount = 0;
    self.targetValue = 0;
    self.secTargetValue = 0;
    dataXLength = 0;
    secGraphYData = [[NSMutableArray alloc] initWithCapacity:0];
    dateArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    NSMutableArray *selectDataAry = [[NSMutableArray alloc] initWithCapacity:0];
    
    switch (self.chartType) {
        case 0:
            //SYS/DIA
            [self.chartDataArray removeAllObjects];
            [secGraphYData removeAllObjects];
            
            if (dataCount == -1) {
                
                int range_int = [self getIntValueFromInteger:dataRange];
                selectDataAry = [[BPMClass sharedInstance] selectSingleDayBPWithRange:range_int];
            }
            else {
                
                int range_int = [self getIntValueFromInteger:dataRange];
                selectDataAry = [[BPMClass sharedInstance] selectBPWithRange:range_int count:dataCount];
            }
            
            //血壓最大最小值量測範圍值
            float maxValue = 280;
            float minValue = 20;
            
            for (int i = 0; i<selectDataAry.count; i++) {
                
                NSNumber *sysNum = [NSNumber numberWithInt:[[[selectDataAry objectAtIndex:i] objectForKey:@"SYS"] intValue]];
                
                NSNumber *diaNum = [NSNumber numberWithInt:[[[selectDataAry objectAtIndex:i] objectForKey:@"DIA"] intValue]];
                
                if (sysNum.intValue != 0 && diaNum.intValue != 0) {
                    
                    if (sysNum.intValue < maxValue) {
                        
                        maxValue = sysNum.intValue;
                    }
                    
                    if (diaNum.intValue > minValue) {
                        
                        minValue = diaNum.intValue;
                    }
                    
                    [self.chartDataArray addObject:[[selectDataAry objectAtIndex:i] objectForKey:@"SYS"]];
                    [secGraphYData addObject:[[selectDataAry objectAtIndex:i] objectForKey:@"DIA"]];
                    [dateArray addObject:[[selectDataAry objectAtIndex:i] objectForKey:@"date"]];
                    
                }
                
                chartMaxValue = maxValue;
                chartMinValue = minValue;
                self.normalValue = 135;
                self.secNormalValue = 85;
                self.targetValue = [LocalData sharedInstance].targetSYS;
                self.secTargetValue = [LocalData sharedInstance].targetDIA;
                
                if (chartMinValue > self.secTargetValue) {
                    
                    chartMinValue = self.secTargetValue;
                }
                
                if (chartMaxValue < self.targetValue) {
                    
                    chartMaxValue = self.targetValue;
                }
                
                if (![LocalData sharedInstance].showTargetSYS) {
                    
                    self.targetValue = 0;
                }
                
                if (![LocalData sharedInstance].showTargetDIA) {
                    
                    self.secTargetValue = 0;
                }
                
            }
            break;
        case 1: {
            //PUL
            [self.chartDataArray removeAllObjects];
            
            if (dataCount == -1) {
                
                int range_int = [self getIntValueFromInteger:dataRange];
                selectDataAry = [[BPMClass sharedInstance] selectSingleDayPULWithRange:range_int];
            }
            else {
                
                int range_int = [self getIntValueFromInteger:dataRange];
                selectDataAry = [[BPMClass sharedInstance] selectPULWithRange:range_int count:dataCount];
            }
            
            for (int i = 0; i < selectDataAry.count; i++) {
                
                [self.chartDataArray addObject:[[selectDataAry objectAtIndex:i] objectForKey:@"PUL"]];
                [dateArray addObject:[[selectDataAry objectAtIndex:i] objectForKey:@"date"]];
            }
            
            //心律最大最小量測範圍值
            chartMaxValue = 200;
            chartMinValue = 40;
            self.targetValue = 75;
        }
            break;
        case 2: {
            //Weight
            [self.chartDataArray removeAllObjects];
            
            if (dataCount == -1) {
                
                int range_int = [self getIntValueFromInteger:dataRange];
                selectDataAry = [[WeightClass sharedInstance] selectSingleDay:@"weight" range:range_int];
            }
            else {
                
                int range_int = [self getIntValueFromInteger:dataRange];
                selectDataAry = [[WeightClass sharedInstance] selectData:@"weight" range:range_int count:dataCount];
            }
            
            for (int i = 0; i<selectDataAry.count; i++) {
                
                [self.chartDataArray addObject:[[selectDataAry objectAtIndex:i] objectForKey:@"weight"]];
                [dateArray addObject:[[selectDataAry objectAtIndex:i] objectForKey:@"date"]];
                
            }
            
            //體重最大最小量測範圍值
            chartMaxValue = 150.0;
            chartMinValue = 5.0;
            
            self.targetValue = [LocalData sharedInstance].targetWeight;
            
            if(chartMaxValue < self.targetValue) {
                
                chartMaxValue = self.targetValue;
            }
            
            if (![LocalData sharedInstance].showTargetWeight) {
                
                self.targetValue = 0;
            }

        }
            break;
        case 3: {
            //BMI
            [self.chartDataArray removeAllObjects];
            
            if (dataCount == -1) {
                
                int range_int = [self getIntValueFromInteger:dataRange];
                selectDataAry = [[WeightClass sharedInstance] selectSingleDay:@"BMI" range:range_int];
            }
            else {
                
                int range_int = [self getIntValueFromInteger:dataRange];
                selectDataAry = [[WeightClass sharedInstance] selectData:@"BNI" range:range_int count:dataCount];
            }
            
            for (int i = 0; i<selectDataAry.count; i++) {
                
                [self.chartDataArray addObject:[[selectDataAry objectAtIndex:i] objectForKey:@"BMI"]];
                [dateArray addObject:[[selectDataAry objectAtIndex:i] objectForKey:@"date"]];
            }
            
            //BMI最大最小量測範圍值
            chartMaxValue = 90;
            chartMinValue = 10;
            
            self.normalValue = [LocalData sharedInstance].standerBMI;
            
            if(chartMinValue > self.normalValue) {
                
                chartMinValue = self.normalValue;
            }
        }
            break;
        case 4: {
            //BODY FAT
            [self.chartDataArray removeAllObjects];
            
            if (dataCount == -1) {
                
                int range_int = [self getIntValueFromInteger:dataRange];
                selectDataAry = [[WeightClass sharedInstance] selectSingleDay:@"bodyFat" range:range_int];
            }
            else {
                
                int range_int = [self getIntValueFromInteger:dataRange];
                selectDataAry = [[WeightClass sharedInstance] selectData:@"bodyFat" range:range_int count:dataCount];
            }
            
            for (int i = 0; i<selectDataAry.count; i++) {
                [self.chartDataArray addObject:[[selectDataAry objectAtIndex:i] objectForKey:@"bodyFat"]];
                [dateArray addObject:[[selectDataAry objectAtIndex:i] objectForKey:@"date"]];
            }
            
            //BODY FAT最大最小量測範圍值
            chartMaxValue = 60;
            chartMinValue = 5;
            
            self.normalValue = [LocalData sharedInstance].standerFat;
            self.targetValue = [LocalData sharedInstance].targetFat;
            
            if (![LocalData sharedInstance].showTargetFat) {
                self.targetValue = 0;
            }
            
            if(chartMinValue > self.normalValue) {
                
                chartMinValue = self.normalValue;
            }
            
            if(chartMaxValue < self.targetValue) {
                
                chartMaxValue = self.targetValue;
            }

        }
            break;
        case 5: {
            //temperature
            [self.chartDataArray removeAllObjects];
            [secGraphYData removeAllObjects];
            
            if (dataCount == -1) {
                
                int range_int = [self getIntValueFromInteger:dataRange];
                selectDataAry = [[BTClass sharedInstance] selectSingleHourTempWithRange:range_int];
            }
            else {
                
                int range_int = [self getIntValueFromInteger:dataRange];
                selectDataAry = [[BTClass sharedInstance] selectTempWithRange:range_int count:dataCount];
                
            }
            
            //體溫最大最小量測範圍值
            chartMaxValue = 42.0;
            chartMinValue = 25.0;
            self.normalValue = 37.5;
            
        }
            break;
        default:
            break;
    }
    
    
    if(dataCount == -1){
        
        showSingleDay = YES;
    }
    
    dataCount = [self getIntValueFromInteger:selectDataAry.count];
    
    //計算資料範圍值
    dataXLength = dataCount;
    dataYLength = chartMaxValue-chartMinValue;
}

-(void)initInterface {
    
    self.backgroundColor = [UIColor whiteColor];
    
    //主線條提示圖片大小
    lineIntroImg_w = 22/imgScale;
    lineIntroImg_h = 10/imgScale;
    
    //目標值提示圖片大小
    targetIntroImg_w = 22/imgScale;
    targetIntroImg_h = 5/imgScale;
    normalImg = [UIImage imageNamed:@"overview_chart_a_normal"];
    normalIntroStr = NSLocalizedString(@"NormalLine", nil);
    
    switch (self.chartType) {
        case 0:
            //SYS/DIA
            unitStr = @"mmHg";
            lineIntroStr = NSLocalizedString(@"SYS/DIA", nil);
            targetIntroStr = NSLocalizedString(@"Target", nil);
            indicatorUnitStr = @"mmHg";
            targetImg = [UIImage imageNamed:@"overview_chart_a_target"];
            mainlineIntroImg = [UIImage imageNamed:@"overview_chart_a_pul"];
            lineIntroImg_w = 22/imgScale;
            lineIntroImg_h = 10/imgScale;
            targetIntroImg_w = 22/imgScale;
            targetIntroImg_h = 5/imgScale;
            break;
        case 1:
            //PUL
            unitStr = @"bpm";
            lineIntroStr = NSLocalizedString(@"PUL", nil);
            targetIntroStr = @"";
            indicatorUnitStr = @"bpm";
            targetImg = nil;
            normalIntroStr = @"";
            normalImg = nil;
            mainlineIntroImg = [UIImage imageNamed:@"overview_chart_a_pul"];
            lineIntroImg_w = 22/imgScale;
            lineIntroImg_h = 10/imgScale;
            targetIntroImg_w = 0;
            targetIntroImg_h = 0;
            break;
        case 2:
            //weight
            unitStr = @"kg";
            lineIntroStr = NSLocalizedString(@"Weight", nil);
            targetIntroStr = NSLocalizedString(@"Target", nil);
            indicatorUnitStr = @"kg";
            targetImg = [UIImage imageNamed:@"overview_chart_a_target"];
            mainlineIntroImg = [UIImage imageNamed:@"overview_chart_a_pul"];
            lineIntroImg_w = 22/imgScale;
            lineIntroImg_h = 10/imgScale;
            targetIntroImg_w = 22/imgScale;
            targetIntroImg_h = 5/imgScale;
            break;
        case 3:
            //BMI
            unitStr = @"";
            lineIntroStr = NSLocalizedString(@"BMI", nil);
            targetIntroStr = NSLocalizedString(@"Target", nil);
            indicatorUnitStr = @"";
            targetImg = [UIImage imageNamed:@"overview_chart_a_target"];
            mainlineIntroImg = [UIImage imageNamed:@"overview_chart_a_pul"];
            lineIntroImg_w = 22/imgScale;
            lineIntroImg_h = 10/imgScale;
            targetIntroImg_w = 22/imgScale;
            targetIntroImg_h = 5/imgScale;
            break;
        case 4:
            //BODY FAT
            unitStr = @"%";
            lineIntroStr = NSLocalizedString(@"FAT", nil);
            targetIntroStr = NSLocalizedString(@"Target", nil);
            indicatorUnitStr = @"%";
            targetImg = [UIImage imageNamed:@"overview_chart_a_target"];
            mainlineIntroImg = [UIImage imageNamed:@"overview_chart_a_pul"];
            lineIntroImg_w = 22/imgScale;
            lineIntroImg_h = 10/imgScale;
            targetIntroImg_w = 22/imgScale;
            targetIntroImg_h = 5/imgScale;
            break;
        case 5:
            //temperature
            unitStr = @"°C";
            targetIntroStr = NSLocalizedString(@"Body Temp.", nil);
            lineIntroStr = NSLocalizedString(@"Room Temp.", nil);
            indicatorUnitStr = @"°C";
            targetImg = [UIImage imageNamed:@"overview_chart_a_pul"];
            mainlineIntroImg = [UIImage imageNamed:@"overview_chart_a_roomtemp"];
            lineIntroImg_w = 22/imgScale;
            lineIntroImg_h = 5/imgScale;
            targetIntroImg_w = 22/imgScale;
            targetIntroImg_h = 10/imgScale;
            break;
        default:
            break;
    }
    
    //圖表上方單位
    self.graphUnitLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 2, SCREEN_WIDTH*0.086, SCREEN_HEIGHT*0.044)];
    self.graphUnitLabel.text = unitStr;
    self.graphUnitLabel.font = [UIFont systemFontOfSize:10.0];
    self.graphUnitLabel.textColor = [UIColor colorWithRed:157.0/255.0 green:157.0/255.0 blue:157.0/255.0 alpha:1.0];
    [self.graphUnitLabel sizeToFit];
    [self addSubview:self.graphUnitLabel];
    
    
    //上方主線條提示文字
    self.lineIntroLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.lineIntroLabel.font = [UIFont systemFontOfSize:12.0];
    self.lineIntroLabel.text = lineIntroStr;
    self.lineIntroLabel.textAlignment = NSTextAlignmentRight;
    [self.lineIntroLabel sizeToFit];
    self.lineIntroLabel.frame = CGRectMake(SCREEN_WIDTH-SCREEN_WIDTH*0.04-self.lineIntroLabel.frame.size.width, SCREEN_HEIGHT*0.044/2-self.lineIntroLabel.frame.size.height/2, self.lineIntroLabel.frame.size.width, self.lineIntroLabel.frame.size.height);
    [self addSubview:self.lineIntroLabel];
    
    
    //上方主線條提示文字圖片
    self.lineIntroImg = [[UIImageView alloc] initWithFrame:CGRectMake(self.lineIntroLabel.frame.origin.x-lineIntroImg_w-4, self.lineIntroLabel.frame.origin.y+self.lineIntroLabel.frame.size.height/2-lineIntroImg_h/2, lineIntroImg_w, lineIntroImg_h)];
    self.lineIntroImg.image = mainlineIntroImg;
    [self addSubview:self.lineIntroImg];
    
    
    //上方目標值提示文字
    self.targetIntroLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.targetIntroLabel.text = targetIntroStr;
    self.targetIntroLabel.font = [UIFont systemFontOfSize:12.0];
    [self.targetIntroLabel sizeToFit];
    self.targetIntroLabel.frame = CGRectMake(self.lineIntroImg.frame.origin.x-self.targetIntroLabel.frame.size.width-4, SCREEN_HEIGHT*0.044/2-self.targetIntroLabel.frame.size.height/2, self.targetIntroLabel.frame.size.width, self.targetIntroLabel.frame.size.height);
    [self addSubview:self.targetIntroLabel];
    
    
    //目標值提示圖片
    self.targetIntroImg = [[UIImageView alloc] initWithFrame:CGRectMake(self.targetIntroLabel.frame.origin.x-targetIntroImg_w-4, self.targetIntroLabel.frame.origin.y+self.targetIntroLabel.frame.size.height/2-targetIntroImg_h/2, targetIntroImg_w, targetIntroImg_h)];
    self.targetIntroImg.image = targetImg;
    [self addSubview:self.targetIntroImg];
    
    
    //上方正常值提示文字
    UILabel *normalIntro = [[UILabel alloc] initWithFrame:CGRectZero];
    normalIntro.text = normalIntroStr;
    normalIntro.font = [UIFont systemFontOfSize:12.0];
    [normalIntro sizeToFit];
    normalIntro.frame = CGRectMake(self.targetIntroImg.frame.origin.x-normalIntro.frame.size.width-4, SCREEN_HEIGHT*0.044/2-normalIntro.frame.size.height/2, normalIntro.frame.size.width, normalIntro.frame.size.height);
    [self addSubview:normalIntro];
    
    
    //正常值提示圖片
    float normalIntroImg_w = 10/imgScale;
    float normalIntroImg_h = 13/imgScale;
    self.normalIntroImg = [[UIImageView alloc] initWithFrame:CGRectMake(normalIntro.frame.origin.x-normalIntroImg_w-4, normalIntro.frame.origin.y+normalIntro.frame.size.height/2-normalIntroImg_h/2, normalIntroImg_w, normalIntroImg_h)];
    self.normalIntroImg.image = normalImg;
    [self addSubview:self.normalIntroImg];

    
    //圖表上方線條
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(self.graphUnitLabel.frame.origin.x+self.graphUnitLabel.frame.size.width, SCREEN_HEIGHT*0.044, SCREEN_WIDTH-SCREEN_WIDTH*0.05-self.graphUnitLabel.frame.size.width, 1)];
    topLine.backgroundColor = [UIColor colorWithRed:157.0/255.0 green:157.0/255.0 blue:157.0/255.0 alpha:0.8];
    [self addSubview:topLine];
    
    
    //圖表下方線條
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(self.graphUnitLabel.frame.origin.x+self.graphUnitLabel.frame.size.width, self.frame.size.height-SCREEN_HEIGHT*0.044, SCREEN_WIDTH-SCREEN_WIDTH*0.05-self.graphUnitLabel.frame.size.width, 1)];
    bottomLine.backgroundColor = [UIColor colorWithRed:157.0/255.0 green:157.0/255.0 blue:157.0/255.0 alpha:0.8];
    [self addSubview:bottomLine];

    
    //開始時間
    self.startTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.graphUnitLabel.bounds.origin.x+2, bottomLine.frame.origin.y+SCREEN_HEIGHT*0.022, self.startTimeLabel.frame.size.width, self.startTimeLabel.frame.size.height)];
    self.startTimeLabel.text = @"";
    self.startTimeLabel.font = [UIFont systemFontOfSize:12.0];
    [self addSubview:self.startTimeLabel];
    
    //結束時間
    self.endTimeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.endTimeLabel.text = @"";
    self.endTimeLabel.font = [UIFont systemFontOfSize:12.0];
    [self.endTimeLabel sizeToFit];
    self.endTimeLabel.frame = CGRectMake(bottomLine.frame.origin.x+bottomLine.frame.size.width-self.endTimeLabel.frame.size.width, bottomLine.frame.origin.y+SCREEN_HEIGHT*0.022, self.endTimeLabel.frame.size.width, self.endTimeLabel.frame.size.height);
    [self addSubview:self.endTimeLabel];
    
    //結束圖片
    float endImgWidth = 15/imgScale;
    float endImgHeight = 13/imgScale;
    UIImageView *endTimeImg = [[UIImageView alloc] initWithFrame:CGRectMake(bottomLine.frame.origin.x+bottomLine.frame.size.width-endImgWidth/2, bottomLine.frame.origin.y+5, endImgWidth, endImgHeight)];
    endTimeImg.image = [UIImage imageNamed:@"overview_chart_a_indicato"];
    [self addSubview:endTimeImg];
    
    
    chartTopWidth = 30;//SCREEN_HEIGHT*0.044;
    chartLeftWidth = self.graphUnitLabel.frame.origin.x+self.graphUnitLabel.frame.size.width;
    chartBottomWidth = chartTopWidth;//SCREEN_HEIGHT*0.044;
    chartRightWidth = SCREEN_WIDTH*0.04;
    
    
    //MARK:計算比例
    xScaleSize = (self.frame.size.width-chartLeftWidth-chartRightWidth)/dataXLength;
    yScaleSize = (self.frame.size.height-chartTopWidth-chartBottomWidth)/dataYLength;
    NSLog(@"xScaleSize:");
    

    //圖表綠色指標線
    indicatorLine = [[UIView alloc] initWithFrame:CGRectMake(chartLeftWidth,chartTopWidth , 1, self.frame.size.height-chartTopWidth*2)];
    indicatorLine.backgroundColor = [UIColor colorWithRed:12.0/255.0 green:165.0/255.0 blue:0.0/255.0 alpha:0.5];
     [indicatorLine setHidden:YES];
    [self addSubview:indicatorLine];
   

    float indicatorViewWidth = 283/imgScale;
    float indicatorViewHeight = 86/imgScale;
    UIImageView *indicatorView = [[UIImageView alloc] initWithFrame:CGRectMake(-indicatorViewWidth/2+1, -indicatorViewHeight+3, indicatorViewWidth, indicatorViewHeight)];
    indicatorView.image = [UIImage imageNamed:@"history_ui_a_bpm"];
    [indicatorLine addSubview:indicatorView];
    

    //標示線圖示顯示值
    valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.frame.size.width*0.146, indicatorView.frame.size.height-3)];
    
    valueLabel.textColor = [UIColor whiteColor];
    valueLabel.text = @"";
    valueLabel.font = [UIFont systemFontOfSize:16.0];
    valueLabel.textAlignment = NSTextAlignmentCenter;
    
    [indicatorView addSubview:valueLabel];
    
    indicatorUnit = [[UILabel alloc] initWithFrame:CGRectMake(valueLabel.frame.origin.x+valueLabel.frame.size.width, valueLabel.frame.origin.y+2, self.frame.size.width*0.08, indicatorView.frame.size.height-2)];
    
    indicatorUnit.textColor = [UIColor whiteColor];
    indicatorUnit.text = indicatorUnitStr;
    indicatorUnit.font = [UIFont systemFontOfSize:8.0];
    
    [indicatorView addSubview:indicatorUnit];
    
    //indicatorUnit.frame.origin.x+indicatorUnit.frame.size.width
    
    indicatorDate = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width*0.26, indicatorUnit.frame.origin.y-4, self.frame.size.width*0.093, indicatorView.frame.size.height-2)];
    
    indicatorDate.textAlignment = NSTextAlignmentCenter;
    indicatorDate.textColor = [UIColor whiteColor];
    indicatorDate.text = @"";
    indicatorDate.font = [UIFont systemFontOfSize:11.0];
    
    [indicatorView addSubview:indicatorDate];
    
    [self setTagValue];
    
    if (dateArray.count != 0) {
        self.startTimeLabel.text = [NSString stringWithFormat:@"%@",[dateArray firstObject]];
        self.endTimeLabel.text = [NSString stringWithFormat:@"%@",[dateArray lastObject]];
    }
    
    [self.startTimeLabel sizeToFit];
    [self.endTimeLabel sizeToFit];
    
    //startTimeLabel.frame = CGRectMake(startTimeLabel.frame.origin.x-startTimeLabel.frame.size.width/2, startTimeLabel.frame.origin.y, startTimeLabel.frame.size.width, startTimeLabel.frame.size.height);
    
    self.endTimeLabel.frame = CGRectMake(self.endTimeLabel.frame.origin.x-self.endTimeLabel.frame.size.width, self.endTimeLabel.frame.origin.y, self.endTimeLabel.frame.size.width, self.endTimeLabel.frame.size.height);
    
    //[self setClipsToBounds:YES];
    //[self.layer setBorderWidth:1];
    //[self.layer setBorderColor:[[UIColor redColor] CGColor]];



    
}



#pragma mark - set Value  ***********************************
-(void)setTagValue {
     /**
     YES: create normal value tag
     NO: target value
    */
    
    switch (self.chartType) {
        case 0:
            //SYS/DIA
            [self createValueTag:self.targetValue normal:NO];
            [self createValueTag:self.secTargetValue normal:NO];
            [self createValueTag:self.normalValue normal:YES];
            [self createValueTag:self.secNormalValue normal:YES];
            break;
        case 1:
            //PUL
            [self createValueTag:0 normal:YES];
            [self createValueTag:0 normal:YES];
            break;
        case 2:
            //Weight
            [self createValueTag:self.targetValue normal:NO];
            [self createValueTag:self.normalValue normal:YES];
            break;
        case 3:
            //BMI
            //亞洲區：23
            //非亞洲區：25
            //[self createValueTag:targetValue normal:NO];
            [self createValueTag:self.normalValue normal:YES];
            break;
        case 4:
            //BODY FAT
            //男性：24%
            //女性：31%
            [self createValueTag:self.targetValue normal:NO];
            [self createValueTag:self.normalValue normal:YES];
            break;
        case 5:
            [self createValueTag:self.normalValue normal:YES];
            break;
        default:
            break;
    }
    
}


-(void)createValueTag:(float)tagValue normal:(BOOL)normalTag{

    float tagWidth = 55/imgScale;
    float tagHeight = 25/imgScale;
    
    UIImageView *tagValueImgView;
    UIImageView *triangleImgView;
    UILabel *tagValueLabel;
    UIImage *tagImg;
   
    if (tagValue == 0) {
        return;
    }
    
    tagValueImgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, chartTopWidth+(chartMaxValue-tagValue)*yScaleSize-tagHeight/2, tagWidth, tagHeight)];
    
    if (normalTag) {
        tagImg = [UIImage imageNamed:@"overview_chart_a_tag_normal"];
        
        float triangleWidth = 10/imgScale;
        float triangleHeight = 13/imgScale;
        
        triangleImgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width-chartRightWidth, chartTopWidth+(chartMaxValue-tagValue)*yScaleSize-tagHeight/2, triangleWidth, triangleHeight)];
        
        triangleImgView.image = [UIImage imageNamed:@"overview_chart_a_normal"];
        
        [self addSubview:triangleImgView];
        
    }
    else{
        tagImg = [UIImage imageNamed:@"overview_chart_a_tag_target"];
        
        
        
    }
    
    tagValueImgView.image = tagImg;
    [self addSubview:tagValueImgView];
    
    
    tagValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tagValueImgView.frame.size.width-5, tagValueImgView.frame.size.height)];
    tagValueLabel.textColor = [UIColor whiteColor];

    if (self.chartType == 2 || self.chartType == 5) {
        
        tagValueLabel.text = [NSString stringWithFormat:@"%.1f",tagValue];
    }
    else{
        
        tagValueLabel.text = [NSString stringWithFormat:@"%.0f",tagValue];
    }
    
    tagValueLabel.font = [UIFont systemFontOfSize:10.0];
    tagValueLabel.textAlignment = NSTextAlignmentCenter;
    [tagValueImgView addSubview:tagValueLabel];

}



#pragma mark - Touch Event  ***********************
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if (!self.indicatorMode) {
        return;
    }
    
    [self.delegate touchBeginChartView];
    
    CGPoint touchPoint = [[touches anyObject] locationInView:self];
    
    if (touchPoint.x > chartLeftWidth && touchPoint.x < self.frame.size.width- chartRightWidth) {
        
        [self showTouchedPointValue:touchPoint];
    }
    
    NSLog(@"Begin");
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if (!self.indicatorMode) {
        return;
    }
    
    CGPoint touchPoint = [[touches anyObject] locationInView:self];
    
    if (touchPoint.x > chartLeftWidth && touchPoint.x < self.frame.size.width- chartRightWidth) {
        
        [self showTouchedPointValue:touchPoint];
    }
    
}

-(void)showTouchedPointValue:(CGPoint)touchedPoint{
    
    if (self.chartDataArray.count == 0) {
        indicatorLine.hidden = YES;
        return;
    }
    
    indicatorLine.frame = CGRectMake(touchedPoint.x, indicatorLine.frame.origin.y, indicatorLine.frame.size.width, indicatorLine.frame.size.height);
    
    indicatorLine.hidden = NO;
    
    float dataMargin = (self.frame.size.width-chartLeftWidth-chartRightWidth)/dataCount;
    
    float index = (touchedPoint.x-chartLeftWidth)/dataMargin;
    
    int dataIndex = floor(index);
    
    if (dataIndex < self.chartDataArray.count ) {
        
        float floatVal = [[self.chartDataArray objectAtIndex:dataIndex] floatValue];
        
        if(self.chartType == 0 || self.chartType == 5){
            float secFloatVal = [[secGraphYData objectAtIndex:dataIndex] floatValue];
            
            if(self.chartType == 0){
                
                valueLabel.text = [NSString stringWithFormat:@"%.0f/%.0f",floatVal,secFloatVal];
            }
            else {
                
                valueLabel.text = [NSString stringWithFormat:@"%.1f/%.1f",floatVal,secFloatVal];
            }
            
        }
        else {
            
            if (self.chartType == 2) {
                
                valueLabel.text = [NSString stringWithFormat:@"%.1f",floatVal];
            }
            else {
                
                valueLabel.text = [NSString stringWithFormat:@"%.0f",floatVal];
            }
        }
        
        NSString *dateStr = [NSString stringWithFormat:@"%@",[dateArray objectAtIndex:dataIndex]];
        
        if (dateStr.length >= 5) {
            
            dateStr = [dateStr substringFromIndex:5];
        }
    
        indicatorDate.text = dateStr;
        
    }
    else {
        
        valueLabel.text = @"";
    }
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if (!self.indicatorMode) {
        return;
    }
    
    [self.delegate touchEndChartView];
    
    indicatorLine.hidden = YES;
    
    NSLog(@"End");
}


#pragma mark - integer -> int  ***********************
-(int)getIntValueFromInteger:(NSInteger)num {
    
    NSNumber *number = [NSNumber numberWithInteger:num];
    int value_int = [number intValue];
    return value_int;
}


#pragma mark - 繪圖區  ***********************
-(void)drawRect:(CGRect)rect {
    
    switch (self.chartType) {
        case 0:
            targetValCount = 2;
            break;
        case 1:
            targetValCount = 0;
            break;
        case 2:
            targetValCount = 1;
            break;
        case 3:
            targetValCount = 0;
            break;
        case 4:
            targetValCount = 1;
            break;
        case 5:
            targetValCount = 0;
            break;
        default:
            break;
    }
    
//MARK:Need To Check
    //目標值曲線
    CGContextRef targetLine = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(targetLine, 1.0);
    CGContextSetLineJoin(targetLine, kCGLineJoinRound);
    CGContextSetRGBStrokeColor(targetLine, 12.0/255.0, 165.0/255.0, 0.0/255.0, 1);
    
    for (int i=0; i<targetValCount; i++) {
        
        CGFloat y=0,x1=0,x2=0;
        
        x1=chartLeftWidth;
        x2=self.frame.size.width-chartRightWidth;
        
        if(i == 0 && self.targetValue != 0) {
            //Target Line
            y=chartTopWidth+(chartMaxValue - self.targetValue)*yScaleSize;
        }
        
        if (i == 1 && self.secTargetValue != 0) {
            //Second Target Line
            y=chartTopWidth+(chartMaxValue - self.secTargetValue)*yScaleSize;
        }
        
        CGContextMoveToPoint(targetLine, x1,y);
        CGContextAddLineToPoint(targetLine,x2,y);
        CGContextStrokePath(targetLine);
        
        if(targetValCount==2) {
            
            NSLog(@"targetValue:%f",self.targetValue);
            NSLog(@"secTargetValue:%f",self.secTargetValue);
            NSLog(@"y:%f",y);
        }
    }


    //MARK:圖表範圍
    CGContextRef graphContext = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(graphContext, 0.0, 61.0/255.0, 165.0/255.0, 1);
    CGContextSetLineWidth(graphContext, 3.0);
    CGContextSetLineJoin(graphContext, kCGLineJoinRound);
    
    //NSLog(@"chartDataArray = %@",chartDataArray);
    
    for (int i=0; i<self.chartDataArray.count; i++) {
        
        //float xValue = [[xPointAry objectAtIndex:i] floatValue];
        float yValue = [[self.chartDataArray objectAtIndex:i] floatValue];
        
        //        if (yValue <= chartMinValue) {
        //            yValue = chartMinValue;
        //        }
        //        NSLog(@"yValue = %f",yValue);
        //        NSLog(@"chartMinValue = %f",chartMinValue);
        
        //if (normalValue != 0) {
        //[self setChartLineDot:i yPoint:yValue normalValue:normalValue];
        //}
        
        if (yValue != 0) {
            
            [self setChartLineDot:i yPoint:yValue normalValue:self.normalValue];
            
            if (firstPoint) {
               
                CGContextMoveToPoint(graphContext, chartLeftWidth+(i*xScaleSize),chartTopWidth+((chartMaxValue-yValue)*yScaleSize));
                firstPoint = NO;
            }
            else {
                
                CGContextAddLineToPoint(graphContext, chartLeftWidth+(i*xScaleSize),chartTopWidth+((chartMaxValue-yValue)*yScaleSize));
            }
            
        }
        
    }
    
    CGContextStrokePath(graphContext);
    
    
    //SYS/DIS 室溫 測試用假資料
    if(self.chartType == 0 || self.chartType == 5){
        
        CGContextRef secGraphContext = UIGraphicsGetCurrentContext();
        
        if (self.chartType == 5) {
            
            CGContextSetRGBStrokeColor(secGraphContext, 77.0/255.0, 143.0/255.0, 255.0/255.0, 1);
        }
        else{
            
            CGContextSetRGBStrokeColor(secGraphContext, 0.0, 61.0/255.0, 165.0/255.0, 1);
        }
    
        CGContextSetLineWidth(secGraphContext, 3.0);
        CGContextSetLineJoin(secGraphContext, kCGLineJoinRound);
        
        for (int i=0; i < self.chartDataArray.count; i++) {
            
            float secGraphYValue = [[secGraphYData objectAtIndex:i] floatValue];
            
            //            if (secGraphYValue <= chartMinValue) {
            //                secGraphYValue = chartMinValue;
            //            }
            
            //if (secNormalValue !=0) {
            //[self setChartLineDot:i yPoint:secGraphYValue normalValue:secNormalValue];
            //}
            
            if (secGraphYValue != 0) {
                
                if (secGraphYValue <= chartMinValue) {
                    secGraphYValue = chartMinValue;
                }
                
                [self setChartLineDot:i yPoint:secGraphYValue normalValue:self.secNormalValue];
                
                if (secFirstPoint) {
                    
                    CGContextMoveToPoint(secGraphContext, chartLeftWidth+(i*xScaleSize),chartTopWidth+((chartMaxValue-secGraphYValue)*yScaleSize));
                    
                    secFirstPoint = NO;
                }
                else {
                    
                    CGContextAddLineToPoint(secGraphContext, chartLeftWidth+(i*xScaleSize),chartTopWidth+((chartMaxValue-secGraphYValue)*yScaleSize));
                }
                
            }
        }
        
        CGContextStrokePath(secGraphContext);
    }
    
    NSString *dateStr;
    
    if(showSingleDay) {
        
        if (dateArray.count != 0) {
            
            dateStr = [NSString stringWithFormat:@"%@",[dateArray firstObject]];
        }
        else {
            
            dateStr = @"";
        }
        
    }
    else{
        
        dateStr = [NSString stringWithFormat:@"%@ - %@",[dateArray firstObject],[dateArray lastObject]];
    }
    
    [self.delegate didFinishLoadChartAndShowDate:dateStr];
}


-(CGFloat)convertRealY:(CGFloat)yValue {
    
    CGFloat rY=0;
    
    float maxValue=135;//chartMaxValue;//==>0
    float minValue=80;//chartMinValue;//==>height
    float height=self.frame.size.height-chartTopWidth-chartBottomWidth;
    
    //if((maxValue-minValue)!=0)
    {
        rY=height-(((yValue-minValue)*height)/(maxValue-minValue));
    }
    
    return rY+chartTopWidth;
}


-(void)setChartLineDot:(float)xPointVal yPoint:(float)yPointVal normalValue:(float)normalVal{
    
    float dotWidth = 15/imgScale;
    float dotHeight = 15/imgScale;
    
    
    if(yPointVal > normalVal && normalVal != 0){
        
        UIImageView *dotView = [[UIImageView alloc] initWithFrame:CGRectMake(chartLeftWidth+(xPointVal*xScaleSize)-dotWidth/2,chartTopWidth+(chartMaxValue-yPointVal)*yScaleSize-dotHeight/2, dotWidth, dotHeight)];
        
        dotView.image = [UIImage imageNamed:@"overview_chart_a_dot_r"];
        
        //        UILabel *dotLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        //        dotLabel.font = [UIFont systemFontOfSize:8.0];
        //        dotLabel.text = [NSString stringWithFormat:@"%.0f",yPointVal];
        //        dotLabel.textColor = [UIColor redColor];
        //        [dotLabel sizeToFit];
        //
        //        dotLabel.frame = CGRectMake(normalDot.frame.origin.x, normalDot.frame.origin.y-dotLabel.frame.size.height, dotLabel.frame.size.width, dotLabel.frame.size.height);
        //        [self addSubview:dotLabel];
        [self addSubview:dotView];
        
    }
    else{
        
        UIImageView *dotView = [[UIImageView alloc] initWithFrame:CGRectMake(chartLeftWidth+(xPointVal*xScaleSize)-dotWidth/2,chartTopWidth+(chartMaxValue-yPointVal)*yScaleSize-dotHeight/2, dotWidth, dotHeight)];
        
        dotView.image = [UIImage imageNamed:@"overview_chart_a_dot_b"];
        
        [self addSubview:dotView];
    }
    
}


#pragma mark - Bezier
-(void)createBezierPath:(CGPoint)theFirstPoint theSecondPoint:(CGPoint)theSecondPoint {
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    
    //線條屬性
    bezierPath.lineWidth = 2.0;
    bezierPath.lineCapStyle =  kCGLineCapRound;
    bezierPath.lineJoinStyle = kCGLineCapRound;
    
    //起始點
    [bezierPath moveToPoint:CGPointMake(theFirstPoint.x, theFirstPoint.y)];
    
    //控制點
    CGPoint controlPoint01 = CGPointMake((theSecondPoint.x - theFirstPoint.x)/2 + theFirstPoint.x, theFirstPoint.y);
    CGPoint controlPoint02 = CGPointMake((theSecondPoint.x - theFirstPoint.x)/2 + theFirstPoint.x, theSecondPoint.y);
    
    //終點與弧度
    [bezierPath addCurveToPoint:theSecondPoint controlPoint1:controlPoint01 controlPoint2:controlPoint02];
    
    //確認 Bezier 路徑
    [bezierPath stroke];
}

@end
