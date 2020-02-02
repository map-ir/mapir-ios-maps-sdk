//
//  SHURLProtocol.m
//  MapirMapKit
//
//  Created by Alireza Asadi on 23/9/1398 AP.
//  Copyright © 1398 AP Map. All rights reserved.
//

#import "SHURLProtocol.h"

/// Notification name for internal unathorized api key.
NSString * const SHUnauthorizedAPIKeyInternalNotification = @"UnauthorizedAPIKeyInternalNotification";

@interface SHURLProtocol ()

@property (class, nonatomic, strong, readonly) NSString *sdkIdentifier;
@property (class, nonatomic, strong, readonly) NSString *userAgent;
@property (class, nonatomic, readonly) NSURLSession *session;

@property (nonatomic, strong) NSURLSessionTask *activeTask;

@end

@implementation SHURLProtocol

static NSString *_sdkIdentifer = nil;
static NSString *_userAgent = nil;
static NSURLSession *_session = nil;

+ (NSURLSession *)session
{
    if (_session == nil)
    {
        _session = [NSURLSession sessionWithConfiguration:NSURLSessionConfiguration.ephemeralSessionConfiguration];
    }

    return _session;
}

+ (NSString *)sdkIdentifier
{
    if (_sdkIdentifer == nil)
    {
        NSMutableArray *sdkIdentifierComponents = [NSMutableArray array];

        NSString *systemName = @"Darwin";
#if TARGET_OS_IPHONE
        systemName = @"iOS";
#elif TARGET_OS_MAC
        systemName = @"macOS";
#elif TARGET_OS_WATCH
        systemName = @"watchOS";
#elif TARGET_OS_TV
        systemName = @"tvOS";
#endif
#if TARGET_OS_SIMULATOR
        systemName = [systemName stringByAppendingString:@" Simulator"];
#endif
        NSString *systemVersion = nil;
        if ([NSProcessInfo instancesRespondToSelector:@selector(operatingSystemVersion)]) {
            NSOperatingSystemVersion osVersion = [NSProcessInfo processInfo].operatingSystemVersion;
            systemVersion = [NSString stringWithFormat:@"%ld.%ld.%ld",
                             (long)osVersion.majorVersion, (long)osVersion.minorVersion, (long)osVersion.patchVersion];
        }
        NSString *osString;
        if (systemVersion) {
            osString = [NSString stringWithFormat:@"%@/%@", systemName, systemVersion];
        }

        NSString *cpu = nil;
#if TARGET_CPU_X86
        cpu = @"x86";
#elif TARGET_CPU_X86_64
        cpu = @"x86_64";
#elif TARGET_CPU_ARM
        cpu = @"arm";
#elif TARGET_CPU_ARM64
        cpu = @"arm64";
#endif
        if (cpu) {
            [osString stringByAppendingFormat:@"(%@)", cpu];
        }
        if (osString)
        {
            [sdkIdentifierComponents addObject:osString];
        }

        NSBundle *sdkBundle = [NSBundle bundleForClass:[SHURLProtocol class]];
        if (sdkBundle)
        {
            NSString *sdkName = sdkBundle.infoDictionary[@"CFBundleName"];
            if (!sdkName)
            {
                sdkName = sdkBundle.infoDictionary[@"CFBundleIdnetifier"];
            }
            NSString *version = sdkBundle.infoDictionary[@"CFBundleShortVersionString"];
            [sdkIdentifierComponents addObject:[NSString stringWithFormat:@"%@/%@", sdkName, version]];
        }

        NSBundle *appBundle = [NSBundle mainBundle];
        if (appBundle) {
            NSString *appName = appBundle.infoDictionary[@"CFBundleName"];
            if (!appName)
            {
                appName = appBundle.infoDictionary[@"CFBundleIdentifier"];
            }
            NSString *version = appBundle.infoDictionary[@"CFBundleShortVersionString"];
            [sdkIdentifierComponents addObject:[NSString stringWithFormat:@"%@/%@", appName, version]];
        } else {
            [sdkIdentifierComponents addObject:[NSProcessInfo processInfo].processName];
        }

        _sdkIdentifer = [sdkIdentifierComponents componentsJoinedByString:@"-"];
    }
    return _sdkIdentifer;
}

