//
//  TempTableViewCell.h
//  Microlife
//
//  Created by 曾偉亮 on 2016/9/17.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OverTempTableViewCell : UITableViewCell{
    //BODY TEMP
    UILabel *bodyTempLabel;
    UILabel *bodyTempUnitLabel;
}

@property (strong, nonatomic) UIImageView *tempCellImgView;

@property (strong, nonatomic) UIImageView *tempCellSperator;

@property (strong, nonatomic) UILabel *tempCellDateLabel;

@property (strong, nonatomic) UILabel *tempCellTimeLabel;

@property (strong, nonatomic) UILabel *bodyTempValueLabel;

-(id)initTempTableViewCellWithFrame:(CGRect)frame;

@end
