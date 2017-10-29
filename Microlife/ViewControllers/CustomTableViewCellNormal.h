//
//  CustomTableViewCellNormal.h
//  MicroLifeSetting
//
//  Created by 曾偉亮 on 2016/12/30.
//  Copyright © 2016年 Nick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCellNormal : UITableViewCell

@property (strong, nonatomic) NSString *titleStr;


//cell initialization
-(id)initWithFrameCustomCellNormal:(CGRect)frame;

//更新 cell 資料
-(void)refreshMessage;

@end
