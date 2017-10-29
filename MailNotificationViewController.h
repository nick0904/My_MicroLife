//
//  MailNotificationViewController.h
//  Setting
//
//  Created by Ideabus on 2016/8/17.
//  Copyright © 2016年 Allen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddMailNotificationViewController.h"
#import "EditMailNotificationViewController.h"
#import "MemberCell.h"

@interface MailNotificationViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

-(id)initWithMailNotificationViewControllerFrame:(CGRect)frame;

@end
