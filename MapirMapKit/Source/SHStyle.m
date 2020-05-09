//
//  SHStyle.m
//  MapirMapKit
//
//  Created by Alireza Asadi on 23/9/1398 AP.
//  Copyright © 1398 AP Map. All rights reserved.
//

#import "SHStyle.h"

@implementation SHStyle

static NSURL *_styleURL_verna = nil;
static NSURL *_styleURL_isatis = nil;
static NSURL *_styleURL_carmania = nil;
static NSURL *_styleURL_hyrcania = nil;

+ (NSURL *)vernaStyleURL
{
    if (!_styleURL_verna)
    {
        _styleURL_verna = [NSURL URLWithString:@"https://map.ir/vector/styles/main/main_mobile_style.json"];
    }
    return _styleURL_verna;
}

+ (NSURL *)isatisStyleURL
{
    if (!_styleURL_isatis)
    {
        _styleURL_isatis = [NSURL URLWithString:@"https://map.ir/vector/styles/main/mapir-style-min-poi.json"];
    }
    return _styleURL_isatis;
}

+ (NSURL *)carmaniaStyleURL
{
    if (!_styleURL_carmania)
    {
        _styleURL_carmania = [NSURL URLWithString:@"https://map.ir/vector/styles/main/mapir-style-dark.json"];
    }
    return _styleURL_carmania;
}

+ (NSURL *)hyrcaniaStyleURL
{
    if (!_styleURL_hyrcania)
    {
        _styleURL_hyrcania = [[NSBundle bundleForClass:[self class]] URLForResource:@"Shiveh" withExtension:@"json"];
    }
    return _styleURL_hyrcania;
}

@end
