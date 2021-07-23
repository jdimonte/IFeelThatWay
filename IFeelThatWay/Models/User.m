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
@dynamic password;
@dynamic email;
@dynamic profilePicture;
@dynamic createdAt;
@dynamic withGoogle;

+ (nonnull NSString *)parseClassName {
    return @"User";
}

@end
