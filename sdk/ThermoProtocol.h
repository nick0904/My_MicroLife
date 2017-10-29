/*
 
 額溫計
 
 */

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "MyBluetoothLE.h"
#import "CommProcess.h"

@class CommProcess;
@class ThermoMeasureData;

//DataResponseDelegate
@protocol ThermoDataResponseDelegate

//取得 額溫計 device info
-(void)onResponseDeviceInfo:(NSString*) macAddress workMode:(int)workMode batteryVoltage:(float) batteryVoltage;//A1h


-(void)onResponseUploadMeasureData:(ThermoMeasureData*) data;//A0h

@end


@interface ThermoProtocol : CommProcess <MyBluetoothLEDelegate>{
}


@property (weak) id<ThermoDataResponseDelegate> dataResponseDelegate;


//////////////////////////////////////////////

- (void) replyMacAddressOrTime:(int) workMode macAddress:(NSString*)mac;
  

@end
