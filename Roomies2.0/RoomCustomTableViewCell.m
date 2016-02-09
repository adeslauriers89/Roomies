//
//  CustomTableViewCell.m
//  Roomies2.0
//
//  Created by Adam DesLauriers on 2016-02-08.
//  Copyright © 2016 Adam DesLauriers & Thiago Heitling. All rights reserved.
//

#import "RoomCustomTableViewCell.h"

@interface RoomCustomTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *roomImageView;
@property (weak, nonatomic) IBOutlet UILabel *roomPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *roomDescriptionLabel;


@end

@implementation RoomCustomTableViewCell : UITableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
