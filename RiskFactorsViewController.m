//
//  RiskFactorsViewController.m
//  Setting
//
//  Created by Ideabus on 2016/8/12.
//  Copyright © 2016年 Allen. All rights reserved.
//

#import "RiskFactorsViewController.h"
#import "ViewController.h"
#import "ProfileViewController.h"

@interface RiskFactorsViewController () {
    
    UIButton *rfselectBtn;
    NSMutableArray  *ary_title;
    UITableView *RFTableView;
    NSMutableArray *ary_selectedTag;
    
}

@end

@implementation RiskFactorsViewController


#pragma mark - Normal Functions  ******************************************
- (void)viewDidLoad {
    [super viewDidLoad];
    //[self RFView];
    
    //[self.view setBackgroundColor:[UIColor colorWithRed:240.0f/255.0f green:240.0f/255.0f blue:240.0f/255.0f alpha:240.0f/255.0f]];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self riskfactortableview];
    
    
    [self initWithNavigationBar];
    
}


-(void)viewWillAppear:(BOOL)animated {
    
    [self initWithTagFromDatabase];
    
}


-(void)viewWillDisappear:(BOOL)animated {
    
    if (ary_selectedTag.count != 0) {
        
        [ary_selectedTag removeAllObjects];
        ary_selectedTag = nil;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - initialization  ******************************************
-(void)initWithTagFromDatabase {
    
    ary_selectedTag = [[NSMutableArray alloc] init];
    [ary_selectedTag addObject:[[NSString stringWithFormat:@"%d",self.m_superVC.isHypertension] copy]];
    [ary_selectedTag addObject:[[NSString stringWithFormat:@"%d",self.m_superVC.isAtrialFibrillation] copy]];
    [ary_selectedTag addObject:[[NSString stringWithFormat:@"%d",self.m_superVC.isDiabetes] copy]];
    [ary_selectedTag addObject:[[NSString stringWithFormat:@"%d",self.m_superVC.isCardiovascular] copy]];
    [ary_selectedTag addObject:[[NSString stringWithFormat:@"%d",self.m_superVC.isChronicKindey] copy]];
    [ary_selectedTag addObject:[[NSString stringWithFormat:@"%d",self.m_superVC.isTransientIschemicAttact] copy]];
    [ary_selectedTag addObject:[[NSString stringWithFormat:@"%d",self.m_superVC.isDyslipidemia] copy]];
    [ary_selectedTag addObject:[[NSString stringWithFormat:@"%d",self.m_superVC.isSnoringOrSleepAponea] copy]];
    [ary_selectedTag addObject:[[NSString stringWithFormat:@"%d",self.m_superVC.isUseOralContraception] copy]];
    [ary_selectedTag addObject:[[NSString stringWithFormat:@"%d",self.m_superVC.isUseAntiHypertensive] copy]];
    [ary_selectedTag addObject:[[NSString stringWithFormat:@"%d",self.m_superVC.isPregenancy_normoal] copy]];
    [ary_selectedTag addObject:[[NSString stringWithFormat:@"%d",self.m_superVC.isPregenancy_preEclampsia] copy]];
    [ary_selectedTag addObject:[[NSString stringWithFormat:@"%d",self.m_superVC.isSmoking] copy]];
    [ary_selectedTag addObject:[[NSString stringWithFormat:@"%d",self.m_superVC.isAlcoholIntake] copy]];
    
    
    NSLog(@"ary_selectedTag: %@",ary_selectedTag);
    
    
    
    /**
    for (int i=0; i<14; i++) {
        
        NSString *selectStr = @"0";
        
        [ary_selectedTag addObject:selectStr];
        
    }
    */
    

}


//initWithNavigationBar
-(void)initWithNavigationBar {
    
    /**
    self.title = NSLocalizedString(@"Risk Factors", nil);
    
    ///改變self.title 的字體顏色
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    ///改變 navigationBar 的底色
    self.navigationController.navigationBar.barTintColor = STANDER_COLOR;
    
    ///改變 statusBarStyle(字體變白色)
    ///先將 info.plist 中的 View controller-based status bar appearance 設為 NO
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;


    //leftBarButton
    UIButton *leftBarBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,30,30)];
    [leftBarBtn setImage:[UIImage imageNamed:@"all_btn_a_cancel"] forState:UIControlStateNormal];
    [leftBarBtn addTarget:self action:@selector(gobackProfile) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarBtn];
     */
    
    
    UIView *pnavview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height*0.09)];
    pnavview.backgroundColor = [UIColor colorWithRed:0 green:61.0f/255.0f blue:165.0f/255.0f alpha:1.0];
    [self.view addSubview:pnavview];
    
    
    CGRect pnavFrame = CGRectMake(0, 0 , self.view.frame.size.width , self.view.frame.size.height*0.1);
    UILabel *pnavLabel = [[UILabel alloc] initWithFrame:pnavFrame];
    [pnavLabel setTextColor:[UIColor whiteColor ]];
    pnavLabel.backgroundColor = [UIColor clearColor];
    pnavLabel.text = NSLocalizedString(@"Risk Factors", nil);
    pnavLabel.font = [UIFont systemFontOfSize:22];
    pnavLabel.alpha = 1.0;
    pnavLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:pnavLabel];
    
    
    UIButton *navbackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    navbackBtn.frame = CGRectMake(0, self.view.frame.size.height*0.026, self.view.frame.size.height*0.05, self.view.frame.size.height*0.05);
    [navbackBtn setImage:[UIImage imageNamed:@"all_btn_a_back"] forState:UIControlStateNormal ];
        navbackBtn.backgroundColor = [UIColor clearColor];
    navbackBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    
    [navbackBtn addTarget:self action:@selector(gobackProfile) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:navbackBtn];

}


