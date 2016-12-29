//
//  MapView.h
//  EasycarDemo
//
//  Created by gongwenkai on 2016/12/24.
//  Copyright © 2016年 gongwenkai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "CarModel.h"

@protocol MapViewDelegate <NSObject>

//点击地图没有点到大头针
- (void)didSelectMapWithoutAnnotation;
//点到大头针
- (void)didSelectMapAnnotationViewWithCarArray:(NSMutableArray<CarModel *>*)carArray WithIndex:(NSInteger)index;

@end





@interface MapView : UIView

@property(nonatomic,strong)id<MapViewDelegate> delegate;
@property (nonatomic,strong)MKMapView *map;
//大头针数组
@property (nonatomic,strong)NSMutableArray *annotationArray;
//car数据模型数组
@property (nonatomic,strong)NSMutableArray<CarModel *> *carModelArray;

@end
