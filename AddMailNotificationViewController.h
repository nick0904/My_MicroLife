//
//  AddMailNotificationViewController.h
//  Setting
//
//  Created by Ideabus on 2016/8/17.
//  Copyright © 2016年 Allen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MailNotificationViewController.h"
#import "RegisterViewController.h"

@interface AddMailNotificationViewController : UIViewController<UITextFieldDelegate>{
    
    UITextField *addNameTextField;
    UITextField *addEmailTextField;

}

@property (nonatomic,retain)UITextField *addNameTextField;
@property (nonatomic,retain)UITextField *addEmailTextField;
@property (nonatomic,retain)NSString *nameString;
@property (nonatomic,retain)NSString *emailString;


@end
