//
//  MainHistoryViewController.m
//  Microlife
//
//  Created by Rex on 2016/7/22.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import "MainHistoryViewController.h"
#import "HistoryPageView.h"
#import "EditListViewController.h"
#import "BLEDataHandler.h"
#import <MessageUI/MessageUI.h>
#import "MailSelector.h"


@interface MainHistoryViewController ()<UINavigationControllerDelegate, UIScrollViewDelegate,HistoryPageViewDelegate,HistoryListDelegate,MFMailComposeViewControllerDelegate,MailSelectorDelegate,APIPostAndResponseDelegate>{
    UIPageControl *pageControl;
    HistoryListTableView *listsView;
    UIImageView *titleImgView;
    
    HistoryPageView *tempView;
    HistoryPageView *weightView;
    HistoryPageView *BPView;
    
    UIView *tempBtnSnapShot;
    
    //Email選擇事件
    MailSelector *mailSelector;
    
    //API
    APIPostAndResponse *apiClass;
    
    NSString *PDF_FilePath;
    NSArray *mailAry;
}

@end

typedef enum {
    
    BPM_PDF,
    Weight_PDF,
    BT_PDF
    
}PDFType;


@implementation MainHistoryViewController

@synthesize contentScroll;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initParameter];
    [self initInterface];
    
    
   // NSLog(@"[WeightClass sharedInstance] = %@", [[WeightClass sharedInstance] selectAllData]);
    //NSLog(@"[BTClass sharedInstance] = %@", [[BTClass sharedInstance] selectAllData]);
   // NSLog(@"[BPMClass sharedInstance] = %@", [[BPMClass sharedInstance] selectAllData]);
    NSLog(@"selectAllData = %@",[[BPMClass sharedInstance] selectAllData]);
    
    //註冊監聽事件＆動作
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(historyListReloadData) name:@"SaveNoteAction" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(historyPageViewRoload) name:@"receiveBPMData" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(historyPageViewRoload) name:@"receiveWeightData" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(historyPageViewRoload) name:@"receiveTempData" object:nil];

}

- (void)historyListReloadData {
    if (listsView) {
        switch (pageControl.currentPage) {
            case 0:
                [BPView showListAction];
                break;
            case 1:
                [weightView showListAction];
                break;
            case 2:
                [tempView showListAction];
                break;
            default:
                break;
        }
        [listsView.historyList reloadData];
    }
}

- (void)historyPageViewRoload {
    [tempView createChart:tempView.chartType];
    [weightView createChart:weightView.chartType];
    [BPView createChart:BPView.chartType];
}

-(void)viewWillAppear:(BOOL)animated{
    
    /**
    if (listsView != nil) {
        
        [listsView removeFromSuperview];
        
        listsView = [[HistoryListTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        listsView.listType = pageControl.currentPage;
        listsView.delegate = self;
        [listsView.historyList reloadData];
        
        [self.view addSubview:listsView];
        
        self.tabBarController.tabBar.hidden = YES;
        [[self navigationController] setNavigationBarHidden:YES animated:YES];
        
        pageControl.hidden = YES;
        
        [listsView.hideListBtn addSubview:tempBtnSnapShot];
        
        [listsView.historyList reloadData];
    }
     */
    NSString *tokenStr = [NSString stringWithContentsOfFile:OAuth_TOKEN encoding:NSUTF8StringEncoding error:nil];
    [apiClass postGetMailNotificationList:tokenStr];
    
    if (listsView != nil)  {
        
        if (tempBtnSnapShot != nil) {
            
            [listsView removeFromSuperview];
            
            listsView = [[HistoryListTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
            listsView.listType = pageControl.currentPage;
            [listsView.hideListBtn addSubview:tempBtnSnapShot];
            listsView.delegate = self;
            [listsView.historyList reloadData];
            
            [self.view addSubview:listsView];
            
            self.tabBarController.tabBar.hidden = YES;
            [[self navigationController] setNavigationBarHidden:YES animated:YES];
            
            pageControl.hidden = YES;
            
            tempBtnSnapShot.backgroundColor = [UIColor cyanColor];
        }
        
    }
    
    if (tempView != nil) {
        [tempView renderEventCircle];
    }
    
    
    
    
}

-(void)initParameter{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentEditVC) name:@"showEditVC" object:nil];
    
    //self
    apiClass = [[APIPostAndResponse alloc] initCloud];
    apiClass.delegate = self;
    
}

