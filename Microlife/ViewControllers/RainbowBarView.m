//
//  RainbowBarView.m
//  Microlife
//
//  Created by 曾偉亮 on 2016/10/12.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import "RainbowBarView.h"

@implementation RainbowBarView {
    
    UIImageView *rainbowbarIndicator;
    UIImageView *rainbowbar;
    NSMutableArray *ary_rainbowbarImg;
    
    //分級敘述相關
    UILabel *classificationLabel;
    NSMutableArray<UILabel *> *ary_levelLabel;
    NSArray *ary_levelName_eroupe;
    NSArray *ary_levelName_usaAndOther;
    NSArray *ary_bmiName;
    
    CGFloat indicatorCenterY;
    CGFloat rainbowbarUnit;
    CGPoint rainbowBarOirPoint;
}


-(id)initWithRainbowView:(CGRect)frame {
    
    self = [super init];
    
    if (!self) return nil;
    
    self.frame = frame;
    
    //speratorLine
    UILabel *speratorLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1)];
    speratorLine.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:speratorLine];
    
    //rainbowbar
    CGFloat barWidth = frame.size.width * 0.9;
    rainbowbar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, barWidth, barWidth/35)];
    rainbowbar.center = CGPointMake(frame.size.width/2, frame.size.height/2);
    [self addSubview:rainbowbar];
    
    rainbowBarOirPoint = CGPointMake(CGRectGetMinX(rainbowbar.frame), CGRectGetMinY(rainbowbar.frame));
    
    //rainbowbarIndicator
    //w:H = 1:1.5
    CGFloat indicatorHight = rainbowbar.frame.size.height * 2;
    rainbowbarIndicator = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, indicatorHight/1.5, indicatorHight)];
    rainbowbarIndicator.center = CGPointMake(frame.size.width/2, frame.size.height/2);
    rainbowbarIndicator.image = [UIImage imageNamed:@"overview_bar_a_indicator"];
    indicatorCenterY = frame.size.height/2;
    [self addSubview:rainbowbarIndicator];
    
    
    //ary_rainbowbarImg
    ary_rainbowbarImg = [NSMutableArray arrayWithObjects:
                         [NSString stringWithFormat:@"overview_bar_esh"],
                         [NSString stringWithFormat:@"overview_bar_jcn7"],
                         [NSString stringWithFormat:@"overview_bar_who"],
                         [NSString stringWithFormat:@"overview_bar_a_ws"],nil];
    
    
    
    //Classification(分級敘述:血壓 BMI)
    classificationLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width*0.8, frame.size.width/12)];
    classificationLabel.center = CGPointMake(frame.size.width/2,frame.size.height/7);
    classificationLabel.adjustsFontSizeToFitWidth = YES;
    classificationLabel.textAlignment = NSTextAlignmentCenter;
    classificationLabel.font = [UIFont systemFontOfSize:classificationLabel.frame.size.height/3];
    [self addSubview:classificationLabel];
    
    
    //ary_levelName_eroupe
    ary_levelName_eroupe = [NSArray arrayWithObjects:
                            @"Too Low",
                            @"Optimal",
                            @"Optimum",
                            @"Elevated",
                            @"Too High",
                            @"Dangerously\nHigh", nil];
    
    
    
    //ary_levelName_usaAndOther
    ary_levelName_usaAndOther = [NSArray arrayWithObjects:
                                 @"Optimal",
                                 @"Normal",
                                 @"High Normal",
                                 @"Grade 1\nHypertension",
                                 @"Grade 2\nHypertension",
                                 @"Grade 3\nHypertension", nil];
    
    
    //ary_bmiName
    ary_bmiName = [NSArray arrayWithObjects:
                   NSLocalizedString(@"Class III Obesity", nil),
                   NSLocalizedString(@"Class II Obesity", nil),
                   NSLocalizedString(@"Class I Obesity", nil),
                   NSLocalizedString(@"Overweight", nil),
                   NSLocalizedString(@"Normal", nil),
                   NSLocalizedString(@"Underweight", nil), nil];
    
    
    
    
    //ary_levelLabel
    ary_levelLabel = [[NSMutableArray alloc] init];
    CGFloat levelLabelWidth = rainbowbar.frame.size.width/5;
    rainbowbarUnit = rainbowbar.frame.size.width/12;
    
    CGFloat upLocation = frame.size.height/2 - levelLabelWidth/3;
    CGFloat downLocation = frame.size.height/2 + levelLabelWidth/3;
    for (int i = 0; i < 6; i++) {
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, levelLabelWidth, levelLabelWidth/2)];
        if (i%2 == 0) {
            
            label.center = CGPointMake(rainbowBarOirPoint.x + (2*i+1)*rainbowbarUnit, upLocation);
        }
        else {
            
            label.center = CGPointMake(rainbowBarOirPoint.x + (2*i+1)*rainbowbarUnit, downLocation);
        }

        label.textAlignment = NSTextAlignmentCenter;
        label.adjustsFontSizeToFitWidth = YES;
        label.font = [UIFont systemFontOfSize:label.frame.size.height/4];
        label.numberOfLines = 2;
        [self addSubview:label];
        [ary_levelLabel addObject:label];
        
    }
    
    return self;
    
}

