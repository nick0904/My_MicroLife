//
//  BLEDataHandler.m
//  Microlife
//
//  Created by Rex on 2016/10/11.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import "BLEDataHandler.h"
#import "MViewController.h"

@implementation BLEDataHandler {
    
    APIPostAndResponse *apiClass;
    
    ///BT Device
    NSString *bt_device_mode;
    NSString *bt_device_macAddress;
    
    ///BP Device
    NSString *bp_device_mode;
    NSString *bp_device_macAddress;
    
    
    ///Weight Device
    NSString *weight_device_mode;
    NSString *weight_deivce_macAddress;
    
}

#pragma mark - initalization ******************
-(instancetype)init{
    
    self = [super init];
    
    if (self) {
        
        [self setUp];
    }
    
    return self;
}

- (void)setUp{
    
    [self initBPMProtocal];
    [self initBTProtocal];
    [self initEBodyProtocol];
    
    scanIndex = 0;
    
    
    //API
    apiClass = [[APIPostAndResponse alloc] initCloud];
    apiClass.delegate = self;
}


//血壓計
-(void)initBPMProtocal{
    
    bPMProtocol = [[BPMProtocol alloc] getInstanceSimulation:NO PrintLog:YES];
    bPMProtocol.dataResponseDelegate = self;
    bPMProtocol.connectStateDelegate = self;
    
    [bPMProtocol enableBluetooth];
}

//額溫計
-(void)initBTProtocal{
    
    thermoProtocol = [[ThermoProtocol alloc] getInstanceSimulation:NO PrintLog:YES];
    thermoProtocol.dataResponseDelegate = self;
    thermoProtocol.connectStateDelegate = self;
}

//體脂計
-(void)initEBodyProtocol {
    
    eBodyProtocol=[[EBodyProtocol alloc] getInstanceSimulation:NO PrintLog:YES];
    eBodyProtocol.connectStateDelegate=self;
    eBodyProtocol.dataResponseDelegate=self;
}


#pragma mark - protocol Start **********************
-(void)protocolStart{
    
    checkThermTimer = [NSTimer scheduledTimerWithTimeInterval:0.2f target:self selector:@selector(changeConnect) userInfo:nil repeats:YES];
}

-(void)changeConnect {
    
    /*
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *date = [NSDate date];
    
    int year = [calendar component:NSCalendarUnitYear fromDate:date];
    int month = [calendar component:NSCalendarUnitMonth fromDate:date];
    int day = [calendar component:NSCalendarUnitDay fromDate:date];
    int hour = [calendar component:NSCalendarUnitHour fromDate:date];
    int min = [calendar component:NSCalendarUnitMinute fromDate:date];
    int sec = [calendar component:NSCalendarUnitSecond fromDate:date];
     
    NSLog(@"==>%d/%d/%d %d:%d:%d<==",year,month,day,hour,min,sec);
    */
    
    if(!isChecking)
    {
        isChecking = YES;
        
        switch (scanIndex) {
            case 5:
                [eBodyProtocol stopScan];
                tag = BPM;
                isSetInfo = NO;
                [bPMProtocol startScanTimeout:10];
                break;
            
            case 10:
                [bPMProtocol stopScan];
                tag = Temp;
                [thermoProtocol startScanTimeout:10];
                break;
            
            case 15:
                [thermoProtocol stopScan];
                tag = Weight;
                [eBodyProtocol startScanTimeout:10];
                break;
                
            default:
                break;
        }
        
    }
    
    scanIndex++;
    
    if (scanIndex == 5 || scanIndex == 10 || scanIndex == 15) {
        isChecking = NO;
    }
    
    if (scanIndex == 20) {
        scanIndex = 0;
    }
    
}

#pragma mark - command delegate
/**
 * 開啟設備BLE事件
 * @param isEnable 藍牙是否開啟
 */
- (void) onBtStateChanged:(bool) isEnable{
    NSLog(@"onBtStateChanged-----isEnable = %i", isEnable);
}

/**
 * 返回掃描到的藍牙
 * @param uuid mac address
 * @param name 名稱
 * @param rssi 訊號強度
 */
