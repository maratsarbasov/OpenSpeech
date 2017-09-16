//
//  NetworkManager.m
//  OpenSpeech
//
//  Created by Fedor Solovev on 16/09/2017.
//  Copyright © 2017 Top ProGear. All rights reserved.
//

#import "NetworkManager.h"

#import "MappingHelper.h"

@implementation NetworkManager

- (instancetype)initPrivate
{
    self = [super init];
    return self;
}

+ (instancetype)sharedInstance
{
    static NetworkManager *uniqueInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        uniqueInstance = [[NetworkManager alloc] initPrivate];
    });
    
    return uniqueInstance;
}

- (void)requestCardsOnCompletion:(ArrayResponseBlock)completionBlock
{
    [self GETRequest:@"MyCards/1.0.0/MyCardsInfo/cardlist"
              params:nil
            progress:nil
        onCompletion:^(id  _Nullable data, NSError * _Nullable error)
     {
         NSMutableArray *cardObjects = nil;
         NSError *localError = nil;
         
         if (error == nil) {
             NSDictionary *response = data[@"Cards"];
             if (response != nil) {
                 
                 NSInteger errorCode = [MappingHelper mapInt:response[@"ErrorCode"]].integerValue;
                 if (errorCode == ErrorCodeNone) {
                     
                     NSArray<NSDictionary *> *cards = response[@"Card"];
                     if (cards != nil) {
                         cardObjects = [[NSMutableArray alloc] initWithCapacity:cards.count];
                         for (NSDictionary *card in cards) {
                             [cardObjects addObject:[[CardObject alloc] mapObjectFieldsFromRemoteDictionary:card]];
                         }
                     }
                 }
             }
         }
         error = (localError != nil ? localError : nil);
         call_completion_block(completionBlock, cardObjects, error);
     }];
}

- (void)POSTRequest:(NSString *)path
             params:(NSDictionary *)params
           progress:(void (^)(NSProgress * _Nonnull))uploadProgress
       onCompletion:(AnyObjectResponseBlock)completionBlock
{
    [self printUrlWithUrl:path andParams:params];
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [self POST:[self prepareRequestURL:path]
    parameters:[self prepareRequestParams:params]
      progress:uploadProgress
       success:^(NSURLSessionDataTask *__unused task, id JSON)
     {
         [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
         
         if (completionBlock != nil) {
             completionBlock(JSON, nil);
         }
     }
       failure:^(NSURLSessionDataTask *__unused task, NSError *requestError)
     {
         [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
         
         DDLogDebug(@"Error: %@", requestError);
         
         if (completionBlock)
         completionBlock(nil, requestError);
     }];
}

- (void)GETRequest:(NSString *)path
            params:(NSDictionary *)params
          progress:(nullable void (^)(NSProgress *downloadProgress))downloadProgress
      onCompletion:(AnyObjectResponseBlock)completionBlock
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    DDLogDebug(@"URL: %@", [self prepareRequestURL:path]);
    
    [self GET:[self prepareRequestURL:path]
   parameters:[self prepareRequestParams:params]
     progress:downloadProgress
      success:^(NSURLSessionDataTask * __unused task, id JSON)
     {
         [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
         
         if (completionBlock) {
             completionBlock(JSON, nil);
         }
     }
      failure:^(NSURLSessionDataTask *__unused task, NSError *requestError)
     {
         [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
         
         DDLogDebug(@"Error: %@", requestError);
         
         if (completionBlock) {
             completionBlock(nil, requestError);
         }
     }];
}

#pragma mark - Helpers

- (void)printUrlWithUrl:(NSString *)url andParams:(NSDictionary *)params
{
    NSMutableString *query_string = [self prepareRequestURL:url].mutableCopy;
    NSDictionary *prepared_params = [self prepareRequestParams:params];
    
    for (id key in prepared_params) {
        NSString *key_string = [key description];
        NSString *value_string = [prepared_params[key] description];
        
        if ([query_string rangeOfString:@"?"].location == NSNotFound) {
            [query_string appendFormat:@"?%@=%@", [self urlEscapeString:key_string], [self urlEscapeString:value_string]];
        }
        else {
            [query_string appendFormat:@"&%@=%@", [self urlEscapeString:key_string], [self urlEscapeString:value_string]];
        }
    }
    
    DDLogDebug(@"URL Response: %@", query_string);
}

- (NSString*)urlEscapeString:(NSString *)unencodedString
{
    CFStringRef originalStringRef = (__bridge_retained CFStringRef)unencodedString;
    NSString *s = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,originalStringRef, NULL, (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ", kCFStringEncodingUTF8);
    CFRelease(originalStringRef);
    return s;
}

- (NSString*)prepareRequestURL:(NSString*)localPath
{
    return [NSString stringWithFormat:@"%@%@", @"https://api.open.ru/", localPath];
}

- (NSDictionary *)prepareRequestParams:(NSDictionary *)params
{
    NSMutableDictionary *paramsMutable = params.mutableCopy;

    return paramsMutable;
}

@end
