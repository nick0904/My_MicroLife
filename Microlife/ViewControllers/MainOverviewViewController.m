

#import "MainOverviewViewController.h"
#import "HealthEducationViewController.h"
#import "NotificationViewController.h"
#import "AboutViewController.h"
#import "LogoutViewController.h"
//#import "OverViewAddEventControllerViewController.h"
#import "OverViewEditEventViewController.h"
//pickerViews
//-------------------------------
//血壓
#import "BloodPressurePickerView.h"
#import "PULPickerView.h"
#import "TimePickerView.h"
#import "DatePickerView.h"

//體重
#import "WEIPickerView.h"
#import "BMIPickerView.h"
#import "FATPickerView.h"
//#import "SkeletonPickerView.h"
//#import "MusclePickerView.h"
//#import "BMRPickerView.h"
//#import "OrganFatPickerView.h"

//溫度
#import "OverViewTempAddView.h"
#import "BodyTempPickerView.h"
#import "RoomTempPickerView.h"


//circleView
//-------------------------------
#import "OverViewCircleView.h"


//TableViewCells
//--------------------------------
#import "OverBPTableViewCell.h"
#import "OverWeightTableViewCell.h"
#import "OverTempTableViewCell.h"

#import "GraphView.h"
#import "RainbowBarView.h"


//圖表
#import "GraphView.h"

//藍芽
#import "BLEDataHandler.h"
#import "SFCommonCalendar.h"

//Health Kit
#import "MyHealthStore.h"


//BTEvent 選擇事件
#import "BTEventSelector.h"



@interface MainOverviewViewController () <UITableViewDelegate,UITableViewDataSource,APIPostAndResponseDelegate,BTEventSelectorDelegate> {

    
    //擷取裝置時間
    //-----------------------------------
    NSTimer *getDateTimer;
    UILabel *timeLabel;
    
    //切割單位長度
    //-----------------------------------
    CGFloat unitHeight;
    

    //顯示 體溫-血壓-體重列表 (包含箭頭 及 list名稱)
    //-----------------------------------
    UIView *listView;
    UILabel *listLable;
    UIImageView *listArrowImg;
    UIButton *listBt;
    UIView *listSperatorView;
    BOOL isListAction;//顯示列表
    
    
    
    //overview scrollView
    //-----------------------------------
    UIScrollView *overView_scrollView;
    UIPageControl *page;
    
    
    //三個 overview scrollView 的 subViews
    UIView *bloodPressureView;
    UIView *weightView;
    UIView *bodyTemperatureView;
    
    
    //各頁大小圓
    //------------------------------------
    //bloodPressure
    OverViewCircleView *bloodPressureCircleView;
    OverViewCircleView *bloodPressureCircleSmallView;
    
    //weight
    OverViewCircleView *weightCircleView;
    OverViewCircleView *weightCircleSmallView;
    
    //bodyTemperature
    OverViewCircleView *bodyTemperatureCircleView;
    OverViewCircleView *bodyTemperatureCircleSmallView;
    
    
    //pickerViewvu相關
    //-----------------------------------
    UITextField *callBPPickerView;
    UITextField *callWEIPickerView;
    UITextField *callTempPickerView;
    
    //血壓
    //bloodPressure
    BloodPressurePickerView *bpPickerView;
    UIToolbar *bloodPressureToolBar;
    
    //pul
    PULPickerView *pulPickerView;
    UIToolbar *pulToolBar;
    
    
    //體重
    //wei
    WEIPickerView *weiPickerView;
    UIToolbar *weiToolBar;
    
    //bmi
    BMIPickerView *bmiPickerView;
    UIToolbar *bmiToolBar;
    
    //fat
    FATPickerView *fatPickerView;
    UIToolbar *fatToolBar;
    
    //skeleton
    //SkeletonPickerView *skeletonPickerView;
    //UIToolbar *skeletonToolBar;
    
    //muscle
    //MusclePickerView *musclePickerView;
    //UIToolbar *muscleToolBar;
    
    //BMR
    //BMRPickerView *bmrPickerView;
    UIToolbar *bmrToolBar;
    
    //OrganFat
    //OrganFatPickerView *organFatPickerView;
    //UIToolbar *organFatToolBar;
    
    
    //溫度
    //bodyTemp
    BodyTempPickerView *bodyTempPickerView;
    UIToolbar *bodyTempToolBar;
    
    //roomTemp
    UIToolbar *roomTempToolBar;
    RoomTempPickerView *roomTempPickerView;
    

    //time
    TimePickerView *timePickerView;

    UIToolbar *timeToolBar;
    UIToolbar *weightTimeToolBar;
    UIToolbar *tempTimeToolBar;
    
    //date
    DatePickerView *datePickerView;

    
    UIToolbar *dateToolBar;
    UIToolbar *weightDateToolBar;
    UIToolbar *tempDateToolBar;
    
    
    
    //各頁之曲線按鍵
    //---------------------------------
    //SYS/DIA 曲線按鍵
    UIButton *sysAndDiaCurveBt;
    //PUL 曲線按鍵
    UIButton *pulCurveBt;
    //bpRainbowBarBt
    UIButton *bpRainbowBarBt;
    BOOL isBPRainbowBarBtSelected;
    
    //WEI 曲線按鍵
    UIButton *weiCurveBt;
    //BMI 曲線按鍵
    UIButton *bmiCurveBt;
    //FAT 曲線按鍵
    UIButton *fatCurveBt;
    //weightRainbowBarBt
    UIButton *weightRainbowBarBt;
    BOOL isweightRainbowBarBtSelected;
    
    
    //PUL value and unit
    //----------------------------------
    UILabel *pulLabel;
    UIButton *pulValueBt;
    UILabel *pulUnitLabel;
    
    //Device model and status
    //----------------------------------
    UILabel *deviceModel;
    UILabel *deviceStatus;
    
    
    //BMI
    //----------------------------------
    UILabel *bmiLabel;
    UIButton *bmiValueBt;
    
    //BODY FAT
    //----------------------------------
    UILabel *bodyFatLabel;
    UILabel *bodyFatValueLabel;
    
    
    //UITableView
    UITableView *m_tableView;
    
    
    //產生模糊畫面
    //----------------------------------
    UIView *blurView;
    
    
    //RainbowBarView(彩虹Bar條)
    //----------------------------------
    RainbowBarView *rainbowViewForBp;
    RainbowBarView *rainbowViewForBMI;
    
    //OverviewAddEventView
    //----------------------------------
    OverViewTempAddView *addTempView;
    
    
    //圖表
    UIView *BPChartArea;
    UIView *tempChartArea;
    UIView *weightChartArea;
    
    GraphView *BPChartView;
    GraphView *weightChartView;
    GraphView *tempChartView;
    
    //0=歐規 1=USA 2=非歐,非USA
    int measureSpec;
    float BMIValue;
    
    NSMutableArray *eventArray;
    NSMutableArray *eventBtnArray;
    NSMutableArray *listDataArray;
    
    NSMutableArray *btnSnapAry;
    
    CGRect listViewFrame_close;
    
    BOOL isPrivacyMode;
    
    UIButton *editEventBtn;
    
    BOOL isSyncHealthKit;//是否與HealthKit同步
    MyHealthStore *healthStore;
    
    
    //Cloud
    APIPostAndResponse *apiClass;
    
    //BTEventSelector
    BTEventSelector *btEventSelector;
    
    NSDictionary *examinationDic;
    
}

#define LIST_BLOODPRESSSURE NSLocalizedString(@"YOUR BLOOD PRESSURE LISTS", nil)
#define LIST_WEIGHT NSLocalizedString(@"YOUR WEIGHT LISTS", nil)
#define LIST_BODYTEMP NSLocalizedString(@"YOUR BODY TEMPERATURE LISTS", nil)


@end

@implementation MainOverviewViewController

#pragma mark - Normal function ************************

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    [self initWithNavigationBar];
    
    [self initParameter];
    
    [self initWithScrollView];
    
    //初始化所有 ToolBars & BarButtonItems
    [self createAllToolBarsAndBarButtonItems];
    
    //初始化所有PickerView
    [self allPickerViewInit];
    
    self.isListBtEnable = YES;
    self.syncInformation = YES;
    
    //生成 血壓 - 體重 - 額溫 大小圓
    [self createBloodPressureCircle];
    [self createWeightCircle];
    [self createBodyTemperatureCircle];

    
    //生成curveBts & rainbow
    [self createSysDiaAndPulCurveBts];
    [self createWeiBmiFatCurveBts];
    
    
    //生成 PUL Label
    [self createPULLabel];
    [self createDeviceModelAndStatus];
    
    //生成 BMI Lable
    [self createBMILabel];
    [self createBodyFatLabel];
    
    
    //初始化 所有的callPickerViews
    [self createCallPickerViews];
    
    
    //m_tableView
    m_tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height - 44)];
    m_tableView.delegate = self;
    m_tableView.dataSource = self;
    //m_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    m_tableView.hidden = YES;
    m_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:m_tableView];
    
    
    
    //生成一個模糊畫面
    blurView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    blurView.backgroundColor = [UIColor darkGrayColor];
    blurView.alpha = 0.3;
    [self.tabBarController.view addSubview:blurView];
    blurView.hidden = YES;
    
    UITapGestureRecognizer *dismissKeyboardTap = [[UITapGestureRecognizer alloc]
                                                  initWithTarget:self
                                                  action:@selector(dismissKeyboard)];
    
    [blurView addGestureRecognizer:dismissKeyboardTap];
    
    
    //tempAdd Event View
    addTempView = [[OverViewTempAddView alloc] initWithTempAddViewFrame:CGRectMake(0, 0, bodyTemperatureView.frame.size.width, bodyTemperatureView.frame.size.height)];
    addTempView.hidden = NO;
    addTempView.m_superVC = self;
    [bodyTemperatureView addSubview:addTempView];
    
    
    //BLE
    BLEDataHandler *handler = [[BLEDataHandler alloc] init];
    
    [handler protocolStart];
    
    //生成圖表
    //[self initChart];
    
    //BLE
    [self addObserverForBLEHandler];
    
    //Button
    [sysAndDiaCurveBt setSelected:YES];
    [pulCurveBt setSelected:NO];
    bpRainbowBarBt.selected=NO;
    
    weiCurveBt.selected=YES;
    bmiCurveBt.selected=NO;
    fatCurveBt.selected=NO;
    weightRainbowBarBt.selected=NO;
    
    //healthKit init
    healthStore = [[MyHealthStore alloc] initHealthStore];
    healthStore.superVC = self;
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    //先判斷是privacy Or membership
    isPrivacyMode = [MViewController checkIsPrivacyModeOrMemberShip];
    NSString *str = isPrivacyMode == YES ? @"YES" : @"NO";
    NSLog(@"isPrivacyMode ==> %@",str);
    
    
    //檢查是否需要與HealthKit同步
    isSyncHealthKit = [MViewController checkIsSyncWithHealthKit];
    NSString *healthStr = isSyncHealthKit == YES ? @"YES" : @"NO";
    NSLog(@"isSyncHealthKit %@",healthStr);
    
    if (eventArray == nil) {
        
        eventArray = [[NSMutableArray alloc] init];
    }
    
    [eventArray removeAllObjects];
    eventArray = [[EventClass sharedInstance] selectAllData];
    
    [[LocalData sharedInstance] checkDefaultProfileData];
    
    if (eventBtnArray.count != 0) {
        
        for (int i=0; i<eventBtnArray.count; i++) {
            
            UIButton *btn = [eventBtnArray objectAtIndex:i];
            
            [btn removeFromSuperview];
            
        }
        
        [eventBtnArray removeAllObjects];
    }
    
    if (eventArray.count != 0) {
        
        [LocalData sharedInstance].currentEventIndex = 0;
        [LocalData sharedInstance].currentEventId = [[[eventArray objectAtIndex:0] objectForKey:@"eventID"] intValue];
        addTempView.hidden = YES;
        [self createEventCircleGroup];
    }
    else{
        addTempView.hidden = NO;
    }
    
    //getTimer 計時開始(navigationBar 顯示時間用)
    getDateTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(getDateAndTime) userInfo:nil repeats:YES];
    
    //生成圖表
    [self initChart];
    
    [self listBtEnable:self.isListBtEnable];
}

-(void)viewDidAppear:(BOOL)animated {
    
    NSLog(@"accountID:  %d",[LocalData sharedInstance].accountID);
  
}



-(void)viewDidDisappear:(BOOL)animated {
    
    //getDateTimer  停止
    [getDateTimer invalidate];
    getDateTimer = nil;
    
    if (editEventBtn != nil) {
        
        [editEventBtn removeFromSuperview];
        editEventBtn = nil;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



#pragma mark - initilization  **************************
//NavigationBar init
-(void)initWithNavigationBar {
    
    self.tabBarController.tabBar.tintColor = STANDER_COLOR;
    
    //***********  navigationController 相關初始化設定  **********
    //改變self.title 的字體顏色
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    //改變 navigationBar 的底色
    self.navigationController.navigationBar.barTintColor = STANDER_COLOR;
    
    //改變 statusBarStyle(字體變白色)
    //先將 info.plist 中的 View controller-based status bar appearance 設為 NO
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    //設定leftBarButtonItem(profileBt)
    UIButton *leftItemBt = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.navigationController.navigationBar.frame.size.height, self.navigationController.navigationBar.frame.size.height)];
    
    [leftItemBt setImage:[UIImage imageNamed:@"all_btn_a_menu"] forState:UIControlStateNormal];
    
    [leftItemBt addTarget:self action:@selector(profileBtAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftItemBt];
    
    //設定 titleView
    UIView *theTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.navigationController.navigationBar.frame.size.width/3, self.navigationController.navigationBar.frame.size.height)];
    
    theTitleView.backgroundColor = [UIColor clearColor];
    
    //titleLabel
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, theTitleView.frame.size.width, theTitleView.frame.size.height/3*2)];
    
    titleLabel.text = NSLocalizedString(@"Overview", nil);
    
    titleLabel.textColor = [UIColor whiteColor];
    
    titleLabel.adjustsFontSizeToFitWidth = YES;
    
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [theTitleView addSubview:titleLabel];
    
    //timeLabel
    timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame),titleLabel.frame.size.width*0.68, theTitleView.frame.size.height/3)];
    
    timeLabel.center = CGPointMake(theTitleView.center.x, theTitleView.frame.size.height/3*2);
    
    timeLabel.textColor = [UIColor whiteColor];
    
    timeLabel.adjustsFontSizeToFitWidth = YES;
    
    timeLabel.textAlignment = NSTextAlignmentCenter;
    
    [theTitleView addSubview:timeLabel];
    
    self.navigationItem.titleView = theTitleView;
    
}

