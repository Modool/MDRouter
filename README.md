# MDRouter

[![](https://img.shields.io/travis/rust-lang/rust.svg?style=flat)](https://github.com/Modool)
[![](https://img.shields.io/badge/language-Object--C-1eafeb.svg?style=flat)](https://developer.apple.com/Objective-C)
[![](https://img.shields.io/badge/license-MIT-353535.svg?style=flat)](https://developer.apple.com/iphone/index.action)
[![](https://img.shields.io/badge/platform-iOS-lightgrey.svg?style=flat)](https://github.com/Modool)
[![](https://img.shields.io/badge/QQ群-662988771-red.svg)](http://wpa.qq.com/msgrd?v=3&uin=662988771&site=qq&menu=yes)

## Introduction

- The router for transitioning or logical processing.
- Return output for handling result and return error for exceptions.
- Support verification for preprocessing, processing continued if return nil, or transmited the returned solution,  see `MDRouterAccessableInvocation`.

```
- (MDRouterInvocation *)verifyValidWithRouterArguments:(NSDictionary *)arguments;
```
- Support verification for optional arguments, processing interrupted if non-matched arguments.

```
@property (nonatomic, strong, readonly) NSDictionary<NSString *, NSNumber *> *argumentConditions;
```
- Support pure URL defination for cross-module or cross-platform.

```
- (BOOL)openURL:(NSURL *)URL output:(id *)output error:(NSError **)error;
```

- Support URL with extensional arguments for native routing.

```
- (BOOL)openURL:(NSURL *)URL arguments:(NSDictionary *)arguments output:(id *)output error:(NSError **)error;
```

- Support to redirect URL to another URL.

```
- (BOOL)redirectURL:(NSURL *)URL toURL:(NSURL *)toURL;
- (BOOL)redirectURLString:(NSString *)URLString toURLString:(NSString *)toURLString;
```

- Support protocol to invoke with router.

```
- (void)addProtocol:(Protocol *)protocol;
```

- Call method of registered protocol to invoke an invocation of router, method invocation will transform to URL, arguments will transform to query item with URL encoding.

```
// Define protocol
@protocol MDRouterSampeProtocol <NSObject>

MDRouterNonArgumentMethodAs(path, - (id)doSomething);

MDRouterMethodAs(path, arg1, - (id)doSomethingWithArg1:(NSDictionary *)arg1 arg2:(BOOL)arg2);

MDRouterMethodHostAs(host, path, arg1, - (id)doSomethingWithArg1:(BOOL)arg1 arg2:(BOOL)arg2);

@end

// Call method1 of protocol, the method transform as 'invocation://path'
id output = [(id<MDRouterSampeProtocol>)router doSomething];

// Call method2 of protocol, the method transform as 'invocation://path?arg1=%7b%22key%22%3a+%22value%22%7d&arg2=1'
id output = [(id<MDRouterSampeProtocol>)router doSomethingWithArg1:@{@"key": @"value"} arg2:YES];

// Call method3 of protocol, the method transform as 'invocation://host/path?arg1=1&arg2=1'
id output = [(id<MDRouterSampeProtocol>)router doSomethingWithArg1:YES arg2:YES];

```
- Support adapter mode, provide protocol and base class `MDRouterAdapter` to extend, easy to divide into groups for different kind of routing.

- Provide invocation for any instance or clas, handle logic with target-action, see `MDRouterInvocation`, handle logic with block, also asynchronous invocation, see `MDRouterBlockInvocation`, `MDRouterAsynchronizeBlockInvocation`

- Provide default simple adapter with block invocation, see `MDRouterSimpleAdapter`

- Default adapter `MDRouterWebsiteAdapter`, to match URL which contained http / https scheme.

- Default adapter `MDRouterUndirectionalAdapter` is the ultimate solution, to match the URL that never matched.

- Provide default implementation for `UIViewController` transitioning, see `UIViewController+MDRouterInvocation`

## How To Get Started

* Download `MDRouter ` and try run example app

## Installation


* Installation with CocoaPods

```
source 'https://github.com/Modool/cocoapods-specs.git'
platform :ios, '8.0'

target 'TargetName' do
pod 'MDRouter'
end

```

* Installation with Carthage

```
github "Modool/MDRouter"
```

* Manual Import

```
drag “MDRouter” directory into your project

```


## Requirements
- Requires ARC

## Architecture

### Router
* `MDRouterSet`

### Adapter
* `MDRouterAdapter`
* `MDRouterSimpleAdapter`
* `MDRouterUndirectionalAdapter`
* `MDRouterWebsiteAdapter`

### Invocation Protocol
* `MDRouterInvocation`
* `MDRouterBlockInvocation`
* `MDRouterAsynchronizeBlockInvocation`

## Usage

* Demo FYI

## Update History

* 2017.12.27 Add README and adjust project class name.

## License
`MDRouter ` is released under the MIT license. See LICENSE for details.


## Communication

<img src="https://github.com/Modool/Resources/blob/master/images/social/qq_300.png?raw=true" width=200><img style="margin:0px 50px 0px 50px" src="https://github.com/Modool/Resources/blob/master/images/social/wechat_300.png?raw=true" width=200><img src="https://github.com/Modool/Resources/blob/master/images/social/github_300.png?raw=true" width=200>
