//
//  EditListViewController.m
//  Microlife
//
//  Created by Rex on 2016/9/19.
//  Copyright © 2016年 Rex. All rights reserved.
//

#import "EditListViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioServices.h>
#import "UIImage+FixOrientation.h"
#import "APIPostAndResponse.h"

@interface EditListViewController ()<UITextViewDelegate,AVAudioRecorderDelegate,AVAudioPlayerDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,APIPostAndResponseDelegate>{
    UIView *actionBtnBase;      //功能列
    UITextView *noteTextView;   //文字輸入框
    UIScrollView *noteScroll;
    UIImagePickerController *imagePicker;
    UIImageView *photoImage;    //相簿圖片
    UIImage *tempImg;           //相簿圖片暫存
    float navHeight;
    UIButton *recordBtn;        //錄音鈕
    float keyboardHeight;
    UIView *recordView;         //錄音狀態列
    UIButton *deleteImgBtn;
    
    UIImageView *animateBase;   //錄音特效放大view-淺色
    UIImageView *animateView;   //錄音特效view-深色
    
    AVAudioPlayer *audioPlayer;
    AVAudioRecorder *audioRecoder;
    
    UIButton *playRecordBtn;
    NSString *recordTimeStr;
    UILabel *recordTimeLab;
    UIView *recordRedView;
    
    UILabel *playTimeLab;
    NSTimer *recordTimer;
    
    BOOL isRecord;
    BOOL isPlay;
    BOOL hasOldRecord;
    BOOL didRecord;
    BOOL didSave;
    
    int totalRecordTime;
    
    NSURL *outputFileURL;           //錄音輸出路徑
    NSDictionary *listDict;
    int dataID;
    NSString *noteStr;
    NSString *photoPath;
    NSString *recordPath;           //儲存的路徑
    NSString *newRecordPath;        //新開錄音路徑
    int listType;
    
    APIPostAndResponse *apiClass;
}

@end

@implementation EditListViewController


#pragma mark - Normal Function  ******************************
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initNavigationBar];
    [self initParameter];
    [self initInterface];
    
}


