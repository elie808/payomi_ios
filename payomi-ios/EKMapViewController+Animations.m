//
//  EKMapViewController+Animations.m
//  payomi-ios
//
//  Created by Elie El Khoury on 11/6/16.
//  Copyright © 2016 Elie El Khoury. All rights reserved.
//

#import "EKMapViewController+Animations.h"

static CGFloat const kButtonOffset = 80.0;

static CGFloat const kAnimationDuration = 1.0;
static CGFloat const kDelay = 0.1;
static CGFloat const kDamping = 0.5;
static CGFloat const kVelocity = 0.6;

@implementation EKMapViewController (Animations)

- (void)hideButtons {
        
    [UIView animateWithDuration:kAnimationDuration
                          delay:0.0
         usingSpringWithDamping:kDamping
          initialSpringVelocity:kVelocity
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         [self buttonRightAnimation:self.filterMarkersButton];
                         [self buttonRightAnimation:self.searchLocationButton];
                     }
                     completion:nil];
}

- (void)showButtons {
    
    [UIView animateWithDuration:kAnimationDuration
                          delay:0.0
         usingSpringWithDamping:kDamping
          initialSpringVelocity:kVelocity
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         [self buttonLeftAnimation:self.searchLocationButton];
                         
                     }
                     completion:nil];
    
    [UIView animateWithDuration:kAnimationDuration
                          delay:kDelay
         usingSpringWithDamping:kDamping
          initialSpringVelocity:kVelocity
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         [self buttonLeftAnimation:self.filterMarkersButton];
                     }
                     completion:nil];
}

#pragma mark - Helpers
//TODO: Move to UIBUtton category

- (void)buttonUpAnimation:(UIButton*)button {
    
    button.frame = CGRectMake(button.frame.origin.x,
                              button.frame.origin.y-kButtonOffset,
                              button.frame.size.width,
                              button.frame.size.height);
}
    
- (void)buttonDownAnimation:(UIButton*)button {
    
    button.frame = CGRectMake(button.frame.origin.x,
                              button.frame.origin.y+kButtonOffset,
                              button.frame.size.width,
                              button.frame.size.height);
}
    
- (void)buttonLeftAnimation:(UIButton*)button {
    
    button.frame = CGRectMake(button.frame.origin.x-kButtonOffset,
                              button.frame.origin.y,
                              button.frame.size.width,
                              button.frame.size.height);
}

- (void)buttonRightAnimation:(UIButton*)button {

    button.frame = CGRectMake(button.frame.origin.x+kButtonOffset,
                              button.frame.origin.y,
                              button.frame.size.width,
                              button.frame.size.height);
}

@end
