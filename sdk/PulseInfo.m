//
//  PulseInfo.m
//  MicroLifeDeviceSDK
//
//  Created by Tom on 2016/9/13.
//  Copyright © 2016年 Tom. All rights reserved.
//

#import "PulseInfo.h"


@implementation PulseInfo
{
    BOOL indexAll;
    BOOL indexPAD;
    BOOL indexAfib;
    BOOL indexIHB;
    int referOfPulseRate;
    int pulseRecordCount;
    
    int headerArr[4];
    
    NSMutableArray *pulseRecordArr;
    
    //int headerArr = new int[]{0x80, 0x04, 0x02, 0x01};
    //PulseRecord[] pulseRecordArr =  new PulseRecord[4];
}

-(id)init
{
    self=[super init];
    
    if(self)
    {
        headerArr[0]=0x80;
        headerArr[1]=0x04;
        headerArr[2]=0x02;
        headerArr[3]=0x01;
        
        pulseRecordArr=[[NSMutableArray alloc]initWithCapacity:4];
        
        for(int i=0;i<4;i++)
        {
            PulseRecord* pRec=[[PulseRecord alloc]init];
            [pRec setHeader:-1];
            [pulseRecordArr addObject:pRec];
        }
        
    }
    
    return self;
}

-(void)setIndexAll:(BOOL)vindexAll {
    indexAll = vindexAll;
}

-(BOOL)isIndexAll{
    return indexAll;
}

-(void)setIndexPAD:(BOOL)vindexPAD{
    indexPAD = vindexPAD;
}

-(BOOL)isIndexPAD {
    return indexPAD;
}

-(void)setIndexAfib:(BOOL)vindexAfib{
    indexAfib = vindexAfib;
}

-(BOOL)isIndexAfib{
    return indexAfib;
}

-(void)setIndexIHB:(BOOL)vindexIHB{
    indexIHB = vindexIHB;
}

-(BOOL)isIndexIHB {
    return indexIHB;
}

-(void)setReferOfPulseRate:(int)vreferOfPulseRate{
    referOfPulseRate = vreferOfPulseRate;
}

-(int)getReferOfPulseRate{
    return referOfPulseRate;
}

-(void)setPulseRecordCount:(int)vpulseRecordCount {
    pulseRecordCount = vpulseRecordCount;
}

-(int)getPulseRecordCount{
    return pulseRecordCount;
}

-(void)addPulseRecordByHeader:(PulseRecord*) pRec {
    
    int header=[pRec getHeader];
    
    BOOL isfind=NO;
    int pos =-1;
    
    for(int i=0;i<4;i++)
    {
        if(headerArr[i]==header)
        {
            pos=i;
            isfind=YES;
            break;
        }
    }
    
    if(isfind)
    {
        pulseRecordArr[pos] =  pRec;
    }

}

-(NSMutableArray*)getPulseRecordArr
{
    return pulseRecordArr;
}


@end
