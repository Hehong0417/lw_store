//
//  HHGoodBaseSubVC.m
//  lw_Store
//
//  Created by User on 2018/7/13.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHGoodBaseSubVC.h"

@interface HHGoodBaseSubVC ()

@end

@implementation HHGoodBaseSubVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    
    [[NSNotificationCenter defaultCenter]removeObserver:self.dcObj];

}

@end
//拼接url：http://dm-order-api.elevo.cn/api/ShopCart/Create?sku=10243585_10243672_10243682&quantity=1
//------------请求成功：------------
//<HHCartAPI: 0x1c0e61ec0>
//{
//    Msg = "没找到对应的条目";
//    State = "-1";
//}
