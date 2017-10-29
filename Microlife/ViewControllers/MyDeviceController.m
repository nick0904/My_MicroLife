//
//  MyDeviceController.m
//  Microlife
//
//  Created by Idea on 2016/10/7.
//  Copyright © 2016年 Rex. All rights reserved.
//MyDevice的頁面

#import "MyDeviceController.h"

typedef enum {
    
    DeviceType_BPM,
    DeviceType_Weight,
    DeviceType_BT,
    DeviceType_Unknow
    
}DeviceType;

@interface MyDeviceController (){

    NSMutableArray *microlifeData;
    
    
    UILabel *deviceNameLabel;
    UILabel *timesLabel;
    UILabel *numLabel;
    
    DeviceType m_deviceType;
    
    
    ///Error Dictionary
    NSMutableArray *BPM_Error_ary;
    NSMutableArray *Weight_Error_ary;
    NSMutableArray *BT_Error_ary;
    NSMutableArray *Unknow_ary;
    
    ///Error Title
    NSArray *BPM_Error_title;
    NSArray *Weright_Error_title;
    NSArray *BT_Error_title;
    NSArray *Unknow_title;
    
}

@end





@implementation MyDeviceController
@synthesize deviceLabel;
@synthesize deviceStr;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUIObjects];
    
    [self MyDevicenav];
    
    [self initWithParam];
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self parserErrorCode];
}


