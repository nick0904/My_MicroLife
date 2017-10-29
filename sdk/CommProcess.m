
#import "CommProcess.h"

@implementation CommProcess{
    //通訊迴圈
    NSTimer *commTimer;
    //指令Array
    NSMutableArray *commArray;
    
    //通訊秒數
    float frequency;
    //標頭檔
    NSString *header;
    //標尾檔
    NSString *end;
    //CheckSum類型
    int checksumType;
    
    int sendCount;
    
}

- (void)initWithInfo:(NSDictionary *)info PrintLog:(BOOL)printLog{
    
    commArray = [[NSMutableArray alloc] init];
    
    //通訊秒數
    frequency = [[info objectForKey:@"frequency"] floatValue];
    //標頭檔
    header = [info objectForKey:@"header"];
    //標尾檔
    end = [info objectForKey:@"end"];
    //checksum類型
    checksumType = [[info objectForKey:@"checksumType"] intValue];
    
    _myBluetooth = [[MyBluetoothLE alloc] getInstanceInfo:info];
}

- (NSString *)getHeader{
    return header;
}
- (NSString *)getEnd{
    return end;
}

-(void) setFrequency: (float)second
{
    frequency = second;
}

//開始通訊迴圈
- (void)commTimerStart{
    [self commTimerStop];
    
    NSLog(@"");
    
    commTimer = [NSTimer scheduledTimerWithTimeInterval:frequency target:self selector:@selector(commTimerLoop) userInfo:nil repeats:YES];
}

- (void)commTimerLoop{
    
    if ( commArray.count > 0){
        
        NSString *message = [self getFirstComm];
        sendCount++;
        
        if(sendCount >= 10){
            [Function printLog:[NSString stringWithFormat:@"commTimerLoop---回覆超時 自動斷線!"]];
            sendCount = 0;
            [_myBluetooth imDisconnect];
            return;
        }
        
        [Function printLog:[NSString stringWithFormat:@"commTimerLoop--- message = %@ , sendCount = %i", message, sendCount]];
         
        
        [_myBluetooth imSendMessage:message];
        
        
        // Device不需回覆
        
        
        
        //eBody
        if([message hasPrefix:@"FD31"] || [message hasPrefix:@"FD53"]) {
       
            sendCount = 0;
            [self initSendCount];
            [self removeComm];

        }
        
        //Thermo
        //A1h  reply: 4DFE000801
        //A0h  reply: 4DFE000281
        if([message hasPrefix:@"4DFE000801"] || [message hasPrefix:@"4DFE000281"]){
            sendCount = 0;
            [self initSendCount];
            [self removeComm];
            
        }
        
        //BPM
        if([message hasPrefix:@"4DFF000204"]  ||
           [message hasPrefix:@"4DFF000800"]  // read history,  when  too much history(我測試時是28筆以上), will timeout  resend
           
           ){
            sendCount = 0;
            [self initSendCount];
            [self removeComm];
        }
        
        
        
        [Function printLog:[NSString stringWithFormat:@"commTimerLoop  ===sendcount=%d", sendCount  ]];

    }
}

- (void)initSendCount{
    sendCount = 0;
}

//結束通訊迴圈
- (void)commTimerStop{
    [commArray removeAllObjects];
    if(commTimer != NULL){
        [commTimer invalidate];
        commTimer = NULL;
    }
}

/**
 *
 * @param comm   cmd+data
 */
- (void)addCommArray:(NSString *)comm RemoveAllComm:(BOOL)removeAllComm{
    NSLog(@"addCommArray---%@ -> %lu , %i", comm, (unsigned long)commArray.count, removeAllComm);
//    if([commArray count] > 10 || removeAllComm)
//        [self removeOtherComm];
    if(removeAllComm)
        [self removeOtherComm];
    
    //NSString *newComm = [self calcChecksum:comm];
    
    
    [commArray addObject:comm];
}

- (NSString *)getFirstComm{
    if (commArray.count > 0)
        return [commArray objectAtIndex:0];
    else
        return nil;
}

- (int)getCommArrayCount{
    return commArray.count;
}

//刪除命令
- (void)removeComm{
    if(commArray.count >= 1)
        [commArray removeObjectAtIndex:0];
}

