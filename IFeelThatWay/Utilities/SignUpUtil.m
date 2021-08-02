//
//  SignUpUtil.m
//  IFeelThatWay
//
//  Created by Jacqueline DiMonte on 7/15/21.
//

#import "SignUpUtil.h"
#import "SignUpViewController.h"
#import <SCLAlertView.h>

@implementation SignUpUtil

+ (void)registerUser:(PFUser*)user :(UIViewController*)currentViewController{
    if([user.username isEqual: @""] || [user.password isEqual: @""]){
        SCLAlertView *alert = [[SCLAlertView alloc] init];
        [alert showError:currentViewController title:@"Error" subTitle:@"Please enter required information." closeButtonTitle:@"OK" duration:0.0f];
    }
    else{
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
            if (error != nil) {
                NSLog(@"Error: %@", error.localizedDescription);
                
                SCLAlertView *alert = [[SCLAlertView alloc] init];
                [alert showError:currentViewController title:@"Error" subTitle:@"The username you have entered is already taken." closeButtonTitle:@"OK" duration:0.0f];
            } else {
                [currentViewController performSegueWithIdentifier:@"signUp" sender:nil];
            }
        }];
    }
}

@end
