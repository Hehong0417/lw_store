//
//  HHActivityWebVC.m
//  lw_Store
//
//  Created by User on 2018/6/5.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHdiscountPackageVC.h"
#import <WebKit/WebKit.h>
#import "HHSubmitOrdersVC.h"

@interface HHdiscountPackageVC ()<WKUIDelegate,WKNavigationDelegate>
{
    WKWebView *_webView;
    UIButton *rightBtn;
    NSString *webpageUrl;
    NSString *responseUrl;
}
@end

@implementation HHdiscountPackageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // js配置
    self.title = @"优惠套餐";
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    //    config.userContentController = userContentController;
    
    _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH-64) configuration:config];
    _webView.UIDelegate = self;
    _webView.navigationDelegate = self;
    
    [_webView.scrollView setShowsVerticalScrollIndicator:NO];
    [_webView.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.view addSubview:_webView];
    
    HJUser *user = [HJUser sharedUser];
    
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/ActivityWeb/DiscountPackage?id=%@&token=%@",API_HOST1,self.Id,user.token]]];
    
    [_webView loadRequest:req];
    
    //抓取返回按钮
    UIButton *backBtn = (UIButton *)self.navigationItem.leftBarButtonItem.customView;
    [backBtn bk_removeEventHandlersForControlEvents:UIControlEventTouchUpInside];
    [backBtn addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)backBtnAction{
    
    if ([_webView canGoBack]) {
        [_webView goBack];
    }else{
        [self.view resignFirstResponder];
        [self.navigationController popVC];
    }
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    
    NSLog(@"Start:%@",navigation);
    
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    
    NSLog(@"Finish:%@",navigation);
    //获取当前页面的title
    [_webView evaluateJavaScript: @"document.title" completionHandler:^(id data, NSError * _Nullable error) {
        self.title = data;
    }];
}
// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    
    NSLog(@"Redirect:%@",navigation);
    
}
// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    
    NSLog(@"Response %@",navigationResponse.response.URL.absoluteString);
    responseUrl = navigationResponse.response.URL.absoluteString;
    
    if ([responseUrl containsString:@"ShopCarWeb/PreviewOrder"]) {
        rightBtn.hidden = YES;
        HHUrlModel *model = [HHUrlModel mj_objectWithKeyValues:[navigationResponse.response.URL.absoluteString lh_parametersKeyValue]];
        HHSubmitOrdersVC *vc = [HHSubmitOrdersVC new];
        vc.ids_Str = model.skuId;
        vc.mode = model.mode;
        vc.gbId = model.gbId;
        vc.enter_type = HHaddress_type_package;
        [self.navigationController pushVC:vc];
        decisionHandler(WKNavigationResponsePolicyCancel);
        
    }else if([responseUrl containsString:@"Home/Index"]){
        
        [UIApplication sharedApplication].keyWindow.rootViewController = [[HJTabBarController alloc] init];
        
        decisionHandler(WKNavigationResponsePolicyCancel);
    }else{
        decisionHandler(WKNavigationResponsePolicyAllow);
    }
    
}

@end