-(void)viewDidAppear:(BOOL)animated {
    
    [self refreshDeviceData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)initWithParam {
    
    ///BPM_Error_ary init
    BPM_Error_ary = [[NSMutableArray alloc] init];
    
    
    ///Weight_Error_ary  init
    Weight_Error_ary = [[NSMutableArray alloc] init];
    
    
    ///BT_Error_ary init
    BT_Error_ary = [[NSMutableArray alloc] init];
    
    
    ///Unknow_ary
    Unknow_ary = [[NSMutableArray alloc] init];
    
    
    //Error_titles
    BPM_Error_title = [[NSArray alloc] initWithObjects:
                       NSLocalizedString(@"血壓量測Error1 ", nil),
                       NSLocalizedString(@"血壓量測Error2 ", nil),
                       NSLocalizedString(@"血壓量測Error3 ", nil),
                       NSLocalizedString(@"血壓量測Error5 ", nil), nil];
    
    
    Weright_Error_title = [[NSArray alloc] initWithObjects:
                           NSLocalizedString(@"體脂量測ErrorWeightOverload ", nil),
                           NSLocalizedString(@"體脂量測ErrorImpedance ", nil), nil];
    
    
    BT_Error_title = [[NSArray alloc] initWithObjects:
                      NSLocalizedString(@"額溫量測ErrorAmbH ", nil),
                      NSLocalizedString(@"額溫量測ErrorAmbL ", nil),
                      NSLocalizedString(@"額溫量測ErrorBodyH ", nil),
                      NSLocalizedString(@"額溫量測ErrorBodyL ", nil), nil];
    
    
    Unknow_title = [[NSArray alloc] initWithObjects:NSLocalizedString(@"Unknown equipment ", nil), nil];
}


-(void)initUIObjects{
    
    float md_Y = self.view.frame.size.height*0.17;
    float md_H = self.view.frame.size.height*0.07;
    float md_X = self.view.frame.size.width*0.5;
    float md_W = self.view.frame.size.width*0.48;
    float mdx = self.view.frame.size.width*0.05;
    
    //Microlife 001
    deviceLabel = [[UILabel alloc] initWithFrame:CGRectMake(mdx+md_H, md_Y-md_H , md_W , md_H)];
    [deviceLabel setTextColor:[UIColor blackColor ]];
    deviceLabel.backgroundColor = [UIColor clearColor];
    deviceLabel.text = deviceStr;
    deviceLabel.font = [UIFont systemFontOfSize:22];
    deviceLabel.alpha = 1.0;
    deviceLabel.textAlignment = NSTextAlignmentLeft;
    
    [self.view addSubview:deviceLabel];

    //Microlife 001圖
    UIImageView *deviceImgV = [[UIImageView alloc] initWithFrame:CGRectMake(mdx, md_Y-md_H*0.9, md_H*0.8, md_H*0.8)];
    UIImage *deviceImg= [UIImage imageNamed:@"setting_icon_a_product"];
    deviceImgV.image = deviceImg;
    deviceImgV.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview :deviceImgV];
    
    
    //deviceNameLabel
    deviceNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(deviceImgV.frame)+10, CGRectGetMinY(deviceImgV.frame), self.view.frame.size.width - CGRectGetMaxX(deviceImgV.frame)-10, deviceImgV.frame.size.height)];
    deviceNameLabel.textColor = [UIColor blackColor];
    deviceNameLabel.adjustsFontSizeToFitWidth = YES;
    deviceNameLabel.font = [UIFont systemFontOfSize:22];
    [self.view addSubview:deviceNameLabel];
    
    
    //產品序號
    UILabel *numtittleLabel = [[UILabel alloc] initWithFrame:CGRectMake(mdx, md_Y , self.view.frame.size.width/4 , md_H)];
    [numtittleLabel setTextColor:[UIColor blackColor ]];
    numtittleLabel.backgroundColor = [UIColor clearColor];
    numtittleLabel.text = @"產品序號";
    numtittleLabel.font = [UIFont systemFontOfSize:22];
    numtittleLabel.alpha = 1.0;
    numtittleLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:numtittleLabel];
    
    
    //numLabel
    //numLabel = [[UILabel alloc] initWithFrame:CGRectMake(md_X, md_Y , md_W , md_H)];
    numLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(numtittleLabel.frame) , CGRectGetMinY(numtittleLabel.frame), self.view.frame.size.width - CGRectGetMaxX(numtittleLabel.frame) - mdx , numtittleLabel.frame.size.height)];
    [numLabel setTextColor:[UIColor blackColor ]];
    numLabel.backgroundColor = [UIColor clearColor];
    numLabel.text = @"";
    numLabel.font = [UIFont systemFontOfSize:22];
    numLabel.adjustsFontSizeToFitWidth = YES;
    numLabel.alpha = 1.0;
    numLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:numLabel];
    
    
    //產品序號
    UILabel *timestittleLabel = [[UILabel alloc] initWithFrame:CGRectMake(mdx, md_Y+md_H , self.view.frame.size.width/4, md_H)];
    [timestittleLabel setTextColor:[UIColor blackColor ]];
    timestittleLabel.backgroundColor = [UIColor clearColor];
    timestittleLabel.text = @"量測次數";
    timestittleLabel.font = [UIFont systemFontOfSize:22];
    timestittleLabel.alpha = 1.0;
    timestittleLabel.textAlignment = NSTextAlignmentLeft;
    
    [self.view addSubview:timestittleLabel];
    
    //timesLabel
    //timesLabel = [[UILabel alloc] initWithFrame:CGRectMake(md_X, md_Y+md_H , md_W , md_H)];
    timesLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(timestittleLabel.frame), CGRectGetMinY(timestittleLabel.frame), self.view.frame.size.width - CGRectGetMaxX(timestittleLabel.frame) - mdx, timestittleLabel.frame.size.height)];
    [timesLabel setTextColor:[UIColor blackColor ]];
    timesLabel.backgroundColor = [UIColor clearColor];
    timesLabel.text = @"999";
    timesLabel.font = [UIFont systemFontOfSize:22];
    timesLabel.alpha = 1.0;
    timesLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:timesLabel];
    
    //tableView
    MeasureTV = [[UITableView alloc]initWithFrame:CGRectMake(-1, md_Y+md_H*2, self.view.frame.size.width+2, (self.theErrorDic.count)*md_H)];
    
    MeasureTV.delegate = self;
    MeasureTV.dataSource = self;
