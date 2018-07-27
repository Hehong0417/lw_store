//
//  HHdiscountPackageView.h
//  lw_Store
//
//  Created by User on 2018/6/19.
//  Copyright © 2018年 User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHdiscountPackageView : UIView

@property(nonatomic,strong)UICollectionView *collectionView;

@property (nonatomic, strong)   NSArray <HHPackagesProductsModel *>*PackagesProducts_models;

@end
