//
//  SHAccountManager.m
//  MapirMapKit
//
//  Created by Alireza Asadi on 23/9/1398 AP.
//  Copyright © 1398 AP Map. All rights reserved.
//

#import "SHAccountManager.h"
#import "SHURLProtocol.h"

@interface SHAccountManager ()

@property (nonatomic) NSString *apiKey;
@property (nonatomic) BOOL isAuthorized;

/// Shared account manager.
@property (class, readonly, strong) SHAccountManager *sharedManager;

@end

@implementation SHAccountManager

+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    static SHAccountManager *_sharedManager;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.isAuthorized = false;
        NSString *apiKey = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"MapirAPIKey"];
        if (!apiKey)
        {
            apiKey = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"MAPIRAccessToken"];
        }
        if (apiKey)
        {
            self.isAuthorized = true;
            self.apiKey = apiKey;
        }

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didReceiveUnauthorizedAPIKey:)
                                                     name:SHUnauthorizedAPIKeyInternalNotification
                                                   object:nil];
    }
    return self;
}

+ (NSString *)apiKey
{
    return SHAccountManager.sharedManager.apiKey;
}

+ (void)setApiKey:(NSString *)apiKey
{
    apiKey = [apiKey stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (!apiKey.length)
    {
        return;
    }

    SHAccountManager.isAuthorized = true;
    SHAccountManager.sharedManager.apiKey = apiKey;
}

+ (BOOL)isAuthorized
{
    return SHAccountManager.sharedManager.isAuthorized;
}

+ (void)setIsAuthorized:(BOOL)isAuthorized
{
    SHAccountManager.sharedManager.isAuthorized = isAuthorized;
}

+ (void)configureAccountWithAPIKey:(NSString *)apiKey
{
    [SHAccountManager setApiKey:apiKey];
}

- (void)didReceiveUnauthorizedAPIKey:(NSNotificationCenter *)notification
{
    if (SHAccountManager.isAuthorized)
    {
        SHAccountManager.isAuthorized = false;
        NSString *description = @"Your Map.ir API key is not valid or you have reached the daily limit of the API key. See <https://map.ir/unauthorized> for more information.";
        NSLog(@"%@", description);

        NSDictionary * userInfo = @{
            NSLocalizedDescriptionKey: @"Unauthorized API key. invalid or no API Key",
            NSLocalizedFailureReasonErrorKey: description,
            @"apiKey": SHAccountManager.apiKey
        };

        NSError *error = [NSError errorWithDomain:@"ir.map.MapirMapKit" code:401 userInfo:userInfo];

        NSNotification *notif = [NSNotification notificationWithName:SHAccountManager.unauthorizedNotification
                                                              object:error
                                                            userInfo:nil];

        [NSNotificationCenter.defaultCenter postNotification:notif];
    }
}

+ (NSNotificationName)unauthorizedNotification
{
    return @"UnauthorizedAPIKeyNotification";
}

- (void)dealloc
{
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

@end
