//
//  LoginViewController.m
//  IFeelThatWay
//
//  Created by Jacqueline DiMonte on 7/12/21.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>
#import "LoginUtil.h"
#import <QuartzCore/QuartzCore.h>
#import <GoogleSignIn.h>
#import "SignUpUtil.h"

@interface LoginViewController ()
@property (strong, nonatomic) IBOutlet UITextField *username;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.loginButton.layer.cornerRadius = 0.2 * self.loginButton.bounds.size.width;
}

- (IBAction)loginTapped:(id)sender {
    User *currentUser = [User new];
    currentUser.username = self.username.text;
    currentUser.password = self.password.text;
    [LoginUtil loginUser:currentUser:self];
}

- (IBAction)screenTapped:(id)sender {
    [self.view endEditing:true];
}

- (IBAction)loginWithGoogleTapped:(id)sender {
    GIDConfiguration *signInConfig = [[GIDConfiguration alloc] initWithClientID:@"199283860183-otfaodus4qg8g974rtpd6tdqd5i11ca0.apps.googleusercontent.com"];
    [GIDSignIn.sharedInstance signInWithConfiguration:signInConfig
                               presentingViewController:self
                                               callback:^(GIDGoogleUser * _Nullable user,
                                                          NSError * _Nullable error) {
        if (error) {
          return;
        }
        // If sign in succeeded, display the app's main content View.
        //check for user in parse
//        PFQuery *query = [PFQuery queryWithClassName:@"User"];
//        [query includeKey:@"author"];
//        [query whereKey:@"withGoogle" equalTo:TRUE];
//        [query whereKey:@"email" equalTo:user.profile.email];
//        query.limit = 1;
//        [query findObjectsInBackgroundWithBlock:^(NSArray *users, NSError *error) {
//            if (users != nil && users.count != 0) {
//                //yes the user exists in parse
//                //sign in
//                User *currentUser = [User new];
//                currentUser.email = user.profile.email;
//                [LoginUtil loginUserWithGoogle:currentUser:self];
//            } else {
//                //no the user does not exist in parse
//                //register
//                PFUser *newUser = [PFUser user];
//                newUser.email = user.profile.email;
//                newUser.withGoogle = TRUE;
//                [SignUpUtil registerUserWithGoogle:newUser:self];
//            }
//        }];
        
      }];
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
