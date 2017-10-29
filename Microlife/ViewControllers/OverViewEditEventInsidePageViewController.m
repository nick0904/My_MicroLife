//
//  OverViewEditEventInsidePageViewController.m
//  Microlife
//
//  Created by 曾偉亮 on 2017/1/19.
//  Copyright © 2017年 Rex. All rights reserved.
//

#import "OverViewEditEventInsidePageViewController.h"
#import "MViewController.h"

@interface OverViewEditEventInsidePageViewController () <APIPostAndResponseDelegate> {
    
    NSMutableArray *ary_event;
    NSString *userNameStr;
    NSString *typeStr;
    NSString *dateStr;
    NSString *eventIDStr;
    NSString *accountIDStr;
    
    UIDatePicker *datePickerView;
    UITextField *nameTextField;
    UITextField *typeTextField;
    UITextField *dateTextField;
    
    //API
    APIPostAndResponse *apiClass;

}

@end

@implementation OverViewEditEventInsidePageViewController

#pragma mark - Normal Functions  **********************
-(id)initWithEventInsidePageFrame:(CGRect)frame {
    
    self = [super init];
    
    if (!self) return nil;

    self.view.backgroundColor = TABLE_BACKGROUND;
    
    [self reloadData];
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = TABLE_BACKGROUND;
    [self intiWithNavigationBar];
    [self initWithUIObject];

}

-(void)viewWillAppear:(BOOL)animated {
    
    [self reloadData];
    
    self.tabBarController.tabBar.hidden = YES;
    self.navigationItem.title = userNameStr;
    nameTextField.text = userNameStr;
    typeTextField.text = typeStr;
    dateTextField.text = dateStr;
}


-(void)viewWillDisappear:(BOOL)animated {
    
    [self revokeKeyboard];
    
    if (ary_event != nil) {
        
        [ary_event removeAllObjects];
        ary_event = nil;
    }
    
     self.tabBarController.tabBar.hidden = NO;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - initalization  ***********************
-(void)intiWithNavigationBar {
    
    //設定leftBarButtonItem
    UIButton *leftItemBt = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 35 , 35)];
    
    [leftItemBt setImage:[UIImage imageNamed:@"all_btn_a_back"] forState:UIControlStateNormal];
    
    [leftItemBt addTarget:self action:@selector(backToPrePage) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftItemBt];

    //設定rightBarButtonItem
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveUserDataAction)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
}

-(void)initWithUIObject {
    
    CGFloat viewHeight = self.view.frame.size.height/15;
    CGFloat space = 2.5;
    
    //datePickerView
    datePickerView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/3)];
    datePickerView.backgroundColor = [UIColor whiteColor];
    [datePickerView addTarget:self action:@selector(updateDateTextField:) forControlEvents:UIControlEventValueChanged];
    
    NSMutableArray<UIView *> *ary_bgview = [[NSMutableArray alloc] init];
    
    //生成三個底圖白色的view
    for (int i = 0; i < 3; i++) {
        
        UIView *bgview = [[UIView alloc] initWithFrame:CGRectMake(0, viewHeight*(i+1)+space*i, self.view.frame.size.width, viewHeight)];
        
        bgview.backgroundColor = [UIColor whiteColor];
        
        [self.view addSubview:bgview];
        
        [ary_bgview addObject:bgview];
    }
    
    CGFloat labelWidth = ary_bgview[0].frame.size.width/5;
    CGFloat labelHeight = ary_bgview[0].frame.size.height;
    
    //nameLabel
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, labelWidth, labelHeight)];
    nameLabel.text = NSLocalizedString(@"Person", nil);
    nameLabel.textAlignment = NSTextAlignmentLeft;
    [ary_bgview[0] addSubview:nameLabel];
    
    //typeLabel
    UILabel *typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, labelWidth, labelHeight)];
    typeLabel.text = NSLocalizedString(@"Type", nil);
    typeTextField.textAlignment = NSTextAlignmentLeft;
    [ary_bgview[1] addSubview:typeLabel];
    
    //dateLabel
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, labelWidth, labelHeight)];
    dateLabel.text = NSLocalizedString(@"Date", nil);
    dateTextField.textAlignment = NSTextAlignmentLeft;
    [ary_bgview[2] addSubview:dateLabel];

    
    CGFloat textFieldWidth = (ary_bgview[0].frame.size.width - labelWidth) *0.95;
    CGFloat textFieldHeight = ary_bgview[0].frame.size.height *0.88;
    CGFloat textFieldSpace = ary_bgview[0].frame.size.height - textFieldHeight;
    
    //將nameTextField 加到 ary_bgView[0] 上
    nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(nameLabel.frame), textFieldSpace/2, textFieldWidth, textFieldHeight)];
    nameTextField.clearButtonMode = UITextFieldViewModeAlways;
    [nameTextField addTarget:self action:@selector(textFieldEditChanging:) forControlEvents:UIControlEventEditingChanged];
    [ary_bgview[0] addSubview:nameTextField];
    
    //將typeTextField 加到 ary_bgView[1] 上
    typeTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(typeLabel.frame), textFieldSpace/2, textFieldWidth, textFieldHeight)];
    [ary_bgview[1] addSubview:typeTextField];
    
    //將dateTextField 加到 ary_bgView[2] 上
    dateTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(dateLabel.frame), textFieldSpace/2, textFieldWidth, textFieldHeight)];
    [ary_bgview[2] addSubview:dateTextField];
    dateTextField.inputView = datePickerView;
    
    //
    UIImageView *dateImage = [[UIImageView alloc]initWithFrame:CGRectMake(dateTextField.frame.size.width-27, dateTextField.frame.size.height/2-9.5, 19, 19.)];
    dateImage.image = [UIImage imageNamed:@"all_icon_a_arrow_down"];
    [dateTextField addSubview:dateImage];
    
    //API
    apiClass = [[APIPostAndResponse alloc] initCloud];
    apiClass.delegate = self;

}


