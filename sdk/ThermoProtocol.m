
#import "ThermoProtocol.h"
#import "CommandType.h"
#import "ThermoMeasureData.h"

 
//ThermoProtocol *instance;

int THER_CMD_LENGTH_INDEX_START = 4;
int THER_CMD_LENGTH_INDEX_END = 8;

int THER_CMD_CMD_INDEX_START = 8;
int THER_CMD_CMD_INDEX_END = 10;

float THER_FREQUESCY = 0.3;
float THER_FREQUESCY_SHORT = 0.2;
float THER_FREQUESCY_LONG = 1.0;


@implementation ThermoProtocol{
    bool isSimulation;
    bool isPrintLog;
    
    //Simulation----------------------------------
    NSTimer *simulationTimer;
    
    NSString *bleName;
    NSString *bleMac;
    
    NSMutableArray *simulationMacArray,*simulationNameArray;
    int simulationPosition;
    //Simulation----------------------------------
    
    NSString *allReceivedCommand;
    int RECEIVED_ERROR_COUNT;
    int receiveErrorCount;
    
    
    //暫存
    int pageTotalNum;
    int totalPacketNum;
    
    NSMutableArray* packetArr;
    int FWReSendCount;
    int FWErrPacketNO;

    int lastPacketNo;
    int lastPageSizeForFW;
    int lastPacketSizeForFW;
    
}
//@synthesize commandDelegate;

//初始化
//@param simulation 是否開啟模擬數據
//@param printLog 是否印出SDK Log
- (id)getInstanceSimulation:(bool)simulation PrintLog:(bool)printLog{
    isSimulation = simulation;
    isPrintLog = printLog;
    
    [Function setPrintLog:isPrintLog];
    
    
    allReceivedCommand = @"";
    RECEIVED_ERROR_COUNT = 10;
    receiveErrorCount = 0;
    
    
    if(isSimulation){
        bleName = @"Fuel";
        bleMac = @"1234567890";
        simulationPosition = 0;
      
        
        simulationMacArray = [[NSMutableArray alloc] initWithCapacity:10];
        simulationNameArray = [[NSMutableArray alloc] initWithCapacity:10];
        for(int i = 1 ; i < 11 ; i++){
            [simulationNameArray addObject:[NSString stringWithFormat:@"%@-%i", bleName, i]];
            [simulationMacArray addObject:[NSString stringWithFormat:@"%@%i", bleMac, (i - 1)]];
        }
        return self;
    }
    
    [self init ];
    return self;
    
//    if(instance == nil)
//        instance = [[FuelProtocol alloc] init];
//    return instance;
}

- (id)init{
    self = [super init];
    if(self){
        NSNumber *type = [NSNumber numberWithInt:cpAndFF];
        NSMutableDictionary *info = [NSMutableDictionary dictionary];
        [info setValue:@"0000fff0-0000-1000-8000-00805f9b34fb" forKey:@"serviceUUID"];
        [info setValue:@"0000fff2-0000-1000-8000-00805f9b34fb" forKey:@"writeUUID"];
        [info setValue:@"0000fff1-0000-1000-8000-00805f9b34fb" forKey:@"notifyUUID"];
        //體脂計
        //[info setValue:@"0000fff3-0000-1000-8000-00805f9b34fb" forKey:@"writeUUID"];
        //[info setValue:@"0000fff4-0000-1000-8000-00805f9b34fb" forKey:@"notifyUUID"];
        
        [info setValue:@"4D" forKey:@"header"];
        [info setValue:@"-1" forKey:@"end"];
        [info setValue:@"0.6" forKey:@"frequency"];
        [info setValue:type forKey:@"checksumType"];
        
        [self initWithInfo:info PrintLog:isPrintLog];
        
        self.myBluetooth.myBLEDelegate = self;
    }
    return self;
}

//檢查是否支援藍牙LE。如果是,彈出詢問使用者是否開啟藍牙視窗
- (void)enableBluetooth{
    [self.myBluetooth enableBluetooth];
}