+ (NSString *)userAgent
{

    if (_userAgent == nil)
    {
        NSMutableArray *userAgentComponents = [NSMutableArray array];

        NSBundle *appBundle = [NSBundle mainBundle];
        if (appBundle) {
            NSString *appName = appBundle.infoDictionary[@"CFBundleName"];
            if (!appName)
            {
                appName = appBundle.infoDictionary[@"CFBundleIdentifier"];
            }
            NSString *version = appBundle.infoDictionary[@"CFBundleShortVersionString"];
            [userAgentComponents addObject:[NSString stringWithFormat:@"%@/%@", appName, version]];
        } else {
            [userAgentComponents addObject:[NSProcessInfo processInfo].processName];
        }

        NSBundle *sdkBundle = [NSBundle bundleForClass:[SHURLProtocol class]];
        if (sdkBundle)
        {
            NSString *sdkName = sdkBundle.infoDictionary[@"CFBundleName"];
            if (!sdkName)
            {
                sdkName = sdkBundle.infoDictionary[@"CFBundleIdnetifier"];
            }
            NSString *version = sdkBundle.infoDictionary[@"CFBundleShortVersionString"];
            [userAgentComponents addObject:[NSString stringWithFormat:@"%@/%@", sdkName, version]];
        }

        // Avoid %s here because it inserts hidden bidirectional markers on macOS when the system
        // language is set to a right-to-left language.

        NSString *systemName = @"Darwin";
#if TARGET_OS_IPHONE
        systemName = @"iOS";
#elif TARGET_OS_MAC
        systemName = @"macOS";
#elif TARGET_OS_WATCH
        systemName = @"watchOS";
#elif TARGET_OS_TV
        systemName = @"tvOS";
#endif
#if TARGET_OS_SIMULATOR
        systemName = [systemName stringByAppendingString:@" Simulator"];
#endif
        NSString *systemVersion = nil;
        if ([NSProcessInfo instancesRespondToSelector:@selector(operatingSystemVersion)]) {
            NSOperatingSystemVersion osVersion = [NSProcessInfo processInfo].operatingSystemVersion;
            systemVersion = [NSString stringWithFormat:@"%ld.%ld.%ld",
                             (long)osVersion.majorVersion, (long)osVersion.minorVersion, (long)osVersion.patchVersion];
        }
        if (systemVersion) {
            [userAgentComponents addObject:[NSString stringWithFormat:@"%@/%@", systemName, systemVersion]];
        }

        NSString *cpu = nil;
#if TARGET_CPU_X86
        cpu = @"x86";
#elif TARGET_CPU_X86_64
        cpu = @"x86_64";
#elif TARGET_CPU_ARM
        cpu = @"arm";
#elif TARGET_CPU_ARM64
        cpu = @"arm64";
#endif
        if (cpu) {
            [userAgentComponents addObject:[NSString stringWithFormat:@"(%@)", cpu]];
        }

        _userAgent = [userAgentComponents componentsJoinedByString:@" "];

    }
    return _userAgent;
}

+ (BOOL)canInitWithTask:(NSURLSessionTask *)task
{
    return [SHURLProtocol canInitWithRequest:task.currentRequest];
}

+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^([a-zA-Z0-9-]+\\.)*map.ir$" options:NSRegularExpressionCaseInsensitive error:&error];
    NSString *host = request.URL.host;
    if (error != nil)
    {
        return false;
    }
    if ([regex numberOfMatchesInString:host options:NSMatchingWithTransparentBounds range:NSMakeRange(0, host.length)])
    {
        return true;
    }
    return false;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
{
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    [mutableRequest setValue:SHAccountManager.apiKey forHTTPHeaderField:@"x-api-key"];
    [mutableRequest setValue:SHURLProtocol.sdkIdentifier forHTTPHeaderField:@"MapIr-SDK"];
    [mutableRequest setValue:SHURLProtocol.userAgent forHTTPHeaderField:@"User-Agent"];
    return mutableRequest;
}

- (void)startLoading
{
    __weak typeof(self) weakSelf = self;
    self.activeTask = [SHURLProtocol.session dataTaskWithRequest:self.request
                                               completionHandler:^(NSData * _Nullable data,
                                                                   NSURLResponse * _Nullable response,
                                                                   NSError * _Nullable error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf)
        {
            if (error)
            {
                [strongSelf.client URLProtocol:strongSelf didFailWithError:error];
            }
            if (response)
            {
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                if (httpResponse)
                {
                    if (httpResponse.statusCode == 401)
                    {
                        [NSNotificationCenter.defaultCenter postNotification:[NSNotification notificationWithName:SHUnauthorizedAPIKeyInternalNotification
                                                                                                           object:nil
                                                                                                         userInfo:nil]];
                    }
                }
                [strongSelf.client URLProtocol:strongSelf didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageAllowed];
            }
            if (data)
            {
                [strongSelf.client URLProtocol:strongSelf didLoadData:data];
            }

            [strongSelf.client URLProtocolDidFinishLoading:strongSelf];
        }
    }];
    [self.activeTask resume];
}

- (void)stopLoading
{
    if (self.activeTask)
    {
        [self.activeTask cancel];
    }
    self.activeTask = nil;
}


@end