//刪除所有相同命令
- (void)removeSameComm:(NSString *)cmd{
    for(int i = 0; i < commArray.count; i++) {
        if([[commArray objectAtIndex:i] isEqualToString:cmd]) {
            [commArray removeObjectAtIndex:i];
        }
    }
}

- (void)removeOtherComm{
    if(commArray != NULL && commArray.count > 1){
        NSString *commStr = [commArray objectAtIndex:0];
        [self removeAllComm];
        [commArray addObject:commStr];
    }
}

//刪除所有命令
- (void)removeAllComm{
    [commArray removeAllObjects];
}



/**
 *計算checksum, 後 填入指令，從cmd 到checksum的前一個byte，
 *並返回完整command Hex
 */
 
- (NSString*) calcChecksum:(NSString*)message{
    NSString* cmd = [message substringWithRange:NSMakeRange(0, 2)];
    NSString* data = [message substringFromIndex:2];
    
    NSLog(@"calcChecksum  message:%@", message);
    
    //data+checksum
    NSString* length = [[NSString alloc] initWithFormat:@"%02lx", data.length / 2 + 1];
    
    NSString* result;
    
    //無標尾檔
    if([end isEqualToString:@"-1"]){
        //無標頭檔
        if([header isEqualToString:@"-1"]){
            //無checksum
            if(checksumType == none){
                
            }else{//有checksum
                
                //FPS protocol cmd  format==  cmd:length:data:cs
                if([cmd isEqualToString:@"10"] || [cmd isEqualToString:@"11"])
                {
                    length = @"0";
                    unsigned int checksum = [self computationCheckSum:message];
                    result = [[NSString alloc] initWithFormat:@"%@%@%@%02x", cmd,  @"", data,  checksum];

                    
                }
                else{
                    
                    unsigned int checksum = [self computationCheckSum:message];
                    result = [[NSString alloc] initWithFormat:@"%@%@%@%02x", cmd,  length, data,  checksum];
 
                }
                
//                unsigned int checksum = [self computationCheckSum:message];
//                result = [[NSString alloc] initWithFormat:@"%@%@%@%02x", cmd,  length, data,  checksum];
                
            }
        }else{
            //有標頭檔
            //無checksum
            if(checksumType == none){
                result = [[NSString alloc] initWithFormat:@"%@%@%@", header, length, message];
            }else{
                //有checksum
                unsigned int checksum = [self computationCheckSum:message];
                result = [[NSString alloc] initWithFormat:@"%@%@%@%02x", header, length, message, checksum];
            }
            
        }
    }else{
        //有標尾
        //無標頭檔
        if([header isEqualToString:@"-1"]){
            if(checksumType == none){
                //無checksum
                
            }else{
                
            }
        }else{
            //有標頭檔
            if(checksumType == none){
                //無checksum
                result = [[NSString alloc] initWithFormat:@"%@%@%@%@", header, length, message, end];
            }else{
                //有checksum
                unsigned int checksum = [self computationCheckSum:message];
                result = [[NSString alloc] initWithFormat:@"%@%@%@%02x%@", header, length, message, checksum, end];
            }
        }
    }
    
    
    return result;
}

//驗證received字串
- (NSString *)calcReceivedMessage:(NSString *)message{
    
//    NSArray *splitMsg = [message componentsSeparatedByString:@","];
    
    unsigned long length = message.length;
    
    if ( length > 0 ){
        NSString *comm = @"";
        
        //是否有標頭檔
        BOOL noHeader = [header isEqualToString:@"-1"];
        //是否有標尾檔
        BOOL noEnd = [end isEqualToString:@"-1"];
        
        
        // 1.驗證標頭檔
        if ( !noHeader && ![message hasPrefix:header])
            return @"Header Error";
        
        // 2.驗證標尾檔
        if ( !noEnd && ![message hasSuffix:end])
            return @"End Error";
        
        return comm;
    }
    return @"Command empty";
}

//計算 CheckSum

