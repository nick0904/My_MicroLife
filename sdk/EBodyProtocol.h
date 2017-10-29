/*
 
 體脂計
 
 */

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import "MyBluetoothLE.h"
#import "CommProcess.h"

@class EBodyMeasureData;


//DataResponseDelegate
@protocol EBodyDataResponseDelegate

/*
 unit:單位
 weight:重量
 resistor:電阻
 */
-(void)onResponseMeasuringData:(int)unit weight:(int)weight;
-(void)onResponseMeasureResult:(int)unit weight:(int)weight resistor:(int)resistor;
-(void)onResponseEBodyMeasureData:(EBodyMeasureData*)eBodyMeasureData;

@end


@interface EBodyProtocol : CommProcess <MyBluetoothLEDelegate>{
}

@property (weak) id<EBodyDataResponseDelegate> dataResponseDelegate;



//////////////////////////////////////////////

-(void)closeDevice;

/**
 *
 *@param  athlete  運動員類型  0=普通，1=業餘運動員，2=運動員
 *@param  gender  性別  1=man, 0=woman
 *@param  age
 *@param  height  身高
 */

-(void)setupPersonParam:(int)athlete gender:(int)gender age:(int)age height:(int)height;


  

@end
