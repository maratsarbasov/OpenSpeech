//
//  CardListViewController.m
//  OpenSpeech
//
//  Created by Marat Sarbasov on 17/09/2017.
//  Copyright © 2017 Top ProGear. All rights reserved.
//

#import "CardListViewController.h"

@interface CardListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *cardsTableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) NSArray *cards;

@end

@implementation CardListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.activityIndicator startAnimating];
    self.cardsTableView.allowsSelection = NO;
    
    [[NetworkManager sharedInstance] requestCardsOnCompletion:^(NSArray * _Nullable data, NSError * _Nullable error) {
        self.cards = data;
        self.cardsTableView.hidden = NO;
        
        for (int i = 0; i < self.cards.count; i++)
        {
            CardObject *card = self.cards[i];
            [[NetworkManager sharedInstance] requestBalanceForCard:card onCompletion:^(id  _Nullable data, NSError * _Nullable error) {
                if (i == self.cards.count - 1)
                {
                    [self.cardsTableView reloadData];
                    [self.activityIndicator stopAnimating];
                }
            }];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cards.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CardCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CardCell"];
    }
    
    CardObject *card = self.cards[indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@: %@ %@", card.name, card.value, [CardObject stringForCurrency:card.currencyType]];
    
    switch (card.cardPaymentSystem) {
        case CardPaymentSystemMir:
            cell.detailTextLabel.text = @"Мир";
            break;
        case CardPaymentSystemVisa:
            cell.detailTextLabel.text = @"Visa";
            break;
        case CardPaymentSystemMasterCard:
            cell.detailTextLabel.text = @"MasterCard";
        default:
            break;
    }
    
    return cell;
}

- (IBAction)dismiss:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