- (void) onScanResultUUID:(NSString*) uuid Name:(NSString*) name RSSI:(int) rssi{
    
    NSLog(@"BLE Scan Message ======>>> onScanResultUUID-----uuid = %@ , name = %@ , rssi = %i", uuid, name, rssi);

    //額溫計
    if([name containsString:@"3MW1"] || [name containsString:@"NC150 BT"]){
        
        if (tag == Temp) {
            
            cur_uuid = uuid;
            [thermoProtocol connectUUID:uuid];
        }
    }
    
    //血壓計
    if([name containsString:@"A6 BT"] || [name containsString:@"A6 BASIS PLUS BT"] || [name containsString:@"BP3GT1-6B"] || [name containsString:@"B3 BT"] || [name containsString:@"B6 Connect"] || [name containsString:@"A6"]) {
        
        if (tag == BPM) {
            
            [bPMProtocol connectUUID:uuid];
        }
    }
    
    
    //體脂計
    if([name containsString:@"eBody-Fat-Scale"] || [name containsString:@"ebody"] || [name containsString:@"BFS800"]) {
        
        if (tag == Weight) {
            
            [eBodyProtocol connectUUID:uuid];
        }
    }
    
}

/**
 * 連線狀態
 * ScanFinish,			//掃描結束
 * Connected,			//連線成功
 * Disconnected,		//斷線
 * ConnectTimeout,		//連線超時
 */
- (void)onConnectionState:(ConnectState)state{
    
    NSLog(@"onConnectionState-----state = %i", state);
    
    connectState = state;
    
    if(state == Connected){
        
        NSLog(@"connection status Connected");
        
        isChecking = YES;
        
        if (tag == BPM) {
            [bPMProtocol stopScan];
            [self syncBPM];
        }
        
        if (tag == Temp) {
            
            [thermoProtocol stopScan];
            
        }
        
        if (tag == Weight) {
            
            [eBodyProtocol stopScan];
            
        }
        
    }else if(state == Disconnect || state == ConnectTimeout || state == ScanFinish){
        
        NSLog(@"connection status Disconnected");
        
        isChecking = NO;
        
    }
}

#pragma mark - BPM Method
-(void)syncBPM{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *date = [NSDate date];
    
    int year=[calendar component:NSCalendarUnitYear fromDate:date];
    int month=[calendar component:NSCalendarUnitMonth fromDate:date];
    int day=[calendar component:NSCalendarUnitDay fromDate:date];
    int hour=[calendar component:NSCalendarUnitHour fromDate:date];
    int min=[calendar component:NSCalendarUnitMinute fromDate:date];
    int sec=[calendar component:NSCalendarUnitSecond fromDate:date];
    
    NSLog(@"==>%d/%d/%d %d:%d:%d<==",year,month,day,hour,min,sec);
    [bPMProtocol readUserAndVersionData];

    [bPMProtocol readHistorysOrCurrDataAndSyncTiming:year month:month day:day hour:hour minute:min second:sec];
}

//==========================================

#pragma mark - BT Command delegate (額溫計 Device Info)
-(void)onResponseDeviceInfo:(NSString *)macAddress workMode:(int)workMode batteryVoltage:(float)batteryVoltage {
    
    NSLog(@"macAddress:%@",macAddress);
    NSLog(@"workMode:%d",workMode);
    NSLog(@"batteryVoltage:%f",batteryVoltage);
    
    //macAddress
    bt_device_macAddress = [MViewController transformMacAddress:macAddress];
    NSLog(@"bt_device_macAddress:%@",bt_device_macAddress);
    
    //device Name
    if ([MViewController checkConnectingDeviceNamePath]) {
        
        bt_device_mode = [NSString stringWithContentsOfFile:ConnectingDevie_NamePath encoding:NSUTF8StringEncoding error:nil];
    }
    
    //1:Get device list from cloud
    [self getDeviceListfromCloud];
    
}


