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

@interface NetworkManager : AFHTTPSessionManager

+ (instancetype)sharedInstance;

- (void)requestCardsOnCompletion:(ArrayResponseBlock)completionBlock;

@end
