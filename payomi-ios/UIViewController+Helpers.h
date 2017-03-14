//
//  UIViewController+Helpers.h
//  payomi-ios
//
//  Created by Elie El Khoury on 1/10/17.
//  Copyright © 2017 Elie El Khoury. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Helpers)

typedef void (^ActionSheetUnwindBlock)(UIAlertAction *action);

- (void)showMessage:(NSString *)bookingMessage withTitle:(NSString*)title completionBlock:(ActionSheetUnwindBlock)block;

@end
