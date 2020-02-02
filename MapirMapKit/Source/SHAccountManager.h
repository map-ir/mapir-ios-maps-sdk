//
//  SHAccountManager.h
//  MapirMapKit
//
//  Created by Alireza Asadi on 23/9/1398 AP.
//  Copyright © 1398 AP Map. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Provides global access to Map.oir API key.
///
/// You can add, edit or update your API key using methods of this class. Not using
/// an API key or using an Invalid one, will cause the map to not load.
@interface SHAccountManager : NSObject

/// Contains Map.ir API key.
///
/// At first it contains API key from Info.plist (If it is available.) If you insert
/// an API key using `SHMapView` initializer, it overrides the existing value of
/// this property.
@property (class, nullable) NSString *apiKey;

/// Indicates the authorization status of your Map.ir API key.
///
/// This property is set to `true` once a new API key is assigned to `apiKey`
/// property. it will not be updated until a 401 (Unauthorized) HTTP status code is
/// received.
@property (class, readonly) BOOL isAuthorized;

/// Name of the notification published if 401 (Unauthorized) HTTP status code is
/// received. Once a 401 (Unauthorized) HTTP status code is received, a notification
/// named `"UnauthorizedAPIKeyNotification"` will be posted. You can either observe
/// it or not.
@property (class, readonly, strong, nonnull) NSNotificationName unauthorizedNotification;

@end

NS_ASSUME_NONNULL_END
