//
//  DRecord.m
//  MicroLifeDeviceSDK
//
//  Created by Tom on 2016/9/12.
//  Copyright © 2016年 Tom. All rights reserved.
//

#import "DRecord.h"
#import "CurrentAndMData.h"

@implementation DRecord

-(void)setMode:(int) vmode{
    mode = vmode;
}

-(int)getMode{
    return mode;
}

/**
 * There are 1 or 3 measurements for 1 measure cycles. Record average data in “MData” field
 and single data in “CurrentData” field.
 
 * @param noOfCurrentMeasurement
 */
-(void)setNoOfCurrentMeasurement:(int) vnoOfCurrentMeasurement {
    noOfCurrentMeasurement = vnoOfCurrentMeasurement;
}

/**
 * There are 1 or 3 measurements for 1 measure cycles. Record average data in “MData” field
 and single data in “CurrentData” field.
 
 * @return
 */
-(int)getNoOfCurrentMeasurement {
    return noOfCurrentMeasurement;
}

-(void)setHistoryMeasuremeNumber:(int)vhistoryMeasuremeNumber {
    historyMeasuremeNumber = vhistoryMeasuremeNumber;
}

-(int)getHistoryMeasuremeNumber {
    return historyMeasuremeNumber;
}

-(void)setUserNumber:(int)vuserNumber {
    userNumber = vuserNumber;
}

-(int)getUserNumber {
    return userNumber;
}

-(void)setMAMState:(int)vMAMState {
    MAMState = vMAMState;
}

-(int)getMAMState {
    return MAMState;
}

-(void)setCurrentData:(NSMutableArray*) vcurrentData {
    currentData = vcurrentData;
}

-(NSMutableArray*) getCurrentData {
    return currentData;
}

-(void)setMData:(NSMutableArray*) vMData {
    MData = vMData;
}

-(NSMutableArray*) getMData {
    return MData;
}

/**
 *   <pre>
 *  measure mode 只會傳送 DataIndex, CurrentData1, CurrentData2, CurrentData3, 而且不會送Mdata
 *
 sleep mode 會送 DataIndex, CurrentData1, CurrentData2, CurrentData3, MData.....N,
 但是CurrentData1, CurrentData2, CurrentData3 會被設為 0x00, 所以是 3*7=21 個 0x00
 所以收到 CurrentData 非0 就是 measure mode
 </pre>
 *
 *
 * @param measureMode
 */

-(void)setMeasureMode:(BOOL) vmeasureMode {
    measureMode = vmeasureMode;
}

/**
 *
 *    <pre>
 *  measure mode 只會傳送 DataIndex, CurrentData1, CurrentData2, CurrentData3, 而且不會送Mdata
 *
 sleep mode 會送 DataIndex, CurrentData1, CurrentData2, CurrentData3, MData.....N,
 但是CurrentData1, CurrentData2, CurrentData3 會被設為 0x00, 所以是 3*7=21 個 0x00
 所以收到 CurrentData 非0 就是 measure mode
 </pre>
 
 *
 * @return
 */


-(BOOL)isMeasureMode {
    return measureMode;
}


-(NSString*) toString {

    NSLog(@"currentData");
    
    for(CurrentAndMData *curMdata in currentData)
    {
        NSLog(@"%@",[curMdata toString]);
    }
    
    NSLog(@"MData");
    
    for(CurrentAndMData *curMdata in MData)
    {
        NSLog(@"%@",[curMdata toString]);
    }
        
    
    return [NSString stringWithFormat:
            @"mode=%d\nnoOfCurrentMeasurement=%d\nhistoryMeasuremeNumber=%d\nuserNumber=%d\nMAMState=%d\ncurrentData=%@\nMData=%@\nmeasureMode=%d",mode,noOfCurrentMeasurement,historyMeasuremeNumber,userNumber,MAMState,currentData,MData,measureMode];
    
    

}


@end
