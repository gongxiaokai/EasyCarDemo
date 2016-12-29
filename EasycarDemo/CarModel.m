//
//  CarModel.m
//  EasycarDemo
//
//  Created by gongwenkai on 2016/12/25.
//  Copyright © 2016年 gongwenkai. All rights reserved.
//

#import "CarModel.h"

@implementation CarModel
- (instancetype)initWithCarModelDict:(NSDictionary*)dict {
    self = [super init];
    if (self) {
        //KVC 字典转模型
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)carModelWithDict:(NSDictionary*)ditc {
    return [[CarModel alloc] initWithCarModelDict:ditc];
}
@end
