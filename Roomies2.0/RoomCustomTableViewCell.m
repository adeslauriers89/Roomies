//
//  CustomTableViewCell.m
//  Roomies2.0
//
//  Created by Adam DesLauriers on 2016-02-08.
//  Copyright © 2016 Adam DesLauriers & Thiago Heitling. All rights reserved.
//

#import "RoomCustomTableViewCell.h"
#import "Room.h"

@interface RoomCustomTableViewCell ()



@end

@implementation RoomCustomTableViewCell : UITableViewCell

- (void)awakeFromNib {

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

//-(void)configureWithRoom:(Room *)room {
//    
//    self.roomImageView.image = room.roomImage;
//    [self.roomImageView loadInBackground];
//    self.roomPriceLabel.text = room.price;
//    self.roomDescriptionLabel.text = room.roomTitle;
//}

@end
