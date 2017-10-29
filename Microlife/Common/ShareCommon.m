//
//  ShareCommon.m
//  LazyEye
//
//  Created by Tom on 2016/3/12.
//
//

#import "ShareCommon.h"

#import <CommonCrypto/CommonDigest.h>

@implementation ShareCommon


+ (void)showApplicationAlert:(NSString *)message Title:(NSString*)title
{
    
    UIAlertView *Alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [Alert show];
    Alert = nil;
}


+(BOOL) isValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

+(BOOL)isNumeric:(NSString*)inputString{
    BOOL isValid = NO;
    NSCharacterSet *alphaNumbersSet = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *stringSet = [NSCharacterSet characterSetWithCharactersInString:inputString];
    isValid = [alphaNumbersSet isSupersetOfSet:stringSet];
    return isValid;
}

+ (NSDate *)dateFromString:(NSString *)string
{
    NSDateFormatter *formatter  = [[NSDateFormatter alloc] init];
    formatter.dateFormat        = @"yyyy/MM/dd";
    NSDate *date                = [formatter dateFromString:string];
    
    return date;
}


+ (NSString *)DateToStringByFormate:(NSDate *)date formate:(NSString*)formate
{
    NSDateFormatter *formatter  = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    formatter.dateFormat        = formate;
    NSString *string            = [formatter stringFromDate:date];
    
    return string;
}

+ (BOOL)isEndDateIsSmallerThanCurrent:(NSDate *)checkEndDate
{
    NSDate* enddate = checkEndDate;
    NSDate* currentdate = [NSDate date];
    NSTimeInterval distanceBetweenDates = [enddate timeIntervalSinceDate:currentdate];
    double secondsInMinute = 60;
    NSInteger secondsBetweenDates = distanceBetweenDates / secondsInMinute;
    
    if (secondsBetweenDates == 0)
        return YES;
    else if (secondsBetweenDates < 0)
        return YES;
    else
        return NO;
}


+(NSString*)getDeviceUUID
{
    UIDevice *device = [UIDevice currentDevice];
    
    NSString  *currentDeviceId = [[device identifierForVendor]UUIDString];
    
    return currentDeviceId;
}

//取得設定檔 SystemConfig.plist 資料
+(NSString*)getSystemConfigValue:(NSString*)key
{
    NSString *keyValue;
    
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
    NSString *documentsDirectory = [paths objectAtIndex:0]; //2
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"SystemConfig.plist"]; //3
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: path]) //4
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"SystemConfig" ofType:@"plist"]; //5
        
        [fileManager copyItemAtPath:bundle toPath: path error:&error]; //6
    }
    
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
    
    keyValue=[data objectForKey:key];
    
    return  keyValue;
}

//設定設定檔 SystemConfig.plist 資料
+(void)setSystemConfigValue:(NSString*)key keyValue:(NSString*)keyValue
{
    
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
    NSString *documentsDirectory = [paths objectAtIndex:0]; //2
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"SystemConfig.plist"]; //3
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: path]) //4
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"SystemConfig" ofType:@"plist"]; //5
        
        [fileManager copyItemAtPath:bundle toPath: path error:&error]; //6
    }
    
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
    
    [data setObject:keyValue forKey:key];
    
    [data writeToFile: path atomically:YES];
    
}

//MD5 加密
+ (NSString *)md5String:(NSString*)input
{
    const char* str = [input UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, strlen(str), result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];//
    
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x",result];
    }
    return ret;
}


+(UIImage *)coreBlurImage:(UIImage *)image withBlurNumber:(CGFloat)blur
{
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage= [CIImage imageWithCGImage:image.CGImage];
    //设置filter
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey]; [filter setValue:@(blur) forKey: @"inputRadius"];
    //模糊图片
    CIImage *result=[filter valueForKey:kCIOutputImageKey];
    CGImageRef outImage=[context createCGImage:result fromRect:[result extent]];
    UIImage *blurImage=[UIImage imageWithCGImage:outImage];
    CGImageRelease(outImage);
    return blurImage;
}

+ (void)saveImageToFile:(UIImage *)image FileName:(NSString *)fileName {
    
    NSData *imgData = UIImageJPEGRepresentation(image, 1.0f);
    NSString *imgFullName = [ShareCommon pathForDocumentsResource:fileName];
    
    NSLog(@"save image file:%@",imgFullName);
    
    [imgData writeToFile:imgFullName atomically:YES];
}

+ (NSString *) pathForDocumentsResource:(NSString *) relativePath {
    
    static NSString* documentsPath = nil;
    
    if (nil == documentsPath) {
        
        NSArray* dirs = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        documentsPath = [dirs objectAtIndex:0] ;
    }
    
    return [documentsPath stringByAppendingPathComponent:relativePath];
}



+(NSString*)DictionaryToJson:(NSMutableArray*)dic
{
    NSString *jsonString=@"";
    
    @try {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic
                                                           options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                             error:&error];
        
        if (! jsonData) {
            NSLog(@"Got an error: %@", error);
            
            
        } else {
            jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        }
        
    } @catch (NSException *exception) {
        
        NSLog(@"exception:%@",exception.description);
        
    } @finally {
        return  jsonString;
    }
    
}

+(NSMutableArray*)JsonToDictionary:(NSString*)json
{
    NSMutableArray *dict=[[NSMutableArray alloc]init];
    
    @try {
        NSError *error;
        NSData *objectData = [json dataUsingEncoding:NSUTF8StringEncoding];
        
        dict = [NSJSONSerialization JSONObjectWithData:objectData options:NSJSONReadingMutableContainers error:&error];
        
    } @catch (NSException *exception) {
        NSLog(@"exception:%@",exception.description);
        
        dict=[[NSMutableArray alloc]init];
        
    } @finally {
        return dict;
    }
}


+ (NSDate *)getWeekStartForDate:(NSDate *)aDate
{
    aDate = [ShareCommon getDayStartForDate:aDate];
    NSCalendar *gregorian               = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger   weekDay                 = 1;
    NSInteger   weekOfMonth             = 1;
    NSDateComponents *dateComponents    = [gregorian components:NSWeekOfMonthCalendarUnit| NSWeekdayCalendarUnit fromDate:aDate];
    weekDay                             = dateComponents.weekday;
    weekOfMonth                         = dateComponents.weekOfMonth;
    
    dateComponents                      = [gregorian components:NSYearCalendarUnit| NSMonthCalendarUnit| NSDayCalendarUnit fromDate:aDate];
    dateComponents.day                  = dateComponents.day - (weekDay - 1);
    aDate                               = [gregorian dateFromComponents:dateComponents];
    
    return aDate;
}

+ (NSDate *)getDayStartForDate:(NSDate *)aDate
{
    NSCalendar *gregorian               = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dateComponents    = [gregorian components:NSYearCalendarUnit| NSMonthCalendarUnit| NSDayCalendarUnit fromDate:aDate];
    dateComponents.hour     = 0;
    dateComponents.minute   = 0;
    dateComponents.second   = 0;
    aDate                               = [gregorian dateFromComponents:dateComponents];
    
    return aDate;
}


@end
