//
//  GraphView.m
//  Microlife
//
//  Created by Rex on 2016/8/18.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import "GraphView.h"

#define SCREEN_BOUNDS [UIScreen mainScreen].bounds
@interface GraphView (){
    
    UIView *indicatorLine;
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

@implementation GraphView

@synthesize chartDataArray,graphUnitLabel,lineIntroLabel,lineIntroImg,targetIntroLabel,targetIntroImg,normalIntroLabel,normalIntroImg,startTimeLabel,endTimeLabel,secNormalValue,normalValue,targetValue,secTargetValue,indicatorMode;

- (id)initWithFrame:(CGRect)frame withChartType:(int)type withDataCount:(int)count withDataRange:(NSInteger)range;
{
    self = [super init];
    
    if (self) {
        
        self.frame = frame;
        self.chartType = type;
        dataCount = count;
        dataRange = range;
        firstPoint = YES;
        secFirstPoint = YES;
        [self initParameter];
        [self initInterface];
    }
    return self;
}

-(void)initParameter{
    
    if(IS_IPHONE_5){
        imgScale = 2;
    }else if(IS_IPHONE_6){
        imgScale = 2;
    }else if(IS_IPHONE_6P){
        imgScale = 1.75;
    }else{
        imgScale = 2.5;
    }
    
    chartDataArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    indicatorMode = NO;
    
    showSingleDay = NO;
    
    targetValCount = 0;
    targetValue = 0;
    secTargetValue = 0;
    dataXLength = 0;
    secGraphYData = [[NSMutableArray alloc] initWithCapacity:0];
    
    dateArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    //測試用資料
//    int tempDevided;
//    int tempPlus;
//    
//    if (self.chartType == 0) {
//        tempDevided = 10;
//        tempPlus = 80;
//    }else{
//        tempDevided = 5;
//        tempPlus = 25;
//    }
//    
//    int plusValue = 0;
//    int devidedValue = 0;
//    
//    switch (self.chartType) {
//        case 0:
//            plusValue = 130;
//            devidedValue = 10;
//            break;
//            
//        case 1:
//            plusValue = 150;
//            devidedValue = 10;
//            break;
//            
//        case 2:
//            plusValue = 55;
//            devidedValue = 20;
//            
//            break;
//            
//        case 3:
//            plusValue = 20;
//            devidedValue = 10;
//            
//            break;
//            
//        case 4:
//            plusValue = 20;
//            devidedValue = 5;
//            
//            break;
//            
//        case 5:
//            plusValue= 35;
//            devidedValue = 5;
//            
//            break;
//            
//        default:
//            break;
//    }
//    
//    int maxValue = 0;
//    int minValue = 280;
//    
//    for (int i=0; i<dataCount; i++) {
//        
//        NSNumber *yValue = [NSNumber numberWithInteger:(arc4random() % devidedValue)+plusValue];
//        
//        [chartDataArray addObject:yValue];
//        
//        if (yValue.intValue > maxValue && self.chartType == 0) {
//            maxValue = yValue.intValue;
//        }
//        
//        NSNumber *yValueNum = [NSNumber numberWithInteger:(arc4random() % tempDevided)+tempPlus];
//        
//        [secGraphYData addObject:yValueNum];
//        
//        if (yValueNum.intValue < minValue && self.chartType == 0) {
//            minValue = yValueNum.intValue;
//        }
//    }
    
    NSMutableArray *selectDataAry = [[NSMutableArray alloc] initWithCapacity:0];
    
    switch (self.chartType) {
        case 0:
            //SYS/DIA
            [chartDataArray removeAllObjects];
            [secGraphYData removeAllObjects];
            
            if (dataCount == -1) {
                selectDataAry = [[BPMClass sharedInstance] selectSingleDayBPWithRange:dataRange];
                
            }else{
                selectDataAry = [[BPMClass sharedInstance] selectBPWithRange:dataRange count:dataCount];
            }  
            
            float maxValue = 300;
            float minValue = 0;
            
            for (int i = 0; i<selectDataAry.count; i++) {
                
                NSNumber *SYSNum = [NSNumber numberWithInt:[[[selectDataAry objectAtIndex:i] objectForKey:@"SYS"] intValue]];
                NSNumber *DIANum = [NSNumber numberWithInt:[[[selectDataAry objectAtIndex:i] objectForKey:@"DIA"] intValue]];

                
                if (SYSNum.intValue != 0 && DIANum.intValue != 0) {
                    if (SYSNum.intValue > maxValue) {
                        maxValue = SYSNum.intValue;
                    }
                    
                    if (DIANum.intValue < minValue) {
                        minValue = DIANum.intValue;
                    }
                    
                    //maxValue += maxValue*0.1;
                    //minValue -= minValue*0.1;
                }
                
                [chartDataArray addObject:[[selectDataAry objectAtIndex:i] objectForKey:@"SYS"]];
                [secGraphYData addObject:[[selectDataAry objectAtIndex:i] objectForKey:@"DIA"]];
                [dateArray addObject:[[selectDataAry objectAtIndex:i] objectForKey:@"date"]];
                
                NSLog(@"[[selectDataAry objectAtIndex:i] objectForKey:date] :%@",[[selectDataAry objectAtIndex:i] objectForKey:@"date"]);
                
            }
            
            chartMaxValue = maxValue*1.15;
            chartMinValue = minValue*0.85;
            
            normalValue = 135;
            secNormalValue = 85;
            targetValue = [LocalData sharedInstance].targetSYS;
            secTargetValue = [LocalData sharedInstance].targetDIA;
            
            if(chartMinValue>secTargetValue)
            {
                chartMinValue=secTargetValue;
            }
            
            if(chartMaxValue<targetValue)
            {
                chartMaxValue=targetValue;
            }
            
            
            if (![LocalData sharedInstance].showTargetSYS) {
                targetValue = 0;
            }
            
            if (![LocalData sharedInstance].showTargetDIA) {
                secTargetValue = 0;
            }
            
            break;
        case 1:{
            //PUL
            [chartDataArray removeAllObjects];
            
            if (dataCount == -1) {
                selectDataAry = [[BPMClass sharedInstance] selectSingleDayPULWithRange:dataRange];
                
            }else{
                selectDataAry = [[BPMClass sharedInstance] selectPULWithRange:dataRange count:dataCount];
            }
            
            chartMaxValue = 200;
            chartMinValue = 0;
            
            for (int i = 0; i<selectDataAry.count; i++) {
                [chartDataArray addObject:[[selectDataAry objectAtIndex:i] objectForKey:@"PUL"]];
                [dateArray addObject:[[selectDataAry objectAtIndex:i] objectForKey:@"date"]];
                int PULValue = [[[selectDataAry objectAtIndex:i] objectForKey:@"PUL"] intValue];
                if (PULValue > chartMaxValue) {
                    chartMaxValue = PULValue*1.15;
                }
                if (chartMinValue > PULValue) {
                    chartMinValue = PULValue*0.85;
                }
            }
            
            
            
            targetValue = 75;
            
            
        }
            break;
        case 2:{
            
            //體重
            [chartDataArray removeAllObjects];
            
            if (dataCount == -1) {
                
                selectDataAry = [[WeightClass sharedInstance] selectSingleDay:@"weight" range:dataRange];

            }else{
                
                selectDataAry = [[WeightClass sharedInstance] selectData:@"weight" range:dataRange count:dataCount];
                
            }
            
            chartMaxValue = 200.0;
            chartMinValue = 0.0;
            
            for (int i = 0; i<selectDataAry.count; i++) {
                [chartDataArray addObject:[[selectDataAry objectAtIndex:i] objectForKey:@"weight"]];
                [dateArray addObject:[[selectDataAry objectAtIndex:i] objectForKey:@"date"]];
                int weightValue = [[[selectDataAry objectAtIndex:i] objectForKey:@"weight"] intValue];
                if (weightValue > chartMaxValue) {
                    chartMaxValue = weightValue*1.15;
                }
                if (chartMinValue > weightValue) {
                    chartMinValue = weightValue*0.85;
                }
            }
            
            targetValue = [LocalData sharedInstance].targetWeight;
            
            if(chartMaxValue<targetValue)
            {
                chartMaxValue=targetValue;
            }
            
            if (![LocalData sharedInstance].showTargetWeight) {
                targetValue = 0;
            }
        }
            
            break;
        case 3:{
            //BMI
            
            [chartDataArray removeAllObjects];
            
            if (dataCount == -1) {
                
                selectDataAry = [[WeightClass sharedInstance] selectSingleDay:@"BMI" range:dataRange];
            }else{
                
                selectDataAry = [[WeightClass sharedInstance] selectData:@"BMI" range:dataRange count:dataCount];
            }
            
            chartMaxValue = 100;
            chartMinValue = 0;
            
            for (int i = 0; i<selectDataAry.count; i++) {
                [chartDataArray addObject:[[selectDataAry objectAtIndex:i] objectForKey:@"BMI"]];
                [dateArray addObject:[[selectDataAry objectAtIndex:i] objectForKey:@"date"]];
                int BMIValue = [[[selectDataAry objectAtIndex:i] objectForKey:@"BMI"] intValue];
                if (BMIValue > chartMaxValue) {
                    chartMaxValue = BMIValue*1.15;
                }
                if (chartMinValue > BMIValue) {
                    chartMinValue = BMIValue*0.85;
                }
            }
            
            NSLog(@"chartDataArray = %@",chartDataArray);
            
            
            
            normalValue = [LocalData sharedInstance].standerBMI;
            targetValue = [LocalData sharedInstance].targetBMI;
            
            if(chartMinValue>normalValue)
            {
                chartMinValue=normalValue;
            }
            
        }
            
            break;
            
        case 4:{
            //FAT
            
            [chartDataArray removeAllObjects];
            
            if (dataCount == -1) {
            
                selectDataAry = [[WeightClass sharedInstance] selectSingleDay:@"bodyFat" range:dataRange];
            }else{
                //selectDataAry = [[WeightClass sharedInstance] selectBMI:dataCount];
                
                selectDataAry = [[WeightClass sharedInstance] selectData:@"bodyFat" range:dataRange count:dataCount];
                
            }
            
            chartMaxValue = 70;
            chartMinValue = 0;
            
            for (int i = 0; i<selectDataAry.count; i++) {
                [chartDataArray addObject:[[selectDataAry objectAtIndex:i] objectForKey:@"bodyFat"]];
                [dateArray addObject:[[selectDataAry objectAtIndex:i] objectForKey:@"date"]];
                int bodyFatValue = [[[selectDataAry objectAtIndex:i] objectForKey:@"bodyFat"] intValue];
                if (bodyFatValue > chartMaxValue) {
                    chartMaxValue = bodyFatValue*1.15;
                }
                if (chartMinValue > bodyFatValue) {
                    chartMinValue = bodyFatValue*0.85;
                }
            }
                        
            normalValue = [LocalData sharedInstance].standerFat;
            targetValue = [LocalData sharedInstance].targetFat;
            
            if (![LocalData sharedInstance].showTargetFat) {
                targetValue = 0;
            }
            
            if(chartMinValue>normalValue)
            {
                chartMinValue=normalValue;
            }
            
            if(chartMaxValue<targetValue)
            {
                chartMaxValue=targetValue;
            }
            
            
        }
            
            break;
        case 5:{
            //溫度
            [chartDataArray removeAllObjects];
            [secGraphYData removeAllObjects];
            
            if (dataCount == -1) {
                selectDataAry = [[BTClass sharedInstance] selectSingleHourTempWithRange:dataRange];

            }else{
                selectDataAry = [[BTClass sharedInstance] selectTempWithRange:dataRange count:dataCount];
            }
            
            for (int i = 0; i<selectDataAry.count; i++) {
                [chartDataArray addObject:[[selectDataAry objectAtIndex:i] objectForKey:@"temp"]];
                [secGraphYData addObject:[[selectDataAry objectAtIndex:i] objectForKey:@"room"]];
                [dateArray addObject:[[selectDataAry objectAtIndex:i] objectForKey:@"date"]];
            }
            
            
            //Allen fix ----------------------------------
            
            //決定室溫的最低值
            float temperatureMinValue = 15.0;
            
            //
            for (int i = 0; i<selectDataAry.count; i++) {
                
                //取室溫值
                float temperatureValue = [[secGraphYData objectAtIndex:i] floatValue];
                
                if (temperatureValue < temperatureMinValue) {
                    temperatureMinValue = temperatureValue;
                }
                
//                //避掉取到資料庫為0的預設值
//                if (temperatureValue == 0 ) {
//                    
//                    if (i>0) {
//                        temperatureValue = [[secGraphYData objectAtIndex:i-1] floatValue];
//                    }else{
//                        temperatureValue = 25.0;
//                    }
//                    
//                }
//                
//                if (i>0) {
//                    //取上一個測量時的室溫值
//                    float temperaturePreviousValue = [[secGraphYData objectAtIndex:i-1] floatValue];
//                    
//                    if (temperatureValue < temperaturePreviousValue) {
//                        temperatureMinValue = temperatureValue;
//                    }
//                    
//                }
                
                
                
            }
            
            NSLog(@"最低的室溫值====%f",temperatureMinValue);
            chartMaxValue = 42.0;
            chartMinValue = temperatureMinValue*0.85;
            normalValue = 37.5;
            
            //Allen fix end----------------------------------


        }
            
            break;
            
        default:
            break;
    }
    
    if(dataCount == -1){
        showSingleDay = YES;
    }
    
    dataCount = selectDataAry.count;

    //MARK:計算資料範圍值
    dataXLength = dataCount;
    
    NSLog(@"chartMaxValue:%f",chartMaxValue);
    NSLog(@"chartMinValue:%f",chartMinValue);
    dataYLength = chartMaxValue-chartMinValue;
    
}

-(void)initInterface{
    
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
            unitStr = @"kg";
            lineIntroStr = @"Weight";
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
            //°C °F
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
    graphUnitLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 2, SCREEN_WIDTH*0.086, SCREEN_HEIGHT*0.044)];
    graphUnitLabel.text = unitStr;
    graphUnitLabel.font = [UIFont systemFontOfSize:10.0];
    graphUnitLabel.textColor = [UIColor colorWithRed:157.0/255.0 green:157.0/255.0 blue:157.0/255.0 alpha:1.0];
    [graphUnitLabel sizeToFit];
    [self addSubview:graphUnitLabel];
    
    
    //上方主線條提示文字
    lineIntroLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    lineIntroLabel.font = [UIFont systemFontOfSize:12.0];
    lineIntroLabel.text = lineIntroStr;
    lineIntroLabel.textAlignment = NSTextAlignmentRight;
    [lineIntroLabel sizeToFit];
    lineIntroLabel.frame = CGRectMake(SCREEN_WIDTH-SCREEN_WIDTH*0.04-lineIntroLabel.frame.size.width, SCREEN_HEIGHT*0.044/2-lineIntroLabel.frame.size.height/2, lineIntroLabel.frame.size.width, lineIntroLabel.frame.size.height);
    [self addSubview:lineIntroLabel];

    
    //上方主線條提示文字圖片
    lineIntroImg = [[UIImageView alloc] initWithFrame:CGRectMake(lineIntroLabel.frame.origin.x-lineIntroImg_w-4, lineIntroLabel.frame.origin.y+lineIntroLabel.frame.size.height/2-lineIntroImg_h/2, lineIntroImg_w, lineIntroImg_h)];
    lineIntroImg.image = mainlineIntroImg;
    [self addSubview:lineIntroImg];
    
    
    //上方目標值提示文字
    targetIntroLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    targetIntroLabel.text = targetIntroStr;
    targetIntroLabel.font = [UIFont systemFontOfSize:12.0];
    [targetIntroLabel sizeToFit];
    targetIntroLabel.frame = CGRectMake(lineIntroImg.frame.origin.x-targetIntroLabel.frame.size.width-4, SCREEN_HEIGHT*0.044/2-targetIntroLabel.frame.size.height/2, targetIntroLabel.frame.size.width, targetIntroLabel.frame.size.height);
    [self addSubview:targetIntroLabel];
    
    
    //目標值提示圖片
    targetIntroImg = [[UIImageView alloc] initWithFrame:CGRectMake(targetIntroLabel.frame.origin.x-targetIntroImg_w-4, targetIntroLabel.frame.origin.y+targetIntroLabel.frame.size.height/2-targetIntroImg_h/2, targetIntroImg_w, targetIntroImg_h)];
    targetIntroImg.image = targetImg;
    [self addSubview:targetIntroImg];
    
    
    //上方正常值提示文字
    UILabel *normalIntro = [[UILabel alloc] initWithFrame:CGRectZero];
    normalIntro.text = normalIntroStr;
    normalIntro.font = [UIFont systemFontOfSize:12.0];
    [normalIntro sizeToFit];
    normalIntro.frame = CGRectMake(targetIntroImg.frame.origin.x-normalIntro.frame.size.width-4, SCREEN_HEIGHT*0.044/2-normalIntro.frame.size.height/2, normalIntro.frame.size.width, normalIntro.frame.size.height);
    [self addSubview:normalIntro];
    
    
    //正常值提示圖片
    float normalIntroImg_w = 10/imgScale;
    float normalIntroImg_h = 13/imgScale;
    
    normalIntroImg = [[UIImageView alloc] initWithFrame:CGRectMake(normalIntro.frame.origin.x-normalIntroImg_w-4, normalIntro.frame.origin.y+normalIntro.frame.size.height/2-normalIntroImg_h/2, normalIntroImg_w, normalIntroImg_h)];
    normalIntroImg.image = normalImg;
    [self addSubview:normalIntroImg];
    
    
    //圖表上方線條
    UIView *topLine = [[UIView alloc] initWithFrame:CGRectMake(graphUnitLabel.frame.origin.x+graphUnitLabel.frame.size.width, SCREEN_HEIGHT*0.044, SCREEN_WIDTH-SCREEN_WIDTH*0.05-graphUnitLabel.frame.size.width, 1)];
    topLine.backgroundColor = [UIColor colorWithRed:157.0/255.0 green:157.0/255.0 blue:157.0/255.0 alpha:0.8];
    [self addSubview:topLine];
    
    
    //圖表下方線條
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(graphUnitLabel.frame.origin.x+graphUnitLabel.frame.size.width, self.frame.size.height-SCREEN_HEIGHT*0.044, SCREEN_WIDTH-SCREEN_WIDTH*0.05-graphUnitLabel.frame.size.width, 1)];
    bottomLine.backgroundColor = [UIColor colorWithRed:157.0/255.0 green:157.0/255.0 blue:157.0/255.0 alpha:0.8];
    [self addSubview:bottomLine];
    
    
    //開始時間
    startTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(graphUnitLabel.bounds.origin.x+2, bottomLine.frame.origin.y+SCREEN_HEIGHT*0.022, startTimeLabel.frame.size.width, startTimeLabel.frame.size.height)];
    startTimeLabel.text = @"";
    startTimeLabel.font = [UIFont systemFontOfSize:12.0];

    //[startTimeLabel sizeToFit];
    
    //startTimeLabel.frame =CGRectMake(graphUnitLabel.frame.origin.x, bottomLine.frame.origin.y+SCREEN_HEIGHT*0.022, startTimeLabel.frame.size.width, startTimeLabel.frame.size.height);
    //CGRectMake(bottomLine.frame.origin.x, bottomLine.frame.origin.y+SCREEN_HEIGHT*0.022, startTimeLabel.frame.size.width, startTimeLabel.frame.size.height);

    [self addSubview:startTimeLabel];
    
    
    
    //結束時間
    endTimeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    endTimeLabel.text = @"";
    endTimeLabel.font = [UIFont systemFontOfSize:12.0];
    [endTimeLabel sizeToFit];
    endTimeLabel.frame = CGRectMake(bottomLine.frame.origin.x+bottomLine.frame.size.width-endTimeLabel.frame.size.width, bottomLine.frame.origin.y+SCREEN_HEIGHT*0.022, endTimeLabel.frame.size.width, endTimeLabel.frame.size.height);
    [self addSubview:endTimeLabel];
    
    float endImgWidth = 15/imgScale;
    float endImgHeight = 13/imgScale;
    UIImageView *endTimeImg = [[UIImageView alloc] initWithFrame:CGRectMake(bottomLine.frame.origin.x+bottomLine.frame.size.width-endImgWidth/2, bottomLine.frame.origin.y+5, endImgWidth, endImgHeight)];
    
    
    //灰色三角形
    endTimeImg.image = [UIImage imageNamed:@"overview_chart_a_indicato"];
    
    [self addSubview:endTimeImg];
    
    chartTopWidth = 30;//SCREEN_HEIGHT*0.044;
    chartLeftWidth = graphUnitLabel.frame.origin.x+graphUnitLabel.frame.size.width;
    chartBottomWidth = chartTopWidth;//SCREEN_HEIGHT*0.044;
    chartRightWidth = SCREEN_WIDTH*0.04;
    
    
    /**
     //MARK:計算比例
     xScaleSize = (self.frame.size.width-chartLeftWidth-chartRightWidth)/dataXLength;
     yScaleSize = (self.frame.size.height-chartTopWidth-chartBottomWidth)/dataYLength;
     */
    
    //Allen fix ----------------------------------
    //MARK:計算比例
    xScaleSize = (self.frame.size.width-chartLeftWidth-chartRightWidth)/dataXLength;
    yScaleSize = (self.frame.size.height-chartTopWidth-chartBottomWidth)/dataYLength;
    
    
    if (IS_IPAD) {
        
        xScaleSize = (self.frame.size.width-chartLeftWidth-chartRightWidth)/dataXLength;
        yScaleSize = ((self.frame.size.height-chartTopWidth-chartBottomWidth)/dataYLength)*3/4;
    }
    
