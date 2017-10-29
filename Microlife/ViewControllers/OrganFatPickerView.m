//
//  OrganFatPickerView.m
//  Microlife
//
//  Created by 曾偉亮 on 2016/10/13.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import "OrganFatPickerView.h"

@implementation OrganFatPickerView {
    
    NSMutableArray *ary_OrganFatData;
}

-(id)initWithOrganFatPickerView:(CGRect)frame {
    
    
    self = [super init];
    
    if (!self) return nil;
    
    self.backgroundColor = [UIColor whiteColor];
    
    //ary_OrganFat
    NSMutableArray *ary_OrganFat = [[NSMutableArray alloc] init];
    for (int i = 1; i <= 50; i++) {
        
        [ary_OrganFat addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    //ary_OrganFatData
    ary_OrganFatData = [NSMutableArray arrayWithObjects:
                        [NSArray arrayWithObjects:@" ", nil],
                        ary_OrganFat,
                        [NSArray arrayWithObjects:@" ", nil],nil];
    
    self.ofatValue=1;
    
    return self;
}


#pragma mark - UIPickerViewDataSource & UIPickerViewDelegate
//----------------------------------------------------------
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return ary_OrganFatData.count;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    NSArray *ary = [[NSArray alloc] initWithArray:ary_OrganFatData[component]];
    NSInteger count = ary.count;
    
    return count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    NSArray *ary = [[NSArray alloc] initWithArray:ary_OrganFatData[component]];
    NSString *title = [NSString stringWithFormat:@"%@",ary[row]];
    
    return title;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"%d,%d",row,component);
    
    if(component==1)
    {
        NSMutableArray *ary=ary_OrganFatData[component];
        NSString *fValue=ary[row];
        self.ofatValue=fValue.floatValue;
    }
    
}

@end