//開始掃瞄,透過onScanResultMac傳回掃描到的藍牙資訊
//@param timeout 掃描時間(sec)
- (void) startScanTimeout:(int)timeout{
    [self stopScan];
    [Function printLog:@"開始掃描"];
    if(isSimulation){
        simulationTimer = [NSTimer scheduledTimerWithTimeInterval:0.7f target:self selector:@selector(simulationScan) userInfo:nil repeats:YES];
        return;
    }
    
//  @[[CBUUID UUIDWithString:@"49535343-1E4D-4BD9-BA61-23C647249616"]]
//    @[[CBUUID UUIDWithString:@"49535343-FE7D-4AE5-8FA9-9FAFD205E455"]]
//    NSArray *uuids = [NSArray arrayWithObject:[CBUUID UUIDWithString:@"49535343-FE7D-4AE5-8FA9-9FAFD205E455"]];
    [self.myBluetooth imStartScanUUIDs:nil Timeout:timeout];
}

//停止掃瞄
- (void)stopScan{
    [Function printLog:@"停止掃描"];
    if(isSimulation){
        [self cancelTimer];
        return;
    }
    [self.myBluetooth imStopScan];
}

- (BOOL) isSupportBLE{
    return [self.myBluetooth isSupportBLE];
}

- (void) connectUUID:(NSString *)uuid{
    [self stopScan];
    [Function printLog:@"連線"];
    if(isSimulation){
        [self.connectStateDelegate onConnectionState:Connected];
        return;
    }
    NSArray *array = [[NSArray alloc] initWithObjects:uuid, nil];
    
    [self.myBluetooth imConnectUUIDs:array];
    
}

//斷線,透過onConnectionState返回斷線狀態
- (void) disconnect{
    [Function printLog:@"斷線"];
    if(isSimulation){
        [self cancelTimer];
        [self.connectStateDelegate onConnectionState:Disconnect];
        return;
    }
    [self commTimerStop];
    [self.myBluetooth imDisconnect];
}

//--------------------------------------------------------------------------------------------------------------------

//回應時間與MAC 取溫度
- (void) replyMacAddressOrTime:(int) workMode macAddress:(NSString*)mac{
    
    if(isSimulation){
        return;
    }
    
    NSLog(@"replyMacAddressOrTime");
    
    //command.
    NSString *command = @"01";
    NSString *data =  @"";
    
    if (workMode == 3) {//work in CAL mode.
        data = mac;
    }
    else
    {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDate *date = [NSDate date];
        
        int year=[calendar component:NSCalendarUnitYear fromDate:date];
        int month=[calendar component:NSCalendarUnitMonth fromDate:date];
        int day=[calendar component:NSCalendarUnitDay fromDate:date];
        int hour=[calendar component:NSCalendarUnitHour fromDate:date];
        int min=[calendar component:NSCalendarUnitMinute fromDate:date];
        int sec=[calendar component:NSCalendarUnitSecond fromDate:date];
        
        NSLog(@"==>%d/%d/%d %d:%d:%d<==",year,month,day,hour,min,sec);
        
        NSString *yy=[NSString stringWithFormat:@"%02x",year%100];
        NSString *mon=[NSString stringWithFormat:@"%02x",month];
        NSString *dd=[NSString stringWithFormat:@"%02x",day];
        
        NSString *hh=[NSString stringWithFormat:@"%02x",hour];
        NSString *mm=[NSString stringWithFormat:@"%02x",min];
        NSString *ss=[NSString stringWithFormat:@"%02x",sec];
        
        data=[NSString stringWithFormat:@"%@%@%@%@%@%@",yy,mon,dd,hh,mm,ss];
        
    }
    
    NSString *result = [self buildCommand:command data:data];
    
    [self addCommArray:result RemoveAllComm:false];
    
}

-(void)replyUploadMeasureData:(int)ack {
    
    if(isSimulation){
        return;
    }
    
    NSLog(@"replyUploadMeasureData");
    
    
    NSString *command = [NSString stringWithFormat:@"%d",ack];  // @"81";
    NSString *data =  @"";
    
    
    NSString *result = [self buildCommand:command data:data];
    
    [self addCommArray:result RemoveAllComm:false];
    
}

-(NSString*)buildCommand:(NSString*)command data:(NSString*)data
{
    NSString *result;
    
    NSString *HEADER=@"4D";
    NSString *DEVICE_CODE_THERMO_APP_REPLY=@"FE";
    
    
    NSString *length =[NSString stringWithFormat:@"%04x",(data.length / 2) + 1 + 1];
    NSString *checkSumString=[self calcChecksum:HEADER deviceCode:DEVICE_CODE_THERMO_APP_REPLY lengthstr:length cmd:command data:data];
    //4D FE 0008 01 1009080A150A 9E
    
    result =[[NSString stringWithFormat:@"%@%@%@%@%@%@",HEADER,DEVICE_CODE_THERMO_APP_REPLY,length,command,data,checkSumString] uppercaseString];
    
    NSLog(@"checkSumString:%@",checkSumString);
    NSLog(@"result:%@",result);
    
    
    
    return result;
}