#pragma mark - 血壓計
//==========================================================
-(void)checkRainbowbarValue:(int)countryFormat sys:(int)sys dia:(int)dia {
    
    classificationLabel.text = NSLocalizedString(@"Blood Pressure Classification", nil);
    
    //0:歐規,1:USA ,2:非歐非USA
    switch (countryFormat) {
        case 0:
            [self europeFormat:sys dia:dia];
            rainbowbar.image = [UIImage imageNamed:ary_rainbowbarImg[0]];
            break;
        case 1:
            [self usaFormat:sys dia:dia];
            rainbowbar.image = [UIImage imageNamed:ary_rainbowbarImg[1]];
            break;
        case 2:
            [self otherCountryFormat:sys dia:dia];
            rainbowbar.image = [UIImage imageNamed:ary_rainbowbarImg[2]];
            break;
        default:
            break;
    }
    
    
}

#pragma mark - 歐規
-(void)europeFormat:(int)sys dia:(int)dia {
    
    rainbowbarIndicator.hidden = NO;
    
    for (int i = 0; i < ary_levelLabel.count; i++) {
        
        ary_levelLabel[i].text = ary_levelName_eroupe[i];
    }
    
    
    if (sys >= 160 || dia >= 100) {
        //Dangerously High
        
        rainbowbarIndicator.center = CGPointMake(rainbowBarOirPoint.x + rainbowbarUnit*11, indicatorCenterY);
    }
    else if ((sys >= 135 && sys <= 159) || (dia >= 85 && dia <= 99)) {
        //Too High
        
        rainbowbarIndicator.center = CGPointMake(rainbowBarOirPoint.x + rainbowbarUnit*9, indicatorCenterY);
    }
    else if ((sys >= 130 && sys <= 134) || (dia >= 80 && dia <= 84)) {
        //Elevated
        
        rainbowbarIndicator.center = CGPointMake(rainbowBarOirPoint.x + rainbowbarUnit*7, indicatorCenterY);
    }
    else if ((sys >= 120 && sys <= 129) || (dia >= 74 && dia <= 79)) {
        //Optimum
        
        rainbowbarIndicator.center = CGPointMake(rainbowBarOirPoint.x + rainbowbarUnit*5, indicatorCenterY);
    }
    else if ((sys >= 110 && sys <= 119) || (dia >= 67 && dia <= 73)) {
        //Optimum
        
        rainbowbarIndicator.center = CGPointMake(rainbowBarOirPoint.x + rainbowbarUnit*3, indicatorCenterY);
    }
    else if (sys <= 109 && dia <= 66) {
        //Optimum
        
        rainbowbarIndicator.center = CGPointMake(rainbowBarOirPoint.x + rainbowbarUnit*1, indicatorCenterY);
    }
    else {
        rainbowbarIndicator.hidden = YES;
        NSLog(@"範圍之外");
    }
    
}

#pragma mark - USA
-(void)usaFormat:(int)sys dia:(int)dia {
    
    rainbowbarIndicator.hidden = NO;
    
    for (int i = 0; i < ary_levelLabel.count; i++) {
        
        ary_levelLabel[i].text = ary_levelName_usaAndOther[i];
    }
    
    if (sys >= 180 || dia >= 110) {
        //Grade 3 Hypertension
        
        rainbowbarIndicator.center = CGPointMake(rainbowBarOirPoint.x + rainbowbarUnit*11, indicatorCenterY);
        
    }
    else if ((sys >= 160 && sys <= 179) || (dia >= 100 && dia <= 109)) {
        //Grade 2 Hypertension
        
        rainbowbarIndicator.center = CGPointMake(rainbowBarOirPoint.x + rainbowbarUnit*9, indicatorCenterY);
    }
    else if ((sys >= 140 && sys <= 159) || (dia >= 90 && dia <= 99)) {
        //Grade 1 Hypertension
     
        rainbowbarIndicator.center = CGPointMake(rainbowBarOirPoint.x + rainbowbarUnit*7, indicatorCenterY);
    }
    else if ((sys >= 130 && sys <= 139) || (dia >= 85 && dia <= 89)) {
        //High Normal
        
        rainbowbarIndicator.center = CGPointMake(rainbowBarOirPoint.x + rainbowbarUnit*5, indicatorCenterY);
    }
    else if ((sys >= 120 && sys <= 129) || (dia >= 80 && dia <= 84)) {
        //Normal
        
        rainbowbarIndicator.center = CGPointMake(rainbowBarOirPoint.x + rainbowbarUnit*3, indicatorCenterY);
    }
    else if (sys < 120 && dia < 80) {
        //Optimal
        
        rainbowbarIndicator.center = CGPointMake(rainbowBarOirPoint.x + rainbowbarUnit*1, indicatorCenterY);
    }
    else {
        
        NSLog(@"範圍之外");
        rainbowbarIndicator.hidden = YES;
    }
    
}

