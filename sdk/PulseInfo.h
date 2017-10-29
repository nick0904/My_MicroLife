//
//  PulseInfo.h
//  MicroLifeDeviceSDK
//
//  Created by Tom on 2016/9/13.
//  Copyright © 2016年 Tom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PulseRecord.h"

@interface PulseInfo : NSObject

-(id)init;

-(void)setIndexAll:(BOOL)vindexAll;

-(BOOL)isIndexAll;

-(void)setIndexPAD:(BOOL)vindexPAD;

-(BOOL)isIndexPAD;

-(void)setIndexAfib:(BOOL)vindexAfib;

-(BOOL)isIndexAfib;

-(void)setIndexIHB:(BOOL)vindexIHB;

-(BOOL)isIndexIHB;

-(void)setReferOfPulseRate:(int)vreferOfPulseRate;

-(int)getReferOfPulseRate;

-(void)setPulseRecordCount:(int)vpulseRecordCount;

-(int)getPulseRecordCount;

-(void)addPulseRecordByHeader:(PulseRecord*) pRec;

-(NSMutableArray*)getPulseRecordArr;


@end
