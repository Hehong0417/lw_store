//
//  HHdiscountPackageFooter.m
//  lw_Store
//
//  Created by User on 2018/6/20.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHdiscountPackageFooter.h"

@implementation HHdiscountPackageFooter

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        UIImageView *imageV = [[UIImageView alloc] init];
        imageV.image = [UIImage imageNamed:@"and"];
        imageV.contentMode = UIViewContentModeCenter;

        [self addSubview:imageV];
        imageV.sd_layout
        .leftSpaceToView(self, 0)
        .rightSpaceToView(self, 0)
        .topSpaceToView(self, 0)
        .bottomSpaceToView(self, 0);
    }
    return self;
}

@end
