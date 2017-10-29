//
//  WEIPickerView.m
//  Microlife
//
//  Created by 曾偉亮 on 2016/10/7.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import "WEIPickerView.h"

@implementation WEIPickerView {
    
    NSMutableArray *ary_weiData;
}

@synthesize m_pickerView;

-(id)initWithWeiPickerView:(CGRect)frame {
    
    self = [super init];
    
    if (!self) return nil;
    
    self.backgroundColor = [UIColor whiteColor];
    
    //m_pickerView
    m_pickerView = [[UIPickerView alloc] initWithFrame:frame];
    
    m_pickerView.backgroundColor = [UIColor whiteColor];
    
    m_pickerView.delegate = self;
    
    m_pickerView.dataSource = self;
    
    m_pickerView.showsSelectionIndicator = YES;
    
    
    //ary_wei
    NSMutableArray *ary_wei = [[NSMutableArray alloc] init];
    
    float weightPlus = 0.1;
    for (float weiFloat = 5.0; weiFloat <= 150.0; weightPlus++) {
        
        [ary_wei addObject:[NSString stringWithFormat:@"%.1f",weiFloat]];
        
        weiFloat += 0.1;
    }
    
    //ary_unit
    NSArray *ary_unit =[NSArray arrayWithObjects:@"kg", nil];
    //[NSArray arrayWithObjects:@"kg",@"lb", nil];
    
    //ary_weiData
    ary_weiData = [NSMutableArray arrayWithObjects:[NSArray arrayWithObjects:@" ",nil],
                                                    ary_wei,
                                                    ary_unit,nil];
    
    self.weightValue=5.0;
    self.weightUnit=ary_unit[0];
    
    return self;
}


#pragma mark - UIPickerViewDataSource & UIPickerViewDelegate
//----------------------------------------------------------
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return ary_weiData.count;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    NSArray *ary = [[NSArray alloc] initWithArray:ary_weiData[component]];
    NSInteger count = ary.count;
    
    return count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    NSArray *ary = [[NSArray alloc] initWithArray:ary_weiData[component]];
    NSString *title = [NSString stringWithFormat:@"%@",ary[row]];
    
    return title;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"%d,%d",row,component);
    
    if(component==1)
    {
        NSMutableArray *ary=ary_weiData[component];
        NSString *wValue=ary[row];
        self.weightValue=wValue.floatValue;
    }
    
    if(component==2)
    {
        NSMutableArray *ary=ary_weiData[component];
        NSString *unitValue=ary[row];
        
        NSLog(@"unit:%@",unitValue);
        
        self.weightUnit=unitValue;
    }
}

@end
