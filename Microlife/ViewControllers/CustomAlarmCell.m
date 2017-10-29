//
//  CustomAlarmCell.m
//  Microlife
//
//  Created by Rex on 2016/9/2.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import "CustomAlarmCell.h"
#import "AlertConfigClass.h"

@implementation CustomAlarmCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        // Initialization code
        
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"CustomAlarmCell" owner:self options:nil];
        
        // 如果路径不存在，return nil
        
        if (arrayOfViews.count < 1)
            
            return nil;
        
        // 如果xib中view不属于UICollectionViewCell类，return nil
        
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UITableViewCell class]])
            
            return nil;
        
        // NSLog(@"arrayOfViews  %i",arrayOfViews.count);
        
        // 加载nib
        
        self = [arrayOfViews objectAtIndex:0];
        
        [self.alarmSwitch addTarget:self action:@selector(alarmSwitchAction) forControlEvents:UIControlEventValueChanged];
        
    }
    
    return self;
}

-(void)alarmSwitchAction{
    
    NSMutableArray * reminderArray = [[LocalData sharedInstance] getReminderData];
    
    NSMutableDictionary *reminderDict = [reminderArray objectAtIndex:self.cellIndex];
    
    NSNumber *switchStatus = [NSNumber numberWithBool:self.alarmSwitch.on];
    
    [reminderDict setObject:switchStatus forKey:@"status"];
    
    NSLog(@"alarm switch");
    
    //update db..
    
    NSString *jsonRs=[ShareCommon DictionaryToJson:reminderArray];
    
    NSLog(@"jsonRs:%@",jsonRs);
    
    AlertConfigClass *alertConfigClass=[[AlertConfigClass alloc]init];
    alertConfigClass.accountID=[LocalData sharedInstance].accountID;
    alertConfigClass.alertConfig=jsonRs;
    
    [alertConfigClass insertData];
    
    [alertConfigClass closeDatabase];

    [alertConfigClass PushLoacaleMessage:reminderArray];
    
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect cellRect = self.bounds;
    cellRect.size.width = self.frame.size.width;
    
    self.bounds = cellRect;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
