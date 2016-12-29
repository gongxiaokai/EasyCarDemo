//
//  CarAnnotation.h
//  EasycarDemo
//
//  Created by gongwenkai on 2016/12/24.
//  Copyright © 2016年 gongwenkai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "CarModel.h"



@interface MyAnnotation : NSObject  <MKAnnotation>

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy, nullable) NSString *title;
@property (nonatomic, copy, nullable) NSString *subtitle;
@property (nonatomic, assign) CarType type;
@property (nonatomic, assign) NSInteger index;
@end