-(void)viewDidAppear:(BOOL)animated{
    
    imagePicker.delegate = nil;
    
    apiClass = [[APIPostAndResponse alloc] initCloud];
    apiClass.delegate = self;
    
    NSLog(@"tempImg  =%@",tempImg);
    
    if (tempImg != nil) {
        photoImage.image = tempImg;
        
        CGFloat img_width;
        CGFloat img_height;
        int scaleSize;
        
        if (tempImg.size.width > photoImage.frame.size.width) {
            
            scaleSize = tempImg.size.width / photoImage.frame.size.width;
            img_width = photoImage.frame.size.width;
            img_height = tempImg.size.height / scaleSize;
        }
        else{
            
            img_width = tempImg.size.width;
            img_height = tempImg.size.height;
        }
        
        NSLog(@"img_width = %f",img_width);
        NSLog(@"img_width = %f",img_height);
        NSLog(@"tempImg.size.width = %f",tempImg.size.width);
        NSLog(@"tempImg.size.height = %f",tempImg.size.height);
        
        photoImage.frame = CGRectMake(photoImage.frame.origin.x, photoImage.frame.origin.y,img_width, img_height);
        deleteImgBtn.hidden = NO;
    }
    else{
        deleteImgBtn.hidden = YES;
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - initlization  ******************************
-(void)initNavigationBar {
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
    self.navigationItem.title = @"Note";
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    
    [backButton setBackgroundImage:[UIImage imageNamed:@"all_btn_a_cancel"] forState:UIControlStateNormal];
    
    [backButton addTarget:self action:@selector(backToListVCAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveNoteAction)];
    
    [saveButton setTintColor:[UIColor whiteColor]];
    
    self.navigationItem.rightBarButtonItem = saveButton;

}



-(void)initParameter{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    //錄音初始化
    
    // Set the audio file
//    NSArray *pathComponents = [NSArray arrayWithObjects:
//                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
//                               @"MyAudioMemo.m4a",
//                               nil];
    
    //NSURL *outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
    
    listDict = [[LocalData sharedInstance] getEditListDict];
    
    dataID = [[listDict objectForKey:@"ID"] intValue];
    noteStr = [listDict objectForKey:@"note"];
    photoPath = [listDict objectForKey:@"photoPath"];
    recordPath = [listDict objectForKey:@"recordingPath"];
    listType = [[listDict objectForKey:@"listType"] intValue];
    
    NSURL *imgURL = [NSURL fileURLWithPath:[AppDelegate getDataPathWithFileName:photoPath]];
    
    NSData *imageData = [NSData dataWithContentsOfURL:imgURL];
    //tempImg = [self loadImage];
    
    tempImg = [UIImage imageWithData:imageData];
    //tempImg = [UIImage imageWithContentsOfFile:photoPath];
    
    [tempImg fixOrientation];
    
    NSLog(@"tempImg = %@",tempImg);
    NSLog(@"recordPath = %@",recordPath);
    NSLog(@"photoPath = %@",photoPath);
    NSLog(@"noteStr = %@",noteStr);
    NSLog(@"imgURL = %@",imgURL);
    
    if ([noteStr isEqualToString:@""] || noteStr == nil) {
        noteStr = @" ";
    }
    
    didRecord = NO;
    didSave = NO;
    newRecordPath = [self getPathFile];
    
    NSLog(@"newRecordPath = %@",newRecordPath);
    
    outputFileURL = [NSURL fileURLWithPath:[AppDelegate getDataPathWithFileName:newRecordPath]];
    
    hasOldRecord = NO;
    
    if (recordPath.length != 0) {
        
        hasOldRecord = YES;
    }
    
    [self setUpAudioRecord];
    
    
    isRecord = NO;
    isPlay = NO;
    
}

- (UIImage*)loadImage {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:
                      photoPath];
    UIImage* image = [UIImage imageWithContentsOfFile:path];
    
    return image;
}

-(void)setUpAudioRecord{
    // Setup audio session
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    //提高音量
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error: nil];
    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
    AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,
                             sizeof (audioRouteOverride),&audioRouteOverride);
    
    
    // Define the recorder setting
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    
    
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    
    NSLog(@"outputFileURL = %@",outputFileURL);
    
    // Initiate and prepare the recorder
    audioRecoder = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:recordSetting error:NULL];
    audioRecoder.delegate = self;
    audioRecoder.meteringEnabled = YES;
    [audioRecoder prepareToRecord];

}

- (NSString *)getPathFile {
    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentPath = [paths firstObject];
//    
//    NSDate *currentDate = [NSDate date];
//    
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    
//    formatter.dateFormat = @"YYYY-MM-DD_HH:mm:ss";
//    
//    NSString *dateString = [formatter stringFromDate:currentDate];
//    
//    newRecordPath = [NSString stringWithFormat:@"record-%@.caf",dateString];
//    
//    NSString *dbPath = [documentPath stringByAppendingPathComponent:newRecordPath];
//    
//    NSLog(@"%@",dbPath);
//    return dbPath;
    
    NSDate *currentDate = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    formatter.dateFormat = @"YYYY-MM-DD_HH:mm:ss";
    
    NSString *dateString = [formatter stringFromDate:currentDate];
    
    newRecordPath = [NSString stringWithFormat:@"record-%@.caf",dateString];
    
    return newRecordPath;
}

