//
//  CustomTableViewCell.h
//  Roomies2.0
//
//  Created by Adam DesLauriers on 2016-02-08.
//  Copyright © 2016 Adam DesLauriers & Thiago Heitling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI/ParseUI.h>

@interface RoomCustomTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet PFImageView *roomImageView;
@property (weak, nonatomic) IBOutlet UILabel *roomPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *roomDescriptionLabel;

@end
