//
//  AlertView.h
//  Microlife
//
//  Created by 曾偉亮 on 2017/7/17.
//  Copyright © 2017年 Rex. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MicroLifeAlertViewDelegate <NSObject>
-(void)confirmAction;
@end



@interface AlertView : UIView

@property (nonatomic) id<MicroLifeAlertViewDelegate>delegate;

-(id)initWithMicroLifeAlertViewFrame:(CGRect)frame withTitle:(NSString *)title;

@end