-(void)initInterface{
    
    navHeight = self.navigationController.navigationBar.bounds.size.height+20;
    
    UIColor *lineColor = [UIColor colorWithRed:231.0/255.0 green:232.0/255.0 blue:235.0/255.0 alpha:1];
    
    actionBtnBase = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-navHeight-SCREEN_HEIGHT*0.063, SCREEN_WIDTH, SCREEN_HEIGHT*0.063)];
    
    actionBtnBase.backgroundColor = [UIColor whiteColor];
    
    UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, actionBtnBase.frame.size.width, 1)];
    
    UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, actionBtnBase.frame.size.height, actionBtnBase.frame.size.width, 1)];
    
    topLineView.backgroundColor = lineColor;
    bottomLineView.backgroundColor = lineColor;
    
    [actionBtnBase addSubview:topLineView];
    [actionBtnBase addSubview:bottomLineView];
    
    float iconWidth = 46/self.imgScale;
    float iconHeight = 47/self.imgScale;
    float iconSpace = SCREEN_WIDTH*0.053;
    
    
    //cameraBtn
    UIButton *cameraBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, actionBtnBase.frame.size.height/2-iconHeight/2, iconWidth, iconHeight)];
    
    [cameraBtn setImage:[UIImage imageNamed:@"history_icon_a_camera"] forState:UIControlStateNormal];
    [cameraBtn addTarget:self action:@selector(openCameraAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *albumBtn = [[UIButton alloc] initWithFrame:CGRectMake(cameraBtn.frame.origin.x+cameraBtn.frame.size.width+iconSpace, actionBtnBase.frame.size.height/2-iconHeight/2, iconWidth, iconHeight)];
    
    [albumBtn addTarget:self action:@selector(openAlbumAction) forControlEvents:UIControlEventTouchUpInside];
    [albumBtn setImage:[UIImage imageNamed:@"history_icon_a_pic"] forState:UIControlStateNormal];
    
    
    //recordBtn
    recordBtn = [[UIButton alloc] initWithFrame:CGRectMake(albumBtn.frame.origin.x+albumBtn.frame.size.width+iconSpace, actionBtnBase.frame.size.height/2-iconHeight/2, iconWidth, iconHeight)];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [recordBtn addGestureRecognizer:longPress];
    
    [recordBtn setImage:[UIImage imageNamed:@"history_icon_a_rec_0"] forState:UIControlStateNormal];
    
    recordTimeLab = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.773, 0, SCREEN_WIDTH*0.16, actionBtnBase.frame.size.height)];
    
    recordTimeLab.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:20];
    
    recordRedView = [[UIView alloc] initWithFrame:CGRectMake(recordTimeLab.frame.origin.x+recordTimeLab.frame.size.width+5, actionBtnBase.frame.size.height/2-5, 10, 10)];

    recordRedView.backgroundColor = CIRCEL_RED;
    recordRedView.layer.cornerRadius = recordRedView.frame.size.width/2;
    recordRedView.hidden = YES;
    
    float scrollHeight = self.view.frame.size.height-actionBtnBase.frame.size.height-navHeight;
    
    noteScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, scrollHeight)];
    
    [noteScroll setContentSize:CGSizeMake(self.view.frame.size.width, noteScroll.frame.size.height-navHeight+100)];

    
    //note
    noteTextView = [[UITextView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-self.view.frame.size.width*0.9/2, 0, self.view.frame.size.width*0.9, SCREEN_HEIGHT*0.074)];
    [noteTextView setFont:[UIFont systemFontOfSize:15.0]];
    noteTextView.text = noteStr;
    noteTextView.scrollEnabled = NO;
    noteTextView.delegate = self;
    
    
    float deleteIconSize = 35/self.imgScale;
    
    photoImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-self.view.frame.size.width*0.9/2, noteTextView.frame.origin.y+noteTextView.frame.size.height+self.view.frame.size.height*0.018, self.view.frame.size.width*0.9, 100)];
    
    photoImage.userInteractionEnabled = YES;
    
    deleteImgBtn = [[UIButton alloc] initWithFrame:CGRectMake(photoImage.frame.size.width-5-deleteIconSize, 5, deleteIconSize, deleteIconSize)];
    
    [deleteImgBtn setImage:[UIImage imageNamed:@"history_icon_a_cancel"] forState:UIControlStateNormal];
    
    [deleteImgBtn addTarget:self action:@selector(deleteImgAction) forControlEvents:UIControlEventTouchUpInside];
    
    imagePicker = [[UIImagePickerController alloc]init];
    
    imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    recordView = [[UIView alloc] initWithFrame:CGRectMake(0, actionBtnBase.frame.origin.y-SCREEN_HEIGHT*0.063, SCREEN_WIDTH, SCREEN_HEIGHT*0.063)];
    
    recordView.backgroundColor = [UIColor colorWithRed:210.0/255.0 green:220.0/255.0 blue:238.0/255.0 alpha:1];
    
    recordView.hidden = YES;
    
    float recordIconSize = 66/self.imgScale;
    
    playRecordBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*0.03, recordView.frame.size.height/2-recordIconSize/2, recordIconSize, recordIconSize)];
    
    [playRecordBtn setImage:[UIImage imageNamed:@"history_icon_a_note_play"] forState:UIControlStateNormal];
    [playRecordBtn addTarget:self action:@selector(playRecordAction) forControlEvents:UIControlEventTouchUpInside];
    
    float soundWidth = 29/self.imgScale;
    float soundHeight = 45/self.imgScale;
    
    playTimeLab = [[UILabel alloc] initWithFrame:CGRectMake(recordView.frame.size.width/2-SCREEN_WIDTH*0.173/2+soundWidth, 0, SCREEN_WIDTH*0.173, recordView.frame.size.height)];
    
    playTimeLab.textColor = STANDER_COLOR;
    playTimeLab.text = @"00:00";
    playTimeLab.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:20];
    
    UIImageView *soundIcon = [[UIImageView alloc] initWithFrame:CGRectMake(playTimeLab.frame.origin.x-soundWidth-5, recordView.frame.size.height/2-soundHeight/2, soundWidth, soundHeight)];
    
    soundIcon.image = [UIImage imageNamed:@"history_icon_a_voice"];
    
    UIButton *deleteRecordBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-SCREEN_WIDTH*0.026-deleteIconSize, recordView.frame.size.height/2-deleteIconSize/2, deleteIconSize, deleteIconSize)];
    
    [deleteRecordBtn setImage:[UIImage imageNamed:@"history_icon_a_cancel"] forState:UIControlStateNormal];
    [deleteRecordBtn addTarget:self action:@selector(deleteReocrdAction) forControlEvents:UIControlEventTouchUpInside];
    
    if (tempImg == nil) {
        deleteImgBtn.hidden = YES;
    }else{
        deleteImgBtn.hidden = NO;
    }
    
    [self.view addSubview:noteScroll];
    [noteScroll addSubview:noteTextView];
    [noteScroll addSubview:photoImage];
    [photoImage addSubview:deleteImgBtn];
    
    [self.view addSubview:recordView];
    [recordView addSubview:playRecordBtn];
    [recordView addSubview:soundIcon];
    [recordView addSubview:playTimeLab];
    [recordView addSubview:deleteRecordBtn];
    
    
    [self.view addSubview:actionBtnBase];
    [actionBtnBase addSubview:cameraBtn];
    [actionBtnBase addSubview:albumBtn];
    [actionBtnBase addSubview:recordBtn];
    [actionBtnBase addSubview:recordTimeLab];
    [actionBtnBase addSubview:recordRedView];
    
    
    if(hasOldRecord){
        playTimeLab.text = recordTimeStr;
        recordView.hidden = NO;
    }
    
}

