//
//  SQLiteClass.h
//  DataBase_Test
//
//  Created by Kimi on 12/4/24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>


//#define kDatabase @"Database.sqlite3"


@interface SQLiteClass : NSObject
{
    sqlite3 *database;  //資料庫
}

//判斷DB是否存在
- (BOOL)OpenOrCreateDB:(NSString *)filename; //打開DB:DB名稱


//= 資料表操作 ==================
//建立資料表
- (void)CREATE_TABLE:(NSString *)command;
//刪除資料表　
- (void)DROP_TABLE:(NSString *)command;
//更改資料表名稱
- (void)RENAME_TABLE:(NSString *)command;
//資料表最佳化，欄位長度有變動、刪除大量資料，都應進行資料表最佳化
- (void)OPTIMIZE_TABLE:(NSString *)command;


//新增資料
- (void)COLUMN_INSERT:(NSString *)command;
//修改資料
- (void)COLUMN_UPDATE:(NSString *)command;
//刪除資料
- (void)COLUMN_DELETE:(NSString *)command;
//查詢資料
- (NSMutableArray *)SELECT:(NSString *)command Num:(int)Num;
//- (NSString *)SELECT_ID:(NSString *)command;







/**
// 判斷是否為第一次
- (bool)DatabaseExist:(NSString *)dbName;
- (NSString *)DatabaseKey:(int)key;
- (NSString *)DatabaseType:(int)type;


//建立資料庫(資料庫名稱: String)
- (void)INSERT_DB:(NSString *)dbName;
//刪除資料庫(資料庫名稱: String)
- (void)DELETE_DB:(NSString *)dbName;

//建立資料表(資料表名稱: String, 欄位名稱: IBusDataArray)
- (void)CREATE_TABLE:(NSString *)tableName:(NSArray *)colName;
//刪除資料表(資料表名稱: String)
- (void)DROP_TABLE:(NSString *)tableName;


//新增資料(資料表名稱: String, 新增資料: IBusDataArray)
- (void)INSERT:(NSString *)tableName:(NSArray *)dataArray;
//修改資料(資料表名稱: String, 修改資料: IBusDataArray, 條件限制: IBusDataArray)
- (void)UPDATE:(NSString *)tableName:(NSArray *)dataArray:(NSArray *)whereArray;
//刪除資料(資料表名稱: String, 條件限制: IBusDataArray)
- (void)DELETE:(NSString *)tableName:(NSArray *)whereArray;
//查詢資料(資料表名稱: String, 查詢欄位: NSArray, 條件限制: IBusDataArray): String
- (NSArray *)SELECT:(NSString *)tableName:(NSArray *)colArray:(NSArray *)whereArray;
*/


@end
