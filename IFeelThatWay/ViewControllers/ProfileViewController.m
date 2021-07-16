//
//  ProfileViewController.m
//  IFeelThatWay
//
//  Created by Jacqueline DiMonte on 7/12/21.
//

#import "ProfileViewController.h"
#import "LoginViewController.h"
#import "User.h"
#import <Parse/Parse.h>

@interface ProfileViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *profilePicture;
@property (strong, nonatomic) IBOutlet User *user;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.user = [PFUser currentUser];
    NSString *colorSelected = self.user[@"profilePicture"];
    if(!colorSelected){
        colorSelected = @"red";
    }
    UIImage * colorPicture = [UIImage imageNamed:colorSelected];
    [self.profilePicture setImage:colorPicture];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe)];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:swipeRight];
}

- (void)handleSwipe {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)backTapped:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)logoutTapped:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [[UIApplication sharedApplication].keyWindow setRootViewController:loginViewController];
    
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
    }];
}

- (void) updateProfilePicture: (NSString *)color {
    UIImage * colorPicture = [UIImage imageNamed:color];
    [self.profilePicture setImage:colorPicture];
    self.user[@"profilePicture"] = color;
    [self.user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error != nil) {
            NSLog(@"fail");
        } else {
            NSLog(@"success");
        }
    }];
}

- (IBAction)redTapped:(id)sender {
    [self updateProfilePicture:@"red"];
}
- (IBAction)pinkTapped:(id)sender {
    [self updateProfilePicture:@"pink"];
}
- (IBAction)orangeTapped:(id)sender {
    [self updateProfilePicture:@"orange"];
}
- (IBAction)yellowTapped:(id)sender {
    [self updateProfilePicture:@"yellow"];
}
- (IBAction)greenTapped:(id)sender {
    [self updateProfilePicture:@"green"];
}
- (IBAction)lightBlueTapped:(id)sender {
    [self updateProfilePicture:@"lightblue"];
}
- (IBAction)blueTapped:(id)sender {
    [self updateProfilePicture:@"blue"];
}
- (IBAction)purpleTapped:(id)sender {
    [self updateProfilePicture:@"purple"];
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
