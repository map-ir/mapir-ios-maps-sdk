//
//  SHSunManager.h
//  MapirMapKit
//
//  Created by Alireza Asadi on 29/10/1398 AP.
//  Copyright © 1398 AP Map. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "SHSunriseSet.h"

@class SHSunManager;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, SHSunState) {
    SHSunStateBelowHorizon = 0,
    SHSunStateOverHorizon = 1
};

@protocol SHSunManagerDelegate <NSObject>

@required
- (void)sunManager:(SHSunManager *)sunManager sunStateChangedToState:(SHSunState)sunState;

@end


@interface SHSunManager : NSObject

@property (nonatomic, assign, readonly) BOOL isRunning;

@property (nonatomic, assign, readonly) SHSunState sunState;

@property (nonatomic, strong, readwrite) CLLocation *location;

@property (nonatomic, weak) id<SHSunManagerDelegate> delegate;

- (instancetype)initWithLocation:(CLLocation *)location;

- (void)start;
- (void)stop;


@end

NS_ASSUME_NONNULL_END
