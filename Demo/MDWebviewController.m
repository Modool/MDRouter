//
//  MDWebviewController.m
//  Demo
//
//  Created by Jave on 2017/12/29.
//  Copyright © 2017年 markejave. All rights reserved.
//

#import <WebKit/WebKit.h>

#import "MDWebviewController.h"

#import "MDAppDelegate.h"

@implementation NSURLComponents (MDRouter)

- (NSString *)queryItemValueNamed:(NSString *)name{
    for (NSURLQueryItem *item in [self queryItems]) {
        if ([[item name] isEqualToString:name]) return [item value];
    }
    return nil;
}

@end

@interface MDWebviewController ()<WKNavigationDelegate, WKUIDelegate>

@property (weak, nonatomic) IBOutlet WKWebView *webView;

@end

@implementation MDWebviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"router" withExtension:@"html"];
    [[self webView] loadHTMLString:[NSString stringWithContentsOfURL:fileURL encoding:NSUTF8StringEncoding error:nil] baseURL:nil];
}

#pragma mark - WKNavigationDelegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler;{
    
    BOOL canOpenURL = [[MDSharedAppDelegate router] canOpenURL:[[navigationAction request] URL]];
    if (canOpenURL) {
        id output = nil;
        NSError *error = nil;
        
        BOOL success = [[MDSharedAppDelegate router] openURL:[[navigationAction request] URL] output:&output error:&error];
        decisionHandler(success ? WKNavigationActionPolicyCancel : WKNavigationActionPolicyAllow);
        
        NSURLComponents *components = [NSURLComponents componentsWithURL:[[navigationAction request] URL] resolvingAgainstBaseURL:NO];
        NSString *callback = [components queryItemValueNamed:@"callback"];
        
        NSString *javascript = [NSString stringWithFormat:@"%@('%@', '%@', %ld, '%@')", callback, [[[navigationAction request] URL] absoluteString], output ?: @"成功", [error code], [error description]];
        
        [webView evaluateJavaScript:javascript completionHandler:^(id _Nullable result, NSError * _Nullable error) {
            
        }];
    } else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message ?: @"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }])];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
