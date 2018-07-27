//
//  HHdiscountPackageViewTabCell.m
//  lw_Store
//
//  Created by User on 2018/6/20.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHGuess_you_likeTabCell.h"
#import "HHGuess_you_likeView.h"

@interface HHGuess_you_likeTabCell()
{
    HHGuess_you_likeView *_guess_you_likeView;
    UIView *_titleView;
    UILabel *_titleLabel;
    UIImageView *_arrpw_imageV;
}
@end
@implementation HHGuess_you_likeTabCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 30)];
        _guess_you_likeView = [[HHGuess_you_likeView alloc] initWithFrame:CGRectMake(0, 45, ScreenW, 220)];
        [self.contentView addSubview:_titleView];
        [self.contentView addSubview:_guess_you_likeView];
        
        _titleLabel = [UILabel lh_labelWithFrame:CGRectMake(15, 0, ScreenW, 45) text:@"————  猜你喜欢  ————" textColor:kBlackColor font:FONT(13) textAlignment:NSTextAlignmentLeft backgroundColor:kClearColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [_titleView addSubview:_titleLabel];
        
    }
    
    return self;
}
- (void)setGuess_you_like_arr:(NSArray *)guess_you_like_arr{
    
    _guess_you_like_arr = guess_you_like_arr;
    
    _guess_you_likeView.guess_you_like_arrs = guess_you_like_arr;
    
    _guess_you_likeView.nav = self.nav;
    [_guess_you_likeView.collectionView reloadData];
}
@end
