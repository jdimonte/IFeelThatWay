//
//  LoginUtil.m
//  IFeelThatWay
//
//  Created by Jacqueline DiMonte on 7/14/21.
//

#import "LoginUtil.h"
#import "LoginViewController.h"
#import <Parse/Parse.h>
#import <UIKit/UIKit.h>
#import <SCLAlertView.h>

@implementation LoginUtil

+ (void)loginUser:(User *)user :(UIViewController *)currentViewController{
    NSString *username = user.username;
    NSString *password = user.password;
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            NSLog(@"User log in failed: %@", error.localizedDescription);
            
            SCLAlertView *alert = [[SCLAlertView alloc] init];
            [alert showError:currentViewController title:@"Error" subTitle:@"The username or password is incorrect." closeButtonTitle:@"OK" duration:0.0f];

        } else {
            [currentViewController performSegueWithIdentifier:@"login" sender:nil];
        }
    }];
}

@end
