//
//  CardObject.m
//  OpenSpeech
//
//  Created by Fedor Solovev on 16/09/2017.
//  Copyright © 2017 Top ProGear. All rights reserved.
//

#import "CardObject.h"

@implementation CardObject
@synthesize pk = _pk;
@synthesize cardType = _cardType;
@synthesize cardPaymentSystem = _cardPaymentSystem;
@synthesize name = _name;

- (instancetype)mapObjectFieldsFromRemoteDictionary:(NSDictionary *)remoteDictionary
{
    [super mapObjectFieldsFromRemoteDictionary:remoteDictionary];
    
    _pk = [MappingHelper mapString:remoteDictionary[@"CardId"]];
    _name = [MappingHelper mapString:remoteDictionary[@"CardName"]];
    _cardType = [self cardTypeFromRemote:[MappingHelper mapString:remoteDictionary[@"CardType"]]];
    _cardPaymentSystem = [self cardPaymentSystemFromRemote:[MappingHelper mapString:remoteDictionary[@"CardPaymentSystem"]]];

    return self;
}

- (CardType)cardTypeFromRemote:(NSString *)remote
{
    if (remote.length == 0) return CardTypeNone;
    
    if ([remote isEqualToString:@"credit"]) {
        return CardTypeCredit;
    }
    else if ([remote isEqualToString:@"debit"]) {
        return CardTypeDebit;
    }
    return CardTypeNone;
}

- (CardPaymentSystem)cardPaymentSystemFromRemote:(NSString *)remote
{
    if (remote.length == 0) return CardPaymentSystemNone;
    
    if ([remote isEqualToString:@"visa"]) {
        return CardPaymentSystemVisa;
    }
    else if ([remote isEqualToString:@"mastercard"]) {
        return CardPaymentSystemMir;
    }
    else if ([remote isEqualToString:@"mir"]) {
        return CardPaymentSystemMasterCard;
    }
    return CardPaymentSystemNone;
}

@end
