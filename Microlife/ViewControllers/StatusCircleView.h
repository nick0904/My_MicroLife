//
//  StatusCircleView.h
//  Microlife
//
//  Created by Rex on 2016/7/28.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatusCircleView : UIView

@property (nonatomic, strong) UIImageView *statusImg;
@property (nonatomic, strong) UIImageView *PADImgView;

@property (nonatomic, strong) UILabel *circleTitle;
@property (nonatomic, strong) UILabel *circleValue;
@property (nonatomic, strong) UILabel *circleUnit;

-(void)setTextColorWithRange:(NSRange)range withColor:(UIColor*)color;

-(void)setCircleTitleText:(NSString*)titleText;
-(void)setcircleValueText:(NSString*)valueText;
-(void)setCircleUnitText:(NSString*)UnitText;
-(void)setCircleValueFrame;
@end
