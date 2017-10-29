//
//  BodyTempPickerView.h
//  Microlife
//
//  Created by 曾偉亮 on 2016/10/12.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BodyTempPickerView : UIView <UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) UIPickerView *m_pickerView;

@property (nonatomic) CGFloat btempValue;
@property (strong,nonatomic)NSString *btempUnit;

-(id)initWithBodyTempPickerView:(CGRect)frame;

@end
