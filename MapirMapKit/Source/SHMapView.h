//
//  SHMapView.h
//  MapirMapKit
//
//  Created by Alireza Asadi on 20/9/1398 AP.
//  Copyright © 1398 AP Map. All rights reserved.
//

#import <Mapbox/Mapbox.h>
#import "SHStyle.h"
#import "SHAutoDarkModeConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

/// Defines different modes of dark mode.
///
/// Default is set to `.off`.
typedef NS_ENUM(NSUInteger, SHAutoDarkMode) {

    /// Auto dark mode turned off.
    SHAutoDarkModeOff = 0,

    /// Auto dark mode updates style at sunrise and sunset automatically.
    SHAutoDarkModeUpdateAutomatically,

    /// Auto dark mode updates style when user switches the device from dark to light UI
    /// style or vise versa.
    ///
    /// @warning Updating with OS works only on iOS 13.0 and above since other versions
    /// don't support dark mode in OS.
    SHAutoDarkModeUpdateWithOS,
};

/// `SHMapView` is an interactive map, providing Map.ir tiles.
///
/// It provides gestures to manipulate the map, with standard gestures like
/// pan. By default it uses Map.ir vector tiles and style for the map, but it can be
/// replaced with Raster style (which is not recommended) through `SHStyle` class.
///
///
/// Using Map.ir tiles and style requires API key. you can create a new one for free
/// at "[Registration website](https://corp.map.ir/registration)".
///
/// In order to receive updates on the mapView, you should specify a delegate class
/// conforming to `MGLMapViewDelegate` using the `SHMapView` instance's `delegate`
/// property.
///
/// You should not remove or update Map.ir and OpenStreetMap attribution text or
/// Map.ir logo from the map.
///
/// See [examples](https://support.map.ir/ios) to learn how to use the map view in
/// your application.
///
/// To create your own custom gesture recoginzers for the map and more info see
/// [`MGLMapView` at Mapbox
/// references](https://docs.mapbox.com/ios/api/maps/5.6.0/Classes/MGLMapView.html).
@interface SHMapView : MGLMapView

/// Contains attribution to Map.ir and OpenStreetMap.
///
/// You should not edit the text or remove it from the view.
@property (nonatomic, readonly) UILabel *attributionLabel;

/// Configuration for auto dark mode feature.
@property (nonatomic, copy, nullable) SHAutoDarkModeConfiguration *autoDarkModeConfiguration;

/// Configuration for auto dark mode feature.
@property (nonatomic, readwrite, assign) SHAutoDarkMode autoDarkMode;

/// initiate a map view class using frame an Map.ir API key.
///
/// API key provided using this initializer overrides the API key from Info.plist.
///
/// @param frame The frame for the view, measured in points. @param apiKey Map.ir
/// API key.
- (instancetype)initWithFrame:(CGRect)frame apiKey:(NSString *)apiKey;

@end

NS_ASSUME_NONNULL_END