////////////////////////////////////////////////////
////////////////////////////////////////////////////
////////////////////////////////////////////////////
////////////////////////////////////////////////////
////////////////////////////////////////////////////




//-------------MyBluetoothLEDelegate---------------------------------------
//連線狀態 IMBluetoothLE 回調

//設備BLE事件
//@param isOpen 藍牙開啟
- (void)onBtStateEnable:(bool)isEnable{
    [self.connectStateDelegate onBtStateChanged:isEnable];
}

- (void)onConnectionState:(ConnectState)state{
    if(state == Connected){
        [self commTimerStart];
//        [self getDeviceInfo];
//        return;
    }else if(state == Disconnect){
        [self commTimerStop];
    }
    [self.connectStateDelegate onConnectionState:state];
}

//接收字串
- (void)onDataResultMessage:(NSString *)message{
//    message = [self calcReceivedMessage:message];
    [Function printLog:[NSString stringWithFormat:@"接收字串 === message = %@",message]];
    
   [self resolution:message];
    
}

- (void)onScanResultUUID:(NSString *)uuid Name:(NSString *)name RSSI:(int)rssi{
    [self.connectStateDelegate onScanResultUUID:uuid Name:name RSSI:rssi];
}



//-------------IMBluetoothLEDelegate---------------------------------------

//-------------模擬數據------------------------------------------------------
- (void)simulationConnect{
    [self.connectStateDelegate onConnectionState:Connected];
}

- (void)simulationScan{
    [self.connectStateDelegate onScanResultUUID:simulationMacArray[simulationPosition]
                                  Name:simulationNameArray[simulationPosition]
                                  RSSI:-50 + simulationPosition];
    simulationPosition++;
    if(simulationPosition >= 10){
        simulationPosition = 0;
        [self cancelTimer];
        [self.connectStateDelegate onConnectionState:ScanFinish];
    }
}


- (void)cancelTimer{
    if(simulationTimer != nil){
        [simulationTimer invalidate];
        simulationTimer = nil;
    }
}
//-------------模擬數據------------------------------------------------------

