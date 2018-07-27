//
//  HHGuess_you_likeTabCell.h
//  lw_Store
//
//  Created by User on 2018/7/12.
//  Copyright © 2018年 User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHGuess_you_likeTabCell : UITableViewCell

@property (nonatomic, strong)   NSArray *guess_you_like_arr;

@property(nonatomic,strong)UINavigationController *nav;
/* 通知 */
@property (weak ,nonatomic) id dcObj;

@end
