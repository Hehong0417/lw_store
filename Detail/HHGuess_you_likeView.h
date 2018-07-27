//
//  HHGuess_you_likeView.h
//  lw_Store
//
//  Created by User on 2018/7/12.
//  Copyright © 2018年 User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHGuess_you_likeView : UIView<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(nonatomic,strong)UICollectionView *collectionView;

@property (nonatomic, strong)   NSArray *guess_you_like_arrs;

@property(nonatomic,strong) UINavigationController *nav;


@end
