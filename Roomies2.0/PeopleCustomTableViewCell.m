//
//  PeopleCustomTableViewCell.m
//  Roomies2.0
//
//  Created by Adam DesLauriers on 2016-02-08.
//  Copyright © 2016 Adam DesLauriers & Thiago Heitling. All rights reserved.
//

#import "PeopleCustomTableViewCell.h"

@interface PeopleCustomTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *peopleImageView;
@property (weak, nonatomic) IBOutlet UILabel *personNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *personLookingForLabel;

@end

@implementation PeopleCustomTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
