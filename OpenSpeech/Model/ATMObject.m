//
//  ATMObject.m
//  OpenSpeech
//
//  Created by Fedor Solovev on 17/09/2017.
//  Copyright © 2017 Top ProGear. All rights reserved.
//

#import "ATMObject.h"
#import "MappingHelper.h"

@implementation ATMObject
@synthesize pk = _pk;
@synthesize name = _name;
@synthesize location = _location;

- (instancetype)mapObjectFieldsFromRemoteDictionary:(NSDictionary *)remoteDictionary
{
    [super mapObjectFieldsFromRemoteDictionary:remoteDictionary];
    _name = [MappingHelper mapString:remoteDictionary[@"name"]];
    _name = [MappingHelper mapString:remoteDictionary[@"name"]];
    
    if (remoteDictionary[@"coordinate"] != nil) {
//        NSDictionary *coordinate = remoteDictionary[@"coordinate"];
//        NSNumber
    }
    return self;
}

@end
