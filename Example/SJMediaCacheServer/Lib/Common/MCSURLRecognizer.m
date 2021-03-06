//
//  MCSURLRecognizer.m
//  SJMediaCacheServer_Example
//
//  Created by BlueDancer on 2020/6/2.
//  Copyright © 2020 changsanjiang@gmail.com. All rights reserved.
//

#import "MCSURLRecognizer.h"
#include <CommonCrypto/CommonCrypto.h>
#import "MCSFileManager.h"

static inline NSString *
MCSMD5(NSString *str) {
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(data.bytes, (CC_LONG)data.length, result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]];
}

@implementation MCSURLRecognizer
+ (instancetype)shared {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (nullable NSURL *)proxyURLWithURL:(NSURL *)URL localServerURL:(NSURL *)serverURL {
    NSURLComponents *components = [NSURLComponents componentsWithURL:serverURL resolvingAgainstBaseURL:NO];
    components.path = URL.path;
    NSString *url = [[URL.absoluteString dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0];
    [components setQuery:[NSString stringWithFormat:@"url=%@", url]];
    return components.URL;
}

- (nullable NSURL *)URLWithProxyURL:(NSURL *)proxyURL {
    NSURLComponents *components = [NSURLComponents componentsWithURL:proxyURL resolvingAgainstBaseURL:NO];
    for ( NSURLQueryItem *query in components.queryItems ) {
        if ( [query.name isEqualToString:@"url"] ) {
            NSString *url = [NSString.alloc initWithData:[NSData.alloc initWithBase64EncodedString:query.value options:0] encoding:NSUTF8StringEncoding];
            return [NSURL URLWithString:url];
        }
    }
    return proxyURL;
}

- (nullable NSString *)resourceNameForURL:(NSURL *)URL {
    if ( [URL.absoluteString containsString:@".ts"] ) {
        return [MCSFileManager hls_resourceNameForTsProxyURL:URL];
    }
    return MCSMD5(URL.absoluteString);
}

- (MCSResourceType)resourceTypeForURL:(NSURL *)URL {
    return [URL.absoluteString containsString:@".m3u8"] || [URL.absoluteString containsString:@".ts"] ? MCSResourceTypeHLS : MCSResourceTypeVOD;
}
@end
