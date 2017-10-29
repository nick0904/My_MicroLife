//
//  MailSelector.m
//  Microlife
//
//  Created by 曾偉亮 on 2017/3/16.
//  Copyright © 2017年 Rex. All rights reserved.
//

#import "MailSelector.h"
#import "MainHistoryViewController.h"

@implementation MailSelector {
    
    UIViewController *alert_rootVC;
    
    UITableView *alert_TableView;
    
    NSMutableArray *ary_checkMark;

}

-(id)initMailSelector {
    
    self = [super init];
    
    if (!self) return nil;
    
    [self initParam];
    
    [self initUIObj];
    
    return self;

}

#pragma mark - initilization  **********************
-(void)initParam {
    
    self.ary_mailList = [[NSMutableArray alloc] init];
    
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


-(void)reloadMailListData {
    
    for (int i = 0; i < self.ary_mailList.count+1; i++) {
        [ary_checkMark addObject:@"0"];
    }
    
}

- (UITextField *)emailTextField {
    if (!_emailTextField) {
        self.emailTextField = [UITextField new];
        self.emailTextField.delegate = self;
        self.emailTextField.placeholder = @"E-mail";
        self.emailTextField.keyboardType = UIKeyboardTypeEmailAddress;
    }
    return _emailTextField;
}

#pragma mark - TableView Delegate & DataSource  *********************************
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSLog(@"self.ary_mailList.count:%lu",(unsigned long)self.ary_mailList.count);
    
    return self.ary_mailList.count+1;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cell_id = @"MailSelector_ID";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_id];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    
    for (int i = 0; i < ary_checkMark.count; i++) {
    
//        cell.accessoryType = [ary_checkMark[indexPath.row] isEqualToString:@"1"] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
        cell.accessoryType = [ary_checkMark[indexPath.row] isEqualToString:@"0"] ? UITableViewCellAccessoryNone:UITableViewCellAccessoryCheckmark;
    }
    
    NSLog(@"self.ary_mailList:%@",self.ary_mailList);
    
    if (indexPath.row == 0) {
        if (cell.accessoryType == UITableViewCellAccessoryNone) {
            cell.textLabel.text = @"E-mail";
            cell.textLabel.textColor = [UIColor grayColor];
        }else {
            cell.textLabel.text = @"";
            [self.emailTextField setFrame:cell.textLabel.frame];
            [cell addSubview:self.emailTextField];
        }
        
    }else {
        cell.textLabel.text = [self.ary_mailList[indexPath.row-1] objectForKey:@"name"];
    }
    
    
    return cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    for (int i = 0; i < ary_checkMark.count; i++) {
        if (i == 0) {
            ary_checkMark[i] = i == indexPath.row ? self.emailTextField.text : @"0";
        }else {
            ary_checkMark[i] = i == indexPath.row ? [self.ary_mailList[indexPath.row-1] objectForKey:@"email"] : @"0";
        }
    }
    
    [alert_TableView reloadData];
}

#pragma mark - UITextFieldDelegate
//結束編輯狀態(意指完成輸入或離開焦點)
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.text.length > 0) {
        ary_checkMark[0] = self.emailTextField.text;
    }
}


#pragma mark - show Alert  *********************************
-(void)showMailSelectorAlert {
    
    UIAlertController *alertShow = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Which email do you want to send your measure datas?", nil)  message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
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