- (void)keyboardWillShow:(NSNotification *)notification {
    keyboardHeight = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    
    actionBtnBase.frame = CGRectMake(0, actionBtnBase.frame.origin.y-keyboardHeight, actionBtnBase.frame.size.width, actionBtnBase.frame.size.height);
    
    recordView.frame = CGRectMake(0, actionBtnBase.frame.origin.y-recordView.frame.size.height, recordView.frame.size.width, recordView.frame.size.height);
}



#pragma mark - Button actions  **************************
-(void)playRecordAction{

    if (hasOldRecord && !didRecord) {
        
        NSURL *oldRecordPath = [NSURL fileURLWithPath:[AppDelegate getDataPathWithFileName:recordPath]];
        
        NSLog(@"play recordPath = %@",oldRecordPath);
        
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:oldRecordPath error:nil];
        
    }else{
        
        NSLog(@"audioRecoder.url = %@",audioRecoder.url);
        
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioRecoder.url error:nil];
    }
    
    [audioPlayer setDelegate:self];
    
    
    if (!isPlay) {
        isPlay = YES;
        playTimeLab.text = @"00:00";
        [playRecordBtn setImage:[UIImage imageNamed:@"history_icon_a_note_stop"] forState:UIControlStateNormal];
        
        [audioPlayer play];
        
        recordTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(trackRecordTime) userInfo:nil repeats:YES];
    }else{
        isPlay = NO;
        
        [playRecordBtn setImage:[UIImage imageNamed:@"history_icon_a_note_play"] forState:UIControlStateNormal];
        
        [audioPlayer pause];
        
        [recordTimer invalidate];
    }
    
    NSLog(@"audioPlayer.currentTime = %f",audioPlayer.currentTime);
    
    NSLog(@"playRecord");
}

