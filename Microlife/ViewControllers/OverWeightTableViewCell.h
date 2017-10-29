//
//  WeightTableViewCell.h
//  Microlife
//
//  Created by 曾偉亮 on 2016/9/17.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OverWeightTableViewCell : UITableViewCell{
    //WEIGHT
    UILabel *weightLabel;
    
    UILabel *weightUnitLabel;
    
    //BMI
    UILabel *bmiLabel;
    
    
    //BODY FAT
    UILabel *bodyFatLabel;
    UILabel *bodyFatUnitLabel;
}

@property (strong, nonatomic) UIImageView *weightCellImgView;

@property (strong, nonatomic) UIImageView *weightCellSperator;

@property (strong, nonatomic) UILabel *weightCellDateLabel;

@property (strong, nonatomic) UILabel *weightCellTimeLabel;

@property (strong, nonatomic) UILabel *weightValueLabel;
@property (strong, nonatomic) UILabel *bodyFatValueLabel;
@property (strong, nonatomic) UILabel *bmiValueLabel;

-(id)initWithWeightCellFrame:(CGRect)frame;

@end
