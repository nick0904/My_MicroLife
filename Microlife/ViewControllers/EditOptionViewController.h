//
//  EditOptionViewController.h
//  Microlife
//
//  Created by Rex on 2016/9/14.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditOptionViewController : UIViewController

@property (nonatomic) NSInteger alarmIndex;
@property (nonatomic, strong) NSString *customStr;

@property (nonatomic, retain) UITapGestureRecognizer          *tapPress;


@end
