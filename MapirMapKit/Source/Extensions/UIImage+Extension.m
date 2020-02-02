//
//  UIImage+Extension.m
//  MapirMapKit
//
//  Created by Alireza Asadi on 23/9/1398 AP.
//  Copyright © 1398 AP Map. All rights reserved.
//

#import "UIImage+Extension.h"
#import "SHMapView.h"

@implementation UIImage (Extensions)

+ (UIImage *)imageInCurrentBundleNamed:(NSString *)imageName
         compatibleWithTraitCollection:(nullable UITraitCollection *)traitCollection;
{
    NSBundle *sdkBundle = [NSBundle bundleForClass:[SHMapView class]];
    return [UIImage imageNamed:imageName inBundle:sdkBundle compatibleWithTraitCollection:traitCollection];
}

@end
