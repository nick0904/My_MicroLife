//
//  SQLiteClass.m
//  DataBase_Test
//
//  Created by Kimi on 12/4/24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SQLiteClass.h"

@implementation SQLiteClass

NSString *fileName = @"";  //資料庫名稱
NSString *filePath = @""; //資料庫檔案路徑

- (BOOL)OpenOrCreateDB:(NSString *)fileNames {
   
    //判斷DB是否存在
	BOOL findFile = [self OpenDatabase:fileNames];
    
    if( findFile ) {
        
        //找到資料庫
        //NSLog(@"^_^");
        return 1;
    }
    else {
        
        //沒找到資料庫
        //NSLog(@"T_T");
        return 0;
    }
}



//= 資料庫操作 ========================================================================================================
//建立資料庫
- (void)CreateDatabase{ 
   
    // 建立資料庫,在指定位置開啟資料庫,如果資料庫不存在,就會新建一個
    if(sqlite3_open([filePath UTF8String], &database) != SQLITE_OK) {
        
        sqlite3_close(database); // 如果執行成功,則回傳ok,用來判斷是否出錯,
        NSAssert(0,@"Failed to open the database"); //無法打開數據庫
    }
    
    [self OpenForeignKeys:1];

}
//刪除資料庫(悲劇了...SQLite無法像其他資料庫一樣可以用"DROP DATABASE test"刪除資料庫，所以我使用直接刪除資料庫文件的方式來達成目的
- (void)DropDatabase{ 
    
    //判斷檔案是否存在
    if( [[NSFileManager defaultManager] fileExistsAtPath:filePath] ) {
        //刪除檔案
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
        NSLog(@"Deleted successfully");
    }
}

