//
//  AlertView.m
//  Microlife
//
//  Created by 曾偉亮 on 2017/7/17.
//  Copyright © 2017年 Rex. All rights reserved.
//

#import "AlertView.h"

@implementation AlertView

-(id)initWithMicroLifeAlertViewFrame:(CGRect)frame withTitle:(NSString *)title{
    
    self = [super init];
    
    if(!self) return nil;
    
    self.frame = frame;
    
    self.backgroundColor = [UIColor lightGrayColor];
    
    [self showAlertView:title];
    
    return self;
}


#pragma mark - Private Function
-(void)showAlertView:(NSString *)title{
 
    CGFloat base_Width = self.frame.size.width;
    CGFloat base_Height = self.frame.size.height;
    
    //title
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, base_Width*0.75, base_Height/4)];
    titleLabel.center = CGPointMake(base_Width/2, base_Height/2);
    titleLabel.text = title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor whiteColor];
    [self addSubview:titleLabel];
    
    //btn
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(titleLabel.frame), CGRectGetMaxY(titleLabel.frame)+1, titleLabel.frame.size.width, titleLabel.frame.size.height/2)];
    [btn setTitle:NSLocalizedString(@"Confirm", nil) forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor whiteColor]];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(confirmBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
}

-(void)confirmBtnAction{
    [self.delegate confirmAction];
}

@end
