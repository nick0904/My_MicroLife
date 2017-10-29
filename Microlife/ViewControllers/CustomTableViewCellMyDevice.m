//
//  CustomTableViewCellMyDevice.m
//  MicroLifeSetting
//
//  Created by 曾偉亮 on 2016/12/29.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import "CustomTableViewCellMyDevice.h"

@implementation CustomTableViewCellMyDevice {
    
    UILabel *cell_titleLabel;
    
    CGFloat textSize;
}

@synthesize redMarkImgView, titleStr;


#pragma mark - cell initialization =======================
-(id)initWithFrameCustomCellMyDevice:(CGRect)frame {
    
    self = [super init];
    
    if (!self) return nil;
    
    self.frame = frame;
    
    [self initWithCellParam];
    
    return self;
    
}


-(void)initWithCellParam {
    
    //redMarkImgView init
    redMarkImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.height*0.45, self.frame.size.height*0.45)];
    redMarkImgView.center = CGPointMake(CGRectGetMaxX(self.frame) - redMarkImgView.frame.size.width, self.frame.size.height/2);
    redMarkImgView.image = [UIImage imageNamed:@"setting_btn_a_delete"];
    [self.contentView addSubview:redMarkImgView];
    
    //cell_titleLabel
    cell_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.frame.size.width - redMarkImgView.frame.size.width - 10, self.frame.size.height)];
    
    [self.contentView addSubview:cell_titleLabel];
    
}


#pragma mark - 更新 cell 資料 =======================
-(void)refreshMessage {
    
    textSize = self.frame.size.height * 0.35;
    cell_titleLabel.font = [UIFont systemFontOfSize:textSize];
    cell_titleLabel.text = titleStr;
}


#pragma mark - Xcode Origin Function =======================
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
