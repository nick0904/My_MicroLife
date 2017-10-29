//
//  RainbowBarView.h
//  Microlife
//
//  Created by 曾偉亮 on 2016/10/12.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RainbowBarView : UIView


-(id)initWithRainbowView:(CGRect)frame;

//0:歐規,1:USA ,2:非歐非USA 血壓計
-(void)checkRainbowbarValue:(int)countryFormat sys:(int)sys dia:(int)dia;

//體重計
-(void)checkBMIValue:(float)bmi;

@end
