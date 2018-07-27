//
//  HHdiscountPackageTabCell.m
//  lw_Store
//
//  Created by User on 2018/6/19.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHdiscountPackageCollectionCell.h"

@implementation HHdiscountPackageCollectionCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        self.goodImageV = [UIImageView new];
        self.goodImageV.image = [UIImage imageNamed:@"icon1"];
        self.goodImageV.contentMode = UIViewContentModeScaleToFill;
        
        self.priceLabel = [UILabel new];
        self.priceLabel.textColor = kBlackColor;
        self.priceLabel.font = FONT(13);
        
        self.price_bottom_view = [UIView new];
        self.price_bottom_view.backgroundColor = kWhiteColor;
        self.price_bottom_view.alpha = 0.5;
        
        [self addSubview:self.goodImageV];
        [self addSubview:self.price_bottom_view];
        [self addSubview:self.priceLabel];
        
        [self setConstraint];
        
    }
    return self;
}
- (void)setConstraint{
    
    self.goodImageV.sd_layout
    .leftSpaceToView(self, 0)
    .topSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .bottomSpaceToView(self, 0);
    
    self.price_bottom_view.sd_layout
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .bottomSpaceToView(self, 0)
    .heightIs(20);
    
    self.priceLabel.sd_layout
    .leftSpaceToView(self, 0)
    .rightSpaceToView(self, 0)
    .bottomSpaceToView(self, 0)
    .heightIs(20);
    
}
- (void)setPackagesProducts_model:(HHPackagesProductsModel *)packagesProducts_model{
    
    _packagesProducts_model = packagesProducts_model;
    [self.goodImageV sd_setImageWithURL:[NSURL URLWithString:packagesProducts_model.Image] placeholderImage:[UIImage imageNamed:@"loadImag_default100"]];
    self.priceLabel.text = [NSString stringWithFormat:@"  ¥%@",packagesProducts_model.Price];
}
@end