//    MeasureTV.layer.borderWidth = 1;
//    MeasureTV.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor grayColor]);
    MeasureTV.pagingEnabled = false;
    MeasureTV.scrollEnabled = NO;
    MeasureTV.bounces = NO;
    [self.view addSubview:MeasureTV];
    
    
    [MeasureTV registerClass:[UITableViewCell class] forCellReuseIdentifier:@"MeasureCell_ID"];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(mdx, md_Y , self.view.frame.size.width*0.95, 1)];
    line1.backgroundColor = [UIColor colorWithRed:227.0f/255.0f green:227.0f/255.0f blue:227.0f/255.0f alpha:1.0];
    [self.view addSubview:line1];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(mdx, md_Y+md_H*1 , self.view.frame.size.width*0.95, 1)];
    line2.backgroundColor = [UIColor colorWithRed:227.0f/255.0f green:227.0f/255.0f blue:227.0f/255.0f alpha:1.0];
    [self.view addSubview:line2];
    
    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(mdx, md_Y+md_H*2 , self.view.frame.size.width*0.95, 1)];
    line3.backgroundColor = [UIColor colorWithRed:227.0f/255.0f green:227.0f/255.0f blue:227.0f/255.0f alpha:1.0];
    [self.view addSubview:line3];
    
    
    
    
}


-(void)MyDevicetableview{
    
    
}



-(void)MyDevicenav{
    
    UIView *pnavview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height*0.09)];
    pnavview.backgroundColor = [UIColor colorWithRed:0 green:61.0f/255.0f blue:165.0f/255.0f alpha:1.0];
    [self.view addSubview:pnavview];
    
    
    CGRect pnavFrame = CGRectMake(0, 0 , self.view.frame.size.width , self.view.frame.size.height*0.1);
    UILabel *pnavLabel = [[UILabel alloc] initWithFrame:pnavFrame];
    [pnavLabel setTextColor:[UIColor whiteColor ]];
    pnavLabel.backgroundColor = [UIColor clearColor];
    pnavLabel.text = @"MyDevice";
    pnavLabel.font = [UIFont systemFontOfSize:22];
    pnavLabel.alpha = 1.0;
    pnavLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:pnavLabel];
    
    
    UIButton *navbackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    navbackBtn.frame = CGRectMake(0, self.view.frame.size.height*0.026, self.view.frame.size.height*0.05, self.view.frame.size.height*0.05);
    [navbackBtn setImage:[UIImage imageNamed:@"all_btn_a_back"] forState:UIControlStateNormal ];
    navbackBtn.backgroundColor = [UIColor clearColor];
    navbackBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    
    [navbackBtn addTarget:self action:@selector(gobackSetting) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:navbackBtn];
    
    
    
}

-(void)gobackSetting{
    
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
    
}

#pragma mark - TableView Delegate  *********************
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.theErrorDic.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return self.view.frame.size.height*0.07 ;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Measurecell";
    MeasureCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        //cell = [[TimerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MeasureCell"owner:self options:nil];
        cell = [nib objectAtIndex:0];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    switch (m_deviceType) {
        case DeviceType_BPM:
            cell.errortittle.text = BPM_Error_title[indexPath.row];
            cell.errortimes.text = BPM_Error_ary[indexPath.row];
            break;
        case DeviceType_Weight:
            cell.errortittle.text = Weright_Error_title[indexPath.row];
            cell.errortimes.text = Weight_Error_ary[indexPath.row];
            break;
        case DeviceType_BT:
            cell.errortittle.text = BT_Error_title[indexPath.row];
            cell.errortimes.text = BT_Error_ary[indexPath.row];
            break;
        case DeviceType_Unknow:
            cell.errortittle.text = Unknow_title[indexPath.row];
            cell.errortimes.text = @"";
            break;
        default:
            break;
    }
    
    
    return cell;
}




#pragma mark - 實現代理的方法
-(void)postValue:(NSString *)stringp {
    
    //[self.person replaceObjectAtIndex:self.number withObject:stringp];
    [self->MeasureTV reloadData];
}



#pragma mark - refreshDeviceData  ******************
-(void)refreshDeviceData {

    deviceNameLabel.text = self.deviceName;
    numLabel.text = self.deviceNum;
    timesLabel.text = self.useCountStr;

}



#pragma mark - paser Error Code  **********************
/**
 error code
 
 BPM:
 Error1 / Error2 / Error3 / Error5
 ---------------------------------------------------
 Weight:
 ErrorWeightOverload / ErrorImpedance
 ----------------------------------------------------
 BT:
 ErrorAmbH / ErrorAmbL / ErrorBodyH / ErrorBodyL
 
 */
