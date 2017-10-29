
#import "BPMProtocol.h"
#import "CommandType.h"
#import "HexString.h"

#import "CommProcess.h"
#import "MyBluetoothLE.h"
#import "DRecord.h"
#import "CurrentAndMData.h"
#import "DeviceInfo.h"
#import "PulseRecord.h"
#import "User.h"
#import "VersionData.h"
#import "PulseInfo.h"
#import "OscillationData.h"

//BPMProtocol *instance;

int BPM_CMD_LENGTH_INDEX_START = 4;
int BPM_CMD_LENGTH_INDEX_END = 8;

int BPM_CMD_CMD_INDEX_START = 8;
int BPM_CMD_CMD_INDEX_END = 10;

float BPM_FREQUESCY = 0.3;
float BPM_FREQUESCY_SHORT = 0.2;
float BPM_FREQUESCY_LONG = 1.0;


@implementation BPMProtocol{
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
    RECEIVED_ERROR_COUNT = 50;
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

//----------------cmd start -------------------

/**
 * read all history or current data from bpm
 * and sync timing to bpm
 *
 *
 * @param year  將只取二位數  ex: 20xx  ,  will sync  to bpm
 * @param month  will sync  to bpm
 * @param day  will sync  to bpm
 * @param hour  will sync  to bpm
 * @param minute  will sync  to bpm
 * @param second  will sync  to bpm
 */

-(void)readHistorysOrCurrDataAndSyncTiming:(int)year month:(int)month day:(int)day hour:(int)hour minute:(int)minute  second:(int)second{
    
    if(isSimulation){
        return;
    }
        
    NSLog(@"readHistorysOrCurrDataAndSyncTiming==>%d/%d/%d %d:%d:%d<==",year,month,day,hour,minute,second);
    
    
    NSString *command = @"00";
    NSString *data =[NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x",
                     year%100 , month, day, hour, minute, second];
    //String.format("%02x%02x%02x%02x%02x%02x",
    //                            year%100 , month, day, hour, minute, second);
    
    
    NSString *result = [self buildCommand:command data:data];
    
    [self addCommArray:result RemoveAllComm:false];
    
    
    //String cmdString = myBluetooth.buildCmdString(command,  data);
    
    //BaseGlobal.printLog("d", TAG, "cmdstring: "+cmdString);
    
    //myBluetooth.writeMessage(cmdString,	false);
    
}


/**
 * clear all history data of the bpm
 */
-(void)clearAllHistorys{
    
    if(isSimulation){
        return;
    }
    
    NSLog(@"BPMProtocol.clearAllHistorys");
    
    NSString *command = @"03";
    NSString *data = @"";
    
    NSString *result = [self buildCommand:command data:data];
    
    [self addCommArray:result RemoveAllComm:false];

    
    //NSString *cmdString = myBluetooth.buildCmdString(command,  data);
    
    //BaseGlobal.printLog("d", TAG, "cmdstring: "+cmdString);
    
    //myBluetooth.writeMessage(cmdString,	false);
    
}


/**
 * disconnect the bluetooth
 */
-(void)disconnectBPM{
    
    NSLog(@"disconnectBPM");
    
    if(isSimulation){
        return;
    }
    
    NSString *command = @"04";
    NSString *data = @"";
    
    NSString *result = [self buildCommand:command data:data];
    
    [self addCommArray:result RemoveAllComm:false];
    
    
    //String cmdString = myBluetooth.buildCmdString(command,  data);
    
    //BaseGlobal.printLog("d", TAG, "cmdstring: "+cmdString);
    
    //myBluetooth.writeMessage(cmdString,	false);
    
}


/**
 * read user id and version data from bpm
 *
 */
-(void)readUserAndVersionData{
    if(isSimulation){
        return;
    }
    
    NSLog(@"readUserAndVersionData");
    
    NSString *command = @"05";
    NSString *data = @"";
    
    NSString *result = [self buildCommand:command data:data];
    
    [self addCommArray:result RemoveAllComm:false];
    
    //NSString *cmdString = myBluetooth.buildCmdString(command,  data);
    
    //BaseGlobal.printLog("d", TAG, "cmdstring: "+cmdString);
    
    //myBluetooth.writeMessage(cmdString,	false);
}


- (NSString *)convertAsciiStringToHexString:(NSString*) asciiString{
    NSMutableString * newString = [[NSMutableString alloc] init];
    
    const char *utf8String = [asciiString UTF8String];
    
    size_t len = strlen(utf8String) + 1;
    
    char charArray[len];
    memcpy(charArray, utf8String, len);
    
    for(int i=0;i<len;i++)
    {
        NSString *hax=[NSString stringWithFormat:@"%02x",(int)charArray[i]];
        [newString appendString:hax];
    }
    
    return newString;
    
    //for(char c : charArray){
    //    stringBuilder.append(Integer.toHexString((int) c));
    ///}
    //return stringBuilder.toString();
}

/**
 * write a new user id to bpm
 *
 * @param ID  11 en char，   超過長度自動截掉後面部份
 * @param age
 */
-(void)writeUserData:(NSString*)ID Age:(int)age{
    if(isSimulation){
        return;
    }
    
    NSLog(@"BPMProtocol.writeUserData");
    
    NSString *command = @"06";
    
    int USER_ID_LENGTH=11;
    
    NSString *IDTemp;
    
    //User  id   11個字元   不足補 空白字元 0x20
    if(ID.length > USER_ID_LENGTH)
    {
        IDTemp = [ID substringToIndex:USER_ID_LENGTH];// .substring(0, USER_ID_LENGTH);
    }
    
    NSString *idHexStr = [self convertAsciiStringToHexString:ID];
    
    if(ID.length < USER_ID_LENGTH)
    {
        idHexStr = [self appendSpaceCharHexStr:idHexStr NumSpaceChar:USER_ID_LENGTH - ID.length];
    }
    
    
    NSString *data =[NSString stringWithFormat:@"%@%02X",idHexStr,age];
    //idHexStr + String.format("%02x",age);
    
    NSString *result = [self buildCommand:command data:data];
    
    [self addCommArray:result RemoveAllComm:false];
    
    
    //String cmdString = myBluetooth.buildCmdString(command,  data);
    
    //BaseGlobal.printLog("d", TAG, "cmdstring: "+cmdString);
    
    //myBluetooth.writeMessage(cmdString,	false);
}




-(NSString*)appendSpaceCharHexStr:(NSString*)idHexStr NumSpaceChar:(int)numSpaceChar {
    
    NSMutableString * sb = [[NSMutableString alloc] init];
    
    //StringBuilder sb = new StringBuilder(idHexStr);
    for (int i = 0; i < numSpaceChar; i++) {
        [sb appendString:@"20"];//  .append(SPACE_ASSCII);
        
    }
    
    return sb;
}


/**
 *   app ui不用顯示，儲存起來就好。以後要做大數據用。
 *
 *  read pulse information from bpm
 *
 *  Note : this command only use in BPM measure mode.
 */
-(void)readPulseInfo{
    if(isSimulation){
        return;
    }
    
    NSLog(@"readPulseInfo");
    
    //BaseGlobal.printLog("d", TAG, "BPMProtocol.readPulseInfo");
    
    NSString *command = @"07";
    NSString *data = @"";
    
    NSString *result = [self buildCommand:command data:data];
    
    [self addCommArray:result RemoveAllComm:false];
    
    //NSString *cmdString = myBluetooth.buildCmdString(command,  data);
    
    //BaseGlobal.printLog("d", TAG, "cmdstring: "+cmdString);
    
    //myBluetooth.writeMessage(cmdString,	false);
    
}

/**
 *
 * app ui不用顯示，儲存起來就好。以後要做大數據用。
 *
 * read oscillation graph from bpm
 *
 * Note : this command only use in BPM measure mode.
 */
-(void)readOscillationGraph{
    if(isSimulation){
        return;
    }
    
    NSLog(@"readOscillationGraph");
    
    //BaseGlobal.printLog("d", TAG, "BPMProtocol.readOscillationGraph");
    
    NSString *command = @"08";
    NSString *data = @"";
    
    NSString *result = [self buildCommand:command data:data];
    
    [self addCommArray:result RemoveAllComm:false];
    
    //String cmdString = myBluetooth.buildCmdString(command,  data);
    
    //BaseGlobal.printLog("d", TAG, "cmdstring: "+cmdString);
    
    //myBluetooth.writeMessage(cmdString,	false);
}


-(void)readDeviceInfo{
    if(isSimulation){
        return;
    }
    
    NSLog(@"readDeviceInfo");
    
    //BaseGlobal.printLog("d", TAG, "BPMProtocol.readDeviceInfo");
    
    NSString *command = @"0B";
    NSString *data = @"";
    
    NSString *result = [self buildCommand:command data:data];
    
    [self addCommArray:result RemoveAllComm:false];
    
    //String cmdString = myBluetooth.buildCmdString(command,  data);
    
    //BaseGlobal.printLog("d", TAG, "cmdstring: "+cmdString);
    
    //myBluetooth.writeMessage(cmdString,	false);
    
}


//------------ cmd end -------------------

-(NSString*)buildCommand:(NSString*)command data:(NSString*)data
{
    NSString *result;
    
    NSString *HEADER=@"4D";
    NSString *DEVICE_CODE_BPM_APP_REPLY=@"FF";
    
    
    NSString *length =[NSString stringWithFormat:@"%04x",(data.length / 2) + 1 + 1];
    NSString *checkSumString=[self calcChecksum:HEADER deviceCode:DEVICE_CODE_BPM_APP_REPLY lengthstr:length cmd:command data:data];
    //4D FE 0008 01 1009080A150A 9E
    
    result =[[NSString stringWithFormat:@"%@%@%@%@%@%@",HEADER,DEVICE_CODE_BPM_APP_REPLY,length,command,data,checkSumString] uppercaseString];
    
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
                NSString * calcChecksum;
                NSString *receiveChecksum = [message substringWithRange:NSMakeRange(lengthCorrect - 2, 2)];
                NSString *cmd = [message substringWithRange:NSMakeRange(8, 2)];//
                
                NSString *herderStr = [message substringWithRange:NSMakeRange(0, 2)];
                NSString *deviceStr = [message substringWithRange:NSMakeRange(2, 2)];
                NSString *lengthStr = [message substringWithRange:NSMakeRange(4, 4)];
                
                if([cmd isEqualToString:@"91"] || [cmd isEqualToString:@"81"])
                {
                    
                    NSLog(@"cmd==>%@",cmd);
                    
                    
                    
                    
                    calcChecksum =[self calcChecksum:herderStr deviceCode:deviceStr lengthstr:lengthStr cmd:@"00" data:cmd];
                    
                    
                }else
                {
                    NSString *data = [message substringWithRange:NSMakeRange(10, lengthCorrect - 12)];
                    calcChecksum =[self calcChecksum:herderStr deviceCode:deviceStr lengthstr:lengthStr cmd:cmd data:data];
                    
                }
                

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
                        int writeCmd = [self hexStringToInt:[[self getFirstComm] substringWithRange:NSMakeRange(BPM_CMD_CMD_INDEX_START, 2)]] ;
                        //接收到的CMD
                        int receiveCmd = [self hexStringToInt:[message substringWithRange:NSMakeRange(BPM_CMD_CMD_INDEX_START, 2)]];
                        
                        [Function printLog:[NSString stringWithFormat:@"Protocol Class writeCmd -> %02x , receiveCmd -> %02x", writeCmd, receiveCmd]];

                        
                        //接收到的CMD : 03h, 06h, 0Ah, -->  81h, 91h
                        if(receiveCmd == 0x91)//device  處理中
                        {
                            
                            
                           allReceivedCommand=[allReceivedCommand substringFromIndex:lengthCorrect];// delete(0, lengthCorrect);
                            continue;
                        }
                        else if(receiveCmd == 0x81)//device 處理完成
                        {
                            if(writeCmd == 0x03  || writeCmd == 0x06  || writeCmd == 0x0A ){
                                //BaseGlobal.printLog("d", TAG, "dataResult  removeComm = " + myBluetooth.getComm(0));
                                
                                //myBluetooth.sendCount = 0;
                                //myBluetooth.removeComm(0);
                                //allReceivedCommand.delete(0, lengthCorrect);
                                
                                [self initSendCount];
                                [self removeComm];
                                
                                
                                allReceivedCommand=[allReceivedCommand substringFromIndex:lengthCorrect];
                                
                                NSMutableString *tempMessage = [NSMutableString stringWithString:message];
                                [tempMessage insertString:[NSString stringWithFormat:@"%02X",writeCmd] atIndex:4*2];
                                
                                NSLog(@"tempMessage:%@",tempMessage);
                                
                                [self handleReceived:tempMessage];
                                
                                
                                //StringBuilder sb = new StringBuilder(message);
                                //BaseGlobal.printLog("d", TAG, "message = " + message);
                                
                                //sb.insert(4*2, String.format("%02X", writeCmd));
                                //解析資料
                                //handleReceived(sb.toString());
                                
                                
                                continue;
                                
                            }
                        }
                        else
                        {
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
    //BPM
    bool isSuccess;
    
    //DeviceStatus* ds;
    
    //4D 41 000A A0 0AD10E3E864D3510 77
    
    //取得接收到的CMD
    int cmd = [self hexStringToInt:[message substringWithRange:NSMakeRange(BPM_CMD_CMD_INDEX_START, 2)]];
    
    //去除  length & cmd & checksum
    NSString* data = [message substringWithRange:NSMakeRange(10, message.length - 12)];
    
    [Function printLog:[NSString stringWithFormat:@"cmd:%d data:%@", cmd,data]];
    
    switch(cmd){
        
        case 0x00:
        {
            NSLog(@"Read History.");
            
            DRecord *drecord = [[DRecord alloc]init];
            [self importHexStringToHistory:data DRecord:drecord];
            
            [self.dataResponseDelegate onResponseReadHistory:drecord];
            
            
        }
            break;
            
        case 0x03: //CLEAR_HISTORY:
        {
            if(data && [data isEqualToString:@"81"])
            {
                isSuccess=YES;
            }else{
                isSuccess=NO;
            }
            
            [self.dataResponseDelegate onResponseClearHistory:isSuccess];
        }
            break;
        
        case 0x04://DISCONNECT_BLE:
        {
            //不用回應
            
            return;
        }
            break;
            
            
        case 0x05://READ_USER_ID_AND_VERSION_DATA:
        {
            //BaseGlobal.printLog("d", TAG, "READ_USER_ID_AND_VERSION_DATA");
            //BaseGlobal.printLog("d", TAG, " data = " + data);
            
            int USER_ID_LENGTH=11;
//            data = @"4D31000D05034D31000D05034643350F0A060363062D09";
            NSString *userStr = [data substringToIndex:(USER_ID_LENGTH +2)*2];//  substring(0, (USER_ID_LENGTH +2)*2 );
            
            NSString *verStr = [data substringFromIndex:(USER_ID_LENGTH +2)*2];//  substring(0, (USER_ID_LENGTH +2)*2 );
            
            
            NSLog(@"userStr=>%@<==",userStr);
            NSLog(@"verStr=>%@<==",verStr);
            
            
            User *user = [[User alloc]init];
            
            //NO
            NSString *noStr=[userStr substringToIndex:2];
            [user setNO:[Function hexStringToInt:noStr]];
            
            //ID
            NSString *idStr=[userStr substringWithRange:NSMakeRange(2, (USER_ID_LENGTH+1)*2)];
            idStr=[self hexStringToAscii:idStr];
            [user setID:idStr];
            
            //Age
            NSString *ageStr=[userStr substringFromIndex:(1+USER_ID_LENGTH)*2];
            [user setAge:[Function hexStringToInt:ageStr]];
            
            //Ver
            VersionData *verData=[[VersionData alloc]init];
            
            [self importHexStringToVersionData:verStr VersionData:verData];
                        
            [self.dataResponseDelegate onResponseReadUserAndVersionData:user VersionData:verData];
            
            
            //user setNO(Integer.parseInt(userStr.substring(0,2), 16));
            //user.setID(convertHexStringToAsciiString(userStr.substring(2,( USER_ID_LENGTH+1)*2 )));
            //user.setAge(Integer.parseInt(userStr.substring((1+USER_ID_LENGTH)*2 ), 16));
            
            //String verStr = data.substring((USER_ID_LENGTH +2)*2 );
            /*
            VersionData verData = new VersionData();
            HexStrUtil.importHexStringToVersionData(verStr, verData);
            BaseGlobal.printLog("d", TAG, verData.toString());
            
            onDataResponseListener.onResponseReadUserAndVersionData(user, verData);
            */
             
             return;
        }
            break;
            
        case 0x06://WRITE_USER_ID:
        {
            //BaseGlobal.printLog("d", TAG, "WRITE_USER_ID");
            //BaseGlobal.printLog("d", TAG, " data = " + data);
            
            NSString *CMD_REPLY_RESULT_SUCCESS=@"81";
            
            if(data && [data isEqualToString:CMD_REPLY_RESULT_SUCCESS])
            {
                isSuccess=YES;
            }else{
                isSuccess=NO;
            }
            
            [self.dataResponseDelegate onResponseWriteUser:isSuccess];
            
            //onDataResponseListener.onResponseWriteUser(isSuccess);
            
            return;

        }
        
            break;
            
        case 0x07://READ_PULSE_INFO:
        {
            //BaseGlobal.printLog("d", TAG, "READ_PULSE_INFO");
            //BaseGlobal.printLog("d", TAG, " data = " + data);
            
            if(data && [data isEqualToString:@"00"]){
                
                [self.dataResponseDelegate onResponseReadPulseInfo:nil];
                
                return;
            }
            
            PulseInfo *pInfo = [[PulseInfo alloc]init];
            
            [self importHexStringToPulseInfo:data PulseInfo:pInfo];
            
            [self.dataResponseDelegate onResponseReadPulseInfo:pInfo];
            
            
            return;
        }
            break;
            
        case 0x08://READ_OSCILLATION_GRAPH:
        {
            //BaseGlobal.printLog("d", TAG, "READ_OSCILLATION_GRAPH");
            //BaseGlobal.printLog("d", TAG, " data = " + data);
            
            if(data && [data isEqualToString:@"00"]){
                [self.dataResponseDelegate onResponseReadOscillationGraph:nil];
                
                return;
            }
            
            OscillationData *oscidata = [[OscillationData alloc]init];
            
            [self importHexStringToOsci:data OscillationData:oscidata];
            
            [self.dataResponseDelegate onResponseReadOscillationGraph:oscidata];
            
            //onDataResponseListener.onResponseReadOscillationGraph(oscidata);
            
            
            return;
        }
            break;
            
            //			作廢  工廠出廠用
            //			case WRITE_DEVICE_ID:
            //				BaseGlobal.printLog("d", TAG, "WRITE_DEVICE_ID");
            //				BaseGlobal.printLog("d", TAG, " data = " + data);
            //
            //				isSuccess = data.equals(CMD_REPLY_RESULT_SUCCESS);
            //
            //				onDataResponseListener.onResponseWriteDeviceIDAndEraseDeviceInfo(isSuccess);
            //
            //
            //				return;
            
            
        case 0x0B://READ_DEVICE_INFO:
        {
            //BaseGlobal.printLog("d", TAG, "READ_DEVICE_INFO");
            //BaseGlobal.printLog("d", TAG, " data = " + data);
            
            DeviceInfo *deviceInfo = [[DeviceInfo alloc]init];
            
            [self importHexStringToDeviceInfo:data DeviceInfo:deviceInfo];
            
            [self.dataResponseDelegate onResponseReadDeviceInfo:deviceInfo];
            
            
            //HexStrUtil.importHexStringToDeviceInfo(data, deviceInfo);
            //onDataResponseListener.onResponseReadDeviceInfo(deviceInfo);
            
            return;
        }
            break;
        
         default:
            [self receiveError:message];
            return;//break;
    }
    receiveErrorCount = 0;
    
}


-(void)importHexStringToHistory:(NSString*)data DRecord:(DRecord*) drecord {
    HexString *hexString=[[HexString alloc]initInputString:data];
    
    NSString *DataIndex =[hexString cutStr:14];
    
    //  DataIndex
    HexString *hsDataIndex = [[HexString alloc]initInputString:DataIndex];
    int mode = [hsDataIndex parseInt:2];
    int NoOfCurrentMeasurement = [hsDataIndex parseInt:2];
    int HistoryMeasuremeNumber = [hsDataIndex parseInt:2];
    int userNumber = [hsDataIndex parseInt:2];
    int MAMState = [hsDataIndex parseInt:2];
    
    
    [drecord setMode:mode];
    [drecord setNoOfCurrentMeasurement:NoOfCurrentMeasurement];
    
    [drecord setHistoryMeasuremeNumber:HistoryMeasuremeNumber];
    
    [drecord setUserNumber:userNumber];
    [drecord setMAMState:MAMState];
    
    
    //current data
    [self importHexStringToCurrentData:hexString DRecord:drecord];
    
    if(!drecord.isMeasureMode){//sleep mode
        [self importHexStringToMData:hexString DRecord:drecord];
    }
    
}


/**
 * <pre>
 * measure mode 只會傳送 DataIndex, CurrentData1, CurrentData2, CurrentData3, 而且不會送Mdata
 *
 sleep mode 會送 DataIndex, CurrentData1, CurrentData2, CurrentData3, MData.....N,
 但是CurrentData1, CurrentData2, CurrentData3 會被設為 0x00, 所以是 3*7=21 個 0x00
 所以收到 CurrentData 非0 就是 measure mode
 </pre>
 * @param hs
 * @param drecord
 */
-(void)importHexStringToCurrentData:(HexString*) hs DRecord:(DRecord*) drecord {
    
    NSMutableArray *cdataArr=[[NSMutableArray alloc]initWithCapacity:3];
    
    
    //CurrentAndMData[] cdataArr = new CurrentAndMData[3];
    
    BOOL measureMode = false;
    int len = DR_CURRENT_DATA_LENGTH;
    
    NSString *cDataStr = [hs cutStr:len];
    
    if(![cDataStr isEqualToString:DR_ZERO_CURRENT_DATA]){
        CurrentAndMData *cData = [[CurrentAndMData alloc]init];
        [cData importHexString:cDataStr];
        
        [cdataArr addObject:cData];
        
        measureMode = true;
    }
    
    cDataStr = [hs cutStr:len];
    if(![cDataStr isEqualToString:DR_ZERO_CURRENT_DATA]){
        CurrentAndMData *cData = [[CurrentAndMData alloc]init];
        [cData importHexString:cDataStr];
        
        [cdataArr addObject:cData];
        
        measureMode = true;
        
    }
    
    cDataStr = [hs cutStr:len];
    if(![cDataStr isEqualToString:DR_ZERO_CURRENT_DATA]){
        CurrentAndMData *cData = [[CurrentAndMData alloc]init];
        [cData importHexString:cDataStr];

        [cdataArr addObject:cData];
        
        measureMode = true;
    }
    
    [drecord setCurrentData:cdataArr];
    [drecord setMeasureMode:measureMode];
    
}


-(void)importHexStringToMData:(HexString*)hs DRecord:(DRecord*)drecord {
    
    NSMutableArray *mdataArr=[[NSMutableArray alloc]init];
    
    int len = DR_CURRENT_DATA_LENGTH;
    
    while (hs.length >= len){
        NSString *mdataStr = [hs cutStr:len];
        
        if(![mdataStr isEqualToString:DR_ZERO_CURRENT_DATA]){
            CurrentAndMData *cData = [[CurrentAndMData alloc]init];
            [cData importHexString:mdataStr];
            
            [mdataArr addObject:cData];

        }
        
    }
    
    [drecord setMData:mdataArr];
    
}


-(void)importHexStringToDeviceInfo:(NSString*)data DeviceInfo:(DeviceInfo*)deviceInfo{
    HexString *hs = [[HexString alloc]initInputString:data];
    
    int index1 = [hs parseInt:2];//device ID string, D(44h)
    
    int DeviceID_length= 6;
    NSString *DeviceIDHexStr = [hs cutStr:DeviceID_length*2];
    NSString *DeviceID = (DeviceIDHexStr);
    
    [deviceInfo setID:DeviceID];
    
    int index2 = [hs parseInt:2];// all of measurement times for BPM, M(4Dh)
    
    int measurementTimes = [hs parseInt:6];
    [deviceInfo setMeasurementTimes:measurementTimes];
    
    int errIndex = [hs parseInt:2];//error 1 happened times, 01h
    
    [deviceInfo setErrHappendTimes:errIndex ErrTimes:[hs parseInt:4]];
    
    errIndex = [hs parseInt:2];// error 2 happened times, 02h
    [deviceInfo setErrHappendTimes:errIndex ErrTimes:[hs parseInt:4]];
    
    errIndex = [hs parseInt:2];// error 3 happened times, 03h
    [deviceInfo setErrHappendTimes:errIndex ErrTimes:[hs parseInt:4]];
    
    errIndex = [hs parseInt:2];// error 5 happened times, 05h
    [deviceInfo setErrHappendTimes:errIndex ErrTimes:[hs parseInt:4]];
    
    // v1.0.10  del  error6
    //        errIndex = hs.parseInt(2);// error 6 happened times, 06h
    //        deviceInfo.setErrHappendTimes(errIndex ,  hs.parseInt(4));
    
}


/**
 *   import verStr  to verData
 *
 * @param verStr
 * @param verData
 */
-(void)importHexStringToVersionData:(NSString*)verStr VersionData:(VersionData*)verData{
    
    NSLog(@"HexStrUtil.importHexStringToVersionData");
    
    //get FW Name.   3 char
    int FWName_length = 3;
    HexString *hs =[[HexString alloc]initInputString:verStr];
    
    NSString *FWNameHexStr = [hs cutStr:(FWName_length *2)];
    NSString *FWName = [self hexStringToAscii:FWNameHexStr];//  convertHexStringToAsciiString(FWNameHexStr);
    
    //        String FWNameHexStr = verStr.substring(0, FWName_length *2);
    //        String FWName = convertHexStringToAsciiString(FWNameHexStr);
    
    [verData setFWName:FWName];
    
    //        verStr = verStr.substring(FWName_length *2);
    //        HexString hs = new HexString(verStr);
    
    [verData setYear:2000+ [hs parseInt:2]];
    [verData setMonth:[hs parseInt:2]];
    [verData setDay:[hs parseInt:2]];
    [verData setMaxUser:[hs parseInt:2]];
    [verData setMaxMemory:[hs parseInt:2]];
    
    int option = [hs parseInt:2];
    
    NSString *optionByteStr=[Function toBinarySystemWithDecimalSystem:option length:8];
    
    NSLog(@"optionByteStr=>%@<=",optionByteStr);
    
    //const char* optionArr=[optionByteStr UTF8String];
    
    //NSLog(@"optionByteStr=>%c<=",optionArr[7]);
    
    [verData setOptionIHB:[optionByteStr substringWithRange:NSMakeRange(7, 1)].intValue];
    [verData setOptionAfib:[optionByteStr substringWithRange:NSMakeRange(6, 1)].intValue];
    [verData setOPtionMAM:[optionByteStr substringWithRange:NSMakeRange(5, 1)].intValue];
    [verData setOptionAmbientT:[optionByteStr substringWithRange:NSMakeRange(4, 1)].intValue];
    [verData setOptionTubeless:[optionByteStr substringWithRange:NSMakeRange(1, 1)].intValue];
    [verData setOptionDeviceID:[optionByteStr substringWithRange:NSMakeRange(0, 1)].intValue];
    
    double vol = 0.0;
    if (hs.length > 0) {
        vol = ((double)[hs parseInt:2])/10.0f;
    }
    [verData setDeviceBatteryVoltage:vol];

    
    
    /*
    ByteBuffer bb = ByteBuffer.allocate(4).order(ByteOrder.LITTLE_ENDIAN).putInt(option);
    BaseGlobal.printLog("d", TAG, "bb.order:"+bb.order());
    
    byte[] bytes = bb.array();
    BitSet bits = BitSet.valueOf(bytes);
    BaseGlobal.printLog("d", TAG, "option:"+option);
    BaseGlobal.printLog("d", TAG, "byte[0]:"+ bytes[0]);
    BaseGlobal.printLog("d", TAG, "byte[0]:"+ bytes[1]);
    BaseGlobal.printLog("d", TAG, "byte[0]:"+ bytes[2]);
    BaseGlobal.printLog("d", TAG, "byte[0]:"+ bytes[3]);
    BaseGlobal.printLog("d", TAG, "bits:"+ bits);
    
    
    verData.setOptionIHB(bits.get(0));
    verData.setOptionAfib(bits.get(1));
    verData.setOPtionMAM(bits.get(2));
    verData.setOptionAmbientT(bits.get(3));
    verData.setOptionTubeless(bits.get(6));
    verData.setOptionDeviceID(bits.get(7));
    
    
    double vol = ((double)hs.parseInt(2))/10f;
    verData.setDeviceBatteryVoltage(vol );
    
    BaseGlobal.printLog("d", TAG, ""+ verData.getDeviceBatteryVoltage());
     */
}


-(void)importHexStringToPulseInfo:(NSString*)data PulseInfo:(PulseInfo*)pInfo{
    
    HexString *hs = [[HexString alloc]initInputString:data];
    
    int index = [hs parseInt:2];

    NSString *indexByteStr=[Function toBinarySystemWithDecimalSystem:index length:8];
    
    const char* indexArr=[indexByteStr UTF8String];
    
    [pInfo setIndexAll:[indexByteStr substringWithRange:NSMakeRange(0, 1)].intValue];//   indexArr[0]];
    [pInfo setIndexPAD:[indexByteStr substringWithRange:NSMakeRange(5, 1)].intValue];//indexArr[5]];
    [pInfo setIndexAfib:[indexByteStr substringWithRange:NSMakeRange(6, 1)].intValue];//indexArr[6]];
    [pInfo setIndexIHB:[indexByteStr substringWithRange:NSMakeRange(7, 1)].intValue];//indexArr[7]];
    
    /*
    byte[] bytes = ByteBuffer.allocate(4).putInt(index).array();
    BitSet bits = BitSet.valueOf(bytes);
    
    pInfo.setIndexAll(bits.get(7));
    pInfo.setIndexPAD(bits.get(2));
    pInfo.setIndexAfib(bits.get(1));
    pInfo.setIndexIHB(bits.get(0));
    */
    
    int count = 0;
    
    count = (indexArr[0]) ? count++ :count;
    count = (indexArr[5]) ? count++ :count;
    count = (indexArr[6]) ? count++ :count;
    count = (indexArr[7]) ? count++ :count;
    
    /*
    count = (bits.get(7)) ? count++ :count;
    count = (bits.get(2)) ? count++ :count;
    count = (bits.get(1)) ? count++ :count;
    count = (bits.get(0)) ? count++ :count;
    */
    
    [pInfo setPulseRecordCount:count];
    [pInfo setReferOfPulseRate:[hs parseInt:4]];
    
    //PulseRecord
    for (int i = 0; i < count; i++) {
        [self importHexStringToPulseRecord:hs PulseInfo:pInfo];
    }
    
    
}

-(void)importHexStringToPulseRecord:(HexString*)hs PulseInfo:(PulseInfo*)pInfo{
    
    int header = [hs parseInt:2];
    int num = [hs parseInt:4];
    
    //raw data of pulse rate
    
    //int[] rawDataOfPulseRate = new int[num-1];
    
    NSMutableArray *rawDataOfPulseRate=[[NSMutableArray alloc]init];
    
    for (int i = 0; i < (num-1); i++) {
        [rawDataOfPulseRate addObject:[NSNumber numberWithInt:[hs parseInt:2]]];
    }
    
    int endbyte = [hs parseInt:2];
    
    PulseRecord *pRec = [[PulseRecord alloc]init];
    [pRec setHeader:header];
    [pRec setRawDataOfPulseRate:rawDataOfPulseRate];
    
    [pInfo addPulseRecordByHeader:pRec];
    
}

-(void)importHexStringToOsci:(NSString*)data OscillationData:(OscillationData*)oscidata{
    
    HexString *hs = [[HexString alloc]initInputString:data];
    
    int cntPress = [hs parseInt:2];
    
    //int[] pressureData = new int[cntPress];
    
    NSMutableArray *pressureData=[[NSMutableArray alloc]init];
    
    for (int i = 0; i < cntPress; i++) {
        [pressureData addObject:[NSNumber numberWithInt:[hs parseInt:4]]];
    }
    
    int cntAmpl = [hs parseInt:2];
    
    
    NSMutableArray *amplitudeData=[[NSMutableArray alloc]init];
    
    //int[] amplitudeData = new int[cntAmpl];
    
    for (int i = 0; i < cntAmpl; i++) {
        [amplitudeData addObject:[NSNumber numberWithInt:[hs parseInt:4]]];
        //amplitudeData[i] = hs.parseInt(4);
    }
    
    [oscidata setPressureData:pressureData];
    [oscidata setAmplitudeData:amplitudeData];
    
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
    int length = [self hexStringToInt:[message substringWithRange:NSMakeRange(BPM_CMD_LENGTH_INDEX_START, 4)]];
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
