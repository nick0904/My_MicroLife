//
//  StatusCircleView.m
//  Microlife
//
//  Created by Rex on 2016/7/28.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import "StatusCircleView.h"

@interface StatusCircleView(){
    
}

@end

@implementation StatusCircleView

@synthesize circleTitle,circleValue,circleUnit,PADImgView;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initParameter];
        [self initInterface];
    }
    return self;
}

-(void)initParameter{
    
}

-(void)initInterface{
        
    self.layer.cornerRadius = self.frame.size.width/2;
    self.layer.borderWidth = 1.5;
    self.layer.borderColor = [TEXT_COLOR CGColor];
    
    PADImgView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width/2-SCREEN_WIDTH*0.093/2, SCREEN_HEIGHT*0.013, SCREEN_WIDTH*0.093, SCREEN_HEIGHT*0.037)];
    
    PADImgView.image = [UIImage imageNamed:@"history_icon_a_pad"];
    
    PADImgView.hidden = YES;
    
    [self addSubview:PADImgView];
    
    circleTitle = [[UILabel alloc] initWithFrame:CGRectZero];
    circleValue = [[UILabel alloc] initWithFrame:CGRectZero];
    circleUnit = [[UILabel alloc] initWithFrame:CGRectZero];
    
    circleTitle.textColor = DARKTEXT_COLOR;
    circleTitle.font = [UIFont systemFontOfSize:12.0];
    circleTitle.textAlignment = NSTextAlignmentCenter;
    [circleTitle setNumberOfLines:0];
    circleTitle.adjustsFontSizeToFitWidth = YES;
    
    [self addSubview:circleTitle];
    
    circleValue.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:30.0];
    circleValue.textAlignment = NSTextAlignmentCenter;
    circleValue.textColor = DARKTEXT_COLOR;
    circleValue.adjustsFontSizeToFitWidth = YES;
    
    [self addSubview:circleValue];
    
    circleUnit.textColor = DARKTEXT_COLOR;
    circleUnit.font = [UIFont systemFontOfSize:12.0];
    circleUnit.textAlignment = NSTextAlignmentCenter;
    [self addSubview:circleUnit];

}

-(void)setCircleTitleText:(NSString*)titleText{
    circleTitle.text = titleText;
    
}

-(void)setcircleValueText:(NSString*)valueText{
    circleValue.text = valueText;
    
}

-(void)setCircleUnitText:(NSString*)UnitText{
    circleUnit.text = UnitText;
}

-(void)setTextColorWithRange:(NSRange)range withColor:(UIColor*)color{
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc]
     initWithAttributedString: circleTitle.attributedText];
    
    [text addAttribute:NSForegroundColorAttributeName
                 value:color
                 range:range];
    [circleTitle setAttributedText: text];
    
}

-(void)setCircleValueFrame{
    
    circleTitle.frame = CGRectMake(self.frame.size.width/2-SCREEN_WIDTH*0.213/2, SCREEN_HEIGHT*0.025, SCREEN_WIDTH*0.213, SCREEN_HEIGHT*0.037);
    
    circleValue.frame = CGRectMake(self.frame.size.width/2-SCREEN_WIDTH*0.213/2, self.frame.size.height/2-SCREEN_HEIGHT*0.037/2, SCREEN_WIDTH*0.213, SCREEN_HEIGHT*0.037);
    
    circleUnit.frame = CGRectMake(self.frame.size.width/2-SCREEN_WIDTH*0.213/2, circleValue.frame.origin.y+circleValue.frame.size.height+10, SCREEN_WIDTH*0.213, SCREEN_HEIGHT*0.037);

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
