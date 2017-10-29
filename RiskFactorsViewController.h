//
//  RiskFactorsViewController.h
//  Setting
//
//  Created by Ideabus on 2016/8/12.
//  Copyright © 2016年 Allen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RiskFactorCell.h"
//#import "ProfileViewController.h"

@class ProfileViewController;

@interface RiskFactorsViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@property (strong,nonatomic) ProfileViewController *m_superVC;



@end
