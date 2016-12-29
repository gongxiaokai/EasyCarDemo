//
//  CarModel.h
//  EasycarDemo
//
//  Created by gongwenkai on 2016/12/25.
//  Copyright © 2016年 gongwenkai. All rights reserved.
//

#import <Foundation/Foundation.h>

//车类型
typedef NS_ENUM(NSInteger, CarType) {
    CarTypeNone = -1,        //默认大头针
    CarTypeDaily,           //日租
    CarTypeHourly,          //时租
    CarTypeLong,            //长租
    CarTypeTestDrive,       //试驾
};

@interface CarModel : NSObject
@property(nonatomic,strong)NSDictionary *location;      //经纬度
@property(nonatomic,assign)NSString *carType;             //车类型
@property(nonatomic,copy)NSString *carName;             //车名称
@property(nonatomic,copy)NSString *price;               //价格
@property(nonatomic,copy)NSString *distance;            //与用户的距离
@property(nonatomic,copy)NSString *locationName;        //当前位置名
@property(nonatomic,copy)NSString *imageName;           //车图片
@property(nonatomic,copy)NSString *order;               //订单
@property(nonatomic,copy)NSString *banDay;              //限行


- (instancetype)initWithCarModelDict:(NSDictionary*)dict;
+ (instancetype)carModelWithDict:(NSDictionary*)ditc;
@end
