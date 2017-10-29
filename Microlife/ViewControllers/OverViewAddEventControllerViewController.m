//
//  OverViewAddEventControllerViewController.m
//  Microlife
//
//  Created by 曾偉亮 on 2016/10/14.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import "OverViewAddEventControllerViewController.h"
#import "MViewController.h"


@interface OverViewAddEventControllerViewController () <APIPostAndResponseDelegate,UITextFieldDelegate> {
    
    UIDatePicker *datePickerView;
    NSMutableArray *eventArray;
    
    //API
    APIPostAndResponse *apiClass;
    
}

@end

@implementation OverViewAddEventControllerViewController

@synthesize ary_userDataStr,nameTextField,typeTextField,dateTextField,editing;

-(id)initWithAddEventViewController:(CGRect)frame {
    
    self = [super init];
    
    if (!self) return nil;
    
    self.view.backgroundColor = TABLE_BACKGROUND;//[UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1.0];
    
    
    //API
    apiClass = [[APIPostAndResponse alloc] initCloud];
    apiClass.delegate = self;
    
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createBarbuttonItem];
    
    [self createViews];
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    if(nameTextField.text.length>0 || typeTextField.text.length>0 || dateTextField.text.length>0){
        
        nameTextField.text = @"";
        typeTextField.text = @"";
        dateTextField.text = @"";
    }
    
    
    if (ary_userDataStr != nil || ary_userDataStr.count != 0) {
        
        [ary_userDataStr removeAllObjects];
        
        ary_userDataStr = nil;
    }
    
    self.nameTextField.placeholder = NSLocalizedString(@"Name ", nil);
    self.typeTextField.placeholder = NSLocalizedString(@"rheum", nil);
    
    [self getEventDataFromDataBase];
    
}


-(void)viewWillDisappear:(BOOL)animated {
    
    if (eventArray != nil) {
        
        [eventArray removeAllObjects];
        eventArray = nil;
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



-(void)createBarbuttonItem {
    
    //title
    
    //if (_editing) {
    //
    //}
    self.navigationItem.title = @"Add Event";
    
    
    //設定leftBarButtonItem
    UIButton *leftItemBt = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 35 , 35)];
    
    [leftItemBt setImage:[UIImage imageNamed:@"all_btn_a_back"] forState:UIControlStateNormal];
    
    [leftItemBt addTarget:self action:@selector(pushToMainOverViewVC) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftItemBt];
    
    
    //設定rightBarButtonItem
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveUserData)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    
}

-(void)updateDateTextField:(id)sender{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"YYYY/MM/dd HH:mm";
    dateTextField.text = [dateFormatter stringFromDate:datePickerView.date];
}

-(void)createViews {
    
    //datePickerView
    datePickerView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/3)];
    datePickerView.backgroundColor = [UIColor whiteColor];
    
    CGFloat viewHeight = self.view.frame.size.height/15;
    CGFloat space = 2.5;
    [datePickerView addTarget:self action:@selector(updateDateTextField:) forControlEvents:UIControlEventValueChanged];

    NSDate *currentDate = [NSDate date];
    datePickerView.maximumDate = currentDate;
    
    
    
    
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
    nameLabel.text = NSLocalizedString(@"Event", nil);
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
    

    
    CGFloat textFieldWidth = (ary_bgview[0].frame.size.width - labelWidth) * 0.8;
    CGFloat textFieldHeight = ary_bgview[0].frame.size.height *0.88;
    CGFloat textFieldSpace = ary_bgview[0].frame.size.height - textFieldHeight;
    
    //將nameTextField 加到 ary_bgView[0] 上
    nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(nameLabel.frame), textFieldSpace/2, textFieldWidth, textFieldHeight)];
    [nameTextField addTarget:self action:@selector(textFieldEditChanging:) forControlEvents:UIControlEventEditingChanged];
    [ary_bgview[0] addSubview:nameTextField];
    
    //將typeTextField 加到 ary_bgView[1] 上
    typeTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(typeLabel.frame), textFieldSpace/2, textFieldWidth, textFieldHeight)];
    [ary_bgview[1] addSubview:typeTextField];
    
    //將dateTextField 加到 ary_bgView[2] 上
     dateTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(dateLabel.frame), textFieldSpace/2, textFieldWidth, textFieldHeight)];
    [ary_bgview[2] addSubview:dateTextField];
    dateTextField.delegate = self;
    dateTextField.inputView = datePickerView;
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([textField isEqual:dateTextField]) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"YYYY/MM/dd HH:mm";
        dateTextField.text = [dateFormatter stringFromDate:datePickerView.date];
    }
}

