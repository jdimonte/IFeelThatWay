//
//  AuthDelegate.h
//  IFeelThatWay
//
//  Created by Jacqueline DiMonte on 7/30/21.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

NS_ASSUME_NONNULL_BEGIN

@interface AuthDelegate : NSObject<PFUserAuthenticationDelegate>

- (bool) restoreAuthenticationWithAuthData;

@end

NS_ASSUME_NONNULL_END
