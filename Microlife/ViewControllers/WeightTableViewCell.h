//
//  WeightTableViewCell.h
//  Microlife
//
//  Created by Rex on 2016/9/22.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeightTableViewCell : UITableViewCell{
    BOOL initLayOut;
}

@property (weak, nonatomic) IBOutlet UIView *noteBase;

@property (weak, nonatomic) IBOutlet UIImageView *typeImage;
@property (weak, nonatomic) IBOutlet UIView *decorateLine;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;


@property (weak, nonatomic) IBOutlet UITextView *noteTextView;

@property (weak, nonatomic) IBOutlet UIImageView *cellImage;
@property (weak, nonatomic) IBOutlet UIView *recordView;

@property (nonatomic) BOOL hasImage;
@property (nonatomic) BOOL hasRecord;
@property (nonatomic) BOOL showDetail;
@property (weak, nonatomic) IBOutlet UILabel *weightValue;
@property (weak, nonatomic) IBOutlet UILabel *BMIValue;
@property (weak, nonatomic) IBOutlet UILabel *bodyFatValue;
@property (weak, nonatomic) IBOutlet UILabel *waterValue;
@property (weak, nonatomic) IBOutlet UILabel *skeletonValue;
@property (weak, nonatomic) IBOutlet UILabel *muscleValue;
@property (weak, nonatomic) IBOutlet UILabel *BMRValue;
@property (weak, nonatomic) IBOutlet UILabel *organFatVlaue;

@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property (weak, nonatomic) IBOutlet UIView *topDetail;

@property (weak, nonatomic) IBOutlet UIView *middeleDetail;
@property (weak, nonatomic) IBOutlet UIView *bottomDetail;

@property (weak, nonatomic) IBOutlet UILabel *recordLabel;

@end
