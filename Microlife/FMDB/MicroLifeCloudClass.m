//
//  MicroLifeCloudClass.m
//  Microlife
//
//  Created by 曾偉亮 on 2017/2/15.
//  Copyright © 2017年 Rex. All rights reserved.
//

#import "MicroLifeCloudClass.h"
#import "CheckNetwork.h"


@implementation MicroLifeCloudClass

-(id)init {
    
    self = [super init];
    
    if (self) {
        
        serverURL = REAL_URL;
    }
    
    return self;
}

#pragma mark - 非同步  **************************************************************
///一般非同步
-(void)postDataAsync:(NSMutableDictionary*)postDict APIName:(NSString*)apiName EventId:(int)eventid
{
    
    if (![CheckNetwork isExistenceNetwork]) {
        
        [self.delegate networkError];
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@%@",serverURL,apiName];
    
    NSString *BoundaryConstant = [NSString stringWithFormat:@"----------%lld",arc4random()%10000000000];
    
    NSURL* requestURL = [NSURL URLWithString:url];
    
    // create request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:30];
    [request setHTTPMethod:@"POST"];

    // set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", BoundaryConstant];
    
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // post body
    NSMutableData *body = [NSMutableData data];
    
    // add params (all params are strings)
    for (NSString *param in postDict) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [postDict objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    [request setURL:requestURL];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc]init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        //test
#ifdef DEBUG
        NSString *responseData = [[NSString alloc]initWithData: data
                                                      encoding: NSUTF8StringEncoding
                                  ];
        NSLog(@"Response = %@", responseData);
        
#endif
        
        [self.delegate MicorLifeCloudResponseData:response Data:data Error:error EventID:eventid];
        
    }];
    
}


///非同步相片+文字檔
-(void)postDataAsync:(NSMutableDictionary*)postDict APIName:(NSString*)apiName EventId:(int)eventid withImage:(UIImage *)image withFile:(NSString*)filePath {
    
    if (![CheckNetwork isExistenceNetwork]) {
        
        [self.delegate networkError];
        
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@%@",serverURL,apiName];
    
    NSString *BoundaryConstant = [NSString stringWithFormat:@"----------%lld",arc4random()%10000000000];
    
    NSURL* requestURL = [NSURL URLWithString:url];
    
    // create request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:30];
    [request setHTTPMethod:@"POST"];
    
    // set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", BoundaryConstant];
    
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // post body
    NSMutableData *body = [NSMutableData data];
    
    // add params (all params are strings)
    for (NSString *param in postDict) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [postDict objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    //圖片
    [UIImage imageWithCGImage:[image  CGImage]
                        scale:[image scale]
                  orientation: UIImageOrientationUp];
    
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    
    if (imageData) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"photo\"; filename=\"%@\"\r\n",@"jpg"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    /**
    //文字檔
    NSError *txtError;
    
    NSData *txtData = [NSData dataWithContentsOfFile:filePath
                                             options:NSDataReadingMappedIfSafe error:&txtError];
    if (txtData) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"filename\"; filename=\"%@\"\r\n",@"occcccc"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:txtData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    */
    
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    [request setURL:requestURL];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc]init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        //test
#ifdef DEBUG
        NSString *responseData = [[NSString alloc]initWithData: data
                                                      encoding: NSUTF8StringEncoding
                                  ];
        NSLog(@"Response = %@", responseData);
        
#endif
        
        [self.delegate MicorLifeCloudResponseData:response Data:data Error:error EventID:eventid];
        
    }];
    
}



