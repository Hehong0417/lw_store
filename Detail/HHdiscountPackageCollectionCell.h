//
//  HHdiscountPackageTabCell.h
//  lw_Store
//
//  Created by User on 2018/6/19.
//  Copyright © 2018年 User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHdiscountPackageCollectionCell : UICollectionViewCell

@property(strong,nonatomic) UIImageView *goodImageV;
@property(strong,nonatomic) UILabel *priceLabel;
@property(strong,nonatomic) UIView *price_bottom_view;

@property (nonatomic, strong)   HHPackagesProductsModel *packagesProducts_model;

@end
