//
//  RoomTempPickerView.h
//  Microlife
//
//  Created by 曾偉亮 on 2016/10/7.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoomTempPickerView : UIView <UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) UIPickerView *m_pickerView;

@property (nonatomic) CGFloat rtempValue;
@property (strong,nonatomic)NSString *rtempUnit;

-(id)initWithRoomTempPickerView:(CGRect)frame;

@end
