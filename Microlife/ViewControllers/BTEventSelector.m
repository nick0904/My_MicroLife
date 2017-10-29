//
//  BTEventSelector.m
//  Microlife
//
//  Created by 曾偉亮 on 2017/3/7.
//  Copyright © 2017年 Rex. All rights reserved.
//

#import "BTEventSelector.h"
#import "MainOverviewViewController.h"

@implementation BTEventSelector {
    
    UIViewController *alert_rootVC;
    
    UITableView *alert_TableView;
    
    NSMutableArray *ary_checkMark;
}


-(id)initBTEventSelector {
    
    self = [super init];
    
    if (!self) return nil;
    
    [self initParam];
    
    [self initUIObj];
    
    return self;
}



#pragma mark - init  *********************************
-(void)initParam {
    
    self.ary_BTEventData = [[NSMutableArray alloc] init];
    
    ary_checkMark = [[NSMutableArray alloc] init];
    
}

-(void)initUIObj {
    
    //alert_rootVC init
    alert_rootVC = [[UIViewController alloc] init];
    
    //rect
    CGRect rect = CGRectMake(0, 0, 272, 200);
    [alert_rootVC setPreferredContentSize:rect.size];
    
    //alert_TableView
    alert_TableView = [[UITableView alloc] initWithFrame:rect];
    alert_TableView.delegate = self;
    alert_TableView.dataSource = self;
    [alert_TableView setUserInteractionEnabled:YES];
    [alert_TableView setAllowsSelection:YES];
    [alert_rootVC.view addSubview:alert_TableView];
    [alert_rootVC.view bringSubviewToFront:alert_TableView];
    [alert_rootVC.view setUserInteractionEnabled:YES];

}


-(void)reloadBTEventData {
    
    for (int i = 0; i < self.ary_BTEventData.count; i++) {
        
        [ary_checkMark addObject:@"0"];
    }
    
}



#pragma mark - TableView Delegate & DataSource  *********************************
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return ary_checkMark.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cell_Id = @"BTEventSelector_ID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_Id];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_Id];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    
    for (int i = 0; i < ary_checkMark.count; i++) {
        
        cell.accessoryType = [ary_checkMark[indexPath.row] isEqualToString:@"0"] ? UITableViewCellAccessoryNone : UITableViewCellAccessoryCheckmark ;
    }
    
    cell.textLabel.text = [self.ary_BTEventData[indexPath.row] objectForKey:@"event"];
    
    return cell;

}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    for (int i = 0; i < ary_checkMark.count; i++) {
        ary_checkMark[i] = i == indexPath.row ? [self.ary_BTEventData[indexPath.row] objectForKey:@"eventID"] : @"0";
    }
    
    [alert_TableView reloadData];
}



#pragma mark - show Alert
-(void)showBTEventSelectorAlert {
    
    UIAlertController *alertShow = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Which event do you want to keep your measure datas?", nil)  message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertShow setValue:alert_rootVC forKey:@"contentViewController"];
    
    //cancelAction
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
       
        [self.delegate confirmOrCancel:1 checkMark:ary_checkMark];
        
    }];
    
    //confirmAction
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Confirm", nil)  style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
         [self.delegate confirmOrCancel:0 checkMark:ary_checkMark];
        
    }];
    
    [alertShow addAction:cancelAction];
    [alertShow addAction:confirmAction];
    
    if (self.superVC != nil){
    
        [self.superVC presentViewController:alertShow animated:YES completion:nil];
    }

}

@end
