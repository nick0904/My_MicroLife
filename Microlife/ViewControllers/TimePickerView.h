//
//  TimePickerView.h
//  Microlife
//
//  Created by 曾偉亮 on 2016/9/11.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimePickerView : UIView

@property (strong, nonatomic) UIDatePicker *m_pickerView;

-(id)initWithTimePickerViewFrame:(CGRect)frame;

@end
