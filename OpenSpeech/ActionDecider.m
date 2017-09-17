//
//  ActionDecider.m
//  OpenSpeech
//
//  Created by Marat Sarbasov on 16/09/2017.
//  Copyright © 2017 Top ProGear. All rights reserved.
//

#import "ActionObjects.h"

#define EXCHANGE_RATES_RULE_WORDS @[@"перевести", @"переведи", @"долларов", @"доллары", @"евро", @"рубли", @"рублей", \
    @"рублях", @"долларах", @"юаней", @"фунты", @"фунтах", @"фунты"]
#define FIND_NEAREST_ATM_RULE_WORDS @[@"банкомат", @"найти", @"найди", @"ближайший", @"недалеко"]
#define SHOW_MY_CARDS_RULE_WORDS @[@"мои", @"карты", @"карточки", @"покажи", @"список", @"карт"]

@implementation ActionDecider

+ (AbstractAction *)decideForRecognition:(YSKRecognition *)recognition
{
    NSString *topResult = recognition.bestResultText;
    NSArray *words = [topResult componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    CGFloat exchangeRatesScore = [self scoreOfActionRule:EXCHANGE_RATES_RULE_WORDS requestWords:words];
    CGFloat findNearestATMScore = [self scoreOfActionRule:FIND_NEAREST_ATM_RULE_WORDS requestWords:words];
    CGFloat showMyCardsScore = [self scoreOfActionRule:SHOW_MY_CARDS_RULE_WORDS requestWords:words];
    
    CGFloat max = fmax(exchangeRatesScore, fmax(findNearestATMScore, showMyCardsScore));
    if (max == 0.0)
    {
        return nil;
    }
    
    if (exchangeRatesScore == max)
    {
        return [[ExchangeRatesAction alloc] initWithWords:words];
    }
    if (findNearestATMScore == max)
    {
        return [[FindNearestATMAction alloc] init];
    }
    if (showMyCardsScore == max)
    {
        return [[ShowMyCardsAction alloc] init];
    }
    
    return nil;
}

+ (CGFloat)scoreOfActionRule:(NSArray *)ruleWords requestWords:(NSArray *)requestWords
{
    CGFloat score = 0.0;
    for (NSString *word in requestWords)
    {
        if ([ruleWords containsObject:word])
        {
            score++;
        }
    }
    
    return score;
}



@end
