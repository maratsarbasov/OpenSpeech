//
//  NetworkManager.h
//  OpenSpeech
//
//  Created by Fedor Solovev on 16/09/2017.
//  Copyright © 2017 Top ProGear. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

// TODO: remove it
#import "ActionDecider.h"

typedef NS_ENUM(NSInteger, ErrorCode) {
    ErrorCodeNone = 0,
    ErrorCodeFail
};

NS_ASSUME_NONNULL_BEGIN

@interface NetworkManager : AFHTTPSessionManager

+ (instancetype)sharedInstance;

- (void)requestCardsOnCompletion:(nullable ArrayResponseBlock)completionBlock;

- (void)requestRatesForCurrencyTypeFrom:(CurrencyType)currencyTypeFrom
                      forCurrencyTypeTo:(CurrencyType)currencyTypeTo
                           onCompletion:(nullable NumberResponseBlock)completionBlock;

@end

NS_ASSUME_NONNULL_END
