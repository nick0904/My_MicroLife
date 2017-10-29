//
//  BPTableViewCell.m
//  Microlife
//
//  Created by 曾偉亮 on 2016/9/17.
//  Copyright © 2016年 Rex. All rights reserved.
//


#import "OverBPTableViewCell.h"

@implementation OverBPTableViewCell

@synthesize bpCellImgView,bpCellSperator,bpCellDateLabel,bpCellTimeLabel,sysValueLabel,diaValueLabel,pulValueLabel;

-(id)initBPTableiewCellWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (!self) return nil;
    
    //bpCellImgView
    bpCellImgView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width/30, frame.size.height/20, frame.size.height/3.5,frame.size.height/3.5)];
    bpCellImgView.image = [UIImage imageNamed:@"reminder_icon_a_bp"];
    [self addSubview:bpCellImgView];
    
    //bpCellSperator
    bpCellSperator = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX(bpCellImgView.frame), CGRectGetMaxY(bpCellImgView.frame)+5, 1.0, frame.size.height/1.8)];
    bpCellSperator.backgroundColor = STANDER_COLOR;
    bpCellSperator.image = [UIImage imageNamed:@"microlife_blue"];
    [self addSubview:bpCellSperator];
    
    //bpCellDateLabel
    bpCellDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(bpCellImgView.frame)+5, CGRectGetMinY(bpCellImgView.frame),frame.size.width/2, frame.size.height/3)];
    //bpCellDateLabel.textAlignment = NSTextAlignmentCenter;
    bpCellDateLabel.text = @"";
    bpCellDateLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:bpCellDateLabel];
    
    //bpCellTimeLabel
    bpCellTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(bpCellDateLabel.frame)+5, CGRectGetMinY(bpCellDateLabel.frame), frame.size.width/6, frame.size.height/3)];
    bpCellTimeLabel.text = @"";
    bpCellTimeLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:bpCellTimeLabel];
    
    //SYS
    //----------------------------------------
    CGFloat labelWidth = frame.size.width/12;
    CGFloat labelHeight = frame.size.height/2.5;
    
    //sysLabel
    sysLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(bpCellDateLabel.frame), CGRectGetMaxY(bpCellDateLabel.frame), labelWidth, labelHeight)];
    sysLabel.text = @"SYS";
    sysLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:sysLabel];
    
    
    //sysValueLabel
    sysValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(sysLabel.frame), CGRectGetMinY(sysLabel.frame), labelWidth, labelHeight)];
    sysValueLabel.text = @"";
    sysValueLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:sysValueLabel];
    
    //sysUnitLabel
    sysUnitLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(sysValueLabel.frame), CGRectGetMinY(sysLabel.frame), labelWidth, labelHeight)];
    sysUnitLabel.text = @"mmHg";
    sysUnitLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:sysUnitLabel];
    
    //DIA
    //----------------------------------------
    //diaLabel
    diaLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(sysUnitLabel.frame)+labelWidth/2, CGRectGetMinY(sysLabel.frame), labelWidth, labelHeight)];
    diaLabel.text = @"DIA";
    diaLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:diaLabel];
    
    //diaValueLabel
    diaValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(diaLabel.frame), CGRectGetMinY(sysLabel.frame), labelWidth, labelHeight)];
    diaValueLabel.text = @"";
    diaValueLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:diaValueLabel];
    
    //diaUnitLabel
    diaUnitLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(diaValueLabel.frame), CGRectGetMinY(sysLabel.frame), labelWidth, labelHeight)];
    diaUnitLabel.text = @"mmHg";
    diaUnitLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:diaUnitLabel];
    
    //PUL
    //----------------------------------------
    //pulLabel
    pulLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(diaUnitLabel.frame)+labelWidth/2, CGRectGetMinY(sysLabel.frame), labelWidth, labelHeight)];
    pulLabel.text = NSLocalizedString(@"PUL", nil);
    pulLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:pulLabel];
    
    //pulValueLabel
    pulValueLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(pulLabel.frame), CGRectGetMinY(sysLabel.frame), labelWidth, labelHeight)];
    pulValueLabel.text = @"";
    pulValueLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:pulValueLabel];
    
    //pulUnitLabel
    pulUnitLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(pulValueLabel.frame), CGRectGetMinY(sysLabel.frame), labelWidth, labelHeight)];
    pulUnitLabel.text = @"bpm";
    pulUnitLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:pulUnitLabel];
    
    
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
