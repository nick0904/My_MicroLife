//
//  PulseRecord.m
//  MicroLifeDeviceSDK
//
//  Created by Tom on 2016/9/13.
//  Copyright © 2016年 Tom. All rights reserved.
//

#import "PulseRecord.h"

@implementation PulseRecord
{
    int header;
    NSMutableArray *rawDataOfPulseRate;
}

-(void)setHeader:(int)vheader {
    header = vheader;
}

-(int)getHeader{
    return header;
}

-(void)setRawDataOfPulseRate:(NSMutableArray*)vrawDataOfPulseRate{
    rawDataOfPulseRate = vrawDataOfPulseRate;
}

-(NSMutableArray*)getRawDataOfPulseRate{
    return rawDataOfPulseRate;
}



@end
