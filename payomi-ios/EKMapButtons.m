//
//  EKMapButtons.m
//  payomi-ios
//
//  Created by Elie El Khoury on 11/16/16.
//  Copyright © 2016 Elie El Khoury. All rights reserved.
//

#import "EKMapButtons.h"

@implementation EKMapButtons

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self materialDropShadow];
}

- (void)materialDropShadow {
    
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.3;
    self.layer.shadowRadius = 1;
    self.layer.shadowOffset = CGSizeMake(0, 3.0f);
}

@end
