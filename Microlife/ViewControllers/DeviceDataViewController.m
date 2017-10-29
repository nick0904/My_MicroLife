//
//  DeviceDataViewController.m
//  Microlife
//
//  Created by WiFi@MBP on 2017/6/8.
//  Copyright © 2017年 Rex. All rights reserved.
//

#import "DeviceDataViewController.h"

@interface DeviceDataViewController ()

@end

@implementation DeviceDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"showContentType:%ld",(long)self.showContentType);
    
    [self initWithObject];
    
    [self setShowContent];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setShowContent {
    [self.view addSubview:self.contentView];
    [self.view addSubview:self.pageControl];
    switch (self.showContentType) {
        case 0:
            page1Title = NSLocalizedString(@"Take Measurement & Upload Data", nil);
            page2Title = NSLocalizedString(@"Upload Memory Data", nil);
            page1ImageName = @"description_img_a_sphygmomanometer_0";
            page2ImageName = @"description_img_a_sphygmomanometer_1";
            page1Content = NSLocalizedString(@"A6 BT - Page 1 Content", nil);
            page2Content = NSLocalizedString(@"A6 BT - Page 2 Content", nil);
            self.pageControl.numberOfPages = 2;
            self.contentView.contentSize = CGSizeMake(CGRectGetWidth(self.contentView.frame)*2, CGRectGetHeight(self.contentView.frame));
            [self.contentView addSubview:self.page1View];
            [self.contentView addSubview:self.page2View];
            break;
        case 1:
            
            /**
            page1Title = NSLocalizedString(@"Take Measurement & Upload Data", nil);
            page1ImageName = @"description_img_a_weightmeter_0";
            page1Content = NSLocalizedString(@"NC150 BT - Page 1 Content", nil);
            self.pageControl.numberOfPages = 1;
            self.contentView.contentSize = self.contentView.frame.size;
            [self.contentView addSubview:self.page1View];
*/
#warning Test
//-----------------------------------------------
            
            page1Title = NSLocalizedString(@"Take Measurement & Upload Data", nil);
            page2Title = NSLocalizedString(@"Upload Memory Data", nil);
            page1ImageName = @"description_img_a_thermometer_0";
            page2ImageName = @"description_img_a_thermometer_1";
            page1Content = NSLocalizedString(@"BFS800 - Page 1 Content", nil);
            page2Content = NSLocalizedString(@"BFS800 - Page 2 Content", nil);
            self.pageControl.numberOfPages = 2;
            self.contentView.contentSize = CGSizeMake(CGRectGetWidth(self.contentView.frame)*2, CGRectGetHeight(self.contentView.frame));
            [self.contentView addSubview:self.page1View];
            [self.contentView addSubview:self.page2View];
            
            break;
        case 2:
            /**
            page1Title = NSLocalizedString(@"Take Measurement & Upload Data", nil);
            page2Title = NSLocalizedString(@"Upload Memory Data", nil);
            page1ImageName = @"description_img_a_thermometer_0";
            page2ImageName = @"description_img_a_thermometer_1";
            page1Content = NSLocalizedString(@"BFS800 - Page 1 Content", nil);
            page2Content = NSLocalizedString(@"BFS800 - Page 2 Content", nil);
            self.pageControl.numberOfPages = 2;
            self.contentView.contentSize = CGSizeMake(CGRectGetWidth(self.contentView.frame)*2, CGRectGetHeight(self.contentView.frame));
            [self.contentView addSubview:self.page1View];
            [self.contentView addSubview:self.page2View];
*/

#warning Test
            //----------------------------------------------
            
            page1Title = NSLocalizedString(@"Take Measurement & Upload Data", nil);
            page1ImageName = @"description_img_a_weightmeter_0";
            page1Content = NSLocalizedString(@"NC150 BT - Page 1 Content", nil);
            self.pageControl.numberOfPages = 1;
            self.contentView.contentSize = self.contentView.frame.size;
            [self.contentView addSubview:self.page1View];
            
            
            break;
        default:
            break;
    }
}

-(void)initWithObject {
    
    titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    titleBtn.frame = CGRectMake(0 , 0, self.view.frame.size.width, self.view.frame.size.height*0.09);
    titleBtn.backgroundColor = [UIColor colorWithRed:0/255.0 green:61.0/255.0 blue:165.0/255.0 alpha:1];
    [titleBtn setTitle:self.title forState:UIControlStateNormal];
    titleBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [titleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    titleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [titleBtn setTitleEdgeInsets:UIEdgeInsetsMake(self.view.frame.size.height*0.01, 0, -self.view.frame.size.height*0.01, 0)];
    [titleBtn addTarget:self action:@selector(goback3Click) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:titleBtn];
    
    UIButton *gobackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    gobackBtn.frame = CGRectMake(0, self.view.frame.size.height*0.026, self.view.frame.size.height*0.05, self.view.frame.size.height*0.05);
    [gobackBtn setImage:[UIImage imageNamed:@"all_btn_a_back"] forState:UIControlStateNormal];
    [gobackBtn addTarget:self action:@selector(goback3Click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:gobackBtn];
    
    
}

-(void)goback3Click{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

- (UIScrollView *)contentView {
    if (!_contentView) {
        self.contentView = [[UIScrollView alloc]initWithFrame:CGRectMake(CGRectGetMinX(titleBtn.frame), CGRectGetMaxY(titleBtn.frame), self.view.frame.size.width, self.view.frame.size.height - CGRectGetHeight(titleBtn.frame))];
        self.contentView.delegate = self;
        self.contentView.bounces = NO;
        self.contentView.pagingEnabled = YES;
        self.contentView.showsHorizontalScrollIndicator = NO;
        self.contentView.backgroundColor = [UIColor whiteColor];
        
    }
    return _contentView;
}

- (UIPageControl *)pageControl {
    if (!_pageControl) {
        self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, 0, 100, 50)];
        self.pageControl.center = CGPointMake(self.contentView.center.x, CGRectGetMaxY(self.contentView.frame)-25);
        self.pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        self.pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:0/255.0 green:61.0/255.0 blue:165.0/255.0 alpha:1];
    }
    return _pageControl;
}

