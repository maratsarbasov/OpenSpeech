//
//  NetworkManager.m
//  OpenSpeech
//
//  Created by Fedor Solovev on 16/09/2017.
//  Copyright © 2017 Top ProGear. All rights reserved.
//

#import "NetworkManager.h"

#import "MappingHelper.h"
#import <XMLDictionary/XMLDictionary.h>

@implementation NetworkManager

- (instancetype)initPrivate
{
    self = [super init];
    if (self) {
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json", @"text/xml"]];        
    }
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

#pragma mark - Methods

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

- (void)requestBalanceForCard:(CardObject *)cardObject onCompletion:(AnyObjectResponseBlock)completionBlock
{
    [self POSTRequest:@"/MyCards/1.0.0/MyCardsInfo/balance"
               params:@{ @"CardId" : cardObject.pk }
             progress:nil
         onCompletion:^(id  _Nullable data, NSError * _Nullable error)
     {
         NSDictionary *response = data;
         if (response != nil) {
             
             NSInteger errorCode = [MappingHelper mapInt:response[@"ErrorCode"]].integerValue;
             if (errorCode == ErrorCodeNone) {
                 NSArray *cardBalance = response[@"CardBalance"];
                 if (cardBalance.firstObject != nil) {
                     [cardObject mapBalanceFieldsFromRemoteDictionary:cardBalance.firstObject];
                 }
             }
         }
         call_completion_block(completionBlock, cardObject, error);
     }];
}

- (void)requestRatesForCurrencyTypeFrom:(CurrencyType)currencyTypeFrom
                      forCurrencyTypeTo:(CurrencyType)currencyTypeTo
                           onCompletion:(NumberResponseBlock)completionBlock
{
    [self GETRequest:@"getrates/1.0.0/rates/cash"
              params:nil
            progress:nil
        onCompletion:^(id  _Nullable data, NSError * _Nullable error)
    {
        NSNumber *value = nil;
        if (error == nil) {
            NSArray *rates = data[@"rates"];
            if (rates != nil) {
                NSMutableArray<NSDictionary *> *needRates = [[NSMutableArray alloc] initWithCapacity:2];
                
                for (NSDictionary *rate in rates) {
                    NSString *currencyCode = [MappingHelper mapString:rate[@"curCharCode"]];
                    if ([currencyCode isEqualToString:@"USD"] && (currencyTypeFrom == CurrencyTypeUSD ||
                                                                  currencyTypeTo == CurrencyTypeUSD ))
                    {
                        [needRates addObject:rate];
                    }
                    else if ([currencyCode isEqualToString:@"EUR"] && (currencyTypeFrom == CurrencyTypeEUR ||
                                                                       currencyTypeTo == CurrencyTypeEUR )) {
                        [needRates addObject:rate];
                    }
                    else if ([currencyCode isEqualToString:@"GBP"] && (currencyTypeFrom == CurrencyTypeGBP ||
                                                                       currencyTypeTo == CurrencyTypeGBP )) {
                        [needRates addObject:rate];
                    }
                    else if ([currencyCode isEqualToString:@"CHF"] && (currencyTypeFrom == CurrencyTypeCHF ||
                                                                       currencyTypeTo == CurrencyTypeCHF )) {
                        [needRates addObject:rate];
                    }
                }
                NSDictionary *needRate = nil;
                for (NSDictionary *rate in needRates) {
                    NSString *operationType = [MappingHelper mapString:rate[@"operationType"]];
                    
                    if (currencyTypeFrom != CurrencyTypeRUB) {
                        if ([operationType isEqualToString:@"S"]) {
                            needRate = rate;
                            break;
                        }
                    }
                    else if (currencyTypeTo != CurrencyTypeRUB) {
                        if ([operationType isEqualToString:@"B"]) {
                            needRate = rate;
                            break;
                        }
                    }
                }
                value = [MappingHelper mapFloat:needRate[@"rateValue"]];
            }
        }
        call_completion_block(completionBlock, value, error);
    }];
}

- (void)requestNearATMsForLocation:(CLLocation *)location
                      onCompletion:(AnyObjectResponseBlock)completionBlock
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[self prepareRequestURL:@"geocoding/1.0.0/getNearATM"]]];
    
    NSString *userUpdate = [NSString stringWithFormat:@"<?xml version=\"1.0\"?><getNearATM><coordinates><latitude>%.8f</latitude><longitude>%.8f</longitude></coordinates></getNearATM>", location.coordinate.latitude, location.coordinate.longitude];
    
    //create the Method "GET" or "POST"
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setValue:@"text/xml" forHTTPHeaderField:@"Content-Type"];
    
    //Convert the String to Data
    NSData *data1 = [userUpdate dataUsingEncoding:NSUTF8StringEncoding];
    
    //Apply the data to the body
    [urlRequest setHTTPBody:data1];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                                                    
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        ATMObject *atmObject = nil;
        if (httpResponse.statusCode == 200) {
            NSDictionary *responseDictionary = [[XMLDictionaryParser sharedInstance] dictionaryWithData:data];
            NSDictionary *atm = responseDictionary[@"return"][@"poiList"];
            if (atm != nil) {
                atmObject = [[ATMObject alloc] mapObjectFieldsFromRemoteDictionary:atm];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            call_completion_block(completionBlock, atmObject, error);
        });
    }];
    [dataTask resume];
}

#pragma mark - Base

- (void)POSTRequest:(NSString *)path
             params:(NSDictionary *)params
           progress:(nullable void (^)(NSProgress *))uploadProgress
       onCompletion:(AnyObjectResponseBlock)completionBlock
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [self POST:[self prepareRequestURL:path]
    parameters:params
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
         
         if (completionBlock) {
             completionBlock(nil, requestError);
         }
     }];
}

- (void)GETRequest:(NSString *)path
            params:(NSDictionary *)params
          progress:(nullable void (^)(NSProgress *downloadProgress))downloadProgress
      onCompletion:(AnyObjectResponseBlock)completionBlock
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [self GET:[self prepareRequestURL:path]
   parameters:params
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
         
         if (completionBlock) {
             completionBlock(nil, requestError);
         }
     }];
}

#pragma mark - Helpers

- (NSString*)prepareRequestURL:(NSString*)localPath
{
    return [NSString stringWithFormat:@"%@%@", @"https://api.open.ru/", localPath];
}

@end
