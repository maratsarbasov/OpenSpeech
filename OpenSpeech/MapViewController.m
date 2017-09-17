//
//  MapViewController.m
//  OpenSpeech
//
//  Created by Fedor Solovev on 17/09/2017.
//  Copyright © 2017 Top ProGear. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>

@interface MapViewController () <GMSMapViewDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet GMSMapView *mapView;

@property (nonatomic) CLLocationManager *locationManager;
@property (nonatomic) BOOL firstLocationUpdate;

@end

@implementation MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.firstLocationUpdate = NO;
    
    self.mapView.delegate = self;
    self.mapView.myLocationEnabled = YES;
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;

    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
}

- (IBAction)didTapOnDismissButton:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self.locationManager startUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if (_firstLocationUpdate == NO) {
        _firstLocationUpdate = YES;
        
        CLLocation *location = locations.lastObject;
        __weak  typeof(self) weak_self = self;
        [[NetworkManager sharedInstance] requestNearATMsForLocation:location
                                                       onCompletion:^(id  _Nullable data, NSError * _Nullable error)
         {
             typeof(self) strong_self = weak_self;
             
             ATMObject *object = (ATMObject *)data;
             GMSMarker *marker = [[GMSMarker alloc] init];
             marker.position = object.location.coordinate;
             marker.title = object.name;
             marker.map = strong_self.mapView;
         }];
        _mapView.camera = [GMSCameraPosition cameraWithTarget:location.coordinate zoom:14];
    }
}

@end
