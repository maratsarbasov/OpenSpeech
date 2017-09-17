//
//  CurrencyExchangeViewController.m
//  OpenSpeech
//
//  Created by Marat Sarbasov on 16/09/2017.
//  Copyright © 2017 Top ProGear. All rights reserved.
//

#import "CurrencyExchangeViewController.h"

@interface CurrencyExchangeViewController ()

@property (weak, nonatomic) IBOutlet UILabel *mainLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation CurrencyExchangeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.activityIndicator startAnimating];
    self.mainLabel.text = @"";
    
    [[NetworkManager sharedInstance] requestRatesForCurrencyTypeFrom:self.action.currencyFrom forCurrencyTypeTo:self.action.currencyTo onCompletion:^(NSNumber * _Nullable number, NSError * _Nullable error) {
        [self.activityIndicator stopAnimating];
        
        CGFloat result = 0.0;
        if (self.action.currencyFrom == CurrencyTypeRUB)
        {
            result = self.action.amount / number.floatValue;
        }
        else if (self.action.currencyTo == CurrencyTypeRUB)
        {
            result = self.action.amount * number.floatValue;
        }
        else
        {
            NSAssert(false, @"not implemented");
        }

        self.mainLabel.text = [NSString stringWithFormat:@"%.2f %@ -> %.2f %@", self.action.amount, [CardObject stringForCurrency:self.action.currencyFrom], result, [CardObject stringForCurrency:self.action.currencyTo]];
    }];
}

- (IBAction)dismiss:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
