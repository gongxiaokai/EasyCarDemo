//
//  CarInfoCollectionView.m
//  EasycarDemo
//
//  Created by gongwenkai on 2016/12/28.
//  Copyright © 2016年 gongwenkai. All rights reserved.
//

#import "CarInfoCollectionView.h"
#import "CarInfoCollectionViewCell.h"



@interface CarInfoCollectionView()<UICollectionViewDelegate,UICollectionViewDataSource>

@end

static NSString *identifier = @"collectionViewCell";

@implementation CarInfoCollectionView

-(void)setCarModelArray:(NSMutableArray<CarModel *> *)carModelArray {
    _carModelArray = carModelArray;
    [self reloadData];
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = [UIColor clearColor];
        [self registerNib:[UINib nibWithNibName:@"CarInfoCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:identifier];
    }
    return self;
}



#pragma mark - datasource
//itme个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.carModelArray.count;
}


//item内容
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CarInfoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[CarInfoCollectionViewCell alloc] init];
    }
    cell.model = self.carModelArray[indexPath.item];
    return cell;
}



//停下的位置
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout*)self.collectionViewLayout;
    //实际滑动的距离
    float pageWidth = layout.itemSize.width + layout.minimumLineSpacing;
    //当前位置
    float currentOffset = scrollView.contentOffset.x;
    //目标位置
    float targetOffset = targetContentOffset->x;
    float newTargetOffset = 0;
    int count = 0;
    
    if (targetOffset > currentOffset) {
        //向上取整
        count = ceilf(currentOffset / pageWidth);
        newTargetOffset = ceilf(currentOffset / pageWidth) * pageWidth;

    }else {
        //向下取整
        count = floorf(currentOffset / pageWidth);
        newTargetOffset = floorf(currentOffset / pageWidth) * pageWidth;

    }

    //处理边界
    if (newTargetOffset < 0)
        newTargetOffset = 0;
    else if (newTargetOffset > scrollView.contentSize.width)
        newTargetOffset = scrollView.contentSize.width;
    
    //设置目标位置指针
    targetContentOffset->x = currentOffset;
    
    //跳转新位置
    [scrollView setContentOffset:CGPointMake(newTargetOffset, 0) animated:YES];

    
}


- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout*)self.collectionViewLayout;
    //实际滑动的距离
    int pageWidth = layout.itemSize.width + layout.minimumLineSpacing;
    //当前位置
    int currentOffset = scrollView.contentOffset.x;
    int count = currentOffset / pageWidth;

    NSLog(@"滚完了 %d",count );
    if ([self.delegate2 respondsToSelector:@selector(selectItemArray:WithIndex:)]) {
        [self.delegate2 selectItemArray:self.carModelArray WithIndex:count];
    }
}
@end
