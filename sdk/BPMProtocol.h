/*
 
 血壓計
 
 */

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import "MyBluetoothLE.h"
#import "CommProcess.h"

@class CommProcess;
@class DRecord;
@class CurrentAndMData;
@class DeviceInfo;
@class PulseRecord;
@class User;
@class VersionData;
@class PulseInfo;
@class OscillationData;

//DataResponseDelegate
@protocol BPMDataResponseDelegate


-(void)onResponseReadHistory:(DRecord*) data;
-(void)onResponseClearHistory:(BOOL)isSuccess;
-(void)onResponseWriteUser:(BOOL)isSuccess;

//取得 血壓計 device info
-(void)onResponseReadDeviceInfo:(DeviceInfo*)deviceInfo;

-(void)onResponseReadUserAndVersionData:(User*)user VersionData:(VersionData*)verData;
-(void)onResponseReadPulseInfo:(PulseInfo*)pulseInfo;
-(void)onResponseReadOscillationGraph:(OscillationData*)oscillationData;

@end


@interface BPMProtocol : CommProcess <MyBluetoothLEDelegate>{
    
}


@property (weak) id<BPMDataResponseDelegate> dataResponseDelegate;

//////////////////////////////////////////////

-(void)readHistorysOrCurrDataAndSyncTiming:(int)year month:(int)month day:(int)day hour:(int)hour minute:(int)minute  second:(int)second;

-(void)clearAllHistorys;

-(void)disconnectBPM;

-(void)readUserAndVersionData;

-(void)writeUserData:(NSString*)ID Age:(int)age;

-(void)readPulseInfo;

-(void)readOscillationGraph;

-(void)readDeviceInfo;


@end
