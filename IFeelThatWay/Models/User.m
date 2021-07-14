//
//  User.m
//  IFeelThatWay
//
//  Created by Jacqueline DiMonte on 7/12/21.
//

#import "User.h"

@implementation User

@dynamic objectId;
@dynamic username;
@dynamic email;
@dynamic profilePicture;
@dynamic createdAt;

+ (nonnull NSString *)parseClassName {
    return @"User";
}

@end
