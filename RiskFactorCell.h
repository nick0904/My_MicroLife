//
//  RiskFactorCell.h
//  Microlife
//
//  Created by Idea on 2016/10/5.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RiskFactorsViewController;

@interface RiskFactorCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *RFLabel;
@property BOOL isSelected;
@property (strong, nonatomic) RiskFactorsViewController *m_superVC;
@property (weak, nonatomic) IBOutlet UIImageView *RFcheckbox;


@end