#pragma mark - ThermoData Delegate 額溫計  ****************************
-(void)onResponseUploadMeasureData:(ThermoMeasureData *)data {
    //NSLog(@"%@",[data toString]);
    
    int mode = [data getMode]; //0身體  1物質
    
    if(mode == 1 ){
        
        NSLog(@"Receive mode 1");
        
        return;
    }
    
    float bodyTemp = roundf([data getMeasureTemperature]*100.0)/100.0;
    float roomTemp = roundf([data getAmbientTemperature]*100.0)/100.0;
    
    //=====save data to DB=====
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"YYYY"];
    
    NSString *yearString=[dateFormatter stringFromDate:[NSDate date]];
    
    NSString *year = [NSString stringWithFormat:@"%d",[data getYear]];
    yearString = [yearString substringToIndex:2];
    yearString = [yearString stringByAppendingString:year];
    
    NSString *month = [NSString stringWithFormat:@"%02d",[data getMonth]];
    NSString *day = [NSString stringWithFormat:@"%02d",[data getDay]];
    NSString *hour = [NSString stringWithFormat:@"%02d",[data getHour]];
    NSString *minute = [NSString stringWithFormat:@"%02d",[data getMinute]];
    
    NSString *date = [NSString stringWithFormat:@"%@-%@-%@ %@:%@",yearString,month,day,hour,minute];
    

    [BTClass sharedInstance].accountID = [LocalData sharedInstance].accountID;
    
    [BTClass sharedInstance].eventID = [LocalData sharedInstance].currentEventId;
    
    [BTClass sharedInstance].date = date;
    
    [BTClass sharedInstance].bodyTemp = [NSString stringWithFormat:@"%.1f",bodyTemp];
    [BTClass sharedInstance].roomTmep = [NSString stringWithFormat:@"%.1f",roomTemp];
    [BTClass sharedInstance].BT_PhotoPath = @"";
    [BTClass sharedInstance].BT_Note = @"";
    [BTClass sharedInstance].BT_RecordingPath = @"";
    
    
    NSLog(@"BTClass  selectAllData = %@", [[BTClass sharedInstance] selectAllData]);
    
    NSDictionary *latestTemp = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  [NSString stringWithFormat:@"%.1f",bodyTemp],@"bodyTemp",
                                  [NSString stringWithFormat:@"%.1f",roomTemp],@"roomTemp",
                                  date,@"date",
                                  nil];
    
//    if ([self checkSaveData:latestTemp]) {
//        [[BTClass sharedInstance] insertData];
//    }
    
    [[LocalData sharedInstance] saveLatestMeasureValue:latestTemp];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"receiveTempData" object:nil];
    
    //[thermoProtocol disconnect];
    
}



#pragma mark - BPM Device info  *****************
-(void)onResponseReadDeviceInfo:(DeviceInfo *)deviceInfo {
    
    NSLog(@"血壓計 deviceInfo: %@",deviceInfo);
}

//onResponseReadUserAndVersionData
-(void)onResponseReadUserAndVersionData:(User *)user VersionData:(VersionData *)verData {
    isAfib = verData.isOptionAfib;
}

