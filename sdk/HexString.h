//
//  HexString.h
//  MicroLifeDeviceSDK
//
//  Created by Tom on 2016/9/8.
//  Copyright © 2016年 Tom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HexString : NSObject

-(id)initInputString:(NSString*) input;
-(int)parseInt:(int)offset;
-(NSString*)cutStr:(int)offset;
-(NSInteger)length;

@end
