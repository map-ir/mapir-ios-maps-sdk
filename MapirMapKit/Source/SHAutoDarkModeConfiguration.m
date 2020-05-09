//
//  SHAutoDarkModeConfiguration.m
//  MapirMapKit
//
//  Created by Alireza Asadi on 28/10/1398 AP.
//  Copyright © 1398 AP Map. All rights reserved.
//

#import "SHAutoDarkModeConfiguration.h"
#import "SHSunriseSet.h"


@implementation SHAutoDarkModeConfiguration

+ (SHAutoDarkModeConfiguration *)defaultConfiguration
{
    CLLocation *tehran = [[CLLocation alloc] initWithLatitude:35.6892 longitude:51.3890];
    SHAutoDarkModeConfiguration *conf = [[SHAutoDarkModeConfiguration alloc] initWithLightStyleURL:SHStyle.vernaStyleURL
                                                                                      darkStyleURL:SHStyle.carmaniaStyleURL
                                                                                          location:tehran];

    return conf;
}

+ (SHAutoDarkModeConfiguration *)defaultConfigurationWithLocation:(CLLocation *)location
{
    SHAutoDarkModeConfiguration *defaultConfig = SHAutoDarkModeConfiguration.defaultConfiguration;
    SHAutoDarkModeConfiguration *config = [[SHAutoDarkModeConfiguration alloc] initWithLightStyleURL:defaultConfig.lightStyleURL
                                                                                        darkStyleURL:defaultConfig.darkStyleURL
                                                                                            location:location];
    return config;
}

- (instancetype)initWithLightStyleURL:(NSURL *)lightStyleURL
                         darkStyleURL:(NSURL *)darkStyleURL
                             location:(CLLocation *)location
{
    self = [super init];
    if (self) {
        _lightStyleURL = lightStyleURL;
        _darkStyleURL = darkStyleURL;
        _location = location;
    }

    return self;
}

- (instancetype)initWithLightStyleURL:(NSURL *)lightStyleURL
                         darkStyleURL:(NSURL *)darkStyleURL
                           coordinate:(CLLocationCoordinate2D)coordinate
{
    CLLocation *location = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    self = [self initWithLightStyleURL:lightStyleURL darkStyleURL:darkStyleURL location:location];
    return self;
}

- (nonnull id)copyWithZone:(nullable NSZone *)zone {
    return [[SHAutoDarkModeConfiguration alloc] initWithLightStyleURL:self.lightStyleURL
                                                         darkStyleURL:self.darkStyleURL
                                                             location:self.location];
}

@end
