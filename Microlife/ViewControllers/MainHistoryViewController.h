//
//  MainHistoryViewController.h
//  Microlife
//
//  Created by Rex on 2016/7/22.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import "MViewController.h"
#import "HistoryListTableView.h"

@interface MainHistoryViewController : MViewController

@property (weak, nonatomic) IBOutlet UIScrollView *contentScroll;

@end



/**
 
 History 圖表顯示規範
 所謂的"目前":是以當前時間往前推
 ----------------------------------------------------------
 血壓機
 Day：以當天，一小時為單位，數值先做單小時平均再顯示，共24筆
 Week：以當天往回推6天，一天為單位，數值先做單日平均再顯示，共7筆
 Month：已當天往回推30天，一天為單位，數值先做單日平均再顯示，共30筆
 Year：共顯示12個月，以月為單位，數值先做單月平均再顯示，共12筆
 ----------------------------------------------------------
 體重機
 Day：以當天，一小時為單位，數值先做單小時平均再顯示，共24筆
 Week：以當天往回推6天，一天為單位，數值先做單日平均再顯示，共7筆
 Month：已當天往回推30天，一天為單位，數值先做單日平均再顯示，共30筆
 Year：共顯示12個月，以月為單位，數值先做單月平均再顯示，共12筆
 ----------------------------------------------------------
 額溫機
 1HR : 當前時間往回推一小時資料，每隔五分鐘內的最高紀錄，要切換事件
 4HR : 當前時間往回推四小時，每隔15分鐘內的最高紀錄，要切換事件
 24HR : 當前時間往回推24小時，每隔一小時內的最高紀錄，要切換事件

*/