- (UIScrollView *)page1View {
    if (!_page1View) {
        self.page1View = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.contentView.frame), CGRectGetHeight(self.contentView.frame)-50)];
        self.page1View.backgroundColor = [UIColor whiteColor];
        self.page1View.showsVerticalScrollIndicator = NO;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(50, 10, CGRectGetWidth(self.contentView.frame)-100, 50)];
        label.text = page1Title;
        label.textColor = [UIColor colorWithRed:0/255.0 green:61.0/255.0 blue:165.0/255.0 alpha:1];
        label.font = [UIFont systemFontOfSize:30];
        label.textAlignment = UITextAlignmentCenter;
        label.numberOfLines = 2;
        [label sizeToFit];
        label.center = CGPointMake(self.page1View.center.x, label.center.y);
        [self.page1View addSubview:label];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(50, CGRectGetMaxY(label.frame)+10, CGRectGetWidth(self.page1View.frame)-100, CGRectGetWidth(self.page1View.frame)-100)];
        imageView.image = [UIImage imageNamed:page1ImageName];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.page1View addSubview:imageView];
        UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(50, CGRectGetMaxY(imageView.frame)+10, CGRectGetWidth(self.page1View.frame)-100, CGRectGetWidth(self.page1View.frame)-100)];
        textView.text = page1Content;
        textView.font = [UIFont systemFontOfSize:20];
        textView.editable = NO;
        [textView sizeToFit];
        textView.center = CGPointMake(self.page1View.center.x, textView.center.y);
        textView.scrollEnabled = NO;
        [self.page1View addSubview:textView];
        self.page1View.contentSize = CGSizeMake(CGRectGetWidth(self.page1View.frame), CGRectGetMaxY(textView.frame));
    }
    return _page1View;
}

- (UIScrollView *)page2View {
    if (!_page2View) {
        self.page2View = [[UIScrollView alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.contentView.frame), 0, CGRectGetWidth(self.contentView.frame), CGRectGetHeight(self.contentView.frame)-50)];
        self.page2View.backgroundColor = [UIColor whiteColor];
        self.page2View.showsVerticalScrollIndicator = NO;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(50, 10, CGRectGetWidth(self.contentView.frame)-100, 50)];
        label.text = page2Title;
        label.textColor = [UIColor colorWithRed:0/255.0 green:61.0/255.0 blue:165.0/255.0 alpha:1];
        label.font = [UIFont systemFontOfSize:30];
        label.textAlignment = UITextAlignmentCenter;
        label.numberOfLines = 2;
        [label sizeToFit];
        [label setFrame:CGRectMake(CGRectGetWidth(self.page2View.frame)*0.5-label.frame.size.width*0.5, label.frame.origin.y, label.frame.size.width, label.frame.size.height)];
        [self.page2View addSubview:label];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(50, CGRectGetMaxY(label.frame)+10, CGRectGetWidth(self.page1View.frame)-100, CGRectGetWidth(self.page2View.frame)-100)];
        imageView.image = [UIImage imageNamed:page2ImageName];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.page2View addSubview:imageView];
        UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(50, CGRectGetMaxY(imageView.frame)+10, CGRectGetWidth(self.page2View.frame)-100, CGRectGetWidth(self.page2View.frame)-100)];
        textView.text = page2Content;
        textView.font = [UIFont systemFontOfSize:20];
        textView.editable = NO;
        [textView sizeToFit];
        [textView setFrame:CGRectMake(CGRectGetWidth(self.page2View.frame)*0.5-textView.frame.size.width*0.5, textView.frame.origin.y, textView.frame.size.width, textView.frame.size.height)];
        textView.scrollEnabled = NO;
        [self.page2View addSubview:textView];
        self.page2View.contentSize = CGSizeMake(CGRectGetWidth(self.page2View.frame), CGRectGetMaxY(textView.frame));
    }
    return _page2View;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    // 记录scrollView 的当前位置，因为已经设置了分页效果，所以：位置/屏幕大小 = 第几页
    int current = scrollView.contentOffset.x/[UIScreen mainScreen].bounds.size.width;
    
    //根据scrollView 的位置对page 的当前页赋值
    self.pageControl.currentPage = current;
    
}


@end
