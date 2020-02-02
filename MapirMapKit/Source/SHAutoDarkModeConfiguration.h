//
//  SHAutoDarkModeConfiguration.h
//  MapirMapKit
//
//  Created by Alireza Asadi on 28/10/1398 AP.
//  Copyright © 1398 AP Map. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHStyle.h"

NS_ASSUME_NONNULL_BEGIN

@interface SHAutoDarkModeConfiguration : NSObject <NSCopying>

/// Style URL for light style.
@property (nonatomic, strong, readonly) NSURL *lightStyleURL;

/// Style URL for dark style.
@property (nonatomic, strong, readonly) NSURL *darkStyleURL;

/// Location of the user.
///
/// Location is used to calculate sunset/surise times to automate style change.
@property (nonatomic, strong, readonly) CLLocation *location;

/// Default configuration of auto dark mode feature.
@property (class, nonatomic, strong, readonly) SHAutoDarkModeConfiguration *defaultConfiguration;

/// Creates a default configuration considering the new location.
+ (SHAutoDarkModeConfiguration *)defaultConfigurationWithLocation:(CLLocation *)location;

/// Initializes an auto dark mode configuration with specified light style and dark
/// style and location.
- (instancetype)initWithLightStyleURL:(NSURL *)lightStyleURL
                         darkStyleURL:(NSURL *)darkStyleURL
                             location:(CLLocation *)location;

/// Convienience initializer to create a configuration using a coordinate instead of
/// location object. See `initWithLightStyleURL:darkStyleURL:location:` for more.
- (instancetype)initWithLightStyleURL:(NSURL *)lightStyleURL
                         darkStyleURL:(NSURL *)darkStyleURL
                           coordinate:(CLLocationCoordinate2D)coordinate;

@end

NS_ASSUME_NONNULL_END
