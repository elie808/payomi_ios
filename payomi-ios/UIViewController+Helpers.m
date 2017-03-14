//
//  UIViewController+Helpers.m
//  payomi-ios
//
//  Created by Elie El Khoury on 1/10/17.
//  Copyright © 2017 Elie El Khoury. All rights reserved.
//

#import "UIViewController+Helpers.h"

@implementation UIViewController (Helpers)

- (void)showMessage:(NSString *)bookingMessage withTitle:(NSString*)title completionBlock:(ActionSheetUnwindBlock)block {
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:title
                                                                         message:bookingMessage
                                                                  preferredStyle:UIAlertControllerStyleAlert];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        block(action);
    }]];
    
    [self presentViewController:actionSheet animated:YES completion:nil];
}


@end
