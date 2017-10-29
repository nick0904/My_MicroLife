//
//  WebViewController.m
//  Microlife
//
//  Created by WiFi@MBP on 2017/5/4.
//  Copyright © 2017年 Rex. All rights reserved.
//

#import "WebViewController.h"
#import "ViewController.h"



@interface WebViewController ()

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.URL]]];
    self.WebURLTextField.text = self.URL;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (WKWebView *)webView {
    if (!_webView) {
        WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
        // 自适应屏幕宽度js
        NSString *jSString = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
        WKUserScript *wkUserScript = [[WKUserScript alloc] initWithSource:jSString injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        // 添加自适应屏幕宽度js调用的方法
        [wkWebConfig.userContentController addUserScript:wkUserScript];
        self.webView = [[WKWebView alloc] initWithFrame:self.WebUIView.frame configuration:wkWebConfig];

        self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        self.webView.UIDelegate = self;
        self.webView.navigationDelegate = self;
        self.webView.backgroundColor = [UIColor whiteColor];
        [self.WebUIView addSubview:self.webView];
    }
    return _webView;
}

#pragma mark -- WKNavigationDelegate
//页面开始加载时调用
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"页面开始加载时调用,%@",self.webView.URL);
}

//当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"当内容开始返回时调用,%@",self.webView.URL);
}

//页面加载完成时调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"页面加载完成时调用,%@",self.webView.URL);
}

//页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"页面加载失败时调用,%@",self.webView.URL);
}

//发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if (navigationAction.navigationType == WKNavigationTypeLinkActivated) {
        if (!webView.isLoading) {
        }
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

#pragma mark - API Delegate
-(void)processOAuthToken:(NSDictionary *)responseData Error:(NSError *)jsonError {
    
    NSLog(@"responseData:%@",responseData);
    
    if ([[responseData objectForKey:@"code"] intValue] == 10000) {
        
        NSString *access_token_str = [responseData objectForKey:@"access_token"];
        NSString *refresh_token_str = [responseData objectForKey:@"refresh_token"];
        
        [MViewController saveAccess_token:access_token_str];
        [MViewController saveRefresh_token:refresh_token_str];
        
        NSString *tokenStr = [NSString stringWithContentsOfFile:OAuth_TOKEN encoding:NSUTF8StringEncoding error:nil];
        NSString *refresh_tokenStr = [NSString stringWithContentsOfFile:OAuth_Refreash_TOKEN encoding:NSUTF8StringEncoding error:nil];
        NSLog(@"tokenStr =====>>> %@",tokenStr);
        NSLog(@"refresh_tokenStr ====> %@",refresh_tokenStr);
        
        //取得這個帳號的 Base Data
        [apiClass postGetMemberBaseData:tokenStr client_id:@"BkbnHiURrKvnFCzAJndMt21Cd25nSiYI" client_secret:@"HnQTBcdCSef4puv2vn3I3RxMms1wh65C"];
        
    }
    
//    [self checkResponseCodeForToken:appDelegate.codeNum beContinue:NO];
    
}

-(void)processGetMemberBaseData:(NSDictionary *)responseData Error:(NSError *)jsonError {
    
    if (jsonError) {
        
        NSLog(@"Get Member Base Data jsonError: %@",jsonError);
        
    }
    else {
        
        NSLog(@"Get Member Base Data responseData: %@",responseData);
        
        if ([[responseData objectForKey:@"code"] intValue] == 10000) {
            
//            m_accountID = [[responseData objectForKey:@"account_id"] intValue];
            
            [LocalData sharedInstance].accountID = [[responseData objectForKey:@"account_id"] intValue];
            
            [LocalData sharedInstance].name = [[responseData objectForKey:@"data"] objectForKey:@"name"];
            
            NSString *emailStr = [[responseData objectForKey:@"data"] objectForKey:@"email"];
            
            [emailStr writeToFile:USER_EMAIL_FILEPATH atomically:YES encoding:NSUTF8StringEncoding error:nil];
            
            NSLog(@"name: %@",[[responseData objectForKey:@"data"] objectForKey:@"name"]);
            
            NSLog(@"email: %@",[[responseData objectForKey:@"data"] objectForKey:@"email"]);
            
//            [self checkResponseCodeForToken:[NSNumber numberWithInt:10000] beContinue:YES];
        }
        
    }
    
}

#pragma -mark backAction
- (IBAction)backAction:(id)sender {
    NSLog(@"backAction");
    [self dismissViewControllerAnimated:YES completion:nil];

}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