-(void)deleteReocrdAction{
    
    [playRecordBtn setImage:[UIImage imageNamed:@"history_icon_a_note_play"] forState:UIControlStateNormal];
    [recordTimer invalidate];
    recordView.hidden = YES;
    [audioPlayer stop];
    isPlay = NO;
    didRecord = NO;
    hasOldRecord = NO;
//    recordPath = newRecordPath;
    [[NSFileManager defaultManager] removeItemAtPath:[AppDelegate getDataPathWithFileName:recordPath] error:nil];
    recordPath = @"";

    NSLog(@"deleteReocrd");
}

-(void)deleteImgAction{
    
    photoImage.image = nil;
    deleteImgBtn.hidden = YES;
    
    NSLog(@"deleteImg");
    
}


-(void)openCameraAction {
    
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.allowsEditing = YES;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

-(void)openAlbumAction{
    
    imagePicker.delegate = self;
    imagePicker.allowsEditing = NO;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:imagePicker animated:YES completion:nil];
    
}


-(void)backToListVCAction{
    
    if(!didRecord || !didSave){
        
        NSError *error;
        
        [[NSFileManager defaultManager]removeItemAtPath:[AppDelegate getDataPathWithFileName:newRecordPath] error:&error];
    }
    
    
    
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
        
    [self.navigationController popViewControllerAnimated:YES];
    
}




