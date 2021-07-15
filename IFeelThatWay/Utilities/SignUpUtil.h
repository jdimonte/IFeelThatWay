//
//  SignUpUtil.h
//  IFeelThatWay
//
//  Created by Jacqueline DiMonte on 7/15/21.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface SignUpUtil : NSObject

+ (void)registerUser:(PFUser*)user: (UIViewController*)currentViewController;

@end

NS_ASSUME_NONNULL_END
