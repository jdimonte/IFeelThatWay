//
//  TopViewController.h
//  IFeelThatWay
//
//  Created by Jacqueline DiMonte on 7/12/21.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TopViewController : UIViewController

@property (strong, nonatomic) LoginViewController *loginViewController;

- (void)setLoginViewController:(LoginViewController*)loginViewController;

@end

NS_ASSUME_NONNULL_END