//    NSLog(@"chartMaxValue:%f",chartMaxValue);
//    NSLog(@"chartMinValue:%f",chartMinValue);
    NSLog(@"xScaleSize:(%f-%f-%f)/%f=%f",self.frame.size.width,chartLeftWidth,chartRightWidth,dataXLength,xScaleSize);
    NSLog(@"yScaleSize:(%f-%f-%f)/%f=%f",self.frame.size.height,chartTopWidth,chartBottomWidth,dataYLength,yScaleSize);

    //圖表綠色指標線
    indicatorLine = [[UIView alloc] initWithFrame:CGRectMake(chartLeftWidth,chartTopWidth , 1, self.frame.size.height-chartTopWidth*2)];
    indicatorLine.backgroundColor = [UIColor colorWithRed:12.0/255.0 green:165.0/255.0 blue:0.0/255.0 alpha:0.5];
    [self addSubview:indicatorLine];
    [indicatorLine setHidden:YES];
    
    
    //float indicatorViewWidth = 283/imgScale;
    //float indicatorViewHeight = 86/imgScale;
    
    
    //Allen
    float indicatorViewWidth = 290/imgScale;
    float indicatorViewHeight = 86/imgScale;
    float multiple = 1.0;
    
    if (IS_IPAD) {
        indicatorViewWidth = 406/imgScale;
        indicatorViewHeight = 100/imgScale;
        multiple = 1.5;
    }
    //Allen
    
    
    UIImageView *indicatorView = [[UIImageView alloc] initWithFrame:CGRectMake(-indicatorViewWidth/2+1, -indicatorViewHeight+3, indicatorViewWidth, indicatorViewHeight)];
    
    indicatorView.image = [UIImage imageNamed:@"history_ui_a_bpm"];
    
    [indicatorLine addSubview:indicatorView];
    
    //標示線圖示顯示值
    //valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.frame.size.width*0.146, indicatorView.frame.size.height-3)];
    valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.frame.size.width*0.21/multiple, indicatorView.frame.size.height-3)];
    
    valueLabel.textColor = [UIColor whiteColor];
    valueLabel.text = @"";
    valueLabel.font = [UIFont systemFontOfSize:16.0];
    valueLabel.textAlignment = NSTextAlignmentCenter;
    
    [indicatorView addSubview:valueLabel];
    
    
    indicatorUnit = [[UILabel alloc] initWithFrame:CGRectMake((valueLabel.frame.origin.x+valueLabel.frame.size.width)/pow(multiple, 0.4), valueLabel.frame.origin.y+2, self.frame.size.width*0.08, indicatorView.frame.size.height-2)];
    
    if (self.chartType == 0) {
        
        indicatorUnit = [[UILabel alloc] initWithFrame:CGRectMake((valueLabel.frame.origin.x+valueLabel.frame.size.width*0.8)/pow(multiple, 0.2), valueLabel.frame.origin.y+2, self.frame.size.width*0.08, indicatorView.frame.size.height-2)];
    }
    
    //indicatorUnit = [[UILabel alloc] initWithFrame:CGRectMake(valueLabel.frame.origin.x+valueLabel.frame.size.width, valueLabel.frame.origin.y+2, self.frame.size.width*0.08, indicatorView.frame.size.height-2)];
    
    indicatorUnit.textColor = [UIColor whiteColor];
    indicatorUnit.text = indicatorUnitStr;
    indicatorUnit.font = [UIFont systemFontOfSize:8.0];
    
    [indicatorView addSubview:indicatorUnit];
    
    //indicatorUnit.frame.origin.x+indicatorUnit.frame.size.width
    
    //indicatorDate = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width*0.26, indicatorUnit.frame.origin.y-4, self.frame.size.width*0.093, indicatorView.frame.size.height-2)];
    
    indicatorDate = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width*0.26/pow(multiple, 1.45), indicatorUnit.frame.origin.y-4, self.frame.size.width*0.099/pow(multiple, 1.8), indicatorView.frame.size.height-2)];
    indicatorDate.textAlignment = NSTextAlignmentCenter;
    indicatorDate.textColor = [UIColor whiteColor];
    indicatorDate.text = @"";
    indicatorDate.font = [UIFont systemFontOfSize:11.0];
    
    [indicatorView addSubview:indicatorDate];
    
    [self setTagValue];
    
    if (dateArray.count != 0) {
        startTimeLabel.text = [NSString stringWithFormat:@"%@",[dateArray firstObject]];
        endTimeLabel.text = [NSString stringWithFormat:@"%@",[dateArray lastObject]];
        
        NSLog(@"startTimeLabel.text ===>> %@",startTimeLabel.text);
        NSLog(@"endTimeLabel.text ===>> %@",endTimeLabel.text);
        
        [self.delegate getTimeRange:startTimeLabel.text EndTime:endTimeLabel.text];
    }
    
    [startTimeLabel sizeToFit];
    [endTimeLabel sizeToFit];
    
    //startTimeLabel.frame = CGRectMake(startTimeLabel.frame.origin.x-startTimeLabel.frame.size.width/2, startTimeLabel.frame.origin.y, startTimeLabel.frame.size.width, startTimeLabel.frame.size.height);
    
    endTimeLabel.frame = CGRectMake(endTimeLabel.frame.origin.x-endTimeLabel.frame.size.width, endTimeLabel.frame.origin.y, endTimeLabel.frame.size.width, endTimeLabel.frame.size.height);
    
    //[self setClipsToBounds:YES];
    //[self.layer setBorderWidth:1];
    //[self.layer setBorderColor:[[UIColor redColor] CGColor]];
    
}


