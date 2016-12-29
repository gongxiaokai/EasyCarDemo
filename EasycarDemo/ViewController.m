//
//  ViewController.m
//  EasycarDemo
//
//  Created by gongwenkai on 2016/12/24.
//  Copyright © 2016年 gongwenkai. All rights reserved.
//

#import "ViewController.h"
#import "MapView.h"
#import "CustomSlider.h"
#import "CarInfoCollectionView.h"
#import "MyAnnotation.h"


@interface ViewController ()<MapViewDelegate,CarInfoCollectionViewDelegate>
@property(nonatomic,strong)CarInfoCollectionView *collectionView;
@property(nonatomic,strong)MapView *mapView;
@property(nonatomic,strong)CustomSlider *carPickView;


@end

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height


@implementation ViewController

- (CarInfoCollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(kScreenWidth * 0.85, kScreenHeight*0.2);
        layout.minimumLineSpacing = kScreenWidth * 0.05;
        
        CGFloat referenceWidth = (kScreenWidth - layout.itemSize.width - 2*layout.minimumLineSpacing)/2 + layout.minimumLineSpacing;
        
        layout.headerReferenceSize = CGSizeMake(referenceWidth, 0);
        layout.footerReferenceSize = CGSizeMake(referenceWidth, 0);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[CarInfoCollectionView alloc] initWithFrame:CGRectMake(0, kScreenHeight*0.8, self.view.frame.size.width, kScreenHeight*0.2) collectionViewLayout:layout];
        _collectionView.hidden = YES;
        _collectionView.delegate2 = self;

    }
    return _collectionView;
}

- (MapView *)mapView {
    if (!_mapView) {
        _mapView = [[MapView alloc] initWithFrame:self.view.bounds];
        _mapView.delegate = self;
    }
    return _mapView;
}

- (CustomSlider *)carPickView {
    if (!_carPickView) {
        _carPickView = [[CustomSlider alloc] initWithFrame:CGRectMake(0, kScreenHeight*0.8, kScreenWidth, kScreenHeight*0.2)];
        _carPickView.backgroundColor = [UIColor whiteColor];
        _carPickView.sliderBarHeight = 10;
        _carPickView.numberOfPart = 4;
        _carPickView.partColor = [UIColor grayColor];
        _carPickView.sliderColor = [UIColor grayColor];
        _carPickView.thumbImage = [UIImage imageNamed:@"yuanxing.png"];
        _carPickView.partNameOffset = CGPointMake(0, -30);
        _carPickView.thumbSize = CGSizeMake(50, 50);
        _carPickView.partSize = CGSizeMake(20, 20);
        _carPickView.partNameArray = @[@"日租",@"时租",@"长租",@"试驾"];
        [_carPickView addTarget:self action:@selector(valuechange:) forControlEvents:UIControlEventValueChanged];
    }
    return  _carPickView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];

    [self.view addSubview:self.mapView];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.carPickView];
    [self valuechange:self.carPickView];
}


- (void)valuechange:(CustomSlider*)sender {
    NSLog(@"%ld",(long)sender.value);
    self.mapView.carModelArray = [self selectCarWithType:sender.value];
    NSLog(@"%@",self.mapView.carModelArray);
}

- (NSMutableArray<CarModel*> *) selectCarWithType:(CarType)type {
    NSMutableArray *resultArray = [NSMutableArray array];
    //读取数据
    NSString *path = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"plist"];
    NSArray *array = [NSArray arrayWithContentsOfFile:path];

    //存数据
    for (NSDictionary *dict in array) {
        CarModel *model = [CarModel carModelWithDict:dict];
        if ([model.carType intValue] == type) {
            [resultArray addObject:model];
        }
    }
    return resultArray;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//collectionview 滚动结束后 调用
- (void)selectItemArray:(NSArray *)array WithIndex:(NSInteger)index {
    
    MyAnnotation *an = self.mapView.annotationArray[index];
    [self.mapView.map selectAnnotation:an animated:YES];
    
}

#pragma mark - mapViewDelegate
//点击地图没有点到大头针
- (void)didSelectMapWithoutAnnotation {
    self.carPickView.hidden = NO;
    self.collectionView.hidden = YES;
}

//点到大头针
- (void)didSelectMapAnnotationViewWithCarArray:(NSMutableArray<CarModel *> *)carArray WithIndex:(NSInteger)index {
    
    self.collectionView.carModelArray = carArray;
    NSLog(@"cararraycoutn =  %lu",(unsigned long)carArray.count);
    //跳转到选择的车辆信息
    [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];

    
    //出现车辆信息动画
    self.carPickView.hidden = YES;
    self.collectionView.hidden = NO;
    
}
@end
