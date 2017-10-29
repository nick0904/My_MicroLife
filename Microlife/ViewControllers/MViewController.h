//
//  MViewController.h
//  FuelSation
//
//  Created by Tom on 2016/4/14.
//  Copyright © 2016年 Tom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"


@interface MViewController : UIViewController
{
    AppDelegate *appDelegate;
    UIButton *sidebarcloseBtn;
    UIView *circleview;
    UIView *circle2view;
    //Global Array
    
}

@property (strong,nonatomic) AppDelegate *appDelegate;
@property (nonatomic) float imgScale;
@property (strong,nonatomic) UIColor *textColor;
@property (strong,nonatomic) UIColor *standerColor;
@property (nonatomic,retain) UIButton *sidebarcloseBtn;
@property (nonatomic,retain) UIView *circleview;

-(void)SidebarBtn;
-(void)sidebarClose;
-(UIImage *)resizeImage:(UIImage *)image;
-(UIImage *)snapShotView:(UIView *)inputView;
-(NSString *)getUserEmail;

//取得字串長度
+(NSUInteger)getStringLength:(NSString *)text;
//警告提示
+(void)showAlert:(NSString *)title message:(NSString *)message buttonTitle:(NSString *)buttonTitle;


//檢查是 privacy 或 會員模式
//NO:會員制 / YES:隱私模式
+(BOOL)checkIsPrivacyModeOrMemberShip;
+(void)setPrivacyModeOrMemberShip:(BOOL)isPrivacy;


//檢查是否與 HealthKit 同步
+(BOOL)checkIsSyncWithHealthKit;
+(void)setSyncWithHealthKit:(BOOL)isSyncHealthKit;

//check access_token
+(BOOL)checkAccess_tokenFilePath;
+(void)saveAccess_token:(NSString *)access_tokenStr;


//check refresh_token
+(BOOL)checkRefresh_tokenFilePath;
+(void)saveRefresh_token:(NSString *)refresh_tokenStr;


//saveUserName
+(BOOL)checkUserNamePath;
+(void)saveUserName:(NSString *)userName;


//Connecting Device Name
+(BOOL)checkConnectingDeviceNamePath;
+(void)saveConnectingDeviceName:(NSString *)deviceName;

//transformMacAddress
+(NSString *)transformMacAddress:(NSString *)originMacAddress;


@end
