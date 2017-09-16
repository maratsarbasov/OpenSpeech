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

@interface CardObject : AbstractObject

@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, readonly) CardType cardType;
@property (nonatomic, readonly) CardPaymentSystem cardPaymentSystem;

@end
