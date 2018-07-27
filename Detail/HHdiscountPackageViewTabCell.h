//
//  HHdiscountPackageViewTabCell.h
//  lw_Store
//
//  Created by User on 2018/6/20.
//  Copyright © 2018年 User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HHdiscountPackageViewTabCell : UITableViewCell

@property (nonatomic, strong)   HHPackagesModel *packages_model;

@property (nonatomic, strong)   NSIndexPath *indexPath;
@property (nonatomic, strong)   UINavigationController *nav;


@end
