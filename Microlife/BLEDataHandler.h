//
//  BLEDataHandler.h
//  Microlife
//
//  Created by Rex on 2016/10/11.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IdeabusSDK_MicroLife.h"
#import "AppDelegate.h"

typedef enum{
    
    ///0:血壓計, 1:額溫計, 2:體脂計
    BPM = 0,
    Temp,
    Weight
    
}scanTag;


@interface BLEDataHandler : NSObject<ConnectStateDelegate,ThermoDataResponseDelegate,BPMDataResponseDelegate,EBodyDataResponseDelegate,APIPostAndResponseDelegate>{
    
    ThermoProtocol *thermoProtocol; //額溫計
    BPMProtocol *bPMProtocol; //血壓計
    EBodyProtocol *eBodyProtocol;//體脂計
    
    BOOL isSetInfo;
    
    BOOL isChecking;
    
    NSString *cur_uuid;
    ConnectState connectState;
    NSTimer *checkThermTimer;
    
    int scanIndex;
    scanTag tag;
    
    BOOL isAfib;
}

-(void)protocolStart;

@end
