
#import "Function.h"
#import "MyBluetoothLE.h"

enum CheckSum{ none, cpAndFF, cpCRC16, cpCRC32};
#define POLY 0xa001


@protocol ConnectStateDelegate

/**
 * 開啟設備BLE事件
 * @param isEnable 藍牙是否開啟
 */
- (void) onBtStateChanged:(bool) isEnable;

/**
 * 返回掃描到的藍牙
 * @param uuid mac address
 * @param name 名稱
 * @param rssi 訊號強度
 */
- (void) onScanResultUUID:(NSString*) uuid Name:(NSString*) name RSSI:(int) rssi;

/**
 * 連線狀態
 * ScanFinish,			//掃描結束
 * Connected,			//連線成功
 * Disconnected,		//斷線
 * ConnectTimeout,		//連線超時
 */
- (void) onConnectionState:(ConnectState) state;

@end

@interface CommProcess : NSObject{
    
}


@property (weak) id<ConnectStateDelegate> connectStateDelegate;

@property (strong,nonatomic) MyBluetoothLE *myBluetooth;

- (void)initWithInfo:(NSDictionary *)info PrintLog:(BOOL)printLog;

//驗證received字串
- (NSString *)calcReceivedMessage:(NSString *)message;

//計算 CheckSum
- (unsigned int)computationCheckSum:(NSString *)comm;

-(void) setFrequency: (float)second;

- (void)commTimerStart; //開始通訊迴圈
- (void)commTimerStop;  //結束通訊迴圈

- (void)addCommArray:(NSString *)comm RemoveAllComm:(BOOL)removeAllComm;

- (NSString *)getFirstComm;

- (int)getCommArrayCount;

//刪除命令
- (void)removeComm;
//刪除所有相同命令
- (void)removeSameComm:(NSString *)cmd;
//刪除所有命令
- (void)removeAllComm;

- (void)initSendCount;

- (NSString *)getHeader;
- (NSString *)getEnd;

-(NSString*) calcChecksum:(NSString *)headerStr deviceCode:(NSString*) deviceCode lengthstr:(NSString*) lengthstr cmd:(NSString*) cmd data:(NSString*) data;



//初始化
//@param simulation 是否開啟模擬數據
//@param printLog 是否印出SDK Log
- (id) getInstanceSimulation:(bool)simulation PrintLog:(bool)printLog;

//檢查是否支援藍牙LE。如果是,彈出詢問使用者是否開啟藍牙視窗
- (void)enableBluetooth;

//開始掃瞄,透過onScanResultMac傳回掃描到的藍牙資訊
//@param timeout 掃描時間(sec)
- (void) startScanTimeout:(int)timeout;

//停止掃瞄
- (void) stopScan;

//連線,透過onConnectionState返回連線狀態
- (void) connectUUID:(NSString *)uuid;

//斷線,透過onConnectionState返回斷線狀態
- (void) disconnect;


@end