//打開資料庫
- (BOOL)OpenDatabase:(NSString *)fileNames {
    
    fileName = [NSString stringWithFormat:@"%@",fileNames];
    
    // 獲取資料庫路徑
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *thePath = [paths objectAtIndex:0];
	filePath = [thePath stringByAppendingPathComponent:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL findFile = [fileManager fileExistsAtPath:filePath];
    
    [self CreateDatabase];
    return findFile;
}



//關閉資料庫
- (void)CloseDatabase {
    
    sqlite3_close(database);
}

//設定外來鍵開關:必須在'每次'運行時先啟用外來鍵,因為默認是關閉:PRAGMA foreign_keys = ON;
- (void)OpenForeignKeys:(bool)num {
    
    NSString *Command = @"";
    if ( num == 1 ) 
        Command = @"PRAGMA foreign_keys = ON;";
    else 
        Command = @"PRAGMA foreign_keys = OFF;";
    
    char *ErrMsg;
    
    //0:建立資料表  1:刪除資料表
    if( sqlite3_exec(database, [Command UTF8String],NULL,NULL,&ErrMsg) != SQLITE_OK ) {
		
        sqlite3_close(database);
        //NSAssert2是後面帶2個顯示參數，依次類推
        //NSAssert1(0,@"Failed to create players table:%s",ErrMsg);
        NSAssert1(0, @"'ForeignKeys' Operation Errors:%s", ErrMsg);
		sqlite3_free(ErrMsg);
	}
    
    
}

//= 資料表－欄位操作 ========================================================================================================
//sqlite3_exec這個方法可以執行那些沒有返回結果的操作，例如創建、插入、刪除等
- (void)TABLE_SQLITE3_EXEC:(int)tag command:(NSString *)command{
    [self CreateDatabase];
    char *ErrMsg;
    //0:建立資料表  1:刪除資料表
    if( sqlite3_exec(database, [command UTF8String],NULL,NULL,&ErrMsg) != SQLITE_OK )
	{
		sqlite3_close(database);
        //NSAssert2是後面帶2個顯示參數，依次類推
        //NSAssert1(0,@"Failed to create players table:%s",ErrMsg);
        NSAssert2(0, @"'TABLE' Operation Errors:%s (Error Codes:%i)", ErrMsg, tag);
		sqlite3_free(ErrMsg);
	}
    [self CloseDatabase];
}


//建立資料表
- (void)CREATE_TABLE:(NSString *)command {
    //CREATE TABLE IF NOT EXISTS SYSTEM( VerID INTEGER PRIMARY KEY,ID0 TINYINT,ID1 TINYINT,ID2 TINYINT,ID3 TINYINT,ID4 TINYINT,ID5 TINYINT);
    
    [self TABLE_SQLITE3_EXEC:0 command:command];
    
}

//刪除資料表　
- (void)DROP_TABLE:(NSString *)command{
    //DROP TABLE IF EXISTS SYSTEM;
    [self TABLE_SQLITE3_EXEC:1 command:command];

}

//更改資料表名稱
- (void)RENAME_TABLE:(NSString *)command{
    //ALTER TABLE t1 RENAME TO t2;
    //將資料表 t1 改名為 t2 
    [self TABLE_SQLITE3_EXEC:1 command:command];

}

//增加新欄位
- (void)CHANGE_TABLE_COLUMN_ADD:(NSString *)command{
    
    //ALTER TABLE t2 ADD d TIMESTAMP; 
    //在資料表 t2 增加新欄位 d 資料型態是 timestamp 
    
    //ALTER TABLE t2 ADD c INT UNSIGNED NOT NULL AUTO_INCREMENT, ADD INDEX (c);
    //新增欄位 c，並做索引(做索引的欄位必須為 not null )
    [self TABLE_SQLITE3_EXEC:2 command:command];
    
}

//刪除欄位
- (void)CHANGE_TABLE_COLUMN_DROP:(NSString *)command{
    //ALTER TABLE t2 DROP COLUMN c;
    //在資料表 t2 刪除欄位 c
    [self TABLE_SQLITE3_EXEC:3 command:command];
    
}

//欄位重新命名 XXXXXXXXXXXXX 工程中,敬請期待 XXXXXXXXXXXXXXXXX
- (void)CHANGE_TABLE_COLUMN_Name:(NSString *)command{
    //ALTER TABLE t1 CHANGE a b INTEGER
    //將資料表 t1 欄位 a 改名為 b (其資料型態是 integer) 
    [self TABLE_SQLITE3_EXEC:4 command:command];
    
}

//改變欄位資料型態 XXXXXXXXXXXXX 工程中,敬請期待 XXXXXXXXXXXXXXXXX
- (void)CHANGE_TABLE_COLUMN_types:(NSString *)command{
    //ALTER TABLE t1 MODIFY b BIGINT NOT NULL
    //將資料表 t1 欄位 b 的資料型態改為 bigint not null
    [self TABLE_SQLITE3_EXEC:5 command:command];
    
}

//資料表最佳化，欄位長度有變動、刪除大量資料，都應進行資料表最佳化(悲劇了...SQLite無法 用"OPTIMIZE TABLE tbl_name"最佳化資料庫)
- (void)OPTIMIZE_TABLE:(NSString *)command{
    //OPTIMIZE TABLE tbl_name
    [self TABLE_SQLITE3_EXEC:13 command:command];
    
}


//= 欄位-資料筆數操作 ========================================================================================================
//sqlite3_exec這個方法可以執行那些沒有返回結果的操作，例如創建、插入、刪除等
- (void)COLUMN_SQLITE3_EXEC:(int)tag command:(NSString *)command{
    [self CreateDatabase];
    char *ErrMsg;
    //0:建立資料表  1:刪除資料表
    if( sqlite3_exec(database, [command UTF8String],NULL,NULL,&ErrMsg) != SQLITE_OK )
	{
		sqlite3_close(database);
        //NSAssert2是後面帶2個顯示參數，依次類推
        //NSAssert1(0,@"Failed to create players table:%s",ErrMsg);
        NSAssert2(0, @"'COLUMN' Operation Errors:%s (Error Codes:%i)", ErrMsg, tag);
		sqlite3_free(ErrMsg);
	}
    [self CloseDatabase];
    
}

//sqlite3_prepare處理查詢結果，有返回得到記錄
//推荐在现在任何的程序中都使用sqlite3_prepare_v2这个函数，sqlite3_prepare只是用于前向兼容
- (NSMutableArray *)COLUMN_SQLITE3_PREPARE:(int)ColNum command:(NSString *)command{
    //支援各國碼 [Data stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
    [self CreateDatabase];
    __autoreleasing NSMutableArray *result = [[NSMutableArray alloc] init];
    
    BOOL notFound = YES;
    
	sqlite3_stmt *statement;
	
	if( sqlite3_prepare_v2( database, [command UTF8String], -1, &statement, NULL) == SQLITE_OK )
    {
			while(sqlite3_step(statement) == SQLITE_ROW) 
            {
                notFound = NO;
                NSMutableArray *results = [[NSMutableArray alloc] init];
                for (int i = 0; i < ColNum; i++)
                {
                    if(sqlite3_column_text(statement, i))
                    {
                        NSString *DataStr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, i)];
                        [results addObject:DataStr];
                    }else{
                        [results addObject:@""];
                    }
                    
                }
				[result addObject:results];
                results = nil;
			}
    }
    sqlite3_finalize(statement);//結束的時候清理statement對象，清理過程中佔用的資源。
    
    NSMutableArray *results = [[NSMutableArray alloc] init];
    [results insertObject:@"Can not find data!" atIndex:0];
    if(notFound)
    {
        //insertObject:向可變數組中插入一個數組對象
        //replaceObjectAtIndex withObject:向可變數組中修改一個數組對象
        [result insertObject:results atIndex:0];
    }
    results = nil;
    //NSLog(@"%@",result);
    [self CloseDatabase];
    return result;
    
}



