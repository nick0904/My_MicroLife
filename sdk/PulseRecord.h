//
//  PulseRecord.h
//  MicroLifeDeviceSDK
//
//  Created by Tom on 2016/9/13.
//  Copyright © 2016年 Tom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PulseRecord : NSObject

-(void)setHeader:(int)vheader;

-(int)getHeader;

-(void)setRawDataOfPulseRate:(NSMutableArray*)vrawDataOfPulseRate;

-(NSMutableArray*)getRawDataOfPulseRate;

@end
