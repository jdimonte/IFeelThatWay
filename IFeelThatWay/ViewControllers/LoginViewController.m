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
#import "AuthDelegate.h"

@interface LoginViewController () <PFUserAuthenticationDelegate>
@property (strong, nonatomic) IBOutlet UITextField *username;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;


@end

@implementation LoginViewController

- (BOOL)restoreAuthenticationWithAuthData:
(nullable NSDictionary<NSString *, NSString *> *)authData{
    return true;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.loginButton.layer.cornerRadius = 0.2 * self.loginButton.bounds.size.width;
    if(self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark){ //FIX
        self.username.layer.borderColor = [UIColor colorNamed:@"loginoutline"].CGColor;
        self.username.layer.borderWidth = 3.0f;
        self.username.layer.cornerRadius = 7.0f;
        self.password.layer.borderColor = [UIColor colorNamed:@"loginoutline"].CGColor;
        self.password.layer.borderWidth = 3.0f;
        self.password.layer.cornerRadius = 7.0f;
    }
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

        [PFUser registerAuthenticationDelegate:self
                                   forAuthType:@"google"];
        //update access token
        [[PFUser logInWithAuthTypeInBackground:@"google"
                                      authData:@{@"id": user.userID, @"access_token": user.authentication.accessToken}] continueWithSuccessBlock:^id(BFTask *task) {

                return nil;
            }];
        
        [self performSegueWithIdentifier:@"login" sender:nil];
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
