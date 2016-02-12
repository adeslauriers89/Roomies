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


#define zoomingMapArea 4000


@interface RoomsViewController () <UITableViewDataSource, MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *roomSegmentControl;
@property (nonatomic, strong) NSMutableArray *roomsArray;
@property (nonatomic) BOOL annotationWasTapped;
@property (nonatomic, strong) id<MKAnnotation> annotation;
@property (nonatomic, strong) Room *room;
@property (nonatomic, strong) NSString *dollarSign;
@property (nonatomic, retain) CLLocationManager *locationManager;

@end

@implementation RoomsViewController

- (void)viewWillAppear:(BOOL)animated {
    
    self.dollarSign = @"$";
        
    PFQuery *query = [PFQuery queryWithClassName:@"Room"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        self.roomsArray = [objects mutableCopy];
        [self.tableView reloadData];
     //   NSSet *roomsSet = [NSSet setWithArray:self.mapView.annotations];
        
        NSMutableSet *roomObjectIDSet =[NSMutableSet set];
        for (Room *room in self.mapView.annotations){
            [roomObjectIDSet addObject:room.objectId ];
            //NSLog(@"%@",roomObjectIDSet);
        }
        
        
        for (Room *room in self.roomsArray) {
            
            
            CLGeocoder *geocoder = [[CLGeocoder alloc] init];
            [geocoder geocodeAddressString:[room objectForKey:@"roomAddress"] completionHandler:^(NSArray* placemarks, NSError* error){
                for (CLPlacemark* aPlacemark in placemarks)
                {
                    
                    room.title = room.roomTitle;
                    room.subtitle = [self.dollarSign stringByAppendingString:[room objectForKey:@"price"]];
                    room.lat = @(aPlacemark.location.coordinate.latitude);
                    room.lng = @(aPlacemark.location.coordinate.longitude);
                    
                    if (![roomObjectIDSet containsObject:room.objectId]) {

                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.mapView addAnnotation:room];
                        });
                    }
                }
            }];
        }
    }];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    };
    
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
//    NSArray *sorted 
//    NSSortDescriptor *dateSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES];
//    self.roomsArray = [self.roomsArray sortedArrayUsingSelector:@[dateSortDescriptor]];
//    
    
    RoomCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath ];
    cell.roomDescriptionLabel.text = @"";
    cell.roomImageView.image = nil;
    cell.roomPriceLabel.text = @"";
    
    Room *individual = self.roomsArray[indexPath.row];
    NSLog(@"\nroom: %@  \nimage:  %@", individual.roomTitle, individual.roomImage);
    cell.roomImageView.file = [individual objectForKey:@"roomImage"];
    [cell.roomImageView addSubview:cell.roomPriceLabel];
    
    cell.roomPriceLabel.text = [self.dollarSign stringByAppendingString:individual.price];
    cell.roomDescriptionLabel.text = [individual objectForKey:@"roomTitle"];
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
    if ([segue.identifier isEqualToString:@"showRoomDVCFromMap"]) {

        DetailRoomViewController *dvc = [segue destinationViewController];
        
      
            Room *myRoom = (Room*)sender;
            dvc.room = myRoom;
    
    } else if ([segue.identifier isEqualToString:@"showRoomDVC"]){
            DetailRoomViewController *dvc = [segue destinationViewController];
            NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
            Room *individual = self.roomsArray[indexPath.row];
            dvc.room = individual;
    }
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    MKPinAnnotationView *view = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"identifier"];
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

-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    
    [view setCanShowCallout:YES];
}



-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    
    Room *myRoom = (Room*)view.annotation;
    
    [self performSegueWithIdentifier:@"showRoomDVCFromMap" sender:myRoom];
    self.annotationWasTapped = YES;
    self.annotation = view.annotation;
}

@end