#pragma mark - BPM Delegate 血壓計 ***************************
//讀取歷史與現況 回應
-(void)onResponseReadHistory:(DRecord *)data {
    NSMutableArray *currentData = [data getCurrentData];
    
    NSMutableArray *MData = [data getMData];
    
    NSMutableArray *allData = [NSMutableArray array];
    
//    NSLog(@"\n=== MData start ===");
//    
//    for(CurrentAndMData *curMdata in MData) {
//        
//        NSLog(@"%@",[curMdata toString]);
//        [allData addObject:curMdata];
//    }
    
    NSLog(@"isAfib:%@",isAfib?@"yes":@"no");
    
    NSLog(@"\n=== MData end ===");

    NSLog(@"\n=== currentData start ===");
    
    for(CurrentAndMData *curMdata in currentData) {
        
        NSLog(@"curMdata:%@",[curMdata toString]);
        [allData addObject:curMdata];
    }
    
    NSLog(@"\n=== currentData end ===");
    
    NSLog(@"\n=== allData start ===%lu",(unsigned long)allData.count);

    NSArray *selectAllData = [[BPMClass sharedInstance] selectAllData];
    for (CurrentAndMData *curMdata in MData) {
        NSLog(@"\n=== MData start ===");
        NSInteger checkOK = 0;
        if ([[selectAllData firstObject] count] != 1) {
            for (int i=0; i<selectAllData.count; i++) {
                NSString *SYSStr = [[selectAllData objectAtIndex:i] objectAtIndex:0];
                NSString *DIAStr = [[selectAllData objectAtIndex:i] objectAtIndex:1];
                NSString *PULStr = [[selectAllData objectAtIndex:i] objectAtIndex:2];
                NSString *dateStr = [[selectAllData objectAtIndex:i] objectAtIndex:9];
                NSString *year = [NSString stringWithFormat:@"%d",curMdata.year];
                NSString *month = [NSString stringWithFormat:@"%02d",curMdata.month];
                NSString *day = [NSString stringWithFormat:@"%02d",curMdata.day];
                NSString *hour = [NSString stringWithFormat:@"%02d",curMdata.hour];
                NSString *minute = [NSString stringWithFormat:@"%02d",curMdata.minute];
                BOOL check1 = ([SYSStr isEqualToString:[NSString stringWithFormat:@"%d",curMdata.systole]])?NO:YES;
                BOOL check2 = ([DIAStr isEqualToString:[NSString stringWithFormat:@"%d",curMdata.dia]])?NO:YES;
                BOOL check3 = ([PULStr isEqualToString:[NSString stringWithFormat:@"%d",curMdata.hr]])?NO:YES;
                BOOL check4 = ([dateStr isEqualToString:[NSString stringWithFormat:@"%@-%@-%@ %@:%@",year,month,day,hour,minute]])?NO:YES;
                NSLog(@"1selectAllData::%@,%@,%@,%@",check1?@"yes":@"no",check2?@"yes":@"no",check3?@"yes":@"no",check4?@"yes":@"no");
                if (check1 && check2 && check3 && check4) {
                    checkOK += 1;
                }
            }
        }else {
            [allData addObject:curMdata];
        }
        
        if (checkOK == selectAllData.count) {
            NSLog(@"MData:%@",[curMdata toString]);
            [allData addObject:curMdata];
        }
        NSLog(@"\n=== MData end ===");
    }
    
    NSLog(@"\n=== allData end ===");
    
    //NSLog(@"currentData = %@",currentData);  selectAllData
    /*
     //縮收壓
     @property int systole;
     //舒張壓
     @property int dia;
     //心跳
     @property int hr;
     
     //年月日 時分
     @property int year;
     @property int month;
     @property int day;
     @property int hour;
     @property int minute;
     
     //0=MAM disable, 1=Weight off, 2=Weight on, 3=Light off, 4=Light on
     @property BOOL MAM;
     //the data detect with PAD 心律不整
     @property BOOL arr;
     */
    
    //=====save data to DB=====
    
    NSLog(@"\n=== currentData start ===");
    for(CurrentAndMData *curMdata in allData) {
        
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
//        [dateFormatter setDateFormat:@"YYYY"];
        if (curMdata.year > 0) {
            NSString *year = [NSString stringWithFormat:@"%d",curMdata.year+2000];
            
            NSString *month = [NSString stringWithFormat:@"%02d",curMdata.month];
            NSString *day = [NSString stringWithFormat:@"%02d",curMdata.day];
            NSString *hour = [NSString stringWithFormat:@"%02d",curMdata.hour];
            NSString *minute = [NSString stringWithFormat:@"%02d",curMdata.minute];
            
            NSString *date = [NSString stringWithFormat:@"%@-%@-%@ %@:%@",year,month,day,hour,minute];
            
            [BPMClass sharedInstance].accountID = [LocalData sharedInstance].accountID;
            [BPMClass sharedInstance].SYS = curMdata.systole;
            [BPMClass sharedInstance].DIA = curMdata.dia;
            [BPMClass sharedInstance].PUL = curMdata.hr;
            
            //目前裝置無法支援PAD量測
            int AFIB = curMdata.arr?1:0;
            [BPMClass sharedInstance].PAD = isAfib?0:AFIB;
            [BPMClass sharedInstance].AFIB =isAfib?AFIB:0;
            [BPMClass sharedInstance].date = date;
            [BPMClass sharedInstance].BPM_PhotoPath = @"";
            [BPMClass sharedInstance].BPM_Note = @"";
            [BPMClass sharedInstance].BPM_RecordingPath = @"";
            [BPMClass sharedInstance].MAM = curMdata.MAM?1:0;
            
            
            NSLog(@"BPMClass insert data = %@", [[BPMClass sharedInstance] selectAllData]);
            NSDictionary *latestBP = [[NSDictionary alloc] initWithObjectsAndKeys:
                                      [NSString stringWithFormat:@"%d",curMdata.systole],@"SYS",
                                      [NSString stringWithFormat:@"%d",curMdata.dia],@"DIA",
                                      [NSString stringWithFormat:@"%d",curMdata.hr],@"PUL",
                                      date,@"date",
                                      [NSString stringWithFormat:@"%d",curMdata.arr],@"Arr",
                                      [NSString stringWithFormat:@"%d",curMdata.MAM],@"MAM",
                                      nil];
            
            if ([self checkSaveData:latestBP]) {
                [[BPMClass sharedInstance] insertData];
            }
            
            [[LocalData sharedInstance] saveLatestMeasureValue:latestBP];
        }
    }
    NSLog(@"\n=== currentData end ===");
    
    //[bPMProtocol disconnect];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"receiveBPMData" object:nil];
    
    //0=MAM disable, 1=Weight off, 2=Weight on, 3=Light off, 4=Light on
    //@property BOOL MAM;
    
    //the data detect with PAD 心律不整
    //@property BOOL arr;
    
    /*
     === currentData start ===
     2016-10-11 17:18:06.508 Microlife[11817:3094671] year=2000
     month = 10
     day = 11
     hour = 17
     minute = 17
     systole = 137
     dia = 83
     hr = 82
     MAM = 0
     arr = 0
     === currentData end ===
     */
}

