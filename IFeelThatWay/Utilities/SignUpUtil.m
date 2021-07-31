//
//  SignUpUtil.m
//  IFeelThatWay
//
//  Created by Jacqueline DiMonte on 7/15/21.
//

#import "SignUpUtil.h"
#import "SignUpViewController.h"

@implementation SignUpUtil

+ (void)registerUser:(PFUser*)user :(UIViewController*)currentViewController{
    if([user.username isEqual: @""] || [user.password isEqual: @""]){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"noText" message:@"Input Text" preferredStyle:(UIAlertControllerStyleAlert)];
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
    }
    else{
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
            if (error != nil) {
                NSLog(@"Error: %@", error.localizedDescription);
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Try Again" preferredStyle:(UIAlertControllerStyleAlert)];
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
                [currentViewController performSegueWithIdentifier:@"signUp" sender:nil];
            }
        }];
    }
}

@end
