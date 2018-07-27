//
//  HHGoodBaseViewController.m
//  Store
//
//  Created by User on 2018/1/5.
//  Copyright © 2018年 User. All rights reserved.
//

#import "HHGoodBaseViewController.h"
#import <WebKit/WebKit.h>
#import "HHDetailGoodReferralCell.h"
#import "HHGoodSpecificationsCell.h"
#import "HHGoodDealRecordInfoDetailCell.h"
#import "HHAddCartTool.h"
#import "DCFeatureSelectionViewController.h"
#import "XWDrawerAnimator.h"
#import "UIViewController+XWTransition.h"
#import "HHShoppingVC.h"
#import "HHSubmitOrdersVC.h"
#import "HHNotWlanView.h"
#import "HHShopIntroCell.h"
#import "HHEvaluationListCell.h"
#import "HHEvaluationListVC.h"
#import "HHAddAdressVC.h"
#import "HHActivityModel.h"
#import "MLMenuView.h"
#import "CZCountDownView.h"
#import "HHdiscountPackageViewTabCell.h"
#import "HHdiscountPackageVC.h"
#import "HHGuess_you_likeTabCell.h"

@interface HHGoodBaseViewController ()<UITableViewDelegate,UITableViewDataSource,WKNavigationDelegate,SDCycleScrollViewDelegate,HHCartVCProtocol>
{
    UIView *_tableHeader;
    UILabel *_title_label;
    CZCountDownView *countDown;
}
@property (strong, nonatomic) UIScrollView *scrollerView;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) WKWebView *webView;
@property (nonatomic, strong)   SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong)   HHAddCartTool *addCartTool;
@property (nonatomic, strong)   NSMutableArray *discribeArr;
@property (nonatomic, strong)   UILabel *tableFooter;
@property (nonatomic, strong)  NSMutableArray *datas;
@property (nonatomic, strong)  NSMutableArray *evaluations;
@property (nonatomic, strong)  HHgooodDetailModel *gooodDetailModel;
@property (nonatomic, assign)   BOOL status;
@property (nonatomic, strong) UIActivityIndicatorView * activityIndicator;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) NSString *headTitle;
@property (nonatomic, strong) NSString *count;
@property (nonatomic, strong) NSMutableArray *alert_Arr;
@property (nonatomic, strong) NSMutableArray *guess_you_like_arr;
@property (nonatomic, strong) NSNumber *Mode;
@property (nonatomic, strong) UIView *countTimeView;

@end

//cell
static NSString *lastNum_;
static NSArray *lastSeleArray_;
static NSArray *lastSele_IdArray_;

static NSString *HHDetailGoodReferralCellID = @"HHDetailGoodReferralCell";//商品信息
static NSString *HHShopIntroCellID = @"HHShopIntroCell";//店铺简介
static NSString *HHGoodSpecificationsCellID = @"HHGoodSpecificationsCell";//商品规格
static NSString *HHEvaluationListCellID = @"HHEvaluationListCell";
static NSString *HHdiscountPackageViewTabCellID = @"HHdiscountPackageViewTabCell";
static NSString *HHGuess_you_likeTabCellID = @"HHGuess_you_likeTabCell";//猜你喜欢


@implementation HHGoodBaseViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.addCartTool.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"商品详情";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //网络监测
    [self setMonitor];
    
    [self setUpViewScroll];
    
    [self setUpInit];
    
    //获取数据
    [self getDatas];
    
    //加入购物车、立即购买
    [self addCartOrBuyAction];
    
    //接收到通知
    [self acceptanceNote];
    
    //抓取返回按钮
    UIButton *backBtn = (UIButton *)self.navigationItem.leftBarButtonItem.customView;
    [backBtn bk_removeEventHandlersForControlEvents:UIControlEventTouchUpInside];
    [backBtn addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)backBtnAction{
    
    [[NSNotificationCenter defaultCenter]removeObserver:_dcObj];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -网络监测

- (void)setMonitor{
  
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager ] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if(status == 1 || status == 2)
        {
            self.status = NO;
            NSLog(@"有网");
        }else{
            NSLog(@"没有网");
            self.status = YES;
            [self.tableView reloadData];
        }
    }];
}
#pragma mark - 懒加载