- (void)resolution:(NSString *)message{
    
    message = message.uppercaseString;
    
    if([message isEqualToString:@""]){
        //for save config&macro
        //分幾個封包送，最後一個封包才會有回應，中間封包不回應
          [Function printLog:[NSString stringWithFormat:@"resolution message is null %@", message]];
        return;
    }
    
    if(allReceivedCommand.length > 0){
        allReceivedCommand = [[NSString alloc] initWithFormat:@"%@%@", allReceivedCommand, message];
    }else{
        allReceivedCommand = [[NSString alloc] initWithFormat:@"%@", message];
    }
    
    message = allReceivedCommand;
    
    bool headerCorrect = [self isCorrectHeader:message];
    bool endCorrect = [self isCorrectEnd:message];
    int lengthCorrect = [self getCorrectLength:message];
    
    
    
    if(headerCorrect && endCorrect && message.length >= lengthCorrect){
        
        receiveErrorCount = 0;
        
        [Function printLog:[NSString stringWithFormat:@"Protocol Class 全部接收完 message -> %@", message]];
        
        while(allReceivedCommand.length != 0){
            
            //重新取一次message
            message = allReceivedCommand;
            //因為如果一次收到2筆Command，每次都要重新取得當筆Command的Length
            lengthCorrect = [self getCorrectLength:message];
            [Function printLog:[NSString stringWithFormat:@"Protocol Class lengthCorrect -> %i", lengthCorrect]];
            
            
            //為了硬體Bug，正式版可以拿掉
//            int testCmd = [self hexStringToInt:[message substringWithRange:NSMakeRange(CMD_CMD_INDEX_START, 2)]];
//            if(testCmd == 0xBC){
//                lengthCorrect += 2;
//            }
            
            
            message = [allReceivedCommand substringToIndex:lengthCorrect];
            [Function printLog:[NSString stringWithFormat:@"Protocol Class message -> %@", message]];
            
            
            @try {
                //----------計算Checksum是否正確----------
                NSString *receiveChecksum = [message substringWithRange:NSMakeRange(lengthCorrect - 2, 2)];
                NSString *cmd = [message substringWithRange:NSMakeRange(8, 2)];//
                NSString *herderStr = [message substringWithRange:NSMakeRange(0, 2)];
                NSString *deviceStr = [message substringWithRange:NSMakeRange(2, 2)];
                NSString *lengthStr = [message substringWithRange:NSMakeRange(4, 4)];
                
                NSString *len = [message substringWithRange:NSMakeRange(2, 4)];
                NSString *data = [message substringWithRange:NSMakeRange(10, lengthCorrect - 12)];
                
                
                
                //NSString * calcChecksum = [[[NSString alloc] initWithFormat:@"%02x", [self computationCheckSum:[NSString stringWithFormat:@"%@%@",cmd, data]]] uppercaseString];
                /*
                message.substring(0, 2),
                message.substring(2, 4),
                message.substring(MyBluetoothLE.CMD_LENGTH_INDEX_START, MyBluetoothLE.CMD_LENGTH_INDEX_END),
                cmd,
                message.substring(10, lengthCorrect - 2)
                */
                
                NSString * calcChecksum =[self calcChecksum:herderStr deviceCode:deviceStr lengthstr:lengthStr cmd:cmd data:data];

                [Function printLog:[NSString stringWithFormat:@"Protocol Class receiveChecksum -> %@", receiveChecksum]];
                [Function printLog:[NSString stringWithFormat:@"Protocol Class calcChecksum -> %@", calcChecksum]];
                //----------計算Checksum是否正確----------
                
                
                //Checksum正確
                if([calcChecksum isEqualToString:receiveChecksum]){
                    
                    //因為是APP主動傳送，所以要比對Write Command
                    //如果有待發送的CMD，則比對是否跟已回傳的CMD相同，如果是，則比對是哪一個CMD，再把它刪除，代表發送成功
                    
                    NSLog(@"getCommArrayCount==>%d",(int)[self getCommArrayCount]);
                    
                    if([self getCommArrayCount] > 0){
                        
                        NSLog(@"[self getFirstComm]==>%@",[self getFirstComm]);
                        
                        //發送出去的CMD, 發送是0xA?, 接收是0xB?, 所以要加0x10
                        int writeCmd = [self hexStringToInt:[[self getFirstComm] substringWithRange:NSMakeRange(THER_CMD_CMD_INDEX_START, 2)]] ;
                        //接收到的CMD
                        int receiveCmd = [self hexStringToInt:[message substringWithRange:NSMakeRange(THER_CMD_CMD_INDEX_START, 2)]];
                        
                        [Function printLog:[NSString stringWithFormat:@"Protocol Class writeCmd -> %02x , receiveCmd -> %02x", writeCmd, receiveCmd]];

                        
                        //比對接收到的CMD跟發送出去的CMD是否相同，如果是，就是收到剛剛發送的CMD的回覆了，刪掉發送陣列裡的CMD
                        if(writeCmd == receiveCmd) {
                            
                            [Function printLog:[NSString stringWithFormat:@"Protocol Class removeComm -> %@", [self getFirstComm]]];
                            
                            [self initSendCount];
                            [self removeComm];
                            
                            allReceivedCommand = [allReceivedCommand substringFromIndex:lengthCorrect];
                            [self handleReceived:message];
                            continue;
                        }
                    }
                    
                    //因為是硬體主動回覆，不用比對Write Command  or
                    //Write Command沒有比對到接收到的Command
                    //清除 allReceivedCommand
                    allReceivedCommand = [allReceivedCommand substringFromIndex:lengthCorrect];
                    [self handleReceived:message];
                    
                }else{
                    //Checksum錯誤
                    [Function printLog:[NSString stringWithFormat:@"Protocol Class === Checksum錯誤 = %@", receiveChecksum]];
                    [self receiveError:message];
                }
                
                
            }
            @catch (NSException *exception) {
                NSLog(@"NSException = %@", [exception debugDescription]);
                [self receiveError:message];
            }
        }
        
        
    }else {
        [Function printLog:[NSString stringWithFormat:@"Protocol Class 還沒接收完 message -> %@", message]];
        
         //預防機制
        ++receiveErrorCount;
        if(receiveErrorCount > RECEIVED_ERROR_COUNT){
            [self receiveError:message];
        }
    }
}