-(void)initInterface{
    
    CGFloat navHeight = self.navigationController.navigationBar.frame.size.height;
    
    CGFloat tabBarHeight = self.tabBarController.tabBar.frame.size.height;
    
    [self setNavgationTitle];
    
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-tabBarHeight-self.view.bounds.size.height*0.05-100, self.view.bounds.size.width, self.view.bounds.size.height*0.02)];
    pageControl.numberOfPages = 3;
    pageControl.currentPage = 0;
    
    pageControl.pageIndicatorTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"all_dot_a_0.png"]];
    
    pageControl.currentPageIndicatorTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"all_dot_a_1.png"]];
    
    [contentScroll setPagingEnabled:YES];
    [contentScroll setShowsHorizontalScrollIndicator:NO];
    [contentScroll setShowsVerticalScrollIndicator:NO];
    [contentScroll setScrollsToTop:NO];
    [contentScroll setDelegate:self];
    
    [self setNavigationImage];
    
    CGFloat width, height;
    width = contentScroll.frame.size.width;
    height = self.view.bounds.size.height-navHeight-tabBarHeight-20;
    [contentScroll setContentSize:CGSizeMake(width * 3, height)];
    
    BPView = [[HistoryPageView alloc] initWithFrame:CGRectMake(0, 0, contentScroll.frame.size.width, height)];
    BPView.delegate = self;
    BPView.chartType = 0;
    BPView.viewType = 0;
    [BPView initBPCurveControlButton];
    [BPView setSegment:[NSArray arrayWithObjects:NSLocalizedString(@"DAY", nil), NSLocalizedString(@"WEEK", nil), NSLocalizedString(@"MONTH", nil), NSLocalizedString(@"YEAR", nil), nil]];
    //[BPView setTimeLabelTitle:@"26/07/2016"];
    [BPView initBPHealthCircle];
    [BPView setAbsentDaysText:[[BPMClass sharedInstance] getLastDate] andFaceIcon:[UIImage imageNamed:@"history_icon_a_face_2"]];//泡泡框上方顯示文字。
    
    
    weightView = [[HistoryPageView alloc] initWithFrame:CGRectMake(width, 0, contentScroll.frame.size.width, height)];
    weightView.delegate = self;
    weightView.chartType = 2;
    weightView.viewType = 1;
    [weightView initWeightCurveControlButton];
    [weightView setSegment:[NSArray arrayWithObjects:NSLocalizedString(@"DAY", nil), NSLocalizedString(@"WEEK", nil), NSLocalizedString(@"MONTH", nil), NSLocalizedString(@"YEAR", nil), nil]];
    //[weightView setTimeLabelTitle:@"26/07/2016"];
    [weightView initWeightHealthCircle];
    [weightView setAbsentDaysText:[[WeightClass sharedInstance] getLastDate] andFaceIcon:[UIImage imageNamed:@"history_icon_a_face_3"]];//泡泡框上方顯示文字。
    
    
    tempView = [[HistoryPageView alloc] initWithFrame:CGRectMake(width*2, 0, contentScroll.frame.size.width, height)];
    tempView.delegate = self;
    tempView.chartType = 5;
    tempView.viewType = 2;
    [tempView setSegment:[NSArray arrayWithObjects:@"1HR", @"4HR", @"24HR", nil]];
    //[tempView setTimeLabelTitle:@"26/07/2016"];
    [tempView initTempHealthCircle];
    [tempView setAbsentDaysText:[[BTClass sharedInstance] getLastDate] andFaceIcon:[UIImage imageNamed:@"history_icon_a_face_1"]];//泡泡框上方顯示文字。
    
    
    [tempView initTempCurveControlButton];
    [tempView renderEventCircle];
    
    [contentScroll addSubview:BPView];
    [contentScroll addSubview:weightView];
    [contentScroll addSubview:tempView];
    [self.view addSubview:pageControl];
    
}

