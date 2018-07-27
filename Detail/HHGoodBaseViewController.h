//
//  HHGoodBaseViewController.h
//  Store
//
//  Created by User on 2018/1/5.
//  Copyright © 2018年 User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHGoodBaseViewController : UIViewController

@property(nonatomic,strong) NSString *Id;

/* 通知 */
@property (weak ,nonatomic) id dcObj;

/* 删除加入购物车和立即购买的通知 */
@property (weak ,nonatomic) id deleteDcObj;


@end
