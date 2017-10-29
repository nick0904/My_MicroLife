//
//  DataBaseClass.h
//  DataBase
//
//  Created by Kimi on 12/9/6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SQLiteClass.h"

#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "FMDatabasePool.h"
#import "FMDatabaseQueue.h"

@interface DataBaseClass : SQLiteClass {
    
    FMDatabase *fmdatabase;
}

@property int TotalUsers;

- (id)initWithOpenDataBase;

- (NSString *)ArrayToString:(NSMutableArray *)Array;//

- (BOOL)openDatabase;

- (void)closeDatabase;
@end