-(void)setTagValue{
    //YES = create normal value tag   NO = target value
    
    switch (self.chartType) {
        case 0:
            
            //SYS/DIA
            [self createValueTag:targetValue normal:NO];
            [self createValueTag:secTargetValue normal:NO];
            
            [self createValueTag:normalValue normal:YES];
            [self createValueTag:secNormalValue normal:YES];
            break;
        
        case 1:
            
            //PUL
            [self createValueTag:0 normal:YES];
            [self createValueTag:0 normal:YES];
            break;
            
        case 2:
            //Weight
            [self createValueTag:targetValue normal:NO];
            [self createValueTag:normalValue normal:YES];
            break;
            
        case 3:
            //BMI
            //亞洲區：23
            //非亞洲區：25
            [self createValueTag:targetValue normal:NO];
            [self createValueTag:normalValue normal:YES];
            break;
            
        case 4:
            //FAT
            //男性：24%
            //女性：31%
            [self createValueTag:targetValue normal:NO];
            [self createValueTag:normalValue normal:YES];
            break;
            
        case 5:
            
            [self createValueTag:normalValue normal:YES];
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
    
    [tagValueImgView removeFromSuperview];
    [triangleImgView removeFromSuperview];
    [tagValueLabel removeFromSuperview];
    
    if (tagValue == 0) {
        return;
    }
    
    tagValueImgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, chartTopWidth+(chartMaxValue-tagValue)*yScaleSize-tagHeight/2, tagWidth, tagHeight)];
    
    UIImage *tagImg;
    
    if (normalTag) {
        tagImg = [UIImage imageNamed:@"overview_chart_a_tag_normal"];
        
        float triangleWidth = 10/imgScale;
        float triangleHeight = 13/imgScale;
        
        triangleImgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width-chartRightWidth, chartTopWidth+(chartMaxValue-tagValue)*yScaleSize-tagHeight/2, triangleWidth, triangleHeight)];
        
        triangleImgView.image = [UIImage imageNamed:@"overview_chart_a_normal"];
        
        [self addSubview:triangleImgView];
        
    }else{
        tagImg = [UIImage imageNamed:@"overview_chart_a_tag_target"];
     
        UIView *targetLine = [[UIView alloc] initWithFrame:CGRectMake(tagValueImgView.frame.origin.x+tagValueImgView.frame.size.width, chartTopWidth+(chartMaxValue-tagValue)*yScaleSize, self.frame.size.width-chartRightWidth-tagValueImgView.frame.size.width, 1)];
        targetLine.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:164.0/255.0 blue:50.0/255.0 alpha:0.8];
        [self addSubview:targetLine];
    }
    
    tagValueImgView.image = tagImg;
    
    [self addSubview:tagValueImgView];

    tagValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tagValueImgView.frame.size.width-5, tagValueImgView.frame.size.height)];
    tagValueLabel.textColor = [UIColor whiteColor];
    
    if (self.chartType == 2 || self.chartType == 5) {
        tagValueLabel.text = [NSString stringWithFormat:@"%.1f",tagValue];
    }else{
        tagValueLabel.text = [NSString stringWithFormat:@"%.0f",tagValue];
    }
    
    tagValueLabel.font = [UIFont systemFontOfSize:10.0];
    tagValueLabel.textAlignment = NSTextAlignmentCenter;
    
    [tagValueImgView addSubview:tagValueLabel];
    
}