-(void)riskfactortableview {

     RFTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height*0.09, self.view.frame.size.width, self.view.frame.size.height*0.91)];
    
    //ary_title init
    ary_title=[[NSMutableArray alloc]init];
    [ary_title addObject:NSLocalizedString(@"Personal History of Hypertension", nil)];
    [ary_title addObject:NSLocalizedString(@"Personal History of Atrial Fibrillation", nil)];
    [ary_title addObject:NSLocalizedString(@"Personal History of Diabetes", nil)];
    [ary_title addObject:NSLocalizedString(@"Personal History of Cardiovascular diseases (CVD)", nil)];
    [ary_title addObject:NSLocalizedString(@"Personal History of Chronic Kidney Disease (CKD)", nil)];
    [ary_title addObject:NSLocalizedString(@"Personal History of Stroke/Transient Ischemic Attack (TIA)", nil)];
    [ary_title addObject:NSLocalizedString(@"Personal History of Dyslipidemia", nil)];
    [ary_title addObject:NSLocalizedString(@"Personal History of Snoring & Sleep Aponea", nil)];
    [ary_title addObject:NSLocalizedString(@"Drug Use–Oral Contraception", nil)];
    [ary_title addObject:NSLocalizedString(@"Drug Use–Anti-Hypertensive Drugs", nil)];
    [ary_title addObject:NSLocalizedString(@"Pregenancy - Normal", nil)];
    [ary_title addObject:NSLocalizedString(@"Pregnancy–Pre-Eclampsia", nil)];
    [ary_title addObject:NSLocalizedString(@"Smoking", nil)];
    [ary_title addObject:NSLocalizedString(@"Alcohol Intake", nil)];
    
    
    
    
    
    RFTableView.delegate = self;
    RFTableView.dataSource = self;
    //self.RFTableView.scrollEnabled = NO;
    RFTableView.backgroundColor = [UIColor clearColor];
    RFTableView.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor colorWithRed:208.0f/255.0f green:208.0f/255.0f blue:208.0f/255.0f alpha:1.0]);
    RFTableView.layer.borderWidth = 2;
    //RFTableView.pagingEnabled = true;
    RFTableView.allowsMultipleSelection = YES;
    //[RFTableView setEditing:YES animated:YES];
    
   // RFTableView.userInteractionEnabled = NO;
    
    [RFTableView registerNib:[UINib nibWithNibName:@"RiskFactorCell" bundle:nil] forCellReuseIdentifier:@"RFcell_ID"];
    
    
    [self.view addSubview:RFTableView];
    
}





