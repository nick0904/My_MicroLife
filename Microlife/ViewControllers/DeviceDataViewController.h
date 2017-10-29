//
//  DeviceDataViewController.h
//  Microlife
//
//  Created by WiFi@MBP on 2017/6/8.
//  Copyright © 2017年 Rex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeviceDataViewController : UIViewController <UIScrollViewDelegate> {
    UIButton *titleBtn;
    NSString *page1Title;
    NSString *page2Title;
    NSString *page1ImageName;
    NSString *page2ImageName;
    NSString *page1Content;
    NSString *page2Content;
}

@property (nonatomic, assign) NSInteger     showContentType;

@property (nonatomic, retain) UIScrollView  *contentView;
@property (nonatomic, retain) UIScrollView  *page1View;
@property (nonatomic, retain) UIScrollView  *page2View;
@property (nonatomic, retain) UIPageControl *pageControl;
@end
