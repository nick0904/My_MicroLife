//
//  ChangePasswordViewController.h
//  Setting
//
//  Created by Ideabus on 2016/8/17.
//  Copyright © 2016年 Allen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangePasswordViewController : UIViewController<UITextFieldDelegate>{
    
    UITextField *Password_cTextField;
    UITextField *NewPasswordTextField;
    UITextField *ComfirmNewPasswordTextField;
    
}

@property (nonatomic,retain)UITextField *Password_cTextField;
@property (nonatomic,retain)UITextField *NewPasswordTextField;
@property (nonatomic,retain)UITextField *ComfirmNewPasswordTextField;

@end
