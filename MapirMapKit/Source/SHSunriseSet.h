//
//  SHSunriseSet.h
//  MapirMapKit
//
//  Created by Alireza Asadi on 24/10/1398 AP.
//  Copyright © 1398 AP Map. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Foundation/Foundation.h>

#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Either turn on ARC for the project or use -fobjc-arc flag in this file.
#endif

@interface SHSunriseSet : NSObject

@property (readonly, strong) NSDate *date;
@property (readonly, strong) NSDate *sunset;
@property (readonly, strong) NSDate *sunrise;
@property (readonly, strong) NSDate *civilTwilightStart;
@property (readonly, strong) NSDate *civilTwilightEnd;
@property (readonly, strong) NSDate *nauticalTwilightStart;
@property (readonly, strong) NSDate *nauticalTwilightEnd;
@property (readonly, strong) NSDate *astronomicalTwilightStart;
@property (readonly, strong) NSDate *astronomicalTwilightEnd;

@property (readonly, strong) NSDateComponents* localSunrise;
@property (readonly, strong) NSDateComponents* localSunset;
@property (readonly, strong) NSDateComponents* localCivilTwilightStart;
@property (readonly, strong) NSDateComponents* localCivilTwilightEnd;
@property (readonly, strong) NSDateComponents* localNauticalTwilightStart;
@property (readonly, strong) NSDateComponents* localNauticalTwilightEnd;
@property (readonly, strong) NSDateComponents* localAstronomicalTwilightStart;
@property (readonly, strong) NSDateComponents* localAstronomicalTwilightEnd;


-(instancetype)initWithDate:(NSDate*)date timezone:(NSTimeZone*)timezone latitude:(double)latitude longitude:(double)longitude NS_DESIGNATED_INITIALIZER;
+(instancetype)sunrisesetWithDate:(NSDate*)date timezone:(NSTimeZone*)timezone latitude:(double)latitude longitude:(double)longitude;
-(instancetype) init __attribute__((unavailable("init not available. Use initWithDate:timeZone:latitude:longitude: instead")));

@end
