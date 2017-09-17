//
//  CardObject.h
//  OpenSpeech
//
//  Created by Fedor Solovev on 16/09/2017.
//  Copyright © 2017 Top ProGear. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CardType) {
    CardTypeCredit = 0,
    CardTypeDebit,
    CardTypeNone
};

typedef NS_ENUM(NSInteger, CardPaymentSystem) {
    CardPaymentSystemMir = 0,
    CardPaymentSystemMasterCard,
    CardPaymentSystemVisa,
    CardPaymentSystemNone
};

typedef NS_ENUM(NSInteger, CurrencyType) {
    CurrencyTypeUSD = 0,
    CurrencyTypeRUB,
    CurrencyTypeEUR,
    CurrencyTypeGBP,
    CurrencyTypeCHF,
    CurrencyTypeNone
};


@interface CardObject : AbstractObject

@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSNumber *value;
@property (nonatomic, readonly) CurrencyType currencyType;
@property (nonatomic, readonly) CardType cardType;
@property (nonatomic, readonly) CardPaymentSystem cardPaymentSystem;

+ (NSString *)stringForCurrency:(CurrencyType)currencyType;
- (instancetype)mapBalanceFieldsFromRemoteDictionary:(NSDictionary *)remoteDictionary;

@end
