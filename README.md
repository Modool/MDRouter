# MDRouter

[![](https://img.shields.io/travis/rust-lang/rust.svg?style=flat)](https://github.com/Modool)
[![](https://img.shields.io/badge/language-Object--C-1eafeb.svg?style=flat)](https://developer.apple.com/Objective-C)
[![](https://img.shields.io/badge/license-MIT-353535.svg?style=flat)](https://developer.apple.com/iphone/index.action)
[![](https://img.shields.io/badge/platform-iOS-lightgrey.svg?style=flat)](https://github.com/Modool)
[![](https://img.shields.io/badge/QQ群-662988771-red.svg)](http://wpa.qq.com/msgrd?v=3&uin=662988771&site=qq&menu=yes)

## Introduction

- The router for transitioning or logical processing.

## How To Get Started

* Download `MDRouter ` and try run example app

## Installation


* Installation with CocoaPods

```
source 'https://github.com/Modool/cocoapods-specs.git'
platform :ios, '8.0'

target 'TargetName' do
pod 'MDRouter', '~> 1.0.0'
end

```

* Installation with Carthage

```
github "Modool/MDRouter" ~> 1.0.0
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

### Solution Protocol
* `MDRouterSolution`
* `MDRouterClassSolution`
* `MDRouterAsynchronizeSolution`

### Solution Class
* `MDRouterSampleSolution `
* `MDRouterAsynchronizeSampleSolution`
* `UIViewController+MDRouterSolution`
	
### Private
* `MDRouterSolutionItem `
* `MDRouterSolutionContainer `

	
## Usage

* Demo FYI 

## Update History

* 2017.12.27 Add README and adjust project class name.

## License
`MDRouter ` is released under the MIT license. See LICENSE for details.


## Communication

<img src="https://github.com/Modool/Resources/blob/master/images/social/qq_300.png?raw=true" width=200><img style="margin:0px 50px 0px 50px" src="https://github.com/Modool/Resources/blob/master/images/social/wechat_300.png?raw=true" width=200><img src="https://github.com/Modool/Resources/blob/master/images/social/github_300.png?raw=true" width=200>
