//
//  MainOverviewViewController.h
//  Microlife
//
//  Created by Rex on 2016/7/22.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import "MViewController.h"

@interface MainOverviewViewController : MViewController <UIScrollViewDelegate> {
    int selectedEventID;
}
@property  BOOL isListBtEnable;
@property  BOOL syncInformation;
;

@end


/**
 Overview 圖表顯示規範
 ---------------------------------------------------------------
 血壓計:
 根據account_id判斷帳號
 取得最新14天平均資料(新->舊,從右到左，每天只抓平均值，固定間距，平滑曲線 )
 ---------------------------------------------------------------
 體脂計:
 根據account_id判斷帳號
 取得最新14天資料(新->舊，從右到左，每天只抓平均值，固定間距，平滑曲線 )
 ---------------------------------------------------------------
 額溫計:
 根據account_id判斷帳號
 可選擇User事件
 取得當前時間前6小時資料(舊->新，從左到右，每15分鐘內量測最高紀錄,固定間距，平滑曲線)
 所以最多 4*6 = 24點
 ---------------------------------------------------------------
 
*/
