//
//  NetworkManager.h
//  OpenSpeech
//
//  Created by Fedor Solovev on 16/09/2017.
//  Copyright © 2017 Top ProGear. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

typedef NS_ENUM(NSInteger, ErrorCode) {
    ErrorCodeNone = 0,
    ErrorCodeFail
};

NS_ASSUME_NONNULL_BEGIN

@interface NetworkManager : AFHTTPSessionManager

+ (instancetype)sharedInstance;

- (void)requestCardsOnCompletion:(nullable ArrayResponseBlock)completionBlock;

- (void)requestBalanceForCard:(CardObject *)cardObject onCompletion:(nullable AnyObjectResponseBlock)completionBlock;

- (void)requestRatesForCurrencyTypeFrom:(CurrencyType)currencyTypeFrom
                      forCurrencyTypeTo:(CurrencyType)currencyTypeTo
                           onCompletion:(nullable NumberResponseBlock)completionBlock;

- (void)requestNearATMsForLocation:(CLLocation *)location
                      onCompletion:(AnyObjectResponseBlock)completionBlock;

@end

NS_ASSUME_NONNULL_END
