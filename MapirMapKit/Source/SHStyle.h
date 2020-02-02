//
//  SHStyle.h
//  MapirMapKit
//
//  Created by Alireza Asadi on 23/9/1398 AP.
//  Copyright © 1398 AP Map. All rights reserved.
//

#import <Mapbox/Mapbox.h>

NS_ASSUME_NONNULL_BEGIN

/// Contains styles of Map.ir map.
@interface SHStyle : MGLStyle

/// Verna is Map's default vector style. this returns url for Verna style.
///
/// Map.ir default style is the main vector-based map style created by Map.ir team.
///
/// To read more about `SHStyle` class, see [`MGLStyle` at Mapbox
/// references](https://docs.mapbox.com/ios/api/maps/5.6.0/Classes/MGLStyle.html).
///
/// @warning The url provided by this property may change in the future releases of
/// the framwork.
@property (class, nonatomic, readonly) NSURL *vernaStyleURL;

/// Isatis is Map's default vector style with less POI icons on the map. this returns url for Isatis style.
///
/// Map.ir default style is the main vector-based map style created by Map.ir team.
/// This version of default style has less POI icons on the map.
///
/// To read more about `SHStyle` class, see [`MGLStyle` at Mapbox
/// references](https://docs.mapbox.com/ios/api/maps/5.6.0/Classes/MGLStyle.html).
///
/// @warning The url provided by this property may change in the future releases of
/// the framwork.
@property (class, nonatomic, readonly) NSURL *isatisStyleURL;

/// Carmania is Map's default dark vector style. this returns url for Carmania style.
///
/// Map.ir dark style is the vector-based dark map style created by Map.ir team.
///
/// To read more about `SHStyle` class, see [`MGLStyle` at Mapbox
/// references](https://docs.mapbox.com/ios/api/maps/5.6.0/Classes/MGLStyle.html).
///
/// @warning The url provided by this property may change in the future releases of
/// the framwork.
@property (class, nonatomic, readonly) NSURL *carmaniaStyleURL;

/// Verna is Map's default raster style. this returns url for Hircania style.
///
/// Map.ir raster style is created by Map.ir team. It is not recommended to use this
/// style over vector style.
///
/// To read more about `SHStyle` class, see [`MGLStyle` at Mapbox
/// references](https://docs.mapbox.com/ios/api/maps/5.6.0/Classes/MGLStyle.html).
///
/// @warning The url provided by this property may change in the future releases of
/// the framwork.
@property (class, nonatomic, readonly) NSURL *hyrcaniaStyleURL;

@end

NS_ASSUME_NONNULL_END
