//
//  AgePickerView.m
//  Microlife
//
//  Created by 曾偉亮 on 2016/10/13.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import "AgePickerView.h"

@implementation AgePickerView {
    
    NSMutableArray *ary_ageData;
}

-(id)initWithAgePickerView:(CGRect)frame {
    
    self = [super init];
    
    if (!self) return nil;
    
    self.backgroundColor = [UIColor whiteColor];
    
    
    //ary_age
    NSMutableArray *ary_age = [[NSMutableArray alloc] init];
    for (int i = 10; i <= 99; i++) {
        
        [ary_age addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    
    //ary_ageData
    ary_ageData = [NSMutableArray arrayWithObjects:
                   [NSArray arrayWithObjects:@" ",nil],
                   ary_age,
                   [NSArray arrayWithObjects:@" ",nil],nil];
    
    self.ageValue=10;
    
    return self;
}

#pragma mark - UIPickerViewDataSource & UIPickerViewDelegate
//----------------------------------------------------------
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return ary_ageData.count;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    NSArray *ary = [[NSArray alloc] initWithArray:ary_ageData[component]];
    NSInteger count = ary.count;
    
    return count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    NSArray *ary = [[NSArray alloc] initWithArray:ary_ageData[component]];
    NSString *title = [NSString stringWithFormat:@"%@",ary[row]];
    
    return title;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"%d,%d",row,component);
    
    if(component==1)
    {
        NSMutableArray *ary=ary_ageData[component];
        NSString *aValue=ary[row];
        self.ageValue=aValue.floatValue;
    }
    
}

@end
