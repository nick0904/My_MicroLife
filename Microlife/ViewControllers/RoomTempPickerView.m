//
//  RoomTempPickerView.m
//  Microlife
//
//  Created by 曾偉亮 on 2016/10/7.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import "RoomTempPickerView.h"

@implementation RoomTempPickerView {
    
    NSMutableArray *ary_roomTempData;
}

@synthesize m_pickerView;

-(id)initWithRoomTempPickerView:(CGRect)frame {
    
    self = [super init];
    
    if (!self) return nil;
    
    self.backgroundColor = [UIColor whiteColor];
    
    //m_pickerView
    m_pickerView = [[UIPickerView alloc] initWithFrame:frame];
    
    m_pickerView.backgroundColor = [UIColor whiteColor];
    
    m_pickerView.delegate = self;
    
    m_pickerView.dataSource = self;
    
    m_pickerView.showsSelectionIndicator = YES;
    
    
    //ary_temp
    NSMutableArray *ary_temp = [[NSMutableArray alloc] init];
    for (int tempInt = 15; tempInt <= 40; tempInt++) {
        
        [ary_temp addObject:[NSString stringWithFormat:@"%d",tempInt]];
        
    }
    
    //ary_unit
    NSArray *ary_unit =[NSArray arrayWithObjects:@"℃",nil];
    //[NSArray arrayWithObjects:@"℃",@"℉" ,nil];
    
    //ary_roomTempData
    ary_roomTempData = [NSMutableArray arrayWithObjects:
                        [NSArray arrayWithObjects:@" ", nil],
                        ary_temp,
                        ary_unit, nil];
    
    self.rtempValue=15;
    self.rtempUnit=ary_unit[0];
    
    
    return self;
}

#pragma mark - UIPickerViewDataSource & UIPickerViewDelegate
//----------------------------------------------------------
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return ary_roomTempData.count;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    NSArray *ary = [[NSArray alloc] initWithArray:ary_roomTempData[component]];
    NSInteger count = ary.count;
    
    return count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    NSArray *ary = [[NSArray alloc] initWithArray:ary_roomTempData[component]];
    NSString *title = [NSString stringWithFormat:@"%@",ary[row]];
    
    return title;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"%d,%d",row,component);
    
    if(component==1)
    {
        NSMutableArray *ary=ary_roomTempData[component];
        NSString *rtValue=ary[row];
        self.rtempValue=rtValue.floatValue;
    }
    
    if(component==2)
    {
        NSMutableArray *ary=ary_roomTempData[component];
        NSString *unitValue=ary[row];
        
        NSLog(@"unit:%@",unitValue);
        
        self.rtempUnit=unitValue;
    }
}


@end