-(void)setNavigationImage{
    
    UIImage *titleImg;
    
    switch (pageControl.currentPage) {
        case 0:
            titleImg = [UIImage imageNamed:@"history_icon_a_bpm"];
            break;
            
        case 1:
            titleImg = [UIImage imageNamed:@"history_icon_a_ws"];
            break;
            
        case 2:
            titleImg = [UIImage imageNamed:@"history_icon_a_ncfr"];
            break;
            
        default:
            break;
    }
    
    titleImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    titleImgView.image = titleImg;
    
    titleImgView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.navigationItem.titleView = titleImgView;
    
}

-(void)setNavgationTitle{
    
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
    
    
    //右邊信箱的按鈕
    //設定rightBarButtonItem(emailBt)
    UIButton *rightItemBt = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.navigationController.navigationBar.frame.size.height*0.8, self.navigationController.navigationBar.frame.size.height*0.8)];
    
    [rightItemBt setImage:[UIImage imageNamed:@"all_icon_a_mail"] forState:UIControlStateNormal];
    
    [rightItemBt addTarget:self action:@selector(emailBtAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightItemBt];
}

-(void)presentEditVC{
    
    EditListViewController *editListVC = [[EditListViewController alloc] init];
        
    [self.navigationController pushViewController:editListVC animated:YES];
}

#pragma mark - profileBtAction (導覽列左邊按鍵方法)
-(void)profileBtAction {
    
    [self SidebarBtn];
}


#pragma mark - profileBtAction (導覽列右邊按鍵方法)
-(void)emailBtAction {
    
    
    if ([MViewController checkIsPrivacyModeOrMemberShip]) {
        //privacy mode can not use MailNotification
        
        [MViewController showAlert:NSLocalizedString(@"Alert", nil) message:NSLocalizedString(@"You can not use MailNotification in Pravicy Mode", nil) buttonTitle:NSLocalizedString(@"Confirm", nil)];
        
    }
    else {
        
        if (![CheckNetwork isExistenceNetwork]) {
            
            //無網路時
            [MViewController showAlert:NETWORK_TITLE message:NETWORK_MESSAGE buttonTitle:NETWORK_CONFIRM];
            return;
        }
        else {
            
            [self showMailSelector:mailAry];
            
            //Download PDF
            CGFloat width = contentScroll.frame.size.width;
            NSInteger currentPage = ((contentScroll.contentOffset.x - width / 2) / width) + 1;
            
            if (currentPage == 0) {
                
                UIImage *img = [self convertViewToImage:BPView.chartView];
                [self requestDownloadPDF:BPM_PDF snapImage:img];
            }
            else if (currentPage == 1) {
                
                UIImage *img = [self convertViewToImage:weightView.chartView];
                [self requestDownloadPDF:Weight_PDF snapImage:img];
            }
            else {
                
                UIImage *img = [self convertViewToImage:tempView.chartView];
                [self requestDownloadPDF:BT_PDF snapImage:img];
            }
        
        }
        
    }
    
}


-(void)sendEmail:(NSArray<NSString *> *)recipient{
    
    MFMailComposeViewController * mailCompseVC = [[MFMailComposeViewController alloc] init];
    
    if (![MFMailComposeViewController canSendMail]) {
        return;
    }
    
    mailCompseVC.mailComposeDelegate = self;
    [mailCompseVC setToRecipients:recipient]; //設定收件者
    
    NSString *messageStr = [[NSString alloc] initWithFormat:NSLocalizedString(@"Report FilePath:\n", nil)];
    
    messageStr = [messageStr stringByAppendingString:PDF_FilePath];
    
    [mailCompseVC setMessageBody:messageStr isHTML:NO];//設定文件內容
    
    [mailCompseVC setSubject:NSLocalizedString(@"Report", nil)];//設定郵件主旨
    
    [self presentViewController:mailCompseVC animated:true completion:nil];
    
}


-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    
    NSString *message = @"";
    
    NSLog(@"result === %ld",(long)result);
    
    switch (result) {
        case MFMailComposeResultCancelled:
            message = NSLocalizedString(@"The Mail has been canceled", nil);
            break;
        case MFMailComposeResultSent:
            message = NSLocalizedString(@"The Mail has been sent", nil);
            break;
        case MFMailComposeResultSaved:
            message = NSLocalizedString(@"The Mial has been saved", nil);
            break;
        case MFMailComposeResultFailed:
            message = NSLocalizedString(@"The Mail delivery failed", nil);
            break;
        default:
            break;
    }
    
    //回到上一頁
    [self dismissViewControllerAnimated:true completion:nil];
    
    [MViewController showAlert:NSLocalizedString(@"Email", nil) message:message buttonTitle:NSLocalizedString(@"Confirm", nil)];
    
}