//符合command條件一共有多少筆資料
- (int)COLUMN_Num_SQLITE3_PREPARE:(NSString *)command{
    //支援各國碼 [Data stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
    [self CreateDatabase];
    int number = 0;
    
    BOOL notFound = YES;
    
	sqlite3_stmt *statement;
	
	if( sqlite3_prepare_v2( database, [command UTF8String], -1, &statement, NULL) == SQLITE_OK )
    {
        if(sqlite3_step(statement) == SQLITE_ROW)
        {
            number = sqlite3_column_int(statement, 0);
        }
    }
    sqlite3_finalize(statement);//結束的時候清理statement對象，清理過程中佔用的資源。
    
    if(notFound)
    {
        number = 17910922; //如果有錯,回傳 17910922
    }
    [self CloseDatabase];
    return number;
    
}



//新增資料 
- (void)COLUMN_INSERT:(NSString *)command{
    
    //INSERT OR REPLACE INTO 資料表( 欄位1,......) VALUES( 值1,值2,......);
    [self COLUMN_SQLITE3_EXEC:0 command:command];

    
}

//修改資料
- (void)COLUMN_UPDATE:(NSString *)command{
    
    //REPLACE INTO:更新一筆紀錄 (語法與 INSERT 相同)
    //REPLACE INTO 資料表(欄位1,欄位2,......) VALUES(值1,值2,......) 
    //UPDATE: 更新多筆紀錄
    //UPDATE UPDATE tbl_name SET col_name1=expr1,col_name2=expr2,...     [WHERE where_definition]如果沒有設定 WHERE 條件，則整個資料表相關的欄位都更新 
    
    //NSString *Command = @"UPDATE SYSTEM SET \"%@\" = \"%@\" ;";
    [self COLUMN_SQLITE3_EXEC:1 command:command];
    
    NSLog(@"====> 更新資料成功 <====");

}

//刪除資料
- (void)COLUMN_DELETE:(NSString *)command{
    
    //NSString *Command = @"DELETE FROM HEART WHERE UserID = %i";
    [self COLUMN_SQLITE3_EXEC:2 command:command];
    
}

//查詢所有資料
- (NSMutableArray *)SELECT:(NSString *)command Num:(int)Num{
    
    //SELECT 欄位1,欄位2,...... FROM 資料表
    return [self COLUMN_SQLITE3_PREPARE:Num command:(NSString *)command];
    
}

//取得PK=ID



//排序輸出查詢"ORDER BY"(遞增：ASC,遞減：DESC)
//select * from 資料表名 order by 欄位名1,欄位名2,欄位名3......　
//select * from 資料表名 order by 欄位名1,欄位名2,欄位名3......　DESC
//select * from 資料表名 order by 欄位名1 ASC,欄位名2 DESC,......







//重複值只輸出一筆"DISTINCT"
//select DISTINCT 欄位名1 from 資料表名 order by 欄位名1








//經過計算的輸出查詢"欄位名1 * 欄位名2"
//select 欄位名1, 欄位名2, 欄位名1 * 欄位名2 AS 欄位名X from 資料表名 WHERE 欄位名1 > '113' order by 欄位名1




//兩個資料表的基本內部合併查詢"INNER JOIN"
//select 資料表名1.欄位名1(欄位名有重複才需選PK那個資料表), 欄位名2,...  from 資料表名1, 資料表名2 WHERE 資料表名1.欄位名1 = 資料表名2.欄位名1 order by 欄位名1