//init Parameter
-(void)initParameter{
    
    eventBtnArray = [NSMutableArray new];
    listDataArray = [NSMutableArray new];
    btnSnapAry = [NSMutableArray new];
    
    
    eventArray = [[EventClass sharedInstance] selectAllData];
    
    measureSpec = [LocalData sharedInstance].measureSpec;
    
    BMIValue = 0;
    
    //設定初次進入index 與 eventID
    if (eventArray.count != 0) {
        
        [LocalData sharedInstance].currentEventIndex = 0;
        [LocalData sharedInstance].currentEventId = [[[eventArray objectAtIndex:0] objectForKey:@"eventID"] intValue];
    }
    
    //API
    apiClass = [[APIPostAndResponse alloc] initCloud];
    apiClass.delegate = self;

    
}


//ScrollView init
-(void)initWithScrollView {
    
    //******* listView & listBt & listLabel & listArrowImg *******
    //切九等份
    CGFloat statusHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    unitHeight = (self.view.frame.size.height - 44 - statusHeight - 49)/9;
    
    //listView
    listViewFrame_close=CGRectMake(0,SCREEN_HEIGHT-(44*3)-20, self.view.frame.size.width, 44);
    listView = [[UIView alloc] initWithFrame:listViewFrame_close];
    listView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:listView];
    
    //listArrowImg
    listArrowImg = [[UIImageView alloc] initWithFrame:CGRectMake(listView.frame.size.height/4, -5,listView.frame.size.height/2,listView.frame.size.height/2)];
    listArrowImg.center = CGPointMake(listView.center.x, listView.frame.size.height/4);
    listArrowImg.image = [UIImage imageNamed:@"all_icon_a_arrow_up"];
    [listView addSubview:listArrowImg];
    
    //listLabel
    listLable = [[UILabel alloc] initWithFrame:CGRectMake(0, listView.frame.size.height*0.25, SCREEN_WIDTH, listView.frame.size.height*0.75)];
    listLable.text = LIST_BLOODPRESSSURE;
    listLable.textAlignment = NSTextAlignmentCenter;
    listLable.textColor = TEXT_COLOR;
    listLable.adjustsFontSizeToFitWidth = YES;
    //listLable.font = [UIFont boldSystemFontOfSize:listLable.frame.size.height * 0.8];
    listLable.font = [UIFont boldSystemFontOfSize:14.0];
    [listView addSubview:listLable];
    

    //listBt
    listBt = [[UIButton alloc]initWithFrame:listView.frame];
    [listBt addTarget:self action:@selector(listBtAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:listBt];
    
    
    //listSperatorView
    listSperatorView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(listView.frame) - 2, self.view.frame.size.width, 1.0)];
    listSperatorView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:listSperatorView];
    
    
    //isListAction
    isListAction = NO;
    
    
    //*************  scrollView 初始設定  ************
    overView_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width,listViewFrame_close.origin.y)];
    //CGRectGetMinY(listSperatorView.frame) - CGRectGetMinY(overView_scrollView.frame)
    overView_scrollView.contentSize = CGSizeMake(self.view.frame.size.width * 3, overView_scrollView.frame.size.height);
    overView_scrollView.pagingEnabled = YES;
    overView_scrollView.delegate = self;
    overView_scrollView.showsHorizontalScrollIndicator = NO;
    overView_scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:overView_scrollView];
    
    
    //bloodPressureView
    //********************************
    bloodPressureView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, overView_scrollView.frame.size.height)];
    bloodPressureView.backgroundColor = [UIColor whiteColor];
    [overView_scrollView addSubview:bloodPressureView];
    
    
    //weightView
    //********************************
    weightView = [[UIView alloc] initWithFrame:CGRectMake(bloodPressureView.frame.size.width, 0, bloodPressureView.frame.size.width, overView_scrollView.frame.size.height)];
    weightView.backgroundColor = [UIColor whiteColor];
    [overView_scrollView addSubview:weightView];
    
    
    //bodyTemperatureView
    //********************************
    bodyTemperatureView = [[UIView alloc] initWithFrame:CGRectMake(bloodPressureView.frame.size.width * 2, 0, bloodPressureView.frame.size.width, overView_scrollView.frame.size.height)];
    bodyTemperatureView.backgroundColor = [UIColor whiteColor];
    [overView_scrollView addSubview:bodyTemperatureView];
    
    
    //***********  pageControl  *************
    page = [[UIPageControl alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(listSperatorView.frame) - 0.5*unitHeight, self.view.frame.size.width, 0.5*unitHeight)];
    page.pageIndicatorTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"all_dot_a_0"]];
    page.currentPageIndicatorTintColor = [UIColor grayColor];
    page.numberOfPages = 3;
    page.currentPage = 0;
    [self.view addSubview:page];

    
}



//圖表 初始化
-(void)initChart{
    
    //remove sub view
    //BPChartArea
    if(BPChartArea)
    {
        [BPChartArea removeFromSuperview];
    }
    
    //weightChartArea
    if(weightChartArea)
    {
        [weightChartArea removeFromSuperview];
    }
    
    //tempChartArea
    if(tempChartArea)
    {
        [tempChartArea removeFromSuperview];
    }
    
    CGFloat chart_h=(bloodPressureView.frame.size.height-CGRectGetMaxY(bpRainbowBarBt.frame) + bpRainbowBarBt.frame.size.height/2.0)-5;
    CGFloat chart_y=CGRectGetMaxY(bpRainbowBarBt.frame) + (bpRainbowBarBt.frame.size.height/2.0)+(IS_IPAD?-10:0);
    
    //Chart View
    BPChartArea = [[UIView alloc] initWithFrame:CGRectMake(0, chart_y, self.view.frame.size.width,chart_h)];
    //self.view.frame.size.width*0.6
    
    BPChartView = [[GraphView alloc] initWithFrame:CGRectMake(0, 0, BPChartArea.frame.size.width, BPChartArea.frame.size.height-page.frame.size.height) withChartType:0 withDataCount:14 withDataRange:14];
    [BPChartArea addSubview:BPChartView];
    
    [bloodPressureView addSubview:BPChartArea];
    
    
    
    weightChartArea = [[UIView alloc] initWithFrame:CGRectMake(0, chart_y, self.view.frame.size.width, chart_h)];
    
    weightChartView = [[GraphView alloc] initWithFrame:CGRectMake(0, 0, weightChartArea.frame.size.width, weightChartArea.frame.size.height-page.frame.size.height) withChartType:2 withDataCount:14 withDataRange:14];
    
    [weightView addSubview:weightChartArea];
    [weightChartArea addSubview:weightChartView];
    
    if (addTempView.hidden == YES) {
        tempChartArea = [[UIView alloc] initWithFrame:CGRectMake(0, chart_y, self.view.frame.size.width, chart_h)];
        
        tempChartView = [[GraphView alloc] initWithFrame:CGRectMake(0, 0, tempChartArea.frame.size.width, tempChartArea.frame.size.height-page.frame.size.height) withChartType:5 withDataCount:14 withDataRange:14];
        [bodyTemperatureView addSubview:tempChartArea];
        [tempChartArea addSubview:tempChartView];
    }
    
    [self.view bringSubviewToFront:listSperatorView];// listSperatorView
    
    NSLog(@"bpRainbowBarBt.selected==>%d",bpRainbowBarBt.selected);
    
    if(bpRainbowBarBt.selected)
    {
        isBPRainbowBarBtSelected=YES;
        [self bpRainbowBarBtAction:bpRainbowBarBt];
        
    }else{
        
        if(sysAndDiaCurveBt.selected)
        {
            [self sysDiaAndPulCurveBtAction:sysAndDiaCurveBt];
            
        }else if(pulCurveBt.selected){
            [self sysDiaAndPulCurveBtAction:pulCurveBt];
        }
    }
    
    if(weightRainbowBarBt.selected)
    {
        isweightRainbowBarBtSelected=YES;
        [self weightRainbowBarBtAction:weightRainbowBarBt];
        
    }else{
        
        if(weiCurveBt.selected)
        {
            [self weiBmiFatBtAction:weiCurveBt];
            
        }else if(bmiCurveBt.selected){
            
            [self weiBmiFatBtAction:bmiCurveBt];
            
        }else if(fatCurveBt.selected){
            
            [self weiBmiFatBtAction:fatCurveBt];
            
        }
    }
    
    
}


-(void)createChartWithType:(int)type{
    
    GraphView *chartView;
    
    if(type == 0 || type ==1){
        
        chartView = [[GraphView alloc] initWithFrame:CGRectMake(0, 0, BPChartArea.frame.size.width, BPChartArea.frame.size.height-page.frame.size.height) withChartType:type withDataCount:14 withDataRange:14];
        
        [BPChartView removeFromSuperview];
        BPChartView = chartView;
        [BPChartArea addSubview:BPChartView];
    }
    
    if(type == 2 || type == 3 || type == 4){
        
        chartView = [[GraphView alloc] initWithFrame:CGRectMake(0, 0, BPChartArea.frame.size.width, BPChartArea.frame.size.height-page.frame.size.height) withChartType:type withDataCount:14 withDataRange:14];
        
        [weightChartView removeFromSuperview];
        weightChartView = chartView;
        [weightChartArea addSubview:weightChartView];
    }
    
    if (type == 5) {
        
        chartView = [[GraphView alloc] initWithFrame:CGRectMake(0, 0, BPChartArea.frame.size.width, BPChartArea.frame.size.height-page.frame.size.height) withChartType:type withDataCount:4 withDataRange:4];
        
        [tempChartView removeFromSuperview];
        tempChartView = chartView;
        [tempChartArea addSubview:tempChartView];
    }
    
}


#pragma mark - BLE 監聽事件  **************************
//add Observer For BLE
-(void)addObserverForBLEHandler{
    
    //血壓
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveBPMMeasureData) name:@"receiveBPMData" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveBPMMeasureDataOnLine) name:@"receiveBPMDataOnLine" object:nil];

    //體重
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveWeightMeasureData) name:@"receiveWeightData" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveWeightMeasureDataOnLine) name:@"receiveWeightDataOnLine" object:nil];

    //額溫
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveTempMeasureData) name:@"receiveTempData" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveTempMeasureDataOnLine) name:@"receiveTempDataOnLine" object:nil];

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveALLData) name:@"receiveALLData" object:nil];

    
}

- (void)didReceiveALLData {
    NSLog(@"didReceiveALLData");

    if (eventArray == nil) {
        
        eventArray = [[NSMutableArray alloc] init];
    }
    
    [eventArray removeAllObjects];
    eventArray = [[EventClass sharedInstance] selectAllData];
    
    [[LocalData sharedInstance] checkDefaultProfileData];
    
    if (eventBtnArray.count != 0) {
        
        for (int i=0; i<eventBtnArray.count; i++) {
            
            UIButton *btn = [eventBtnArray objectAtIndex:i];
            
            [btn removeFromSuperview];
            
        }
        
        [eventBtnArray removeAllObjects];
    }
    
    if (eventArray.count != 0) {
        
        [LocalData sharedInstance].currentEventIndex = 0;
        [LocalData sharedInstance].currentEventId = [[[eventArray objectAtIndex:0] objectForKey:@"eventID"] intValue];
        addTempView.hidden = YES;
        [self createEventCircleGroup];
    }

    [self initChart];


}

- (void)didReceiveBPMMeasureDataOnLine {
    self.syncInformation = NO;
    [self didReceiveBPMMeasureData];
}
    
//BLE 血壓
-(void)didReceiveBPMMeasureData{
    
    int age = [LocalData sharedInstance].UserAge;
    int PULUnit = [LocalData sharedInstance].PULUnit;
    
    NSDictionary *latestBP = [[LocalData sharedInstance] getLatestMeasureValue];
    
    if ([self examinationIsEqualSaveData:latestBP]) {
        return;
    }else
    {
        NSLog(@"%@,latestBP:%@",self.syncInformation?@"YES":@"NO",latestBP);
        
        int SYS = [[latestBP objectForKey:@"SYS"] intValue];
        int DIA = [[latestBP objectForKey:@"DIA"] intValue];
        int PUL = [[latestBP objectForKey:@"PUL"] intValue];
        
        BOOL MAM = [[latestBP objectForKey:@"MAM"] boolValue];
        BOOL PAD = 0;
        BOOL AFIB =[[latestBP objectForKey:@"Arr"] boolValue];
        
        NSString *dateStr = [latestBP objectForKey:@"date"];
        
        NSLog(@"sys:%d\ndia:%d\npul:%d\nMAM:%@\nAFIB:%@",SYS,DIA,PUL,MAM?@"YES":@"NO",AFIB?@"YES":@"NO");
        
        NSLog(@"dateStr ==> %@",dateStr);
        
        if (self.syncInformation) {
            //API
            if (![CheckNetwork isExistenceNetwork]) {
                
                //無網路時
                [MViewController showAlert:NETWORK_TITLE message:NETWORK_MESSAGE buttonTitle:NETWORK_CONFIRM];
                return;
            }
            else {
                
                if ([LocalData sharedInstance].accountID != -1) {
                    
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        
                        NSString *tokenStr = [NSString stringWithContentsOfFile:OAuth_TOKEN encoding:NSUTF8StringEncoding error:nil];
                        
                        [apiClass postAddBPM:tokenStr user_id:@"123456789BP" sys:SYS dia:DIA pul:PUL bpm_id:BPM_Device_ID afib:[[latestBP objectForKey:@"Arr"] intValue] pad:0 man:[[latestBP objectForKey:@"MAM"] intValue] date:dateStr mac_address:nil];
                        
                    });
                    
                }
                
            }
        }else {
            self.syncInformation = YES;
        }
        
        
        //HealthKit
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            
            if (isSyncHealthKit) {
                
                [healthStore saveBloodPressureDataToHealthStore:SYS diaValue:DIA];
                [healthStore saveMeasureDataToHealthStore:healthKit_heartRate dataValue:PUL];
            }
        });

        
        weightCircleSmallView.alertRedImage.hidden = NO;
        bodyTemperatureCircleSmallView.alertRedImage.hidden = NO;
        bloodPressureCircleSmallView.alertRedImage.hidden = YES;
        
        UIImage *circleImg;
        UIColor *circleColor = STANDER_COLOR;
        
        
        bloodPressureCircleView.sys = SYS;
        bloodPressureCircleView.dia = DIA;
        
        if (SYS >= 135 || DIA >= 85) {
            //血壓異常
            circleColor = CIRCEL_RED;
            circleImg = IMAGE_HIGH_BP;
            
            if (age > 65 || age == -1) {
                bloodPressureCircleSmallView.alertRedImage.hidden = NO;
            }else{
                bloodPressureCircleSmallView.alertRedImage.hidden = YES;
            }
            
        }
        else{
            
            circleColor = STANDER_COLOR;
            circleImg = IMAGE_NORMAL_BP;
        }
        
        [pulValueBt setTitle:[NSString stringWithFormat:@"%d",PUL] forState:UIControlStateNormal];
        
        if (PULUnit == 0) {
            pulUnitLabel.text = @"bpm";
        }
        else{
            
            pulUnitLabel.text = @"bpm";
        }
        
        [bloodPressureCircleView setString];
        
        if (MAM) {
            
            if (PAD) {
                deviceStatus.textColor = CIRCEL_RED;
                deviceStatus.text = NSLocalizedString(@"Detected", nil);
                circleImg = IMAGE_PAD_OVERVIEW;
                
            }else{
                deviceStatus.textColor = TEXT_COLOR;
                deviceStatus.text = NSLocalizedString(@"Not Detected", nil);
            }
            
            if(AFIB){
                deviceStatus.textColor = CIRCEL_RED;
                deviceStatus.text = NSLocalizedString(@"Detected", nil);
                circleImg = IMAGE_AFIB_OVERVIEW;
                
                if (age > 65 || age == -1) {
                    bloodPressureCircleSmallView.alertRedImage.hidden = NO;
                }else{
                    bloodPressureCircleSmallView.alertRedImage.hidden = YES;
                }
                
            }else{
                deviceStatus.textColor = TEXT_COLOR;
                deviceStatus.text = NSLocalizedString(@"Not Detected", nil);
            }
            
        }else{
            deviceStatus.textColor = TEXT_COLOR;
            deviceStatus.text = NSLocalizedString(@"Off", nil);
        }
        
        bloodPressureCircleView.layer.borderColor = circleColor.CGColor;
        bloodPressureCircleSmallView.circleImgView.image = circleImg;
        bloodPressureCircleSmallView.layer.borderColor = circleColor.CGColor;
        
        [self createChartWithType:0];
    }
    
    
}

