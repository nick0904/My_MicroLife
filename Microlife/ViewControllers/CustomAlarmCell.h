//
//  CustomAlarmCell.h
//  Microlife
//
//  Created by Rex on 2016/9/2.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomAlarmCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *typeTitle;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *measureWeek;
@property (weak, nonatomic) IBOutlet UISwitch *alarmSwitch;
@property (nonatomic) int type;
@property (nonatomic) NSInteger cellIndex;
@end
