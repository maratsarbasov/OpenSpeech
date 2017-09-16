//
//  MappingHelper.m
//  OpenSpeech
//
//  Created by Fedor Solovev on 16/09/2017.
//  Copyright © 2017 Top ProGear. All rights reserved.
//

#import "MappingHelper.h"

@implementation MappingHelper

#pragma mark - Fields mapping

+ (BOOL)fieldNotEmpty:(id)fieldValue
{
    return (fieldValue != nil && fieldValue != [NSNull null]);
}

+ (NSString*)mapString:(id)fieldValue
{
    if ([self fieldNotEmpty:fieldValue] && [fieldValue isKindOfClass:[NSString class]])
        return fieldValue;
    return nil;
}

+ (NSNumber*)mapInt:(id)fieldValue
{
    if ([self fieldNotEmpty:fieldValue] &&
        ([fieldValue isKindOfClass:[NSNumber class]] || [fieldValue isKindOfClass:[NSString class]]))
    {
        return @([fieldValue intValue]);
    }
    return nil;
}

+ (NSNumber*)mapBool:(id)fieldValue
{
    if ([self fieldNotEmpty:fieldValue]) {
        if ([fieldValue isKindOfClass:[NSNumber class]] || [fieldValue isKindOfClass:[NSString class]])
        {
            return @([fieldValue boolValue]);
        }
    }
    return nil;
}

+ (NSNumber*)mapFloat:(id)fieldValue
{
    if ([self fieldNotEmpty:fieldValue] &&
        ([fieldValue isKindOfClass:[NSNumber class]] || [fieldValue isKindOfClass:[NSString class]]))
    {
        return @([fieldValue floatValue]);
    }
    return nil;
}

+ (id)localFieldToRemote:(id)localValue
{
    return (localValue == nil ? @"" : localValue);
}

@end
