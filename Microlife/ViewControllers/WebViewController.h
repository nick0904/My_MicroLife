//
//  WebViewController.h
//  Microlife
//
//  Created by WiFi@MBP on 2017/5/4.
//  Copyright © 2017年 Rex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

#import "MViewController.h"
#import "NavViewController.h"

@interface WebViewController : UIViewController <WKUIDelegate,WKNavigationDelegate,APIPostAndResponseDelegate> {
    APIPostAndResponse *apiClass;
}

@property (weak, nonatomic) IBOutlet UIButton *BackButton;

@property (weak, nonatomic) IBOutlet UITextField *WebURLTextField;

@property (weak, nonatomic) IBOutlet UIView *WebUIView;

@property (nonatomic, retain) WKWebView *webView;

@property (nonatomic, strong) NSString *URL;

@end
