//
//  PULPickerView.m
//  Microlife
//
//  Created by 曾偉亮 on 2016/9/10.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import "PULPickerView.h"

@implementation PULPickerView {
    
    NSMutableArray *ary_pulData;
}

@synthesize m_pickerView;

-(id)initWithpulPIckerView:(CGRect)frame {
    
    self = [super init];
    
    if (!self) return nil;
    
    self.backgroundColor = [UIColor whiteColor];
    
    //m_pickerView
    m_pickerView = [[UIPickerView alloc] initWithFrame:frame];
    
    m_pickerView.backgroundColor = [UIColor whiteColor];
    
    m_pickerView.delegate = self;
    
    m_pickerView.dataSource = self;
    
    m_pickerView.showsSelectionIndicator = YES;
    
    //ary_pul
    NSMutableArray *ary_pul = [[NSMutableArray alloc] init];
    for (int pulInt = 40; pulInt <= 200; pulInt++) {
        
        [ary_pul addObject:[NSString stringWithFormat:@"%d",pulInt]];
    }
    
    //ary_unit
    NSArray *ary_unit = [NSArray arrayWithObjects:@"bpm", nil];
    
    //ary_pulData
    ary_pulData = [NSMutableArray arrayWithObjects:
                    [NSArray arrayWithObjects:@" ", nil],
                    ary_pul,
                    ary_unit,nil];
    
    self.bpPul=40;
    self.bpPulUnit=ary_unit[0];
    
    return self;
}


#pragma mark - UIPickerViewDataSource & UIPickerViewDelegate
//----------------------------------------------------------
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return ary_pulData.count;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    NSArray *ary = [[NSArray alloc] initWithArray:ary_pulData[component]];
    NSInteger count = ary.count;
    
    return count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    NSArray *ary = [[NSArray alloc] initWithArray:ary_pulData[component]];
    NSString *title = [NSString stringWithFormat:@"%@",ary[row]];
    
    return title;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(component==1)
    {
        NSMutableArray *ary=ary_pulData[component];
        NSString *pulValue=ary[row];
        self.bpPul=pulValue.intValue;
    }
    
    if(component==2)
    {
        NSMutableArray *ary=ary_pulData[component];
        NSString *unitValue=ary[row];
        self.bpPulUnit=unitValue;
    }
    
    
}


@end
