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
#import "RoomiesLocationManager.h"
#import <Corelocation/CLGeocoder.h>
#import <Corelocation/CLPlacemark.h>
#import <AddressBookUI/AddressBookUI.h>

#define zoomingMapArea 5800

@interface RoomsViewController () <UITableViewDataSource, MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *roomSegmentControl;
@property (nonatomic, strong) NSMutableArray *roomsArray;
@property (nonatomic) BOOL annotationWasTapped;
@property (nonatomic, strong) id<MKAnnotation> annotation;
@property (nonatomic, strong) Room *room;
@property (nonatomic, strong) NSString *dollarSign;
@property (nonatomic) UIRefreshControl *refreshControl;

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
        
        if ([self.mapView.annotations isKindOfClass:[MKUserLocation class]]) {
            for (Room *room in self.mapView.annotations){
                [roomObjectIDSet addObject:room.objectId ];
                //NSLog(@"%@",roomObjectIDSet);
        }
       
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
    
    [self.mapView setHidden:YES];
    
    [[RoomiesLocationManager sharedManager] addDelegateObserver:self];
    
    if ([[[RoomiesLocationManager sharedManager] locationManager] respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [[[RoomiesLocationManager sharedManager] locationManager] requestWhenInUseAuthorization];
    }
    
    [self.tableView addSubview:self.refreshControl];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor purpleColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(updateRooms)
                  forControlEvents:UIControlEventValueChanged];
    [self.refreshControl endRefreshing];
    
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)dealloc {
    [[RoomiesLocationManager sharedManager] removeDelegateObserver:self];
}

-(void)updateRooms {
    [self.tableView reloadData];
    
}

-(void)initiateMap {
    
    CLLocationCoordinate2D zoomLocation = CLLocationCoordinate2DMake(49.28, -123.12);
    
    MKCoordinateRegion adjustedRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, zoomingMapArea, zoomingMapArea);
    
    [_mapView setRegion:adjustedRegion animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.roomsArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // NSLog(@"%@",self.roomsArray);
    //    NSArray *reversedArray = [[self.roomsArray reverseObjectEnumerator] allObjects];
    // NSLog(@"%@", reversedArray);
    
    
    RoomCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath ];
    cell.roomDescriptionLabel.text = @"";
    cell.roomImageView.image = nil;
    cell.roomPriceLabel.text = @"";
    
    
    Room *individual = self.roomsArray[indexPath.row];
    //NSLog(@"\nroom: %@  \nimage:  %@", individual.roomTitle, individual.roomImage);
    cell.roomImageView.file = [individual objectForKey:@"roomImage"];
    [cell.roomImageView addSubview:cell.roomPriceLabel];
    
    cell.roomPriceLabel.text = [self.dollarSign stringByAppendingString:individual.price];
    cell.roomDescriptionLabel.text = [individual objectForKey:@"roomTitle"];
    if (!cell.roomImageView.image) {
        cell.roomImageView.alpha = 0;
        
        /**
         -loadInBackground is an asynchronous operation:
         By the time the operation finishes, 'cell' might be in use by another indexPath.
         You should make sure to get the right cell for a given indexPath.
         */
        [cell.roomImageView loadInBackground:^(UIImage * _Nullable image, NSError * _Nullable error) {
            RoomCustomTableViewCell * aCell = [tableView cellForRowAtIndexPath:indexPath];
            if (aCell) {
                aCell.roomImageView.image = image;
                [UIView animateWithDuration:0.3 animations:^{
                    aCell.roomImageView.alpha = 1;
                }];
            }
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
    
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        return nil;
    }
    
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

#pragma mark - @protocol <CLLocationManagerDelegate>

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        self.mapView.showsUserLocation = YES;
    }
}

@end