#pragma mark - pushToMainOverViewVC
-(void)pushToMainOverViewVC {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - saveUserData
-(void)saveUserData {
    
    [self revokeKeyboard];
    
    //判斷textField是否為空值
    if (nameTextField.text.length <= 0 ) {
        
        [MViewController showAlert:NSLocalizedString(@"Alert", nil) message:NSLocalizedString(@"Please insert Event", nil) buttonTitle:NSLocalizedString(@"Confirm", nil)];
        
        return;
    }
    
    if (typeTextField.text.length <= 0) {
        
        [MViewController showAlert:NSLocalizedString(@"Alert", nil) message:NSLocalizedString(@"Please insert Type", nil) buttonTitle:NSLocalizedString(@"Confirm", nil)];
        
        return;
    }
    
    if (dateTextField.text.length <= 0 ) {
        
        [MViewController showAlert:NSLocalizedString(@"Alert", nil) message:NSLocalizedString(@"Please insert Date", nil) buttonTitle:NSLocalizedString(@"Confirm", nil)];
        
        return;
    }
    
    
    //判斷event名稱是否有重覆
    for (int i = 0; i < eventArray.count; i++) {
        
        if ([nameTextField.text isEqualToString:eventArray[i]]) {
            //重覆跳alert
            
            [MViewController showAlert:NSLocalizedString(@"Alert", nil) message:NSLocalizedString(@"This name has existed in Event List. Please reset the new name.", nil) buttonTitle:NSLocalizedString(@"Confirm", nil)];
            nameTextField.text = @"Name";
            return;
        }
        
    }

    
    int theEventId = 0;
    NSUInteger currentCount = [[EventClass sharedInstance] selectAllData].count;
    if (currentCount == 0) {
        //第一次新增,強制設定 event_code = 1
        theEventId = 1;
    }
    else {
        
        NSMutableArray *tempAry = [[EventClass sharedInstance] selectAllData];
        NSLog(@"tempAry get All:%@",tempAry);
        theEventId = [[[tempAry lastObject] objectForKey:@"eventID"] intValue]+1;
//        NSMutableArray *ary_num = [[NSMutableArray alloc] initWithObjects:@"1",@"2",@"3",@"4",@"5", nil];
//        for ( int i = 0; i < tempAry.count; i++) {
//            
//            NSLog(@"tempAry eventId ==>>>> %@",tempAry[i]);
//            
//            for (int j = 0; j < ary_num.count; j++)
//                
//                if ([[tempAry[i] objectForKey:@"eventID"] isEqualToString:ary_num[j]]) {
//                    
//                    [ary_num removeObjectAtIndex:j];
//                }
//            
//        }
//        
//        NSLog(@"ary_num = %@",ary_num);
//        
//        theEventId = [ary_num[0] intValue];
//        NSLog(@"ary_num[0]:%@ num:%d",ary_num[0],[ary_num[0] intValue]);
    }
    
    NSLog(@"theEventId ===>> %d",theEventId);
    
    //API
    if (![CheckNetwork isExistenceNetwork]) {
        
        [MViewController showAlert:NETWORK_TITLE message:NETWORK_MESSAGE buttonTitle:NETWORK_CONFIRM];
        return;
    }
    else {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
           
            NSString *tokenStr = [NSString stringWithContentsOfFile:OAuth_TOKEN encoding:NSUTF8StringEncoding error:nil];
            
            [apiClass postAddBTEvent:tokenStr event_code:theEventId event:nameTextField.text type:typeTextField.text event_time:dateTextField.text];
        });
        
    }
    
    
    ary_userDataStr = [[NSMutableArray alloc] init];
    [ary_userDataStr addObject: nameTextField.text];
    [ary_userDataStr addObject: typeTextField.text];
    [ary_userDataStr addObject: dateTextField.text];

    
    [EventClass sharedInstance].type = typeTextField.text;
    [EventClass sharedInstance].event = nameTextField.text;
    [EventClass sharedInstance].eventTime = dateTextField.text;
    [EventClass sharedInstance].eventID = theEventId;
    [[EventClass sharedInstance] insertData];
    
    
    NSLog(@"ary_userDataStr:%@",ary_userDataStr);
    
    if (self.m_superVC != nil) {
        
        self.m_superVC.isListBtEnable = YES;
    }

    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

-(void)showAlertWithTitle:(NSString *)title withMessage:(NSString *)message{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleDefault handler:nil];
    
    [alert addAction:okAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}


#pragma mark - TextField Edit changing
-(void)textFieldEditChanging:(UITextField *)textField  {
    
    if (textField == self.nameTextField) {
        
        NSUInteger textLength = [MViewController getStringLength:textField.text];
        
        if (textLength > 50) {
            
           textField.text = [textField.text substringWithRange:NSMakeRange(0, 50)];
            
            [MViewController showAlert:NSLocalizedString(@"Alert", nil) message:NSLocalizedString(@"The string length is limited to 50 characters", nil) buttonTitle:NSLocalizedString(@"OK", nil)];
        }
        
    }

}


#pragma mark - 從資料庫撈 event 資料
-(void)getEventDataFromDataBase {
    
    if (eventArray == nil) {
        
        eventArray = [[NSMutableArray alloc] init];
    }
    
    [eventArray removeAllObjects];
    
    NSMutableArray *tempAry = [[EventClass sharedInstance] selectAllData];
    
    //只取event
    for (int i = 0; i < tempAry.count; i++) {
        
        NSString *event = [tempAry[i] objectForKey:@"event"];
        
        [eventArray addObject:event];
    }
    
}


#pragma mark - 收起所有鍵盤及PickerView選項
-(void)revokeKeyboard {
    
    [nameTextField resignFirstResponder];
    [typeTextField resignFirstResponder];
    [dateTextField resignFirstResponder];
}


#pragma mark - touchEvents
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self revokeKeyboard];
}


#pragma mark - API Delegate  ************************
-(void)processAddBTEvent:(NSDictionary *)resopnseData Error:(NSError *)jsonError {
    
    if (jsonError) {
        
        NSLog(@"AddBTEvent jsonError:%@",jsonError);
    }
    else {
        
        NSLog(@"AddBTEvent response:%@",resopnseData);
    }
    
}


@end