#pragma mark - scrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView == contentScroll) {
        
        CGFloat width = scrollView.frame.size.width;
        
        NSInteger currentPage = ((scrollView.contentOffset.x - width / 2) / width) + 1;
        
        [pageControl setCurrentPage:currentPage];
        [self setNavigationImage];
    }
}



#pragma mark - HistoryPageView Delegate
-(void)showListButtonTapped:(UIView *)btnSnapShot{
    
    [listsView removeFromSuperview];
    
    listsView = [[HistoryListTableView alloc] initWithFrame:CGRectMake(0, self.tabBarController.tabBar.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)];
    listsView.listType = pageControl.currentPage;
    listsView.delegate = self;
    [listsView.hideListBtn addSubview:btnSnapShot];
    
    [self.view addSubview:listsView];
    
    self.tabBarController.tabBar.hidden = YES;
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    pageControl.hidden = YES;
    
    tempBtnSnapShot = btnSnapShot;
        
    [UIView transitionWithView:listsView duration:0.1 options:UIViewAnimationOptionTransitionNone animations:^{
        
        listsView.frame = CGRectMake(0, 0, listsView.frame.size.width, listsView.frame.size.height);
        
    } completion:^(BOOL finished) {
        
    }];
}

-(void)hideListButtonTapped{
    
    [UIView transitionWithView:listsView duration:0.1 options:UIViewAnimationOptionTransitionNone animations:^{
        
        listsView.frame = CGRectMake(0, self.view.frame.size.height, listsView.frame.size.width, listsView.frame.size.height);
        
    } completion:^(BOOL finished) {
        //
    }];
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    self.tabBarController.tabBar.hidden = NO;
    pageControl.hidden = NO;

    //20170306FIX
    tempBtnSnapShot = nil;
}

-(void)GraphViewScrollBegin{
    contentScroll.scrollEnabled = NO;
}

