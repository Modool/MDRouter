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

NSString * const MDRouterErrorDomain    = @"com.bilibili.link.router.error.domain";

@interface MDRouterSet ()

@end

@implementation MDRouterSet
@dynamic baseURL;

+ (instancetype)router;{
    return [self routerWithBaseURL:nil];
}

+ (instancetype)routerWithBaseURL:(NSURL *)baseURL;{
    return [[self alloc] initWithBaseURL:baseURL];
}

- (instancetype)initWithBaseURL:(NSURL *)baseURL{
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
    }
    return self;
}

#pragma mark - accessor

- (void)setValidSchemes:(NSSet<NSString *> *)validSchemes{
    if (_validSchemes != validSchemes) {
        _validSchemes = [self invalidSchemes] ? [validSchemes setByMinusSet:[self invalidSchemes]] : validSchemes;
    }
}

- (void)setInvalidSchemes:(NSSet<NSString *> *)invalidSchemes{
    if (_invalidSchemes != invalidSchemes) {
        _invalidSchemes = [self validSchemes] ? [invalidSchemes setByMinusSet:[self validSchemes]]: invalidSchemes;
    }
}

- (void)setValidHosts:(NSSet<NSString *> *)validHosts{
    if (_validHosts != validHosts) {
        _validHosts = [self invalidHosts] ? [validHosts setByMinusSet:[self validHosts]]: validHosts;
    }
}

- (void)setInvalidHosts:(NSSet<NSString *> *)invalidHosts{
    if (_invalidHosts != invalidHosts) {
        _invalidHosts = [self validHosts] ? [invalidHosts setByMinusSet:[self validHosts]]: invalidHosts;
    }
}

- (void)setValidPorts:(NSSet<NSNumber *> *)validPorts{
    if (_validPorts != validPorts) {
        _validPorts = [self invalidPorts] ? [validPorts setByMinusSet:[self validPorts]]: validPorts;
    }
}

- (void)setInvalidPorts:(NSSet<NSNumber *> *)invalidPorts{
    if (_invalidPorts != invalidPorts) {
        _invalidPorts = [self validPorts] ? [invalidPorts setByMinusSet:[self validPorts]]: invalidPorts;
    }
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

#pragma mark - public

- (BOOL)openURL:(NSURL *)URL arguments:(NSDictionary *)arguments output:(id *)output error:(NSError **)error;{
    NSParameterAssert(URL);

    arguments = [self _argumentsWithURL:URL baseArguments:arguments];
    
    BOOL state = [super openURL:URL arguments:arguments output:output error:error];
    if (!state && error && *error == nil) {
        *error = [NSError errorWithDomain:MDRouterErrorDomain code:MDRouterErrorCodeInvalidURL userInfo:@{NSLocalizedDescriptionKey: @"Failed to redirect invalid URL."} underlyingError:*error];
    }
    return state;
}

@end
