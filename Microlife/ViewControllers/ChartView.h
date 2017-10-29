//
//  ChartView.h
//  Microlife
//
//  Created by 曾偉亮 on 2017/1/23.
//  Copyright © 2017年 Rex. All rights reserved.
//

#import <UIKit/UIKit.h>

//CharViewDelegate  **********************
@protocol CharViewDelegate

-(void)touchBeginChartView;
-(void)touchEndChartView;
-(void)didFinishLoadChartAndShowDate:(NSString *)datString;

@end


// ChartView  **********************
@interface ChartView : UIView {
    
    float xScaleSize;
    float yScaleSize;
    float imgScale;
    float dataXLength; //資料X軸長度
    float dataYLength; //資料Y軸長度
    
    NSInteger dataRange;
    int dataCount;
}

@property (nonatomic) int chartType;

/**
圖表類型   0=SYS/IDAChart
          1=PULChart
          2=WeightChart
          3=BMIchart
          4=FATchart
          5=TempChart
*/

@property (nonatomic,strong) UILabel *graphUnitLabel;   //圖表單位

@property (nonatomic,strong) UILabel *lineIntroLabel;   //上方主線條提示文字
@property (nonatomic,strong) UIImageView *lineIntroImg; //目標值(室溫)提示圖片

@property (nonatomic,strong) UILabel *targetIntroLabel; //目標值(體溫)提示文字
@property (nonatomic,strong) UIImageView *targetIntroImg; //目標值(體溫)提示圖片

@property (nonatomic,strong) UILabel *normalIntroLabel; //正常值提示文字
@property (nonatomic,strong) UIImageView *normalIntroImg; //正常值提示圖片

@property (nonatomic,strong) UILabel *startTimeLabel;   //圖表結束時間
@property (nonatomic,strong) UILabel *endTimeLabel;     //圖表起始時間

@property (nonatomic) float normalValue; //正常值
@property (nonatomic) float secNormalValue; //第二正常值

@property (nonatomic) float targetValue; //目標值
@property (nonatomic) float secTargetValue; //第二目標值

@property (nonatomic) BOOL indicatorMode; //顯示指標線

@property (nonatomic) NSMutableArray *chartDataArray; //圖表資料

- (id)initWithFrame:(CGRect)frame withChartType:(int)type withDataCount:(int)count withDataRange:(NSInteger)range;

@property (weak) id<CharViewDelegate>delegate;

@end
