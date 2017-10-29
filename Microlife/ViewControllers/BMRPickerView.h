//
//  BMRPickerView.h
//  Microlife
//
//  Created by 曾偉亮 on 2016/10/13.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BMRPickerView : UIView <UIPickerViewDelegate,UIPickerViewDataSource>

@property (strong, nonatomic) UIPickerView *m_pickerView;

@property (nonatomic) CGFloat bmrValue;
@property (strong,nonatomic)NSString *bmrUnit;

-(id)initWithBMRPickerView:(CGRect)frame;

@end