#pragma mark - 同步  **************************************************************
//立即同步
-(void)postDataSync:(NSMutableDictionary*)postDict APIName:(NSString*)apiName EventId:(int)eventid
{
    
    if (![CheckNetwork isExistenceNetwork]) {
        
        [self.delegate networkError];
        
        return;
    }
    
    
    NSString *url = [NSString stringWithFormat:@"%@%@",serverURL,apiName];
    
    NSString *BoundaryConstant = [NSString stringWithFormat:@"----------%lld",arc4random()%10000000000];
    
    NSURL* requestURL = [NSURL URLWithString:url];
    
    // create request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:30];
    [request setHTTPMethod:@"POST"];
    
    // set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", BoundaryConstant];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // post body
    NSMutableData *body = [NSMutableData data];
    
    // add params (all params are strings)
    for (NSString *param in postDict) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [postDict objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    
    
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    [request setURL:requestURL];
    
    NSError *error;
    NSURLResponse *response = nil;
    
    NSData *data = [NSURLConnection
                    sendSynchronousRequest: request
                    returningResponse: &response
                    error: &error
                    ];
    
    
    //test
#ifdef DEBUG
    NSString *responseData = [[NSString alloc]initWithData: data
                                                  encoding: NSUTF8StringEncoding
                              ];
    NSLog(@"Response = %@", responseData);
    
#endif
    
    [self.delegate MicorLifeCloudResponseData:response Data:data Error:error EventID:eventid];
    
}


//立即同步相片+文字檔
-(void)postDataSync:(NSMutableDictionary*)postDict APIName:(NSString*)apiName EventId:(int)eventid withImage:(UIImage *)image withFile:(NSString*)filePath
{
    
    if (![CheckNetwork isExistenceNetwork]) {
        
        [self.delegate networkError];
        
        return;
    }
    
    
    NSString *url = [NSString stringWithFormat:@"%@%@",serverURL,apiName];
    
    NSString *BoundaryConstant = [NSString stringWithFormat:@"----------%ld",arc4random()%10000000000];
    
    NSURL* requestURL = [NSURL URLWithString:url];
    
    // create request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:30];
    [request setHTTPMethod:@"POST"];
    
    // set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", BoundaryConstant];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // post body
    NSMutableData *body = [NSMutableData data];
    
    // add params (all params are strings)
    for (NSString *param in postDict) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [postDict objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    
    //圖片
    [UIImage imageWithCGImage:[image  CGImage]
                        scale:[image scale]
                  orientation: UIImageOrientationUp];
    
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    
    if (imageData) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"photo\"; filename=\"%@\"\r\n",@"jpg"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    
    //文字檔
    NSError *txtError;
    
    NSData *txtData = [NSData dataWithContentsOfFile:filePath
                                             options:NSDataReadingMappedIfSafe error:&txtError];
    if (txtData) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"filename\"; filename=\"%@\"\r\n",@"occcccc"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:txtData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    [request setURL:requestURL];
    
    NSError *error;
    NSURLResponse *response = nil;
    
    NSData *data = [NSURLConnection
                    sendSynchronousRequest: request
                    returningResponse: &response
                    error: &error
                    ];
    
    
    //test
#ifdef DEBUG
    NSString *responseData = [[NSString alloc]initWithData: data
                                                  encoding: NSUTF8StringEncoding
                              ];
    NSLog(@"Response = %@", responseData);
    
#endif
    
    [self.delegate MicorLifeCloudResponseData:response Data:data Error:error EventID:eventid];
    
}


#pragma mark - 非同步相片
-(void)postDataAsync:(NSMutableDictionary *)postDic APIName:(NSString *)apiName EventId:(int)eventid withImage:(UIImage *)image {
    
    if (![CheckNetwork isExistenceNetwork]) {
        
        [self.delegate networkError];
        
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@%@",serverURL,apiName];
    
    NSString *BoundaryConstant = [NSString stringWithFormat:@"----------%ld",arc4random()%10000000000];
    
    NSURL* requestURL = [NSURL URLWithString:url];
    
    // create request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:30];
    [request setHTTPMethod:@"POST"];
    
    // set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", BoundaryConstant];
    
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // post body
    NSMutableData *body = [NSMutableData data];
    
    // add params (all params are strings)
    for (NSString *param in postDic) {
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [postDic objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    //圖片
    [UIImage imageWithCGImage:[image  CGImage]
                        scale:[image scale]
                  orientation: UIImageOrientationUp];
    
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    
    if (imageData) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"photo\"; filename=\"%@\"\r\n",@"jpg"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    [request setURL:requestURL];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc]init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        //test
#ifdef DEBUG
        NSString *responseData = [[NSString alloc]initWithData: data
                                                      encoding: NSUTF8StringEncoding
                                  ];
        NSLog(@"Response = %@", responseData);
        
#endif
        
        [self.delegate MicorLifeCloudResponseData:response Data:data Error:error EventID:eventid];
        
    }];

}



#pragma mark - 非同步相片+錄音檔
-(void)postDataAsync:(NSMutableDictionary *)postDic APIName:(NSString *)apiName EventId:(int)eventid withImage:(UIImage *)image withRecording:(NSData *)recording{
    
    if (![CheckNetwork isExistenceNetwork]) {
        
        [self.delegate networkError];
        
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@%@",serverURL,apiName];
    
    NSString *BoundaryConstant = [NSString stringWithFormat:@"----------%ld",arc4random()%10000000000];
    
    NSURL* requestURL = [NSURL URLWithString:url];
    
    // create request
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:30];
    [request setHTTPMethod:@"POST"];
    
    // set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", BoundaryConstant];
    
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // post body
    NSMutableData *body = [NSMutableData data];
    
    // add params (all params are strings)
    for (NSString *param in postDic) {
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@\r\n", [postDic objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    //圖片
    [UIImage imageWithCGImage:[image  CGImage]
                        scale:[image scale]
                  orientation: UIImageOrientationUp];
    
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    
    if (imageData) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"photo\"; filename=\"%@\"\r\n",@"jpg"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    
    //錄音檔
    
    
    
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    [request setURL:requestURL];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc]init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        //test
#ifdef DEBUG
        NSString *responseData = [[NSString alloc]initWithData: data
                                                      encoding: NSUTF8StringEncoding
                                  ];
        NSLog(@"Response = %@", responseData);
        
#endif
        
        [self.delegate MicorLifeCloudResponseData:response Data:data Error:error EventID:eventid];
        
    }];

    
}



@end
