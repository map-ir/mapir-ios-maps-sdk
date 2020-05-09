//
//  EventManager.h
//  MapirMapKit
//
//  Created by Alireza Asadi on 15/2/1399 AP.
//  Copyright © 1399 AP Map. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SHMapView.h"

NS_ASSUME_NONNULL_BEGIN

@interface SHEventManager : NSObject

@property(nonatomic, weak) SHMapView* mapView;

- (void)sendLoadEventForStyle:(NSURL *)styleURL;

@end

NS_ASSUME_NONNULL_END
