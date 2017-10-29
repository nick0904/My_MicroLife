//
//  CustomTableViewCellSwitch.m
//  MicroLifeSetting
//
//  Created by 曾偉亮 on 2016/12/29.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import "CustomTableViewCellSwitch.h"

@implementation CustomTableViewCellSwitch {
    
    UILabel *cell_titleLabel;
    UILabel *cell_subTitleLabel;
    CGFloat textSize;
    UIView *bottomLine;
}

@synthesize titleStr, subTitleStr, switchOn, cell_switch;


#pragma mark - cell initialization =======================
-(id)initWithFrameCustomCellMyDevice:(CGRect)frame withSubTitle:(BOOL)withSubTitle {
    
    self = [super init];
    
    if(!self) return nil;
    
    self.frame = frame;
    
    [self initCellParam:withSubTitle];
    
    return self;
}

-(void)initCellParam:(BOOL)withSubtitle {
    
    //topLine (上邊線)
    UIView *topLine = [self createBoardLine:CGPointMake(0, 0)];
    [self.contentView addSubview:topLine];
    
    //bottomLine (下邊線)
    bottomLine = [self createBoardLine:CGPointMake(0, CGRectGetMaxY(self.frame) - 1 )];
    [self.contentView addSubview:bottomLine];
    
    
    if(withSubtitle) {
        
        //有subTitle
        //cell_switch init
        cell_switch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.height*0.5, self.frame.size.height*0.5)];
        cell_switch.center = CGPointMake(CGRectGetMaxX(self.frame) - cell_switch.frame.size.width/2, self.frame.size.height/2);
        [self.contentView addSubview:cell_switch];
        
        
        //cell_titleLabel init
        cell_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.frame.size.width - cell_switch.frame.size.width - 10, self.frame.size.height/3*2)];
        cell_titleLabel.font = [UIFont systemFontOfSize:cell_titleLabel.frame.size.height];
        [self.contentView addSubview:cell_titleLabel];
        
        
        //cell_subTitleLabel init
        cell_subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(cell_titleLabel.frame), cell_titleLabel.frame.size.width - 10, self.frame.size.height/3)];
        cell_subTitleLabel.font = [UIFont systemFontOfSize:cell_subTitleLabel.frame.size.height];
        cell_subTitleLabel.adjustsFontSizeToFitWidth = YES;
        cell_subTitleLabel.textColor = [UIColor grayColor];
        [self.contentView addSubview:cell_subTitleLabel];
        
    }
    else {
        
        //無subTitle
        //cell_switch init
        cell_switch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.height*0.5, self.frame.size.height*0.5)];
         cell_switch.center = CGPointMake(CGRectGetMaxX(self.frame) - cell_switch.frame.size.width/2, self.frame.size.height/2);
        [self.contentView addSubview:cell_switch];
        
        
        //cell_titleLabel init
        cell_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.frame.size.width - cell_switch.frame.size.width - 10, self.frame.size.height)];
        [self.contentView addSubview:cell_titleLabel];
        
    }
    
}

#pragma mark - 更新 cell 資料 =======================
-(void)refreshMessage:(BOOL)withSubtitle {
    
    textSize = self.frame.size.height * 0.35;
    
    if (withSubtitle) {
        
        cell_titleLabel.font = [UIFont systemFontOfSize:textSize/3*2];
        cell_subTitleLabel.font = [UIFont systemFontOfSize:textSize/3];
        cell_subTitleLabel.text = subTitleStr;
    }
    else {
        
        cell_titleLabel.font = [UIFont systemFontOfSize:textSize];
    }
    
    cell_titleLabel.text = titleStr;
    cell_switch.on = switchOn;
}


#pragma mark - CreateBoardLine =======================
-(UIView *)createBoardLine:(CGPoint)originPoint {
    
    UIView *boardLine = [[UIView alloc] initWithFrame:CGRectMake(originPoint.x, originPoint.y, self.frame.size.width, 1)];
    boardLine.backgroundColor = CELL_SPERATORCOLOR;
    
    return boardLine;
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
