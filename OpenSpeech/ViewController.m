//
//  ViewController.m
//  OpenSpeech
//
//  Created by Marat Sarbasov on 16/09/2017.
//  Copyright © 2017 Top ProGear. All rights reserved.
//

#import "ViewController.h"
#import "ActionObjects.h"
#import "ActionDecider.h"
#import "CurrencyExchangeViewController.h"

#import <YandexSpeechKit/YSKRecognizer.h>
#import <YandexSpeechKit/YSKRecognition.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *listeningIndicator;
@property (weak, nonatomic) IBOutlet UILabel *listeningLabel;
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

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view, typically from a nib.
    
    [[NetworkManager sharedInstance] requestNearATMsForLocation:[[CLLocation alloc] initWithLatitude:37.6167 longitude:55.7500]
                                                   onCompletion:^(NSNumber * _Nullable number, NSError * _Nullable error) {
        
    }];
}

- (IBAction)startListening:(id)sender
{
    self.isListening = YES;
    self.recognizer = [[YSKRecognizer alloc] initWithLanguage:YSKRecognitionLanguageRussian model:YSKRecognitionModelGeneral];
    self.recognizer.delegate = self;
    [self.recognizer start];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)recognizer:(YSKRecognizer *)recognizer didCompleteWithResults:(YSKRecognition *)results
{
    NSLog(@"Запрос: %@",  results.bestResultText);
    AbstractAction *action = [ActionDecider decideForRecognition:results];
    
    if (!action)
    {
        NSLog(@"Can't recognize command");
        self.isListening = NO;
        return;
    }
    
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
        ShowMyCardsAction *act = (ShowMyCardsAction *)action;
        CardListViewController *destination = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CardListViewController"];
        
    }
    self.isListening = NO;
}

- (void)recognizer:(YSKRecognizer *)recognizer didFailWithError:(NSError *)error
{
    self.isListening = NO;
    DDLogDebug(@"%@", error);
}

- (IBAction)finish:(id)sender
{
    [self.recognizer finishRecording];
}

@end