-(NSString*) calcChecksum:(NSString *)headerStr deviceCode:(NSString*) deviceCode lengthstr:(NSString*) lengthstr cmd:(NSString*) cmd data:(NSString*) data {
    
    [Function printLog:[NSString stringWithFormat:@"calcChecksum cmd =%@",cmd]];
    [Function printLog:[NSString stringWithFormat:@"calcChecksum lengthstr =%@",lengthstr]];
    [Function printLog:[NSString stringWithFormat:@"calcChecksum data =%@",data]];
    
    
    @try {
        
        int checksum = [self hexStringToInt:headerStr];
        
        data =[NSString stringWithFormat:@"%@%@%@%@",deviceCode,lengthstr,cmd,data];
        
        int length = data.length;
        int start = 0;
        int end = 2;
        
        while(end <= length){
            checksum +=[self hexStringToInt:[data substringWithRange:NSMakeRange(start, 2)]];
            start += 2;
            end += 2;
        }
        
        checksum &= 0xFF; //取最後二個16進制字母
        
        //轉為16進制int , 前面補0
        
        NSString * checksumStr = [[[NSString alloc] initWithFormat:@"%02x",checksum] uppercaseString];
        
        if(checksumStr.length == 1)
            checksumStr = [NSString stringWithFormat:@"0%@",checksumStr];
        
        
        [Function printLog:[NSString stringWithFormat:@"checksumStr =%@",checksumStr]];
        
        return [checksumStr uppercaseString];
        
    } @catch (NSException *exception) {
        
        NSLog(@"==>exception:%@",exception.description);
        
        return @"00";
        
        
    }


}


- (unsigned int)computationCheckSum:(NSString *)comm{
      NSLog(@"computationCheckSum comm = %@", comm);
    
    NSString* cmd = [comm substringWithRange:NSMakeRange(0, 2)];
    NSString* data = [comm substringFromIndex:2];
    [Function printLog:[NSString stringWithFormat:@"cmd: %@  data:%@",cmd, data ]];
    
    
    //data+checksum
    NSString* length = [[NSString alloc] initWithFormat:@"%02x", data.length / 2 + 1];
    [Function printLog:[NSString stringWithFormat:@"length: %@", length]];
    
    
    comm = [[NSString alloc] initWithFormat:@"%@%@%@", cmd, length, data];

    
    [Function printLog:[NSString stringWithFormat:@"test2  comm:  %@",comm ]];
    
    
    unsigned int checkSum = 0;
    
    
     [Function printLog:[NSString stringWithFormat:@"test2  checksumType:  %i", checksumType ]];
    
    
    switch (checksumType) {
        case cpAndFF:{
            
            int i = 0;
            while (i < [comm length])
            {
                NSString * hexChar = [comm substringWithRange: NSMakeRange(i, 2)];
                int value = 0;
                sscanf([hexChar cStringUsingEncoding:NSASCIIStringEncoding], "%x", &value);
                checkSum += value;
//                [newString appendFormat:@"%c", (char)value];
                i+=2;
            }
                        
            checkSum &= 0xFF;
            
            NSLog(@"checksum = %02x", checkSum);
        }
            break;
//        case cpCRC16:{
//            NSMutableArray *array = [[NSMutableArray alloc] init];
//            
//            for (int i = 0 ; i < comm.length ; i += 2) {
//                [array addObject:[comm substringWithRange:NSMakeRange(i, 2)]];
//            }
//            
//            unsigned long size = [array count];
//            unsigned char testing[size];
//            
//            unsigned holder;
//            
//            for (int i = 0; i < size; ++i) {
//                [[NSScanner scannerWithString:[array objectAtIndex:i]]
//                 scanHexInt:&holder];
//                testing[i] = holder; /* or check for errors before assigning */
//            }
//            
//            checkSum = FUN_Get_CRC16_Value(testing, size);
//            printf("checkSum1 = %04x\n", checkSum);
//        }
//            break;
//        case cpCRC32:{
//            
//        }
//            break;
    }
    
    return checkSum;
}

unsigned int FUN_Get_CRC16_Value(unsigned char *data0, unsigned char data_length)
{
    unsigned int reg_crc=0xffff;
    unsigned char data_bytes = 0;
    unsigned char j = 0;
    for(data_bytes=0; data_bytes<data_length; data_bytes++)
    {
        reg_crc=(((reg_crc&0x00FF)^*(data0+data_bytes))|(reg_crc&0xFF00));
        //reg_crc^=*(data0+data_bytes);
        for(j=0; j<8; j++)
        {
            if(reg_crc&0x0001)
                reg_crc=(reg_crc>>1) ^ POLY;
            else
                reg_crc>>=1;
        }
    }
    return reg_crc;
}

- (int)hexStringToInt:(NSString *)hexString{
    unsigned result = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    
    //    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&result];
    return result;
}


@end
