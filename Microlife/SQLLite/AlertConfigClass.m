//
//  WeightClass.m
//  Microlife
//
//  Created by Rex on 2016/10/6.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import "AlertConfigClass.h"
#import "AppDelegate.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "FMDatabasePool.h"
#import "FMDatabaseQueue.h"

@implementation AlertConfigClass
{
    AppDelegate *appDelegate;
}

@synthesize ALERT_ID,accountID,alertConfig,FLAG;

-(id)init
{
    self=[super init];
    
    if(self)
    {
        [self openDatabase];
        appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    }
    
    
    return self;
}

-(id)initWithOpenDataBase{
    
    self = [super init];
    
    if (self) {
        
        [self setUp];
    }
    return self;
}


-(void)setUp{
    
}

-(void)getUserAlertConfig:(int)accid{

    NSString *Command;
    
    Command = [NSString stringWithFormat:@"SELECT ALERT_ID, accountID, ALERT_CONFIG,FLAG FROM ALERTList order by ALERT_ID desc"];
    
    NSLog(@"Command:%@",Command);
    
    //WHERE accountID = %d

    //[self openDatabase];
    
    FMResultSet *rs=[fmdatabase executeQuery:Command];
    
    if(rs.next)
    {
        accountID=[rs intForColumn:@"accountID"];
        alertConfig=[rs stringForColumn:@"ALERT_CONFIG"];
        ALERT_ID=[rs intForColumn:@"ALERT_ID"];
        FLAG=[rs stringForColumn:@"FLAG"];
    }
    
    
}



- (void)updateData{
    
    NSString *SQLStr = [NSString stringWithFormat:@"UPDATE ALERTList SET ALERT_CONFIG = ? WHERE accountID = ?"];

    //[self openDatabase];
    
    [fmdatabase executeUpdate:SQLStr,alertConfig,[NSNumber numberWithInt:accountID]];
    
    
}

-(void)insertData{
    
    NSString *check=@"select accountID from ALERTList where accountID = ?";
    NSString *SQLStr = [NSString stringWithFormat:@"INSERT INTO ALERTList(accountID,ALERT_CONFIG) values(?,?);"];
    
    //ALERT_CONFIG
    

    FMResultSet *rs=[fmdatabase executeQuery:check,[NSNumber numberWithInt:accountID]];
    
    if(rs.next)
    {
        [self updateData];
    }else{
        [fmdatabase executeUpdate:SQLStr,[NSNumber numberWithInt:accountID],alertConfig];
    }
    
}

-(void)PushLoacaleMessage:(NSMutableArray*)noiseData
{
    [appDelegate setLocalNoise:noiseData];
}


-(void)deletData {
    
    NSString *sqStr = [NSString stringWithFormat:@"DELETE FROM ALERTList WHERE accountID ='%d';",[LocalData sharedInstance].accountID];
    
    [self COLUMN_DELETE:sqStr];
    
}


@end
