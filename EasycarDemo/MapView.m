//
//  MapView.m
//  EasycarDemo
//
//  Created by gongwenkai on 2016/12/24.
//  Copyright © 2016年 gongwenkai. All rights reserved.
//

#import "MapView.h"
#import <CoreLocation/CoreLocation.h>
#import "MyAnnotation.h"
#import "WGS84TOGCJ02.h"


@interface MapView()<CLLocationManagerDelegate,MKMapViewDelegate>
@property (nonatomic,strong)CLLocationManager *locationManager;
@property (nonatomic,strong)UIButton *currentLocationBtn;
@property (nonatomic,strong)UIButton *zoomInBtn; //放大
@property (nonatomic,strong)UIButton *zoomOutBtn;//缩小
@property (nonatomic,strong)MyAnnotation *userLocationAnnotation;
@property (nonatomic,assign)int scale;
@end

@implementation MapView

//初始化
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.carModelArray = [NSMutableArray array];
        [self loadingMapInfo];
        [self addSubview:self.map];
        [self addSubview:self.currentLocationBtn];
        [self addSubview:self.zoomInBtn];
        [self addSubview:self.zoomOutBtn];
    }
    return self;
}

//地图视图
-(MKMapView *)map {
    if (!_map) {
        _map = [[MKMapView alloc] initWithFrame:self.bounds];
        _map.delegate = self;

      
    }
    return _map;
}

//大头针数组
- (NSMutableArray *)annotationArray {
    if (!_annotationArray) {
        _annotationArray  = [NSMutableArray array];
    }
    return _annotationArray;
}

//定位管理
-(CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        
    }
    return _locationManager;
}

//定位
- (UIButton *)currentLocationBtn {
    if (!_currentLocationBtn) {
        _currentLocationBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame)*0.6, 50, 50)];
        [_currentLocationBtn setImage:[UIImage imageNamed:@"location_my.png"] forState:UIControlStateNormal];
        [_currentLocationBtn addTarget:self action:@selector(clickCurrentBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _currentLocationBtn;
}
//点击定位
- (void)clickCurrentBtn {
    [self.map deselectAnnotation:self.userLocationAnnotation animated:NO];
    [self.map selectAnnotation:self.userLocationAnnotation animated:YES];
}
//放大
- (UIButton *)zoomInBtn {
    if (!_zoomInBtn) {
        _zoomInBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)-60, CGRectGetHeight(self.frame)*0.55, 50, 50)];
        [_zoomInBtn setImage:[UIImage imageNamed:@"zoomin.png"] forState:UIControlStateNormal];
        [_zoomInBtn addTarget:self action:@selector(mapZoomIn) forControlEvents:UIControlEventTouchUpInside];
    }
    return _zoomInBtn;
}
//放大方法
- (void)mapZoomIn {
    MKCoordinateRegion region = self.map.region;
    region.span.latitudeDelta = region.span.latitudeDelta * 0.5;
    region.span.longitudeDelta = region.span.longitudeDelta * 0.5;
    [self.map setRegion:region animated:YES];
}

//缩小
- (UIButton *)zoomOutBtn {
    if (!_zoomOutBtn) {
        _zoomOutBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)-60, CGRectGetMaxY(self.zoomInBtn.frame), 50, 50)];
        [_zoomOutBtn setImage:[UIImage imageNamed:@"zoomout.png"] forState:UIControlStateNormal];
        [_zoomOutBtn addTarget:self action:@selector(mapZoomOut) forControlEvents:UIControlEventTouchUpInside];
    }
    return _zoomOutBtn;
}

//缩小方法
- (void)mapZoomOut {
    MKCoordinateRegion region = self.map.region;
    region.span.latitudeDelta = region.span.latitudeDelta * 2;
    region.span.longitudeDelta = region.span.longitudeDelta * 2;
    [self.map setRegion:region animated:YES];
}

