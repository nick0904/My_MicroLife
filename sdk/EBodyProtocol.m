
#import "EBodyProtocol.h"
#import "CommandType.h"
#import "HexString.h"
#import "EBodyMeasureData.h"
 
int EBODY_CMD_LENGTH_INDEX_START = 4;
int EBODY_CMD_LENGTH_INDEX_END = 8;

int EBODY_CMD_CMD_INDEX_START = 8;
int EBODY_CMD_CMD_INDEX_END = 10;

float EBODY_FREQUESCY = 0.3;
float EBODY_FREQUESCY_SHORT = 0.2;
float EBODY_FREQUESCY_LONG = 1.0;




@implementation EBodyProtocol{
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
    //int pageTotalNum;
    //int totalPacketNum;
    
    //NSMutableArray* packetArr;
    //int FWReSendCount;
    //int FWErrPacketNO;

    //int lastPacketNo;
    //int lastPageSizeForFW;
    //int lastPacketSizeForFW;
    
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
        [info setValue:@"0000fff3-0000-1000-8000-00805f9b34fb" forKey:@"writeUUID"];
        [info setValue:@"0000fff4-0000-1000-8000-00805f9b34fb" forKey:@"notifyUUID"];
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
//microlift  protocol   cmd

-(void)closeDevice{
    
    if(isSimulation){
        return;
    }
    
    NSLog(@"EBody Protocol closeDevice");
    
    //FD  53
    
    NSString *command = @"FD31";

    NSString *data = @"";
    
    NSString *result = [self buildCommand:command data:data];
    
    [self addCommArray:result RemoveAllComm:false];
    
    //String cmdString = myBluetooth.buildCmdStringForEBody(command,  data);
    //BaseGlobal.printLog("d", TAG, "cmdstring: "+cmdString);
    //myBluetooth.writeMessage(cmdString,	false);
}

/**
 *
 *@param  athlete  運動員類型  0=普通，1=業餘運動員，2=運動員
 *@param  gender  性別  1=man, 0=woman
 *@param  age
 *@param  height  身高
 */

-(void)setupPersonParam:(int)athlete gender:(int)gender age:(int)age height:(int)height{
    
    if(isSimulation){
        return;
    }
    
    NSLog(@"EBody Protocol setupPersonParam");
    
    //FD  53
    
    NSString *command = @"FD53";
    
    int ath = 0b00000100 | athlete;
    ath = ath<<4;
    
    int ga = gender<<7;
    ga = ga | age;
    NSString *data =[NSString stringWithFormat:@"0000%02X%02X%02X",ath,ga,height];
    
    NSString *result = [self buildCommand:command data:data];
    
    [self addCommArray:result RemoveAllComm:false];
    
    
    /*
    @"0000" +
				String.format("%02X", ath) +
				String.format("%02X", ga)  +
				String.format("%02X", height);
    */
    
    //NSString *cmdString = myBluetooth.buildCmdStringForEBody(command,  data);
    //BaseGlobal.printLog("d", TAG, "cmdstring: "+cmdString);
    //myBluetooth.writeMessage(cmdString,	false);
    
}

//==== microlift  cmd end =======================================



-(NSString*)buildCommand:(NSString*)command data:(NSString*)data
{
    NSString *result;
    
    
    result =[[NSString stringWithFormat:@"%@%@",command,data] uppercaseString];
    
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
    
    [Function printLog:[NSString stringWithFormat:@"Protocol Class 全部接收完 message -> %@", message]];
    
    if([message hasPrefix:@"FB53"]){
        //FB53 忽略
          [Function printLog:[NSString stringWithFormat:@"resolution message is FB53 %@", message]];
        return;
    }
    
    
    if(allReceivedCommand.length > 0){
        allReceivedCommand = [[NSString alloc] initWithFormat:@"%@%@", allReceivedCommand, message];
    }else{
        allReceivedCommand = [[NSString alloc] initWithFormat:@"%@", message];
    }
    
    message = allReceivedCommand;
    
    //[Function printLog:[NSString stringWithFormat:@"Protocol Class 全部接收完 message -> %@", message]];
    
    
    bool headerCorrect = YES;//[self isCorrectHeader:message];
    bool endCorrect = YES;//[self isCorrectEnd:message];
    int lengthCorrect = [self getCorrectLength:message];
    
    
    
    if(headerCorrect && endCorrect && message.length >= lengthCorrect){
        
        receiveErrorCount = 0;
        
        
        
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
                /*
                NSString *receiveChecksum = [message substringWithRange:NSMakeRange(lengthCorrect - 2, 2)];
                NSString *cmd = [message substringWithRange:NSMakeRange(8, 2)];//
                NSString *herderStr = [message substringWithRange:NSMakeRange(0, 2)];
                NSString *deviceStr = [message substringWithRange:NSMakeRange(2, 2)];
                NSString *lengthStr = [message substringWithRange:NSMakeRange(4, 4)];
                
                NSString *len = [message substringWithRange:NSMakeRange(2, 4)];
                NSString *data = [message substringWithRange:NSMakeRange(10, lengthCorrect - 12)];
                */
                
                
                //NSString * calcChecksum = [[[NSString alloc] initWithFormat:@"%02x", [self computationCheckSum:[NSString stringWithFormat:@"%@%@",cmd, data]]] uppercaseString];
                /*
                message.substring(0, 2),
                message.substring(2, 4),
                message.substring(MyBluetoothLE.CMD_LENGTH_INDEX_START, MyBluetoothLE.CMD_LENGTH_INDEX_END),
                cmd,
                message.substring(10, lengthCorrect - 2)
                */
                
                /*
                NSString * calcChecksum =[self calcChecksum:herderStr deviceCode:deviceStr lengthstr:lengthStr cmd:cmd data:data];

                [Function printLog:[NSString stringWithFormat:@"Protocol Class receiveChecksum -> %@", receiveChecksum]];
                [Function printLog:[NSString stringWithFormat:@"Protocol Class calcChecksum -> %@", calcChecksum]];
                
                 */
                 //----------計算Checksum是否正確----------
                
                
                //Checksum正確
                
                //if([calcChecksum isEqualToString:receiveChecksum]){
                    
                    //因為是APP主動傳送，所以要比對Write Command
                    //如果有待發送的CMD，則比對是否跟已回傳的CMD相同，如果是，則比對是哪一個CMD，再把它刪除，代表發送成功
                    
                    NSLog(@"getCommArrayCount==>%d",(int)[self getCommArrayCount]);
                    
                    if(!isSimulation && [self getCommArrayCount] > 0){
                        
                        NSLog(@"=>[self getFirstComm]==>%@",[self getFirstComm]);
                        NSLog(@"=>message==>%@",message);
                        
                        //發送出去的CMD, 發送是0xA?, 接收是0xB?, 所以要加0x10
                        int writeCmd = [self hexStringToInt:[[self getFirstComm] substringWithRange:NSMakeRange(EBODY_CMD_CMD_INDEX_START, 2)]] ;
                        //接收到的CMD
                        int receiveCmd = [self hexStringToInt:[message substringWithRange:NSMakeRange(EBODY_CMD_CMD_INDEX_START, 2)]];
                        
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
                    
               // }else{
                    //Checksum錯誤
                //    [Function printLog:[NSString stringWithFormat:@"Protocol Class === Checksum錯誤 = %@", receiveChecksum]];
               //     [self receiveError:message];
               // }
                
                
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
    int cmd = [self hexStringToInt:[message substringWithRange:NSMakeRange(0, 2)]];
    
    //去除  length & cmd & checksum
    NSString* data = [message substringFromIndex:2]; //substringWithRange:NSMakeRange(2, message.length)];
    
    [Function printLog:[NSString stringWithFormat:@"cmd:%d data:%@", cmd,data]];
    
    switch(cmd){
        
        case 0x00://TYPE_00_MEASURING: //testing
        {
            //BaseGlobal.printLog("d", TAG, "TYPE_00_MEASURING");
            //BaseGlobal.printLog("d", TAG, " data = " + data);
            
            HexString *hs = [[HexString alloc]initInputString:data];
            int unitWeightH = [hs parseInt:2];
            int unit = unitWeightH & 0xa0 >> 6;
            
            int weightH = unitWeightH & 0x3F;
            int weightL = [hs parseInt:2];
            int weight = (weightH<<8) | weightL;
            
            [self.dataResponseDelegate onResponseMeasuringData:unit weight:weight];
            
            //BaseGlobal.printLog("d", TAG, "unit = " + unit);
            //BaseGlobal.printLog("d", TAG, "weight = " + weight);
            //onDataResponseListener.onResponseMeasuringData(unit, weight);
        }
            break;
        
        case 0xFC: //TYPE_FC_MEASURE_RESULT:// test result  (no person param)
        {
            //BaseGlobal.printLog("d", TAG, "TYPE_FC_MEASURE_RESULT");
            //BaseGlobal.printLog("d", TAG, " data = " + data);
            
            HexString *hs = [[HexString alloc]initInputString:data];

            int unitWeightH = [hs parseInt:2];
            int unit =(unitWeightH & 0xc0) >> 6;
            //unitWeightH & 0xa0 >> 6;
            
            int weightH = unitWeightH & 0x3F;
            int weightL = [hs parseInt:2];
            int weight = ((weightH<<8) | weightL);
            
            int resistor = [hs parseInt:4];//hs.parseInt(4);
            
            [self.dataResponseDelegate onResponseMeasureResult:unit weight:weight resistor:resistor];
            
            //BaseGlobal.printLog("d", TAG, "unit = " + unit);
            //BaseGlobal.printLog("d", TAG, "weight = " + weight);
            //BaseGlobal.printLog("d", TAG, "resistor = " + resistor);
            //onDataResponseListener.onResponseMeasureResult(unit,weight,resistor);
        }
            
            break;
            
        case 0xFF://TYPE_FF_MEASURE_RESULT2://current measure result
        {
            NSLog(@"TYPE_FF_MEASURE_RESULT2");
            
            //BaseGlobal.printLog("d", TAG, "TYPE_FF_MEASURE_RESULT2");
            //BaseGlobal.printLog("d", TAG, " data = " + data);
            
            EBodyMeasureData *meaData = [[EBodyMeasureData alloc]init];
            [meaData importHexString:data];
            
            [self.dataResponseDelegate onResponseEBodyMeasureData:meaData];
            
            //BaseGlobal.printLog("d", TAG, "meaData = " + meaData);
            //onDataResponseListener.onResponseMeasureResult2(meaData);
            
        }
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
    
    int type =[self hexStringToInt:[message substringWithRange:NSMakeRange(0, 2)]];
    int length = 0;
    
    if(type == 0x00   ){
        length = 3;
    }
    
    if(type == 0xFC) {
        length = 5;
        
    }
    
    if(type == 0xFF){
        length = 20;
    }
    
    // Length
    return (length) * 2;
    
    
    
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