- (void)longPress:(UILongPressGestureRecognizer*)gesture {
    
    float recordCircelSize = 166/self.imgScale;
    
    CGRect circleFrame = CGRectMake(recordBtn.center.x-recordCircelSize/2, recordBtn.center.y-recordCircelSize/2, recordCircelSize, recordCircelSize);
    
    UIImageView *whiteMicro;
    
    didRecord = YES;
    
    if (hasOldRecord) {
        NSError *error;
        
        [[NSFileManager defaultManager]removeItemAtPath:[AppDelegate getDataPathWithFileName:recordPath] error:&error];
    }

    
    if ( gesture.state == UIGestureRecognizerStateBegan ) {
        NSLog(@"Long Press began");
        [recordTimer invalidate];
        isRecord = YES;
        recordView.hidden = YES;
        recordRedView.hidden = NO;
        recordTimeStr = @"00:00";
        recordTimeLab.text = recordTimeStr;
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setActive:YES error:nil];
        
        // Start recording
        [audioRecoder record];
        
        recordTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(trackRecordTime) userInfo:nil repeats:YES];
        
        animateBase = [[UIImageView alloc] initWithFrame:circleFrame];
        animateBase.image = [UIImage imageNamed:@"history_ef_a_1"];
        
        animateView = [[UIImageView alloc] initWithFrame:circleFrame];
        animateView.image = [UIImage imageNamed:@"history_ef_a_2"];
        
        float whiteMicroWidth = 26/self.imgScale;
        float whiteMicroHeight = 47/self.imgScale;
        
        whiteMicro = [[UIImageView alloc] initWithFrame:CGRectMake(animateBase.frame.size.width/2-whiteMicroWidth/2, animateBase.frame.size.height/2-whiteMicroHeight/2, whiteMicroWidth, whiteMicroHeight)];
        
        whiteMicro.image = [UIImage imageNamed:@"history_icon_a_rec_1"];

        [actionBtnBase addSubview:animateBase];
        [actionBtnBase addSubview:animateView];
        [actionBtnBase bringSubviewToFront:animateBase];
        [actionBtnBase bringSubviewToFront:animateView];
        [animateBase addSubview:whiteMicro];
        
        //UIViewKeyframeAnimationOptionAutoreverse |
        
        [UIView animateKeyframesWithDuration:2.0 delay:0.0 options: UIViewKeyframeAnimationOptionRepeat animations:^{
            [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.2 animations:^{
                
                animateView.transform =  CGAffineTransformMakeScale(1.5, 1.5);
            }];
            [UIView addKeyframeWithRelativeStartTime:0.2 relativeDuration:0.2 animations:^{
                animateView.alpha = 0;
            }];
        } completion:nil];
    }
    
    if ( gesture.state == UIGestureRecognizerStateEnded ) {
        NSLog(@"Long Press end");
        isRecord = NO;
        [audioRecoder stop];
        
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setActive:NO error:nil];
        
        [recordTimer invalidate];
        
        [animateBase removeFromSuperview];
        [animateView removeFromSuperview];
        [whiteMicro removeFromSuperview];
        animateBase.hidden = YES;
        animateView.hidden = YES;
    }
}

-(void)trackRecordTime{
    
    int recordMin;
    int recordSec;
    
    if (isRecord) {
        
        recordMin = audioRecoder.currentTime/60;
        recordSec = audioRecoder.currentTime-recordMin*60;
        
        recordTimeStr = [NSString stringWithFormat:@"%02d:%02d",recordMin,recordSec];
        
        recordTimeLab.text = recordTimeStr;
        
        NSLog(@"recordTimeLab = %@",recordTimeLab.text);
        
    }else{
        recordMin = audioPlayer.currentTime/60;
        recordSec = audioPlayer.currentTime-recordMin*60;
        
        
        NSLog(@"audioPlayer.currentTime = %f",audioPlayer.currentTime);
        playTimeLab.text = [NSString stringWithFormat:@"%02d:%02d",recordMin,recordSec];
        NSLog(@"playTimeLab = %@",playTimeLab.text);
    }
    
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)avrecorder successfully:(BOOL)flag{
    
    if ([recordTimeStr isEqualToString:@""] || recordTimeStr == nil) {
        recordTimeStr = @"00:00";
    }
    
    recordPath = newRecordPath;
    NSLog(@"recordPath = %@",recordPath);
    
    playTimeLab.text = recordTimeStr;
    recordView.hidden = NO;
    recordRedView.hidden = YES;
    recordTimeLab.text = @"";
    NSLog(@"flag = %d",flag);
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    playTimeLab.text = recordTimeStr;
    [playRecordBtn setImage:[UIImage imageNamed:@"history_icon_a_note_play"] forState:UIControlStateNormal];
    [recordTimer invalidate];
    isPlay = NO;
    NSLog(@"audioPlayerDidFinishPlaying");
}

#pragma mark - Photo Delegate  ****************************
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *pickedImg = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    tempImg = pickedImg;

    photoImage.image = nil;
    
}

