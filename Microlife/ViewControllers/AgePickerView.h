//
//  AgePickerView.h
//  Microlife
//
//  Created by 曾偉亮 on 2016/10/13.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AgePickerView : UIView <UIPickerViewDelegate,UIPickerViewDataSource>

@property (strong, nonatomic) UIPickerView *m_pickerView;

@property (nonatomic) int ageValue;

-(id)initWithAgePickerView:(CGRect)frame;

@end
