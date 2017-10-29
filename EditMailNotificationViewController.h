//
//  EditMailNotificationViewController.h
//  Setting
//
//  Created by Ideabus on 2016/8/18.
//  Copyright © 2016年 Allen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditMailNotificationViewController : UIViewController<UITextFieldDelegate>

@property (nonatomic,retain) UITextField *editNameTextField;
@property (nonatomic,retain) UITextField *editEmailTextField;
@property(strong,nonatomic) UITextField *textInfo;
@property(strong,nonatomic) NSString *str;
@property (nonatomic,retain) NSString *editNameStr;
@property (nonatomic,retain) NSString *editEmailStr;
@property int editIndex;
@property (strong, nonatomic) NSNumber *mail_id;



@end