-(void)didReceiveWeightMeasureDataOnLine {
    self.syncInformation = NO;
    [self didReceiveWeightMeasureData];
}

//BLE 體重
-(void)didReceiveWeightMeasureData{
    
    NSLog(@"didReceiveWeightMeasureData");
    
    NSDictionary *latestWeight = [[LocalData sharedInstance] getLatestMeasureValue];
    
    if ([self examinationIsEqualSaveData:latestWeight]) {
        return;
    }else
    {
        NSLog(@"%@,latestWeight:%@",self.syncInformation?@"YES":@"NO",latestWeight);

        UIImage *circleImage = IMAGE_NORMAL_WEIGHT;
        UIColor *circleColor = STANDER_COLOR;
        weightCircleSmallView.alertRedImage.hidden = YES;
        
        float weight = [[latestWeight objectForKey:@"weight"] floatValue];
        BMIValue = [[latestWeight objectForKey:@"BMI"] floatValue];
        float bodyFat = [[latestWeight objectForKey:@"bodyFat"] floatValue];
        
        NSString *dateStr = [latestWeight objectForKey:@"date"];
        
        if (self.syncInformation) {
            //API
            if(![CheckNetwork isExistenceNetwork]) {
                //無網路時
                
                [MViewController showAlert:NETWORK_TITLE message:NETWORK_MESSAGE buttonTitle:NETWORK_CONFIRM];
                return;
            }
            else {
                
                if ([LocalData sharedInstance].accountID != -1) {
                    
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        
                        NSString *tokenStr = [NSString stringWithContentsOfFile:OAuth_TOKEN encoding:NSUTF8StringEncoding error:nil];
                        
                        [apiClass postAddWeightData:tokenStr weight_id:Weight_Device_ID weight:weight bmi:BMIValue body_fat:bodyFat water:70 skeleton:56 muscle:70 bmr:70 organ_fat:33 date:dateStr mac_address:nil];
                        
                    });
                    
                }
                
            }
        }else {
            self.syncInformation = YES;
        }
        
        //HealthKit
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            
            if (isSyncHealthKit) {
                
                [healthStore saveMeasureDataToHealthStore:healthKit_weight dataValue:weight];
                [healthStore saveMeasureDataToHealthStore:healthKit_BMI dataValue:BMIValue];
                [healthStore saveMeasureDataToHealthStore:healthKit_bodyFat dataValue:bodyFat/100];
            }
        });

        
        NSLog(@"bodyFat=>%f",bodyFat);
        
        int userArea = [LocalData sharedInstance].userArea;
        
        weightCircleView.weight = weight;
        //BMI
        //亞洲區：23 =0
        //非亞洲區：25 =1
        
        //FAT
        //男性：24%
        //女性：31%
        
        if (userArea == 0) {
            if (BMIValue >= 23) {
                
                circleImage = IMAGE_OVERWEIGHT;
                circleColor = CIRCEL_RED;
                weightCircleSmallView.alertRedImage.hidden = NO;
            }
        }else{
            if (BMIValue >= 25) {
                circleImage = IMAGE_OVERWEIGHT;
                circleColor = CIRCEL_RED;
                weightCircleSmallView.alertRedImage.hidden = NO;
            }
        }
        
        weightCircleSmallView.circleImgView.image = circleImage;
        
        
        weightCircleView.layer.borderColor = circleColor.CGColor;
        weightCircleSmallView.layer.borderColor = circleColor.CGColor;
        bodyFatValueLabel.text = [NSString stringWithFormat:@"%.1f%%",bodyFat];
        [bmiValueBt setTitle:[NSString stringWithFormat:@"%.1f",BMIValue] forState:UIControlStateNormal];
        [weightCircleView setString];
        
        [rainbowViewForBMI checkBMIValue:BMIValue];
        
        [self createChartWithType:2];
    }
    
    NSLog(@"didReceiveWeightMeasureData");
}

-(void)didReceiveTempMeasureDataOnLine {
    self.syncInformation = NO;
    [self didReceiveTempMeasureData];
}

//BLE 額溫
-(void)didReceiveTempMeasureData{
    
    NSDictionary *latestTemp = [[LocalData sharedInstance] getLatestMeasureValue];
    float bodyTemp = [[latestTemp objectForKey:@"bodyTemp"] floatValue];
    NSString *dateStr = [latestTemp objectForKey:@"date"];
    selectedEventID = [latestTemp objectForKey:@"selectedEventID"]?[[latestTemp objectForKey:@"selectedEventID"] intValue]:0;

    if ([self examinationIsEqualSaveData:latestTemp]) {
        return;
    }
    else
    {
        NSLog(@"%@,latestTemp:%@",self.syncInformation?@"YES":@"NO",latestTemp);
        //先跳出選擇事件 -----------------------
        //如果不選擇任何事件,則不存DataBase / 不同步雲端 / 不同步HealthKit
        if(bodyTemp == 0.0){
            return;
        }

        if (self.syncInformation) {
            if (selectedEventID == 0) {
                [self showBTEventSelector];
            }else {
                //API
                if (![CheckNetwork isExistenceNetwork]) {
                    //無網路時
                    [MViewController showAlert:NETWORK_TITLE message:NETWORK_MESSAGE buttonTitle:NETWORK_CONFIRM];
                    return;
                }
                else {
                    
                    if ([LocalData sharedInstance].accountID != -1) {
                        
                        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                            
                            ///event_code:流水號,第幾位
                            NSString *tokenStr = [NSString stringWithContentsOfFile:OAuth_TOKEN encoding:NSUTF8StringEncoding error:nil];
                            
                            [apiClass postAddBTData:tokenStr event_code:selectedEventID bt_id:Temp_Device_ID body_temp:bodyTemp room_temp:26 date:dateStr mac_address:nil];
                            
                        });
                        
                    }
                    
                }
            }
            
        }else {
            self.syncInformation = YES;
        }
        
        //HealthKit
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            
            if (isSyncHealthKit) {
                
                [healthStore saveMeasureDataToHealthStore:healthKit_bodyTemp dataValue:bodyTemp];
            }
        });
        
        //float roomTemp = [[latestTemp objectForKey:@"roomTemp"] floatValue];
        
        NSLog(@"bodyTemp ===== %f",bodyTemp);
        
        UIImage *circleImage = IMAGE_NORMAL_TEMP;
        UIColor *circleColor = STANDER_COLOR;
        
        bodyTemperatureCircleView.temp = bodyTemp;
        
        bodyTemperatureCircleSmallView.alertRedImage.hidden = YES;
        
        if (bodyTemp >= 37.5) {
            
            circleColor = CIRCEL_RED;
            circleImage = IMAGE_FEVER_OVERVIEW;
            bodyTemperatureCircleSmallView.alertRedImage.hidden = NO;
            
        }
        
        bodyTemperatureCircleSmallView.circleImgView.image = circleImage;
        bodyTemperatureCircleView.layer.borderColor = circleColor.CGColor;
        bodyTemperatureCircleSmallView.layer.borderColor = circleColor.CGColor;
        [bodyTemperatureCircleView setString];
        
        [self createChartWithType:5];
    }
    
}

-(BOOL)examinationIsEqualSaveData:(NSDictionary *)dic {
    if ([examinationDic isEqual:dic]) {
        NSLog(@"examinationIsEqualSaveData:相同資訊！！！");
        return YES;
    }else {
        NSLog(@"examinationIsEqualSaveData:新資訊！！！");
        examinationDic = dic;
        return NO;
    }
}



#pragma mark - 額溫計事件圓圈 ************************
-(void)createEventCircleGroup{
    
    float circleWidth = SCREEN_WIDTH*0.1;
    float circleHeight = SCREEN_WIDTH*0.1;
    
    [LocalData sharedInstance].currentEventId = [[[eventArray objectAtIndex:[LocalData sharedInstance].currentEventIndex] objectForKey:@"eventID"] intValue];
    
    //Nick Fix
    if (btnSnapAry.count > 0) {
        
        [btnSnapAry removeAllObjects];
    }
    
    
    for (int i=0; i<eventArray.count; i++) {
        
        UIButton *groupBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 10+((circleHeight+10)*i), circleWidth, circleHeight)];
        
        [groupBtn addTarget:self action:@selector(switchToAnotherPerson:) forControlEvents:UIControlEventTouchUpInside];
        
        groupBtn.tag = i+1;
        
        NSString *name = [[eventArray objectAtIndex:i] objectForKey:@"event"];
        
        name = [name substringToIndex:1];
        
        
        //先將圖片設定為編輯用樣式並截圖
        [groupBtn setTitle:name forState:UIControlStateNormal];
        [groupBtn setTitleColor:STANDER_COLOR forState:UIControlStateNormal];
        groupBtn.layer.borderWidth = 1.5;
        groupBtn.layer.cornerRadius = groupBtn.frame.size.width/2;
        groupBtn.layer.borderColor = STANDER_COLOR.CGColor;
        
        //儲存Button圖片供編輯使用
        [btnSnapAry addObject:[self snapShotView:groupBtn]];
        
        if (i == [LocalData sharedInstance].currentEventIndex) {
            [self setEventBtnIntoCircle:groupBtn withOnMode:YES buttonName:name];
            
        }else{
            [self setEventBtnIntoCircle:groupBtn withOnMode:NO buttonName:name];
        }
        
        
        [eventBtnArray addObject:groupBtn];
        [bodyTemperatureView addSubview:groupBtn];
        
    }
    
    //額溫編輯按鈕
    editEventBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 10+((circleHeight+10)*eventArray.count), circleWidth, circleHeight)];
    [editEventBtn setBackgroundImage:[UIImage imageNamed:@"overview_icon_a_ncfr_edit"] forState:UIControlStateNormal];
    [editEventBtn addTarget:self action:@selector(pushToEditEventVC) forControlEvents:UIControlEventTouchUpInside];
    [bodyTemperatureView addSubview:editEventBtn];
    
}

-(void)switchToAnotherPerson:(id)sender{
    
    NSInteger btnTag = [sender tag];
    
    BOOL isOn = NO;
    
    for (int i=0; i<eventBtnArray.count; i++) {
        
        UIButton *eventBtn = [eventBtnArray objectAtIndex:i];
        
        NSString *name = [[eventArray objectAtIndex:i] objectForKey:@"event"];
        
        name = [name substringToIndex:1];
        
        if (i+1 == btnTag) {
            
            isOn = YES;
            
            [LocalData sharedInstance].currentEventIndex = i;
            
            
            [LocalData sharedInstance].currentEventId = [[[eventArray objectAtIndex:i] objectForKey:@"eventID"] intValue];
            NSLog(@"[LocalData sharedInstance].currentEventId:%d",[LocalData sharedInstance].currentEventId);
        }else{
            
            isOn = NO;

        }
        
        [self setEventBtnIntoCircle:eventBtn withOnMode:isOn buttonName:name];
        
    }
    
    [self initChart];
    
}

