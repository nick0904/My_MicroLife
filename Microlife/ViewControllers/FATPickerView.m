//
//  FATPickerView.m
//  Microlife
//
//  Created by 曾偉亮 on 2016/10/7.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import "FATPickerView.h"

@implementation FATPickerView {
    
    
    NSMutableArray *ary_fatData;
}

@synthesize m_pickerView;

-(id)initWithFATPickerView:(CGRect)frame {
    
    self = [super init];
    
    if (!self) return nil;
    
    self.backgroundColor = [UIColor whiteColor];
    
    //m_pickerView
    m_pickerView = [[UIPickerView alloc] initWithFrame:frame];
    
    m_pickerView.backgroundColor = [UIColor whiteColor];
    
    m_pickerView.delegate = self;
    
    m_pickerView.dataSource = self;
    
    m_pickerView.showsSelectionIndicator = YES;
    
    
    //ary_fat
    NSMutableArray *ary_fat = [[NSMutableArray alloc]init];
    float fatPlus = 0.1;
    for (float fatFloat = 5.0; fatFloat <= 60.0; fatPlus++) {
        
        [ary_fat addObject:[NSString stringWithFormat:@"%.1f",fatFloat]];
        
        fatFloat += 0.1;
    }
    
    //ary_fatData
    ary_fatData = [NSMutableArray arrayWithObjects:
                   [NSArray arrayWithObjects:@" ", nil],
                   ary_fat,
                   [NSArray arrayWithObjects:@"%" ,nil],nil];
    
    self.fatValue=5.0;
    self.fatUnit=@"%";
    
    return self;
    
}


#pragma mark - UIPickerViewDataSource & UIPickerViewDelegate
//----------------------------------------------------------
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return ary_fatData.count;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    NSArray *ary = [[NSArray alloc] initWithArray:ary_fatData[component]];
    NSInteger count = ary.count;
    
    return count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    NSArray *ary = [[NSArray alloc] initWithArray:ary_fatData[component]];
    NSString *title = [NSString stringWithFormat:@"%@",ary[row]];
    
    return title;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"%d,%d",row,component);
    
    if(component==1)
    {
        NSMutableArray *ary=ary_fatData[component];
        NSString *fValue=ary[row];
        self.fatValue=fValue.floatValue;
    }
    
    if(component==2)
    {
        NSMutableArray *ary=ary_fatData[component];
        NSString *unitValue=ary[row];
        
        NSLog(@"unit:%@",unitValue);
        
        self.fatUnit=unitValue;
    }
}

@end
