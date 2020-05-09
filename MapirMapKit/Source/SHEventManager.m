//
//  EventManager.m
//  MapirMapKit
//
//  Created by Alireza Asadi on 15/2/1399 AP.
//  Copyright © 1399 AP Map. All rights reserved.
//

#import "SHEventManager.h"
#import "SHURLProtocol.h"
#import "SHStyle.h"

@interface SHEventManager()

@property(nonatomic, strong) NSURLSession *session;

@end

@implementation SHEventManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        [NSNotificationCenter.defaultCenter addObserver:self
                                               selector:@selector(applicationWillEnterForeground:)
                                                   name:UIApplicationWillEnterForegroundNotification
                                                 object:nil];

        NSURLSessionConfiguration *sessionConf = NSURLSessionConfiguration.defaultSessionConfiguration;
        NSMutableArray *classes = [sessionConf.protocolClasses mutableCopy];
        [classes insertObject:[SHURLProtocol class] atIndex:0];
        sessionConf.protocolClasses = classes;

        _session = [NSURLSession sessionWithConfiguration:sessionConf];
    }
    return self;
}

- (void)sendLoadEventForStyle:(NSURL *)styleURL
{

    NSURL *url;
    if (styleURL == SHStyle.hyrcaniaStyleURL) {
        url = [NSURL URLWithString:@"https://map.ir/shiveh/load"];
    }
    else {
        url = [NSURL URLWithString:@"https://map.ir/vector/load"];
    }

    NSURLSessionDataTask *task = [self.session dataTaskWithURL:url];
    [task resume];

}

- (void)applicationWillEnterForeground:(NSNotification *)notif
{
    [self sendLoadEventForStyle:self.mapView.styleURL];
}

- (void)dealloc
{
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

@end
