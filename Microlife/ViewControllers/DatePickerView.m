//
//  DatePickerView.m
//  Microlife
//
//  Created by 曾偉亮 on 2016/9/11.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import "DatePickerView.h"

@implementation DatePickerView

@synthesize m_pickerView;

-(id)initWithDatePickerViewFrame:(CGRect)frame {
    
    self = [super init];
    
    if (!self) return nil;
    
    self.backgroundColor = [UIColor  whiteColor];
    
    //m_pickerView
    m_pickerView = [[UIDatePicker alloc] initWithFrame:frame];
    
    m_pickerView.datePickerMode = UIDatePickerModeDate;
    
    m_pickerView.backgroundColor = [UIColor whiteColor];
    
    
    
    return self;
    
}

@end
