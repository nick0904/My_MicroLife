//
//  BPTableViewCell.h
//  Microlife
//
//  Created by Rex on 2016/9/19.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BPTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UIView *noteBase;

@property (weak, nonatomic) IBOutlet UIImageView *typeImage;
@property (weak, nonatomic) IBOutlet UIView *decorateLine;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *SYSValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *DIAValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *PULValueLabel;
@property (weak, nonatomic) IBOutlet UITextView *noteTextView;

@property (weak, nonatomic) IBOutlet UIImageView *cellImage;
@property (weak, nonatomic) IBOutlet UIView *recordView;

@property (nonatomic) BOOL hasImage;
@property (nonatomic) BOOL hasRecord;

@property (weak, nonatomic) IBOutlet UILabel *recordLabel;


@end
