//
//  ActionDecider.m
//  OpenSpeech
//
//  Created by Marat Sarbasov on 16/09/2017.
//  Copyright © 2017 Top ProGear. All rights reserved.
//

#import "ActionObjects.h"

#define EXCHANGE_RATES_RULE_WORDS @[@"перевести", @"долларов", @"доллары", @"евро", @"рубли", @"рублей"]
#define FIND_NEAREST_ATM_RULE_WORDS @[@"банкомат", @"найти", @"найди", @"ближайший"]

@implementation ActionDecider

+ (AbstractAction *)decideForRecognition:(YSKRecognition *)recognition
{
    NSString *topResult = recognition.bestResultText;
    NSArray *words = [topResult componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    CGFloat exchangeRatesScore = [self scoreOfActionRule:EXCHANGE_RATES_RULE_WORDS requestWords:words];
    CGFloat findNearestATMScore = [self scoreOfActionRule:FIND_NEAREST_ATM_RULE_WORDS requestWords:words];
    
    if (exchangeRatesScore > findNearestATMScore)
    {
        return [[ExchangeRatesAction alloc] initWithWords:words];
    }
    else
    {
        return [[FindNearestATMAction alloc] init];
    }
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
