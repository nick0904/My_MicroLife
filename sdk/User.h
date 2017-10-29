//
//  User.h
//  MicroLifeDeviceSDK
//
//  Created by Tom on 2016/9/14.
//  Copyright © 2016年 Tom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject


/**
 *
 * @param NO   Current user, User1 = 1, User2 = 2, Guest = 3
 */
-(void)setNO:(int)vNo;

/**
 *
 * @return  Current user, User1 = 1, User2 = 2, Guest = 3
 */
-(int)getNO;

-(void)setID:(NSString *)vID;

-(NSString*)getID;

-(void)setAge:(int)vage;

-(int)getAge;


-(NSString*)toString;

@end
