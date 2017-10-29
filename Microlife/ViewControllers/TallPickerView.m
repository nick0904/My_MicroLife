//
//  TallPickerView.m
//  Microlife
//
//  Created by 曾偉亮 on 2016/10/13.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import "TallPickerView.h"

@implementation TallPickerView {
    
    NSMutableArray *ary_tallData;
}

-(id)initWithTallPickerView:(CGRect)frame {
    
    self = [super init];
    
    if (!self) return nil;
    
    self.backgroundColor = [UIColor whiteColor];

    
    //ary_tall
    NSMutableArray *ary_tall = [[NSMutableArray alloc] init];
    for (int i = 100; i <= 220; i++) {
        
        [ary_tall addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    //ary_unit
    NSArray *ary_unit =[NSArray arrayWithObjects:@"cm", nil];
    //[NSArray arrayWithObjects:@"cm",@"ft", nil];
    
    //ary_tallData
    ary_tallData = [NSMutableArray arrayWithObjects:
                    [NSArray arrayWithObjects:@" ",nil],
                    ary_tall,
                    ary_unit,nil];
    
    
    return self;
}


#pragma mark - UIPickerViewDataSource & UIPickerViewDelegate
//----------------------------------------------------------
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return ary_tallData.count;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    NSArray *ary = [[NSArray alloc] initWithArray:ary_tallData[component]];
    NSInteger count = ary.count;
    
    return count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    NSArray *ary = [[NSArray alloc] initWithArray:ary_tallData[component]];
    NSString *title = [NSString stringWithFormat:@"%@",ary[row]];
    
    return title;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"%d,%d",row,component);
    
    if(component==1)
    {
        NSMutableArray *ary=ary_tallData[component];
        NSString *tValue=ary[row];
        self.tallValue=tValue.floatValue;
    }
    
    if(component==2)
    {
        NSMutableArray *ary=ary_tallData[component];
        NSString *unitValue=ary[row];
        
        NSLog(@"unit:%@",unitValue);
        
        self.tallUnit=unitValue;
    }
}



@end
