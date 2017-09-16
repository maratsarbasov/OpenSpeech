//
//  AbstractObject.h
//  OpenSpeech
//
//  Created by Fedor Solovev on 16/09/2017.
//  Copyright © 2017 Top ProGear. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MappingHelper.h"

NS_ASSUME_NONNULL_BEGIN

@interface AbstractObject : NSObject

@property (nonatomic, copy, readonly) NSString *pk;

- (instancetype)mapObjectFieldsFromRemoteDictionary:(nullable NSDictionary *)remoteDictionary;

@end

NS_ASSUME_NONNULL_END