#pragma mark - TextView Delegate  ***************************
-(void)textViewDidBeginEditing:(UITextView *)textView{
    
    if ([noteTextView.text isEqualToString:@" "]) {
        noteTextView.text = @"";
    }
    
}

-(void)textViewDidChange:(UITextView *)textView{
    
    CGFloat fixedWidth = noteTextView.frame.size.width;
    CGSize newSize = [noteTextView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = noteTextView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    noteTextView.frame = newFrame;

    photoImage.frame = CGRectMake(photoImage.frame.origin.x, noteTextView.frame.origin.y+noteTextView.frame.size.height+self.view.frame.size.height*0.018, photoImage.frame.size.width, photoImage.frame.size.height);
    
    float scrollContent = noteTextView.frame.size.height+self.view.frame.size.height*0.018+photoImage.frame.size.height+100;
    
    [noteScroll setContentSize:CGSizeMake(self.view.frame.size.width, scrollContent)];
}


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    
    if ([text isEqualToString:@"\n"]) {
        
        [noteTextView resignFirstResponder];
        
        [UIView transitionWithView:self.view duration:0.1 options:UIViewAnimationOptionTransitionNone animations:^{
            
            actionBtnBase.frame = CGRectMake(-1, SCREEN_HEIGHT-navHeight-SCREEN_HEIGHT*0.063, SCREEN_WIDTH+2, SCREEN_HEIGHT*0.063);
            recordView.frame =  CGRectMake(0, actionBtnBase.frame.origin.y-SCREEN_HEIGHT*0.063, SCREEN_WIDTH, SCREEN_HEIGHT*0.063);
            
        } completion:^(BOOL finished) {
        
        }];
    }
    
    //textView 字數上限
    NSString *str = [NSString stringWithFormat:@"%@%@",textView.text,text];
    if (str.length > 100) {
        
        NSRange rangeIndex = [str rangeOfComposedCharacterSequenceAtIndex:100];
        
        if (rangeIndex.length == 1) {
            
            textView.text = [str substringToIndex:100];
        }
        else {
            
            NSRange theRange = [str rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, 100)];
            textView.text = [str substringWithRange:theRange];
        }
        
        return NO;
    }
    
    return YES;
}