-(void)GraphViewScrollEnd{
    contentScroll.scrollEnabled = YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 寄送郵件相關  **********************
-(void)showMailSelector:(NSArray *)responseAry {
    
    mailSelector = [[MailSelector alloc] initMailSelector];
    mailSelector.superVC = self;
    mailSelector.ary_mailList = responseAry;
    mailSelector.delegate = self;
    [mailSelector reloadMailListData];
    [mailSelector showMailSelectorAlert];

}

-(void)confirmOrCancel:(int)confirm checkMark:(NSMutableArray *)ary_checkMark {
    
    NSLog(@"ary_checkMark:%@",ary_checkMark);
    
    if (confirm == 0) {
        //指定Mail寄件者
        
        for (int i = 0; i < ary_checkMark.count; i++) {
            
            if (![ary_checkMark[i] isEqualToString:@"0"]) {
                [self sendEmail:@[ary_checkMark[i]]];
                break;
            }
//            if ([ary_checkMark[i] isEqualToString:@"1"]) {
//                [self sendEmail:@[[mailSelector.ary_mailList[i] objectForKey:@"email"]]];
//                break;
//            }
        }
        
    }
    else {
        //不指定,不傳
        
    }

}


#pragma mark - API Delegate  **********************************
-(void)processeGetMailNotificationList:(NSDictionary *)resopnseData Error:(NSError *)jsonError {
    
    if (jsonError) {
        
        NSLog(@"Get Mail Notification List:%@",jsonError);
    }
    else {
        
        NSLog(@"Get Mail Notification List resopnseData: %@",resopnseData);
        
        if ([[resopnseData objectForKey:@"code"] intValue] == 10000) {
            
            mailAry = [[NSArray alloc] initWithArray:[resopnseData objectForKey:@"data"]];
            
            NSLog(@"mailAry:%@",mailAry);
            
            
        }
        
    }
    
}

-(void)processDownloadBPMPDF:(NSDictionary *)resopnseData Error:(NSError *)jsonError {
    
    if (jsonError) {
        
        NSLog(@"DownloadBPMPDF jsonError:%@",jsonError);
    }
    else {
        
        NSLog(@"DownloadBPMPDF resopnseData:%@",resopnseData);
        
        if ([[resopnseData objectForKey:@"code"] intValue] == 10000) {
            
            PDF_FilePath = [resopnseData objectForKey:@"pdf_path"];
            
            NSLog(@"PDF_FilePath:%@",PDF_FilePath);
            
//            NSString *tokenStr = [NSString stringWithContentsOfFile:OAuth_TOKEN encoding:NSUTF8StringEncoding error:nil];
//            [apiClass postGetMailNotificationList:tokenStr];
        }
        
    }
    
}

-(void)processDownloadWeightPDF:(NSDictionary *)resopnseData Error:(NSError *)jsonError {
 
    if (jsonError) {
        
        NSLog(@"DownloadWeightPDF jsonError:%@",jsonError);
    }
    else {
        
        NSLog(@"DownloadWeightPDF resopnseData:%@",resopnseData);
        
        if ([[resopnseData objectForKey:@"code"] intValue] == 10000) {
            
            PDF_FilePath = [resopnseData objectForKey:@"pdf_path"];
            
            NSLog(@"PDF_FilePath:%@",PDF_FilePath);
            
//            NSString *tokenStr = [NSString stringWithContentsOfFile:OAuth_TOKEN encoding:NSUTF8StringEncoding error:nil];
//            [apiClass postGetMailNotificationList:tokenStr];
        }
        
    }

    
}

-(void)processDownloadBTPDF:(NSDictionary *)resopnseData Error:(NSError *)jsonError {
    
    if (jsonError) {
        
        NSLog(@"DownloadBTPDF jsonError:%@",jsonError);
    }
    else {
        
        NSLog(@"DownloadBTPDF resopnseData:%@",resopnseData);
        
        if ([[resopnseData objectForKey:@"code"] intValue] == 10000) {
            
            PDF_FilePath = [resopnseData objectForKey:@"pdf_path"];
            
            NSLog(@"PDF_FilePath:%@",PDF_FilePath);
            
//            NSString *tokenStr = [NSString stringWithContentsOfFile:OAuth_TOKEN encoding:NSUTF8StringEncoding error:nil];
//            [apiClass postGetMailNotificationList:tokenStr];
        }
        
    }

}


#pragma mark - Download PDF  **********************
/**
 1.先根據 scrollView 位置,判斷是BPM / Weight / BT
 2.結目前位置曲線圖
*/
-(void)requestDownloadPDF:(PDFType)type snapImage:(UIImage *)snapImg {
    
    NSString *tokenStr = [NSString stringWithContentsOfFile:OAuth_TOKEN encoding:NSUTF8StringEncoding error:nil];
    
    /**
    NSString *testStartTime = @"2017-03-23";
    NSString *testEndTime = @"2017-03-23";
    
    NSString *testStartTime01 = @"2017-03-23 09:00";
    NSString *testEndTime01 = @"2017-03-23 11:00";
    */
    
    if (type == BPM_PDF) {
        
        NSString *startTime = BPView.startTimeString;
        NSString *endTime = BPView.endTimeString;
        
        NSLog(@"startTime:%@\nendTime:%@",startTime,endTime);

        [apiClass postDownloadBPMPDF:tokenStr start_date:startTime end_date:endTime sys_threshold:130 dia_threshold:70 photo:snapImg];

    }
    else if (type == Weight_PDF) {
        
        NSString *startTime = weightView.startTimeString;
        NSString *endTime = weightView.endTimeString;
        
         NSLog(@"startTime:%@\nendTime:%@",startTime,endTime);
        
        [apiClass postDownloadWeightPDF:tokenStr start_date:startTime end_date:endTime bmi_threshold:26 photo:snapImg];
    }
    else {
        
        NSString *startTime = tempView.startTimeString;
        NSString *endTime = tempView.endTimeString;
        
        NSLog(@"startTime:%@\nendTime:%@",startTime,endTime);
        
        [apiClass postDownloadBTPDF:tokenStr start_date:startTime end_date:endTime threshold:38 photo:snapImg];
    }
    
}

#pragma mark - UIView 轉 UIImage  ************************
-(UIImage *)convertViewToImage:(UIView*)view {
    
    CGSize size = view.bounds.size;
    UIGraphicsBeginImageContextWithOptions(size, YES, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
