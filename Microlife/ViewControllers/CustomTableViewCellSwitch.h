//
//  CustomTableViewCellSwitch.h
//  MicroLifeSetting
//
//  Created by 曾偉亮 on 2016/12/29.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCellSwitch : UITableViewCell

@property (strong, nonatomic) NSString *titleStr;
@property (strong, nonatomic) NSString *subTitleStr;
@property (nonatomic) BOOL switchOn;
@property (strong, nonatomic) UISwitch *cell_switch;

//cell initialization
-(id)initWithFrameCustomCellMyDevice:(CGRect)frame withSubTitle:(BOOL)withSubTitle;

//更新 cell 資料
-(void)refreshMessage:(BOOL)withSubtitle;


@end
