//
//  Actions.m
//  OpenSpeech
//
//  Created by Marat Sarbasov on 16/09/2017.
//  Copyright © 2017 Top ProGear. All rights reserved.
//

#import "ActionObjects.h"

#define RUB_WORDS @[@"рублей", @"рубль", @"рубля", @"р", @"рубли", @"рублях"]
#define USD_WORDS @[@"доллар", @"доллара", @"долларов", @"доллары", @"долларах"]
#define GBP_WORDS @[@"фунт", @"фунтов", @"фунта", @"стерлингов", @"фунтах", @"фунты"]
#define CHF_WORDS @[@"китайская", @"юань", @"юаней", @"юанях", @"китайских", @"китайские"]
#define EUR_WORDS @[@"евро"]

@implementation ExchangeRatesAction

- (instancetype)initWithWords:(NSArray *)words
{
    self = [super init];
    if (self)
    {
        BOOL currencyFromFound = false;
        for (NSString *word in words)
        {
            if ([word integerValue])
            {
                _amount = [word integerValue];
            }
            
            unichar lastLetter = [word characterAtIndex:(word.length - 1)];
            if (lastLetter == L'$' || lastLetter == L'€')
            {
                _amount = [[word substringToIndex:(word.length - 1)] integerValue];
                if (lastLetter == L'$')
                {
                    _currencyFrom = CurrencyTypeUSD;
                }
                else if (lastLetter == L'€')
                {
                    _currencyFrom = CurrencyTypeEUR;
                }
                currencyFromFound = true;
            }
            
            CurrencyType *currentField;
            if (currencyFromFound)
            {
                currentField = &_currencyTo;
            }
            else
            {
                currentField = &_currencyFrom;
            }
            
            if ([RUB_WORDS containsObject:word])
            {
                *currentField = CurrencyTypeRUB;
                currencyFromFound = YES;
            }
            else if ([USD_WORDS containsObject:word])
            {
                *currentField = CurrencyTypeUSD;
                currencyFromFound = YES;
            }
            else if ([EUR_WORDS containsObject:word])
            {
                *currentField = CurrencyTypeEUR;
                currencyFromFound = YES;
            }
            else if ([GBP_WORDS containsObject:word])
            {
                *currentField = CurrencyTypeGBP;
                currencyFromFound = YES;
            }
            else if ([CHF_WORDS containsObject:word])
            {
                *currentField = CurrencyTypeCHF;
                currencyFromFound = YES;
            }
        }
    }
    
    return self;
}

@end

@implementation AbstractAction

@end

@implementation FindNearestATMAction

@end

@implementation ShowMyCardsAction

@end
