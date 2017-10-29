//
//  Microlife
//
//  Created by Rex on 2016/9/9.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import "MViewController.h"

@interface AlarmDetailViewController : MViewController

@property (nonatomic) int listType; //0=week 1=type

@property (nonatomic, strong) NSMutableDictionary *reminderDict;
@property (nonatomic) NSMutableArray *weekArray;
@property (nonatomic) NSMutableArray *typeArray;

@property (nonatomic) NSInteger alarmIndex;
@property (nonatomic, strong) NSString *customStr;


@end