-(void)updateDateTextField:(id)sender{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"YYYY/MM/dd HH:mm";
    
    dateTextField.text = [dateFormatter stringFromDate:datePickerView.date];
}


#pragma mark - reloadData  ********************
-(void)reloadData {
    
    if (ary_event == nil) {
        
        ary_event = [[NSMutableArray alloc] init];
    }
    
    ary_event = [[EventClass sharedInstance] selectAllData];
    
    userNameStr = [ary_event[self.insidePageIndex] objectForKey:@"event"];
    typeStr = [ary_event[self.insidePageIndex] objectForKey:@"type"];
    dateStr = [ary_event[self.insidePageIndex] objectForKey:@"eventTime"];
    eventIDStr = [NSString stringWithFormat:@"%@",[ary_event [self.insidePageIndex] objectForKey:@"eventID"]];
    accountIDStr = [NSString stringWithFormat:@"%@", [ary_event [self.insidePageIndex] objectForKey:@"accountID"]];
    
}

#pragma mark - Btn Actions  ********************
-(void)backToPrePage {
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)saveUserDataAction {
    
    [self revokeKeyboard];
    
    if (nameTextField.text.length <= 0 ) {
        
        [self showAlert:NSLocalizedString(@"Please insert person", nil) message:@""];
        
        return;
    }
    
    if (typeTextField.text.length <= 0) {

        [self showAlert:NSLocalizedString(@"Please insert type", nil) message:@""];
        
        return;
    }
    
    if (dateTextField.text.length <= 0 ) {
        
        [self showAlert:NSLocalizedString(@"Please insert date", nil) message:@""];
        
        return;
    }

    
    self.navigationItem.title = nameTextField.text;
    
    if (![CheckNetwork isExistenceNetwork]) {
        
        [MViewController showAlert:NETWORK_TITLE message:NETWORK_MESSAGE buttonTitle:NETWORK_CONFIRM];
    }
    else {
        
        NSString *tokenStr = [NSString stringWithContentsOfFile:OAuth_TOKEN encoding:NSUTF8StringEncoding error:nil];
        
        [apiClass postEditBTEvent:tokenStr event_code: [eventIDStr intValue] event:nameTextField.text type:typeTextField.text event_time:dateTextField.text delete:0];
    }
    
    
    //儲存至資料庫
    [EventClass sharedInstance].event = nameTextField.text;
    [EventClass sharedInstance].type = typeTextField.text;
    [EventClass sharedInstance].eventTime = dateTextField.text;
    [EventClass sharedInstance].eventID = [eventIDStr intValue];
    [EventClass sharedInstance].accountID = [accountIDStr intValue];
    [[EventClass sharedInstance] updateData];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}


#pragma mark - TextField 相關  ********************
-(void)textFieldEditChanging:(UITextField *)textField  {
    
    if (textField == nameTextField) {
        
        NSUInteger textLength = [MViewController getStringLength:textField.text];
        
        if (textLength > 50) {
            
            textField.text = [textField.text substringWithRange:NSMakeRange(0, 50)];
            
            [MViewController showAlert:NSLocalizedString(@"Alert", nil) message:NSLocalizedString(@"The string length is limited to 50 characters", nil) buttonTitle:NSLocalizedString(@"OK", nil)];
        }
        
    }

}


//鍵盤收回
-(void)revokeKeyboard {
    
    [nameTextField resignFirstResponder];
    [typeTextField resignFirstResponder];
    [dateTextField resignFirstResponder];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self revokeKeyboard];
}


#pragma mark - Alert
-(void)showAlert:(NSString *)title message:(NSString *)message {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles: nil];
    [alert show];
    alert = nil;
    
}


#pragma mark - API Delegate
-(void)processeEditBTEvent:(NSDictionary *)resopnseData Error:(NSError *)jsonError {
    
    if (jsonError) {
        
        NSLog(@"EditBTEvent error:%@",jsonError);
    }
    else {
        
        NSLog(@"EditBTEvent response:%@",resopnseData);
    }
    
}

@end