-(void)setEventBtnIntoCircle:(UIButton *)button withOnMode:(BOOL)selected buttonName:(NSString *)name{
    
    UIColor *circleColor;
    UIColor *titleColor;
    UIColor *backgroundColor;
    
    if (selected) {
        circleColor = STANDER_COLOR;
        titleColor = [UIColor whiteColor];
        backgroundColor = STANDER_COLOR;
    }
    else{
        circleColor = TEXT_COLOR;
        titleColor = TEXT_COLOR;
        backgroundColor = [UIColor whiteColor];
    }

    
    button.layer.borderWidth = 1.5;
    button.layer.cornerRadius = button.frame.size.width/2;
    button.layer.borderColor = circleColor.CGColor;
    
    [button setTitle:name forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    [button setBackgroundColor:backgroundColor];
    
}

#pragma mark - 生成血壓計 - 體重計 - 額溫計 大小圓  ***************************
//生成 bloodPressure 大小圓
-(void)createBloodPressureCircle {
    
    //bloodPressure 藍色大圓
    CGFloat cy_w=self.view.frame.size.width/(IS_IPAD?1.88:1.88);
    CGFloat cy_h=cy_w;
    CGFloat cy_x=(SCREEN_WIDTH/2.0)-(cy_w/2.0);
    
    bloodPressureCircleView = [[OverViewCircleView alloc] initWithFrame:CGRectMake(cy_x, (IS_IPAD?60:23), cy_w, cy_h)];
    //bloodPressureCircleView.center = CGPointMake(bloodPressureView.frame.size.width/2, overView_scrollView.frame.size.height/3.88);
    [bloodPressureView addSubview:bloodPressureCircleView];
    
    bloodPressureCircleView.circleViewTitleString = NSLocalizedString(@"SYS/DIA", nil);
    bloodPressureCircleView.circleViewUnitString = @"mmHg";
    bloodPressureCircleView.device = 0; //0:血壓計
    bloodPressureCircleView.sys = 0;
    bloodPressureCircleView.dia = 0;
    [bloodPressureCircleView setString];
    
    
    //bloodPressure 藍色小圓
    bloodPressureCircleSmallView = [[OverViewCircleView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/8.6, self.view.frame.size.width/8.6)];
    bloodPressureCircleSmallView.center = CGPointMake(CGRectGetMidX(bloodPressureCircleView.frame), CGRectGetMinY(bloodPressureCircleView.frame)+bloodPressureCircleView.layer.borderWidth);
    bloodPressureCircleSmallView.layer.borderWidth = 2.0;
    bloodPressureCircleSmallView.backgroundColor = [UIColor whiteColor];
    bloodPressureCircleSmallView.circleImgView.image = [UIImage imageNamed:@"overview_icon_a_bpm"];
    [bloodPressureView addSubview:bloodPressureCircleSmallView];
    
}

//生成 weight 大小圓
-(void)createWeightCircle {
    
    //weight 藍色大圓
    CGFloat cy_w=self.view.frame.size.width/(IS_IPAD?1.88:1.88);
    CGFloat cy_h=cy_w;
    CGFloat cy_x=(SCREEN_WIDTH/2.0)-(cy_w/2.0);
    
    weightCircleView = [[OverViewCircleView alloc] initWithFrame:CGRectMake(cy_x, (IS_IPAD?60:23), cy_w, cy_h)];
    //weightCircleView.center = CGPointMake(weightView.frame.size.width/2, overView_scrollView.frame.size.height/3.88);
    [weightView addSubview:weightCircleView];
    
    weightCircleView.circleViewTitleString = NSLocalizedString(@"Weight", nil);
    weightCircleView.circleViewUnitString = @"kg";
    weightCircleView.device = 1; //1:體重計
    weightCircleView.weight = 0;
    [weightCircleView setString];
    
    
    
    //weight 藍色小圓
    weightCircleSmallView = [[OverViewCircleView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/8.6, self.view.frame.size.width/8.6)];
    weightCircleSmallView.center = CGPointMake(CGRectGetMidX(bloodPressureCircleView.frame), CGRectGetMinY(bloodPressureCircleView.frame)+weightCircleView.layer.borderWidth);
    weightCircleSmallView.layer.borderWidth = 2.0;
    weightCircleSmallView.backgroundColor = [UIColor whiteColor];
    weightCircleSmallView.circleImgView.image = [UIImage imageNamed:@"overview_icon_a_ws_b"];
    [weightView addSubview:weightCircleSmallView];
    
    
}

//生成 Temperature 大小圓
-(void)createBodyTemperatureCircle {
    
    //BodyTemperature藍色大圓
    CGFloat cy_w=self.view.frame.size.width/(IS_IPAD?1.88:1.88);
    CGFloat cy_h=cy_w;
    CGFloat cy_x=(SCREEN_WIDTH/2.0)-(cy_w/2.0);
    
    bodyTemperatureCircleView = [[OverViewCircleView alloc] initWithFrame:CGRectMake(cy_x, (IS_IPAD?60:23), cy_w, cy_h)];
    
    //bodyTemperatureCircleView.center = CGPointMake(bodyTemperatureView.frame.size.width/2, overView_scrollView.frame.size.height/3.88);
    [bodyTemperatureView addSubview:bodyTemperatureCircleView];
    
    bodyTemperatureCircleView.circleViewTitleString = NSLocalizedString(@"Body Temp.", nil);
    bodyTemperatureCircleView.circleViewUnitString = @"";
    bodyTemperatureCircleView.device = 2; //2:溫度計
    bodyTemperatureCircleView.temp = 0;
    [bodyTemperatureCircleView setString];
    
    
    //BodyTemperature藍色小圓
    bodyTemperatureCircleSmallView = [[OverViewCircleView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/8.6, self.view.frame.size.width/8.6)];
    bodyTemperatureCircleSmallView.center = CGPointMake(CGRectGetMidX(bloodPressureCircleView.frame), CGRectGetMinY(bloodPressureCircleView.frame)+bodyTemperatureCircleView.layer.borderWidth);
    bodyTemperatureCircleSmallView.layer.borderWidth = 2.0;
    bodyTemperatureCircleSmallView.backgroundColor = [UIColor whiteColor];
    bodyTemperatureCircleSmallView.circleImgView.image = [UIImage imageNamed:@"overview_icon_a_ncfr_b"];
    [bodyTemperatureView addSubview:bodyTemperatureCircleSmallView];
    
}



#pragma mark - create AllToolBars & BarButtonItems ************************
-(void)createAllToolBarsAndBarButtonItems {
    
    CGFloat toolBarWidth = self.view.frame.size.width;
    CGFloat toolBarHeight = self.view.frame.size.height/16;
    
    //**************  bloodPressureToolBar & bloodPressureToolBarBts  ***************
    //cancel
    UIBarButtonItem *toolBarCancelBt = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(toolBarCancelBtAction)];
    [toolBarCancelBt setTintColor:[UIColor darkGrayColor]];
    
    //sys
    UIBarButtonItem *sysBt = [[UIBarButtonItem alloc] initWithTitle:@"SYS" style:UIBarButtonItemStylePlain target:self action:nil];
    [sysBt setTintColor:[UIColor blackColor]];
    
    //dia
    UIBarButtonItem *diaBt = [[UIBarButtonItem alloc] initWithTitle:@"DIA" style:UIBarButtonItemStylePlain target:self action:nil];
    [diaBt setTintColor:[UIColor blackColor]];
    
    //Next
    UIBarButtonItem *nextBt = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(bpNextTopulBtAction)];
    
    //space
    UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    //bloodPressureToolBar
    bloodPressureToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, toolBarWidth, toolBarHeight)];
    
    [bloodPressureToolBar setItems:@[toolBarCancelBt,space,sysBt,space,diaBt,space,nextBt] animated:NO];
    
    
    
    //****************  pulToolBar & pulToolBarBts  ******************
    //back
    UIBarButtonItem *backTobpBt = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(pulBackTobpBtAction)];
    [backTobpBt setTintColor:[UIColor darkGrayColor]];
    
    //pul
    UIBarButtonItem *pulBt = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"PUL", nil) style:UIBarButtonItemStylePlain target:self action:nil];
    [pulBt setTintColor:[UIColor blackColor]];
    
    //nextToTimeBt
    UIBarButtonItem *nextToTimeBt = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(pulNextToTimeBtAction)];
    
    //pulToolbar
    pulToolBar = [[UIToolbar alloc] initWithFrame:bloodPressureToolBar.frame];
    [pulToolBar setItems:@[backTobpBt,space,pulBt,space,nextToTimeBt] animated:NO];
    
    
    //****************  timeToolBar & timeToolBarBts  *******************
    //timeBackToPulBt
    UIBarButtonItem *timeBackToPulBt = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(timeBackToPulBtAction)];
    [timeBackToPulBt setTintColor:[UIColor darkGrayColor]];
    
    
    //timeBt
    UIBarButtonItem *timeBt = [[UIBarButtonItem alloc] initWithTitle:@"TIME" style:UIBarButtonItemStylePlain target:self action:nil];
    [timeBt setTintColor:[UIColor blackColor]];
    
    
    //timeNextToDateBt
    UIBarButtonItem *timeNextToDateBt = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(timeNextToDateBtAction)];
    
    //timeToolBar
    timeToolBar = [[UIToolbar alloc] initWithFrame:bloodPressureToolBar.frame];
    [timeToolBar setItems:@[timeBackToPulBt,space,timeBt,space,timeNextToDateBt] animated:NO];
    
    
    //**********************  dateToolBar & dateToolBarBts  *********************
    //dateBackToTimeBt
    UIBarButtonItem *dateBackToTimeBt = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(dateBackToTimeBtAction)];
    [dateBackToTimeBt setTintColor:[UIColor darkGrayColor]];
    
    
    //dateBt
    UIBarButtonItem *dateBt = [[UIBarButtonItem alloc] initWithTitle:@"DATE" style:UIBarButtonItemStylePlain target:self action:nil];
    [dateBt setTintColor:[UIColor blackColor]];
    
    //toolBarSaveBt
    UIBarButtonItem *toolBarSaveBt = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(toolBarSaveBtAction)];
    
    //dateToolBar
    dateToolBar = [[UIToolbar alloc] initWithFrame:bloodPressureToolBar.frame];
    [dateToolBar setItems:@[dateBackToTimeBt,space,dateBt,space,toolBarSaveBt] animated:NO];
    
    
    //****************  weiToolBar & weiToolBarBts  ******************
    //Cancel
    UIBarButtonItem *weiToolBarCancelBt = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(weightCancelBtAction)];
    [weiToolBarCancelBt setTintColor:[UIColor darkGrayColor]];
    
    
    //wei
    UIBarButtonItem *weiBt = [[UIBarButtonItem alloc] initWithTitle:@"WEI" style:UIBarButtonItemStylePlain target:self action:nil];
    [weiBt setTintColor:[UIColor blackColor]];
    
    
    UIBarButtonItem *weiNextToBmiBt = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(weiNextToBmiBtAction)];
    
    
    //weiToolBar
    weiToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/16)];
    
    [weiToolBar setItems:@[weiToolBarCancelBt,space,weiBt,space,weiNextToBmiBt] animated:NO];
    
    
    //****************  bmiToolBar & bmiToolBarBts  ******************
    //bmiBackToWeiBt
    UIBarButtonItem *bmiBackToWeiBt = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(bmiBackToWeiBtAction)];
    [bmiBackToWeiBt setTintColor:[UIColor darkGrayColor]];
    
    
    //bmi
    UIBarButtonItem *bmiBt = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"BMI", nil) style:UIBarButtonItemStylePlain target:self action:nil];
    [bmiBt setTintColor:[UIColor blackColor]];
    
    //bmiNextToFatBt
    UIBarButtonItem *bmiNextToFatBt = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(bmiNextToFatBTAction)];
    
    //bmiToolBar
    bmiToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0,toolBarWidth, toolBarHeight)];
    [bmiToolBar setItems:@[bmiBackToWeiBt,space,bmiBt,space,bmiNextToFatBt] animated:NO];
    
    
    //****************  fatToolBar & fatToolBarBts  ******************
    //fatBacktoBmiBt
    UIBarButtonItem *fatBacktoBmiBt = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(fatBackToBmiBtAction)];
    [fatBacktoBmiBt setTintColor:[UIColor darkGrayColor]];
    
    //fatBt
    UIBarButtonItem *fatBt = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"FAT", nil) style:UIBarButtonItemStylePlain target:self action:nil];
    [fatBt setTintColor:[UIColor blackColor]];
    
    //fatNextToWeightTime
    UIBarButtonItem *fatNextToWeightTimeBt = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(fatNextToWeightTimeBtAction)];
    
    fatToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0,toolBarWidth, toolBarHeight)];
    [fatToolBar setItems:@[fatBacktoBmiBt,space,fatBt,space,fatNextToWeightTimeBt] animated:NO];
    
    
    //****************  weightTimeToolBar & weightTimeToolBarBts  ******************
    //weightTimeBackToFatBt
    UIBarButtonItem *weightTimeBackToFatBt = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(weightTimeBackTofatBtAction)];
    [weightTimeBackToFatBt setTintColor:[UIColor darkGrayColor]];
    
    //weightTimeBt
    UIBarButtonItem *weightTimeBt = [[UIBarButtonItem alloc] initWithTitle:@"TIME" style:UIBarButtonItemStylePlain target:self action:nil];
    [weightTimeBt setTintColor:[UIColor blackColor]];
    
    
    //weightTimeNextToDateBt
    UIBarButtonItem *weightTimeNextToDateBt = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(weightTimeNextToWeightDateBtAction)];
    
    
    //weightTimeToolBar
    weightTimeToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0,toolBarWidth,toolBarHeight)];
    [weightTimeToolBar setItems:@[weightTimeBackToFatBt,space,weightTimeBt,space,weightTimeNextToDateBt] animated:NO];
    
    
    //****************  weightDateToolBar & weightDateToolBarBts  ******************
    //weightDateBackToTimeBt
    UIBarButtonItem *weightDateBackToTimeBt = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(weightDateBackToWeightTimeBtAction)];
    [weightDateBackToTimeBt setTintColor:[UIColor darkGrayColor]];
    
    //weightDateBt
    UIBarButtonItem *weightDateBt = [[UIBarButtonItem alloc] initWithTitle:@"DATE" style:UIBarButtonItemStylePlain target:self action:nil];
    [weightDateBt setTintColor:[UIColor blackColor]];
    
    //weightSave
    UIBarButtonItem *weightSave = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(weightSaveBtAction)];
    
    
    //weightTimeToolBar
    weightDateToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, toolBarWidth, toolBarHeight)];
    [weightDateToolBar setItems:@[weightDateBackToTimeBt,space,weightDateBt,space,weightSave] animated:NO];
    
    
    
    //****************  bodyTempToolBar & bodyTempToolBarBts  **************
    //bodyTempCancelBt
    UIBarButtonItem *bodyTempCancelBt = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(bodyTempCancelBtAction)];
    [bodyTempCancelBt setTintColor:[UIColor darkGrayColor]];
    
    //bodyTempBt
    UIBarButtonItem *bodyTempBt = [[UIBarButtonItem alloc] initWithTitle:@"BODY TEMP" style:UIBarButtonItemStylePlain target:self action:nil];
    [bodyTempBt setTintColor:[UIColor blackColor]];
    
    //bodyTempNextToRoomTempBt
    UIBarButtonItem *bodyTempNextToRoomTempBt = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(bodyTempNextToRoomTempBtAction)];
    
    //bodyTempToolBar
    bodyTempToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, toolBarWidth, toolBarHeight)];
    [bodyTempToolBar setItems:@[bodyTempCancelBt,space,bodyTempBt,space,bodyTempNextToRoomTempBt] animated:NO];
    
    
    //****************  roomTempToolBar & roomTempToolBarBts  **************
    //roomTempBackToBodyTempBt
    UIBarButtonItem *roomTempBackToBodyTempBt = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(roomTempBackToBodyTempBtAction)];
    
    [roomTempBackToBodyTempBt setTintColor:[UIColor darkGrayColor]];
    
    //roomTempBt
    UIBarButtonItem *roomTempBt = [[UIBarButtonItem alloc] initWithTitle:@"ROOM TEMP" style:UIBarButtonItemStylePlain target:self action:nil];
    [roomTempBt setTintColor:[UIColor blackColor]];
    
    
    //roomTempNextToTempTimeBt
    UIBarButtonItem *roomTempNextToTempTimeBt = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(roomTempNextToTempTimeBtAction)];
    
    //roomTempToolBar
    roomTempToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, toolBarWidth, toolBarHeight)];
    [roomTempToolBar setItems:@[roomTempBackToBodyTempBt,space,roomTempBt,space,roomTempNextToTempTimeBt] animated:NO];
    
    
    //****************  tempTimeToolBar & tempTimeToolBarBts  **************
    //tempTimeBackToRoomTempBt
    UIBarButtonItem *tempTimeBackToRoomTempBt = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(tempTimeBackToRoomTempBtAction)];
    [tempTimeBackToRoomTempBt setTintColor:[UIColor darkGrayColor]];
    
    //tempTimeBt
    UIBarButtonItem *tempTimeBt = [[UIBarButtonItem alloc] initWithTitle:@"Time" style:UIBarButtonItemStylePlain target:self action:nil];
    [tempTimeBt setTintColor:[UIColor blackColor]];
    
    //tempTimeNextToTempDateBt
    UIBarButtonItem *tempTimeNextToTempDateBt = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(tempTimeNextToTempDateBtAction)];
    
    //tempTimeToolBar
    tempTimeToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, toolBarWidth, toolBarHeight)];
    [tempTimeToolBar setItems:@[tempTimeBackToRoomTempBt,space,tempTimeBt,space,tempTimeNextToTempDateBt] animated:NO];
    
    
    //****************  tempDateToolBar & tempDateToolBarBts  **************
    //tempDateBackToTempTimeBt
    UIBarButtonItem *tempDateBackToTempTimeBt = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(tempDateBackToTempTimeBtAction)];
    [tempDateBackToTempTimeBt setTintColor:[UIColor darkGrayColor]];
    
    //tempDateBt
    UIBarButtonItem *tempDateBt = [[UIBarButtonItem alloc] initWithTitle:@"DATE" style:UIBarButtonItemStylePlain target:self action:nil];
    [tempDateBt setTintColor:[UIColor blackColor]];
    
    //tempSaveBt
    UIBarButtonItem *tempSaveBt = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(tempSaveBtAction)];
    
    //tempDateToolBar
    tempDateToolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, toolBarWidth, toolBarHeight)];
    [tempDateToolBar setItems:@[tempDateBackToTempTimeBt,space,tempDateBt,space,tempSaveBt] animated:NO];
    
}



