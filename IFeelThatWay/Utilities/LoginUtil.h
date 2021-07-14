//
//  LoginUtil.h
//  IFeelThatWay
//
//  Created by Jacqueline DiMonte on 7/14/21.
//

#import <Foundation/Foundation.h>
#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface LoginUtil : NSObject

+ (void)loginUser:(User*)user:(UIViewController*)currentViewController;

@end



NS_ASSUME_NONNULL_END