#pragma mark - Ebody Delegate  體脂計 ****************************
-(void)onResponseMeasuringData:(int)unit weight:(int)weight
{
    NSLog(@"onResponseMeasuringData unit:%d weight:%d",unit,weight);
    
    if(!isSetInfo)
    {
        /**
         *
         *@param  athlete  運動員類型  0=普通，1=業餘運動員，2=運動員
         *@param  gender  性別  1=man, 0=woman
         *@param  age
         *@param  height  身高
         */
        
        [eBodyProtocol setupPersonParam:0 gender:1 age:27 height:[LocalData sharedInstance].UserHeight];
        
        isSetInfo=YES;
    }
    
}

-(void)onResponseEBodyMeasureData:(EBodyMeasureData *)eBodyMeasureData {
    
    NSLog(@"onResponseEBodyMeasureData ==>%@",[eBodyMeasureData toString]);
    
    NSString *year = [NSString stringWithFormat:@"%d",[eBodyMeasureData getYear]];
    
    NSString *month = [NSString stringWithFormat:@"%02d",[eBodyMeasureData getMonth]];
    NSString *day = [NSString stringWithFormat:@"%02d",[eBodyMeasureData getDay]];
    NSString *hour = [NSString stringWithFormat:@"%02d",[eBodyMeasureData getHour]];
    NSString *minute = [NSString stringWithFormat:@"%02d",[eBodyMeasureData getMinute]];
    
    NSString *date = [NSString stringWithFormat:@"%@-%@-%@ %@:%@",year,month,day,hour,minute];
    
    [WeightClass sharedInstance].accountID = [LocalData sharedInstance].accountID;
    [WeightClass sharedInstance].weight = [eBodyMeasureData getWeight];
    [WeightClass sharedInstance].date = date;
    [WeightClass sharedInstance].water = [eBodyMeasureData getWater];
    [WeightClass sharedInstance].bodyFat = [eBodyMeasureData getFat];
    [WeightClass sharedInstance].muscle = [eBodyMeasureData getMuscle];
    [WeightClass sharedInstance].skeleton = [eBodyMeasureData getBone];
    [WeightClass sharedInstance].BMI = [eBodyMeasureData getBMI];
    [WeightClass sharedInstance].BMR = [eBodyMeasureData getKcal];
    [WeightClass sharedInstance].organFat = [eBodyMeasureData getVisceraFat];
    [WeightClass sharedInstance].weight_PhotoPath = @"";
    [WeightClass sharedInstance].weight_Note = @"";
    [WeightClass sharedInstance].weight_RecordingPath = @"";

    
//    [eBodyProtocol disconnect];
    
    NSDictionary *latestWeight = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  [NSString stringWithFormat:@"%f",[eBodyMeasureData getWeight]],@"weight",
                                  [NSString stringWithFormat:@"%f",[eBodyMeasureData getFat]],@"bodyFat",
                                  [NSString stringWithFormat:@"%f",[eBodyMeasureData getBMI]],@"BMI",
                                  date,@"date",
                                  nil];
    
    if ([self checkSaveData:latestWeight]) {
        [[WeightClass sharedInstance] insertData];
    }

    [[LocalData sharedInstance] saveLatestMeasureValue:latestWeight];
    
    NSLog(@"藍芽。。latestWeight = %@",latestWeight);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"receiveWeightData" object:nil];
    
    /*
     @property (nonatomic) int weightID;                     //體脂機ID
     @property (nonatomic) int accountID;                    //會員ID
     @property (nonatomic) int weight;                       //體重
     @property (nonatomic) int weightUnit;                   //體重單位 0 : kg 1 : lb
     @property (nonatomic) int BMI;                          //身體質量指數
     @property (nonatomic) int bodyFat;                      //體脂肪
     @property (nonatomic) int water;                        //體水分
     @property (nonatomic) int skeleton;                     //骨質量
     @property (nonatomic) int muscle;                       //肌肉
     @property (nonatomic) int BMR;                          //基礎代謝率
     @property (nonatomic) int organFat;                     //內臟脂肪
     @property (nonatomic) NSString *date;                   //日期
     @property (nonatomic) NSString * weight_PhotoPath;      //筆記照片路徑
     @property (nonatomic) NSString * weight_Note;           //筆記內容
     @property (nonatomic) NSString * weight_RecordingPath;  //筆記錄音路徑
     
     [BPMClass sharedInstance] = (
     {
     BMI = 25;
     BMR = 1433;
     accountID = 521;
     bodyFat = 76;
     date = "2016/10/11 19:05";
     eventID = 0;
     muscle = 85;
     organFat = 10;
     skeleton = 5;
     water = 75;
     weight = 73;
     weightUnit = 0;
     "weight_Note" = "";
     "weight_PhotoPath" = "";
     "weight_RecordingPath" = "";
     }
     */
    
    /*
     onResponseEBodyMeasureData ==>EBodyMeasureData:
     unit=1
     weight=73.600000
     year=2016
     month=10
     day=11
     hour=18
     minute=52
     second=25
     althleteLevel=0
     gender=1
     age=19
     height=180
     fat=76.700000
     water=75.000000
     muscle=88.000000
     bone=6.100000
     visceraFat=8
     kcal=1537
     BMI=22.716049
     */
    
}