/*- sqlite3基本用法 http://www.cnblogs.com/wengzilin/archive/2012/03/27/2419203.html -----------------------------------------
A.設定鍵值，詳細情結請至 http://www.helplib.net/s/sqlite/9/201.shtml 觀看
    1.主鍵
        INTEGER PRIMARY KEY AUTOINCREMENT:自動計數，大型專案建議用這個，避免主鍵衝突，增加資料筆數時，設定成'NULL'就可以了，不要自定數值導致主鍵衝突
        INTEGER PRIMARY KEY:自定鍵值，小型專案建議用這個，只要注意不重複使用相同鍵值，這種方法易控制且簡單，快速
    2.外來鍵(SQLite 3.6.19 開始支援)
        必須在運行時先啟用外來鍵,因為默認是關閉:PRAGMA foreign_keys = ON;
        FOREIGN KEY(欄位m) REFERENCES 資料表A(欄位n)
 
    
B.儲存資料的數據類型，詳細情結請至 http://www.sqlite.org/datatype3.html 觀看
    1.以以下五大類型為主:
        NULL:該值是一個NULL值
        INTEGER:該值是一個有正負的整數，由數據的大小決定存儲為1,2,3,4,6或8 bytes
        REAL:該值是一個浮點值，作為一個8 bytes浮點數存儲。
        TEXT:該值是一個文本字符串，使用（UTF-8，UTF-16BE或UTF-16LE）編碼存儲
        BLOB:存儲自定義的數據類型
 
    2.但實際上，sqlite3也接受如下的數據類型:
        smallint 16 位​​元的整數。
        interger 32 位元的整數。
        decimal(p,s) p 精確值和s 大小的 "十進位整數"，精確值p是指全部有幾個數(digits)大小值，s是指小數點後有幾位數。如果沒有特別指定，則係統會設為p=5; s=0 。
        float 32位元的實數。
        double 64位元的實數。
        char(n) n 長度的字串，n不能超過254。
        varchar(n) 長度不固定且其​​最大長度為n 的字串，n不能超過4000。
        graphic(n) 和char(n) 一樣，不過其單位是兩個字元double-bytes， n不能超過127。這個形態是為了支援兩個字元長度的字體，例如中文字。
        vargraphic(n) 可變長度且其最大長度為n 的雙字元字串，n不能超過2000
        date 包含了 年份、月份、日期。
        time 包含了 小時、​​分鐘、秒。
        timestamp 包含了年、月、日、時、分、秒、千分之一秒。
 
C.註:
    1.重要結構體
        sqlite3 *database:數據庫句柄，跟文件句柄FILE很類似
        sqlite3_stmt *statement:這個相當於ODBC的Command對象，用於保存編譯好的SQL語句
 
    2.主要執行函數
        sqlite3_open():打開數據庫
        sqlite3_exec():執行非查詢的sql語句
        sqlite3_prepare():準備sql語句，執行select語句或者要使用parameter bind時，用這個函數（封裝了sqlite3_exec）.
        sqlite3_step():在調用sqlite3_prepare後，使用這個函數在記錄集中移動。
        sqlite3_close():關閉數據庫文件
 
    3.取值時選用的函數
        sqlite3_column_text():取text類型的數據
        sqlite3_column_blob():取blob類型的數據
        sqlite3_column_int():取int類型的數據
 
    4.其他工具函數
        int sqlite3_column_count(sqlite3_stmt *pStmt):得到結果總共的行數，如果過程沒有返回值，如update，將返回0
        int sqlite3_data_count(sqlite3_stmt *pStmt):得到當前行中包含的數據個數，如果sqlite3_step返回SQLITE_ROW，可以得到列數，否則為零。
        sqlite3_column_xxx(sqlite3_stmt*, int iCol):得到數據行中某個列的數據，在sqlite3_step返回SQLITE_ROW後，使用它得到第iCol列的數據。注意：如果對該列使用了不同與該列本身類型適合的數據讀取方法，得到的數值將是轉換過的結果。
        int sqlite3_column_type(sqlite3_stmt*, int iCol):得到數據行中某個列的數據的類型，返回值：SQLITE_INTEGER，SQLITE_FLOAT，SQLITE_TEXT，SQLITE_BLOB，SQLITE_NULL，使用的方法和sqlite3_column_xxx()函數類似。

 

---------------------------------------------------------------------------------------------------------------------------*/



@end
