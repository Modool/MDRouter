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

NSString * const MDRouterTestRootURLString = @"https://www.github.com/Modool";
NSString * const MDRouterTestURLString = @"https://www.github.com/Modool/Resources/blob/master/images/social/github_1000.png?raw=true";

@interface MDRouterTestViewController : UIViewController

@end

@implementation MDRouterTestViewController

@end

@interface MDRouterTests : XCTestCase

@property (nonatomic, strong) MDRouterSet *router;

@end

@implementation MDRouterTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.

    self.router = [MDRouterSet router];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testYiMing {

    MDRouterSimpleSolution *solution = [MDRouterSimpleSolution solutionWithBlock:^id(NSDictionary *arguments, NSError *__autoreleasing *error) {
        return @1;
    }];

    NSURL *baseURL = [NSURL URLWithString:MDRouterTestRootURLString];

    [[self router] addSolution:solution baseURL:baseURL];

    [[self router] addAdapter:[[MDRouterAdapter alloc] initWithBaseURL:baseURL]];

    [[self router] removeSolution:solution baseURL:baseURL];

    id output = nil;
    BOOL state = [[self router] openURL:[NSURL URLWithString:MDRouterTestURLString] output:&output error:NULL];

    XCTAssertFalse(state);
}

- (void)testFilterSchemes {
    
    MDRouterWebsiteAdapter *websiteAdapter = [MDRouterWebsiteAdapter adapter];
    [websiteAdapter addSolution:[MDRouterSimpleSolution solutionWithBlock:^id(NSDictionary *arguments, NSError *__autoreleasing *error) {
        return @1;
    }] baseURL:[NSURL URLWithString:MDRouterTestRootURLString]];
    
    
    [[self router] addAdapter:websiteAdapter];
    
    BOOL state = [[self router] openURL:[NSURL URLWithString:MDRouterTestURLString] output:NULL error:NULL];
    
    XCTAssertTrue(state);
    
    self.router.invalidSchemes = [NSSet setWithObject:@"https"];
    
    state = [[self router] openURL:[NSURL URLWithString:MDRouterTestURLString] output:NULL error:NULL];
    XCTAssertFalse(state);
    
    self.router.invalidSchemes = [NSSet setWithObject:@"http"];
    
    state = [[self router] openURL:[NSURL URLWithString:MDRouterTestURLString] output:NULL error:NULL];
    XCTAssertTrue(state);
    
    self.router.invalidSchemes = nil;
    self.router.validSchemes = [NSSet setWithObject:@"https"];
    
    state = [[self router] openURL:[NSURL URLWithString:MDRouterTestURLString] output:NULL error:NULL];
    XCTAssertTrue(state);
    
    self.router.validSchemes = [NSSet setWithObject:@"http"];
    
    state = [[self router] openURL:[NSURL URLWithString:MDRouterTestURLString] output:NULL error:NULL];
    XCTAssertFalse(state);
    
    [[self router] removeAdapter:websiteAdapter];
}

- (void)testFilterHosts {
    MDRouterWebsiteAdapter *websiteAdapter = [MDRouterWebsiteAdapter adapter];
    [websiteAdapter addSolution:[MDRouterSimpleSolution solutionWithBlock:^id(NSDictionary *arguments, NSError *__autoreleasing *error) {
        return @1;
    }] baseURL:[NSURL URLWithString:MDRouterTestRootURLString]];
    
    
    [[self router] addAdapter:websiteAdapter];
    
    BOOL state = [[self router] openURL:[NSURL URLWithString:MDRouterTestURLString] output:NULL error:NULL];
    
    XCTAssertTrue(state);
    
    self.router.invalidHosts = [NSSet setWithObject:@"www.github.com"];
    
    state = [[self router] openURL:[NSURL URLWithString:MDRouterTestURLString] output:NULL error:NULL];
    XCTAssertFalse(state);
    
    self.router.invalidHosts = [NSSet setWithObject:@"www.baidu.com"];
    
    state = [[self router] openURL:[NSURL URLWithString:MDRouterTestURLString] output:NULL error:NULL];
    XCTAssertTrue(state);
    
    self.router.invalidHosts = nil;
    self.router.validHosts = [NSSet setWithObject:@"www.github.com"];
    
    state = [[self router] openURL:[NSURL URLWithString:MDRouterTestURLString] output:NULL error:NULL];
    XCTAssertTrue(state);
    
    self.router.validSchemes = [NSSet setWithObject:@"www.baidu.com"];
    
    state = [[self router] openURL:[NSURL URLWithString:MDRouterTestURLString] output:NULL error:NULL];
    XCTAssertFalse(state);
    
    [[self router] removeAdapter:websiteAdapter];
}

- (void)testFilterPorts {
    MDRouterWebsiteAdapter *websiteAdapter = [MDRouterWebsiteAdapter adapter];
    [websiteAdapter addSolution:[MDRouterSimpleSolution solutionWithBlock:^id(NSDictionary *arguments, NSError *__autoreleasing *error) {
        return @1;
    }] baseURL:[NSURL URLWithString:MDRouterTestRootURLString]];
    
    
    [[self router] addAdapter:websiteAdapter];
    
    BOOL state = [[self router] openURL:[NSURL URLWithString:MDRouterTestURLString] output:NULL error:NULL];
    
    XCTAssertTrue(state);
    
    self.router.invalidPorts = [NSSet setWithObject:@(8080)];
    
    state = [[self router] openURL:[NSURL URLWithString:MDRouterTestURLString] output:NULL error:NULL];
    XCTAssertTrue(state);
    
    self.router.invalidHosts = nil;
    self.router.validHosts = [NSSet setWithObject:@(8080)];
    
    state = [[self router] openURL:[NSURL URLWithString:MDRouterTestURLString] output:NULL error:NULL];
    XCTAssertFalse(state);
    
    [[self router] removeAdapter:websiteAdapter];
}

