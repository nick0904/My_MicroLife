//
//  BloodPressurePickerView.h
//  Microlife
//
//  Created by 曾偉亮 on 2016/9/10.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BloodPressurePickerView : UIView <UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) UIPickerView *m_pickerView;

@property (nonatomic) int bpSys;
@property (nonatomic) int bpDia;
@property (strong,nonatomic) NSString *bpUnit;

-(id)initWithbloodPressurePickerViewFrame:(CGRect)frame;

@end
