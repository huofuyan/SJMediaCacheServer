//
//  MCSHLSResource.h
//  SJMediaCacheServer_Example
//
//  Created by BlueDancer on 2020/6/9.
//  Copyright © 2020 changsanjiang@gmail.com. All rights reserved.
//

#import "MCSResourceSubclass.h"
#import "MCSHLSParser.h"

NS_ASSUME_NONNULL_BEGIN
@interface MCSHLSResource : MCSResource
@property (nonatomic, copy, readonly, nullable) NSString *tsContentType;
@property (nonatomic, strong, nullable) MCSHLSParser *parser;

- (NSString *)tsNameForTsProxyURL:(NSURL *)URL;
- (nullable MCSResourcePartialContent *)contentForTsProxyURL:(NSURL *)URL;
- (MCSResourcePartialContent *)createContentWithTsProxyURL:(NSURL *)URL tsTotalLength:(NSUInteger)totalLength;
- (NSString *)filePathOfContent:(MCSResourcePartialContent *)content;
- (void)updateTsContentType:(NSString * _Nullable)tsContentType;
@end
NS_ASSUME_NONNULL_END
