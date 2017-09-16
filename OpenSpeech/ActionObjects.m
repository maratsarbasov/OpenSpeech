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
            
            if ([RUB_WORDS containsObject:word])
            {
                if (currencyFromFound)
                {
                    _currencyTo = CurrencyTypeRUB;
                }
                else
                {
                    _currencyFrom = CurrencyTypeRUB;
                    currencyFromFound = true;
                }
            }
            
            if ([USD_WORDS containsObject:word])
            {
                if (currencyFromFound)
                {
                    _currencyTo = CurrencyTypeUSD;
                }
                else
                {
                    _currencyFrom = CurrencyTypeUSD;
                    currencyFromFound = true;
                }
            }
            
            if ([EUR_WORDS containsObject:word])
            {
                if (currencyFromFound)
                {
                    _currencyTo = CurrencyTypeEUR;
                }
                else
                {
                    _currencyFrom = CurrencyTypeEUR;
                    currencyFromFound = true;
                }
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