#pragma mark - create callPickerViews
//-------------------------------------
-(void)createCallPickerViews {
    
    //callBPPickerView (血壓計)
    callBPPickerView = [[UITextField alloc] initWithFrame:CGRectMake(0,0, bloodPressureView.frame.size.width/3, bloodPressureView.frame.size.width/3)];
    callBPPickerView.center = CGPointMake(bloodPressureView.frame.size.width/2, bloodPressureView.frame.size.height/4.5);
    callBPPickerView.backgroundColor = [UIColor clearColor];
    callBPPickerView.tintColor = [UIColor clearColor];
    [callBPPickerView addTarget:self action:@selector(callPickerViewAction) forControlEvents:UIControlEventEditingDidBegin];
    callBPPickerView.inputView = bpPickerView.m_pickerView;
    callBPPickerView.inputAccessoryView = bloodPressureToolBar;
    [bloodPressureView addSubview:callBPPickerView];
    
    //callWEIPickerView (體重計)
    callWEIPickerView = [[UITextField alloc] initWithFrame:CGRectMake(0,0, weightView.frame.size.width/3, weightView.frame.size.width/3)];
    callWEIPickerView.center = CGPointMake(weightView.frame.size.width/2, weightView.frame.size.height/4.5);
    callWEIPickerView.backgroundColor = [UIColor clearColor];
    callWEIPickerView.tintColor = [UIColor clearColor];
    [callWEIPickerView addTarget:self action:@selector(callPickerViewAction) forControlEvents:UIControlEventEditingDidBegin];
    callWEIPickerView.inputView = weiPickerView.m_pickerView;
    callWEIPickerView.inputAccessoryView = weiToolBar;
    [weightView addSubview:callWEIPickerView];

    
    
    //callTEMPPickerView (溫度計)
    callTempPickerView = [[UITextField alloc] initWithFrame:CGRectMake(0,0, bodyTemperatureView.frame.size.width/3, bodyTemperatureView.frame.size.width/3)];
    callTempPickerView.center = CGPointMake(bodyTemperatureView.frame.size.width/2, bodyTemperatureView.frame.size.height/4.5);
    callTempPickerView.backgroundColor = [UIColor clearColor];
    callTempPickerView.tintColor = [UIColor clearColor];
    [callTempPickerView addTarget:self action:@selector(callPickerViewAction) forControlEvents:UIControlEventEditingDidBegin];
    
    callTempPickerView.inputView = bodyTempPickerView.m_pickerView;
    callTempPickerView.inputAccessoryView = bodyTempToolBar;
    
    [bodyTemperatureView addSubview:callTempPickerView];

}



#pragma  mark - bloodPressure - SYS/DIA curveBt and PULcurveBt
//--------------------------------------------------------------
-(void)createSysDiaAndPulCurveBts {
    
    CGFloat btWidth = self.view.frame.size.width/4.5;
    CGFloat btHeight = self.view.frame.size.width/12;
    
    //SYS/DIA curveBt
    sysAndDiaCurveBt = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, btWidth, btHeight)];
    sysAndDiaCurveBt.center = CGPointMake(bloodPressureView.frame.size.width/2 - sysAndDiaCurveBt.frame.size.width/1.8, bloodPressureView.frame.size.height/(IS_IPAD ? 1.7 : 1.9));
    [sysAndDiaCurveBt setTitle:NSLocalizedString(@"SYS/DIA", nil) forState:UIControlStateNormal];
    [sysAndDiaCurveBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    if(!IS_IPAD)
        [sysAndDiaCurveBt.titleLabel setFont:[UIFont systemFontOfSize:12]];
     
    [sysAndDiaCurveBt setBackgroundImage:[UIImage imageNamed:@"all_btn_a_1"] forState:UIControlStateNormal];
    [sysAndDiaCurveBt addTarget:self action:@selector(sysDiaAndPulCurveBtAction:) forControlEvents:UIControlEventTouchUpInside];
    [bloodPressureView addSubview:sysAndDiaCurveBt];
    
    //PULcurveBt
    pulCurveBt = [[UIButton alloc]initWithFrame:CGRectMake(0, 0,btWidth, btHeight)];
    pulCurveBt.center = CGPointMake(bloodPressureView.frame.size.width/2 + pulCurveBt.frame.size.width/1.8,sysAndDiaCurveBt.center.y);
    [pulCurveBt setTitle:NSLocalizedString(@"PUL", nil) forState:UIControlStateNormal];
    [pulCurveBt setTitleColor:STANDER_COLOR forState:UIControlStateNormal];
    [pulCurveBt setBackgroundImage:[UIImage imageNamed:@"all_btn_a_0"] forState:UIControlStateNormal];
    [pulCurveBt addTarget:self action:@selector(sysDiaAndPulCurveBtAction:) forControlEvents:UIControlEventTouchUpInside];
    
    if(!IS_IPAD) {
        
         [pulCurveBt.titleLabel setFont:[UIFont systemFontOfSize:12]];
    }
    
    [bloodPressureView addSubview:pulCurveBt];
    
    
    //bpRainbowBarBt
    bpRainbowBarBt = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, btHeight, btHeight)];
    bpRainbowBarBt.center = CGPointMake(bloodPressureView.frame.size.width - bpRainbowBarBt.frame.size.width, pulCurveBt.center.y);
    [bpRainbowBarBt setBackgroundImage:[UIImage imageNamed:@"overview_btn_a_bar_0"] forState:UIControlStateNormal];
    [bpRainbowBarBt addTarget:self action:@selector(bpRainbowBarBtAction:) forControlEvents:UIControlEventTouchUpInside];
    isBPRainbowBarBtSelected = NO;
    [bloodPressureView addSubview:bpRainbowBarBt];
    
    
    CGFloat chart_oriPoint_y = CGRectGetMaxY(bpRainbowBarBt.frame) + (bpRainbowBarBt.frame.size.height/2.0)+(IS_IPAD ? - 10 : 0);
    //CGFloat chartView_size_h = CGRectGetMinY(page.frame) - chart_oriPoint_y;
    
    CGFloat chart_size_h = (bloodPressureView.frame.size.height-CGRectGetMaxY(bpRainbowBarBt.frame) + bpRainbowBarBt.frame.size.height/2.0)-5;
   
    //rainbowViewForBp
    //rainbowViewForBp = [[RainbowBarView alloc] initWithRainbowView:CGRectMake(0, CGRectGetMaxY(bpRainbowBarBt.frame) + bpRainbowBarBt.frame.size.height/2, self.view.frame.size.width, self.view.frame.size.width*0.6)];
    rainbowViewForBp = [[RainbowBarView alloc] initWithRainbowView:CGRectMake(0, chart_oriPoint_y, self.view.frame.size.width, chart_size_h)];
    [rainbowViewForBp checkRainbowbarValue:measureSpec sys:bloodPressureCircleView.sys dia:bloodPressureCircleView.dia];
    [bloodPressureView addSubview:rainbowViewForBp];
    rainbowViewForBp.hidden = YES;
    
    
    
}


#pragma mark - sysDia and pul CurveBt Action
-(void)sysDiaAndPulCurveBtAction:(UIButton *)sender {
    
    isBPRainbowBarBtSelected = NO;
    
    [bpRainbowBarBt setBackgroundImage:[UIImage imageNamed:@"overview_btn_a_bar_0"] forState:UIControlStateNormal];
    
    if (sender == sysAndDiaCurveBt) {
        
        [sysAndDiaCurveBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [sysAndDiaCurveBt setBackgroundImage:[UIImage imageNamed:@"all_btn_a_1"] forState:UIControlStateNormal];
        
        [pulCurveBt setTitleColor:STANDER_COLOR forState:UIControlStateNormal];
        [pulCurveBt setBackgroundImage:[UIImage imageNamed:@"all_btn_a_0"] forState:UIControlStateNormal];
        
        [sysAndDiaCurveBt setSelected:YES];
        [pulCurveBt setSelected:NO];
        bpRainbowBarBt.selected=NO;
        
        [self createChartWithType:0];
        
    }
    else if (sender == pulCurveBt) {
        
        [sysAndDiaCurveBt setTitleColor:STANDER_COLOR forState:UIControlStateNormal];
        [sysAndDiaCurveBt setBackgroundImage:[UIImage imageNamed:@"all_btn_a_0"] forState:UIControlStateNormal];
        
        [pulCurveBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [pulCurveBt setBackgroundImage:[UIImage imageNamed:@"all_btn_a_1"] forState:UIControlStateNormal];
        
        
        [self createChartWithType:1];
        
        [sysAndDiaCurveBt setSelected:NO];
        [pulCurveBt setSelected:YES];
        bpRainbowBarBt.selected=NO;
    }
    
    BPChartView.hidden = NO;
    rainbowViewForBp.hidden = YES;
    isBPRainbowBarBtSelected = NO;
}

-(void)sysDiaAndPulCurveBtOff
{
    [sysAndDiaCurveBt setTitleColor:STANDER_COLOR forState:UIControlStateNormal];
    [sysAndDiaCurveBt setBackgroundImage:[UIImage imageNamed:@"all_btn_a_0"] forState:UIControlStateNormal];
    
    [pulCurveBt setTitleColor:STANDER_COLOR forState:UIControlStateNormal];
    [pulCurveBt setBackgroundImage:[UIImage imageNamed:@"all_btn_a_0"] forState:UIControlStateNormal];
}

#pragma mark - bloodPressure RainbowBarBt Action
-(void)bpRainbowBarBtAction:(UIButton *)sender {
    
    //isBPRainbowBarBtSelected = isBPRainbowBarBtSelected == YES ? NO : YES;
    
    if (rainbowViewForBp.hidden || isBPRainbowBarBtSelected) {
        
        [bpRainbowBarBt setBackgroundImage:[UIImage imageNamed:@"overview_btn_a_bar_1"] forState:UIControlStateNormal];
        
        [rainbowViewForBp checkRainbowbarValue:measureSpec sys:bloodPressureCircleView.sys dia:bloodPressureCircleView.dia];
        
        BPChartView.hidden = YES;
        
        rainbowViewForBp.hidden = NO;
        
        bpRainbowBarBt.selected=YES;
        
        isBPRainbowBarBtSelected=NO;
        
    }
    else {
        
        
        [bpRainbowBarBt setBackgroundImage:[UIImage imageNamed:@"overview_btn_a_bar_0"] forState:UIControlStateNormal];
        
        BPChartView.hidden = NO;
        
        rainbowViewForBp.hidden = YES;
        
        bpRainbowBarBt.selected=NO;
    }
    
}



#pragma mark - WEI BMI FAT CurveBT
//---------------------------------
-(void)createWeiBmiFatCurveBts {
    
    CGFloat btWidth = self.view.frame.size.width/4.5;
    CGFloat btHeight = self.view.frame.size.width/12;
    
    //BMI CurveBt
    bmiCurveBt = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, btWidth, btHeight)];
    bmiCurveBt.center = CGPointMake(weightView.frame.size.width/2, weightView.frame.size.height/(IS_IPAD?1.7:1.9));
    [bmiCurveBt setBackgroundImage:[UIImage imageNamed:@"all_btn_a_0"] forState:UIControlStateNormal];
    [bmiCurveBt setTitleColor:STANDER_COLOR forState:UIControlStateNormal];
    [bmiCurveBt setTitle:NSLocalizedString(@"BMI", nil) forState:UIControlStateNormal];
    [bmiCurveBt addTarget:self action:@selector(weiBmiFatBtAction:) forControlEvents:UIControlEventTouchUpInside];
    
    if(!IS_IPAD)
        [bmiCurveBt.titleLabel setFont:[UIFont systemFontOfSize:12]];
    
    [weightView addSubview:bmiCurveBt];
    
    
    //WEI CurveBt
    weiCurveBt = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, btWidth,btHeight)];
    weiCurveBt.center = CGPointMake(bmiCurveBt.center.x - 1.1*btWidth, bmiCurveBt.center.y);
    [weiCurveBt setTitle:@"WEI" forState:UIControlStateNormal];
    [weiCurveBt setBackgroundImage:[UIImage imageNamed:@"all_btn_a_1"] forState:UIControlStateNormal];
    [weiCurveBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [weiCurveBt addTarget:self action:@selector(weiBmiFatBtAction:) forControlEvents:UIControlEventTouchUpInside];
    
    if(!IS_IPAD)
        [weiCurveBt.titleLabel setFont:[UIFont systemFontOfSize:12]];
    
    [weightView addSubview:weiCurveBt];
    
    //FAT CurveBt
    fatCurveBt = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, btWidth, btHeight)];
    fatCurveBt.center = CGPointMake(bmiCurveBt.center.x + 1.1*btWidth, bmiCurveBt.center.y);
    [fatCurveBt setTitle:NSLocalizedString(@"FAT", nil) forState:UIControlStateNormal];
    [fatCurveBt setTitleColor: STANDER_COLOR forState:UIControlStateNormal];
    [fatCurveBt setBackgroundImage:[UIImage imageNamed:@"all_btn_a_0"] forState:UIControlStateNormal];
    [fatCurveBt addTarget:self action:@selector(weiBmiFatBtAction:) forControlEvents:UIControlEventTouchUpInside];
    
    if(!IS_IPAD)
        [fatCurveBt.titleLabel setFont:[UIFont systemFontOfSize:12]];
    
    [weightView addSubview:fatCurveBt];
    
    
    //weight rainbowBarBt
    weightRainbowBarBt = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, btHeight, btHeight)];
    weightRainbowBarBt.center = CGPointMake(weightView.frame.size.width - weightRainbowBarBt.frame.size.width, fatCurveBt.center.y);
    [weightRainbowBarBt setBackgroundImage:[UIImage imageNamed:@"overview_btn_a_bar_0"] forState:UIControlStateNormal];
    [weightRainbowBarBt addTarget:self action:@selector(weightRainbowBarBtAction:) forControlEvents:UIControlEventTouchUpInside];
    isweightRainbowBarBtSelected = NO;
    [weightView addSubview:weightRainbowBarBt];
    
    
    //rainbowViewForBp
    CGFloat chart_y=CGRectGetMaxY(bpRainbowBarBt.frame) + (bpRainbowBarBt.frame.size.height/2.0)+(IS_IPAD?-10:0);
    CGFloat chartView_size_h = CGRectGetMinY(page.frame) - chart_y;
   // CGFloat chart_h=(bloodPressureView.frame.size.height-CGRectGetMaxY(bpRainbowBarBt.frame) + bpRainbowBarBt.frame.size.height/2.0)-5;
    //rainbowViewForBMI = [[RainbowBarView alloc] initWithRainbowView:CGRectMake(0, CGRectGetMaxY(weightRainbowBarBt.frame) + weightRainbowBarBt.frame.size.height/2, self.view.frame.size.width, self.view.frame.size.width*0.6)];
    rainbowViewForBMI = [[RainbowBarView alloc] initWithRainbowView:CGRectMake(0, chart_y, self.view.frame.size.width,chartView_size_h)];
    [rainbowViewForBMI checkBMIValue:BMIValue];
    [weightView addSubview:rainbowViewForBMI];
    rainbowViewForBMI.hidden = YES;

}

