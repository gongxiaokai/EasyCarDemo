//
//  CarInfoCollectionViewCell.m
//  EasycarDemo
//
//  Created by gongwenkai on 2016/12/28.
//  Copyright © 2016年 gongwenkai. All rights reserved.
//

#import "CarInfoCollectionViewCell.h"

@interface CarInfoCollectionViewCell()
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UIImageView *carImageView;
@property (weak, nonatomic) IBOutlet UILabel *carNameLab;
@property (weak, nonatomic) IBOutlet UILabel *carDistanceLab;
@property (weak, nonatomic) IBOutlet UILabel *banDayLab;
@property (weak, nonatomic) IBOutlet UILabel *locationLab;
@property (weak, nonatomic) IBOutlet UILabel *orderLab;

@end

@implementation CarInfoCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setupData {
    switch ([_model.carType integerValue]) {
        case CarTypeDaily:
            _priceLab.text = [NSString stringWithFormat:@"%@/天",_model.price];
            break;
        case CarTypeHourly:
            _priceLab.text = [NSString stringWithFormat:@"%@/时",_model.price];
            break;
        case CarTypeLong:
            _priceLab.text = [NSString stringWithFormat:@"%@/月",_model.price];
            break;
        case CarTypeTestDrive:
            _priceLab.text = [NSString stringWithFormat:@"%@/次",_model.price];
            break;
        default:
            break;
    }
    
    _carNameLab.text = _model.carName;
    _locationLab.text = _model.locationName;
    _carDistanceLab.text = _model.distance;
    _carImageView.image = [UIImage imageNamed:_model.imageName];
    
    _orderLab.text = [NSString stringWithFormat:@"%@接单",_model.order];
    _banDayLab.text = [NSString stringWithFormat:@"%@限行",_model.banDay];
    
    
    if (_model.banDay != nil) {
        _banDayLab.layer.cornerRadius = 10;
        _banDayLab.layer.borderWidth = 1;
        _banDayLab.layer.borderColor = [UIColor cyanColor].CGColor;
        _banDayLab.tintColor = [UIColor cyanColor];
    }
    
    _orderLab.layer.cornerRadius = 10;
    _orderLab.layer.borderWidth = 1;
    _orderLab.layer.borderColor = [UIColor cyanColor].CGColor;
    _orderLab.tintColor = [UIColor cyanColor];
}

- (void)setModel:(CarModel *)model {
    _model = model;
    [self setupData];
   
}
@end