//set方法
- (void)setCarModelArray:(NSMutableArray<CarModel *> *)carModelArray {
    
    for (MyAnnotation *an in self.map.annotations) {
        if (an.type != CarTypeNone) {
            [self.map removeAnnotation:an];
        }
    }
    [_carModelArray removeAllObjects];
    _carModelArray = carModelArray;
    
    //重新加载数据
    [self loadData];
}

//加载模拟数据
- (void)loadData {

    [self.annotationArray removeAllObjects];
    //完善model数据
    for (CarModel *model in self.carModelArray) {
        CLGeocoder *coder = [[CLGeocoder alloc] init];
        //model中的位置
        CLLocation *location = [[CLLocation alloc] initWithLatitude:[model.location[@"lat"] doubleValue] longitude:[model.location[@"long"] doubleValue]];
        //反地理编码 获得 经纬度 对应的 地名 并计算与当前位置的距离
        [coder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            CLPlacemark *mark = [placemarks firstObject];
            CLLocationCoordinate2D locatio = [WGS84TOGCJ02 transformFromWGSToGCJ:self.locationManager.location.coordinate];
            CLLocation *currentLocation =  [[CLLocation alloc] initWithLatitude:locatio.latitude longitude:locatio.longitude];
            CLLocationDistance dis = [location distanceFromLocation:currentLocation];
            
            model.locationName = mark.name;
            model.distance = [NSString stringWithFormat:@"%.2fkm",dis/1000];
        }];
    }
    
    int count = 0;
    //加载大头针
    for (CarModel *model in self.carModelArray) {
        
        MyAnnotation *annotation = [[MyAnnotation alloc] init];
        CLLocationCoordinate2D location = CLLocationCoordinate2DMake([model.location[@"lat"] doubleValue], [model.location[@"long"] doubleValue]);
        annotation.coordinate = location;
        annotation.index = count;
        annotation.type = [model.carType intValue];
        [self.map addAnnotation:annotation];
        [self.annotationArray addObject:annotation];
        count++;
    }
}

//当前位置大头针
- (MyAnnotation *)userLocationAnnotation {
    if (!_userLocationAnnotation) {
        _userLocationAnnotation = [[MyAnnotation alloc] init];
        _userLocationAnnotation.type = CarTypeNone;
        //转火星坐标
        CLLocationCoordinate2D currentLocation = [WGS84TOGCJ02 transformFromWGSToGCJ:self.locationManager.location.coordinate];
        _userLocationAnnotation.coordinate = currentLocation;
        _userLocationAnnotation.title = @"我的位置";
    }
    return _userLocationAnnotation;
}
//加载地图相关信息
- (void)loadingMapInfo {
    //获得授权
    [self getAuthorization];
  
    //设置当前位置的大头针
    [self.map addAnnotation:self.userLocationAnnotation];
    [self.map selectAnnotation:self.userLocationAnnotation animated:YES];
}



//自定义MKAnnotationView
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    
    MyAnnotation *an = (MyAnnotation*)annotation;
    //用户位置的定位大头针不变
    if (an.type == CarTypeNone) {
        return [self customLocalAnnotationView:annotation];
    }
    
    switch (an.type) {
        case CarTypeNone:
            return [self customLocalAnnotationView:annotation];
            break;
        default:
            //自定义大头针
            return [self customMKAnnotationView:annotation];
            break;
    }
    
    return nil;
}

//当前位置大头针
- (MKPinAnnotationView*)customLocalAnnotationView:(id<MKAnnotation>)annotation {
    static NSString *locationID = @"locationViewID";
    //从缓存池中获取大头针
    MKPinAnnotationView *pinView = ( MKPinAnnotationView *)[self.map dequeueReusableAnnotationViewWithIdentifier:locationID];
    if (pinView == nil) {
        pinView  = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:locationID];
    }
    pinView.annotation = annotation;
    // 取消气泡显示
    pinView.canShowCallout = YES;
    // 设置大头针是否有下落动画
    pinView.animatesDrop = YES;
    return pinView;
    
}


