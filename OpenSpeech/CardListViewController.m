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
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
