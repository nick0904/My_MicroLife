//
//  DeleteMailCell.h
//  Microlife
//
//  Created by 曾偉亮 on 2017/3/17.
//  Copyright © 2017年 Rex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeleteMailCell : UITableViewCell

@property (strong, nonatomic) UIButton *selectBtn;

@property (strong, nonatomic) NSString *mailTitle;

@property (strong, nonatomic) NSString *selectedStr;

-(id)initWithDeleteMailCellFrame:(CGRect)frame;

-(void)refreshData;

@end
