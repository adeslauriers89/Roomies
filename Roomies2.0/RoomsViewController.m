//
//  RoomsViewController.m
//  Roomies2.0
//
//  Created by Adam DesLauriers on 2016-02-08.
//  Copyright © 2016 Adam DesLauriers & Thiago Heitling. All rights reserved.
//

#import "RoomsViewController.h"
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>
#import "RoomCustomTableViewCell.h"
#import "Room.h"
#import "DetailRoomViewController.h"
#import <Corelocation/CLGeocoder.h>
#import <Corelocation/CLPlacemark.h>
#import <AddressBookUI/AddressBookUI.h>
#import "RoomAnnotation.h"

#define zoomingMapArea 4000


@interface RoomsViewController () <UITableViewDataSource, MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *roomSegmentControl;
@property (nonatomic, strong) NSMutableArray *roomsArray;
@property (nonatomic) RoomAnnotation *annotationView;

@end

@implementation RoomsViewController

- (void)viewWillAppear:(BOOL)animated {
    
    PFQuery *query = [PFQuery queryWithClassName:@"Room"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        self.roomsArray = [objects mutableCopy];
        [self.tableView reloadData];
        
        NSLog(@"%@",[[self.roomsArray lastObject]objectForKey:@"roomAddress"]);
        
        
        for (Room *room in self.roomsArray) {
            NSLog(@"%@", [room objectForKey:@"roomAddress"]);
        
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder geocodeAddressString:[room objectForKey:@"roomAddress"] completionHandler:^(NSArray* placemarks, NSError* error){
            for (CLPlacemark* aPlacemark in placemarks)
            {

                NSString *latDest1 = [NSString stringWithFormat:@"%.4f",aPlacemark.location.coordinate.latitude];
                NSString *lngDest1 = [NSString stringWithFormat:@"%.4f",aPlacemark.location.coordinate.longitude];
                NSLog(@"%@ %@ ", latDest1, lngDest1);
                
                room.title = [room objectForKey:@"roomTitle"];
                room.subtitle = [room objectForKey:@"price"];
                room.lat = @(aPlacemark.location.coordinate.latitude);
                room.lng = @(aPlacemark.location.coordinate.longitude);
                
//                RoomAnnotation.lat = @(aPlacemark.location.coordinate.latitude);
//                RoomAnnotation.lng = @(aPlacemark.location.coordinate.longitude);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                     [self.mapView addAnnotation:room];
                });
              

            }
        }];
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self.mapView setHidden:YES];
}


-(void)initiateMap{
    
    CLLocationCoordinate2D zoomLocation = CLLocationCoordinate2DMake(49.28, -123.12);
    
    MKCoordinateRegion adjustedRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, zoomingMapArea, zoomingMapArea);
    
    [_mapView setRegion:adjustedRegion animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.roomsArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RoomCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath ];
    
    Room *individual = self.roomsArray[indexPath.row];
    cell.roomImageView.file = [individual objectForKey:@"roomImage"];
    cell.roomPriceLabel.text = [individual objectForKey:@"price"];
    cell.roomDescriptionLabel.text = [individual objectForKey:@"roomDetails"];
    
    if (!cell.roomImageView.image) {
        cell.roomImageView.alpha = 0;
        [cell.roomImageView loadInBackground:^(UIImage * _Nullable image, NSError * _Nullable error) {
            cell.roomImageView.image = image;
            [UIView animateWithDuration:0.3 animations:^{
                cell.roomImageView.alpha = 1;
            }];
        }];
    }
    
    return cell;
}

- (IBAction)sorterSelected:(UISegmentedControl *)sender {
    
    if (sender.selectedSegmentIndex == 0) {
        [self.mapView setHidden:YES];
        [self.tableView setHidden:NO];
    } else {
        [self.tableView setHidden:YES];
        [self.mapView setHidden:NO];
        [self initiateMap];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showRoomDVC"]) {
        DetailRoomViewController *dvc = [segue destinationViewController];
        NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
        Room *individual = self.roomsArray[indexPath.row];
        dvc.room = individual;
        
    }
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    MKPinAnnotationView *view = (id)[mapView dequeueReusableAnnotationViewWithIdentifier:@"identifier"];
    if (view) {
        view.annotation = annotation;
    } else {
        view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"identifier"];
        UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        view.rightCalloutAccessoryView= infoButton;
        infoButton.tag = 1200;
        view.enabled = YES;
        view.canShowCallout = YES;
        view.multipleTouchEnabled = NO;
        view.animatesDrop = YES;
            }
    return view;
}



-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(RoomAnnotation *)view {
    
    [view setCanShowCallout:YES];
}


@end
