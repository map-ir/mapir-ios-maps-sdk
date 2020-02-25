//
//  SHMapViewDelegate.h
//  MapirMapKit
//
//  Created by Alireza Asadi on 6/12/1398 AP.
//  Copyright © 1398 AP Map. All rights reserved.
//

#import <Mapbox/Mapbox.h>
#import "SHMapView.h"

NS_ASSUME_NONNULL_BEGIN

/// The `SHMapViewDelegate` protocol defines a set of optional methods that you can
/// use to receive map-related update messages. Because many map operations require
/// the `MGLMapView` class to load data asynchronously, the map view calls these
/// methods to notify your application when specific operations complete. The map
/// view also uses these methods to request information about annotations displayed
/// on the map, such as the styles and interaction modes to apply to individual
/// annotations.
@protocol SHMapViewDelegate <MGLMapViewDelegate>

@optional

/// Tells the delegate that receiving style or tiles failed due to using
/// unauthorized API key.
///
/// This error happens when the API key is not valid or reached its quota.
///
/// @param mapView the map that failed to load style or tiles.
/// @param error the error that contains details about the failure.
- (void)mapView:(SHMapView *)mapView didReceiveUnauthorizedError:(NSError *)error;

@end

NS_ASSUME_NONNULL_END
