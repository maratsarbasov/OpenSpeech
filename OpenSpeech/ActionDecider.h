//
//  ActionDecider.h
//  OpenSpeech
//
//  Created by Marat Sarbasov on 16/09/2017.
//  Copyright © 2017 Top ProGear. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YandexSpeechKit/YSKRecognition.h>

typedef NS_ENUM(NSInteger, CurrencyType) {
    CurrencyTypeUSD = 0,
    CurrencyTypeRUB,
    CurrencyTypeEUR,
    CurrencyTypeGBP,
    CurrencyTypeCHF
};


@interface AbstractAction : NSObject

@end


@interface ExchangeRatesAction : AbstractAction

@property (nonatomic) CurrencyType currencyFrom;
@property (nonatomic) CurrencyType currencyTo;
@property (nonatomic) CGFloat amount;

@end

@interface FindNearestATMAction : AbstractAction

@end


@interface ActionDecider : NSObject

+ (AbstractAction *)decideForRecognition:(YSKRecognition *)recognition;

@end