- (NSMutableArray *)datas{
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}
- (NSMutableArray *)alert_Arr{
    if (!_alert_Arr) {
        _alert_Arr = [NSMutableArray array];
    }
    return _alert_Arr;
}

- (NSMutableArray *)evaluations{
    if (!_evaluations) {
        _evaluations = [NSMutableArray array];
    }
    return _evaluations;
}
- (NSMutableArray *)discribeArr{
    if (!_discribeArr) {
        _discribeArr = [NSMutableArray array];
    }
    return _discribeArr;
}
- (NSMutableArray *)guess_you_like_arr{
    if (!_guess_you_like_arr) {
        _guess_you_like_arr = [NSMutableArray array];
    }
    return _guess_you_like_arr;
}
#pragma mark - initialize

- (void)setUpInit
{
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    //初始化
    lastSeleArray_ = [NSArray array];
    lastSele_IdArray_ = [NSArray array];
    lastNum_ = 0;
    
    //tableHeaderView
    _tableHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenW)];
    
    UIView *bg_view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 350, 50)];
    bg_view.backgroundColor = [UIColor blackColor];
    _title_label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 50)];
    _title_label.textColor = kWhiteColor;
    _title_label.textAlignment = NSTextAlignmentRight;
    _title_label.text = @"距离活动结束";
    countDown = [CZCountDownView new];
    countDown.frame = CGRectMake(CGRectGetMaxX(_title_label.frame),0, 200, 50);
    countDown.backgroundImageName = @"";
    countDown.timerStopBlock = ^{
        NSLog(@"时间停止");
    };
    [bg_view addSubview:_title_label];
    [bg_view addSubview:countDown];
    [self.countTimeView addSubview:bg_view];
    [_tableHeader addSubview:self.countTimeView];
    bg_view.centerX = self.countTimeView.centerX;
    [_tableHeader addSubview:self.cycleScrollView];

}

#pragma mark - 记载图文详情
- (void)setUpGoodsWKWebView
{
    NSString *content =   [NSString stringWithFormat:@"<style>img{width:100%%;}</style>%@",self.gooodDetailModel.Description];
    [self.webView loadHTMLString:content baseURL:nil];
}

#pragma mark - 接受通知
- (void)acceptanceNote
{
    //删除通知
    _deleteDcObj = [[NSNotificationCenter defaultCenter] addObserverForName:DELETE_SHOPITEMSELECTBACK object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
        [self deleteObj];

    }];
    
    WEAK_SELF();
    //选择Item通知
    _dcObj = [[NSNotificationCenter defaultCenter]addObserverForName:SHOPITEMSELECTBACK object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        
        NSArray *selectArray = note.userInfo[@"Array"];
        NSArray *select_IdArray = note.userInfo[@"id_Array"];
        NSString *num = note.userInfo[@"Num"];
        NSString *buttonTag = note.userInfo[@"Tag"];
        NSString *button_title = note.userInfo[@"button_title"];
        NSString *pid = note.userInfo[@"pid"];

        lastNum_ = num;
        lastSeleArray_ = selectArray;
        lastSele_IdArray_ = select_IdArray;
        
        //更新价格和s积分
        NSString *seleId_str = [NSString stringWithFormat:@"%@_%@",self.gooodDetailModel.Id,[select_IdArray componentsJoinedByString:@"_"]];

        [self.gooodDetailModel.SKUList enumerateObjectsUsingBlock:^(HHproduct_skuModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([obj.Id isEqualToString:seleId_str]) {
                self.gooodDetailModel.BuyPrice = obj.SalePrice;
                [self.tableView reloadData];
            }
        }];
        if ([buttonTag isEqualToString:@"0"]) { //加入购物车

            if ([button_title isEqualToString:@"加入购物车"]) {

           [weakSelf setUpWithAddSuccessWithselect_IdArray:select_IdArray quantity:num pid:pid];
                NSLog(@" 加入购物车");

            }else{
                NSLog(@"参加拼团");

                [weakSelf instanceBuyActionWithselect_IdArray:select_IdArray quantity:num pid:pid];
            }
        }

    }];
    
}
- (void)deleteObj{
    [[NSNotificationCenter defaultCenter]removeObserver:self.dcObj];
}
#pragma mark -加载数据