#pragma mark - Get Device List from Cloud  ****************************
-(void)getDeviceListfromCloud {
    
    NSString *tokenStr = [NSString stringWithContentsOfFile:OAuth_TOKEN encoding:NSUTF8StringEncoding error:nil];
    [apiClass postGetDeviceList:tokenStr];
}
#pragma mark -  API Delegate  *********************
-(void)processeGetDeviceList:(NSDictionary *)resopnseData Error:(NSError *)jsonError {
    
    if (jsonError) {
        
        NSLog(@"GetDeviceList jsonError: %@",jsonError);
    }
    else {
        
        NSLog(@"GetDeviceList resopnseData:%@",resopnseData);
        
        if ([[resopnseData objectForKey:@"code"] intValue] == 10000) {
            
            //BPM
            NSMutableArray *ary_bmp = [[NSMutableArray alloc] initWithArray:[resopnseData objectForKey:@"bpm"]];
            
            if (ary_bmp.count != 0) {
                
                [self checkBPMDevices:ary_bmp];
                
            }
            
            //Weight
            NSMutableArray *ary_weight = [[NSMutableArray alloc] initWithArray:[resopnseData objectForKey:@"weight"]];
            
            if (ary_weight.count != 0) {
                
                [self checkWeightDevices:ary_weight];
            }
            
            
            //BT
            NSMutableArray *ary_bt = [[NSMutableArray alloc] initWithArray:[resopnseData objectForKey:@"bt"]];
            
            [self checkBTDevices:ary_bt];
            
        }
        
    }
    
}


