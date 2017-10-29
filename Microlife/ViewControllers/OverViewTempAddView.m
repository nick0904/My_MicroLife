//
//  OverViewTempAddView.m
//  Microlife
//
//  Created by 曾偉亮 on 2016/10/14.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import "OverViewTempAddView.h"
#import "MainOverviewViewController.h"
#import "OverViewAddEventControllerViewController.h"

@implementation OverViewTempAddView {
    
    OverViewAddEventControllerViewController *addEventVC;
}

@synthesize m_superVC;

-(id)initWithTempAddViewFrame:(CGRect)frame {
    
    self = [super init];
    
    if (!self) return nil;
    
    self.frame = frame;
    
    CGFloat unitHeight = frame.size.height/8;
    
    self.backgroundColor = [UIColor whiteColor];
    
    //tempImgView (底圖 w:H = 1:2.5)
    UIImageView *tempImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,3*unitHeight/2.5 ,3*unitHeight)];
    
    tempImgView.center = CGPointMake(frame.size.width/2, unitHeight + tempImgView.frame.size.height/2);
    
    tempImgView.image = [UIImage imageNamed:@"overview_pic_a_ncfr"];
    
    [self addSubview:tempImgView];
    
    
    //content
    UILabel *contentLabe = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, unitHeight*2)];
    
    contentLabe.center = CGPointMake(frame.size.width/2, CGRectGetMaxY(tempImgView.frame) + contentLabe.frame.size.height/2);
    
    contentLabe.numberOfLines = 4;
    
    //調整行距
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 10;//行距
    style.alignment = NSTextAlignmentCenter;
    
    NSString *informationText = NSLocalizedString(@"Do you want to monitor your fever event?\nJust tap Add button,you can easily\nmanage your all measured\ndatas in this app", nil);
    
    NSMutableAttributedString *textStr = [[NSMutableAttributedString alloc] initWithString:informationText];
    
    [textStr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, textStr.length)];
    
    contentLabe.textColor = [UIColor darkGrayColor];
    
    contentLabe.attributedText = textStr;
    
    [self addSubview:contentLabe];
    

    
    
    //addBt (底圖 w:H = 1:1)
    UIButton *addBt = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, unitHeight*1.25, unitHeight*1.25)];
    
    addBt.center = CGPointMake(frame.size.width/2, CGRectGetMaxY(contentLabe.frame) + addBt.frame.size.height/2);
    
    [addBt setImage:[UIImage imageNamed:@"overview_btn_a_add_s"] forState:UIControlStateNormal];
    
    [addBt addTarget:self action:@selector(pushToAddEventVC) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:addBt];
    
    
    return self;
}


#pragma mark - 連結到 add Event 頁面
-(void)pushToAddEventVC {
    
    if (m_superVC != nil) {
        
        if (addEventVC == nil) {
            
            addEventVC = [[OverViewAddEventControllerViewController alloc] initWithAddEventViewController:m_superVC.view.frame];
        }
        
        addEventVC.m_superVC = m_superVC;
        [m_superVC.navigationController pushViewController:addEventVC animated:YES];
        
    }
    
}

@end