- (void)handleReceived:(NSString* )message{
    [Function printLog:[NSString stringWithFormat:@"Protocol Class handleReceived message -> %@", message]];
    
    bool isSuccess;
    
    //DeviceStatus* ds;
    
    //4D 41 000A A0 0AD10E3E864D3510 77
    
    //取得接收到的CMD
    int cmd = [self hexStringToInt:[message substringWithRange:NSMakeRange(THER_CMD_CMD_INDEX_START, 2)]];
    
    //去除  length & cmd & checksum
    NSString* data = [message substringWithRange:NSMakeRange(10, message.length - 12)];
    
    [Function printLog:[NSString stringWithFormat:@"cmd:%d data:%@", cmd,data]];
    
    switch(cmd){
        
        case 0xA1:
        {
            [Function printLog:[NSString stringWithFormat:@"0xA1"]];
            
            int macLength = 6;//byte
            NSString *macAddress = [data substringToIndex:macLength*2];//   substring(0, macLength*2);
            NSString *strWorkMode = [data substringWithRange:NSMakeRange((macLength*2), 2)];   //data.substring(( macLength*2), ( macLength*2)+2);
            NSString *strBatt =[data substringFromIndex:data.length-2];
            //data.substring(data.length()-2);
            
            
            /*
             * DeviceBatt : Device battery voltage information. Battery voltage is from 2.0v to 3.5v.
             Battery Voltage = (DeviceBatt+100) / 100.
             battery voltage = 3.10V, DeviceBatt = (3.10*100) - 100 = 210 = 0xD2.
             battery voltage = 2.64V, DeviceBatt = (2.64*100) - 100 = 164 = 0xA4
             * */
            int workMode= [self hexStringToInt:strWorkMode]; //Integer.parseInt(strWorkMode, 16);
            
            float batteryVoltage = (float)([self hexStringToInt:strBatt] +100 ) /100.0f;
            
            NSLog(@"strWorkMode:%@",strWorkMode);
            NSLog(@"strBatt:%@",strBatt);
            
            
            [self replyMacAddressOrTime:workMode macAddress:macAddress];
            
            
            [self.dataResponseDelegate onResponseDeviceInfo:macAddress workMode:workMode batteryVoltage:batteryVoltage];
            
            
            
            
        }
            return;
            
            break;
            
        case 0xA0:
        {
            //4D 41 000A A0 0AD10E3E864D3510 77
            
            [Function printLog:[NSString stringWithFormat:@"0xA0"]];
            
            ThermoMeasureData *thermoMeasureData=[[ThermoMeasureData alloc]init];
            
            [thermoMeasureData importDataString:data];
            
            NSLog(@"%@",[thermoMeasureData toString]);
            
            int ack= 81;
            
            [self replyUploadMeasureData:ack];
            
            [self.dataResponseDelegate onResponseUploadMeasureData:thermoMeasureData];
            
            
        }
            
            return;
            
            break;
            
        
            
         default:
            [self receiveError:message];
            return;//break;
    }
    receiveErrorCount = 0;
    
}

- (bool)isCorrectHeader:(NSString *)message{
    bool hasHeader = ![[self getHeader] isEqualToString:@"-1"];
    bool isCorrect = [message hasPrefix:[self getHeader]];
    if(hasHeader){
        if(isCorrect)
            return true;
        else
            return false;
    }else
        return true;
}

- (bool)isCorrectEnd:(NSString *)message{
    bool hasEnd = ![[self getEnd] isEqualToString:@"-1"];
    bool isCorrect = [message hasSuffix:[self getEnd]];
    if(hasEnd){
        if(isCorrect)
            return true;
        else
            return false;
    }else
        return true;
}

- (int)getCorrectLength:(NSString *)message{
    int length = [self hexStringToInt:[message substringWithRange:NSMakeRange(THER_CMD_LENGTH_INDEX_START, 4)]];
    //  & Length &
    int totalLength = (4 + length) * 2;
    
    
    [Function printLog:[NSString stringWithFormat:@"Protocol Class dataResult totalLength -> %i", totalLength]];
    
    return totalLength;
}

