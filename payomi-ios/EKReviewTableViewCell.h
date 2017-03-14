//
//  EKReviewTableViewCell.h
//  payomi-ios
//
//  Created by Elie El Khoury on 11/5/16.
//  Copyright © 2016 Elie El Khoury. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EKReviewTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *cellProfileImageView;
@property (strong, nonatomic) IBOutlet UIImageView *cellEditableImageView;
@property (strong, nonatomic) IBOutlet UILabel *cellNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *cellReviewLabel;

@end