/**
-(DeviceType)distinguishErrorCode:(NSMutableArray *)ary_error {
    
    if (ary_error.count > 0) {
        
        NSNumber *BPM_ErrorNum = [ary_error[0] objectForKey:@"Error1"];
        if (BPM_ErrorNum != nil) {
            
            return DeviceType_BPM;
        }
        
        
        NSNumber *weight_ErrorNum = [ary_error[0] objectForKey:@"ErrorWeightOverload"];
        if (weight_ErrorNum != nil) {
            
            return DeviceType_Weight;
        }
        
        
        NSNumber *BT_ErrorNum = [ary_error[0] objectForKey:@"ErrorAmbH"];
        if (BT_ErrorNum != nil) {
            
            return DeviceType_BT;
        }
        
    }
    
    return DeviceType_BPM;
}
*/
 
//Paser Error code
-(void)parserErrorCode {
    
    DeviceType deviceType;
    
    if ([self.deviceName containsString:@"A6 BT"] || [self.deviceName containsString:@"A6 BASIS PLUS BT"] || [self.deviceName containsString:@"BP3GT1-6B"] || [self.deviceName containsString:@"B3 BT"] || [self.deviceName containsString:@"B6 Connect"]) {
        //血壓計
        
        m_deviceType = DeviceType_BPM;
        
        deviceType = DeviceType_BPM;
    }
    else if ([self.deviceName containsString:@"eBody-Fat-Scale"]) {
        //體脂計
        
         m_deviceType = DeviceType_Weight;
        
        deviceType = DeviceType_Weight;
        
    }
    else if ([self.deviceName containsString:@"3MW1"] || [self.deviceName containsString:@"NC150 BT"]) {
        //額溫槍
        
        m_deviceType = DeviceType_BT;
        
        deviceType = DeviceType_BT;
    }
    else {
        //不明設備
        
        m_deviceType = DeviceType_Unknow;
        
        deviceType = DeviceType_Unknow;
    }
    
    
    
    
    if (deviceType == DeviceType_BPM) {
        
        if (BPM_Error_ary.count > 0) {
            
            [BPM_Error_ary removeAllObjects];
        }
        
        [BPM_Error_ary addObject:[[NSString stringWithFormat:@"%@",[self.theErrorDic objectForKey:@"Error1"]] mutableCopy]];
        [BPM_Error_ary addObject:[[NSString stringWithFormat:@"%@",[self.theErrorDic objectForKey:@"Error2"]] mutableCopy]];
        [BPM_Error_ary addObject:[[NSString stringWithFormat:@"%@",[self.theErrorDic objectForKey:@"Error3"]] mutableCopy]];
        [BPM_Error_ary addObject:[[NSString stringWithFormat:@"%@",[self.theErrorDic objectForKey:@"Error5"]] mutableCopy]];
        
        
    }
    else if (deviceType == DeviceType_Weight) {
        
        if (Weight_Error_ary.count > 0) {
            
            [Weight_Error_ary removeAllObjects];
        }
        
        [Weight_Error_ary addObject:[[NSString stringWithFormat:@"%@",[self.theErrorDic objectForKey:@"ErrorWeightOverload"]] mutableCopy]];
        [Weight_Error_ary addObject:[[NSString stringWithFormat:@"%@",[self.theErrorDic objectForKey:@"ErrorImpedance"]] mutableCopy]];
        
    }
    else if (deviceType == DeviceType_BT){
        
        if (BT_Error_ary.count > 0) {
            
            [BT_Error_ary removeAllObjects];
        }
        
        [BT_Error_ary addObject:[[NSString stringWithFormat:@"%@",[self.theErrorDic objectForKey:@"ErrorAmbH"]] mutableCopy]];
        [BT_Error_ary addObject:[[NSString stringWithFormat:@"%@",[self.theErrorDic objectForKey:@"ErrorAmbL"]] mutableCopy]];
        [BT_Error_ary addObject:[[NSString stringWithFormat:@"%@",[self.theErrorDic objectForKey:@"ErrorBodyH"]] mutableCopy]];
        [BT_Error_ary addObject:[[NSString stringWithFormat:@"%@",[self.theErrorDic objectForKey:@"ErrorBodyL"]] mutableCopy]];
        
    }
    else {
        
        if (Unknow_ary == nil) {
            
            Unknow_ary = [[NSMutableArray alloc] init];
        }
        
    }
    
    [MeasureTV reloadData];
    
}

@end