- (void)getDatas{

    UIView *hudView = [UIView lh_viewWithFrame:CGRectMake(0, 0, ScreenW, ScreenH) backColor:kWhiteColor];
    [self.tableView addSubview:hudView];
    
    
    HHNotWlanView *notAlanView = [[HHNotWlanView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
    [hudView addSubview:notAlanView];
    notAlanView.hidden = YES;
    
    self.activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleGray)];
    self.activityIndicator.frame= CGRectMake(0, 0, 30, 30);
     self.activityIndicator.center = self.tableView.center;
    self.activityIndicator.color = KACLabelColor;
    self.activityIndicator.hidesWhenStopped = YES;
    [hudView addSubview:self.activityIndicator];
    [self.activityIndicator startAnimating];
    self.addCartTool.userInteractionEnabled = NO;
   
    //商品详情
    [[[HHHomeAPI GetProductDetailWithId:self.Id] netWorkClient] getRequestInView:nil finishedBlock:^(HHHomeAPI *api, NSError *error) {
        if (!error) {
            if (api.State == 1) {
                
                self.gooodDetailModel = nil;
                self.gooodDetailModel = [HHgooodDetailModel mj_objectWithKeyValues:api.Data];
                self.cycleScrollView.imageURLStringsGroup = self.gooodDetailModel.ImageUrls;
                self.discribeArr =  self.gooodDetailModel.AttributeValueList.mutableCopy;
                
                [self.tableView reloadData];
                
                [self.activityIndicator stopAnimating];
                [hudView removeFromSuperview];
                self.addCartTool.userInteractionEnabled = YES;

                [self.activityIndicator removeFromSuperview];
                [self tableView:self.tableView viewForHeaderInSection:1];
                
                [self setUpGoodsWKWebView];
                

                //拼团
               HHActivityModel *GroupBy_m = [HHActivityModel mj_objectWithKeyValues:self.gooodDetailModel.GroupBuy];
                //降价团
                HHActivityModel *CutGroupBuy_m = [HHActivityModel mj_objectWithKeyValues:self.gooodDetailModel.CutGroupBuy];
                //送礼
                HHActivityModel *SendGift_m = [HHActivityModel mj_objectWithKeyValues:self.gooodDetailModel.SendGift];
                //砍价
                HHActivityModel *CutPrice_m = [HHActivityModel mj_objectWithKeyValues:self.gooodDetailModel.CutPrice];

                if ([GroupBy_m.IsJoin isEqual:@1]) {
                    
                    [self.alert_Arr addObject:GroupBy_m];
                }
                if ([CutGroupBuy_m.IsJoin isEqual:@1]) {
                    [self.alert_Arr addObject:CutGroupBuy_m];
                }
                if ([SendGift_m.IsJoin isEqual:@1]) {
                    [self.alert_Arr addObject:SendGift_m];
                }
                if ([CutPrice_m.IsJoin isEqual:@1]) {
                    [self.alert_Arr addObject:CutPrice_m];
                }
                
                if (self.alert_Arr.count >0) {
                    self.addCartTool.buyBtn.hidden = NO;
                    self.addCartTool.addCartBtn.mj_w = ScreenW/3;
                }else{
                    self.addCartTool.buyBtn.hidden = YES;
                    self.addCartTool.addCartBtn.mj_w = ScreenW/3*2;
                }
                // 秒杀
                HHActivityModel *SecKill_m = [HHActivityModel mj_objectWithKeyValues:self.gooodDetailModel.SecKill];
                if ([SecKill_m.IsSecKill isEqual:@1]) {
                    self.cycleScrollView.frame = CGRectMake(0, 50, ScreenW, ScreenW);
                    _tableHeader.frame = CGRectMake(0, 0, ScreenW, ScreenW+50);
                    if (SecKill_m.StartSecond.integerValue>0) {
                        _titleLabel.text = @"距离活动开始";
                        countDown.timestamp = SecKill_m.StartSecond.integerValue;
                    }else{
                        _titleLabel.text = @"距离活动结束";
                        countDown.timestamp = SecKill_m.EndSecond.integerValue;
                    }
                }else{
                    self.cycleScrollView.frame = CGRectMake(0, 0, ScreenW, ScreenW);
                    _tableHeader.frame = CGRectMake(0, 0, ScreenW, ScreenW);
                }
                _tableView.tableHeaderView = _tableHeader;

            }else{
                [self.activityIndicator stopAnimating];
                
                [SVProgressHUD showInfoWithStatus:api.Msg];
            }
        }else{
            [self.activityIndicator stopAnimating];
            if ([error.localizedDescription isEqualToString:@"似乎已断开与互联网的连接。"]||[error.localizedDescription  containsString:@"请求超时"]||[error.localizedDescription isEqualToString:@"The Internet connection appears to be offline."]) {
                notAlanView.hidden = NO;
            }else{
                notAlanView.hidden = YES;
                [hudView removeFromSuperview];
                [SVProgressHUD showInfoWithStatus:error.localizedDescription];
            }
        }
    }];
    
    //猜你喜欢
    [self getGuess_you_likeData];
    
}
//猜你喜欢
- (void)getGuess_you_likeData{
    
    [[[HHCategoryAPI GetAlliancesProductsWithpids:self.Id]  netWorkClient] getRequestInView:nil finishedBlock:^(HHCategoryAPI *api, NSError *error) {
        
        if (!error) {
            if (api.State == 1) {
                NSArray *arr =  api.Data;
                self.guess_you_like_arr = arr.mutableCopy;
                [self.tableView reloadData];
            }else{
                [SVProgressHUD showInfoWithStatus:api.Msg];
            }
        }else{
            
        }
    }];
    
}
//编码图片
- (NSString *)htmlForJPGImage:(UIImage *)image
{
    NSData *imageData = UIImageJPEGRepresentation(image,1.0);
    NSString *imageSource = [NSString stringWithFormat:@"data:image/jpg;base64,%@",[imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength]];
    return [NSString stringWithFormat:@"<img src = \"%@\" />", imageSource];
}
#pragma mark - 加入购物车、立即购买
//加入购物车、立即购买
- (void)addCartOrBuyAction{
    
    [self.view addSubview:self.addCartTool];
    
    WEAK_SELF();
    //加入购物车
    self.addCartTool.addCartBlock = ^{
        
            DCFeatureSelectionViewController *dcNewFeaVc = [DCFeatureSelectionViewController new];
            dcNewFeaVc.product_sku_value_arr = weakSelf.gooodDetailModel.SKUValues;
            dcNewFeaVc.lastNum = lastNum_;
            dcNewFeaVc.lastSeleArray = [NSMutableArray arrayWithArray:lastSeleArray_];
            dcNewFeaVc.lastSele_IdArray = [NSMutableArray arrayWithArray:lastSele_IdArray_];
            dcNewFeaVc.product_sku_arr = weakSelf.gooodDetailModel.SKUList;
            dcNewFeaVc.button_Title = @"加入购物车";
            dcNewFeaVc.product_price = weakSelf.gooodDetailModel.BuyPrice;
            dcNewFeaVc.product_id = weakSelf.gooodDetailModel.Id;
        
            dcNewFeaVc.product_stock = weakSelf.gooodDetailModel.Stock;
            if (self.gooodDetailModel.ImageUrls.count>0) {
                dcNewFeaVc.goodImageView = weakSelf.gooodDetailModel.ImageUrls[0];
            }
            CGFloat  distance;
            if (weakSelf.gooodDetailModel.SKUValues.count == 0) {
                distance = ScreenH/2.3;
            }else if (weakSelf.gooodDetailModel.SKUValues.count == 1){
                distance = ScreenH/1.75;
            }else{
                distance = ScreenH*2/3;
            }
            dcNewFeaVc.nowScreenH = distance;
            [weakSelf setUpAlterViewControllerWith:dcNewFeaVc WithDistance:distance WithDirection:XWDrawerAnimatorDirectionBottom WithParallaxEnable:NO WithFlipEnable:NO];
    };
    //立即购买
    self.addCartTool.buyBlock = ^(UIButton *btn) {
        
        MLMenuView *menuView = [[MLMenuView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/3*2, SCREEN_HEIGHT-Status_HEIGHT-49-weakSelf.alert_Arr.count*50, SCREEN_WIDTH/3, weakSelf.alert_Arr.count*50) WithmodelsArr:weakSelf.alert_Arr WithMenuViewOffsetTop:Status_HEIGHT WithTriangleOffsetLeft:80 button:btn];
        
            menuView.isHasTriangle = NO;
            
            menuView.didSelectBlock = ^(NSInteger index, HHActivityModel *model) {
                //属性选择
                DCFeatureSelectionViewController *dcNewFeaVc = [DCFeatureSelectionViewController new];
                dcNewFeaVc.product_sku_value_arr = weakSelf.gooodDetailModel.SKUValues;
                dcNewFeaVc.lastNum = lastNum_;
                dcNewFeaVc.lastSeleArray = [NSMutableArray arrayWithArray:lastSeleArray_];
                dcNewFeaVc.lastSele_IdArray = [NSMutableArray arrayWithArray:lastSele_IdArray_];
                dcNewFeaVc.product_sku_arr = weakSelf.gooodDetailModel.SKUList;
                dcNewFeaVc.product_id = weakSelf.gooodDetailModel.Id;
                
                weakSelf.Mode = model.Mode;
                if ([model.Mode isEqual:@2]) {
                    dcNewFeaVc.button_Title = @"参加拼团";
                }else if ([model.Mode isEqual:@8]){
                    dcNewFeaVc.button_Title = @"送礼";
                }else if ([model.Mode isEqual:@32]){
                    dcNewFeaVc.button_Title = @"参加降价团";
                }else if ([model.Mode isEqual:@4096]){
                    dcNewFeaVc.button_Title = @"砍价";
                }else{
                    dcNewFeaVc.button_Title = @"立即购买";
                }
                dcNewFeaVc.product_price = weakSelf.gooodDetailModel.BuyPrice;
                dcNewFeaVc.product_stock = weakSelf.gooodDetailModel.Stock;
                
                CGFloat  distance;
                if (weakSelf.gooodDetailModel.SKUValues.count == 0) {
                    distance = ScreenH/2.3;
                }else if (weakSelf.gooodDetailModel.SKUValues.count == 1){
                    distance = ScreenH/1.75;
                }else{
                    distance = ScreenH*2/3;
                }
                dcNewFeaVc.nowScreenH = distance;
                
                if (self.gooodDetailModel.ImageUrls.count>0) {
                    dcNewFeaVc.goodImageView = weakSelf.gooodDetailModel.ImageUrls[0];
                }
                
                [weakSelf setUpAlterViewControllerWith:dcNewFeaVc WithDistance:distance WithDirection:XWDrawerAnimatorDirectionBottom WithParallaxEnable:NO WithFlipEnable:NO];
            };
            [menuView showMenuEnterAnimation:MLEnterAnimationStyleNone];
             
    };
    
    //***跳转首页****
    self.addCartTool.homeIconImgV.userInteractionEnabled = YES;
    [self.addCartTool.homeIconImgV setTapActionWithBlock:^{
        
        [[NSNotificationCenter defaultCenter]removeObserver:weakSelf.dcObj];

        kKeyWindow.rootViewController = [HJTabBarController new];
    }];
    
    //****跳转购物车****
    self.addCartTool.cartIconImgV.userInteractionEnabled = YES;
    
    [self.addCartTool.cartIconImgV setTapActionWithBlock:^{

      [[NSNotificationCenter defaultCenter]removeObserver:weakSelf.dcObj];
        weakSelf.addCartTool.hidden = YES;
        HHShoppingVC *vc = [HHShoppingVC new];
        vc.cartType = HHcartType_goodDetail;
        vc.delegate = weakSelf;
        [weakSelf.navigationController pushVC:vc];
    }];
}

