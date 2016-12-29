//
//  CustomSlider.h
//  EasycarDemo
//
//  Created by gongwenkai on 2016/12/26.
//  Copyright © 2016年 gongwenkai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomSlider : UIControl

//当前值
@property (nonatomic,assign)NSInteger value;
//选择点个数 >2
@property (nonatomic,assign)NSInteger numberOfPart;
//当前滑块颜色
@property (nonatomic,assign)UIColor *thumbColor;
//当前滑块图片
@property (nonatomic,strong)UIImage *thumbImage;
//当前滑块尺寸
@property (nonatomic,assign)CGSize thumbSize;
//分段点尺寸
@property (nonatomic,assign)CGSize partSize;
//slider height
@property (nonatomic,assign)CGFloat sliderBarHeight;
//分段点的颜色
@property (nonatomic,assign)UIColor *partColor;
//slider 滑竿颜色
@property (nonatomic,assign)UIColor *sliderColor;
//分段名
@property (nonatomic,strong)NSArray<NSString*> *partNameArray;
//分段名偏移位置 初始在slider上
@property (nonatomic,assign)CGPoint partNameOffset;

@end