#pragma mark - 非歐非USA
-(void)otherCountryFormat:(int)sys dia:(int)dia {
    
    rainbowbarIndicator.hidden = NO;
    
    for (int i = 0; i < ary_levelLabel.count; i++) {
        
        ary_levelLabel[i].text = ary_levelName_usaAndOther[i];
    }
    
    
    if (sys >= 180 || dia >= 110) {
        //Grade 3 Hypertension
        
        rainbowbarIndicator.center = CGPointMake(rainbowBarOirPoint.x + rainbowbarUnit*11, indicatorCenterY);
    }
    else if ((sys >= 160 && sys <= 179) || (dia >= 100 && dia <= 109)) {
        //Grade 2 Hypertension
    
        rainbowbarIndicator.center = CGPointMake(rainbowBarOirPoint.x + rainbowbarUnit*9, indicatorCenterY);
    }
    else if ((sys >= 140 && sys <= 159) || (dia >= 90 && dia <= 99)) {
        //Grade 1 Hypertension
        rainbowbarIndicator.center = CGPointMake(rainbowBarOirPoint.x + rainbowbarUnit*7, indicatorCenterY);
    }
    else if ((sys >= 130 && sys <= 139) || (dia >= 85 && dia <= 89)) {
        //High Normal
        rainbowbarIndicator.center = CGPointMake(rainbowBarOirPoint.x + rainbowbarUnit*5, indicatorCenterY);
    }
    else if ((sys >= 120 && sys <= 129) || (dia >= 80 && dia <= 84)) {
        //Normal
        rainbowbarIndicator.center = CGPointMake(rainbowBarOirPoint.x + rainbowbarUnit*3, indicatorCenterY);
    }
    else if (sys < 120 && dia < 80) {
        //Optimal
        rainbowbarIndicator.center = CGPointMake(rainbowBarOirPoint.x + rainbowbarUnit*1, indicatorCenterY);
    }
    else {
        
        NSLog(@"範圍之外");
        rainbowbarIndicator.hidden = YES;
    }

}

//==========================================================


#pragma mark - 體重計
-(void)checkBMIValue:(float)bmi {
    
    NSLog(@"bmi = %f",bmi);
    
    rainbowbarIndicator.hidden = NO;
    
    classificationLabel.text = NSLocalizedString(@"BMI   Classification", nil);
    
    rainbowbar.image = [UIImage imageNamed:ary_rainbowbarImg[2]];
    
    for (int i = 0; i < ary_levelLabel.count; i++) {
        
        ary_levelLabel[i].text = ary_bmiName[i];
    }

    
    if (bmi < 18.5) {
        
        rainbowbarIndicator.center = CGPointMake(rainbowBarOirPoint.x + rainbowbarUnit*1, indicatorCenterY);
    }
    else if (bmi >= 18.5 && bmi <= 24.99) {
        
        rainbowbarIndicator.center = CGPointMake(rainbowBarOirPoint.x + rainbowbarUnit*3, indicatorCenterY);
        
    }
    else if (bmi >= 25.0 && bmi <= 29.99) {
        
        rainbowbarIndicator.center = CGPointMake(rainbowBarOirPoint.x + rainbowbarUnit*5, indicatorCenterY);
    }
    else if (bmi >= 30.0 && bmi <= 34.99) {
        
        rainbowbarIndicator.center = CGPointMake(rainbowBarOirPoint.x + rainbowbarUnit*7, indicatorCenterY);
    }
    else if (bmi >= 35.0 && bmi <= 39.9) {
        
        rainbowbarIndicator.center = CGPointMake(rainbowBarOirPoint.x + rainbowbarUnit*9, indicatorCenterY);
    }
    else if (bmi >= 40.0) {
        
        rainbowbarIndicator.center = CGPointMake(rainbowBarOirPoint.x + rainbowbarUnit*11, indicatorCenterY);
    }
    else {
        rainbowbarIndicator.hidden = YES;
        NSLog(@"範圍之外");
    }
    
}


@end
