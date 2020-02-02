//
//  SHSunManager.m
//  MapirMapKit
//
//  Created by Alireza Asadi on 29/10/1398 AP.
//  Copyright © 1398 AP Map. All rights reserved.
//

#import "SHSunManager.h"

NSString * const SHSunStateKey = @"IsSunUpKey";


@interface SHSunManager ()

@property (nonatomic, copy, readonly, nullable) NSDate *nextSunriseSunset;

@property (nonatomic, weak) NSTimer *timer;

@end

@implementation SHSunManager

- (instancetype)initWithLocation:(CLLocation *)location
{
    self = [super init];
    if (self) {
        _location = location;

        _sunState = false;
        _nextSunriseSunset = nil;
        _isRunning = false;
    }
    return self;
}

// MARK: Start/Stop

- (void)start
{
    _isRunning = true;

    [self updateNextSunriseSunset];
    [self setupTimer];
}

- (void)stop
{
    _isRunning = false;

    if (self.timer)
    {
        [self.timer invalidate];
    }
}

// MARK: Updating Location

@synthesize location = _location;

- (CLLocation *)location
{
    return _location;
}

- (void)setLocation:(CLLocation *)location
{
    _location = location;
    if (_isRunning)
    {
        [self updateNextSunriseSunset];
        [self setupTimer];
    }
}

// MARK: next sunrise/sunset time

- (void)updateNextSunriseSunset
{
    CLLocationCoordinate2D currentLocation = self.location.coordinate;

    NSDate *now = [NSDate date];
    SHSunriseSet *today = [SHSunriseSet sunrisesetWithDate:now
                                                  timezone:[NSTimeZone defaultTimeZone]
                                                  latitude:currentLocation.latitude
                                                 longitude:currentLocation.longitude];

    SHSunriseSet *tommorow = [SHSunriseSet sunrisesetWithDate:[now dateByAddingTimeInterval:24 * 3600]
                                                     timezone:[NSTimeZone defaultTimeZone]
                                                     latitude:currentLocation.latitude
                                                    longitude:currentLocation.longitude];

    if ([now compare:today.sunrise] == (NSOrderedAscending | NSOrderedSame))
    {
        _sunState = SHSunStateBelowHorizon;
        _nextSunriseSunset = today.sunrise;
    }
    else if ([now compare:today.sunset] == (NSOrderedAscending | NSOrderedSame))
    {
        _sunState = SHSunStateOverHorizon;
        _nextSunriseSunset = today.sunset;
    }
    else
    {
        _sunState = SHSunStateBelowHorizon;
        _nextSunriseSunset = tommorow.sunrise;
    }
}

// MARK: Timer

- (void)setupTimer
{
    if (self.timer)
    {
        [self.timer invalidate];
    }

    NSDictionary *timerInfo = @{
        SHSunStateKey: [NSNumber numberWithUnsignedInteger:self.sunState],
    };

    NSTimer *timer = [[NSTimer alloc] initWithFireDate:self.nextSunriseSunset
                                              interval:0.0
                                                target:self
                                              selector:@selector(timerDidReachFireDate:)
                                              userInfo:timerInfo
                                               repeats:false];

    [NSRunLoop.currentRunLoop addTimer:timer forMode:NSRunLoopCommonModes];
    _timer = timer;
}

- (void)timerDidReachFireDate:(NSTimer *)timer
{
    if (self.isRunning)
    {
        NSDictionary *timerInfo = timer.userInfo;

        SHSunState lastSunState = ((NSNumber *)[timerInfo objectForKey:SHSunStateKey]).unsignedIntegerValue;

        if ([self.delegate respondsToSelector:@selector(sunManager:sunStateChangedToState:)])
        {
            [self.delegate sunManager:self
               sunStateChangedToState:[SHSunManager oppositeSunStateToState:!lastSunState]];
        }

        [timer invalidate];

        [self updateNextSunriseSunset];
        [self setupTimer];
    }
    else
    {
        [timer invalidate];
    }
}

// MARK: Util methods

+ (SHSunState)oppositeSunStateToState:(SHSunState)sunState
{
    return (sunState == SHSunStateOverHorizon) ? SHSunStateBelowHorizon : SHSunStateOverHorizon;
}

@end
