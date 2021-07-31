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

@implementation LoginUtil

+ (void)loginUser:(User *)user :(UIViewController *)currentViewController{
    NSString *username = user.username;
    NSString *password = user.password;
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            NSLog(@"User log in failed: %@", error.localizedDescription);
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Wrong username or password" message:@"Try Again" preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                                style:UIAlertActionStyleCancel
                                                              handler:^(UIAlertAction * _Nonnull action) {
                                                              }];
            [alert addAction:cancelAction];

            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * _Nonnull action) {
    
                                                             }];
            [alert addAction:okAction];
            
            [currentViewController presentViewController:alert animated:YES completion:^{
            }];
        } else {
            [currentViewController performSegueWithIdentifier:@"login" sender:nil];
        }
    }];
}

@end
