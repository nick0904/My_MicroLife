//
//  DeleteMailCell.m
//  Microlife
//
//  Created by 曾偉亮 on 2017/3/17.
//  Copyright © 2017年 Rex. All rights reserved.
//

#import "DeleteMailCell.h"

@implementation DeleteMailCell {
    
    UILabel *mailTitle_label;
}

-(id)initWithDeleteMailCellFrame:(CGRect)frame {
    
    self = [super init];
    
    if (!self) return nil;
    
    self.frame = frame;
    
    [self initWithUIObjs];
    
    return self;
}


-(void)initWithUIObjs {
    
    //selectedStr init
    self.selectedStr = @"0";
    
    
    //selectBtn init
    self.selectBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.height*0.5, self.frame.size.height*0.5)];
    self.selectBtn.center = CGPointMake(10+self.selectBtn.frame.size.width/2, self.frame.size.height/2);
    [self.selectBtn setImage:[UIImage imageNamed:@"all_select_a_0"] forState:UIControlStateNormal];
    [self addSubview:self.selectBtn];
    
    
    //mailTitle_label init
    mailTitle_label = [[UILabel alloc] initWithFrame:CGRectMake(0,  0, self.frame.size.width - CGRectGetMaxY(self.selectBtn.frame) - 10, self.frame.size.height*0.88)];
    mailTitle_label.center = CGPointMake(CGRectGetMaxX(self.selectBtn.frame) + mailTitle_label.frame.size.width/2 + 10, self.selectBtn.center.y);
    mailTitle_label.textAlignment = NSTextAlignmentLeft;
    mailTitle_label.textColor = [UIColor blackColor];
    [self addSubview:mailTitle_label];
    
}


-(void)refreshData {
    
    mailTitle_label.text = self.mailTitle;
    
    NSString *imgName = [self.selectedStr isEqualToString:@"0"] ? @"all_select_a_0" : @"all_select_a_1";
    [self.selectBtn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
    
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