#pragma mark ================所有圖表畫圖的地方================
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    
    //chartType判斷是哪個圖表(0.血壓、1.心跳、2.重量、3.BMI、4.體脂、5.體溫)
    //targetValCount判斷要畫幾個點
    switch (self.chartType) {
        case 0:
            //舒張壓、收縮壓
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
    
    //*******************目標值曲線*******************
    
    //通過UIGraphicsBeginImageContextWithOptions方法就可以獲得一個圖形上下文，然後你就可以在其上進行繪圖操作，當繪圖操作完成以後，可以通過UIGraphicsGetImageFromCurrentImageContext 得到一個代表繪製內容的UIImage對象，最後不要忘了調用UIGraphicsEndImageContext關閉此圖形上下文
    
    //    //設置上下文
    //    CGContextRef targetLine = UIGraphicsGetCurrentContext();
    //    //設置線的寬度
    //    CGContextSetLineWidth(targetLine, 1.0);
    //    //設置折線效果                     Round圓角
    //    CGContextSetLineJoin(targetLine, kCGLineJoinRound);
    //    //畫筆颜色設置
    //    CGContextSetRGBStrokeColor(targetLine, 12.0/255.0, 165.0/255.0, 0.0/255.0, 1);
    //
    //    for (int i=0; i<targetValCount; i++) {
    //
    //        //x1前 x2
    //        CGFloat y=0,x1=0,x2=0;
    //
    //        x1=chartLeftWidth;
    //        x2=self.frame.size.width-chartRightWidth;
    //
    //        if(i==0 && targetValue != 0){
    //            //Target Line
    //            y=chartTopWidth+(chartMaxValue-targetValue)*yScaleSize;
    //        }
    //
    //        if (i == 1 && secTargetValue != 0) {
    //            //Second Target Line
    //            y=chartTopWidth+(chartMaxValue-secTargetValue)*yScaleSize;
    //        }
    //
    //        //開始畫線
    //        CGContextMoveToPoint(targetLine, x1,y);
    //        //畫直線
    //        CGContextAddLineToPoint(targetLine,x2,y);
    //        //開始繪製圖片
    //        CGContextStrokePath(targetLine);
    //
    //        if(targetValCount==2)
    //        {
    //            NSLog(@"targetValue:%f",targetValue);
    //            NSLog(@"secTargetValue:%f",secTargetValue);
    //            NSLog(@"y:%f",y);
    //        }
    //    }
    
    //    CGContextRef context = UIGraphicsGetCurrentContext();
    //    CGContextSetLineWidth(context, 2.0);
    //    CGContextSetStrokeColorWithColor(context, [UIColor blueColor].CGColor);
    //    CGContextMoveToPoint(context, 10, 10);
    //    CGContextAddCurveToPoint(context, 0, 50, 300, 250, 300, 400);
    //    CGContextStrokePath(context);
    
    
    //MARK:*******************圖表範圍*******************
    
    //設置上下文
    CGContextRef graphContext = UIGraphicsGetCurrentContext();
    //畫筆颜色設置
    CGContextSetRGBStrokeColor(graphContext, 0.0, 61.0/255.0, 165.0/255.0, 1);
    //設置線的寬度
    CGContextSetLineWidth(graphContext, 3.0);
    //設置折線效果
    CGContextSetLineJoin(graphContext, kCGLineJoinRound);
    
    //NSLog(@"chartDataArray = %@",chartDataArray);
    
    
    NSLog(@"chartDataArray.count===%lu",(unsigned long)chartDataArray.count);
    
    
    for (int i=0; i<chartDataArray.count; i++) {
        
        //float xValue = [[xPointAry objectAtIndex:i] floatValue];
        
        //y軸的值
        float yValue = [[chartDataArray objectAtIndex:i] floatValue];
        
        
        
        
        //        if (yValue <= chartMinValue) {
        //            yValue = chartMinValue;
        //        }
        //        NSLog(@"yValue = %f",yValue);
        //        NSLog(@"chartMinValue = %f",chartMinValue);
        
        //if (normalValue != 0) {
        //[self setChartLineDot:i yPoint:yValue normalValue:normalValue];
        //}
        
        
        
        if (yValue != 0) {
            
            [self setChartLineDot:i yPoint:yValue normalValue:normalValue];
            
            if (firstPoint) {
                //移到第一個點準備繪圖
                CGContextMoveToPoint(graphContext, chartLeftWidth+(i*xScaleSize),chartTopWidth+((chartMaxValue-yValue)*yScaleSize));
                
                NSLog(@"MoveToPoint X ==%f",chartLeftWidth+(i*xScaleSize));
                NSLog(@"MoveToPoint Y ==%f",chartTopWidth+((chartMaxValue-yValue)*yScaleSize));
                
                firstPoint = NO;
                
            }else{
                
                //Allen fix----------------------------------------
                
                
                //取出前一點的資料
                
                if (i > 0) {
                    
                    float previous_yValue = [[chartDataArray objectAtIndex:i-1] floatValue];
                    
                    if (previous_yValue == 0) {
                        
                        for (int j=2; j<chartDataArray.count; j++) {
                            
                            previous_yValue = [[chartDataArray objectAtIndex:i-j] floatValue];
                            
                            if (previous_yValue > 0) {
                                break;
                            }
                        }
                        
                    }
                    NSLog(@"previous_yValue===>%f",previous_yValue);
                    
                    //決定前一點的x,y
                    CGFloat x1 = chartLeftWidth+((i-1)*xScaleSize);
                    CGFloat y1 = chartTopWidth+((chartMaxValue-previous_yValue)*yScaleSize);
                    
                    //決定目前這一點的x,y
                    CGFloat x2 = chartLeftWidth+(i*xScaleSize);
                    CGFloat y2 = chartTopWidth+((chartMaxValue-yValue)*yScaleSize);
                    
                    //曲線控制點的x,y
                    CGFloat dx1 = (x2-x1)*0.5+x1;
                    CGFloat dx2 = (x2-x1)*0.5+x1;
                    
                    CGFloat dy1 = y1;
                    CGFloat dy2 = y2;
                    
                    NSLog(@"x1===%f",x1);
                    NSLog(@"y1===%f",y1);
                    
                    NSLog(@"x2===%f",x2);
                    NSLog(@"y2===%f",y2);
                    
                    NSLog(@"dx1===%f",dx1);
                    NSLog(@"dx2===%f",dx2);
                    NSLog(@"dy1===%f",dy1);
                    NSLog(@"dy2===%f",dy2);
                    
                    //畫曲線
                    CGContextAddCurveToPoint(graphContext, dx1, dy1, dx2, dy2, x2, y2);
                    
                    
                    
                }
                
                //Allen fix----------------------------------------
                
            }
            
        }
        
    }
    
    //開始繪製圖表
    CGContextStrokePath(graphContext);
    
    
    //*******************當圖表"0.舒張壓、收縮壓"或"5.體溫"時********************
    //SYS/DIS , 室溫(測試用假資料)
    
    if(self.chartType == 0 || self.chartType == 5){
        
        CGContextRef secGraphContext = UIGraphicsGetCurrentContext();
        
        if (self.chartType == 5) {
            CGContextSetRGBStrokeColor(secGraphContext, 77.0/255.0, 143.0/255.0, 255.0/255.0, 1);
        }else{
            CGContextSetRGBStrokeColor(secGraphContext, 0.0, 61.0/255.0, 165.0/255.0, 1);
        }
        
        CGContextSetLineWidth(secGraphContext, 3.0);
        CGContextSetLineJoin(secGraphContext, kCGLineJoinRound);
        
        for (int i=0; i<chartDataArray.count; i++) {
            
            
            float secGraphYValue = [[secGraphYData objectAtIndex:i] floatValue];
            
            //            if (secGraphYValue <= chartMinValue) {
            //                secGraphYValue = chartMinValue;
            //            }
            
            //if (secNormalValue !=0) {
            //[self setChartLineDot:i yPoint:secGraphYValue normalValue:secNormalValue];
            //}
            
            if (secGraphYValue != 0) {
                
//                if (secGraphYValue <= chartMinValue) {
//                    secGraphYValue = chartMinValue;
//                }
                
                [self setChartLineDot:i yPoint:secGraphYValue normalValue:secNormalValue];
                
                if (secFirstPoint) {
                    
                    //移到第一個點準備繪圖
                    CGContextMoveToPoint(secGraphContext, chartLeftWidth+(i*xScaleSize),chartTopWidth+((chartMaxValue-secGraphYValue)*yScaleSize));
                    
                    secFirstPoint = NO;
                    
                }else{
                    
                    //Allen fix----------------------------------------
                    
                    if (i>0) {
                        
                        //取出前一點的資料
                        float previous_yValue = [[secGraphYData objectAtIndex:i-1] floatValue];
                        
                        if (previous_yValue == 0) {
                            
                            for (int j=2; j<secGraphYData.count; j++) {
                                
                                previous_yValue = [[secGraphYData objectAtIndex:i-j] floatValue];
                                
                                if (previous_yValue > 0) {
                                    break;
                                }
                            }
                            
                        }
                        
                        NSLog(@"第二點previous_yValue===%f",previous_yValue);
                        
                        //決定前一點的x,y
                        CGFloat x1 = chartLeftWidth+((i-1)*xScaleSize);
                        CGFloat y1 = chartTopWidth+((chartMaxValue-previous_yValue)*yScaleSize);
                        
                        //決定目前這一點的x,y
                        CGFloat x2 = chartLeftWidth+(i*xScaleSize);
                        CGFloat y2 = chartTopWidth+((chartMaxValue-secGraphYValue)*yScaleSize);
                        
                        //曲線控制點的x,Y
                        CGFloat dx1 = (x2-x1)*0.5+x1;
                        CGFloat dx2 = (x2-x1)*0.5+x1;
                        
                        CGFloat dy1 = y1;
                        CGFloat dy2 = y2;
                        
                        NSLog(@"sec x1===%f",x1);
                        NSLog(@"sec y1===%f",y1);
                        
                        NSLog(@"sec x2===%f",x2);
                        NSLog(@"sec y2===%f",y2);
                        
                        NSLog(@"sec dx1===%f",dx1);
                        NSLog(@"sec dx2===%f",dx2);
                        NSLog(@"sec dy1===%f",dy1);
                        NSLog(@"sec dy2===%f",dy2);
                        
                        //畫曲線
                        CGContextAddCurveToPoint(secGraphContext, dx1, dy1, dx2, dy2, x2, y2);
                        
                    }
                    //Allen fix----------------------------------------
                }
                
            }
        }
        
        //開始繪製圖表
        CGContextStrokePath(secGraphContext);
    }
    
    
    //***************************************************
    
    
    
    
    
    //*********************判斷畫圖表資料是畫一天還是多天************************
    
    NSString *dateStr;
    
    
    if(showSingleDay){
        
        if (dateArray.count != 0) {
            
            dateStr = [NSString stringWithFormat:@"%@",[dateArray firstObject]];
        }
        else{
            dateStr = @"";
//            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//            [dateFormatter setDateFormat:@"yyyy/MM/dd"];
//            dateStr = [dateFormatter stringFromDate:[NSDate date]];
//            NSLog(@"現在時間=%@",dateStr);
        }
        
    }else{
        
        dateStr = [NSString stringWithFormat:@"%@ - %@",[dateArray firstObject],[dateArray lastObject]];
        
    }
    
    
    [self.delegate DidFinishLoadChartAndShowDate:dateStr];
    
    //***************************************************
    
}




