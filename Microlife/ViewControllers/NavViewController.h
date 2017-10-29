//
//  NavViewController.h
//  Microlife
//
//  Created by 點睛 on 2016/9/21.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import "MViewController.h"
#import <WebKit/WebKit.h>


@interface NavViewController : MViewController<UIScrollViewDelegate,APIPostAndResponseDelegate,WKUIDelegate,WKNavigationDelegate>
@property(nonatomic,strong)NSMutableArray *navImageArray;
@property(nonatomic,strong)NSMutableArray *navTextArray;

@property (nonatomic, retain) WKWebView *webView;
@property (nonatomic, retain) UIView *webUIView;
@property (nonatomic, retain) UIBarButtonItem *backButton;
@property (nonatomic, retain) UIToolbar *toolbar;
@property (nonatomic, retain) UITextField *webURLTextField;

@end
