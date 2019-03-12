//
//  MDRouterSet.m
//  MDRouter
//
//  Created by Jave on 2017/12/27.
//  Copyright © 2017年 Modool. All rights reserved.
//

#import "MDRouterSet.h"
#import "MDRouterAdapter+Private.h"

#import "MDRouterConstants.h"
#import "NSSet+MDRouter.h"
#import "NSError+MDRouter.h"

#define MDSYNC(__VA_ARGS__) [self _sync:^{\
__VA_ARGS__\
}];

NSString * const MDRouterErrorDomain    = @"com.bilibili.link.router.error.domain";

@interface MDRouterSet ()

@property (nonatomic) dispatch_queue_t queue;
@property (nonatomic) void *queueTag;

@end

@implementation MDRouterSet
@dynamic baseURL;

+ (instancetype)router {
    return [self routerWithBaseURL:nil];
}

+ (instancetype)routerWithBaseURL:(NSURL *)baseURL {
    return [[self alloc] initWithBaseURL:baseURL queue:nil];
}

+ (instancetype)routerWithBaseURL:(NSURL *)baseURL queue:(dispatch_queue_t)queue {
    return [[self alloc] initWithBaseURL:baseURL queue:queue];
}

- (instancetype)initWithBaseURL:(NSURL *)baseURL queue:(dispatch_queue_t)queue{
    if (self = [super initWithBaseURL:baseURL]) {
        if ([baseURL scheme]) {
            self.validSchemes = [NSSet setWithObject:[baseURL scheme]];
        }
        if ([baseURL host]) {
            self.validHosts = [NSSet setWithObject:[baseURL host]];
        }
        if ([baseURL port]) {
            self.validPorts = [NSSet setWithObject:[baseURL port]];
        }
        if (queue) _queue = queue;
        else _queue = dispatch_queue_create("com.modool.router.serial.queue", DISPATCH_QUEUE_SERIAL);
        
        _queueTag = &_queueTag;
        dispatch_queue_set_specific(_queue, _queueTag, _queueTag, NULL);
    }
    return self;
}

#pragma mark - accessor

- (void)setValidSchemes:(NSSet<NSString *> *)validSchemes{
    MDSYNC(
        if (_validSchemes != validSchemes) {
            _validSchemes = [self invalidSchemes] ? [validSchemes setByMinusSet:[self invalidSchemes]] : validSchemes;
        }
    )
}

- (void)setInvalidSchemes:(NSSet<NSString *> *)invalidSchemes{
    MDSYNC(
        if (_invalidSchemes != invalidSchemes) {
            _invalidSchemes = [self validSchemes] ? [invalidSchemes setByMinusSet:[self validSchemes]]: invalidSchemes;
        }
    )
}

- (void)setValidHosts:(NSSet<NSString *> *)validHosts{
    MDSYNC(
        if (_validHosts != validHosts) {
            _validHosts = [self invalidHosts] ? [validHosts setByMinusSet:[self invalidHosts]]: validHosts;
        }
    )
}

- (void)setInvalidHosts:(NSSet<NSString *> *)invalidHosts{
    MDSYNC(
        if (_invalidHosts != invalidHosts) {
            _invalidHosts = [self validHosts] ? [invalidHosts setByMinusSet:[self validHosts]]: invalidHosts;
        }
    )
}

- (void)setValidPorts:(NSSet<NSNumber *> *)validPorts{
    MDSYNC(
        if (_validPorts != validPorts) {
            _validPorts = [self invalidPorts] ? [validPorts setByMinusSet:[self invalidPorts]]: validPorts;
        }
    )
}

- (void)setInvalidPorts:(NSSet<NSNumber *> *)invalidPorts{
    MDSYNC(
        if (_invalidPorts != invalidPorts) {
            _invalidPorts = [self validPorts] ? [invalidPorts setByMinusSet:[self validPorts]]: invalidPorts;
        }
    )
}

#pragma mark - private

- (BOOL)_validateURL:(NSURL *)URL{
    if ([self invalidSchemes] && [[self invalidSchemes] containsObject:[URL scheme]]) return NO;
    if ([self invalidHosts] && [[self invalidHosts] containsObject:[URL host]]) return NO;
    if ([self invalidPorts] && [[self invalidPorts] containsObject:[URL port]]) return NO;
    
    if ([self validSchemes] && ![[self validSchemes] containsObject:[URL scheme]]) return NO;
    if ([self validHosts] && ![[self validHosts] containsObject:[URL host]]) return NO;
    if ([self validPorts] && ![[self validPorts] containsObject:[URL port]]) return NO;
    
    return YES;
}

- (void)_async:(dispatch_block_t)block {
    if (dispatch_get_specific(_queueTag)) block();
    else dispatch_async(self.queue, block);
}

- (void)_sync:(dispatch_block_t)block {
    if (dispatch_get_specific(_queueTag)) block();
    else dispatch_sync(self.queue, block);
}

#pragma mark - public

- (BOOL)openURL:(NSURL *)URL arguments:(NSDictionary *)arguments output:(id *)output error:(NSError **)error queueLabel:(const char *)queueLabel {
    NSParameterAssert(URL);
    
    __block NSDictionary *_arguments = arguments;
    __block BOOL state = NO;
    const char *label = dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL);
    
    __weak typeof(self)_self = self;
    [self _sync:^{
        __strong typeof(_self)self = _self;
    
        _arguments = [self _argumentsWithURL:URL baseArguments:_arguments];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wblock-capture-autoreleasing"
        state = [super openURL:URL arguments:_arguments output:output error:error queueLabel:label];
#pragma clang diagnostic pop
        if (!state && error && *error == nil) {
            *error = [NSError errorWithDomain:MDRouterErrorDomain code:MDRouterErrorCodeInvalidURL userInfo:@{NSLocalizedDescriptionKey: @"Failed to redirect invalid URL."} underlyingError:*error];
        }
    }];

    return state;
}

- (void)addAdapter:(id<MDRouterAdapter>)adapter {
    MDSYNC([super addAdapter:adapter];)
}

- (void)addSolution:(id<MDRouterSolution>)solution baseURL:(NSURL *)baseURL {
    MDSYNC([super addSolution:solution baseURL:baseURL];)
}

- (void)removeAdapter:(id<MDRouterAdapter>)adapter {
    MDSYNC([super removeAdapter:adapter];)
}

- (BOOL)removeSolution:(id<MDRouterSolution>)solution baseURL:(NSURL *)baseURL {
    __block BOOL state = NO;
    MDSYNC(state = [super removeSolution:solution baseURL:baseURL];)
    return state;
}

- (void)async:(void (^)(id<MDRouterAdapter> router))block {
    __weak typeof(self)_self = self;
    [self _async:^{
        __strong typeof(_self)self = _self;
        block(self);
    }];
}

@end