-(CGFloat)convertRealY:(CGFloat)yValue
{
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
    
    //處理最低最高值，跑版問題。
    float dotWidth = 15/imgScale;
    float dotHeight = 15/imgScale;
    
    UIImageView *dotView = [[UIImageView alloc] initWithFrame:CGRectMake(chartLeftWidth+(xPointVal*xScaleSize)-dotWidth/2,chartTopWidth+(chartMaxValue-yPointVal)*yScaleSize-dotHeight/2, dotWidth, dotHeight)];

    
    if(yPointVal > normalVal && normalVal != 0){
        
//        UIImageView *dotView = [[UIImageView alloc] initWithFrame:CGRectMake(chartLeftWidth+(xPointVal*xScaleSize)-dotWidth/2,chartTopWidth+(chartMaxValue-yPointVal)*yScaleSize-dotHeight/2, dotWidth, dotHeight)];
        
        dotView.image = [UIImage imageNamed:@"overview_chart_a_dot_r"];
        
//        UILabel *dotLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//        dotLabel.font = [UIFont systemFontOfSize:8.0];
//        dotLabel.text = [NSString stringWithFormat:@"%.0f",yPointVal];
//        dotLabel.textColor = [UIColor redColor];
//        [dotLabel sizeToFit];
//        
//        dotLabel.frame = CGRectMake(normalDot.frame.origin.x, normalDot.frame.origin.y-dotLabel.frame.size.height, dotLabel.frame.size.width, dotLabel.frame.size.height);
//        [self addSubview:dotLabel];
//        [self addSubview:dotView];
        
    }
    else{
        
//        UIImageView *dotView = [[UIImageView alloc] initWithFrame:CGRectMake(chartLeftWidth+(xPointVal*xScaleSize)-dotWidth/2,chartTopWidth+(chartMaxValue-yPointVal)*yScaleSize-dotHeight/2, dotWidth, dotHeight)];
        
        dotView.image = [UIImage imageNamed:@"overview_chart_a_dot_b"];
        
//        [self addSubview:dotView];
    }
    [self addSubview:dotView];

    
}