- (void)receiveError:(NSString *)message{
    [Function printLog:[NSString stringWithFormat:@"Protocol Class 接收錯誤 message -> %@", message]];
    [Function printLog:[NSString stringWithFormat:@"Protocol Class receiveErrorCount -> %d", receiveErrorCount ]];
    
    ++receiveErrorCount;
    int allLength = allReceivedCommand.length;
    
    //預防一堆錯誤訊息一直累積，RECEIVED_ERROR_COUNT數值待確認，因為可能有很多筆資料會一次傳回來
    if(receiveErrorCount > RECEIVED_ERROR_COUNT){
        receiveErrorCount = 0;
        //接收錯誤超過次數，代表都是錯的，刪除所有CMD
        allReceivedCommand = @"";
    }else{
        //預設是刪到CMD下一個Header的地方
        NSString *headerIndexStr = [[NSString alloc] initWithFormat:@"%@%@", [self getEnd], [self getHeader]];
        unsigned long headerIndex = [message rangeOfString:headerIndexStr].location;
        
        allReceivedCommand = [allReceivedCommand substringToIndex:headerIndex == NSNotFound ? allLength : headerIndex + 2];
    }
    [Function printLog:[NSString stringWithFormat:@"Protocol Class 接收錯誤 allReceivedCommand -> %@", allReceivedCommand]];
    
    
//    
//    [Function printLog:[NSString stringWithFormat:@"Protocol Class 接收錯誤 message -> %@", message]];
//    
//    unsigned long errorIndex = [errorMsg rangeOfString:[self getHeader]].location;
//    [Function printLog:[NSString stringWithFormat:@"Protocol Class 接收錯誤 errorIndex -> %lu", errorIndex]];
//    
//    if(errorIndex == NSNotFound){
//        allReceivedCommand = @"";
//    }else{
//        allReceivedCommand = [allReceivedCommand substringToIndex:errorIndex];
//    }
//    [Function printLog:[NSString stringWithFormat:@"Protocol Class 接收錯誤 allReceivedCommand -> %@", allReceivedCommand]];
    
    //測試時註解
    //		++receiveErrorCount;
    //		CustomVariable.printLog("e", TAG, "dataResult  receiveErrorCount = " + receiveErrorCount);
    //		if(receiveErrorCount > RECEIVED_ERROR_COUNT){
    //			CustomVariable.printLog("e", TAG, "接收錯誤 = " + message + " 斷線!");
    //			receiveErrorCount = 0;
    //			myBluetooth.disconnect(BluetoothLEClass.DISCONNECTED);
    //		}
}

- (int)hexStringToInt:(NSString *)hexString{
    unsigned result = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    
//    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&result];
    return result;
}

- (NSString *) hexStringToAscii:(NSString *)hexString{
    NSMutableString * newString = [[NSMutableString alloc] init];
    int i = 0;
    unsigned long length = [hexString length];
    
    while (i < length){
        NSString * hexChar = [hexString substringWithRange: NSMakeRange(i, 2)];
        int value = 0;
        sscanf([hexChar cStringUsingEncoding:NSASCIIStringEncoding], "%x", &value);
        [newString appendFormat:@"%c", (char)value];
        i+=2;
    }
    return newString;
}

- (NSString *) getIntToHexString:(int)i Digit:(int)digit{
    NSString *hexString = [[NSString alloc] initWithFormat:@"%x", i];
    
    while(hexString.length < digit)
        hexString = [[NSString alloc] initWithFormat:@"0%@", hexString];
    
    return hexString;
}

- (NSString*)convertHexToBinary:(NSString*)hexString {
    
    NSMutableString *returnString = [NSMutableString string];
    for(int i = 0; i < [hexString length]; i++) {
        char c = [[hexString lowercaseString] characterAtIndex:i];
        switch(c) {
            case '0':
                [returnString appendString:@"0000"];
                break;
            case '1':
                [returnString appendString:@"0001"];
                break;
            case '2':
                [returnString appendString:@"0010"];
                break;
            case '3':
                [returnString appendString:@"0011"];
                break;
            case '4':
                [returnString appendString:@"0100"];
                break;
            case '5':
                [returnString appendString:@"0101"];
                break;
            case '6':
                [returnString appendString:@"0110"];
                break;
            case '7':
                [returnString appendString:@"0111"];
                break;
            case '8':
                [returnString appendString:@"1000"];
                break;
            case '9':
                [returnString appendString:@"1001"];
                break;
            case 'a':
                [returnString appendString:@"1010"];
                break;
            case 'b':
                [returnString appendString:@"1011"];
                break;
            case 'c':
                [returnString appendString:@"1100"];
                break;
            case 'd':
                [returnString appendString:@"1101"];
                break;
            case 'e':
                [returnString appendString:@"1110"];
                break;
            case 'f':
                [returnString appendString:@"1111"];
                break;
            default :
                break;
        }
    }
    return returnString;
}

@end
