//
//  ViewController.m
//  OpenSpeech
//
//  Created by Marat Sarbasov on 16/09/2017.
//  Copyright © 2017 Top ProGear. All rights reserved.
//

#import "ViewController.h"

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
    self.isListening = NO;
    NSLog(@"%@",  results.bestResultText);
}


- (void)recognizer:(YSKRecognizer *)recognizer didFailWithError:(NSError *)error
{
    self.isListening = NO;
    NSLog(@"%@", error);
}

- (IBAction)finish:(id)sender
{
    [self.recognizer finishRecording];
}

@end
