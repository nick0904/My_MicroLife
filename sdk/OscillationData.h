//
//  OscillationData.h
//  MicroLifeDeviceSDK
//
//  Created by Tom on 2016/9/13.
//  Copyright © 2016年 Tom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OscillationData : NSObject

-(void)setPressureData:(NSMutableArray*)vpressureData;

-(NSMutableArray*)getPressureData;

-(void)setAmplitudeData:(NSMutableArray*)vamplitudeData;

-(NSMutableArray*)getAmplitudeData;

-(NSString*)toString;

@end