#pragma mark - HHCartVCProtocol

- (void)cartVCBackActionHandle{
    
    //接收到通知
    [self acceptanceNote];
    
}
#pragma mark - 加入购物车成功
- (void)setUpWithAddSuccessWithselect_IdArray:(NSArray *)select_IdArray quantity:(NSString *)quantity pid:(NSString *)pid
{
    NSString *select_Id = [select_IdArray componentsJoinedByString:@"_"];
    NSString *sku_id;
    if (select_Id.length>0) {
        sku_id = select_Id;
    }else{
        sku_id = @"0";
    }
    NSString *sku_id_Str = [NSString stringWithFormat:@"%@_%@",pid,sku_id];
    
    //加入购物车
    [[[HHCartAPI postAddProductsWithsku_id:sku_id_Str quantity:quantity] netWorkClient] postRequestInView:self.view finishedBlock:^(HHCartAPI *api, NSError *error) {
        
        if (!error) {
            if (api.State == 1) {
                [SVProgressHUD showSuccessWithStatus:@"加入购物车成功～"];
                [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
                [SVProgressHUD dismissWithDelay:1.0];
                
            }else{
                
                [SVProgressHUD showInfoWithStatus:api.Msg];
            }
        }else{
            [SVProgressHUD showInfoWithStatus:api.Msg];
        }
    }];
    
}
#pragma mark - 立即购买
- (void)instanceBuyActionWithselect_IdArray:(NSArray *)select_IdArray quantity:(NSString *)quantity pid:(NSString *)pid{
    
    NSString *select_Id = [select_IdArray componentsJoinedByString:@"_"];
    NSString *sku_id;
    if (select_Id.length>0) {
        sku_id = select_Id;
    }else{
        sku_id = @"0";
    }
    NSString *sku_id_Str = [NSString stringWithFormat:@"%@_%@",pid,sku_id];
    NSLog(@"select_Id:%@",sku_id_Str);

    if (sku_id_Str.length>0) {
        //立即购买
//      是否存在收货地址
        [self isExitAddressWithsku_id_Str:sku_id_Str quantity:quantity];
    }
}
#pragma mark - 是否存在收货地址
- (void)isExitAddressWithsku_id_Str:(NSString *)sku_id_Str quantity:(NSString *)quantity{
    
    [[[HHCartAPI IsExistOrderAddress] netWorkClient] getRequestInView:nil finishedBlock:^(HHCartAPI *api, NSError *error) {
        
        if (!error) {
            if (api.State == 1) {
                if ([api.Data isEqual:@1]) {
                    
                    HHSubmitOrdersVC *vc = [HHSubmitOrdersVC new];
                    vc.enter_type = HHaddress_type_Spell_group;
                    vc.ids_Str = sku_id_Str;
                    vc.pids = self.Id;
                    vc.count = quantity;
                    vc.mode = self.Mode;
                    [self.navigationController pushVC:vc];
                }else{
                    HHAddAdressVC *vc = [HHAddAdressVC new];
                    vc.titleStr = @"新增收货地址";
                    vc.addressType = HHAddress_settlementType_productDetail;
                    vc.mode = self.Mode;
                    vc.ids_Str = sku_id_Str;
                    vc.pids = self.Id;
                    [self.navigationController pushVC:vc];
                }
            }else{
                [SVProgressHUD showInfoWithStatus:api.Msg];
            }
        }else{
            
            [SVProgressHUD showInfoWithStatus:api.Msg];
        }
    }];
    
}
#pragma mark - LazyLoad

- (UIScrollView *)scrollerView
{
    if (!_scrollerView) {
        _scrollerView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _scrollerView.frame = self.view.bounds;
        _scrollerView.contentSize = CGSizeMake(ScreenW, (ScreenH - 50) * 2);
        _scrollerView.pagingEnabled = YES;
        _scrollerView.scrollEnabled = NO;
        [self.view addSubview:_scrollerView];
    }
    return _scrollerView;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ScreenH - 64-35) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = KVCBackGroundColor;
        _tableView.tableFooterView = self.tableFooter;
        //注册cell
        [_tableView registerNib:[UINib nibWithNibName:HHDetailGoodReferralCellID bundle:nil] forCellReuseIdentifier:HHDetailGoodReferralCellID];
        [_tableView registerNib:[UINib nibWithNibName:HHShopIntroCellID bundle:nil] forCellReuseIdentifier:HHShopIntroCellID];
        [_tableView registerNib:[UINib nibWithNibName:HHGoodSpecificationsCellID bundle:nil] forCellReuseIdentifier:HHGoodSpecificationsCellID];
        [_tableView registerClass:[HHdiscountPackageViewTabCell class] forCellReuseIdentifier:HHdiscountPackageViewTabCellID];
        [_tableView registerClass:[HHGuess_you_likeTabCell class] forCellReuseIdentifier:HHGuess_you_likeTabCellID];


        [self.scrollerView addSubview:_tableView];
    }
    return _tableView;
}
- (WKWebView *)webView
{
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:CGRectZero];
        _webView.frame = CGRectMake(-5,ScreenH-50 , ScreenW+10, ScreenH - 50);
        _webView.scrollView.contentInset = UIEdgeInsetsMake(DCTopNavH, 0, 0, 0);
        _webView.scrollView.scrollIndicatorInsets = _webView.scrollView.contentInset;
        [_webView.scrollView setShowsHorizontalScrollIndicator:NO];
        [self.scrollerView addSubview:_webView];
    }
    return _webView;
}
- (HHAddCartTool *)addCartTool{
    if (!_addCartTool) {
        CGRect statusRect = [[UIApplication sharedApplication] statusBarFrame];
        CGFloat y = statusRect.size.height+44;
        _addCartTool = [[HHAddCartTool alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 50-y, SCREEN_WIDTH, 50)];
        _addCartTool.nav = self.navigationController;
        UIView *line = [UIView lh_viewWithFrame:CGRectMake(0, 0, ScreenW, 1) backColor:RGB(220, 220, 220)];
        [_addCartTool addSubview:line];
    }
    return _addCartTool;
    
}
//头部
- (SDCycleScrollView *)cycleScrollView {
    
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH) imageNamesGroup:@[@""]];
        _cycleScrollView.placeholderImage = [UIImage imageNamed:@"loadImag_default"];
        _cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleNone;
        _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFit;
        [_cycleScrollView setPlaceholderImage:[UIImage imageWithColor:kWhiteColor]];
        
        _cycleScrollView.delegate = self;
    }
    
    return _cycleScrollView;
}
- (UIView *)countTimeView{
    if (!_countTimeView) {
        _countTimeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 50)];
        _countTimeView.backgroundColor = kBlackColor;
    }
    return _countTimeView;
}
- (UILabel *)tableFooter{
    
    if (!_tableFooter) {
        _tableFooter = [UILabel lh_labelWithFrame:CGRectMake(0, 0, ScreenW, 30) text:@"——————   继续向上拖动，查看图文详情   ——————" textColor:KACLabelColor font:FONT(13) textAlignment:NSTextAlignmentCenter backgroundColor:kClearColor];
    }
    return _tableFooter;
}
#pragma mark - 视图滚动
- (void)setUpViewScroll{
    WEAK_SELF();
    self.tableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingBlock:^{
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
//            !weakSelf.changeTitleBlock ? : weakSelf.changeTitleBlock(YES);
            weakSelf.scrollerView.contentOffset = CGPointMake(0, ScreenH);
        } completion:^(BOOL finished) {
            [weakSelf.tableView.mj_footer endRefreshing];
        }];
    }];
    
    self.webView.scrollView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
        [UIView animateWithDuration:0.8 animations:^{
//            !weakSelf.changeTitleBlock ? : weakSelf.changeTitleBlock(NO);
            weakSelf.scrollerView.contentOffset = CGPointMake(0, 0);
        } completion:^(BOOL finished) {
            [weakSelf.webView.scrollView.mj_header endRefreshing];
        }];
        
    }];
}
#pragma mark --- tableView delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *gridcell = nil;
    if (indexPath.section == 0) {
        HHDetailGoodReferralCell *cell = [tableView dequeueReusableCellWithIdentifier:HHDetailGoodReferralCellID];
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        cell.gooodDetailModel = self.gooodDetailModel;
        gridcell = cell;
    }else if (indexPath.section == 1) {
        //店铺介绍
        HHShopIntroCell *cell = [tableView dequeueReusableCellWithIdentifier:HHShopIntroCellID];
        // cell.gooodDetailModel = self.gooodDetailModel;
        gridcell = cell;
    }else if (indexPath.section == 2){
        //商品信息
        HHGoodSpecificationsCell *cell = [tableView dequeueReusableCellWithIdentifier:HHGoodSpecificationsCellID];
        cell.separatorInset = UIEdgeInsetsMake(0, -ScreenW, 0, 0);
        HHattributeValueModel *model = self.discribeArr[indexPath.row];
        cell.leftTitleLabel.text = [NSString stringWithFormat:@"【%@】",model.ValueName];
        cell.discribeLabel.text = model.ValueStr;
        gridcell = cell;
    }else if (indexPath.section == 3){
            //优惠套餐
            HHdiscountPackageViewTabCell *cell = [tableView dequeueReusableCellWithIdentifier:HHdiscountPackageViewTabCellID];
             cell.packages_model = self.gooodDetailModel.Packages[indexPath.row];
             cell.indexPath = indexPath;
             cell.nav = self.navigationController;
             gridcell = cell;
    }else if (indexPath.section == 4){
        //猜你喜欢
       HHGuess_you_likeTabCell  *cell = [tableView dequeueReusableCellWithIdentifier:HHGuess_you_likeTabCellID];
        cell.guess_you_like_arr =  self.guess_you_like_arr;
        cell.nav = self.navigationController;
        cell.dcObj = self.dcObj;
        gridcell = cell;
    }
    gridcell.selectionStyle = UITableViewCellSelectionStyleNone;
    return gridcell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
  return  5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
     return 1;
    }else if (section == 1) {
        return 1;
    }else if (section == 2) {
     return self.discribeArr.count;
    }else if (section == 3){
     return self.gooodDetailModel.Packages.count;
    }else if (section == 4){
        return self.guess_you_like_arr.count>0?1:0;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return 100;
    }else if (indexPath.section == 1) {
        return 90;
    }else if (indexPath.section == 2) {
       return 30;
    }else if (indexPath.section == 3) {
        return 130;
    }else if (indexPath.section == 4) {
        return 220+45;
    }
    return 0.001;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 2) {
        if (self.discribeArr.count>0) {
            UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 30)];
            headView.backgroundColor = kWhiteColor;
            self.titleLabel = [UILabel lh_labelWithFrame:CGRectMake(15, 0, ScreenW-30, 30) text:@"商品信息" textColor:kBlackColor font:FONT(13) textAlignment:NSTextAlignmentLeft backgroundColor:kWhiteColor];
            [headView addSubview:self.titleLabel];
            return headView;
        }else{
            return [UIView new];
        }
    }
    
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 2) {
        if (self.discribeArr.count>0) {
          return 30;
        }else{
            return 0.001;
        }
    }
    return 0.001;
    
}
#pragma mark - 转场动画弹出控制器
- (void)setUpAlterViewControllerWith:(UIViewController *)vc WithDistance:(CGFloat)distance WithDirection:(XWDrawerAnimatorDirection)vcDirection WithParallaxEnable:(BOOL)parallaxEnable WithFlipEnable:(BOOL)flipEnable
{
    [self dismissViewControllerAnimated:YES completion:nil]; //以防有控制未退出
    XWDrawerAnimatorDirection direction = vcDirection;
    XWDrawerAnimator *animator = [XWDrawerAnimator xw_animatorWithDirection:direction moveDistance:distance];
    animator.parallaxEnable = parallaxEnable;
    animator.flipEnable = flipEnable;
    [self xw_presentViewController:vc withAnimator:animator];
//    WEAK_SELF();
    [animator xw_enableEdgeGestureAndBackTapWithConfig:^{
//        [weakSelf selfAlterViewback];
    }];
}
#pragma 退出界面
- (void)selfAlterViewback{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:_dcObj];

}
- (CGFloat)cellContentViewWith
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    // 适配ios7横屏
    if ([UIApplication sharedApplication].statusBarOrientation != UIInterfaceOrientationPortrait && [[UIDevice currentDevice].systemVersion floatValue] < 8) {
        width = [UIScreen mainScreen].bounds.size.height;
    }
    return width;
}

@end