#pragma mark - Touch Event  ***********************
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if (!indicatorMode) {
        return;
    }
    
    [self.delegate TouchBeginGraphView];
    
    CGPoint touchPoint = [[touches anyObject] locationInView:self];
    
    if (touchPoint.x > chartLeftWidth && touchPoint.x < self.frame.size.width- chartRightWidth) {
        
        [self showTouchedPointValue:touchPoint];
    }
    
    NSLog(@"Begin");
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if (!indicatorMode) {
        return;
    }
    
    CGPoint touchPoint = [[touches anyObject] locationInView:self];
    
    if (touchPoint.x > chartLeftWidth && touchPoint.x < self.frame.size.width- chartRightWidth) {
        
        [self showTouchedPointValue:touchPoint];
    }

}

-(void)showTouchedPointValue:(CGPoint)touchedPoint{
    
    if (chartDataArray.count == 0) {
        indicatorLine.hidden = YES;
        return;
    }
    
    indicatorLine.frame = CGRectMake(touchedPoint.x, indicatorLine.frame.origin.y, indicatorLine.frame.size.width, indicatorLine.frame.size.height);
    
    indicatorLine.hidden = NO;
    
    float dataMargin = (self.frame.size.width-chartLeftWidth-chartRightWidth)/dataCount;
    
    float index = (touchedPoint.x-chartLeftWidth)/dataMargin;
    
    int dataIndex = floor(index);
    
    if (dataIndex < chartDataArray.count ) {
        
        float floatVal = [[chartDataArray objectAtIndex:dataIndex] floatValue];
        
        if(self.chartType == 0 || self.chartType == 5){
            float secFloatVal = [[secGraphYData objectAtIndex:dataIndex] floatValue];
            
            if(self.chartType == 0){
               valueLabel.text = [NSString stringWithFormat:@"%.0f/%.0f",floatVal,secFloatVal];
            }else{
                valueLabel.text = [NSString stringWithFormat:@"%.1f/%.1f",floatVal,secFloatVal];
            }
            
        }else{
            if (self.chartType == 2){
                valueLabel.text = [NSString stringWithFormat:@"%.1f",floatVal];
            }else{
                valueLabel.text = [NSString stringWithFormat:@"%.0f",floatVal];
            }
        }
        
        NSString *dateStr = [NSString stringWithFormat:@"%@",[dateArray objectAtIndex:dataIndex]];
        NSLog(@"show dateStr:%@",dateStr);
        if (dateStr.length >= 5) {
            dateStr = [dateStr substringFromIndex:5];
        }
        
                             
        indicatorDate.text = dateStr;
        
    }
    else{
        
        valueLabel.text = @"";
    }
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    if (!indicatorMode) {
        return;
    }
    
    [self.delegate TouchEndGraphView];
    
    indicatorLine.hidden = YES;
    
    NSLog(@"End");
}


#pragma mark - Bezier
-(void)createBezierPath:(CGPoint)theFirstPoint secondPoint:(CGPoint)theSecondPoint {
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    bezierPath.lineWidth = 3.0;
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