#pragma WEI BMI FAT curveBt Action
-(void)weiBmiFatBtAction:(UIButton *)sender {
    
    isweightRainbowBarBtSelected = NO;
    
    [weightRainbowBarBt setBackgroundImage:[UIImage imageNamed:@"overview_btn_a_bar_0"] forState:UIControlStateNormal];
    
    if (sender == weiCurveBt) {
        
        [weiCurveBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [weiCurveBt setBackgroundImage:[UIImage imageNamed:@"all_btn_a_1"] forState:UIControlStateNormal];
        
        [bmiCurveBt setTitleColor: STANDER_COLOR forState:UIControlStateNormal];
        [bmiCurveBt setBackgroundImage:[UIImage imageNamed:@"all_btn_a_0"] forState:UIControlStateNormal];
        
        [fatCurveBt setTitleColor:STANDER_COLOR forState:UIControlStateNormal];
        [fatCurveBt setBackgroundImage:[UIImage imageNamed:@"all_btn_a_0"] forState:UIControlStateNormal];
        
        [self createChartWithType:2];
        
        weiCurveBt.selected=YES;
        bmiCurveBt.selected=NO;
        fatCurveBt.selected=NO;
        weightRainbowBarBt.selected=NO;
        
        
    }
    else if (sender == bmiCurveBt) {
        
        [weiCurveBt setTitleColor:STANDER_COLOR forState:UIControlStateNormal];
        [weiCurveBt setBackgroundImage:[UIImage imageNamed:@"all_btn_a_0"] forState:UIControlStateNormal];
        
        [bmiCurveBt setTitleColor: [UIColor whiteColor] forState:UIControlStateNormal];
        [bmiCurveBt setBackgroundImage:[UIImage imageNamed:@"all_btn_a_1"] forState:UIControlStateNormal];
        
        [fatCurveBt setTitleColor:STANDER_COLOR forState:UIControlStateNormal];
        [fatCurveBt setBackgroundImage:[UIImage imageNamed:@"all_btn_a_0"] forState:UIControlStateNormal];
        
        [self createChartWithType:3];
        
        weiCurveBt.selected=NO;
        bmiCurveBt.selected=YES;
        fatCurveBt.selected=NO;
        weightRainbowBarBt.selected=NO;
    }
    else if (sender == fatCurveBt) {
        
        [weiCurveBt setTitleColor:STANDER_COLOR forState:UIControlStateNormal];
        [weiCurveBt setBackgroundImage:[UIImage imageNamed:@"all_btn_a_0"] forState:UIControlStateNormal];
        
        [bmiCurveBt setTitleColor:STANDER_COLOR forState:UIControlStateNormal];
        [bmiCurveBt setBackgroundImage:[UIImage imageNamed:@"all_btn_a_0"] forState:UIControlStateNormal];
        
        [fatCurveBt setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
        [fatCurveBt setBackgroundImage:[UIImage imageNamed:@"all_btn_a_1"] forState:UIControlStateNormal];
        
        [self createChartWithType:4];
        
        weiCurveBt.selected=NO;
        bmiCurveBt.selected=NO;
        fatCurveBt.selected=YES;
        weightRainbowBarBt.selected=NO;
    }
    
    weightChartView.hidden = NO;
    rainbowViewForBMI.hidden = YES;
    isBPRainbowBarBtSelected = NO;
}

#pragma mark - weight RainbowBarBt Action
-(void)weightRainbowBarBtAction:(UIButton *)sender {
    
    //isweightRainbowBarBtSelected = isweightRainbowBarBtSelected == YES ? NO : YES;
    
    if (rainbowViewForBMI.hidden || isweightRainbowBarBtSelected) {
        
        [weightRainbowBarBt setBackgroundImage:[UIImage imageNamed:@"overview_btn_a_bar_1"] forState:UIControlStateNormal];
        
        [rainbowViewForBMI checkBMIValue:BMIValue];
        
        weightChartView.hidden = YES;
        rainbowViewForBMI.hidden = NO;
        
        weightRainbowBarBt.selected=YES;
        isweightRainbowBarBtSelected=NO;
    }
    else {
        
        [weightRainbowBarBt setBackgroundImage:[UIImage imageNamed:@"overview_btn_a_bar_0"] forState:UIControlStateNormal];
        
        weightChartView.hidden = NO;
        rainbowViewForBMI.hidden = YES;
        
        weightRainbowBarBt.selected=NO;
    }
    
}


#pragma mark - PUL Label
//---------------------------------------------------
-(void)createPULLabel {
    
    CGFloat labelWidth = self.view.frame.size.width/8;
    CGFloat labelHeight = self.view.frame.size.width/16;
    
    //pulLabel
    pulLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, labelWidth, labelHeight)];
    pulLabel.center = CGPointMake(bloodPressureView.frame.size.width/6, bloodPressureView.frame.size.height/2.8);
    pulLabel.textAlignment = NSTextAlignmentCenter;
    pulLabel.text = NSLocalizedString(@"PUL", nil);
    [bloodPressureView addSubview:pulLabel];
    
    //pulValueBt
    pulValueBt = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(pulLabel.frame), CGRectGetMaxY(pulLabel.frame), labelWidth*2, labelWidth)];
    pulValueBt.center = CGPointMake(pulLabel.center.x, pulLabel.center.y+pulLabel.frame.size.height/2+pulValueBt.frame.size.height/2);
    [pulValueBt setTitle:@"--" forState:UIControlStateNormal];
    [pulValueBt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    pulValueBt.titleLabel.font = [UIFont systemFontOfSize:pulValueBt.frame.size.height*0.88];
    pulValueBt.titleLabel.adjustsFontSizeToFitWidth = YES;
    [bloodPressureView addSubview:pulValueBt];
    
    //pulUnitLabel
    pulUnitLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(pulLabel.frame), CGRectGetMaxY(pulValueBt.frame), labelWidth, labelHeight)];
    pulUnitLabel.textAlignment = NSTextAlignmentCenter;
    pulUnitLabel.text = @"bpm";
    [bloodPressureView addSubview:pulUnitLabel];
}


#pragma mark - Device Model and Device Status
-(void)createDeviceModelAndStatus {
    
    CGFloat labelWidth = self.view.frame.size.width/8;
    CGFloat labelHeight = self.view.frame.size.height/16;
    CGFloat labelLongWidth = self.view.frame.size.width/4;
    
    //deviceModel
    deviceModel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, labelWidth, labelHeight)];
    deviceModel.center = CGPointMake(bloodPressureView.frame.size.width/7*6, bloodPressureView.frame.size.height/2.8);
    deviceModel.textAlignment = NSTextAlignmentCenter;
    deviceModel.text = @"AFIB";
    [bloodPressureView addSubview:deviceModel];
    
    //deviceStatus
    deviceStatus = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, labelLongWidth, labelHeight)];
    deviceStatus.center = CGPointMake(deviceModel.center.x, pulValueBt.center.y);
    deviceStatus.textAlignment = NSTextAlignmentCenter;
    deviceStatus.textColor = TEXT_COLOR;
    deviceStatus.text = @"Off";
    deviceStatus.adjustsFontSizeToFitWidth = YES;
    [bloodPressureView addSubview:deviceStatus];
}

#pragma mark - BMI Label
-(void)createBMILabel {
    
    CGFloat labelWidth = self.view.frame.size.width/8;
    CGFloat labelHeight = self.view.frame.size.height/16;
    
    //BMI Label
    bmiLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, labelWidth, labelHeight)];
    bmiLabel.center = CGPointMake(weightView.frame.size.width/6, weightView.frame.size.height/2.8);
    bmiLabel.text = NSLocalizedString(@"BMI", nil);
    bmiLabel.textAlignment = NSTextAlignmentCenter;
    bmiLabel.adjustsFontSizeToFitWidth = YES;
    [weightView addSubview:bmiLabel];
    
    //bmiValueBt
    bmiValueBt = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(bmiLabel.frame), CGRectGetMaxY(bmiLabel.frame), labelWidth*2, labelWidth)];
    bmiValueBt.center = CGPointMake(bmiLabel.center.x, bmiLabel.center.y+bmiLabel.frame.size.height/2+bmiValueBt.frame.size.height/2);
    [bmiValueBt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [bmiValueBt setTitle:@"--" forState:UIControlStateNormal];
    bmiValueBt.titleLabel.font = [UIFont systemFontOfSize:bmiValueBt.frame.size.height*0.88];
    bmiValueBt.titleLabel.adjustsFontSizeToFitWidth = YES;
    [weightView addSubview:bmiValueBt];
    
}


#pragma mark - Body Fat Label
-(void)createBodyFatLabel {
    
    CGFloat labelWidth = self.view.frame.size.width/8;
    CGFloat labelHeight = self.view.frame.size.height/16;

    //bodyFatLabel
    bodyFatLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, labelWidth*2, labelHeight)];
    bodyFatLabel.center =  CGPointMake(weightView.frame.size.width/7*6, weightView.frame.size.height/2.8);
    bodyFatLabel.textAlignment = NSTextAlignmentCenter;
    bodyFatLabel.text = NSLocalizedString(@"Body Fat", nil);
    bodyFatLabel.adjustsFontSizeToFitWidth = YES;
    [weightView addSubview:bodyFatLabel];
    
    //bodyFatValueLabel
    bodyFatValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, labelWidth*2, labelWidth)];
    bodyFatValueLabel.center = CGPointMake(bodyFatLabel.center.x, bodyFatLabel.center.y+bodyFatLabel.frame.size.height/2+bodyFatValueLabel.frame.size.height/2);
    bodyFatValueLabel.textAlignment = NSTextAlignmentCenter;
    bodyFatValueLabel.text = @"--";
    bodyFatValueLabel.font = [UIFont systemFontOfSize:bodyFatValueLabel.frame.size.height*0.75];
    [weightView addSubview:bodyFatValueLabel];
    
}


#pragma mark - 所有 pickerView 初始化
//---------------------------------------------------
-(void)allPickerViewInit {
    
    CGFloat pickerViewWidth = self.view.frame.size.width;
    CGFloat pickerViewHeight = self.view.frame.size.height/3;
    
    //BloodPressure
    bpPickerView = [[BloodPressurePickerView alloc] initWithbloodPressurePickerViewFrame:CGRectMake(0, 0, pickerViewWidth, pickerViewHeight)];
    
    //Pul
    pulPickerView = [[PULPickerView alloc] initWithpulPIckerView:CGRectMake(0, 0, pickerViewWidth, pickerViewHeight)];
    
    //Time
    timePickerView = [[TimePickerView alloc] initWithTimePickerViewFrame:CGRectMake(0, 0, pickerViewWidth, pickerViewHeight)];
    
    //Date
    datePickerView = [[DatePickerView alloc] initWithDatePickerViewFrame:CGRectMake(0, 0, pickerViewWidth, pickerViewHeight)];
    
    //weight *******************
    //WEI
    weiPickerView = [[WEIPickerView alloc] initWithWeiPickerView:CGRectMake(0, 0, pickerViewWidth, pickerViewHeight)];
    
    //BMI
    bmiPickerView = [[BMIPickerView alloc] initWithBMIPickerView:CGRectMake(0, 0, pickerViewWidth, pickerViewHeight)];

    
    //FAT
    fatPickerView = [[FATPickerView alloc] initWithFATPickerView:CGRectMake(0, 0, pickerViewWidth, pickerViewHeight)];
    
    
    //Skeleton
    //skeletonPickerView = [[SkeletonPickerView alloc] initWithSkeletonPickerView:CGRectMake(0, 0, pickerViewWidth, pickerViewHeight)];
    
    //Muscle
    //musclePickerView = [[MusclePickerView alloc] initWithMusclePickerView:CGRectMake(0, 0, pickerViewWidth, pickerViewHeight)];
    
    //BMR
    //bmrPickerView = [[BMRPickerView alloc] initWithBMRPickerView:CGRectMake(0, 0, pickerViewWidth, pickerViewHeight)];
    
    //OrganFat
    //organFatPickerView = [[OrganFatPickerView alloc] initWithOrganFatPickerView:CGRectMake(0, 0, pickerViewWidth, pickerViewHeight)];
    
    

    //Temp  *********************
    //BodyTemp
    bodyTempPickerView = [[BodyTempPickerView alloc] initWithBodyTempPickerView:CGRectMake(0, 0, pickerViewWidth, pickerViewHeight)];
    
    //RoomTemp
    roomTempPickerView = [[RoomTempPickerView alloc] initWithRoomTempPickerView:CGRectMake(0, 0, pickerViewWidth, pickerViewHeight)];
    
    
}


#pragma mark - profileBtAction (導覽列左邊按鍵方法)
//----------------------------------------------
-(void)profileBtAction {
    
    [self SidebarBtn];
}


#pragma mark - listBtAction (顯示 tableView)
//------------------------------------------
-(void)listBtAction:(UIButton *)sender {
    
    isListAction = isListAction == YES ? NO : YES;
    
    if (isListAction == YES) {
        
        switch (page.currentPage) {
            case 0:
                listDataArray = [[BPMClass sharedInstance] selectDataForList:14 count:14];
                break;
            case 1:
                listDataArray = [[WeightClass sharedInstance] selectDataForList:14 count:14];
                break;
            case 2:
                listDataArray = [[BTClass sharedInstance] selectDataForList:4 count:4];
                break;
            default:
                break;
        }
        
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        
        self.tabBarController.tabBar.hidden = YES;
        
        listView.frame = CGRectMake(0, 5, listView.frame.size.width, listView.frame.size.height-5);
        
        listBt.frame = listView.frame;
        
        listArrowImg.image = [UIImage imageNamed:@"all_icon_a_arrow_down"];
        
        listSperatorView.hidden = YES;
        
        m_tableView.hidden = NO;
        
        [self.view bringSubviewToFront:listView];
        [self.view bringSubviewToFront:listBt];
        
        overView_scrollView.hidden = YES;
        

        [m_tableView reloadData];
    }
    else {
        
        listView.frame =listViewFrame_close;
        
        //CGRectMake(0,unitHeight*8.4, listView.frame.size.width, listView.frame.size.height);
        
        listBt.frame = listView.frame;
        
        listArrowImg.image = [UIImage imageNamed:@"all_icon_a_arrow_up"];
        
        listSperatorView.hidden = NO;
        
        m_tableView.hidden = YES;
        
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        
        self.tabBarController.tabBar.hidden = NO;
        
        overView_scrollView.hidden = NO;
        
        overView_scrollView.contentSize = CGSizeMake(self.view.frame.size.width * 3, overView_scrollView.frame.size.height-60.0);
        
    }
    
}


