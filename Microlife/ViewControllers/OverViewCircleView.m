//
//  OverViewCircleView.m
//  Microlife
//
//  Created by 曾偉亮 on 2016/9/12.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import "OverViewCircleView.h"

@implementation OverViewCircleView {
    
    UILabel *titleLabel;
    UILabel *valueLabel;
    UILabel *unitLabel;
    
    NSString *circleViewValueString;
    
}

@synthesize circleViewTitleString,circleViewUnitString,circleImgView,device,sys,dia,weight,temp,alertRedImage;

-(instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self initParameter];
        [self initInterface];
    }
    
    return self;
}

-(void)initParameter {
    
    
}

-(void)initInterface {
    
    //圓
    self.layer.cornerRadius = self.frame.size.width/2;
    self.layer.borderWidth = 6.0f;
    self.layer.borderColor = [STANDER_COLOR CGColor];
    
    //紅色漸層小圈
    alertRedImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width*1.5, self.frame.size.width*1.5)];
    
    
    alertRedImage.center = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    alertRedImage.image = [UIImage imageNamed:@"overview_ef_2"];
    [self addSubview:alertRedImage];
    
    alertRedImage.hidden = YES;
    
    //titleLabel
    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width/2, self.frame.size.height/4)];
    titleLabel.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/4);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.adjustsFontSizeToFitWidth = YES;
    //titleLabel.numberOfLines=0;
    [self addSubview:titleLabel];
    
    //valueLabel
    valueLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width*0.8, self.frame.size.height/3)];
    valueLabel.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    valueLabel.textAlignment = NSTextAlignmentCenter;
    valueLabel.font = [UIFont systemFontOfSize:valueLabel.frame.size.height * (IS_IPAD?0.68:0.68)];
    valueLabel.adjustsFontSizeToFitWidth = YES;
    
    [self addSubview:valueLabel];
    
    //unitLabel
    unitLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width/2, self.frame.size.height/4)];
    unitLabel.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/4*3);
    unitLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:unitLabel];
    
    //circleImgView
    circleImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width*0.88, self.frame.size.width*0.88)];
    circleImgView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    [self addSubview:circleImgView];
    
}


-(void)setString {
//    @property int pul;
//    @property float weight;
//    @property float MBI;
//    @property float fat;
    switch (device) {
        case 0:
            //血壓計
            if (sys == 0 || dia == 0) {
                circleViewValueString = @"--/--";
            }else{
                circleViewValueString = [NSString stringWithFormat:@"%d/%d",sys,dia];
            }
            
            break;
        case 1:
            //體重計
            if(weight == 0){
                circleViewValueString = @"--";
            }else{
                circleViewValueString = [NSString stringWithFormat:@"%.1f",weight];
            }
            
            break;
        case 2:
            //溫度計
            if(temp == 0){
                circleViewValueString = @"--";
            }else{
                circleViewValueString = [NSString stringWithFormat:@"%.1f℃",temp];
            }
            
            break;
        default:
            break;
    }
    
    titleLabel.text = circleViewTitleString;
    
    valueLabel.text = circleViewValueString;
    
    unitLabel.text = circleViewUnitString;
    
}

@end
