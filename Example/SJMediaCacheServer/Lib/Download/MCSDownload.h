//
//  SJDataDownload.h
//  SJMediaCacheServer_Example
//
//  Created by BlueDancer on 2020/5/30.
//  Copyright © 2020 changsanjiang@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol MCSDownloadTaskDelegate;
NS_ASSUME_NONNULL_BEGIN
@interface MCSDownload : NSObject
+ (instancetype)shared;

@property (nonatomic) NSTimeInterval timeoutInterval;

@property (nonatomic, copy, nullable) NSMutableURLRequest *_Nullable(^requestHandler)(NSMutableURLRequest *request);

- (nullable NSURLSessionTask *)downloadWithRequest:(NSURLRequest *)request delegate:(id<MCSDownloadTaskDelegate>)delegate;

- (nullable NSURLSessionTask *)downloadWithRequest:(NSURLRequest *)request completionHandler:(void (^)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))completionHandler;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
@end

@protocol MCSDownloadTaskDelegate <NSObject>
- (void)downloadTask:(NSURLSessionTask *)task didReceiveResponse:(NSURLResponse *)response;
- (void)downloadTask:(NSURLSessionTask *)task didReceiveData:(NSData *)data;
- (void)downloadTask:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error;
@end
NS_ASSUME_NONNULL_END
