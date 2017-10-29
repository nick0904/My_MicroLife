//
//  OverViewCircleView.h
//  Microlife
//
//  Created by 曾偉亮 on 2016/9/12.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OverViewCircleView : UIView


@property (strong, nonatomic) NSString *circleViewTitleString;
@property (strong, nonatomic) NSString *circleViewUnitString;
@property (strong, nonatomic) UIImageView *circleImgView;
@property (strong, nonatomic) UIImageView *alertRedImage;

@property int device; //0:血壓計, 1:體重計, 2:溫度計
@property int sys;
@property int dia;
@property float weight;
@property float temp;

-(void)setString;

@end
