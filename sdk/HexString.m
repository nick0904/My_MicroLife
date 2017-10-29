//
//  HexString.m
//  MicroLifeDeviceSDK
//
//  Created by Tom on 2016/9/8.
//  Copyright © 2016年 Tom. All rights reserved.
//

#import "HexString.h"
#import "Function.h"

@implementation HexString
{
    NSString *inputString;
    
}

-(id)initInputString:(NSString*) input
{
    self=[super init];
    
    if(self)
    {
        inputString=input;
    }
    
    return self;
    
}

-(int)parseInt:(int)offset
{
    int ret=[Function hexStringToInt:[inputString substringToIndex:offset]];
    
    //
    inputString=[inputString substringFromIndex:offset];
    
    return ret;
}

-(NSString*)cutStr:(int)offset {
    
    NSString *ret =[inputString substringToIndex:offset];
    
    inputString=[inputString substringFromIndex:offset];
        
    return ret;
}

-(NSInteger)length {
    
    return inputString.length;
}

@end
