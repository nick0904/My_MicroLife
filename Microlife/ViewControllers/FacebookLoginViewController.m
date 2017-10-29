//
//  FacebookLoginViewController.m
//  facebooklogin
//
//  Created by Ideabus on 2016/8/4.
//  Copyright © 2016年 Allen. All rights reserved.
//

#import "FacebookLoginViewController.h"
#import <Accounts/Accounts.h>
#import <AccountKit/AccountKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface FacebookLoginViewController ()


@property (strong, nonatomic) IBOutlet UIButton *logoutFacebook;

@end

@implementation FacebookLoginViewController

-(void)connectFacebook{
    FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
    
    if ([FBSDKAccessToken currentAccessToken])
    {
        NSLog(@"Token is available : %@",[[FBSDKAccessToken currentAccessToken]tokenString]);
        [self fetchUserInfo];
    }
    else
    {
        [loginManager logInWithReadPermissions:@[@"email"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error)
         {
             if (error)
             {
                 NSLog(@"Login process error");
             }
             else if (result.isCancelled)
             {
                 NSLog(@"User cancelled login");
             }
             else
             {
                 NSLog(@"Login Success");
                 
                 if ([result.grantedPermissions containsObject:@"email"])
                 {
                     NSLog(@"result is:%@",result);
                     [self fetchUserInfo];
                 }
                 else
                 {
                     
                     
                     //  [NSProgress showErrorWithStatus:@"Facebook email permission error"];
                     
                 }
             }
         }];
    }
    
    [loginManager logOut];
    [FBSDKAccessToken setCurrentAccessToken:nil];

}


-(void)getFBResult
{
    if ([FBSDKAccessToken currentAccessToken])
    {
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, first_name, last_name, picture.type(large), email"}]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error)
             {
                 NSLog(@"fb user info : %@",result);
             }
             else
             {
                 NSLog(@"error : %@",error);
             }
         }];
    }
}


- (IBAction)logoutFacebook:(id)sender {
    //[self logout];
    
}

//取得使用者的姓名和email

-(void)fetchUserInfo{
    
    
    if ([FBSDKAccessToken currentAccessToken])
    {
        NSLog(@"Token is available : %@",[[FBSDKAccessToken currentAccessToken]tokenString]);
        
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id, name, email,picture.type(large)"}]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error)
             {
                 NSLog(@"results:%@",result);
                 
                 NSString *email = [result objectForKey:@"email"];
                 NSString *userID = [result objectForKey:@"id"];
                 NSString *userName = [result objectForKey:@"name"];

                // NSString *userId = [result objectForKey:@"id"];
                 
                 if (email.length >0 )
                 {
                     //這裏可以放要讓app做的事
                     
                     [LocalData sharedInstance].accountID = [userID intValue];
                     
                     UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                     UIViewController *vc=[storyboard instantiateViewControllerWithIdentifier:@"TabBarViewController"];
                     
                     [self presentViewController:vc animated:YES completion:nil];
                     
                 }
                 else
                 {
                     NSLog(@"Facebook email is not verified");
                        }
                  }
                           else
                           {
                               NSLog(@"Error %@",error);
                           }
                }];
             }
        }


-(void)fbLogin{
    
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    // 將臉書登入按鈕置中
    loginButton.frame = CGRectMake(100, 100, 180, 33);
    [self.view addSubview:loginButton];
    
    loginButton.readPermissions =
    @[@"public_profile", @"email", @"user_friends"];
    
}

//-(void) logout
//{
////    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
////    
////    if ( [FBSDKAccessToken currentAccessToken] ){
////        [login logOut];
////    }
//}




- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    

}

@end
