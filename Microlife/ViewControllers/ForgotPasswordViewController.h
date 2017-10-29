//
//  ForgotPasswordViewController.h
//  facebooklogin
//
//  Created by Ideabus on 2016/8/11.
//  Copyright © 2016年 Allen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegisterViewController.h"


@interface ForgotPasswordViewController : UIViewController <UITextFieldDelegate> {
    UIButton *sendBtn;
    UITextField *femailTextField;
}
@property (nonatomic,retain) UIButton *sendBtn;
@property (nonatomic,retain) UITextField *femailTextField;

@end
