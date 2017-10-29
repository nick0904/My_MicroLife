//
//  OscillationData.m
//  MicroLifeDeviceSDK
//
//  Created by Tom on 2016/9/13.
//  Copyright © 2016年 Tom. All rights reserved.
//

#import "OscillationData.h"

@implementation OscillationData
{
    NSMutableArray *pressureData;
    NSMutableArray *amplitudeData;
}

-(void)setPressureData:(NSMutableArray*)vpressureData{
    pressureData = vpressureData;
}

-(NSMutableArray*)getPressureData{
    return pressureData;
}

-(void)setAmplitudeData:(NSMutableArray*)vamplitudeData{
    amplitudeData = vamplitudeData;
}

-(NSMutableArray*)getAmplitudeData{
    return amplitudeData;
}


-(NSString*)toString{

    NSString *msg=[NSString stringWithFormat:@"OscillationData==>pressureData:%@\namplitudeData:%@",pressureData,amplitudeData];

    return msg;
    
}

@end
