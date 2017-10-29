//
//  MailSelector.h
//  Microlife
//
//  Created by 曾偉亮 on 2017/3/16.
//  Copyright © 2017年 Rex. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MailSelectorDelegate <NSObject>

-(void)confirmOrCancel:(int)confirm checkMark:(NSMutableArray *)ary_checkMark; //confirm = 0 ,cancel = otherwise

@end



@class MainHistoryViewController;

@interface MailSelector : NSObject <UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate>

@property (strong, nonatomic) MainHistoryViewController *superVC;

@property (strong, nonatomic) NSMutableArray *ary_mailList;

@property (strong) id <MailSelectorDelegate> delegate;

@property (nonatomic, retain) UITextField *emailTextField;

-(id)initMailSelector;

-(void)reloadMailListData;

-(void)showMailSelectorAlert;

@end
