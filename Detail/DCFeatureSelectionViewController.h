//
//  DCFeatureSelectionViewController.h
//  CDDStoreDemo
//
//  Created by apple on 2017/7/12.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DCFeatureSelectionViewController : UIViewController

/* 按钮标题 */
@property (strong , nonatomic)NSString *button_Title;

/* 商品图片 */
@property (strong , nonatomic)NSString *goodImageView;
/* 上一次选择的属性 */
@property (strong , nonatomic)NSMutableArray *lastSeleArray;
/* 上一次选择的属性Id */
@property (strong , nonatomic)NSMutableArray *lastSele_IdArray;

/* 上一次选择的数量 */
@property (assign , nonatomic)NSString *lastNum;

/* 价格 */
@property (assign , nonatomic)NSString *product_price;
/* 库存 */
@property (assign , nonatomic)NSString *product_stock;
/* 商品Id */
@property (assign , nonatomic)NSString *product_id;

//商品规格
@property (strong , nonatomic)NSArray <HHproduct_sku_valueModel *> *product_sku_value_arr;

//用来查询库存和价格
@property (assign , nonatomic)NSArray <HHproduct_skuModel *> *product_sku_arr;


@property (assign , nonatomic)CGFloat nowScreenH;


@property (nonatomic ,strong)NSMutableArray * SKUResult;

@property (nonatomic ,strong)NSMutableArray * skuResult;//!<可匹配规格
@property (nonatomic ,strong)NSMutableArray * seletedIndexPaths;//!<已经选中的规格数组
@property (nonatomic ,strong)NSMutableArray * seletedIdArray;//!<记录已选id
@property (nonatomic ,strong)NSMutableArray * seletedEnable;//!<不可选indexPath

///** 选择的属性和数量 */
//@property (nonatomic , copy) void(^userChooseBlock)(NSMutableArray *seleArray,NSInteger num,NSInteger tag);

@end
