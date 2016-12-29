//
//  CustomSlider.m
//  EasycarDemo
//
//  Created by gongwenkai on 2016/12/26.
//  Copyright © 2016年 gongwenkai. All rights reserved.
//

#import "CustomSlider.h"

@interface CustomSlider()
@property(nonatomic,assign)CGRect thumbRect;    //滑块fram
@property(nonatomic,assign)CGRect sliderRect;   //sliderFrame
@property(nonatomic,strong)NSMutableArray *partRectArray; //节点frame数组
@property(nonatomic,assign)BOOL isFirst;        //首次运行
@property(nonatomic,strong)NSDictionary *textAttributesDict;//文本字体信息
@end

@implementation CustomSlider


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.value = 0;
        self.partRectArray = [NSMutableArray array];
        self.numberOfPart = 2;
        self.sliderBarHeight = 20;
        self.thumbSize = CGSizeMake(self.sliderBarHeight, self.sliderBarHeight);
        self.partNameOffset = CGPointZero;
        self.partSize = self.thumbSize;
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
    return self;
}

//节点必须>1
- (void)setNumberOfPart:(NSInteger)numberOfPart {
    _numberOfPart = numberOfPart > 1 ? numberOfPart: 2;
}


//设置文本属性
- (NSDictionary*)textAttributesDict {
    if (!_textAttributesDict) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        
        dict[NSForegroundColorAttributeName] = [UIColor blackColor]; // 文字颜色
        dict[NSFontAttributeName] = [UIFont systemFontOfSize:14]; // 字体

        _textAttributesDict = dict;
    }
    return _textAttributesDict;
}

//重绘
- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();

    //画slider
    [self loadSliderWithContext:context];
    
    //画滑块
    [self loadThumWithContext:context];


}

//画滑块
- (void)loadThumWithContext:(CGContextRef)context {

    //当前滑块
    if (!self.isFirst) {
        //滑块初始化
        self.thumbRect = [self.partRectArray[0] CGRectValue];
        self.isFirst = YES;
    }
    
    //有背景图则用背景图 没有就画圆
    if (self.thumbImage) {
        [self.thumbImage drawInRect: self.thumbRect];
    } else {
        CGContextAddEllipseInRect(context, self.thumbRect);
        [self.thumbColor set];
        CGContextFillPath(context);
    }
    
}

