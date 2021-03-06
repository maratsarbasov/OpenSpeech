//
//  ViewController.m
//  OpenSpeech
//
//  Created by Marat Sarbasov on 16/09/2017.
//  Copyright © 2017 Top ProGear. All rights reserved.
//

#import "ViewController.h"
#import "CurrencyExchangeViewController.h"
#import "CardListViewController.h"
#import "MapViewController.h"

#import "ActionObjects.h"
#import "ActionDecider.h"


#import <YandexSpeechKit/YSKRecognizer.h>
#import <YandexSpeechKit/YSKRecognition.h>
#import <YandexSpeechKit/YSKRecognizerDelegate.h>

@interface ViewController () <YSKRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *listeningIndicator;
@property (weak, nonatomic) IBOutlet UILabel *listeningLabel;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (nonatomic) BOOL isListening;
@property (weak, nonatomic) IBOutlet UIButton *startListenButton;

@property (strong, nonatomic) YSKRecognizer *recognizer;

@end

@implementation ViewController

- (void)setIsListening:(BOOL)isListening
{
    self.listeningIndicator.hidden = !isListening;
    isListening ? [self.listeningIndicator startAnimating] : [self.listeningIndicator stopAnimating];
    self.listeningLabel.hidden = !isListening;
    self.startListenButton.enabled = !isListening;
    _isListening = isListening;
}

- (IBAction)startListening:(id)sender
{
    self.errorLabel.hidden = YES;
    self.isListening = YES;
    self.recognizer = [[YSKRecognizer alloc] initWithLanguage:YSKRecognitionLanguageRussian model:YSKRecognitionModelGeneral];
    self.recognizer.delegate = self;
    [self.recognizer start];
}

- (void)recognizer:(YSKRecognizer *)recognizer didCompleteWithResults:(YSKRecognition *)results
{
    NSLog(@"Запрос: %@",  results.bestResultText);
    AbstractAction *action = [ActionDecider decideForRecognition:results];
    
    if (!action)
    {
        NSLog(@"Can't recognize command");
        self.errorLabel.hidden = NO;
        self.errorLabel.text = @"Не удалось распознать команду";
        self.isListening = NO;
        return;
    }
    
    self.errorLabel.hidden = YES;
    
    if ([action isKindOfClass:[ExchangeRatesAction class]])
    {
        ExchangeRatesAction *exchangeAction = (ExchangeRatesAction *)action;
        CurrencyExchangeViewController *destination = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CurrencyExchangeViewController"];
        destination.action = exchangeAction;
        [self presentViewController:destination animated:YES completion:^{
            self.isListening = NO;
        }];
        return;
    }
    else if ([action isKindOfClass:[ShowMyCardsAction class]])
    {
        CardListViewController *destination = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CardListViewController"];
        [self presentViewController:destination animated:YES completion:^{
            self.isListening = NO;
        }];
        return;
    }
    else if ([action isKindOfClass:[FindNearestATMAction class]])
    {
        MapViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MapViewController"];
        [self presentViewController:vc animated:YES completion:nil];
        self.isListening = NO;
    }
    
    self.isListening = NO;
}

- (void)recognizer:(YSKRecognizer *)recognizer didFailWithError:(NSError *)error
{
    self.isListening = NO;
    self.errorLabel.hidden = NO;
    self.errorLabel.text = @"Не удалось распознать команду";
    DDLogDebug(@"%@", error);
}

- (IBAction)finish:(id)sender
{
    [self.recognizer finishRecording];
}

@end
