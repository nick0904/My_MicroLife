//
//  PULPickerView.h
//  Microlife
//
//  Created by 曾偉亮 on 2016/9/10.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PULPickerView : UIView <UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) UIPickerView *m_pickerView;
@property (nonatomic) int bpPul;
@property (strong,nonatomic) NSString *bpPulUnit;

-(id)initWithpulPIckerView:(CGRect)frame;

@end
