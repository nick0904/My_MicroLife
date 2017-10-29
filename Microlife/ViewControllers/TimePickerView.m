//
//  TimePickerView.m
//  Microlife
//
//  Created by 曾偉亮 on 2016/9/11.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import "TimePickerView.h"

@implementation TimePickerView

@synthesize m_pickerView;

-(id)initWithTimePickerViewFrame:(CGRect)frame {
    
    self = [super init];
    
    if(!self) return nil;
    
    self.backgroundColor = [UIColor whiteColor];
    
    //m_pickerView
    m_pickerView = [[UIDatePicker alloc] initWithFrame:frame];
    
    m_pickerView.datePickerMode = UIDatePickerModeTime;
    
    m_pickerView.backgroundColor = [UIColor whiteColor];
    
    return self;
}

@end