//画滑杆内容
- (void)loadSliderWithContext:(CGContextRef)context {
    //设置滑杆的frame
    CGFloat tmp = self.thumbSize.width > self.partSize.width ? self.thumbSize.width :  self.partSize.width;
    CGFloat tmpHeight = self.thumbSize.height > self.partSize.height ? self.thumbSize.height :  self.partSize.height;
    
    CGFloat sliderHeight = self.sliderBarHeight;
    CGFloat sliderMargin = sliderHeight/2 + tmp/2;
    CGFloat sliderY = CGRectGetHeight(self.frame)/2;
    CGFloat sliderWidth = CGRectGetWidth(self.frame) - 2 * sliderMargin - tmp;
    self.sliderRect = CGRectMake(sliderMargin + self.partSize.width/2, sliderY-tmpHeight/2, sliderWidth+tmp, tmpHeight);
    
    
    //画slider滑杆
    CGPoint starPoint = CGPointMake(sliderMargin + tmp/2, sliderY);
    CGPoint endPoint = CGPointMake(CGRectGetWidth(self.frame)-sliderMargin- tmp/2, sliderY);
    CGContextMoveToPoint(context, starPoint.x, starPoint.y);
    CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
    CGContextSetLineWidth(context, sliderHeight); // 线的宽度
    CGContextSetLineCap(context, kCGLineCapRound); // 起点和重点圆角
    CGContextSetStrokeColorWithColor(context, self.sliderColor.CGColor);
    CGContextStrokePath(context);
    
    //画分段点
    CGFloat partPointWidth = self.partSize.width;
    CGFloat partPointHeight = self.partSize.height;
    CGFloat y = CGRectGetHeight(self.frame)/2 - self.partSize.height/2;
    
    [self.partRectArray removeAllObjects];
    
    for (int i = 0; i < self.numberOfPart; i++) {
        
        CGFloat x = i * sliderWidth/(self.numberOfPart-1) + starPoint.x-partPointWidth/2 ;
        
        CGContextAddEllipseInRect(context, CGRectMake(x, y, partPointWidth, partPointHeight));
        [self.partColor set];
        CGContextFillPath(context);
        
        //计算滑块位置
        CGRect fram = CGRectMake(x+partPointWidth/2-self.thumbSize.width/2, y+partPointHeight/2-self.thumbSize.height/2, self.thumbSize.width, self.thumbSize.height);
        
        [self.partRectArray addObject:[NSValue valueWithCGRect:fram]];
        
    }
    
    //画分段点名称
    for (int i = 0; i < self.partNameArray.count; i++) {
        NSString *partName = self.partNameArray[i];
        
        CGRect parRect = [self.partRectArray[i] CGRectValue];
        
        //根据字体属性 计算出size
        CGSize size = [partName sizeWithAttributes:self.textAttributesDict];
        
        CGFloat nameX = parRect.origin.x + parRect.size.width/2 - size.width/2 + self.partNameOffset.x;
        
        CGFloat nameY = parRect.origin.y + self.partNameOffset.y;
        
        CGRect nameFrame = CGRectMake(nameX, nameY, size.width, size.height) ;
        [partName drawInRect:nameFrame withAttributes:self.textAttributesDict];
        
    }

}


//开始拖动
- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(nullable UIEvent *)event {
    CGPoint point = [touch locationInView:self];
    
    //可滑动范围
    if (!CGRectContainsPoint(self.sliderRect, point)) {
        return NO;
    }
    
    int index = [self getCurrentXWithOffset:point.x];
    self.thumbRect = [self.partRectArray[index] CGRectValue];
    [self setNeedsDisplay];

    return YES;
    
}


//持续拖动
- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(nullable UIEvent *)event {
    
    CGPoint point = [touch locationInView:self];
    
    CGFloat thumbImageX = point.x - self.thumbSize.width/2;
    self.thumbRect = CGRectMake(thumbImageX, self.thumbRect.origin.y, self.thumbRect.size.width, self.thumbRect.size.height);
    [self setNeedsDisplay];
    

    
    return YES;

}

//拖动结束
- (void)endTrackingWithTouch:(nullable UITouch *)touch withEvent:(nullable UIEvent *)event {
    CGPoint point = [touch locationInView:self];

    int index = [self getCurrentXWithOffset:point.x];
    self.thumbRect = [self.partRectArray[index] CGRectValue];
    [self setNeedsDisplay];
    NSLog(@"point = %f",point.x);
    //增加控制事件
    [self sendActionsForControlEvents:UIControlEventValueChanged];

}

//计算滑到一半时根据占比选择对应位置
- (int)getCurrentXWithOffset:(CGFloat)x {

    CGFloat tmpX = x - [self.partRectArray[0] CGRectValue].origin.x;
    //超出边界
    if (tmpX > [self.partRectArray[self.numberOfPart-1] CGRectValue].origin.x) {
        tmpX = [self.partRectArray[self.numberOfPart-1] CGRectValue].origin.x;
    }
    
    //计算总长度
    CGFloat firstx = [[self.partRectArray firstObject] CGRectValue].origin.x;
    CGFloat lastx = [[self.partRectArray lastObject] CGRectValue].origin.x;
    CGFloat wid = lastx - firstx;
    CGFloat part = wid/(self.numberOfPart-1) ;
    //减去滑块占比
    CGFloat per = self.thumbSize.width/2/part;
    
    int count = tmpX / part - per + 0.5;
    self.value = count;
    return count;
}

@end
