//
//  BTEventSelector.h
//  Microlife
//
//  Created by 曾偉亮 on 2017/3/7.
//  Copyright © 2017年 Rex. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol BTEventSelectorDelegate <NSObject>

@required

-(void)confirmOrCancel:(int)confirm checkMark:(NSMutableArray *)ary_checkMark; //confirm = 0 ,cancel = otherwise

@end



@class MainOverviewViewController;

@interface BTEventSelector : NSObject  <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) MainOverviewViewController *superVC;

@property (strong,nonatomic) NSMutableArray *ary_BTEventData;

@property (strong) id <BTEventSelectorDelegate> delegate;

-(id)initBTEventSelector;

-(void)reloadBTEventData;

-(void)showBTEventSelectorAlert;

@end
