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

#define zoomingMapArea 4000


@interface RoomsViewController () <UITableViewDataSource, MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *roomSegmentControl;
@property (nonatomic, strong) CLLocation *vancouverLocation;
@property (nonatomic, strong) NSMutableArray *roomsArray;



@end

@implementation RoomsViewController

- (void)viewWillAppear:(BOOL)animated {
    
    PFQuery *query = [PFQuery queryWithClassName:@"Room"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        self.roomsArray = [objects mutableCopy];
        [self.tableView reloadData];
        
    }];
}



- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self.mapView setHidden:YES];
    
    
}


//- (void)fetchSeafoodTypesWithCompletion:(void (^)(NSMutableArray *seafoodTypes))handler {
//    dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), ^{
//        PFQuery *typeQuery = [PFQuery queryWithClassName:@"Seafood_Type"];
//        NSArray *fetchedObjects = [typeQuery findObjects];
//        [self.seafoodTypes removeAllObjects];
//        for (PFObject *object in fetchedObjects) {
//            SKSeafoodType *seafoodType = [SKSeafoodType new];
//            seafoodType.name = object[@"Name"];
//            seafoodType.objectId = [object objectId];
//            seafoodType.unitType = [object[@"Unit_Type"] integerValue];
//            PFFile *imageFile = object[@"Category_Picture"];
//            seafoodType.image = [UIImage imageWithData:[imageFile getData]];
//            [self.seafoodTypes addObject:seafoodType];
//        }
//        dispatch_async(dispatch_get_main_queue(), ^{
//            handler(self.seafoodTypes);
//        });
//    });
//}

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


@end
