//
//  AbstractObject.m
//  OpenSpeech
//
//  Created by Fedor Solovev on 16/09/2017.
//  Copyright © 2017 Top ProGear. All rights reserved.
//

#import "AbstractObject.h"

@implementation AbstractObject

- (instancetype)mapObjectFieldsFromRemoteDictionary:(NSDictionary *)remoteDictionary
{
    // redefine in subclasses
    return self;
}

@end
