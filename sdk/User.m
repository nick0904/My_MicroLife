//
//  User.m
//  MicroLifeDeviceSDK
//
//  Created by Tom on 2016/9/14.
//  Copyright © 2016年 Tom. All rights reserved.
//

#import "User.h"

@implementation User
{
    int No;
    NSString *ID;
    int age;
}

/**
 *
 * @param NO   Current user, User1 = 1, User2 = 2, Guest = 3
 */
-(void)setNO:(int)vNo{
    No = vNo;
}

/**
 *
 * @return  Current user, User1 = 1, User2 = 2, Guest = 3
 */
-(int)getNO{
    return No;
}

-(void)setID:(NSString *)vID {
    ID = vID;
}

-(NSString*)getID {
    return ID;
}

-(void)setAge:(int)vage{
    age = vage;
}

-(int)getAge {
    return age;
}


-(NSString*)toString{
    
    NSString *msg=[NSString stringWithFormat:@"User NO=%d\nID=%@\nage=%d\n",No,ID,age];
    
    return msg;
    
}


@end
