//
//  RiskFactorCell.m
//  Microlife
//
//  Created by Idea on 2016/10/5.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import "RiskFactorCell.h"
#import "RiskFactorsViewController.h"

@implementation RiskFactorCell 

@synthesize isSelected,RFcheckbox,m_superVC;



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
