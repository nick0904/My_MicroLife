//
//  BPTableViewCell.h
//  Microlife
//
//  Created by 曾偉亮 on 2016/9/17.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OverBPTableViewCell : UITableViewCell{
    //SYS
    UILabel *sysLabel;
    UILabel *sysValueLabel;
    UILabel *sysUnitLabel;
    
    //DIA
    UILabel *diaLabel;
    UILabel *diaValueLabel;
    UILabel *diaUnitLabel;
    
    //PUL
    UILabel *pulLabel;
    UILabel *pulValueLabel;
    UILabel *pulUnitLabel;
}

@property (strong, nonatomic) UIImageView *bpCellImgView;

@property (strong, nonatomic) UIImageView *bpCellSperator;

@property (strong, nonatomic) UILabel *bpCellDateLabel;

@property (strong, nonatomic) UILabel *bpCellTimeLabel;

@property (strong, nonatomic) UILabel *diaValueLabel;
@property (strong, nonatomic) UILabel *pulValueLabel;
@property (strong, nonatomic) UILabel *sysValueLabel;

-(id)initBPTableiewCellWithFrame:(CGRect)frame;

@end
