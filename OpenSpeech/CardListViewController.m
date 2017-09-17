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
    // Do any additional setup after loading the view.
    [self.activityIndicator startAnimating];
    
    [[NetworkManager sharedInstance] requestCardsOnCompletion:^(NSArray * _Nullable data, NSError * _Nullable error) {
        [self.activityIndicator stopAnimating];
        self.cards = data;
        self.cardsTableView.hidden = NO;
        [self.cardsTableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    cell.textLabel.text = card.name;
    
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
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