//自定义大头针
- (MKAnnotationView*)customMKAnnotationView:(id<MKAnnotation>)annotation {
    //自定义大头针
    static NSString *carViewID = @"carViewID";
    //从缓存池中获取自定义大头针
    MKAnnotationView *annoView = [self.map dequeueReusableAnnotationViewWithIdentifier:carViewID];
    if (annoView == nil) {
        //缓存池中没有则创建
        annoView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:carViewID];
    }
    annoView.annotation = annotation;
    annoView.canShowCallout = NO;
    annoView.draggable = YES;
    annoView.image = [self getCarImageWithTypeInAnnotation:annotation];
    return annoView;
}

//根据大头针的类型返回图片
- (UIImage *)getCarImageWithTypeInAnnotation:(MyAnnotation*)annotation {
    switch (annotation.type) {
        case CarTypeDaily:
            return  [UIImage imageNamed:@"dailycar.png"];
            break;
        case CarTypeHourly:
            return [UIImage imageNamed:@"hourlycar.png"];
            break;
        case CarTypeLong:
            return [UIImage imageNamed:@"longcar.png"];
            break;
        case CarTypeTestDrive:
            return [UIImage imageNamed:@"testcar.png"];
            break;
        default:
            break;
    }
    return nil;
}


#pragma mark - MKMapViewDelegate
//点击大头针
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    //重置汽车原来的颜色
    NSArray *array = [mapView annotations];
    for (MyAnnotation *an in array) {
        MKAnnotationView *v = [mapView viewForAnnotation:an];
        if ([v.reuseIdentifier isEqualToString:@"carViewID"]) {
            v.image = [self getCarImageWithTypeInAnnotation:an];
        }
    }
    //点击小车换颜色
    if ([view.reuseIdentifier isEqualToString:@"carViewID"]) {
        view.image = [UIImage imageNamed:@"pickcar.png"];
        
        //代理回调 通知界面 将 carInfoView 出现 carPickView消失
        if ([self.delegate respondsToSelector:@selector(didSelectMapAnnotationViewWithCarArray:WithIndex:)]) {
            [self.delegate didSelectMapAnnotationViewWithCarArray:self.carModelArray WithIndex:((MyAnnotation*)view.annotation).index];
        }
        //设置中心点和范围
        [self.map setRegion:MKCoordinateRegionMakeWithDistance(((MyAnnotation*)view.annotation).coordinate, 2000, 2000) animated:NO];

    }
    else {
        [self.map setRegion:MKCoordinateRegionMakeWithDistance(self.userLocationAnnotation.coordinate, 2000, 2000) animated:YES];
    }

    

    
}

//没有选中大头针
- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    //重置汽车原来的颜色
    NSArray *array = [mapView annotations];
    for (MyAnnotation *an in array) {
        MKAnnotationView *v = [mapView viewForAnnotation:an];
        if ([v.reuseIdentifier isEqualToString:@"carViewID"]) {
            v.image = [self getCarImageWithTypeInAnnotation:an];
        }
    }
    
    if ([view.reuseIdentifier isEqualToString:@"carViewID"]) {
        //代理回调 通知界面 将 carInfoView 消失 carPickView出现 小车变为未选中
        if ([self.delegate respondsToSelector:@selector(didSelectMapWithoutAnnotation)]) {
            [self.delegate didSelectMapWithoutAnnotation];
        }
    }
    

}

//获取授权
- (void)getAuthorization {
    //获取授权状态
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (status == kCLAuthorizationStatusNotDetermined) {
        [self.locationManager requestAlwaysAuthorization];
    } else if (status == kCLAuthorizationStatusAuthorizedAlways) {
        //不跟随用户
        self.map.userTrackingMode = MKUserTrackingModeNone;
    }
}

//授权后进入
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    
    //授权后开始定位
    [self.locationManager startUpdatingLocation];
    //加载地图信息
    [self loadData];

    [self loadingMapInfo];
    
}


//位置更新
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    NSLog(@"位置更新！");
    //停止更新
    [manager stopUpdatingLocation];
    
}


@end
