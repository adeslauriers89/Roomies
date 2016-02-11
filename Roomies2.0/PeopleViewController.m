//
//  PeopleViewController.m
//  Roomies2.0
//
//  Created by Adam DesLauriers on 2016-02-08.
//  Copyright © 2016 Adam DesLauriers & Thiago Heitling. All rights reserved.
//

#import "PeopleViewController.h"
#import <Parse/Parse.h>
#import "PeopleCustomTableViewCell.h"
#import "DetailPeopleViewController.h"

@interface PeopleViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *peopleArray;

@end

@implementation PeopleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    PFQuery *query = [PFUser query];
    [query findObjectsInBackgroundWithBlock:^(NSArray *  objects, NSError *  error) {
        
        if (!error) {
            self.peopleArray  = [objects mutableCopy];
            [self.tableView reloadData];
        } else {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:[error userInfo][@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
        
      
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return self.peopleArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PeopleCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath ];
    PFUser *individual = self.peopleArray[indexPath.row];

    
    cell.personNameLabel.text = individual[@"fullName"];
    cell.personLookingForLabel.text = individual[@"userDetails"];
    PFFile *img = [individual objectForKey:@"userImage"];
    [img getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (data) {
            UIImage *userImage = [UIImage imageWithData:data];
            cell.peopleImageView.image = userImage;
        }
    }];
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"showPersonDVC"]) {
        DetailPeopleViewController *dvc = [segue destinationViewController];
        NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
        PFUser *individual = self.peopleArray[indexPath.row];
        dvc.user = individual;
        
    }
}

@end
