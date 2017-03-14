//
//  EKLoginViewController.m
//  payomi-ios
//
//  Created by Elie El Khoury on 1/10/17.
//  Copyright © 2017 Elie El Khoury. All rights reserved.
//

#import "EKLoginViewController.h"

@interface EKLoginViewController ()
@property (strong, nonatomic) IBOutlet FBSDKProfilePictureView *profileView;

@end

@implementation EKLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Add a custom login button to your app
    UIButton *myLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    myLoginButton.backgroundColor = [UIColor darkGrayColor];
    myLoginButton.frame = CGRectMake(0,0,180,40);
    myLoginButton.center = self.view.center;
    
    if ([FBSDKAccessToken currentAccessToken]) {

        self.profileView = [[FBSDKProfilePictureView alloc] init];
        [self.profileView setProfileID:@"me"];
        
        [myLoginButton setTitle: @"Logout" forState: UIControlStateNormal];
    } else {
        [myLoginButton setTitle: @"Login" forState: UIControlStateNormal];
    }
    
    // Handle clicks on the button
    [myLoginButton addTarget:self action:@selector(loginButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    // Add the button to the view
    [self.view addSubview:myLoginButton];
}

// Once the button is clicked, show the login dialog
- (void)loginButtonClicked {
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    
    if ([FBSDKAccessToken currentAccessToken]) {
        
        [login logOut];
        
    } else {
        
        [login logInWithReadPermissions:@[@"public_profile", @"email", @"user_friends"]
                     fromViewController:self
                                handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                    
                                    if (error) {
                                        NSLog(@"Process error");
                                    } else if (result.isCancelled) {
                                        NSLog(@"Cancelled");
                                    } else {
                                        NSLog(@"Logged in");
                                        NSLog(@"/n /n ~~~~~NAME: %@", [FBSDKProfile currentProfile].name);
                                        [self performSegueWithIdentifier:@"unwindSegue" sender:nil];
                                    }
                                }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
