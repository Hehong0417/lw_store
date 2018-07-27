//
//  HHDetailGoodReferralCell.m
//  Store
//
//  Created by User on 2018/1/5.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHDetailGoodReferralCell.h"

@implementation HHDetailGoodReferralCell

- (void)setGooodDetailModel:(HHgooodDetailModel *)gooodDetailModel{

    _gooodDetailModel = gooodDetailModel;
    
    self.product_nameLabel.text = gooodDetailModel.ProductName;
    self.product_min_priceLabel.text = [NSString stringWithFormat:@"¥ %@",gooodDetailModel.BuyPrice?gooodDetailModel.BuyPrice:@""];
    NSMutableAttributedString *newPrice = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%@",gooodDetailModel.MarketPrice]];
    [newPrice addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, newPrice.length)];
    self.product_s_intergralLabel.attributedText = newPrice;
    self.package_lab.text = gooodDetailModel.StrFreightModey;

}
@end
