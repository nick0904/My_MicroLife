//
//  DRecord.h
//  MicroLifeDeviceSDK
//
//  Created by Tom on 2016/9/12.
//  Copyright © 2016年 Tom. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *DR_ZERO_CURRENT_DATA = @"00000000000000";//14個0，7個byte
static int DR_CURRENT_DATA_LENGTH = 14;//7個byte , 14個 hex char

@interface DRecord : NSObject
{
    //The value of this flag is fixed to 0x00
    int mode;
    
    //There are 1 or 3 measurements for 1 measure cycles. Record average data in “MData” field and single data in “CurrentData” field.
    int noOfCurrentMeasurement;
    int historyMeasuremeNumber;
    
    //User1 = 1, User2 = 2, Guest = 3
    int userNumber;
    int MAMState;
    
    NSMutableArray *MData;
    NSMutableArray *currentData;
    //List<CurrentAndMData> MData = new ArrayList<CurrentAndMData>();
    
    
    BOOL measureMode;
}


-(void)setMode:(int) vmode;

-(int)getMode;

/**
 * There are 1 or 3 measurements for 1 measure cycles. Record average data in “MData” field
 and single data in “CurrentData” field.
 
 * @param noOfCurrentMeasurement
 */
-(void)setNoOfCurrentMeasurement:(int) vnoOfCurrentMeasurement;

/**
 * There are 1 or 3 measurements for 1 measure cycles. Record average data in “MData” field
 and single data in “CurrentData” field.
 
 * @return
 */
-(int)getNoOfCurrentMeasurement;

-(void)setHistoryMeasuremeNumber:(int)vhistoryMeasuremeNumber;

-(int)getHistoryMeasuremeNumber;

-(void)setUserNumber:(int)vuserNumber;

-(int)getUserNumber;

-(void)setMAMState:(int)vMAMState;

-(int)getMAMState;

-(void)setCurrentData:(NSMutableArray*) vcurrentData;

-(NSMutableArray*) getCurrentData;

-(void)setMData:(NSMutableArray*) vMData;

-(NSMutableArray*) getMData;

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

-(void)setMeasureMode:(BOOL) vmeasureMode;

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


-(BOOL)isMeasureMode;

-(NSString*) toString;


@end
