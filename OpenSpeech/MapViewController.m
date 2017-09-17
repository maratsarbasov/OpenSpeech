//
//  MapViewController.m
//  OpenSpeech
//
//  Created by Fedor Solovev on 17/09/2017.
//  Copyright © 2017 Top ProGear. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController () <GMSMapViewDelegate>

@property (weak, nonatomic) IBOutlet GMSMapView *mapView;

@end

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mapView.delegate = self;
    
    [[NetworkManager sharedInstance] requestNearATMsForLocation:nil
                                                   onCompletion:^(NSNumber * _Nullable number, NSError * _Nullable error) {
        
    }];
}

- (IBAction)didTapOnDismissButton:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
