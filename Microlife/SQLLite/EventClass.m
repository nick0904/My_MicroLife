//
//  EventClass.m
//  Microlife
//
//  Created by Rex on 2016/10/6.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import "EventClass.h"

@implementation EventClass

@synthesize eventID,accountID,eventTime,type,event;

+(EventClass*) sharedInstance {
    
    static EventClass *sharedInstance;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        sharedInstance = [[EventClass alloc] initWithOpenDataBase];
    });
    
    return sharedInstance;
}

-(id)initWithOpenDataBase{
    
    self = [super initWithOpenDataBase];
    
    if (self) {
        
        [self setUp];
    }
    
    return self;
}


-(void)setUp{
    
}

-(NSMutableArray *)selectAllData{
    
    //NSString *Command = [NSString stringWithFormat:@"SELECT eventID, accountID, event, type, eventTime FROM EventList"];
    
    NSMutableArray *resultArray = [NSMutableArray new];
    
    NSString *Command = [NSString stringWithFormat:@"SELECT eventID, event, type, eventTime FROM EventList"];
    
    NSMutableArray* DataArray = [self SELECT:Command Num:4];//SELECT:指令：幾筆欄位
    
    //NSLog(@"DataArray = %@",DataArray);
    
    if ([[DataArray firstObject] count] != 1) {
        
        for (int i=0; i < DataArray.count; i++) {
            
            NSString *eventIDStr = [[DataArray objectAtIndex:i] objectAtIndex:0];
            NSString *eventStr = [[DataArray objectAtIndex:i] objectAtIndex:1];
            NSString *typeStr = [[DataArray objectAtIndex:i] objectAtIndex:2];
            NSString *eventTimeStr = [[DataArray objectAtIndex:i] objectAtIndex:3];
            
            NSDictionary *eventDict = [[NSDictionary alloc] initWithObjectsAndKeys:eventIDStr,@"eventID",
                                       eventStr,@"event",
                                       typeStr,@"type",
                                       eventTimeStr,@"eventTime",nil];
            
            [resultArray addObject:eventDict];
        }
        
    }
    
    return resultArray;

}

-(NSMutableArray *)selectEventData{
    
    NSString *Command = [NSString stringWithFormat:@"SELECT event, type, eventTime FROM EventList WHERE accountID = %d ORDER BY date DESC",[LocalData sharedInstance].accountID];
    
    NSMutableArray* DataArray = [self SELECT:Command Num:3];//SELECT:指令：幾筆欄位
    
    return DataArray;
    
}

- (void)updateData{

    NSString *SQLStr = [NSString stringWithFormat:@"UPDATE EventList SET event = \"%@\", type = \"%@\", eventTime = \"%@\" WHERE eventID = \"%d\" AND accountID = %d"
                         ,event, type, eventTime, [LocalData sharedInstance].currentEventId, [LocalData sharedInstance].accountID];
    
    [self COLUMN_UPDATE:SQLStr];
    
}

-(void)insertData{
    
    NSString *SQLStr = [NSString stringWithFormat:@"INSERT INTO EventList( accountID, event, type, eventTime, eventID) VALUES(\"%d\",\"%@\", \"%@\", \"%@\",\"%d\");",[LocalData sharedInstance].accountID , event, type, eventTime,eventID];
    
    [self COLUMN_INSERT:SQLStr];
}

-(void)deletData {
    
    NSLog(@"ready to delete ==> accountID:%d, eventID:%d",self.accountID,self.eventID);

    [LocalData sharedInstance].currentEventId = self.eventID;
    
    NSString *sqStr = [NSString stringWithFormat:@"DELETE FROM EventList WHERE eventID='%d';",[LocalData sharedInstance].currentEventId];
    
    [self COLUMN_DELETE:sqStr];
}


-(void)deleteAllEventData {
    
    NSString *sqStr = [NSString stringWithFormat:@"DELETE FROM EventList WHERE accountID ='%d';",[LocalData sharedInstance].accountID];
    
    [self COLUMN_DELETE:sqStr];

    
}

@end
