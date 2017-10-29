//
//  WEIPickerView.h
//  Microlife
//
//  Created by 曾偉亮 on 2016/10/7.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WEIPickerView : UIView <UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) UIPickerView *m_pickerView;

@property (nonatomic) CGFloat weightValue;
@property (strong,nonatomic)NSString *weightUnit;

-(id)initWithWeiPickerView:(CGRect)frame;

@end
