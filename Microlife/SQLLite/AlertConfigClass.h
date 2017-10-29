//
//  WeightClass.h
//  Microlife
//
//  Created by Rex on 2016/10/6.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import "DataBaseClass.h"

@interface AlertConfigClass : DataBaseClass

@property (nonatomic) int accountID,ALERT_ID;
@property (strong,nonatomic) NSString *alertConfig,*FLAG;

-(id)init;

-(void)getUserAlertConfig:(int)accountid;

-(void)insertData;

- (void)updateData;

-(void)PushLoacaleMessage:(NSMutableArray*)noiseData;

-(void)deletData;

@end
