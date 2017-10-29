//
//  HistoryListTableView.h
//  Microlife
//
//  Created by Rex on 2016/8/30.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

#import "AppDelegate.h"

@protocol HistoryListDelegate <NSObject>

-(void)hideListButtonTapped;

@end

@interface HistoryListTableView : UIView<UITableViewDelegate, UITableViewDataSource,AVAudioPlayerDelegate>{
    
    float imgScale;
    
}

@property (nonatomic, strong) UITableView *historyList;
@property (nonatomic, strong) UIView *hideListBtn;
@property (nonatomic) NSInteger listType;
@property (weak) id<HistoryListDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *listDataArray;


@end