- (void)testWebsiteAdapter {
    MDRouterWebsiteAdapter *websiteAdapter = [MDRouterWebsiteAdapter adapter];
    [websiteAdapter addSolution:[MDRouterSimpleSolution solutionWithBlock:^id(NSDictionary *arguments, NSError *__autoreleasing *error) {
        return @1;
    }] baseURL:[NSURL URLWithString:MDRouterTestRootURLString]];
    
    
    [[self router] addAdapter:websiteAdapter];
    
    id output = nil;
    
    BOOL state = [[self router] openURL:[NSURL URLWithString:MDRouterTestURLString] output:&output error:NULL];
    
    [[self router] removeAdapter:websiteAdapter];
    
    XCTAssertTrue(state);
    XCTAssertEqualObjects(output, @1);
}

- (void)testUndirectionalAdapter {
    MDRouterUndirectionalAdapter *undirectionalAdapter = [MDRouterUndirectionalAdapter adapterWithBlock:^id(NSURL *URL, NSDictionary *arguments, NSError *__autoreleasing *error) {
        return @1;
    }];
    
    [[self router] addAdapter:undirectionalAdapter];
    
    id output = nil;
    
    BOOL state = [[self router] openURL:[NSURL URLWithString:MDRouterTestURLString] output:&output error:NULL];
    
    [[self router] removeAdapter:undirectionalAdapter];
    
    XCTAssertTrue(state);
    XCTAssertEqualObjects(output, @1);
}

- (void)testSampleSolution {
    MDRouterSimpleSolution *solution = [MDRouterSimpleSolution solutionWithBlock:^id(NSDictionary *arguments, NSError *__autoreleasing *error) {
        return @1;
    }];
    
    [[self router] addSolution:solution baseURL:[NSURL URLWithString:MDRouterTestRootURLString]];
    
    id output = nil;
    BOOL state = [[self router] openURL:[NSURL URLWithString:MDRouterTestURLString] output:&output error:NULL];
    
    [[self router] removeSolution:solution baseURL:[NSURL URLWithString:MDRouterTestRootURLString]];
    
    XCTAssertTrue(state);
    XCTAssertEqualObjects(output, @1);
}

- (void)testRouterErrorOuput {
    MDRouterSimpleSolution *solution = [MDRouterSimpleSolution solutionWithBlock:^id(NSDictionary *arguments, NSError *__autoreleasing *error) {
        *error = [NSError errorWithDomain:MDRouterErrorDomain code:10000 userInfo:nil];
        return nil;
    }];
    
    [[self router] addSolution:solution baseURL:[NSURL URLWithString:MDRouterTestRootURLString]];
    
    NSError *error = nil;
    BOOL state = [[self router] openURL:[NSURL URLWithString:MDRouterTestURLString] output:NULL error:&error];
    
    [[self router] removeSolution:solution baseURL:[NSURL URLWithString:MDRouterTestRootURLString]];
    
    XCTAssertFalse(state);
    XCTAssertTrue([error code] == 10000);
}

- (void)testAsynchronizeSampleSolution {
    XCTestExpectation *expectation = [self expectationWithDescription:@"success"];
    MDRouterAsynchronizeSampleSolution *solution = [MDRouterAsynchronizeSampleSolution solutionWithBlock:^(void (^completion)(id<MDRouterSolution> solution)) {
        MDRouterSimpleSolution *innerSolution = [MDRouterSimpleSolution solutionWithBlock:^id(NSDictionary *arguments, NSError *__autoreleasing *error) {
            [expectation fulfill];
            return @1;
        }];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            completion(innerSolution);
        });
    }];
    
    [[self router] addSolution:solution baseURL:[NSURL URLWithString:MDRouterTestRootURLString]];
    
    BOOL state = [[self router] openURL:[NSURL URLWithString:MDRouterTestURLString] output:NULL error:NULL];
    
    [[self router] removeSolution:solution baseURL:[NSURL URLWithString:MDRouterTestRootURLString]];
    
    XCTAssertTrue(state);
    
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
    
    XCTAssertTrue(state || [error code] == MDRouterErrorCodeNoVisibleNavigationController);
}

- (void)testPresentViewControllerSolution {
    [[self router] addSolution:(id)[MDRouterTestViewController class] baseURL:[NSURL URLWithString:MDRouterTestRootURLString]];
    
    id output = nil;
    NSError *error = nil;
    
    BOOL state = [[self router] openURL:[NSURL URLWithString:MDRouterTestURLString] arguments:@{MDRouterSolutionItemPushKey: @NO} output:&output error:&error];
    
    [[self router] removeSolution:(id)[MDRouterTestViewController class] baseURL:[NSURL URLWithString:MDRouterTestRootURLString]];
    
    XCTAssertTrue(state || [error code] == MDRouterErrorCodeNoVisibleViewController || [error code] == MDRouterErrorCodePresentedViewControllerExsit);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
