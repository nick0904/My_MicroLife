//
//  DeviceInfo.m
//  MicroLifeDeviceSDK
//
//  Created by Tom on 2016/9/13.
//  Copyright © 2016年 Tom. All rights reserved.
//

#import "DeviceInfo.h"

@implementation DeviceInfo
{
    NSString *ID;
    
    
    /**
     * 共5種err,    但編號不連續。  依序為：1,2,3,5,6
     *
     * Index3: the header of error 1 happened times, 01h
     Index4: the header of error 2 happened times, 02h
     Index5: the header of error 3 happened times, 03h
     
     Index6: the header of error 5 happened times, 05h
     Index7: the header of error 6 happened times, 06h
     */
    
    NSMutableArray *errHappendTimes;// = new int[7];  //only use: 1,2,3,  5,6
    
    int measurementTimes;
}

-(id)init
{
    self=[super init];
    
    if(self)
    {
        errHappendTimes=[[NSMutableArray alloc]initWithObjects:@0,@0,@0,@0,@0,@0,@0, nil];
    }
    
    return self;
}


-(void)setID:(NSString*)vID {
    ID = vID;
}

-(NSString*)getID{
    return ID;
}

-(int)getErrHappendTimes:(int)errIndex{
    
    if(errIndex<errHappendTimes.count)
    {
        NSNumber *num=errHappendTimes[errIndex];
        return [num intValue];
        
    }else{
        return 0;
    }
}

-(void)setErrHappendTimes:(int)errIndex ErrTimes:(int)errTimes {
    
    if(errIndex<errHappendTimes.count)
    {
        errHappendTimes[errIndex]=[NSNumber numberWithInt:errTimes];
        
    }
    
}

-(void)setMeasurementTimes:(int)vmeasurementTimes {
    measurementTimes = vmeasurementTimes;
}

-(int)getMeasurementTimes{
    return measurementTimes;
}

-(NSString*)toString{
    
    NSString *msg=[NSString stringWithFormat:@"DeviceInfo ID:%@\nmeasurementTimes:%d\nerrHappendTimes:%@",ID,measurementTimes,errHappendTimes];
    
    return msg;
}

@end