#pragma mark -  取得裝置目前時間
//---------------------------
-(void)getDateAndTime {
    
    NSDate *date = [NSDate date];
    NSTimeInterval now = [date timeIntervalSinceNow];
    NSDate *currentDate = [[NSDate alloc]initWithTimeIntervalSinceNow:now];
    
    //年月日
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    NSString *dateStr = [dateFormatter stringFromDate:currentDate];
    
    //時分
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc]init];
    [timeFormatter setDateFormat:@"HH:mm"];
    NSString *timeStr = [timeFormatter stringFromDate:currentDate];
    
    //串接Date + at
    NSString *strAt = [dateStr stringByAppendingString:@" at "];
    
    //串接Date at + time
    NSString *finalStr = [strAt stringByAppendingString:timeStr];
    
    timeLabel.text = finalStr;
}


#pragma mark - scrollView Delegate
//--------------------------------
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (scrollView == overView_scrollView) {
        
        int currentPage = (int)(round(scrollView.contentOffset.x / scrollView.frame.size.width)) + 1;
        
        switch (currentPage) {
            case 1:
                listLable.text = LIST_BLOODPRESSSURE;
                page.currentPage = 0;
                [self listBtEnable:YES];
                break;
            case 2:
                listLable.text = LIST_WEIGHT;
                page.currentPage = 1;
                [self listBtEnable:YES];
                break;
            case 3:
                listLable.text = LIST_BODYTEMP;
                page.currentPage = 2;
                self.isListBtEnable = addTempView.isHidden == YES ? YES : NO;
                [self listBtEnable:self.isListBtEnable];
                break;
            default:
                break;
        }
    }
    
}

-(void)listBtEnable:(BOOL)enable {
    
    listSperatorView.hidden = !enable;
    listLable.hidden = !enable;
    listArrowImg.hidden = !enable;
    listBt.userInteractionEnabled = enable;

}

//pickerView自定方法
-(void)showSelectedRowInPickerView:(UIPickerView *)pickerView atRow:(NSInteger)row inComponet:(NSInteger)component{
    
    [pickerView selectRow:row inComponent:component animated:YES];
}

#pragma mark - toolBarBtActions ************************
//---------------------------------------------------------------
//bloodPressure
-(void)toolBarCancelBtAction {
    
    blurView.hidden = YES;
    [callBPPickerView resignFirstResponder];
    callBPPickerView.inputView = bpPickerView.m_pickerView;
    callBPPickerView.inputAccessoryView = bloodPressureToolBar;

}

-(void)bpNextTopulBtAction {

    NSLog(@"Next.Bp");
    
    NSLog(@"Sys:%d",bpPickerView.bpSys);
    NSLog(@"Dia:%d",bpPickerView.bpDia);
    NSLog(@"Unit:%@",bpPickerView.bpUnit);
    if (bpPickerView.bpSys > bpPickerView.bpDia) {
        [callBPPickerView resignFirstResponder];
        callBPPickerView.inputView = pulPickerView.m_pickerView;
        callBPPickerView.inputAccessoryView = pulToolBar;
        [callBPPickerView becomeFirstResponder];
    }else {
        [MViewController showAlert:NETWORK_TITLE message:@"SYS or DIA Numerical error!" buttonTitle:NETWORK_CONFIRM];
    }
    
}


//pul
-(void)pulBackTobpBtAction {
    
    [callBPPickerView resignFirstResponder];
    callBPPickerView.inputView = bpPickerView.m_pickerView;
    callBPPickerView.inputAccessoryView = bloodPressureToolBar;
    [callBPPickerView becomeFirstResponder];
}


-(void)pulNextToTimeBtAction {
    
    NSLog(@"Pul:%d",pulPickerView.bpPul);
    NSLog(@"Unit:%@",pulPickerView.bpPulUnit);
    
    [callBPPickerView resignFirstResponder];
    callBPPickerView.inputView = timePickerView.m_pickerView;
    callBPPickerView.inputAccessoryView = timeToolBar;
    [callBPPickerView becomeFirstResponder];
}


//bp time
-(void)timeBackToPulBtAction {
    
    [callBPPickerView resignFirstResponder];
    callBPPickerView.inputView = pulPickerView.m_pickerView;
    callBPPickerView.inputAccessoryView = pulToolBar;
    [callBPPickerView becomeFirstResponder];
}


-(void)timeNextToDateBtAction {
    
    NSLog(@"Time:%@",timePickerView.m_pickerView.date);
    
    [callBPPickerView resignFirstResponder];
    callBPPickerView.inputView = datePickerView.m_pickerView;
    callBPPickerView.inputAccessoryView = dateToolBar;
    [callBPPickerView becomeFirstResponder];
}

//bp date
-(void)dateBackToTimeBtAction {
    
    [callBPPickerView resignFirstResponder];
    callBPPickerView.inputView = timePickerView.m_pickerView;
    callBPPickerView.inputAccessoryView = timeToolBar;
    [callBPPickerView becomeFirstResponder];
    
}

-(void)toolBarSaveBtAction {
    
    [self SaveBPToDataBase];
    
    NSLog(@"Date:%@",datePickerView.m_pickerView.date);
    
    [callBPPickerView resignFirstResponder];
    
    blurView.hidden = YES;
    
    NSLog(@"Save");    
    
}

-(void)SaveBPToDataBase
{
    //=====save data to DB=====
    self.syncInformation = YES;
    NSLog(@"SaveBPToDataBase");
    
    NSDate *bpDate=datePickerView.m_pickerView.date;
    NSDate *bpTime=timePickerView.m_pickerView.date;
    
    NSString *bpDateString=[SFCommonCalendar DateToStringByFormate:bpDate formate:@"yyyy-MM-dd"];
    NSString *bpTimeString=[SFCommonCalendar DateToStringByFormate:bpTime formate:@"HH:mm"];
    
    NSString *date = [NSString stringWithFormat:@"%@ %@",bpDateString,bpTimeString];
    
    NSLog(@"Sys:%d",bpPickerView.bpSys);
    NSLog(@"Dia:%d",bpPickerView.bpDia);
    NSLog(@"Unit:%@",bpPickerView.bpUnit);
    
    NSLog(@"Pul:%d",pulPickerView.bpPul);
    NSLog(@"Unit:%@",pulPickerView.bpPulUnit);
        
        [BPMClass sharedInstance].accountID = [LocalData sharedInstance].accountID;
        [BPMClass sharedInstance].SYS = bpPickerView.bpSys;
        [BPMClass sharedInstance].DIA = bpPickerView.bpDia;
        [BPMClass sharedInstance].PUL = pulPickerView.bpPul;
        //目前裝置無法支援PAD量測
        [BPMClass sharedInstance].PAD = 0;
        [BPMClass sharedInstance].AFIB = 0;//curMdata.arr;
        [BPMClass sharedInstance].date = date;
        [BPMClass sharedInstance].BPM_PhotoPath = @"";
        [BPMClass sharedInstance].BPM_Note = @"";
        [BPMClass sharedInstance].BPM_RecordingPath = @"";
        [BPMClass sharedInstance].MAM = 0;//curMdata.MAM;
        
        [[BPMClass sharedInstance] insertData];
        
        NSLog(@"BPMClass insert data = %@", [[BPMClass sharedInstance] selectAllData]);
        NSDictionary *latestBP = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  [NSString stringWithFormat:@"%d",bpPickerView.bpSys],@"SYS",
                                  [NSString stringWithFormat:@"%d",bpPickerView.bpDia],@"DIA",
                                  [NSString stringWithFormat:@"%d",pulPickerView.bpPul],@"PUL",
                                  date,@"date",
                                  /*[NSString stringWithFormat:@"%d",curMdata.arr]*/@"0",@"Arr",
                                  /*[NSString stringWithFormat:@"%d",curMdata.MAM]*/@"0",@"MAM",
                                  nil];
        
    [[LocalData sharedInstance] saveLatestMeasureValue:latestBP];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"receiveBPMData" object:nil];
    
}


-(void)callPickerViewAction {
    
    NSLog(@"callPickerViewAction");
    
    //show BP View
    if(blurView.hidden)
    {
            switch (page.currentPage) {
                case 0:
                {
                    callBPPickerView.inputView = bpPickerView.m_pickerView;
                    callBPPickerView.inputAccessoryView = bloodPressureToolBar;
                    [callBPPickerView becomeFirstResponder];
                }
                    break;
                case 1:
                {
                    callWEIPickerView.inputView = weiPickerView.m_pickerView;
                    callWEIPickerView.inputAccessoryView = weiToolBar;
                    [callWEIPickerView becomeFirstResponder];
                }
                    break;
                case 2:
                {
                    callTempPickerView.inputView = bodyTempPickerView.m_pickerView;
                    callTempPickerView.inputAccessoryView = bodyTempToolBar;
                    [callTempPickerView becomeFirstResponder];
                }
                    break;
                default:
                    break;
            }
    }
    
    blurView.hidden = NO;
    
}


//weight Cancel  *****************
-(void)weightCancelBtAction {
    
    blurView.hidden = YES;
    [callWEIPickerView resignFirstResponder];
    callWEIPickerView.inputView = weiPickerView.m_pickerView;
    callWEIPickerView.inputAccessoryView = weiToolBar;
    
}

//wei nextTo bmi
-(void)weiNextToBmiBtAction {
    
    [callWEIPickerView resignFirstResponder];
    callWEIPickerView.inputView = bmiPickerView.m_pickerView;
    callWEIPickerView.inputAccessoryView = bmiToolBar;
    [callWEIPickerView becomeFirstResponder];
    
}

//bmi backTo wei
-(void)bmiBackToWeiBtAction {
    
    [callWEIPickerView resignFirstResponder];
    callWEIPickerView.inputView = weiPickerView.m_pickerView;
    callWEIPickerView.inputAccessoryView = weiToolBar;
    [callWEIPickerView becomeFirstResponder];
}

//bmi nextTo Fat
-(void)bmiNextToFatBTAction {
    
    [callWEIPickerView resignFirstResponder];
    callWEIPickerView.inputView = fatPickerView.m_pickerView;
    callWEIPickerView.inputAccessoryView = fatToolBar;
    [callWEIPickerView becomeFirstResponder];
    
}

//fat backTo bmi
-(void)fatBackToBmiBtAction {
    
    [callWEIPickerView resignFirstResponder];
    callWEIPickerView.inputView = bmiPickerView.m_pickerView;
    callWEIPickerView.inputAccessoryView = bmiToolBar;
    [callWEIPickerView becomeFirstResponder];
    
}

//fat nextTo Time
-(void)fatNextToWeightTimeBtAction {
    
    [callWEIPickerView resignFirstResponder];
    callWEIPickerView.inputView = timePickerView.m_pickerView;
    callWEIPickerView.inputAccessoryView = weightTimeToolBar;
    [callWEIPickerView becomeFirstResponder];
    
}

//weightTime backTo fat
-(void)weightTimeBackTofatBtAction {
    
    [callWEIPickerView resignFirstResponder];
    callWEIPickerView.inputView = fatPickerView.m_pickerView;
    callWEIPickerView.inputAccessoryView = fatToolBar;
    [callWEIPickerView becomeFirstResponder];
    
}

//weightTime nextTo weightDate
-(void)weightTimeNextToWeightDateBtAction {
    
    [callWEIPickerView resignFirstResponder];
    callWEIPickerView.inputView = datePickerView.m_pickerView;
    callWEIPickerView.inputAccessoryView = weightDateToolBar;
    [callWEIPickerView becomeFirstResponder];
}

//weightDate backTo weightTime
-(void)weightDateBackToWeightTimeBtAction {
    
    [callWEIPickerView resignFirstResponder];
    callWEIPickerView.inputView = timePickerView.m_pickerView;
    callWEIPickerView.inputAccessoryView = weightTimeToolBar;
    [callWEIPickerView becomeFirstResponder];
}

//weight save
-(void)weightSaveBtAction {
    
    NSLog(@"weightSaveBtAction");
    
    [self SaveWeightToDataBase];
    
    blurView.hidden = YES;
    [callWEIPickerView resignFirstResponder];
    callWEIPickerView.inputView = weiPickerView.m_pickerView;
    callWEIPickerView.inputAccessoryView = weiToolBar;
    
}

-(void)SaveWeightToDataBase
{
    self.syncInformation = YES;

    NSLog(@"SaveWeightToDataBase");
    
    NSDate *bpDate=datePickerView.m_pickerView.date;
    NSDate *bpTime=timePickerView.m_pickerView.date;
    
    NSString *bpDateString=[SFCommonCalendar DateToStringByFormate:bpDate formate:@"yyyy-MM-dd"];
    NSString *bpTimeString=[SFCommonCalendar DateToStringByFormate:bpTime formate:@"HH:mm"];
    
    NSString *date = [NSString stringWithFormat:@"%@ %@",bpDateString,bpTimeString];
    
    NSLog(@"Weight:%f",weiPickerView.weightValue);
    NSLog(@"Weight unit:%@",weiPickerView.weightUnit);
    
    [WeightClass sharedInstance].accountID = [LocalData sharedInstance].accountID;
    [WeightClass sharedInstance].weight = weiPickerView.weightValue;
    [WeightClass sharedInstance].date = date;
    [WeightClass sharedInstance].water = 0;
    [WeightClass sharedInstance].bodyFat = fatPickerView.fatValue;
    [WeightClass sharedInstance].muscle = 0;
    [WeightClass sharedInstance].skeleton = 0;
    [WeightClass sharedInstance].BMI = bmiPickerView.bmiValue;
    [WeightClass sharedInstance].BMR = 0;
    [WeightClass sharedInstance].organFat = 0;
    [WeightClass sharedInstance].weight_PhotoPath = @"";
    [WeightClass sharedInstance].weight_Note = @"";
    [WeightClass sharedInstance].weight_RecordingPath = @"";
    
    [[WeightClass sharedInstance] insertData];
    
    
    NSDictionary *latestWeight = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  [NSString stringWithFormat:@"%.1f",weiPickerView.weightValue],@"weight",
                                  [NSString stringWithFormat:@"%.1f",fatPickerView.fatValue],@"bodyFat",
                                  [NSString stringWithFormat:@"%.1f",bmiPickerView.bmiValue],@"BMI",
                                  date,@"date",
                                  nil];
    
    [[LocalData sharedInstance] saveLatestMeasureValue:latestWeight];
    
    NSLog(@"主頁。。latestWeight = %@",latestWeight);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"receiveWeightData" object:nil];

    
}



//bodytemp cancel  *******************
-(void)bodyTempCancelBtAction {
    
    blurView.hidden = YES;
    [callTempPickerView resignFirstResponder];
    callTempPickerView.inputView = bodyTempPickerView.m_pickerView;
    callTempPickerView.inputAccessoryView = bodyTempToolBar;
}

