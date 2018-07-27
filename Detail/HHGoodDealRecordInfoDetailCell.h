//
//  HHGoodDealRecordInfoDetailCell.h
//  Store
//
//  Created by User on 2018/1/5.
//  Copyright © 2018年 User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHGoodDealRecordInfoDetailCell : UITableViewCell

@property(nonatomic,strong) HHHomeModel *model;
@property (weak, nonatomic) IBOutlet UILabel *user_nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *skuLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *finish_dateLabel;
@property (weak, nonatomic) IBOutlet UIView *scoreSuperView;

@end
