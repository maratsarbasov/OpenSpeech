//
//  CustomBlocks.h
//  OpenSpeech
//
//  Created by Fedor Solovev on 16/09/2017.
//  Copyright © 2017 Top ProGear. All rights reserved.
//


#ifndef OpenSpeech_CustomBlocks_h
#define OpenSpeech_CustomBlocks_h

@import Foundation;

typedef void (^ErrorResponseBlock)(NSError *__nullable error);
typedef void (^AnyObjectResponseBlock)(id __nullable data, NSError *__nullable error);

typedef void (^ArrayResponseBlock)(NSArray *__nullable data, NSError *__nullable error);
typedef void (^DictionaryResponseBlock)(NSDictionary *__nullable data, NSError *__nullable error);

typedef void (^StringResponseBlock)(NSString *__nullable data, NSError *__nullable error);
typedef void (^NumberResponseBlock)(NSNumber *__nullable number, NSError *__nullable error);
typedef void (^LogicalResponseBlock)(BOOL flag, NSError *__nullable error);

typedef void (^TransmitProgressBlock)(NSInteger bytesTransmited,
                                      long long totalBytesTransmited,
                                      long long totalBytesExpectedToTransmit);

#endif