#pragma mark - TableView Delegate & DataSource  ******************************************
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [ary_title count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cell_id = @"RFcell_ID";

    RiskFactorCell *RFcell = [tableView dequeueReusableCellWithIdentifier:cell_id forIndexPath:indexPath];
    
    RFcell.m_superVC = self;

    RFcell.RFLabel.text = ary_title[indexPath.row];
    RFcell.RFLabel.numberOfLines = 2;
    
    
    RFcell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    BOOL selected = [[ary_selectedTag objectAtIndex:indexPath.row] boolValue];
    
    RFcell.RFcheckbox.image = [UIImage imageNamed:@"all_select_a_0"];
    
    if (selected) {
        
        RFcell.RFcheckbox.image = [UIImage imageNamed:@"all_select_a_1"];
    }
    
    return RFcell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60 ;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"user selected %@",[ary_title objectAtIndex:indexPath.row]);
    
    NSString *selectStr;
    
    BOOL selected = [[ary_selectedTag objectAtIndex:indexPath.row] boolValue];
    
    selected = !selected;
    
    selectStr = [NSString stringWithFormat:@"%d",selected];
    
    [ary_selectedTag replaceObjectAtIndex:indexPath.row withObject:selectStr];
    
    [RFTableView reloadData];
    
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {

    [RFTableView reloadData];
}


#pragma mark - 跳至其他頁面  ******************************************
-(void)gobackProfile {
    
    [self recordSelectedTag];
}

-(void)recordSelectedTag {

    //1.高血壓:isHypertension
    self.m_superVC.isHypertension = [ary_selectedTag[0] intValue];
    
    //2.心房顫動:isAtrialFibrillation
    self.m_superVC.isAtrialFibrillation = [ary_selectedTag[1] intValue];
    
    //3.糖尿病:isDiabetes
    self.m_superVC.isDiabetes = [ary_selectedTag[2] intValue];
    
    //4.心血管疾病:isCardiovascular
    self.m_superVC.isCardiovascular = [ary_selectedTag[3] intValue];
    
    //5.慢性腎臟病:isChronicKindey
    self.m_superVC.isChronicKindey = [ary_selectedTag[4] intValue];
    
    //6.貧血:isTransientIschemicAttact
    self.m_superVC.isTransientIschemicAttact = [ary_selectedTag[5] intValue];
    
    //7.血脂異常:isDyslipidemia
    self.m_superVC.isDyslipidemia = [ary_selectedTag[6] intValue];
    
    //8.打鼾 或 睡眠呼吸暫停:isSnoringOrSleepAponea
    self.m_superVC.isSnoringOrSleepAponea = [ary_selectedTag[7] intValue];
    
    //9.使用口服避孕藥:isUseOralContraception
    self.m_superVC.isUseOralContraception = [ary_selectedTag[8] intValue];
    
    //10.使用抗高血壓:isUseAntiHypertensive
    self.m_superVC.isUseAntiHypertensive = [ary_selectedTag[9] intValue];
    
    //11.懷孕(正常):isPregenancy_normoal
    self.m_superVC.isPregenancy_normoal = [ary_selectedTag[10] intValue];
    
    //12.懷孕(子癇前症 或 妊娠毒血症):isPregenancy_preEclampsia
    self.m_superVC.isPregenancy_preEclampsia = [ary_selectedTag[11] intValue];
    
    //13.抽菸習慣:isSmoking
    self.m_superVC.isSmoking = [ary_selectedTag[12] intValue];
    
    //14.飲用酒精:isAlcoholIntake
    self.m_superVC.isAlcoholIntake = [ary_selectedTag[13] intValue];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
