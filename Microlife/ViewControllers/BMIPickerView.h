//
//  BMIPickerView.h
//  Microlife
//
//  Created by 曾偉亮 on 2016/10/7.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BMIPickerView : UIView <UIPickerViewDataSource,UIPickerViewDelegate>


@property (strong, nonatomic) UIPickerView *m_pickerView;

@property (nonatomic) CGFloat bmiValue;

-(id)initWithBMIPickerView:(CGRect)frame;

@end