//bodyTemp NextTo RoomTemp
-(void)bodyTempNextToRoomTempBtAction {
    
    [callTempPickerView resignFirstResponder];
    callTempPickerView.inputView = roomTempPickerView.m_pickerView;
    callTempPickerView.inputAccessoryView = roomTempToolBar;
    [callTempPickerView becomeFirstResponder];
}

//roomTemp backTo bodyTemp
-(void)roomTempBackToBodyTempBtAction {
    
    [callTempPickerView resignFirstResponder];
    callTempPickerView.inputView = bodyTempPickerView.m_pickerView;
    callTempPickerView.inputAccessoryView = bodyTempToolBar;
    [callTempPickerView becomeFirstResponder];
    
}

//roomTemp nextTo time
-(void)roomTempNextToTempTimeBtAction {
    
    [callTempPickerView resignFirstResponder];
    callTempPickerView.inputView = timePickerView.m_pickerView;
    callTempPickerView.inputAccessoryView = tempTimeToolBar;
    [callTempPickerView becomeFirstResponder];
}

//TempTime backTo roomTemp
-(void)tempTimeBackToRoomTempBtAction {
    
    [callTempPickerView resignFirstResponder];
    callTempPickerView.inputView = roomTempPickerView.m_pickerView;
    callTempPickerView.inputAccessoryView = roomTempToolBar;
    [callTempPickerView becomeFirstResponder];
    
}

//TempTime nextTo TempDate
-(void)tempTimeNextToTempDateBtAction {
    
    [callTempPickerView resignFirstResponder];
    callTempPickerView.inputView = datePickerView.m_pickerView;
    callTempPickerView.inputAccessoryView = tempDateToolBar;
    [callTempPickerView becomeFirstResponder];
}

//TempDate backTo tempTime
-(void)tempDateBackToTempTimeBtAction {
    
    
    [callTempPickerView resignFirstResponder];
    callTempPickerView.inputView = timePickerView.m_pickerView;
    callTempPickerView.inputAccessoryView = tempTimeToolBar;
    [callTempPickerView becomeFirstResponder];
}


//TempDate save
-(void)tempSaveBtAction {
    
    NSLog(@"save BT");
    
    [self SaveTempActionToDataBase];
   
    blurView.hidden = YES;
    [callTempPickerView resignFirstResponder];
     /*
    callTempPickerView.inputView = bodyTempPickerView.m_pickerView;
    callTempPickerView.inputAccessoryView = bodyTempToolBar;
     */
}

-(void)SaveTempActionToDataBase
{
    NSLog(@"SaveTempActionToDataBase:%d",[LocalData sharedInstance].currentEventId);
    self.syncInformation = YES;

    //=====save data to DB=====
    
    NSDate *bpDate=datePickerView.m_pickerView.date;
    NSDate *bpTime=timePickerView.m_pickerView.date;
    
    NSString *bpDateString=[SFCommonCalendar DateToStringByFormate:bpDate formate:@"yyyy-MM-dd"];
    NSString *bpTimeString=[SFCommonCalendar DateToStringByFormate:bpTime formate:@"HH:mm"];
    
    NSString *date = [NSString stringWithFormat:@"%@ %@",bpDateString,bpTimeString];
    
    
    [BTClass sharedInstance].accountID = [LocalData sharedInstance].accountID;
    
    [BTClass sharedInstance].eventID = [LocalData sharedInstance].currentEventId;
    
    [BTClass sharedInstance].date = date;
    
    [BTClass sharedInstance].bodyTemp = [NSString stringWithFormat:@"%.1f",bodyTempPickerView.btempValue];
    [BTClass sharedInstance].roomTmep = [NSString stringWithFormat:@"%.1f",roomTempPickerView.rtempValue];
    [BTClass sharedInstance].BT_PhotoPath = @"";
    [BTClass sharedInstance].BT_Note = @"";
    [BTClass sharedInstance].BT_RecordingPath = @"";
    
    [[BTClass sharedInstance] insertData];
    
    
    NSDictionary *latestTemp = [[NSDictionary alloc] initWithObjectsAndKeys:
                                [NSString stringWithFormat:@"%.1f",bodyTempPickerView.btempValue],@"bodyTemp",
                                [NSString stringWithFormat:@"%.1f",roomTempPickerView.rtempValue],@"roomTemp",
                                [NSString stringWithFormat:@"%d",[BTClass sharedInstance].eventID],@"selectedEventID",
                                date,@"date",
                                nil];
    
    [[LocalData sharedInstance] saveLatestMeasureValue:latestTemp];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"receiveTempData" object:nil];
}



#pragma mark - TableView DataSource & Delegate ************************
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return listDataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cell_ID;
    
    UITableViewCell *cell;
    
    NSDictionary *cellDict = [listDataArray objectAtIndex:indexPath.row];
    
    if (page.currentPage == 0) {
        
        //BLOOD Pressure CELL
        //--------------------------------------
        cell_ID = @"bp_cellID";
        
         OverBPTableViewCell*bpCell = (OverBPTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cell_ID];
        
        cell = bpCell;
        
        if(bpCell == nil) {
            
            bpCell = [[OverBPTableViewCell alloc] initBPTableiewCellWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
        }
        
        int SYSValue = [[cellDict objectForKey:@"SYS"] intValue];
        int DIAValue = [[cellDict objectForKey:@"DIA"] intValue];
        int PULValue = [[cellDict objectForKey:@"PUL"] intValue];
        BOOL detecAFIB = [[cellDict objectForKey:@"AFIB"] boolValue];
        BOOL detecPAD = [[cellDict objectForKey:@"PAD"] boolValue];
        BOOL highSYS = NO;
        BOOL highDIA = NO;
        
        
        UIImage *typeImage = IMAGE_BPM;
        UIColor *lineColor = STANDER_COLOR;
        
        if (SYSValue >= 135) {
            highSYS = YES;
            typeImage = IMAGE_BPM_RED;
            lineColor = CIRCEL_RED;
        }
        
        if (DIAValue >= 85) {
            highDIA = YES;
            typeImage = IMAGE_BPM_RED;
            lineColor = CIRCEL_RED;
        }
        
        if (detecPAD){
            
            if (highDIA || highSYS) {
                typeImage = IMAGE_PAD_RED;
                lineColor = CIRCEL_RED;
            }else{
                typeImage = IMAGE_PAD;
                lineColor = TEXT_COLOR;
            }
        }
        
        if (detecAFIB) {
            
            if (highSYS || highDIA) {
                lineColor = CIRCEL_RED;
                typeImage = IMAGE_AFIB_RED;
            }else{
                typeImage = IMAGE_AFIB;
                lineColor = TEXT_COLOR;
            }
            
        }
        
        if (highSYS) {
            
            bpCell.sysValueLabel.textColor = CIRCEL_RED;
        }
        
        if (highDIA) {
            bpCell.diaValueLabel.textColor = CIRCEL_RED;
        }
        
        bpCell.bpCellSperator.backgroundColor = lineColor;
        
        bpCell.sysValueLabel.text = [NSString stringWithFormat:@"%d",SYSValue];
        bpCell.diaValueLabel.text = [NSString stringWithFormat:@"%d",DIAValue];
        bpCell.pulValueLabel.text = [NSString stringWithFormat:@"%d",PULValue];
        bpCell.bpCellDateLabel.text = [cellDict objectForKey:@"date"];
        

        bpCell.bpCellTimeLabel.text = @"";
        
        bpCell.bpCellImgView.image = typeImage;
        
        return bpCell;

    }
    else if (page.currentPage == 1) {
        
        //WEIGHT CELL
        //--------------------------------------
        cell_ID = @"weight_cellID";
        
        OverWeightTableViewCell *weightCell = (OverWeightTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cell_ID];
        
        cell = weightCell;
        
        if (weightCell == nil) {
            
            weightCell = [[OverWeightTableViewCell alloc] initWithWeightCellFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
            
        }
        
        UIImage *typeImage = IMAGE_WEIGHT;
        UIColor *lineColor = STANDER_COLOR;
        
        
        float weight = [[cellDict objectForKey:@"weight"] floatValue];
        float BMI = [[cellDict objectForKey:@"BMI"] floatValue];
        float bodyFat = [[cellDict objectForKey:@"bodyFat"] floatValue];
        
        if (BMI > [LocalData sharedInstance].standerBMI) {
            typeImage = IMAGE_WEIGHT_RED;
            lineColor = CIRCEL_RED;
            weightCell.bmiValueLabel.textColor = CIRCEL_RED;
        }
        
        if (bodyFat > [LocalData sharedInstance].standerFat) {
            typeImage = IMAGE_WEIGHT_RED;
            lineColor = CIRCEL_RED;
        }
        
        weightCell.weightValueLabel.text = [NSString stringWithFormat:@"%.1f",weight];
        weightCell.bmiValueLabel.text = [NSString stringWithFormat:@"%.1f",BMI];
        weightCell.bodyFatValueLabel.text = [NSString stringWithFormat:@"%.1f",bodyFat];
        
        weightCell.weightCellDateLabel.text = [cellDict objectForKey:@"date"];
        weightCell.weightCellTimeLabel.text = @"";
        weightCell.weightCellImgView.image = typeImage;
        weightCell.weightCellSperator.backgroundColor = lineColor;
        
        return weightCell;

        
    }
    else if (page.currentPage == 2) {
        
        //BODY TEMP CELL
        //--------------------------------------
        cell_ID = @"temp_cellID";
        
         OverTempTableViewCell *tempCell = (OverTempTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cell_ID];
        
        cell = tempCell;
        
        if (tempCell == nil) {
            
            tempCell = [[OverTempTableViewCell alloc] initTempTableViewCellWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
        }
        
        float bodyTemp = [[cellDict objectForKey:@"bodyTemp"] floatValue];
        //float roomTemp = [[cellDict objectForKey:@"roomTemp"] floatValue];
        
        UIImage *typeImage = IMAGE_TEMP_NORMAL;
        
        if (bodyTemp >= 37.5) {
            typeImage = IMAGE_FEVER;
            tempCell.tempCellSperator.backgroundColor = CIRCEL_RED;
            tempCell.bodyTempValueLabel.textColor = CIRCEL_RED;
        }
        
        tempCell.tempCellImgView.image = typeImage;
        tempCell.bodyTempValueLabel.text = [NSString stringWithFormat:@"%.1f",bodyTemp];
        
        tempCell.tempCellDateLabel.text = [cellDict objectForKey:@"date"];
        
        tempCell.tempCellTimeLabel.text = @"";
        
        tempCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return tempCell;

    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat rowHeight = 0;
    
    switch (page.currentPage) {
        case 0:
            rowHeight = 100;
            break;
        case 1:
            rowHeight = 100;
            break;
        case 2:
            rowHeight = 80;
            break;
        default:
            break;
    }
    
    return rowHeight;
}



#pragma mark - 連結到 edit Event 頁面
-(void)pushToEditEventVC {
    
    OverViewEditEventViewController *editEventVC = [[OverViewEditEventViewController alloc] init];
    
    editEventVC.cellImgAry =  btnSnapAry;
    
    editEventVC.eventCount = eventArray.count;
    
    [self.navigationController pushViewController:editEventVC animated:YES];

}


-(void)dismissKeyboard
{
    [callBPPickerView resignFirstResponder];
    [callWEIPickerView resignFirstResponder];
    [callTempPickerView resignFirstResponder];
    blurView.hidden = YES;
}


#pragma mark - Cloud API Delegate
-(void)processAddBPM:(NSDictionary *)resopnseData Error:(NSError *)jsonError {
    
    if (jsonError) {
        
        NSLog(@"AddBPMData jsonError:%@",jsonError);
    }
    else {
        
        NSLog(@"AddBPMData responseData: %@",resopnseData);
    }
}


-(void)processAddWeightData:(NSDictionary *)resopnseData Error:(NSError *)jsonError {
    
    if (jsonError) {
        
        NSLog(@"AddWeightData jsonError:%@",jsonError);
    }
    else {
        
        NSLog(@"AddWeightData responseData: %@",resopnseData);
    }
}


-(void)processeAddBTData:(NSDictionary *)resopnseData Error:(NSError *)jsonError {
    
    if (jsonError) {
        
        NSLog(@"AddBTData jsonError:%@",jsonError);
    }
    else {
        
        NSLog(@"AddBTData responseData: %@",resopnseData);
    }

    
}


#pragma mark - BTEventSelector
-(void)showBTEventSelector {
    
    btEventSelector = [[BTEventSelector alloc] initBTEventSelector];
    btEventSelector.superVC = self;
    btEventSelector.ary_BTEventData = [[EventClass sharedInstance] selectAllData];
    [btEventSelector reloadBTEventData];
    btEventSelector.delegate = self;
    [btEventSelector showBTEventSelectorAlert];
    
}


-(void)confirmOrCancel:(int)confirm checkMark:(NSMutableArray *)ary_checkMark {
    
    NSDictionary *latestTemp = [[LocalData sharedInstance] getLatestMeasureValue];
    float bodyTemp = [[latestTemp objectForKey:@"bodyTemp"] floatValue];
    float roomTemp = [[latestTemp objectForKey:@"roomTemp"] floatValue];
    NSString *dateStr = [latestTemp objectForKey:@"date"];

    for (NSString *eventID in ary_checkMark) {
        if (![eventID isEqualToString:@"0"]) {
            selectedEventID = eventID.intValue;
        }
    }
    NSLog(@"selectedEventID:%d",selectedEventID);
    if (confirm == 0) {
        //指定事件並儲存
        if (![CheckNetwork isExistenceNetwork]) {
            //無網路時
            [MViewController showAlert:NETWORK_TITLE message:NETWORK_MESSAGE buttonTitle:NETWORK_CONFIRM];
            return;
        }
        else {
            if ([LocalData sharedInstance].accountID != -1) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    ///event_code:流水號,第幾位
                    NSString *tokenStr = [NSString stringWithContentsOfFile:OAuth_TOKEN encoding:NSUTF8StringEncoding error:nil];
                    [apiClass postAddBTData:tokenStr event_code:selectedEventID bt_id:Temp_Device_ID body_temp:bodyTemp room_temp:26 date:dateStr mac_address:nil];
                });
            }
            
        }
        [BTClass sharedInstance].accountID = [LocalData sharedInstance].accountID;
        [BTClass sharedInstance].eventID = selectedEventID;
        [BTClass sharedInstance].date = dateStr;
        [BTClass sharedInstance].bodyTemp = [NSString stringWithFormat:@"%.1f",bodyTemp];
        [BTClass sharedInstance].roomTmep = [NSString stringWithFormat:@"%.1f",roomTemp];
        [BTClass sharedInstance].BT_PhotoPath = @"";
        [BTClass sharedInstance].BT_Note = @"";
        [BTClass sharedInstance].BT_RecordingPath = @"";
        [[BTClass sharedInstance] insertData];
    }
    else {
        //不指定事件 不儲存
        
    }
    blurView.hidden = YES;

}



@end
