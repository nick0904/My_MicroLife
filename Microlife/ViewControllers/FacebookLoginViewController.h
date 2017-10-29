//
//  FacebookLoginViewController.h
//  facebooklogin
//
//  Created by Ideabus on 2016/8/4.
//  Copyright © 2016年 Allen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>  //授權認證機制
#import "FBSDKLoginKit/FBSDKLoginKit.h"


@interface FacebookLoginViewController : UIViewController
@property (nonatomic, strong) ACAccountStore *accountStore;
@property (nonatomic, strong) ACAccount *facebookAccount;

//-(void) getI;
-(void) connectFacebook;

@end
