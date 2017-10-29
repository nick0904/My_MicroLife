//
//  MeasureCell.m
//  Microlife
//
//  Created by Idea on 2016/10/11.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import "MeasureCell.h"

@implementation MeasureCell

-(void)layoutSubviews{
    
    [super layoutSubviews];
    CGRect cellRect = self.bounds;
    cellRect.size.width = self.frame.size.width;
    
    
    _errortittle.textAlignment = NSTextAlignmentLeft;
    _errortittle.frame = CGRectMake(cellRect.size.width*0.05, 0, cellRect.size.width*0.5, cellRect.size.height);
    
    _errortimes.textAlignment = NSTextAlignmentRight;
    _errortimes.frame = CGRectMake(cellRect.size.width*0.5, 0, cellRect.size.width*0.47, cellRect.size.height);
    
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
