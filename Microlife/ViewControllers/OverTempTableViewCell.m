//
//  TempTableViewCell.m
//  Microlife
//
//  Created by 曾偉亮 on 2016/9/17.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import "OverTempTableViewCell.h"

@implementation OverTempTableViewCell

@synthesize tempCellImgView,tempCellSperator,tempCellDateLabel,tempCellTimeLabel,bodyTempValueLabel;


-(id)initTempTableViewCellWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (!self) return nil;
    
    //tempCellImgView
    //tempCellImgView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width/30, frame.size.height/20, frame.size.height/3.5,frame.size.height/3.5)];
    
    tempCellImgView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width/30, frame.size.height/20, 30,30)];
    
    tempCellImgView.image = [UIImage imageNamed:@"reminder_icon_a_bt"];
    [self addSubview:tempCellImgView];
    
    //tempCellSperator
    tempCellSperator = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX(tempCellImgView.frame), CGRectGetMaxY(tempCellImgView.frame)+5, 1.0, frame.size.height/1.8)];
    tempCellSperator.image = [UIImage imageNamed:@"microlife_blue"];
    
    tempCellSperator.backgroundColor = STANDER_COLOR;
    [self addSubview:tempCellSperator];
    
    //tempCellDateLabel
    tempCellDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(tempCellImgView.frame)+5, CGRectGetMinY(tempCellImgView.frame),frame.size.width/3, tempCellImgView.frame.size.height)];
    tempCellDateLabel.text = @"";
    tempCellDateLabel.font = [UIFont systemFontOfSize:15.0];
    tempCellDateLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:tempCellDateLabel];
    
    //tempCellTimeLabel
    //tempCellTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(tempCellDateLabel.frame)+5, CGRectGetMinY(tempCellDateLabel.frame), frame.size.width/6, frame.size.height/3)];
    //tempCellTimeLabel.text = @"at 10:25";
    //tempCellTimeLabel.adjustsFontSizeToFitWidth = YES;
    //[self addSubview:tempCellTimeLabel];
    
    //BODY TEMP
    //---------------------------------
    CGFloat labelWidth = frame.size.width/6;
    CGFloat labelHeight = tempCellImgView.frame.size.height;
    
    //bodyTempLabel
//    bodyTempLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(tempCellTimeLabel.frame)+labelWidth/2, CGRectGetMinY(tempCellTimeLabel.frame), labelWidth, labelHeight)];
//    bodyTempLabel.text = @"body temp";
//    bodyTempLabel.adjustsFontSizeToFitWidth = YES;
//    [self addSubview:bodyTempLabel];
    
    
    //bodyTempLabel
    bodyTempLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(tempCellDateLabel.frame)+labelWidth/2-10, CGRectGetMinY(tempCellDateLabel.frame), labelWidth, labelHeight)];
    bodyTempLabel.text = @"body temp";
    bodyTempLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:bodyTempLabel];
    
    
    
    //bodyTempValueLabel
    bodyTempValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(bodyTempLabel.frame)+10, CGRectGetMinY(bodyTempLabel.frame), labelWidth, labelHeight)];
    bodyTempValueLabel.text = @"";
    bodyTempValueLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:bodyTempValueLabel];
    
    //bodyTempUnitLabel
    bodyTempUnitLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(bodyTempValueLabel.frame), CGRectGetMinY(bodyTempLabel.frame), labelWidth/2, labelHeight)];
    bodyTempUnitLabel.text = @"℃";
    [self addSubview:bodyTempUnitLabel];
    
    return self;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
    
    
    
}

@end
