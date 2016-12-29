//
//  CarInfoCollectionView.h
//  EasycarDemo
//
//  Created by gongwenkai on 2016/12/28.
//  Copyright © 2016年 gongwenkai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarModel.h"

@protocol CarInfoCollectionViewDelegate <NSObject>

- (void)selectItemArray:(NSArray*)array WithIndex:(NSInteger)index;

@end

@interface CarInfoCollectionView : UICollectionView

@property (nonatomic,strong)NSMutableArray<CarModel*> *carModelArray;
@property (nonatomic,strong)id<CarInfoCollectionViewDelegate> delegate2;

@end
