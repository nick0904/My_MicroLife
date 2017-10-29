//
//  HistoryPageView.h
//  Microlife
//
//  Created by Rex on 2016/7/27.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StatusCircleView.h"
#import "GraphView.h"
#import "HistoryListTableView.h"

@protocol HistoryPageViewDelegate <NSObject>


//圖表觸控偵測
-(void)GraphViewScrollBegin;
-(void)GraphViewScrollEnd;
//下方歷史列表
-(void)showListButtonTapped:(UIView *)btnSnapShot;


@end

@interface HistoryPageView : UIView<UIScrollViewDelegate,GraphViewDelegate>{
    
    
    float imgScale;
    UIView *segBase;
    UIScreen *screen;
    UISegmentedControl *topSegment;
    UILabel *timeLabel;
    UIButton *prevCurveBtn;
    UIButton *nextCurveBtn;
    UIView *absentBase;
    UIImageView *absentFace;
    UILabel *absentLabel;
    UIButton *showListBtn;
    NSUInteger dateSegIndex;
    NSUInteger typSegIndex;
    
    //泡泡框大小
    float circelSize;
    
    //血壓機按鈕
    UIButton *SYSBtn;
    UIButton *PULBtn;
    UIButton *BPTimeBtn;
    int BPCurveTime; //0=all 1=am 2=pm
    
    //體重計按鈕
    UIButton *weightBtn;
    UIButton *BMIBtn;
    UIButton *fatBtn;
    NSMutableArray *weightBtnAry;
    GraphView *chart;
    
    //體重狀態泡泡框
    StatusCircleView *weightCircle;
    StatusCircleView *lastTemp;
    StatusCircleView *avgTemp;
    
    //體溫按鈕
    NSMutableArray *nameBtnAry;
    
    StatusCircleView *BPCircle;
    StatusCircleView *PADCircle;
    StatusCircleView *AFIBCircle;
    StatusCircleView *LASTircle;

    NSInteger dateIntervalIndex0;
    NSInteger dateIntervalIndex1;
    NSInteger dateIntervalIndex2;
    NSInteger dateIntervalIndex3;

    int selectedEvent;
    NSMutableArray *eventArray;
    
    //
    float avgSYSValue;
    float avgDIAValue;
    int totalAFIB;
    int totalPAD;
    int BPDataNum;
    int ListDataNum;
    float avgSYSForListValue;
    float avgDIAForListValue;
    int totalMAM;
}

@property (nonatomic, strong) UIView *chartView;
@property (nonatomic, strong) UIScrollView *healthStatusScroll;
@property (nonatomic, strong) UIView *curveControlBase;
@property (nonatomic) int chartType;//0=BloodPressure 1=Weight 2=Temperature
@property (nonatomic) int viewType;//0=BloodPressure 1=Weight 2=Temperature

@property (strong,nonatomic) NSString *startTimeString;
@property (strong, nonatomic) NSString *endTimeString;


//設定時間segment
-(void)setSegment:(NSArray *)array;
//設定時間Label
-(void)setTimeLabelTitle:(NSString *)title;

//設定未測量日期
-(void)setAbsentDaysText:(NSString *)absentDays andFaceIcon:(UIImage *)iconImg;


//初始血壓功能按鈕
-(void)initBPCurveControlButton;
//初始體重功能按鈕
-(void)initWeightCurveControlButton;
//初始體溫功能按鈕
-(void)initTempCurveControlButton;
-(void)renderEventCircle;

//初始血壓泡泡框
-(void)initBPHealthCircle;
//初始體重泡泡框
-(void)initWeightHealthCircle;
//初始體溫泡泡框
-(void)initTempHealthCircle;


/**
 可用重繪圖表

 @param chartType graphViewType
 */
-(void)createChart:(int)chartType;


/**
 可用讀取歷史列表資料
 */
-(void)showListAction;

@property (weak)id<HistoryPageViewDelegate>delegate;

@end