-(void)processeAddDevice:(NSDictionary *)resopnseData Error:(NSError *)jsonError {
    
    if (jsonError) {
        
        NSLog(@"AddDevice jsonError: %@",jsonError);
    }
    else {
        
        NSLog(@"AddDevice resopnseData: %@",resopnseData);
    }
    
}



-(void)checkBPMDevices:(NSMutableArray *)ary_bmp {
    
    for (int i = 0; i < ary_bmp.count; i++) {
        
        if (![[ary_bmp[i] objectForKey:@"device_mode"] isEqualToString: bp_device_mode] && ![[ary_bmp[i] objectForKey:@"mac_address"] isEqualToString:bp_device_macAddress]) {
            
            NSString *tokenStr = [NSString stringWithContentsOfFile:OAuth_TOKEN encoding:NSUTF8StringEncoding error:nil];
            
            [apiClass postAddDevice:tokenStr device_type:1 device_model:bp_device_mode error_code:@"" mac_address:bp_device_macAddress];
            
        }
        
    }
    
}


-(void)checkWeightDevices:(NSMutableArray *)ary_weight {
    
     for (int i = 0; i < ary_weight.count; i++) {
         
         if (![[ary_weight[i] objectForKey:@"device_mode"] isEqualToString: weight_device_mode] && ![[ary_weight[i] objectForKey:@"mac_address"] isEqualToString:weight_deivce_macAddress]) {
             
             NSString *tokenStr = [NSString stringWithContentsOfFile:OAuth_TOKEN encoding:NSUTF8StringEncoding error:nil];
         
             [apiClass postAddDevice:tokenStr device_type:2 device_model:weight_device_mode error_code:@"" mac_address:weight_deivce_macAddress];
         }
         
     }
    
}


-(void)checkBTDevices:(NSMutableArray *)ary_bt {
    
    NSLog(@"bt_device_mode:%@ \n bt_device_macAddress:%@",bt_device_mode,bt_device_macAddress);
    
    if (ary_bt.count ==0) {
        
        NSString *tokenStr = [NSString stringWithContentsOfFile:OAuth_TOKEN encoding:NSUTF8StringEncoding error:nil];
        
        [apiClass postAddDevice:tokenStr device_type:3 device_model:bt_device_mode error_code:@"" mac_address:bt_device_macAddress];

    }
    else {
        
        for (int i = 0; i < ary_bt.count; i++) {
            
            if (![[ary_bt[i] objectForKey:@"device_mode"] isEqualToString: bt_device_mode] && ![[ary_bt[i] objectForKey:@"mac_address"] isEqualToString:bt_device_macAddress]) {
                
                NSString *tokenStr = [NSString stringWithContentsOfFile:OAuth_TOKEN encoding:NSUTF8StringEncoding error:nil];
                
                [apiClass postAddDevice:tokenStr device_type:3 device_model:bt_device_mode error_code:@"" mac_address:bt_device_macAddress];
                
            }
            
        }
        
    }
    
}

- (BOOL)checkSaveData:(id)data {
    if ([[AppDelegate readNSUserDefaults:@"checkSaveData"] isEqual:data]) {
        NSLog(@"checkSaveData:NO");
        return NO;
    }else {
        NSLog(@"checkSaveData:YES");
        [AppDelegate saveNSUserDefaults:data Key:@"checkSaveData"];
        return YES;
    }
}


@end
