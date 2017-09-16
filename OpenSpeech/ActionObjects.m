//
//  Actions.m
//  OpenSpeech
//
//  Created by Marat Sarbasov on 16/09/2017.
//  Copyright © 2017 Top ProGear. All rights reserved.
//

#import "Actions.h"

@implementation ExchangeRatesAction

- (instancetype)initWithWords:(NSArray *)words
{
    NSInteger amount;
    for (NSString *word in words)
    {
        
        if (word[word.length-1] == '$' || word[word.length-1] == '€')
        {
            amount = [[word substringToIndex:(word.length - 1)] intValue];
            
        }
        
        if (word[word.length-1] == "$")
    }
}

@end
