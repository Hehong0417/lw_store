//
//  HHGuess_you_likeView.m
//  lw_Store
//
//  Created by User on 2018/7/12.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHGuess_you_likeView.h"
#import "HXHomeCollectionCell.h"
#import "HHGoodBaseSubVC.h"

@implementation HHGuess_you_likeView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, frame.size.height) collectionViewLayout:layout];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        self.collectionView.backgroundColor = kWhiteColor;
        self.collectionView.showsHorizontalScrollIndicator = NO;
        self.collectionView.showsVerticalScrollIndicator = NO;
        
        [self addSubview:_collectionView];
        
        [self.collectionView registerNib:[UINib nibWithNibName:@"HXHomeCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"HXHomeCollectionCell"];

    }
    return self;
}

- (UICollectionView *)collectionView {
    
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:[[UICollectionViewFlowLayout alloc]init]];
    }
    return _collectionView;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.guess_you_like_arrs.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((SCREEN_WIDTH - 30)/2 , 220);
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HXHomeCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HXHomeCollectionCell" forIndexPath:indexPath];
    HHGuess_you_likeModel *model =  [HHGuess_you_likeModel mj_objectWithKeyValues:self.guess_you_like_arrs[indexPath.row]];
    cell.guess_you_likeModel = model;
    return cell;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0, 10, 0,10);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
        
    HHGuess_you_likeModel *model =  [HHGuess_you_likeModel mj_objectWithKeyValues:self.guess_you_like_arrs[indexPath.row]];

    HHGoodBaseSubVC *vc = [HHGoodBaseSubVC new];
    vc.Id = model.pid;
    
    [self.nav pushVC:vc];
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    
        return  CGSizeMake(10,220);
}

@end
