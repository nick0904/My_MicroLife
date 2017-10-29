
#import <Foundation/Foundation.h>

@interface Function : NSObject

typedef enum{
    ScanFinish,
    Connected,
    Disconnect,
    ConnectTimeout
}ConnectState;


// Math

//十六進制字串轉bytes
+ (NSData *) hexStrToNSData:(NSString *)hexStr;

+ (int)hexStringToInt:(NSString *)hexString;

// 字串轉十六進制(轉換字串: string): int
+ (int)stringToHex:(NSString *)string;

//+ (NSString *)hexStringFromString:(NSString *)string;

+ (void)setPrintLog:(BOOL)printLog;
+ (void)printLog:(NSString *)log;

//取得當前時間yyyy-MM-dd-HH-mm-ss-ww
+ (NSString *)getCurrentDateTimeWeek;
//取得當月天數
+ (long)getDayOfMonth;

//十六進制字串轉十進制數值
//scanLocation : 從第幾位開始轉換
+ (int)getIntFromHexString:(NSString *)hexString ScanLocation:(int)scanLocation;


//16进制和2进制互转
+ (NSString *)getBinaryByhex:(NSString *)hex binary:(NSString *)binary;
//  二进制转十进制
+ (NSString *)toDecimalWithBinary:(NSString *)binary;
//10进制转2进制
+ (NSString *)toBinarySystemWithDecimalSystem:(int)num length:(int)length;


@end
