//
//  OverViewTempAddView.h
//  Microlife
//
//  Created by 曾偉亮 on 2016/10/14.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainOverviewViewController;

@interface OverViewTempAddView : UIView

@property (strong, nonatomic) MainOverviewViewController *m_superVC;

-(id)initWithTempAddViewFrame:(CGRect)frame;

@end
