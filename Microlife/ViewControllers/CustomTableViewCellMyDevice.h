//
//  CustomTableViewCellMyDevice.h
//  MicroLifeSetting
//
//  Created by 曾偉亮 on 2016/12/29.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCellMyDevice : UITableViewCell

@property (strong, nonatomic) UIImageView *redMarkImgView;
@property (strong, nonatomic) NSString *titleStr;

//cell initialization
-(id)initWithFrameCustomCellMyDevice:(CGRect)frame;

//更新 cell 資料
-(void)refreshMessage;
 @end
