//
//  MCSSessionTask.m
//  SJMediaCacheServer_Example
//
//  Created by BlueDancer on 2020/6/2.
//  Copyright © 2020 changsanjiang@gmail.com. All rights reserved.
//

#import "MCSSessionTask.h"
#import "MCSResourceManager.h"

@interface MCSSessionTask ()<MCSResourceReaderDelegate>
@property (nonatomic, weak) id<MCSSessionTaskDelegate> delegate;
@property (nonatomic, strong) NSURLRequest * request;
@property (nonatomic, strong) id<MCSResource> resource;
@property (nonatomic, strong) id<MCSResourceReader> reader;
@end

@implementation MCSSessionTask
- (instancetype)initWithRequest:(NSURLRequest *)request delegate:(id<MCSSessionTaskDelegate>)delegate {
    self = [super init];
    if ( self ) {
        _request = request;
        _delegate = delegate;
    }
    return self;
}

- (void)prepare {
    _resource = [MCSResourceManager.shared resourceWithURL:_request.URL];
    _reader = [_resource readerWithRequest:_request];
    _reader.delegate = self;
    @autoreleasepool {
        [_reader prepare];
    }
}

- (NSDictionary *)responseHeaders {
    return _reader.response.responseHeaders;
}

- (NSUInteger)contentLength {
    return _reader.response.totalLength;
}

- (nullable NSData *)readDataOfLength:(NSUInteger)length {
    return [_reader readDataOfLength:length];
}

- (NSUInteger)offset {
    return _reader.offset;
}

- (BOOL)isPrepared {
    return _reader.isPrepared;
}

- (BOOL)isDone {
    return _reader.isReadingEndOfData;
}

- (void)close {
    [_reader close];
}

#pragma mark -

- (void)readerPrepareDidFinish:(id<MCSResourceReader>)reader {
    if ( !_reader.isClosed ) [_delegate taskPrepareDidFinish:self];
}

- (void)readerHasAvailableData:(id<MCSResourceReader>)reader {
    if ( !_reader.isClosed ) [_delegate taskHasAvailableData:self];
}

- (void)reader:(id<MCSResourceReader>)reader anErrorOccurred:(NSError *)error {
    if ( !_reader.isClosed ) [_delegate task:self anErrorOccurred:error];
}
@end
