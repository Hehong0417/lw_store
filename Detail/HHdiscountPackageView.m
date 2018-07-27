//
//  HHdiscountPackageView.m
//  lw_Store
//
//  Created by User on 2018/6/19.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHdiscountPackageView.h"
#import "HHdiscountPackageCollectionCell.h"
#import "HHdiscountPackageFooter.h"

@interface HHdiscountPackageView ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@end
@implementation HHdiscountPackageView

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
        [self.collectionView registerClass:[HHdiscountPackageCollectionCell class] forCellWithReuseIdentifier:@"HHdiscountPackageCollectionCell"];
        [self.collectionView  registerClass:[HHdiscountPackageFooter class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"HHdiscountPackageFooter"];
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
    
    return self.PackagesProducts_models.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 1;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(80, 80);
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    HHdiscountPackageCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HHdiscountPackageCollectionCell" forIndexPath:indexPath];
    HHPackagesProductsModel *model = self.PackagesProducts_models[indexPath.section];
    cell.packagesProducts_model = model;
    return cell;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(10, 10, 10,10);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
//    HHdiscountPackageCollectionCell *cell = (HHdiscountPackageCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];

}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    
    if (section == self.PackagesProducts_models.count-1) {

    return  CGSizeMake(0,0);
        
    }else{
        return  CGSizeMake(40,100);
    }

}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if(kind == UICollectionElementKindSectionFooter){
        if (indexPath.section == self.PackagesProducts_models.count-1) {
            return [UICollectionReusableView new];
        }else{
        HHdiscountPackageFooter   *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"HHdiscountPackageFooter" forIndexPath:indexPath];
        return footer;
        }
    }else{
       return nil;
    }
}
@end
