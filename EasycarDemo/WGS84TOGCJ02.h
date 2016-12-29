//
//  WGS84TOGCJ02.h
//  EasycarDemo
//
//  Created by gongwenkai on 2016/12/28.
//  Copyright © 2016年 gongwenkai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface WGS84TOGCJ02 : NSObject
+(CLLocationCoordinate2D)transformFromWGSToGCJ:(CLLocationCoordinate2D)wgsLoc;
@end