#pragma mark - update Data  **************************
///Blood Pressure Data
-(void)updateBPMdata{
    
    //資料庫日期格式需為YYYY-MM-dd
    NSString *dateStr = [listDict objectForKey:@"date"];
    dateStr = [dateStr stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
    
    [BPMClass sharedInstance].BPM_ID = dataID;
    [BPMClass sharedInstance].SYS = [[listDict objectForKey:@"SYS"] intValue];
    [BPMClass sharedInstance].DIA = [[listDict objectForKey:@"DIA"] intValue];
    [BPMClass sharedInstance].PUL = [[listDict objectForKey:@"PUL"] intValue];
    [BPMClass sharedInstance].AFIB = [[listDict objectForKey:@"AFIB"] intValue];
    [BPMClass sharedInstance].PAD = [[listDict objectForKey:@"PAD"] intValue];
    [BPMClass sharedInstance].date = dateStr;
    [BPMClass sharedInstance].BPM_Note = noteStr;
    [BPMClass sharedInstance].BPM_PhotoPath = photoPath;
    [BPMClass sharedInstance].BPM_RecordingPath = recordPath;
    
    [[BPMClass sharedInstance] updateData];
    
    NSLog(@"selectAllData = %@",[[BPMClass sharedInstance] selectAllData]);
    NSString *tokenStr = [NSString stringWithContentsOfFile:OAuth_TOKEN encoding:NSUTF8StringEncoding error:nil];
    [apiClass postAddNoteData:tokenStr type_id:[NSString stringWithFormat:@"%d",dataID] note_type:1 note:noteStr photo:photoImage.image recording:nil recording_time:@""];
}


///Weight Data
-(void)updateWeightData {
    //資料庫日期格式需為YYYY-MM-dd
    NSString *dateStr = [listDict objectForKey:@"date"];
    dateStr = [dateStr stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
    
    [WeightClass sharedInstance].weightID = dataID;
    [WeightClass sharedInstance].weight = [[listDict objectForKey:@"weight"]floatValue];
    [WeightClass sharedInstance].date = dateStr;
    [WeightClass sharedInstance].water = [[listDict objectForKey:@"water"]intValue];
    [WeightClass sharedInstance].bodyFat = [[listDict objectForKey:@"bodyFat"] floatValue];
    [WeightClass sharedInstance].muscle = [[listDict objectForKey:@"muscle"]intValue];
    [WeightClass sharedInstance].skeleton = [[listDict objectForKey:@"skeleton"]intValue];
    [WeightClass sharedInstance].BMI = [[listDict objectForKey:@"BMI"]floatValue];
    [WeightClass sharedInstance].BMR = [[listDict objectForKey:@"bmr"] intValue];
    [WeightClass sharedInstance].organFat = [[listDict objectForKey:@"organFat"]intValue];
    [WeightClass sharedInstance].weight_PhotoPath = photoPath;
    [WeightClass sharedInstance].weight_Note = noteStr;
    [WeightClass sharedInstance].weight_RecordingPath = recordPath;
    
    [[WeightClass sharedInstance] updateData];
    
    NSLog(@"selectAllData = %@",[[WeightClass sharedInstance] selectAllData]);

}


///Temprature Data
-(void)updateTempData{
    //資料庫日期格式需為YYYY-MM-dd
    NSString *dateStr = [listDict objectForKey:@"date"];
    dateStr = [dateStr stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
    
    [BTClass sharedInstance].BT_ID = dataID;
    [BTClass sharedInstance].bodyTemp = [listDict objectForKey:@"bodyTemp"];
    [BTClass sharedInstance].roomTmep = [listDict objectForKey:@"roomTemp"];
    [BTClass sharedInstance].BT_Note = noteStr;
    [BTClass sharedInstance].BT_PhotoPath = photoPath;
    [BTClass sharedInstance].BT_RecordingPath = recordPath;
    [BTClass sharedInstance].date = dateStr;
    
    [[BTClass sharedInstance] updateData];
    
    NSLog(@"Temp selectAllData = %@",[[BTClass sharedInstance] selectAllData]);
}

//APIPostAndResponseDelegate
-(void)processeAddNoteData:(NSDictionary *)resopnseData Error:(NSError *)jsonError {
    NSLog(@"processeAddNoteData:%@",resopnseData);
}

#pragma mark - save Note  **************************
-(void)saveNoteAction{
    
    noteStr = noteTextView.text;
    
    didSave = YES;
    
    
    [self saveImageToFilePath];
    
    
    switch (listType) {
        case 0:
            [self updateBPMdata];
            break;
        case 1:
            [self updateWeightData];
            break;
        case 2:
            [self updateTempData];
            break;
        default:
            break;
    }
    
    //監聽事件通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SaveNoteAction" object:nil userInfo:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)saveImageToFilePath{
    
    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
//    
//    NSString *fileName = [NSString stringWithFormat:@"NoteImage-ID%d",dataID];
//    
//    photoPath = [documentsPath stringByAppendingPathComponent:fileName]; //Add the file name
//    
//    [imageData writeToFile:photoPath atomically:YES];
    
    if (photoImage.image) {
        NSData *imageData = UIImageJPEGRepresentation(tempImg, 1.0);
        
        photoPath = [NSString stringWithFormat:@"NoteImage-ID%d",dataID];
        
        [imageData writeToFile:[AppDelegate getDataPathWithFileName:photoPath] atomically:YES];
    }else {
        [[NSFileManager defaultManager] removeItemAtPath:[AppDelegate getDataPathWithFileName:[NSString stringWithFormat:@"NoteImage-ID%d",dataID]] error:nil];
        photoPath = @"";
    }
    
}

@end
