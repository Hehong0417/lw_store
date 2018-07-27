//
//  HHGoodDealRecordInfoDetailCell.m
//  Store
//
//  Created by User on 2018/1/5.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHGoodDealRecordInfoDetailCell.h"

@implementation HHGoodDealRecordInfoDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(HHHomeModel *)model{
    
    _model = model;
    self.user_nameLabel.text = model.user_name;
    self.skuLabel.text = model.sku;
    self.finish_dateLabel.text = model.finish_date;
    self.countLabel.text = model.count;
    
}
- (void)layoutSubviews{
    
    //评分
    NSInteger count =  self.model.score.integerValue;
    for (NSInteger i = 0; i<count; i++) {
        UIImageView *score_img = [UIImageView lh_imageViewWithFrame:CGRectMake(i*18, 0, 18, 23) image:[UIImage imageNamed:@"icon_medal_default"] userInteractionEnabled:NO];
        score_img.contentMode = UIViewContentModeCenter;
        [self.scoreSuperView addSubview:score_img];
    }
    
}
@end
