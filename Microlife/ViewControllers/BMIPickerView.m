//
//  BMIPickerView.m
//  Microlife
//
//  Created by 曾偉亮 on 2016/10/7.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import "BMIPickerView.h"

@implementation BMIPickerView {
    
    NSMutableArray *ary_bmiData;
}

@synthesize m_pickerView;

-(id)initWithBMIPickerView:(CGRect)frame {
    
    self = [super init];
    
    if (!self) return nil;
    
    self.backgroundColor = [UIColor whiteColor];
    
    //m_pickerView
    m_pickerView = [[UIPickerView alloc] initWithFrame:frame];
    
    m_pickerView.backgroundColor = [UIColor whiteColor];
    
    m_pickerView.delegate = self;
    
    m_pickerView.dataSource = self;
    
    m_pickerView.showsSelectionIndicator = YES;
    

    //ary_bmi
    NSMutableArray *ary_bmi = [[NSMutableArray alloc] init];
    float bmiPlus = 0.1;
    for (float bmiFloat = 10.0; bmiFloat <= 90.0; bmiPlus++) {
        
        [ary_bmi addObject:[NSString stringWithFormat:@"%.1f",bmiFloat]];
        bmiFloat += 0.1;
        
    }
    
    //ary_bmiData
    ary_bmiData = [NSMutableArray arrayWithObjects:
                    [NSArray arrayWithObjects:@" ", nil],
                    ary_bmi,
                    [NSArray arrayWithObjects:@" ", nil], nil];
    
    self.bmiValue=10.0;
    
    
    return self;
}


#pragma mark - UIPickerViewDataSource & UIPickerViewDelegate
//----------------------------------------------------------
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return ary_bmiData.count;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    NSArray *ary = [[NSArray alloc] initWithArray:ary_bmiData[component]];
    NSInteger count = ary.count;
    
    return count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    NSArray *ary = [[NSArray alloc] initWithArray:ary_bmiData[component]];
    NSString *title = [NSString stringWithFormat:@"%@",ary[row]];
        
    return title;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"%d,%d",row,component);
    
    if(component==1)
    {
        NSMutableArray *ary=ary_bmiData[component];
        NSString *bValue=ary[row];
        self.bmiValue=bValue.floatValue;
    }
    
}


@end
