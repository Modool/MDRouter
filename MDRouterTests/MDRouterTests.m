//
//  MDRouterTests.m
//  MDRouterTests
//
//  Created by Jave on 2017/12/15.
//  Copyright © 2017年 markejave. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <UIKit/UIKit.h>

#import "MDRouter.h"
#import "MDRouterSimpleAdapter.h"
#import "MDRouterWebsiteAdapter.h"
#import "MDRouterUndirectionalAdapter.h"

#import "MDRouterSampleSolution.h"
#import "MDRouterAsynchronizeSampleSolution.h"
#import "UIViewController+MDRouterSolution.h"

#import "MDRouterConstants.h"

NSString * const MDRouterTestRootURLString = @"https://www.github.com/Modool";
NSString * const MDRouterTestURLString = @"https://www.github.com/Modool/Resources/blob/master/images/social/github_1000.png?raw=true";

@interface MDRouterTestViewController : UIViewController

@end

@implementation MDRouterTestViewController

@end

@interface MDRouterTests : XCTestCase

//    http://tieba.baidu.com/p/5488009488?red_tag=r2448777939

@property (nonatomic, strong) MDRouter *router;

@end

@implementation MDRouterTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.

    self.router = [MDRouter routerWithBaseURL:[NSURL URLWithString:MDRouterTestRootURLString]];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testWebsiteAdapter {
    MDRouterWebsiteAdapter *websiteAdapter = [MDRouterWebsiteAdapter adapter];
    [websiteAdapter addSolution:[MDRouterSampleSolution solutionWithBlock:^id(NSDictionary *arguments, NSError *__autoreleasing *error) {
        return @1;
    }] baseURL:[NSURL URLWithString:MDRouterTestRootURLString]];
    
    
    [[self router] addAdapter:websiteAdapter];
    
    id output = nil;
    NSError *error = nil;
    
    BOOL state = [[self router] openURL:[NSURL URLWithString:MDRouterTestURLString] output:&output error:&error];
    
    [[self router] removeAdapter:websiteAdapter];
    
    XCTAssertTrue(state);
    XCTAssertNil(error);
    XCTAssertEqualObjects(output, @1);
}

- (void)testUndirectionalAdapter {
    MDRouterUndirectionalAdapter *undirectionalAdapter = [MDRouterUndirectionalAdapter adapterWithBlock:^id(NSDictionary *arguments, NSError *__autoreleasing *error) {
        return @1;
    }];
    
    [[self router] addAdapter:undirectionalAdapter];
    
    id output = nil;
    NSError *error = nil;
    
    BOOL state = [[self router] openURL:[NSURL URLWithString:MDRouterTestURLString] output:&output error:&error];
    
    [[self router] removeAdapter:undirectionalAdapter];
    
    XCTAssertTrue(state);
    XCTAssertNil(error);
    XCTAssertEqualObjects(output, @1);
}

- (void)testSampleSolution {
    MDRouterSampleSolution *solution = [MDRouterSampleSolution solutionWithBlock:^id(NSDictionary *arguments, NSError *__autoreleasing *error) {
        return @1;
    }];
    
    [[self router] addSolution:solution baseURL:[NSURL URLWithString:MDRouterTestRootURLString]];
    
    id output = nil;
    NSError *error = nil;
    
    BOOL state = [[self router] openURL:[NSURL URLWithString:MDRouterTestURLString] output:&output error:&error];
    
    [[self router] removeSolution:solution baseURL:[NSURL URLWithString:MDRouterTestRootURLString]];
    
    XCTAssertTrue(state);
    XCTAssertNil(error);
    XCTAssertEqualObjects(output, @1);
}

- (void)testAsynchronizeSampleSolution {
    XCTestExpectation *expectation = [self expectationWithDescription:@"success"];
    MDRouterAsynchronizeSampleSolution *solution = [MDRouterAsynchronizeSampleSolution solutionWithBlock:^(void (^completion)(id<MDRouterSolution> solution)) {
        MDRouterSampleSolution *innerSolution = [MDRouterSampleSolution solutionWithBlock:^id(NSDictionary *arguments, NSError *__autoreleasing *error) {
            [expectation fulfill];
            return @1;
        }];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            completion(innerSolution);
        });
    }];
    
    [[self router] addSolution:solution baseURL:[NSURL URLWithString:MDRouterTestRootURLString]];
    
    id output = nil;
    NSError *error = nil;
    
    BOOL state = [[self router] openURL:[NSURL URLWithString:MDRouterTestURLString] output:&output error:&error];
    
    [[self router] removeSolution:solution baseURL:[NSURL URLWithString:MDRouterTestRootURLString]];
    
    XCTAssertTrue(state);
    XCTAssertNil(error);
    XCTAssertNil(output);
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError * _Nullable error) {
        XCTAssertNil(error);
    }];
}

- (void)testPushViewControllerSolution {
    [[self router] addSolution:(id)[MDRouterTestViewController class] baseURL:[NSURL URLWithString:MDRouterTestRootURLString]];
    
    id output = nil;
    NSError *error = nil;
    
    BOOL state = [[self router] openURL:[NSURL URLWithString:MDRouterTestURLString] output:&output error:&error];
    
    [[self router] removeSolution:(id)[MDRouterTestViewController class] baseURL:[NSURL URLWithString:MDRouterTestRootURLString]];
    
    XCTAssertTrue(state);
    XCTAssertFalse([error code] != MDRouterErrorCodeNoVisibleNavigationController);
}

- (void)testPresentViewControllerSolution {
    [[self router] addSolution:(id)[MDRouterTestViewController class] baseURL:[NSURL URLWithString:MDRouterTestRootURLString]];
    
    id output = nil;
    NSError *error = nil;
    
    BOOL state = [[self router] openURL:[NSURL URLWithString:MDRouterTestURLString] arguments:@{MDRouterSolutionItemPushKey: @NO} output:&output error:&error];
    
    [[self router] removeSolution:(id)[MDRouterTestViewController class] baseURL:[NSURL URLWithString:MDRouterTestRootURLString]];
    
    XCTAssertTrue(state);
    XCTAssertFalse([error code] != MDRouterErrorCodeNoVisibleViewController);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
