//
//  MappingHelper.h
//  OpenSpeech
//
//  Created by Fedor Solovev on 16/09/2017.
//  Copyright © 2017 Top ProGear. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MappingHelper : NSObject

+ (BOOL)fieldNotEmpty:(id)fieldValue;
+ (NSString *)mapString:(id)fieldValue;
+ (NSNumber *)mapInt:(id)fieldValue;
+ (NSNumber *)mapBool:(id)fieldValue;
+ (NSNumber *)mapFloat:(id)fieldValue;

+ (id)localFieldToRemote:(id)localValue;

@end
