//
//  CustomTableViewCellNormal.m
//  MicroLifeSetting
//
//  Created by 曾偉亮 on 2016/12/30.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import "CustomTableViewCellNormal.h"

@implementation CustomTableViewCellNormal {
    
    UILabel *cell_titleLabel;
    CGFloat textSize;
}

@synthesize titleStr;

#pragma mark - cell initialization =======================
-(id)initWithFrameCustomCellNormal:(CGRect)frame {
    
    self = [super init];
    
    if (!self) return nil;
    
    self.frame = frame;
    
    [self initWithCellParam];
    
    return self;
}

-(void)initWithCellParam {
    
    //topLine (上邊線)
    UIView *topLine = [self createBoardLine:CGPointMake(0, 0)];
    [self.contentView addSubview:topLine];
    
    //bottomLine (下邊線)
    UIView *bottomLine = [self createBoardLine:CGPointMake(0, CGRectGetMaxY(self.frame) - 1 )];
    [self.contentView addSubview:bottomLine];
    
    
    //cell_titleLabel init
    cell_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.frame.size.width - 10, self.frame.size.height)];
    [self.contentView addSubview:cell_titleLabel];
    
}


#pragma mark - 更新 cell 資料 =======================
-(void)refreshMessage {
    
    textSize = self.frame.size.height*0.35;
    cell_titleLabel.font = [UIFont systemFontOfSize:textSize];
    cell_titleLabel.text = titleStr;
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
